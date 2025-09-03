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
  String get confirmPassword => 'Confirm password (optional)';

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
  String get deleteImageConfirm =>
      'Do you want to delete your profile picture?';

  @override
  String get deleteAccountConfirm =>
      'Do you want to permanently delete your account?';

  @override
  String get deleteAccountWarning => 'This action cannot be undone';

  @override
  String get messageSettings => 'Message Settings';

  @override
  String get showOnlineStatus => 'Your Connection Status';

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
  String addedToFavorites(Object name) {
    return 'Added $name to favorites';
  }

  @override
  String get markAllAsReadConfirm =>
      'Do you want to mark all messages as read?';

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
  String get appearancePreferences =>
      'Appearance, Height and Weight Preferences';

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

  @override
  String get deleteAllChats => 'Delete All Chats';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get muteChat => 'Mute Chat';

  @override
  String get blockUser => 'Block User';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get favoritesList => 'Favorites List';

  @override
  String get errorLoadingMessages => 'Error loading messages';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get now => 'Now';

  @override
  String get minute => 'minute';

  @override
  String get minutes => 'minutes';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get greetingSalam => 'Peace be upon you and God\'s mercy';

  @override
  String get freeRegistration =>
      'To provide opportunities for all members, registration is free.';

  @override
  String get oathFormat => 'Oath Format:';

  @override
  String get mainOath =>
      'I swear by Almighty God that I have registered in this application for lawful marriage, and that my intention is serious and sincere in building a family based on love and mercy, in accordance with Islamic law.';

  @override
  String get commitmentPart1 => 'I pledge to fully comply ';

  @override
  String get termsAndConditions => 'with the terms and conditions';

  @override
  String get commitmentPart2 =>
      ' of this application, and not to use it for any purpose that offends religion or morals or contradicts the objectives set for it, and God is a witness to what I say.';

  @override
  String get oathAcceptance => 'I have taken the oath and will abide by it';

  @override
  String get registerMaleFree => 'Register as Husband Free (Male)';

  @override
  String get registerFemaleFree => 'Register as Wife Free (Female)';

  @override
  String get homeLabel => 'Home';

  @override
  String get messagesLabel => 'Messages';

  @override
  String get membersLabel => 'Members';

  @override
  String get accountLabel => 'Account';

  @override
  String get anyPerson => 'Anyone';

  @override
  String get allCountries => 'All Countries';

  @override
  String get allNationalities => 'All Nationalities';

  @override
  String get notSpecified => 'Not Specified';

  @override
  String get unknown => 'Unknown';

  @override
  String get noData => 'No Data';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get whoCanSendMessages => 'Who can send you messages?';

  @override
  String get errorLoadingNationalities => 'Error loading nationalities';

  @override
  String get errorLoadingCountries => 'Error loading countries';

  @override
  String get errorLoadingLists => 'Error loading lists';

  @override
  String get settingUpLists => 'Setting up lists...';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get onlineStatus => 'Online Now';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get connectionStatusUpdated =>
      'Connection status updated successfully';

  @override
  String get savingInProgress => 'Saving...';

  @override
  String get profilePictureNotification => 'Member Photos';

  @override
  String get manageMyAccount => 'Manage My Account';

  @override
  String get myInterestsList => 'My Interests List';

  @override
  String get alsadeqenBlog => 'Alsadiqeen & Alsadiqat Blog';

  @override
  String get freeRegistrationOnboarding => 'Free Registration';

  @override
  String get notSpecifiedTime => 'Not specified';

  @override
  String get currentlyOnline => 'Currently online';

  @override
  String get aboutPerson => 'About Person';

  @override
  String get historyRecord => 'History Record';

  @override
  String get registeredSince => 'Registered since';

  @override
  String get lastVisitDate => 'Last visit date';

  @override
  String get information => 'Information';

  @override
  String get residence => 'Residence';

  @override
  String get typeOfMarriage => 'Type of Marriage';

  @override
  String get numberOfChildren => 'Number of Children';

  @override
  String get cm => 'cm';

  @override
  String get kg => 'kg';

  @override
  String get invalidPersonId => 'Invalid person ID provided';

  @override
  String get noDataFound => 'No data found for this user';

  @override
  String get failedToLoadUserDetails =>
      'Failed to load user details. Please try again.';

  @override
  String get noDataFoundShort => 'No data found';

  @override
  String get selectAgeCategory => 'Select Age Category';

  @override
  String get pleaseWaitMoment => 'Please wait a moment';

  @override
  String get saving => 'Saving...';

  @override
  String get save => 'Save';

  @override
  String get noChangesMade => 'No changes made';

  @override
  String get settingsLoadedSuccessfully => 'Settings loaded successfully';

  @override
  String get connectionStatusUpdatedSuccessfully =>
      'Connection status updated successfully';

  @override
  String get onlineNow => 'Online Now';

  @override
  String get offline => 'Offline';

  @override
  String get showThatYouAreOnline => 'Show that you\'re online';

  @override
  String get yourConnectionStatus => 'Your Connection Status';

  @override
  String get loadingNationalitiesPleaseWait => 'Loading nationalities...';

  @override
  String get blogTitle => 'Alsadiqeen & Alsadiqat Blog';

  @override
  String get successStoriesTitle => 'Success Stories';

  @override
  String successStoriesCount(Object count) {
    return 'By God\'s grace $count success stories';
  }

  @override
  String get nationalityAndResidence => 'Nationality and Residence';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get educationalQualification => 'Educational Qualification';

  @override
  String get loading => 'Loading...';

  @override
  String get mostVisitedFirst => 'Most Visited First';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get oldestFirst => 'Oldest First';

  @override
  String foundResults(Object count) {
    return 'Found $count results';
  }

  @override
  String get editMyData => 'Edit My Data';

  @override
  String get loginData => 'Login Data';

  @override
  String get myAppearance => 'My Appearance';

  @override
  String get religion => 'Religion';

  @override
  String get studyAndWork => 'Study and Work';

  @override
  String get partnerDescription =>
      'Description of your life partner you want to connect with';

  @override
  String get talkAboutYourself => 'Talk About Yourself';

  @override
  String get myImage => 'My Image';

  @override
  String get importantInformation => 'Important Information:';

  @override
  String get imageGuidelines1 =>
      'The image must be respectful and appropriate for the Islamic app theme';

  @override
  String get imageGuidelines2 =>
      'Any misuse of this service leads to banning your subscription without prior notice';

  @override
  String get allowedToViewMyImage => 'Allowed to view my image';

  @override
  String get noOne => 'No one';

  @override
  String get hideMyImage => '(Hide my image)';

  @override
  String get allMembers => 'All members';

  @override
  String get noOneCanSeeYourImage => 'No one is allowed to see your image';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get chooseImageSource => 'Choose Image Source';

  @override
  String get takePhotoFromCamera => 'Take photo from camera';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get updatingPrivacySettings => 'Updating privacy settings...';

  @override
  String get noOneWillSeeYourImage => 'No one will see your image';

  @override
  String get everyoneWillSeeYourImage => 'Everyone will see your image';

  @override
  String get imageUploadedSuccessfully => 'Image uploaded successfully';

  @override
  String get successGuide => 'Your guide to success';

  @override
  String get zeroMembers => '0 members';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get membershipNumber => 'Membership Number';

  @override
  String get registrationDate => 'Registration Date';

  @override
  String get today => 'Today';

  @override
  String get oneDayAgo => 'One day ago';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String weeksAgo(Object count) {
    return '$count weeks ago';
  }

  @override
  String monthsAgo(Object count) {
    return '$count months ago';
  }

  @override
  String yearsAgo(Object count) {
    return '$count years ago';
  }

  @override
  String get year => 'year';

  @override
  String ageText(Object count) {
    if (count == 1) {
      return '$count year';
    } else {
      return '$count years';
    }
  }

  @override
  String get editLoginData => 'Edit Login Data';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get newPassword => 'New password (optional)';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get enterConfirmPassword => 'Enter confirm password';

  @override
  String get editNationalityCountryCity => 'Edit Nationality, Country and City';

  @override
  String get chooseNationality => 'Choose nationality';

  @override
  String get chooseCountry => 'Choose country';

  @override
  String get chooseCity => 'Choose city';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get logoutError => 'Logout error';

  @override
  String get logoutSuccessful => 'Logout successful';

  @override
  String get doYouWantToLogout => 'Do you want to logout?';

  @override
  String get unreportUser => 'Unreport User';

  @override
  String get confirmUnreport => 'Confirm Unreport';

  @override
  String get areYouSureUnreport =>
      'Are you sure you want to unreport this user?';

  @override
  String get unreportSuccessful => 'User unreported successfully';
}
