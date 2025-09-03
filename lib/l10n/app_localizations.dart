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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
  /// **'Confirm password (optional)'**
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
  /// **'Your Connection Status'**
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
  /// **'Added {name} to favorites'**
  String addedToFavorites(Object name);

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

  /// No description provided for @deleteAllChats.
  ///
  /// In en, this message translates to:
  /// **'Delete All Chats'**
  String get deleteAllChats;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @muteChat.
  ///
  /// In en, this message translates to:
  /// **'Mute Chat'**
  String get muteChat;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @favoritesList.
  ///
  /// In en, this message translates to:
  /// **'Favorites List'**
  String get favoritesList;

  /// No description provided for @errorLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Error loading messages'**
  String get errorLoadingMessages;

  /// No description provided for @tryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainButton;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @greetingSalam.
  ///
  /// In en, this message translates to:
  /// **'Peace be upon you and God\'s mercy'**
  String get greetingSalam;

  /// No description provided for @freeRegistration.
  ///
  /// In en, this message translates to:
  /// **'To provide opportunities for all members, registration is free.'**
  String get freeRegistration;

  /// No description provided for @oathFormat.
  ///
  /// In en, this message translates to:
  /// **'Oath Format:'**
  String get oathFormat;

  /// No description provided for @mainOath.
  ///
  /// In en, this message translates to:
  /// **'I swear by Almighty God that I have registered in this application for lawful marriage, and that my intention is serious and sincere in building a family based on love and mercy, in accordance with Islamic law.'**
  String get mainOath;

  /// No description provided for @commitmentPart1.
  ///
  /// In en, this message translates to:
  /// **'I pledge to fully comply '**
  String get commitmentPart1;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'with the terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @commitmentPart2.
  ///
  /// In en, this message translates to:
  /// **' of this application, and not to use it for any purpose that offends religion or morals or contradicts the objectives set for it, and God is a witness to what I say.'**
  String get commitmentPart2;

  /// No description provided for @oathAcceptance.
  ///
  /// In en, this message translates to:
  /// **'I have taken the oath and will abide by it'**
  String get oathAcceptance;

  /// No description provided for @registerMaleFree.
  ///
  /// In en, this message translates to:
  /// **'Register as Husband Free (Male)'**
  String get registerMaleFree;

  /// No description provided for @registerFemaleFree.
  ///
  /// In en, this message translates to:
  /// **'Register as Wife Free (Female)'**
  String get registerFemaleFree;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @messagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesLabel;

  /// No description provided for @membersLabel.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersLabel;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @anyPerson.
  ///
  /// In en, this message translates to:
  /// **'Anyone'**
  String get anyPerson;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get allCountries;

  /// No description provided for @allNationalities.
  ///
  /// In en, this message translates to:
  /// **'All Nationalities'**
  String get allNationalities;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not Specified'**
  String get notSpecified;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @whoCanSendMessages.
  ///
  /// In en, this message translates to:
  /// **'Who can send you messages?'**
  String get whoCanSendMessages;

  /// No description provided for @errorLoadingNationalities.
  ///
  /// In en, this message translates to:
  /// **'Error loading nationalities'**
  String get errorLoadingNationalities;

  /// No description provided for @errorLoadingCountries.
  ///
  /// In en, this message translates to:
  /// **'Error loading countries'**
  String get errorLoadingCountries;

  /// No description provided for @errorLoadingLists.
  ///
  /// In en, this message translates to:
  /// **'Error loading lists'**
  String get errorLoadingLists;

  /// No description provided for @settingUpLists.
  ///
  /// In en, this message translates to:
  /// **'Setting up lists...'**
  String get settingUpLists;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @onlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Online Now'**
  String get onlineStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineStatus;

  /// No description provided for @connectionStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Connection status updated successfully'**
  String get connectionStatusUpdated;

  /// No description provided for @savingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingInProgress;

  /// No description provided for @profilePictureNotification.
  ///
  /// In en, this message translates to:
  /// **'Member Photos'**
  String get profilePictureNotification;

  /// No description provided for @manageMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage My Account'**
  String get manageMyAccount;

  /// No description provided for @myInterestsList.
  ///
  /// In en, this message translates to:
  /// **'My Interests List'**
  String get myInterestsList;

  /// No description provided for @alsadeqenBlog.
  ///
  /// In en, this message translates to:
  /// **'Alsadiqeen & Alsadiqat Blog'**
  String get alsadeqenBlog;

  /// No description provided for @freeRegistrationOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Free Registration'**
  String get freeRegistrationOnboarding;

  /// No description provided for @notSpecifiedTime.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecifiedTime;

  /// No description provided for @currentlyOnline.
  ///
  /// In en, this message translates to:
  /// **'Currently online'**
  String get currentlyOnline;

  /// No description provided for @aboutPerson.
  ///
  /// In en, this message translates to:
  /// **'About Person'**
  String get aboutPerson;

  /// No description provided for @historyRecord.
  ///
  /// In en, this message translates to:
  /// **'History Record'**
  String get historyRecord;

  /// No description provided for @registeredSince.
  ///
  /// In en, this message translates to:
  /// **'Registered since'**
  String get registeredSince;

  /// No description provided for @lastVisitDate.
  ///
  /// In en, this message translates to:
  /// **'Last visit date'**
  String get lastVisitDate;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @residence.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residence;

  /// No description provided for @typeOfMarriage.
  ///
  /// In en, this message translates to:
  /// **'Type of Marriage'**
  String get typeOfMarriage;

  /// No description provided for @numberOfChildren.
  ///
  /// In en, this message translates to:
  /// **'Number of Children'**
  String get numberOfChildren;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @invalidPersonId.
  ///
  /// In en, this message translates to:
  /// **'Invalid person ID provided'**
  String get invalidPersonId;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found for this user'**
  String get noDataFound;

  /// No description provided for @failedToLoadUserDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user details. Please try again.'**
  String get failedToLoadUserDetails;

  /// No description provided for @noDataFoundShort.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFoundShort;

  /// No description provided for @selectAgeCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Age Category'**
  String get selectAgeCategory;

  /// No description provided for @pleaseWaitMoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWaitMoment;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noChangesMade.
  ///
  /// In en, this message translates to:
  /// **'No changes made'**
  String get noChangesMade;

  /// No description provided for @settingsLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings loaded successfully'**
  String get settingsLoadedSuccessfully;

  /// No description provided for @connectionStatusUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Connection status updated successfully'**
  String get connectionStatusUpdatedSuccessfully;

  /// No description provided for @onlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online Now'**
  String get onlineNow;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @showThatYouAreOnline.
  ///
  /// In en, this message translates to:
  /// **'Show that you\'re online'**
  String get showThatYouAreOnline;

  /// No description provided for @yourConnectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Your Connection Status'**
  String get yourConnectionStatus;

  /// No description provided for @loadingNationalitiesPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Loading nationalities...'**
  String get loadingNationalitiesPleaseWait;

  /// No description provided for @blogTitle.
  ///
  /// In en, this message translates to:
  /// **'Alsadiqeen & Alsadiqat Blog'**
  String get blogTitle;

  /// No description provided for @successStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStoriesTitle;

  /// No description provided for @successStoriesCount.
  ///
  /// In en, this message translates to:
  /// **'By God\'s grace {count} success stories'**
  String successStoriesCount(Object count);

  /// No description provided for @nationalityAndResidence.
  ///
  /// In en, this message translates to:
  /// **'Nationality and Residence'**
  String get nationalityAndResidence;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @educationalQualification.
  ///
  /// In en, this message translates to:
  /// **'Educational Qualification'**
  String get educationalQualification;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @mostVisitedFirst.
  ///
  /// In en, this message translates to:
  /// **'Most Visited First'**
  String get mostVisitedFirst;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @foundResults.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String foundResults(Object count);

  /// No description provided for @editMyData.
  ///
  /// In en, this message translates to:
  /// **'Edit My Data'**
  String get editMyData;

  /// No description provided for @loginData.
  ///
  /// In en, this message translates to:
  /// **'Login Data'**
  String get loginData;

  /// No description provided for @myAppearance.
  ///
  /// In en, this message translates to:
  /// **'My Appearance'**
  String get myAppearance;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @studyAndWork.
  ///
  /// In en, this message translates to:
  /// **'Study and Work'**
  String get studyAndWork;

  /// No description provided for @partnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Description of your life partner you want to connect with'**
  String get partnerDescription;

  /// No description provided for @talkAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Talk About Yourself'**
  String get talkAboutYourself;

  /// No description provided for @myImage.
  ///
  /// In en, this message translates to:
  /// **'My Image'**
  String get myImage;

  /// No description provided for @importantInformation.
  ///
  /// In en, this message translates to:
  /// **'Important Information:'**
  String get importantInformation;

  /// No description provided for @imageGuidelines1.
  ///
  /// In en, this message translates to:
  /// **'The image must be respectful and appropriate for the Islamic app theme'**
  String get imageGuidelines1;

  /// No description provided for @imageGuidelines2.
  ///
  /// In en, this message translates to:
  /// **'Any misuse of this service leads to banning your subscription without prior notice'**
  String get imageGuidelines2;

  /// No description provided for @allowedToViewMyImage.
  ///
  /// In en, this message translates to:
  /// **'Allowed to view my image'**
  String get allowedToViewMyImage;

  /// No description provided for @noOne.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get noOne;

  /// No description provided for @hideMyImage.
  ///
  /// In en, this message translates to:
  /// **'(Hide my image)'**
  String get hideMyImage;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get allMembers;

  /// No description provided for @noOneCanSeeYourImage.
  ///
  /// In en, this message translates to:
  /// **'No one is allowed to see your image'**
  String get noOneCanSeeYourImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose Image Source'**
  String get chooseImageSource;

  /// No description provided for @takePhotoFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo from camera'**
  String get takePhotoFromCamera;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @updatingPrivacySettings.
  ///
  /// In en, this message translates to:
  /// **'Updating privacy settings...'**
  String get updatingPrivacySettings;

  /// No description provided for @noOneWillSeeYourImage.
  ///
  /// In en, this message translates to:
  /// **'No one will see your image'**
  String get noOneWillSeeYourImage;

  /// No description provided for @everyoneWillSeeYourImage.
  ///
  /// In en, this message translates to:
  /// **'Everyone will see your image'**
  String get everyoneWillSeeYourImage;

  /// No description provided for @imageUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully'**
  String get imageUploadedSuccessfully;

  /// No description provided for @successGuide.
  ///
  /// In en, this message translates to:
  /// **'Your guide to success'**
  String get successGuide;

  /// No description provided for @zeroMembers.
  ///
  /// In en, this message translates to:
  /// **'0 members'**
  String get zeroMembers;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @membershipNumber.
  ///
  /// In en, this message translates to:
  /// **'Membership Number'**
  String get membershipNumber;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @oneDayAgo.
  ///
  /// In en, this message translates to:
  /// **'One day ago'**
  String get oneDayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String weeksAgo(Object count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(Object count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(Object count);

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  /// In ar, this message translates to:
  /// **'سنة'**
  String get year;

  /// No description provided for @ageText.
  ///
  /// In en, this message translates to:
  /// **'$count year' or '$count years'**
  /// In ar, this message translates to:
  /// **'$count سنة' or '$count سنوات'**
  String ageText(Object count);

  /// No description provided for @editLoginData.
  ///
  /// In en, this message translates to:
  /// **'Edit Login Data'**
  String get editLoginData;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password (optional)'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @editNationalityCountryCity.
  ///
  /// In en, this message translates to:
  /// **'Edit Nationality, Country and City'**
  String get editNationalityCountryCity;

  /// No description provided for @chooseNationality.
  ///
  /// In en, this message translates to:
  /// **'Choose nationality'**
  String get chooseNationality;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose country'**
  String get chooseCountry;

  /// No description provided for @chooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get chooseCity;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Logout error'**
  String get logoutError;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccessful;

  /// No description provided for @doYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get doYouWantToLogout;

  /// No description provided for @unreportUser.
  ///
  /// In en, this message translates to:
  /// **'Unreport User'**
  String get unreportUser;

  /// No description provided for @confirmUnreport.
  ///
  /// In en, this message translates to:
  /// **'Confirm Unreport'**
  String get confirmUnreport;

  /// No description provided for @areYouSureUnreport.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unreport this user?'**
  String get areYouSureUnreport;

  /// No description provided for @unreportSuccessful.
  ///
  /// In en, this message translates to:
  /// **'User unreported successfully'**
  String get unreportSuccessful;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
