import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/shared_preferences.dart';
import 'package:universities_map/view/settings_page/settings_property.dart';

late final ViewSettings viewSettings;

enum TimeFormat { twelveHours, twentyFourHours }

enum Language { english, spanish, french }

class ViewSettings extends StringPropertyChangeNotifier {
  ViewSettings(SharedPreferencesInstance sharedPreferencesInstance)
    : _sharedPreferencesInstance = sharedPreferencesInstance {
    setSettings();
  }

  final SharedPreferencesInstance _sharedPreferencesInstance;

  final Map<String, SettingsProperty> _propertyToValue = {};

  static const Map<String, String> _propertyToCategory = {
    themeProperty: globalSettingsCategory,
    use24HoursProperty: globalSettingsCategory,
    displayMonthBeforeDayProperty: globalSettingsCategory,
    calendarViewProperty: notDisplayedSettingsCategory,
    activitiesViewProperty: notDisplayedSettingsCategory,
    languageProperty: globalSettingsCategory,
  };

  late Language language;

  bool _notifyListeners = true;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => themeMode == ThemeMode.dark;
  void toggleThemeMode() {
    _themeMode = themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _propertyToValue[themeProperty]?.update(isDarkTheme);
  }

  T getPropertyValue<T>(String property) {
    return _propertyToValue[property]!.value as T;
  }

  SettingsProperty getSettingsProperty(String property) {
    return _propertyToValue[property]!;
  }

  void updateProperty<T>(String property, {T? newValue}) {
    if (property == themeProperty) {
      toggleThemeMode();
    } else {
      if (T == bool) {
        _propertyToValue[property]?.update(
          !(_propertyToValue[property]!.value as bool),
        );
      } else if (T == int) {
        _propertyToValue[property]?.update(newValue as int);
        if (property == languageProperty) {
          language = Language.values[_propertyToValue[languageProperty]!.value];
        }
      }
    }
    if (_notifyListeners) {
      notifyListeners(property);
    }
  }

  List<String> getCategoryProperties(String settingsCategory) {
    return _propertyToValue.keys
        .where(
          (property) =>
              _propertyToValue[property]!.settingsCategory == settingsCategory,
        )
        .toList();
  }

  void resetSettings() {
    _sharedPreferencesInstance.setSettingsToDefault();
    _notifyListeners = false;
    _propertyToValue.clear();
    setSettings();
    _notifyListeners = true;
    notifyListeners(settingsReseted);
  }

  void setSettings() {
    SettingsProperty.defaultValues.forEach((key, defaultValue) {
      if (defaultValue is bool) {
        _propertyToValue[key] = SettingsProperty(
          property: key,
          initialValue: _sharedPreferencesInstance.getPropertyValue<bool>(key),
          settingsCategory:
              _propertyToCategory[key] ?? notDisplayedSettingsCategory,
        );
      } else if (defaultValue is int) {
        _propertyToValue[key] = SettingsProperty(
          property: key,
          initialValue: _sharedPreferencesInstance.getPropertyValue<int>(key),
          settingsCategory:
              _propertyToCategory[key] ?? notDisplayedSettingsCategory,
        );
      }
    });
    _themeMode = (_propertyToValue[themeProperty]?.value as bool)
        ? ThemeMode.dark
        : ThemeMode.light;
    language = Language.values[_propertyToValue[languageProperty]!.value];
  }

  static const String globalSettingsCategory = "globalSettingsCategory";
  static const String aboutSettingsCategory = "aboutSettingsCategory";
  static const String notDisplayedSettingsCategory =
      "notDisplayedSettingsCategory";

  static const String themeProperty = "themeProperty";
  static const String use24HoursProperty = "use24HoursProperty";
  static const String displayMonthBeforeDayProperty =
      "displayMonthBeforeDayProperty";
  static const String calendarViewProperty = "calendarViewProperty";
  static const String activitiesViewProperty = "activitiesViewProperty";
  static const String languageProperty = "languageProperty";

  static const String settingsReseted = "settingsReseted";
}
