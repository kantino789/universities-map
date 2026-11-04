import 'package:flutter/material.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class SettingsProperty<T> {
  SettingsProperty({
    required this.property,
    required T? initialValue,
    required this.settingsCategory,
  }) {
    label = _labels[property]!;
    _value = initialValue ?? _defaultValues[property]! as T;
    _icon = _icons[property];
  }
  final String property;
  late final String label;
  late T _value;
  T get value => _value;
  late final Icon? _icon;
  Icon? get icon => _icon;
  final String settingsCategory;

  void update(T newValue) {
    _value = newValue;
  }

  static const Map<String, String> _labels = {
    ViewSettings.themeProperty: "Dark mode",
    ViewSettings.use24HoursProperty: "24 hours time format",
    ViewSettings.displayMonthBeforeDayProperty: "Display month before day",
    ViewSettings.languageProperty: "Language",
  };

  static const Map<String, Object> _defaultValues = {
    ViewSettings.languageProperty: 0,
    ViewSettings.themeProperty: false,
    ViewSettings.displayMonthBeforeDayProperty: false,
    ViewSettings.use24HoursProperty: true,
  };

  static Map<String, Object> get defaultValues =>
      Map<String, Object>.from(_defaultValues);

  static const Map<String, Icon> _icons = {
    ViewSettings.themeProperty: Icon(Icons.dark_mode),
    ViewSettings.use24HoursProperty: Icon(Icons.schedule),
    ViewSettings.displayMonthBeforeDayProperty: Icon(Icons.calendar_month),
    ViewSettings.languageProperty: Icon(Icons.language),
  };

  static const Map<String, Map<int, String>> _choices = {
    ViewSettings.languageProperty: {
      0: "English",
      1: "Español",
      2: "Français",
      3: "Deutsch",
      4: "Italiano",
      5: "Português",
    },
  };

  static Map<int, String> getChoices(String property) {
    return _choices[property] ?? {};
  }
}
