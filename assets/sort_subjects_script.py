import json

# 1. Load your original JSON file
with open("universities.json", "r", encoding="utf-8") as file:
    data = json.load(file)

# 2. Sort the subjects list for each entry
for item in data:
    if "subjects" in item and isinstance(item["subjects"], list):
        item["subjects"].sort()  # Sorts alphabetically in-place

# 3. Save the output to sorted_subjects_universities.json
output_filename = "sorted_subjects_universities.json"
with open(output_filename, "w", encoding="utf-8") as file:
    json.dump(data, file, indent=4, ensure_ascii=False)

print(f"Sorted data saved to {output_filename}")