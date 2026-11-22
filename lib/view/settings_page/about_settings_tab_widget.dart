import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/app_info.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/view/helpers/snackbar_helper.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettingsTabWidget extends StatelessWidget {
  AboutSettingsTabWidget({super.key});

  final InAppReview inAppReview = InAppReview.instance;

  void showResetApplicationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 24),
          insetPadding: EdgeInsets.all(24),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              const Icon(Icons.restart_alt, color: Colors.red),
              Text(AppLocalizations.of(context)!.resetApplication),
            ],
          ),
          content: Builder(
            builder: (context) {
              var screenSize = MediaQuery.of(context).size;
              return SizedBox(
                width: screenSize.width - 20,
                child: Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.resetConfirmation,
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.reset,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final editor = StringPropertyChangeProvider.of<Editor, String>(
                  context,
                  listen: false,
                )!.value;
                await editor.resetAll();
                viewSettings.resetSettings();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getLanguageString() {
    switch (viewSettings.language) {
      case Language.english:
        return "en";
      case Language.spanish:
        return "es";
      case Language.french:
        return "fr";
      case Language.german:
        return "de";
      case Language.italian:
        return "it";
      case Language.portuguese:
        return "pt";
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = _getLanguageString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.versionLabel(packageInfo.version)),
        ListTile(
          title: Text(AppLocalizations.of(context)!.rateApp),
          leading: Icon(Icons.stars, color: Colors.amber),
          onTap: () async {
            if (await inAppReview.isAvailable()) {
              try {
                // TODO: set for Apple Store
                await inAppReview.openStoreListing(appStoreId: null);
              } catch (ex) {
                if (context.mounted) {
                  SnackBarHelper.displayMessage(
                    context,
                    AppLocalizations.of(context)!.errorOccurred,
                  );
                }
              }
            } else {
              if (context.mounted) {
                SnackBarHelper.displayMessage(
                  context,
                  AppLocalizations.of(context)!.errorOccurred,
                );
              }
            }
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.resetApplication),
          leading: const Icon(Icons.restart_alt, color: Colors.red),
          onTap: () => showResetApplicationDialog(context),
        ),
        SizedBox(height: 24),
        // TODO: translate
        Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Other applications that might interest you",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
                title: Text("Icons Calendar"),
                subtitle: Text("A visual calendar with icons"),
                leading: Image.asset(
                  "assets/icons_calendar.png",
                  width: 72,
                  height: 72,
                ),
                trailing: IconButton(
                  onPressed: () {
                    final Uri url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.quentin.calendar.icons&hl=$language',
                    );
                    launchUrl(url);
                  },
                  icon: Icon(Icons.open_in_new),
                ),
                onTap: () {
                  final Uri url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.quentin.calendar.icons&hl=$language',
                  );
                  launchUrl(url);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
