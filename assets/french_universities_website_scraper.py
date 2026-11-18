import asyncio
import json
from typing import Optional
from playwright.async_api import async_playwright


async def scrape_all_universities_websites(
    output_file_path: str = "universities_with_websites.json",
    start: Optional[int] = None,
    end: Optional[int] = None,
):
    """Scrapes the main service-public directory page to find all university links,

    visits each university page to extract its official website, and outputs a JSON file.
    """
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 1280, "height": 800},
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        )
        page = await context.new_page()

        # Step 1: Load the main directory page
        main_url = "https://lannuaire.service-public.gouv.fr/gouvernement/1f4f4751-162b-4aa8-8e46-189b9b28d14a"
        print(f"Loading main directory page: {main_url}")

        try:
            await page.goto(main_url, timeout=30000, wait_until="domcontentloaded")
        except Exception as e:
            print(f"Failed to load main directory page: {e}")
            await browser.close()
            return

        # Extract university links and titles from the <ul> list elements on the page
        universities = await page.evaluate(
            """
            () => {
                const results = [];
                // Look for anchor tags within list elements or general links pointing to government directory pages
                const links = document.querySelectorAll('ul a');
                
                links.forEach((link) => {
                    const href = link.href;
                    const text = link.innerText.trim();
                    
                    if (href && text && href.includes('/gouvernement/')) {
                        // Avoid duplicate entries
                        if (!results.some(item => item.url === href)) {
                            results.push({
                                id: href.split('/').pop(),
                                title: text,
                                url: href
                            });
                        }
                    }
                });
                return results;
            }
        """
        )

        print(f"Successfully extracted {len(universities)} universities from the main page.")

        if len(universities) == 0:
            print("Error: No universities found. The page structure might have changed.")
            await browser.close()
            return

        # Handle optional slicing (start/end)
        start_idx = (start - 1) if start is not None and start > 0 else 0
        end_idx = end if end is not None else len(universities)
        target_universities = universities[start_idx:end_idx]

        print(f"Processing range: {start_idx + 1} to {end_idx}...")

        detailed_results = []
        failed_items = []

        # Step 2: Visit each university's individual page to scrape its website URL
        for idx, entry in enumerate(target_universities, 1):
            univ_id = entry.get("id")
            title = entry.get("title")
            detail_url = entry.get("url")

            print(f"[{idx}/{len(target_universities)}] Processing '{title}'...")

            entry_copy = entry.copy()

            try:
                response = await page.goto(
                    detail_url, timeout=20000, wait_until="domcontentloaded"
                )
                if response is None or response.status >= 400 or "404" in page.url:
                    print(f" -> Page not found for {title}")
                    entry_copy["website"] = None
                    failed_items.append(title)
                    detailed_results.append(entry_copy)
                    continue

                # Extract the official website URL using browser page evaluation
                website = await page.evaluate(
                    """
                    () => {
                        // Look for elements containing "Site web"
                        const elements = Array.from(document.querySelectorAll('span, p, strong, a, dt, li'));
                        
                        for (const el of elements) {
                            if (el.textContent && el.textContent.trim().toLowerCase().includes('site web')) {
                                const link = el.tagName === 'A' ? el : el.querySelector('a') || el.closest('p, div, li, dl')?.querySelector('a') || el.parentElement?.querySelector('a');
                                if (link && link.href) {
                                    if (!link.href.includes('service-public.fr')) {
                                        return link.href;
                                    }
                                }
                            }
                        }
                        
                        // Fallback: search for clean external links
                        const externalLinks = Array.from(document.querySelectorAll('a[href^="http"]'));
                        for (const l of externalLinks) {
                            const href = l.href;
                            if (!href.includes('service-public.fr') && !href.includes('legifrance.gouv.fr') && !href.includes('gouvernement.fr')) {
                                if (l.textContent.includes('http') || l.textContent.includes('www') || l.classList.contains('external')) {
                                    return href;
                                }
                            }
                        }
                        
                        return null;
                    }
                """
                )

                if website:
                    print(f" -> Found website: {website}")
                    entry_copy["website"] = website
                else:
                    print(f" -> No website found for {title}")
                    entry_copy["website"] = None
                    failed_items.append(title)

            except Exception as e:
                print(f" -> Error processing {title}: {e}")
                entry_copy["website"] = None
                failed_items.append(title)

            detailed_results.append(entry_copy)
            # Polite pause between target page requests
            await asyncio.sleep(0.3)

        await browser.close()

        # Save output JSON data
        with open(output_file_path, "w", encoding="utf-8") as f:
            json.dump(detailed_results, f, indent=4, ensure_ascii=False)

        print(f"\nScraping complete. Output saved to {output_file_path}")
        print(f"Total processed: {len(detailed_results)}")
        print(f"Entries without a detected website: {len(failed_items)}")


if __name__ == "__main__":
    asyncio.run(
        scrape_all_universities_websites(
            output_file_path="universities_with_websites.json",
            start=1,
            end=100,  # Adjust or set to None to process all
        )
    )