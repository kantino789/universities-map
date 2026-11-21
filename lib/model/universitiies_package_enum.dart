enum UniversitiesPackage { general, french, german }

final Map<UniversitiesPackage, Iterable<String>> _packageToCategories = {
  UniversitiesPackage.general: ["All"],
  UniversitiesPackage.french: ["All", "university", "iut", "engineer"],
  UniversitiesPackage.german: [
    "All",
    "Fachhochschule",
    "Künstlerische Hochschule",
    "Universität",
    "Verwaltungshochschule",
  ],
};

Iterable<String> getPackageCategories(UniversitiesPackage package) {
  return _packageToCategories[package] ?? [];
}
