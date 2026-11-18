import asyncio
import json
import re
from typing import Optional
from playwright.async_api import async_playwright


def format_title_to_slug(title: str) -> str:
    """Converts university title to URL slug format."""
    slug = title.lower()
    # Replace ampersands (with or without surrounding spaces) with a hyphen
    slug = re.sub(r"\s*&\s*", "-", slug)
    # Remove remaining punctuation
    slug = re.sub(r"[,'.()]+", "", slug)
    # Replace multiple spaces or hyphens with a single hyphen
    slug = re.sub(r"[\s-]+", "-", slug)
    return slug.strip("-")


async def scrape_university_websites(
    input_file_path: str,
    output_file_path: str,
    start: Optional[int] = None,
    end: Optional[int] = None,
):
    with open(input_file_path, "r", encoding="utf-8") as f:
        universities = json.load(f)

    start_idx = (start - 1) if start is not None and start > 0 else 0
    end_idx = end if end is not None else len(universities)
    target_universities = universities[start_idx:end_idx]

    results = []
    missing_ids = []

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 1280, "height": 800},
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        )
        page = await context.new_page()

        for entry in target_universities:
            univ_id = entry.get("id")
            title = entry.get("title", "")
            print(f"[ID {univ_id}] Processing '{title}'...")

            entry_copy = entry.copy()
            slug = format_title_to_slug(title)
            url = f"https://www.shanghairanking.com/universities/{slug}"

            try:
                response = await page.goto(
                    url, timeout=20000, wait_until="domcontentloaded"
                )

                if response is None or response.status >= 400 or "404" in page.url:
                    print(f" -> Page not found for id {univ_id}")
                    missing_ids.append(univ_id)
                    entry_copy["website"] = None
                    results.append(entry_copy)
                    continue

                # Extract the official university website link inside page evaluation
                website_url = await page.evaluate(
                    """
                    () => {
                        const anchors = Array.from(document.querySelectorAll('a[href]'));
                        
                        for (const a of anchors) {
                            const href = a.href.trim();
                            
                            // Check if the link starts with http(s) and excludes shanghairanking domains (.com and .cn)
                            if (href.startsWith('http') && 
                                !href.includes('shanghairanking.com') && 
                                !href.includes('shanghairanking.cn')) {
                                
                                // Filter out common social networks
                                const isSocial = /facebook|twitter|linkedin|youtube|instagram|wikipedia/i.test(href);
                                if (!isSocial) {
                                    return href;
                                }
                            }
                        }
                        return null;
                    }
                """
                )

                entry_copy["website"] = website_url
                print(f" -> Found website: {website_url}")

            except Exception as e:
                print(f" -> Error processing id {univ_id}: {e}")
                missing_ids.append(univ_id)
                entry_copy["website"] = None

            results.append(entry_copy)

        await browser.close()

    with open(output_file_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=4, ensure_ascii=False)

    print(f"\nScraping complete. Output saved to {output_file_path}")
    print(f"IDs with errors or missing pages: {missing_ids}")


if __name__ == "__main__":
    asyncio.run(
        scrape_university_websites(
            input_file_path="universities.json",
            output_file_path="universities_with_websites.json",
            start=1,
            end=1000,
        )
    )