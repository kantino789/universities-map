import asyncio
import json
import re
from playwright.async_api import async_playwright


async def scrape_single_university(json_entry_str: str, url: str):
    # Parse the input JSON string into a dictionary
    try:
        entry = json.loads(json_entry_str)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON string provided: {e}")
        return

    univ_id = entry.get("id")

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 1280, "height": 800},
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        )
        page = await context.new_page()

        try:
            response = await page.goto(
                url, timeout=20000, wait_until="domcontentloaded"
            )

            if response is None or response.status >= 400 or "404" in page.url:
                print(f"page not found for id {univ_id}")
                entry["subjects"] = []
                print(json.dumps(entry, indent=4, ensure_ascii=False))
                await browser.close()
                return

            # Wait specifically for the subjects table element to load
            try:
                await page.wait_for_selector("table", timeout=8000)
            except Exception:
                print(f"page not found for id {univ_id}")
                entry["subjects"] = []
                print(json.dumps(entry, indent=4, ensure_ascii=False))
                await browser.close()
                return

            # Extract subject names directly from table rows
            subjects = await page.evaluate(
                """
                () => {
                    const table = document.querySelector('table');
                    if (!table) return [];
                    
                    const rows = table.querySelectorAll('tr');
                    const extracted = [];
                    
                    rows.forEach(row => {
                        const cells = row.querySelectorAll('td');
                        if (cells.length > 0) {
                            const subjectText = cells[0].innerText ? cells[0].innerText.trim() : '';
                            if (subjectText) {
                                extracted.push(subjectText);
                            }
                        }
                    });
                    return extracted;
                }
            """
            )

            # Clean extra whitespace or prefix numbers
            clean_subjects = [
                re.sub(r"^\d+\s*", "", s).strip() for s in subjects if s
            ]
            unique_subjects = list(dict.fromkeys(clean_subjects))

            if not unique_subjects:
                print(f"page not found for id {univ_id}")
                entry["subjects"] = []
            else:
                entry["subjects"] = unique_subjects

        except Exception:
            print(f"page not found for id {univ_id}")
            entry["subjects"] = []

        await browser.close()

    # Output the result directly to the console
    print(json.dumps(entry, indent=4, ensure_ascii=False))


# Example usage:
if __name__ == "__main__":
    sample_entry_str = """
    {
        "id": 1,
        "title": "Harvard University",
        "description": "Ivy League research university in Cambridge, MA.",
        "location": "42.37700, -71.11666",
        "country": "US"
    }
    """
    target_url = "https://www.shanghairanking.com/universities/harvard-university"

    asyncio.run(scrape_single_university(sample_entry_str, target_url))