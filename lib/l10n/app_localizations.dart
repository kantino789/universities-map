import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Universities Map'**
  String get appTitle;

  /// No description provided for @mapTab.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTab;

  /// No description provided for @favoritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTab;

  /// No description provided for @notesTab.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @generalTab.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTab;

  /// No description provided for @aboutTab.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTab;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @use24Hours.
  ///
  /// In en, this message translates to:
  /// **'24 hours time format'**
  String get use24Hours;

  /// No description provided for @monthBeforeDay.
  ///
  /// In en, this message translates to:
  /// **'Display month before day'**
  String get monthBeforeDay;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @resetApplication.
  ///
  /// In en, this message translates to:
  /// **'Reset application'**
  String get resetApplication;

  /// No description provided for @resetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset the application? All data will be lost and settings will be reset.'**
  String get resetConfirmation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get reset;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// Installed application version
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateApp;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @filterOptions.
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Map loading failure with diagnostic details
  ///
  /// In en, this message translates to:
  /// **'Could not load map:\n{error}'**
  String mapLoadError(String error);

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavorites;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get noNotes;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @recognizedSubjects.
  ///
  /// In en, this message translates to:
  /// **'Recognized for its excellence in the following subjects:'**
  String get recognizedSubjects;

  /// No description provided for @notesHeading.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get notesHeading;

  /// No description provided for @enterNote.
  ///
  /// In en, this message translates to:
  /// **'Enter a note'**
  String get enterNote;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNote;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get saveNote;

  /// No description provided for @categoryNaturalSciences.
  ///
  /// In en, this message translates to:
  /// **'Natural Sciences'**
  String get categoryNaturalSciences;

  /// No description provided for @categoryEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get categoryEngineering;

  /// No description provided for @categoryLifeSciences.
  ///
  /// In en, this message translates to:
  /// **'Life Sciences'**
  String get categoryLifeSciences;

  /// No description provided for @categoryMedicalSciences.
  ///
  /// In en, this message translates to:
  /// **'Medical Sciences'**
  String get categoryMedicalSciences;

  /// No description provided for @categorySocialSciences.
  ///
  /// In en, this message translates to:
  /// **'Social Sciences'**
  String get categorySocialSciences;

  /// No description provided for @subjectAtmosphericScience.
  ///
  /// In en, this message translates to:
  /// **'Atmospheric Science'**
  String get subjectAtmosphericScience;

  /// No description provided for @subjectChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get subjectChemistry;

  /// No description provided for @subjectEarthSciences.
  ///
  /// In en, this message translates to:
  /// **'Earth Sciences'**
  String get subjectEarthSciences;

  /// No description provided for @subjectEcology.
  ///
  /// In en, this message translates to:
  /// **'Ecology'**
  String get subjectEcology;

  /// No description provided for @subjectGeography.
  ///
  /// In en, this message translates to:
  /// **'Geography'**
  String get subjectGeography;

  /// No description provided for @subjectMathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get subjectMathematics;

  /// No description provided for @subjectOceanography.
  ///
  /// In en, this message translates to:
  /// **'Oceanography'**
  String get subjectOceanography;

  /// No description provided for @subjectPhysics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get subjectPhysics;

  /// No description provided for @subjectAerospaceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Aerospace Engineering'**
  String get subjectAerospaceEngineering;

  /// No description provided for @subjectArtificialIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get subjectArtificialIntelligence;

  /// No description provided for @subjectAutomationControl.
  ///
  /// In en, this message translates to:
  /// **'Automation & Control'**
  String get subjectAutomationControl;

  /// No description provided for @subjectBiomedicalEngineering.
  ///
  /// In en, this message translates to:
  /// **'Biomedical Engineering'**
  String get subjectBiomedicalEngineering;

  /// No description provided for @subjectBiotechnology.
  ///
  /// In en, this message translates to:
  /// **'Biotechnology'**
  String get subjectBiotechnology;

  /// No description provided for @subjectChemicalEngineering.
  ///
  /// In en, this message translates to:
  /// **'Chemical Engineering'**
  String get subjectChemicalEngineering;

  /// No description provided for @subjectCivilEngineering.
  ///
  /// In en, this message translates to:
  /// **'Civil Engineering'**
  String get subjectCivilEngineering;

  /// No description provided for @subjectComputerScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Computer Science & Engineering'**
  String get subjectComputerScienceEngineering;

  /// No description provided for @subjectElectricalElectronicEngineering.
  ///
  /// In en, this message translates to:
  /// **'Electrical & Electronic Engineering'**
  String get subjectElectricalElectronicEngineering;

  /// No description provided for @subjectEnergyScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Energy Science & Engineering'**
  String get subjectEnergyScienceEngineering;

  /// No description provided for @subjectEnvironmentalScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Environmental Science & Engineering'**
  String get subjectEnvironmentalScienceEngineering;

  /// No description provided for @subjectFoodScienceTechnology.
  ///
  /// In en, this message translates to:
  /// **'Food Science & Technology'**
  String get subjectFoodScienceTechnology;

  /// No description provided for @subjectInstrumentsScienceTechnology.
  ///
  /// In en, this message translates to:
  /// **'Instruments Science & Technology'**
  String get subjectInstrumentsScienceTechnology;

  /// No description provided for @subjectMarineOceanEngineering.
  ///
  /// In en, this message translates to:
  /// **'Marine/Ocean Engineering'**
  String get subjectMarineOceanEngineering;

  /// No description provided for @subjectMaterialsScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Materials Science & Engineering'**
  String get subjectMaterialsScienceEngineering;

  /// No description provided for @subjectMechanicalEngineering.
  ///
  /// In en, this message translates to:
  /// **'Mechanical Engineering'**
  String get subjectMechanicalEngineering;

  /// No description provided for @subjectMetallurgicalEngineering.
  ///
  /// In en, this message translates to:
  /// **'Metallurgical Engineering'**
  String get subjectMetallurgicalEngineering;

  /// No description provided for @subjectMiningMineralEngineering.
  ///
  /// In en, this message translates to:
  /// **'Mining & Mineral Engineering'**
  String get subjectMiningMineralEngineering;

  /// No description provided for @subjectNanoscienceNanotechnology.
  ///
  /// In en, this message translates to:
  /// **'Nanoscience & Nanotechnology'**
  String get subjectNanoscienceNanotechnology;

  /// No description provided for @subjectRemoteSensing.
  ///
  /// In en, this message translates to:
  /// **'Remote Sensing'**
  String get subjectRemoteSensing;

  /// No description provided for @subjectRoboticScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Robotic Science & Engineering'**
  String get subjectRoboticScienceEngineering;

  /// No description provided for @subjectTelecommunicationEngineering.
  ///
  /// In en, this message translates to:
  /// **'Telecommunication Engineering'**
  String get subjectTelecommunicationEngineering;

  /// No description provided for @subjectTextileScienceEngineering.
  ///
  /// In en, this message translates to:
  /// **'Textile Science & Engineering'**
  String get subjectTextileScienceEngineering;

  /// No description provided for @subjectTransportationScienceTechnology.
  ///
  /// In en, this message translates to:
  /// **'Transportation Science & Technology'**
  String get subjectTransportationScienceTechnology;

  /// No description provided for @subjectWaterResources.
  ///
  /// In en, this message translates to:
  /// **'Water Resources'**
  String get subjectWaterResources;

  /// No description provided for @subjectAgriculturalSciences.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Sciences'**
  String get subjectAgriculturalSciences;

  /// No description provided for @subjectBiologicalSciences.
  ///
  /// In en, this message translates to:
  /// **'Biological Sciences'**
  String get subjectBiologicalSciences;

  /// No description provided for @subjectHumanBiologicalSciences.
  ///
  /// In en, this message translates to:
  /// **'Human Biological Sciences'**
  String get subjectHumanBiologicalSciences;

  /// No description provided for @subjectVeterinarySciences.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Sciences'**
  String get subjectVeterinarySciences;

  /// No description provided for @subjectClinicalMedicine.
  ///
  /// In en, this message translates to:
  /// **'Clinical Medicine'**
  String get subjectClinicalMedicine;

  /// No description provided for @subjectDentistryOralSciences.
  ///
  /// In en, this message translates to:
  /// **'Dentistry & Oral Sciences'**
  String get subjectDentistryOralSciences;

  /// No description provided for @subjectMedicalTechnology.
  ///
  /// In en, this message translates to:
  /// **'Medical Technology'**
  String get subjectMedicalTechnology;

  /// No description provided for @subjectNursing.
  ///
  /// In en, this message translates to:
  /// **'Nursing'**
  String get subjectNursing;

  /// No description provided for @subjectPharmacyPharmaceuticalSciences.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy & Pharmaceutical Sciences'**
  String get subjectPharmacyPharmaceuticalSciences;

  /// No description provided for @subjectPublicHealth.
  ///
  /// In en, this message translates to:
  /// **'Public Health'**
  String get subjectPublicHealth;

  /// No description provided for @subjectBusinessAdministration.
  ///
  /// In en, this message translates to:
  /// **'Business Administration'**
  String get subjectBusinessAdministration;

  /// No description provided for @subjectCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get subjectCommunication;

  /// No description provided for @subjectEconomics.
  ///
  /// In en, this message translates to:
  /// **'Economics'**
  String get subjectEconomics;

  /// No description provided for @subjectEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get subjectEducation;

  /// No description provided for @subjectFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get subjectFinance;

  /// No description provided for @subjectHospitalityTourismManagement.
  ///
  /// In en, this message translates to:
  /// **'Hospitality & Tourism Management'**
  String get subjectHospitalityTourismManagement;

  /// No description provided for @subjectLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get subjectLaw;

  /// No description provided for @subjectLibraryInformationScience.
  ///
  /// In en, this message translates to:
  /// **'Library & Information Science'**
  String get subjectLibraryInformationScience;

  /// No description provided for @subjectManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get subjectManagement;

  /// No description provided for @subjectPoliticalSciences.
  ///
  /// In en, this message translates to:
  /// **'Political Sciences'**
  String get subjectPoliticalSciences;

  /// No description provided for @subjectPsychology.
  ///
  /// In en, this message translates to:
  /// **'Psychology'**
  String get subjectPsychology;

  /// No description provided for @subjectPublicAdministration.
  ///
  /// In en, this message translates to:
  /// **'Public Administration'**
  String get subjectPublicAdministration;

  /// No description provided for @subjectSociology.
  ///
  /// In en, this message translates to:
  /// **'Sociology'**
  String get subjectSociology;

  /// No description provided for @subjectStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get subjectStatistics;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
