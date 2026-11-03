import 'package:universities_map/view/settings_page/view_settings.dart';

const Map<Language, String> languageToCalendarString = {
  Language.english: "en",
  Language.spanish: "es",
  Language.french: "fr",
};

const Map<String, Map<Language, String>> _keyToLanguageTranslationMap = {};

String translate(String key) {
  return _keyToLanguageTranslationMap[key]?[viewSettings.language] ?? key;
}
