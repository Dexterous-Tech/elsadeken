// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome to my app';

  @override
  String get authTitle => 'Authentication';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get nosignup => 'Don\'t have an account?';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get emailError => 'Invalid email address';

  @override
  String get passwordError => 'Password is required';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get location => 'Location';

  @override
  String get locationSearch => 'Search Location';

  @override
  String get locationSelect => 'Select Location';

  @override
  String get locationAddress => 'Address';

  @override
  String get locationCountry => 'Country';

  @override
  String get locationCity => 'City';

  @override
  String get locationStreet => 'Street';

  @override
  String get manageAccount => 'Manage Account';

  @override
  String get interestsList => 'Interests List';

  @override
  String get ignoringList => 'Ignoring List';

  @override
  String get whoInterestsMe => 'Who Interests Me';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get membersPhotos => 'Members Photos';

  @override
  String get excellencePackage => 'Excellence Package';

  @override
  String get successStories => 'Success Stories';

  @override
  String get blog => 'Alsadiqeen & Alsadiqat Blog';

  @override
  String get aboutUs => 'About Us';

  @override
  String get shareApp => 'Share App';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get appSettings => 'App Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get deleteMyPhoto => 'Delete My Photo';

  @override
  String get personalAccount => 'Personal Account';

  @override
  String get confirm => 'Confirm';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get close => 'Close';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get continueButton => 'Continue';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get deleteImageSuccess => 'Image deleted successfully';

  @override
  String get deleteImageError => 'Error deleting image';

  @override
  String get deleteImageLoading => 'Deleting image...';

  @override
  String get deleteImageConfirm => 'Do you want to delete your profile picture?';

  @override
  String get deleteAccountConfirm => 'Do you want to permanently delete your account?';

  @override
  String get deleteAccountWarning => 'This action cannot be undone';

  @override
  String get messageSettings => 'Message Settings';

  @override
  String get showOnlineStatus => 'Show that you\'re online';

  @override
  String get newMessages => 'New Messages';

  @override
  String get ageGroup => 'Age Group';

  @override
  String get nationalities => 'Nationalities';

  @override
  String get countries => 'Countries';

  @override
  String get selectAgeGroup => 'Select Age Group';

  @override
  String get selectNationalities => 'Select Nationalities';

  @override
  String get selectCountries => 'Select Countries';

  @override
  String get loadingNationalities => 'Loading nationalities...';

  @override
  String get loadingCountries => 'Loading countries...';

  @override
  String get nationalitiesError => 'Error loading nationalities';

  @override
  String get countriesError => 'Error loading countries';

  @override
  String get setupListsLoading => 'Setting up lists...';

  @override
  String get chatDeleted => 'Chat deleted - you can start a new conversation';

  @override
  String chatDeletedSuccess(Object name) {
    return 'Chat with \"$name\" deleted successfully';
  }

  @override
  String get chatBlockedSuccess => 'Chat blocked successfully';

  @override
  String get chatMutedSuccess => 'Chat muted';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get markAllAsReadConfirm => 'Do you want to mark all messages as read?';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get selectAll => 'All';

  @override
  String get choose => 'Choose';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get nationality => 'Nationality';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get age => 'Age';

  @override
  String get marriageType => 'Marriage Type';

  @override
  String get skinColor => 'Skin Color';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get appearancePreferences => 'Appearance, Height and Weight Preferences';

  @override
  String get sortResults => 'Sort Results';

  @override
  String get quickSearch => 'Quick Search';

  @override
  String get searchByUsername => 'Search by Username';

  @override
  String get noNationalitiesAvailable => 'No nationalities available';

  @override
  String get noCitiesAvailable => 'No cities available';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get share => 'Share';

  @override
  String get interest => 'Interest';

  @override
  String get ignore => 'Ignore';

  @override
  String get report => 'Report';

  @override
  String get liked => 'Liked';

  @override
  String get ignored => 'Ignored';

  @override
  String get reported => 'Reported';

  @override
  String get actionFailed => 'Failed to record action';

  @override
  String get likedMessage => 'Liked!';

  @override
  String addedToInterestsList(Object name) {
    return 'Added $name to favorites';
  }

  @override
  String get search => 'Search';

  @override
  String searchResults(Object count) {
    return 'Found $count results';
  }

  @override
  String get noResults => 'No results found';

  @override
  String get createPassword => 'Create Password';

  @override
  String get confirmPasswordField => 'Confirm Password';

  @override
  String get passwordsNotMatch => 'Password and confirm password do not match';

  @override
  String get confirmPasswordRequired => 'Please confirm password';

  @override
  String get selectAllRequiredFields => 'Please select all required fields';

  @override
  String get maritalStatus => 'Marital Status';

  @override
  String get whatIsMaritalStatus => 'What is your marital status?';

  @override
  String get whatIsMarriageType => 'What is your marriage type?';

  @override
  String get single => 'Single';

  @override
  String get married => 'Married';

  @override
  String get divorced => 'Divorced';

  @override
  String get singleFemale => 'Single';

  @override
  String get marriedFemale => 'Married';

  @override
  String get divorcedFemale => 'Divorced';

  @override
  String get onlyWife => 'Only Wife';

  @override
  String get noPolygamy => 'No Polygamy Allowed';

  @override
  String get firstWife => 'First Wife';

  @override
  String get secondWife => 'Second Wife';

  @override
  String get onlyHusband => 'Only Husband';

  @override
  String get noPolygamyHusband => 'No Polygamy Allowed';

  @override
  String get dataUpdatedSuccessfully => 'Data updated successfully';

  @override
  String get noChanges => 'No changes made';

  @override
  String get username => 'Username';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get financialStatus => 'Financial Status';

  @override
  String get job => 'Job';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get healthStatus => 'Health Status';

  @override
  String get socialStatus => 'Social Status';

  @override
  String get children => 'Children';

  @override
  String get members => 'Members';

  @override
  String get onlineMembers => 'Online Members';

  @override
  String get profileVisitors => 'Profile Visitors';

  @override
  String get newMembers => 'New Members';

  @override
  String get premiumMembers => 'Premium Members';

  @override
  String get healthStatuses => 'Health Statuses';

  @override
  String get all => 'All';

  @override
  String get males => 'Males';

  @override
  String get females => 'Females';
}
