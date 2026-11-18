import asyncio
import json
import re
from typing import Optional
from playwright.async_api import async_playwright


async def scrape_engineering_schools_websites(output_file_path: str = "french_engineering_schools_websites.json"):
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 1280, "height": 800},
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        )
        page = await context.new_page()

        # Step 1: Scrape the main Wikipedia page for French engineering schools
        main_url = "https://fr.wikipedia.org/wiki/%C3%89cole_d'ing%C3%A9nieurs_en_France"
        print(f"Loading main page: {main_url}")
        
        try:
            await page.goto(main_url, timeout=30000, wait_until="networkidle")
        except Exception as e:
            print(f"Failed to load main Wikipedia page: {e}")
            await browser.close()
            return

        table_exists = await page.evaluate("""
            () => {
                const table = document.querySelector('table.wikitable, table#mwQQ, table');
                return table !== null;
            }
        """)

        if not table_exists:
            print("Error: The target table was not found on the page.")
            await browser.close()
            return
        
        print("Table found! Extracting university links from the 3rd column...")

        # debug_data = await page.evaluate("""
        #     () => {
        #         const results = [];
        #         const logs = [];
                
        #         const rows = document.querySelectorAll('table.wikitable tbody tr, table tr');
        #         logs.push(`Total table rows found: ${rows.length}`);
                
        #         let passed_cols = 0;
        #         let no_link = 0;
        #         let bad_start = 0;
        #         let has_colon = 0;
                
        #         rows.forEach((row, index) => {
        #             const tds = row.querySelectorAll('td');
        #             if (tds.length >= 3) {
        #                 passed_cols++;
        #                 const thirdTd = tds[2];
        #                 const link = thirdTd.querySelector('a');
                        
        #                 if (link) {
        #                     const href = link.getAttribute('href');
        #                     const text = link.innerText.trim();
                            
        #                     if (href && href.startsWith('/wiki/')) {
        #                         const wikiPart = href.replace('/wiki/', '');
        #                         if (!wikiPart.includes(':') && !wikiPart.includes('#')) {
        #                             const fullUrl = 'https://fr.wikipedia.org' + href;
        #                             if (!results.some(item => item.wiki_url === fullUrl)) {
        #                                 results.push({
        #                                     title: text,
        #                                     wiki_url: fullUrl
        #                                 });
        #                             }
        #                         } else {
        #                             has_colon++;
        #                             if (has_colon <= 5) {
        #                                 logs.push(`Row ${index}: rejected (colon/hash) -> href: '${href}'`);
        #                             }
        #                         }
        #                     } else {
        #                         bad_start++;
        #                         if (bad_start <= 5) {
        #                             logs.push(`Row ${index}: rejected (doesn't start with /wiki/) -> href: '${href}'`);
        #                         }
        #                     }
        #                 } else {
        #                     no_link++;
        #                     if (no_link <= 5) {
        #                         logs.push(`Row ${index}: no <a> tag found in 3rd td. Text was: '${thirdTd.innerText.trim()}'`);
        #                     }
        #                 }
        #             }
        #         });
                
        #         logs.push(`Summary -> Rows with >= 3 columns: ${passed_cols}`);
        #         logs.push(`Summary -> Missing <a> tag in 3rd td: ${no_link}`);
        #         logs.push(`Summary -> Href doesn't start with /wiki/: ${bad_start}`);
        #         logs.push(`Summary -> Contains colon/hash: ${has_colon}`);
                
        #         return { results, logs };
        #     }
        # """)

        # # Print the diagnostic logs to your terminal
        # print("\n--- Scraping Diagnostic Logs ---")
        # for log in debug_data["logs"]:
        #     print(f"  {log}")
        # print("--------------------------------")

        # schools = debug_data["results"]

        # Step 1: Extract links correctly handling absolute URLs
        schools = await page.evaluate("""
            () => {
                const results = [];
                const rows = document.querySelectorAll('table.wikitable tbody tr, table tr');
                
                rows.forEach(row => {
                    const tds = row.querySelectorAll('td');
                    if (tds.length >= 3) {
                        const thirdTd = tds[2];
                        const link = thirdTd.querySelector('a');
                        
                        if (link) {
                            const href = link.getAttribute('href');
                            const text = link.innerText.trim();
                            
                            if (href && href.includes('/wiki/')) {
                                // Extract the part after '/wiki/'
                                const parts = href.split('/wiki/');
                                const wikiPart = parts[parts.length - 1];
                                
                                // Ensure it's not a special system page or anchor
                                if (wikiPart && !wikiPart.includes(':') && !wikiPart.includes('#')) {
                                    // Ensure it's a full URL
                                    const fullUrl = href.startsWith('http') ? href : 'https://fr.wikipedia.org' + href;
                                    
                                    if (!results.some(item => item.wiki_url === fullUrl)) {
                                        results.push({
                                            title: text,
                                            wiki_url: fullUrl
                                        });
                                    }
                                }
                            }
                        }
                    }
                });
                
                return results;
            }
        """)

        print(f"Successfully extracted {len(schools)} school links.")

        if len(schools) == 0:
            print("Error: Still found 0 links. The page structure might require manual inspection or debugging.")
            await browser.close()
            return

        detailed_results = []
        missing_websites = []

        # Step 2: Visit each school's Wikipedia page to extract its official website from the infobox
        for idx, school in enumerate(schools, 1):
            title = school["title"]
            wiki_url = school["wiki_url"]
            print(f"[{idx}/{len(schools)}] Processing '{title}'...")

            entry_copy = school.copy()

            try:
                response = await page.goto(wiki_url, timeout=15000, wait_until="domcontentloaded")
                if response is None or response.status >= 400:
                    print(f" -> Page not found for {title}")
                    entry_copy["website"] = None
                    missing_websites.append(title)
                    detailed_results.append(entry_copy)
                    continue

                # Wait for the infobox to render if present
                try:
                    await page.wait_for_selector(".infobox, .infobox_v2", timeout=3000)
                except Exception:
                    pass

                # Extract official website from the Wikipedia infobox
                website = await page.evaluate("""
                    () => {
                        const infobox = document.querySelector('.infobox, .infobox_v2');
                        if (!infobox) return null;

                        // Look for table rows containing 'Site web' or 'Site officiel'
                        const rows = infobox.querySelectorAll('tr');
                        for (let row of rows) {
                            const th = row.querySelector('th');
                            if (th && (th.innerText.toLowerCase().includes('site web') || th.innerText.toLowerCase().includes('site officiel'))) {
                                const a = row.querySelector('a.external');
                                if (a) return a.href;
                            }
                        }

                        // Fallback: search for any external link in the infobox (excluding Wikimedia/Wikidata/Wikipedia)
                        const externalLinks = infobox.querySelectorAll('a.external');
                        for (let a of externalLinks) {
                            const href = a.href;
                            if (href && !href.includes('wikidata.org') && !href.includes('wikipedia.org') && !href.includes('wikimedia.org')) {
                                return href;
                            }
                        }

                        return null;
                    }
                """)

                if website:
                    print(f" -> Found website: {website}")
                    entry_copy["website"] = website
                else:
                    print(f" -> No website found in infobox for {title}")
                    entry_copy["website"] = None
                    missing_websites.append(title)

            except Exception as e:
                print(f" -> Error processing {title}: {e}")
                entry_copy["website"] = None
                missing_websites.append(title)

            detailed_results.append(entry_copy)
            
            # Brief pause to be respectful to Wikipedia's servers
            await asyncio.sleep(0.3)

        await browser.close()

        # Save output JSON data
        with open(output_file_path, "w", encoding="utf-8") as f:
            json.dump(detailed_results, f, indent=4, ensure_ascii=False)

        print(f"\nScraping complete. Output saved to {output_file_path}")
        print(f"Total schools processed: {len(detailed_results)}")
        print(f"Schools without a detected website: {len(missing_websites)}")


if __name__ == "__main__":
    asyncio.run(scrape_engineering_schools_websites())