import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universities_map/app_info.dart';
import 'package:universities_map/config.dart' show config;
import 'package:universities_map/data/data_provider_factory.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/shared_preferences.dart';
import 'package:universities_map/translations.dart';
import 'package:universities_map/view/pages/main_page.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferencesInstance = SharedPreferencesInstance(sharedPreferences);
  if (sharedPreferences.getBool(
        SharedPreferencesInstance.settingsInitializedProperty,
      ) ==
      null) {
    sharedPreferencesInstance.setSettingsToDefault();
  }
  viewSettings = ViewSettings(sharedPreferencesInstance);
  viewSettings.addListener(
    sharedPreferencesInstance.onViewSettingsChangedNotifications,
  );
  await PackageInfo.fromPlatform().then((p) => packageInfo = p);
  final dataProvider = await createDataProvider(config);
  final editor = Editor(dataProvider);
  await editor.initializeData();
  runApp(MyApp(editor: editor));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.editor});

  final Editor editor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StringPropertyChangeProvider<Editor>(
      value: editor,
      child: PropertyChangeProvider<ViewSettings, String>(
        value: viewSettings,
        child: PropertyChangeConsumer<ViewSettings, String>(
          properties: const [
            ViewSettings.themeProperty,
            ViewSettings.languageProperty,
            ViewSettings.settingsReseted,
          ],
          builder: (p0, p1, p2) => MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            locale: Locale(languageToCalendarString[viewSettings.language]!),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: viewSettings.themeMode,
            theme: ThemeData(
              brightness: viewSettings.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
              colorSchemeSeed: Color(0xFFCBD5E1),
            ),
            home: const MainPage(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
