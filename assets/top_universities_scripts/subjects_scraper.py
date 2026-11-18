import asyncio
import json
import re
from typing import Optional
from playwright.async_api import async_playwright


def format_title_to_slug(title: str) -> str:
    """Converts university title to URL slug format."""
    slug = title.lower()
    slug = re.sub(r"[,'.()]+", "", slug)
    slug = re.sub(r"[\s-]+", "-", slug)
    return slug.strip("-")


async def scrape_university_subjects(
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
                    print(f"page not found for id {univ_id}")
                    missing_ids.append(univ_id)
                    entry_copy["subjects"] = []
                    results.append(entry_copy)
                    continue

                # Wait specifically for the subjects table element to load in the DOM
                try:
                    await page.wait_for_selector("table", timeout=8000)
                except Exception:
                    # If no table exists on the page
                    print(f"page not found for id {univ_id}")
                    missing_ids.append(univ_id)
                    entry_copy["subjects"] = []
                    results.append(entry_copy)
                    continue

                # Extract subject names from table rows/cells using browser JS evaluation
                subjects = await page.evaluate(
                    """
                    () => {
                        const table = document.querySelector('table');
                        if (!table) return [];
                        
                        const rows = table.querySelectorAll('tr');
                        const extracted = [];
                        
                        rows.forEach(row => {
                            // Find cells containing subject text (excluding table headers)
                            const cells = row.querySelectorAll('td');
                            if (cells.length > 0) {
                                // Subject name is typically in the first or second column
                                const subjectText = cells[0].innerText.strip ? cells[0].innerText.strip() : cells[0].innerText.trim();
                                if (subjectText) {
                                    extracted.push(subjectText);
                                }
                            }
                        });
                        return extracted;
                    }
                """
                )

                # Clean up any extraneous whitespace or rank numbers
                clean_subjects = [
                    re.sub(r"^\d+\s*", "", s).strip() for s in subjects if s
                ]
                unique_subjects = list(dict.fromkeys(clean_subjects))

                if not unique_subjects:
                    print(f"page not found for id {univ_id}")
                    missing_ids.append(univ_id)
                    entry_copy["subjects"] = []
                else:
                    print(
                        f" -> Extracted {len(unique_subjects)} subjects for id {univ_id}"
                    )
                    entry_copy["subjects"] = unique_subjects

            except Exception:
                print(f"page not found for id {univ_id}")
                missing_ids.append(univ_id)
                entry_copy["subjects"] = []

            results.append(entry_copy)

        await browser.close()

    # Save output JSON data to file
    with open(output_file_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=4, ensure_ascii=False)

    print(f"\nScraping complete. Output saved to {output_file_path}")
    print(f"IDs for which page was not found: {missing_ids}")


if __name__ == "__main__":
    asyncio.run(
        scrape_university_subjects(
            input_file_path="universities.json",
            output_file_path="universities_with_subjects.json",
            start=1,
            end=1000,
        )
    )