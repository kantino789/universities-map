import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universities_map/view/settings_page/settings_property.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

late final SharedPreferencesInstance sharedPreferencesInstance;

class SharedPreferencesInstance {
  SharedPreferencesInstance(this.sharedPreferences);
  final SharedPreferences sharedPreferences;
  void onViewSettingsChangedNotifications(String? property) {
    if (property != null && property != ViewSettings.settingsReseted) {
      var value = viewSettings.getPropertyValue(property);
      if (value is bool) {
        sharedPreferences.setBool(property, value);
      } else if (value is int) {
        sharedPreferences.setInt(property, value);
      }
    }
  }

  T? getPropertyValue<T>(String property) {
    if (T == bool) {
      return sharedPreferences.getBool(property) as T?;
    } else if (T == int) {
      return sharedPreferences.getInt(property) as T?;
    }
    return null;
  }

  void setSettingsToDefault() {
    SettingsProperty.defaultValues.forEach((key, value) {
      if (key == ViewSettings.languageProperty) {
        if (kIsWeb) {
          sharedPreferences.setInt(key, Language.english.index);
        } else {
          String locale = Platform.localeName;
          if (locale.startsWith("fr")) {
            sharedPreferences.setInt(key, Language.french.index);
          } else if (locale.startsWith("es")) {
            sharedPreferences.setInt(key, Language.spanish.index);
          } else if (locale.startsWith("de")) {
            sharedPreferences.setInt(key, Language.german.index);
          } else if (locale.startsWith("it")) {
            sharedPreferences.setInt(key, Language.italian.index);
          } else if (locale.startsWith("pt")) {
            sharedPreferences.setInt(key, Language.portuguese.index);
          } else {
            sharedPreferences.setInt(key, Language.english.index);
          }
        }
      } else if (value is bool) {
        sharedPreferences.setBool(key, value);
      } else if (value is int) {
        sharedPreferences.setInt(key, value);
      }
    });
    sharedPreferences.setBool("settingsInitializedProperty", true);
  }

  static const String settingsInitializedProperty =
      "settingsInitializedProperty";
}
