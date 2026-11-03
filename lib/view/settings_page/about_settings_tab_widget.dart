import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/app_info.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/translations.dart';
import 'package:universities_map/view/helpers/snackbar_helper.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

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
              Text(translate("Reset application")),
            ],
          ),
          content: Builder(
            builder: (context) {
              var screenSize = MediaQuery.of(context).size;
              return SizedBox(
                width: screenSize.width - 20,
                child: Text(
                  textAlign: TextAlign.center,
                  translate(
                    "Do you really want to reset the application ? All data will be lost and settings will be reset.",
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                translate("RESET"),
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
                  // TODO: Check if there is anything to do
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   PageRouteBuilder(
                  //     pageBuilder: (_, __, ___) => const CalendarPageWidget(),
                  //   ),
                  //   (route) => false,
                  // );
                }
              },
            ),
            TextButton(
              child: Text(translate('BACK')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${translate("Version")} ${packageInfo.version}"),
        //const SettingSwitchTileWidget(property: ViewSettings.enableAdsProperty),
        ListTile(
          title: Text(translate("Rate the app")),
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
                    translate("An error occurred"),
                  );
                }
              }
            } else {
              if (context.mounted) {
                SnackBarHelper.displayMessage(
                  context,
                  translate("An error occurred"),
                );
              }
            }
          },
        ),
        ListTile(
          title: Text(translate("Reset application")),
          leading: const Icon(Icons.restart_alt, color: Colors.red),
          onTap: () => showResetApplicationDialog(context),
        ),
      ],
    );
  }
}
