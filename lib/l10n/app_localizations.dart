import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to my app'**
  String get welcome;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @nosignup.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get nosignup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get emailError;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordError;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationSearch.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get locationSearch;

  /// No description provided for @locationSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get locationSelect;

  /// No description provided for @locationAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get locationAddress;

  /// No description provided for @locationCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get locationCountry;

  /// No description provided for @locationCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get locationCity;

  /// No description provided for @locationStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get locationStreet;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage Account'**
  String get manageAccount;

  /// No description provided for @interestsList.
  ///
  /// In en, this message translates to:
  /// **'Interests List'**
  String get interestsList;

  /// No description provided for @ignoringList.
  ///
  /// In en, this message translates to:
  /// **'Ignoring List'**
  String get ignoringList;

  /// No description provided for @whoInterestsMe.
  ///
  /// In en, this message translates to:
  /// **'Who Interests Me'**
  String get whoInterestsMe;

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

  /// No description provided for @membersPhotos.
  ///
  /// In en, this message translates to:
  /// **'Members Photos'**
  String get membersPhotos;

  /// No description provided for @excellencePackage.
  ///
  /// In en, this message translates to:
  /// **'Excellence Package'**
  String get excellencePackage;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Alsadiqeen & Alsadiqat Blog'**
  String get blog;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @deleteMyPhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete My Photo'**
  String get deleteMyPhoto;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal Account'**
  String get personalAccount;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @deleteImageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image deleted successfully'**
  String get deleteImageSuccess;

  /// No description provided for @deleteImageError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting image'**
  String get deleteImageError;

  /// No description provided for @deleteImageLoading.
  ///
  /// In en, this message translates to:
  /// **'Deleting image...'**
  String get deleteImageLoading;

  /// No description provided for @deleteImageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your profile picture?'**
  String get deleteImageConfirm;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to permanently delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get deleteAccountWarning;

  /// No description provided for @messageSettings.
  ///
  /// In en, this message translates to:
  /// **'Message Settings'**
  String get messageSettings;

  /// No description provided for @showOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Show that you\'re online'**
  String get showOnlineStatus;

  /// No description provided for @newMessages.
  ///
  /// In en, this message translates to:
  /// **'New Messages'**
  String get newMessages;

  /// No description provided for @ageGroup.
  ///
  /// In en, this message translates to:
  /// **'Age Group'**
  String get ageGroup;

  /// No description provided for @nationalities.
  ///
  /// In en, this message translates to:
  /// **'Nationalities'**
  String get nationalities;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @selectAgeGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Age Group'**
  String get selectAgeGroup;

  /// No description provided for @selectNationalities.
  ///
  /// In en, this message translates to:
  /// **'Select Nationalities'**
  String get selectNationalities;

  /// No description provided for @selectCountries.
  ///
  /// In en, this message translates to:
  /// **'Select Countries'**
  String get selectCountries;

  /// No description provided for @loadingNationalities.
  ///
  /// In en, this message translates to:
  /// **'Loading nationalities...'**
  String get loadingNationalities;

  /// No description provided for @loadingCountries.
  ///
  /// In en, this message translates to:
  /// **'Loading countries...'**
  String get loadingCountries;

  /// No description provided for @nationalitiesError.
  ///
  /// In en, this message translates to:
  /// **'Error loading nationalities'**
  String get nationalitiesError;

  /// No description provided for @countriesError.
  ///
  /// In en, this message translates to:
  /// **'Error loading countries'**
  String get countriesError;

  /// No description provided for @setupListsLoading.
  ///
  /// In en, this message translates to:
  /// **'Setting up lists...'**
  String get setupListsLoading;

  /// No description provided for @chatDeleted.
  ///
  /// In en, this message translates to:
  /// **'Chat deleted - you can start a new conversation'**
  String get chatDeleted;

  /// No description provided for @chatDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Chat with \"{name}\" deleted successfully'**
  String chatDeletedSuccess(Object name);

  /// No description provided for @chatBlockedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Chat blocked successfully'**
  String get chatBlockedSuccess;

  /// No description provided for @chatMutedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Chat muted'**
  String get chatMutedSuccess;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @markAllAsReadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark all messages as read?'**
  String get markAllAsReadConfirm;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get selectAll;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @marriageType.
  ///
  /// In en, this message translates to:
  /// **'Marriage Type'**
  String get marriageType;

  /// No description provided for @skinColor.
  ///
  /// In en, this message translates to:
  /// **'Skin Color'**
  String get skinColor;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @appearancePreferences.
  ///
  /// In en, this message translates to:
  /// **'Appearance, Height and Weight Preferences'**
  String get appearancePreferences;

  /// No description provided for @sortResults.
  ///
  /// In en, this message translates to:
  /// **'Sort Results'**
  String get sortResults;

  /// No description provided for @quickSearch.
  ///
  /// In en, this message translates to:
  /// **'Quick Search'**
  String get quickSearch;

  /// No description provided for @searchByUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by Username'**
  String get searchByUsername;

  /// No description provided for @noNationalitiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No nationalities available'**
  String get noNationalitiesAvailable;

  /// No description provided for @noCitiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cities available'**
  String get noCitiesAvailable;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @ignored.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get ignored;

  /// No description provided for @reported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get reported;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to record action'**
  String get actionFailed;

  /// No description provided for @likedMessage.
  ///
  /// In en, this message translates to:
  /// **'Liked!'**
  String get likedMessage;

  /// No description provided for @addedToInterestsList.
  ///
  /// In en, this message translates to:
  /// **'Added {name} to favorites'**
  String addedToInterestsList(Object name);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String searchResults(Object count);

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @confirmPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordField;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password do not match'**
  String get passwordsNotMatch;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get confirmPasswordRequired;

  /// No description provided for @selectAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please select all required fields'**
  String get selectAllRequiredFields;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @whatIsMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'What is your marital status?'**
  String get whatIsMaritalStatus;

  /// No description provided for @whatIsMarriageType.
  ///
  /// In en, this message translates to:
  /// **'What is your marriage type?'**
  String get whatIsMarriageType;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @singleFemale.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get singleFemale;

  /// No description provided for @marriedFemale.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get marriedFemale;

  /// No description provided for @divorcedFemale.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorcedFemale;

  /// No description provided for @onlyWife.
  ///
  /// In en, this message translates to:
  /// **'Only Wife'**
  String get onlyWife;

  /// No description provided for @noPolygamy.
  ///
  /// In en, this message translates to:
  /// **'No Polygamy Allowed'**
  String get noPolygamy;

  /// No description provided for @firstWife.
  ///
  /// In en, this message translates to:
  /// **'First Wife'**
  String get firstWife;

  /// No description provided for @secondWife.
  ///
  /// In en, this message translates to:
  /// **'Second Wife'**
  String get secondWife;

  /// No description provided for @onlyHusband.
  ///
  /// In en, this message translates to:
  /// **'Only Husband'**
  String get onlyHusband;

  /// No description provided for @noPolygamyHusband.
  ///
  /// In en, this message translates to:
  /// **'No Polygamy Allowed'**
  String get noPolygamyHusband;

  /// No description provided for @dataUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get dataUpdatedSuccessfully;

  /// No description provided for @noChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes made'**
  String get noChanges;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @financialStatus.
  ///
  /// In en, this message translates to:
  /// **'Financial Status'**
  String get financialStatus;

  /// No description provided for @job.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get job;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// No description provided for @socialStatus.
  ///
  /// In en, this message translates to:
  /// **'Social Status'**
  String get socialStatus;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @onlineMembers.
  ///
  /// In en, this message translates to:
  /// **'Online Members'**
  String get onlineMembers;

  /// No description provided for @profileVisitors.
  ///
  /// In en, this message translates to:
  /// **'Profile Visitors'**
  String get profileVisitors;

  /// No description provided for @newMembers.
  ///
  /// In en, this message translates to:
  /// **'New Members'**
  String get newMembers;

  /// No description provided for @premiumMembers.
  ///
  /// In en, this message translates to:
  /// **'Premium Members'**
  String get premiumMembers;

  /// No description provided for @healthStatuses.
  ///
  /// In en, this message translates to:
  /// **'Health Statuses'**
  String get healthStatuses;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @males.
  ///
  /// In en, this message translates to:
  /// **'Males'**
  String get males;

  /// No description provided for @females.
  ///
  /// In en, this message translates to:
  /// **'Females'**
  String get females;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
