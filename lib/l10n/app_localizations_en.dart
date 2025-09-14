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
  String get confirm => 'Confirm';

  @override
  String get confirmDeletion => 'Confirm Delete';

  @override
  String get confirmDelCont => 'Do you confirm delete all chats? u can\'t roll back it';

  @override
  String get delteDone => 'Deletion Successfully';

  @override
  String get confirmReadCont => 'Do you want to make all chats have read mark?';

  @override
  String get doneReadCont => 'All chats have read mark?';

  @override
  String get modify => 'Modify';

  @override
  String get update => 'Update';

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
  String get more => 'more';

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
  String get successStories => 'Success stories';

  @override
  String get blog => 'Alsadiqeen Blog';

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
  String get showOnlineStatus => 'Your Connection Status';

  @override
  String get newMessages => 'New messages';

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
  String get appearancePreferences => 'Appearance Preferences';

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
  String get searchResults => 'Search Results';

  @override
  String get noResults => 'No results found';

  @override
  String get createPassword => 'Create Password';

  @override
  String get confirmPasswordField => 'Confirm Password';

  @override
  String get passwordsNotMatch => 'Password and confirm password do not match';

  @override
  String get confirmPasswordRequired => 'You must confirm the password';

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
  String get onlyWife => 'Only wife';

  @override
  String get noPolygamy => 'No Polygamy Allowed';

  @override
  String get firstWife => 'First wife';

  @override
  String get secondWife => 'Second wife';

  @override
  String get onlyHusband => 'Only husband';

  @override
  String get noPolygamyHusband => 'No Polygamy Allowed';

  @override
  String get dataUpdatedSuccessfully => 'Data updated successfully';

  @override
  String get noChanges => 'No changes made';

  @override
  String get username => 'Username';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get financialStatus => 'Financial status?';

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
  String get freeRegistration => 'To provide opportunities for all members, registration is free.';

  @override
  String get oathFormat => 'Oath Format:';

  @override
  String get mainOath => 'I swear by Almighty God that I have registered in this application for lawful marriage, and that my intention is serious and sincere in building a family based on love and mercy, in accordance with Islamic law.';

  @override
  String get commitmentPart1 => 'I pledge to fully comply ';

  @override
  String get termsAndConditions => 'with the terms and conditions';

  @override
  String get commitmentPart2 => ' of this application, and not to use it for any purpose that offends religion or morals or contradicts the objectives set for it, and God is a witness to what I say.';

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
  String get accountLabel => 'Account';

  @override
  String get anyPerson => 'Anyone';

  @override
  String get allCountries => 'All Countries';

  @override
  String get allNationalities => 'All Nationalities';

  @override
  String get notSpecified => 'Not specified';

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
  String get connectionStatusUpdated => 'Connection status updated successfully';

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
  String get currentlyOnline => 'Currently Online';

  @override
  String get aboutPerson => 'About Person';

  @override
  String get historyRecord => 'History Record';

  @override
  String get registeredSince => 'Registered Since';

  @override
  String get lastVisitDate => 'Last Visit Date';

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
  String get failedToLoadUserDetails => 'Failed to load user details. Please try again.';

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
  String get connectionStatusUpdatedSuccessfully => 'Connection status updated successfully';

  @override
  String get onlineNow => 'Online now';

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
  String get partnerDescription => 'Description of your life partner you want to connect with';

  @override
  String get talkAboutYourself => 'Talk About Yourself';

  @override
  String get myImage => 'My Image';

  @override
  String get importantInformation => 'Important Information:';

  @override
  String get imageGuidelines1 => 'The image must be respectful and appropriate for the Islamic app theme';

  @override
  String get imageGuidelines2 => 'Any misuse of this service leads to banning your subscription without prior notice';

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
  String get oneDayAgo => 'One Day Ago';

  @override
  String daysAgo(Object count) {
    return '$count Days Ago';
  }

  @override
  String weeksAgo(Object count) {
    return '$count Weeks Ago';
  }

  @override
  String monthsAgo(Object count) {
    return '$count Months Ago';
  }

  @override
  String yearsAgo(Object count) {
    return '$count Years Ago';
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
  String get areYouSureUnreport => 'Are you sure you want to unreport this user?';

  @override
  String get unreportSuccessful => 'User unreported successfully';

  @override
  String get year => 'year';

  @override
  String ageText(String count) {
    String _temp0 = intl.Intl.selectLogic(
      count,
      {
        '1': 'year',
        'other': 'years',
      },
    );
    return '$_temp0';
  }

  @override
  String get whatIsYourJob => 'What is your job?';

  @override
  String get whatIsYourMonthlyIncome => 'What is your monthly income?';

  @override
  String get jobRequired => 'Job is required';

  @override
  String get jobTooLong => 'Job must not exceed 50 characters';

  @override
  String get jobNoLinks => 'Job cannot contain links';

  @override
  String get retryButton => 'Retry';

  @override
  String get pleaseWaitWhileLoadingProfile => 'Please wait while loading profile';

  @override
  String get failedToLoadData => 'Failed to load data';

  @override
  String get enterNumberOfChildren => 'Enter number of children';

  @override
  String get religiousCommitment => 'Religious Commitment';

  @override
  String get prayer => 'Prayer?';

  @override
  String get smoking => 'Smoking';

  @override
  String get hijab => 'hijab';

  @override
  String get beard => 'beard';

  @override
  String get editReligiousInfo => 'Edit Religious Information';

  @override
  String get chooseReligiousCommitmentLevel => 'Choose religious commitment level';

  @override
  String get choosePrayerStatus => 'Choose prayer status';

  @override
  String get chooseSmokingStatus => 'Choose smoking status';

  @override
  String get chooseBeardStatus => 'Choose beard status';

  @override
  String get chooseHijabStatus => 'Choose hijab status';

  @override
  String get irreligious => 'Not religious';

  @override
  String get littleReligious => 'A little religious';

  @override
  String get religious => 'Religious';

  @override
  String get muchReligious => 'Very religious';

  @override
  String get dontSay => 'Prefer not to say';

  @override
  String get irreligiousFemale => 'Not religious';

  @override
  String get littleReligiousFemale => 'A little religious';

  @override
  String get religiousFemale => 'Religious';

  @override
  String get muchReligiousFemale => 'Very religious';

  @override
  String get prayAlways => 'I always pray';

  @override
  String get prayMostTimes => 'I pray most of the time';

  @override
  String get praySometimes => 'I pray sometimes';

  @override
  String get noPray => 'I don\'t pray';

  @override
  String get withBeard => 'With beard';

  @override
  String get withoutBeard => 'without Beard';

  @override
  String get notHijab => 'Not Hijab';

  @override
  String get hijabFaceVisible => 'Hijab (face visible)';

  @override
  String get hijabWithVeil => 'Hijab with veil';

  @override
  String get hijabFaceCovered => 'Hijab (face covered)';

  @override
  String get howOldAreYou => 'How old are you?';

  @override
  String get howManyChildren => 'How many children do you have?';

  @override
  String get howMuchDoYouWeigh => 'How much do you weigh (kg)?';

  @override
  String get howTallAreYou => 'How tall are you (cm)?';

  @override
  String premiumMembersCount(Object count) {
    return 'Premium Members Count: $count';
  }

  @override
  String get noPremiumMembers => 'No premium members';

  @override
  String onlineMembersCount(Object count) {
    return 'Online Now: $count';
  }

  @override
  String get whoVisitedMyProfile => 'Who Visited My Profile';

  @override
  String get noResultsCurrently => 'No results currently';

  @override
  String get minuteAgo => 'A minute ago';

  @override
  String get twoMinutesAgo => 'Two minutes ago';

  @override
  String minutesAgo(Object count) {
    return '$count Minutes Ago';
  }

  @override
  String minutesAgoSingle(Object count) {
    return '$count minute ago';
  }

  @override
  String get hourAgo => 'An hour ago';

  @override
  String get twoHoursAgo => 'Two hours ago';

  @override
  String hoursAgo(Object count) {
    return '$count Hours Ago';
  }

  @override
  String hoursAgoSingle(Object count) {
    return '$count hour ago';
  }

  @override
  String get dayAgo => 'A day ago';

  @override
  String get twoDaysAgo => 'Two days ago';

  @override
  String daysAgoSingle(Object count) {
    return '$count day ago';
  }

  @override
  String get filter => 'Filter';

  @override
  String resultsCount(Object count) {
    return 'Results Count: $count';
  }

  @override
  String healthStatusesCount(Object count) {
    return 'Health Statuses Count: $count';
  }

  @override
  String get noHealthStatuses => 'No health statuses';

  @override
  String filteredByHealthStatus(Object status) {
    return 'Filtered by health status: $status';
  }

  @override
  String filteredByCountry(Object country) {
    return 'Filtered by country: $country';
  }

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get filterByHealthStatus => 'Filter by health status';

  @override
  String get filterByCountry => 'Filter by country';

  @override
  String get clear => 'Clear';

  @override
  String get conditions => 'Conditions';

  @override
  String get editMaritalStatus => 'Edit Marital Status';

  @override
  String get chooseMaritalStatus => 'Choose marital status';

  @override
  String get chooseMarriageType => 'Choose marriage type';

  @override
  String get enterAge => 'Enter age';

  @override
  String get widowed => 'Widower';

  @override
  String get widowedFemale => 'Widower';

  @override
  String get noObjectionToPolygamy => 'No objection to polygamy';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get errorNoUpdateProfileCubit => 'Error: UpdateProfileCubit not provided';

  @override
  String get pleaseConfirmPassword => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordOptional => 'Password (optional)';

  @override
  String get confirmPasswordOptional => 'Confirm password (optional)';

  @override
  String get countryCode => 'Country Code';

  @override
  String get physique => 'Physique';

  @override
  String get usernameMinLength => 'Username must be at least 2 characters';

  @override
  String get usernameMaxLength => 'Username cannot exceed 50 characters';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get phoneNumberLength => 'Phone number must be between 8 and 15 digits';

  @override
  String get passwordMinLength => 'Password must contain at least 6 characters';

  @override
  String get passwordNumberOrSymbol => 'Password must contain at least one number (0-9) or symbol';

  @override
  String get passwordCase => 'Password must contain at least one uppercase and lowercase letter';

  @override
  String get pleaseSelectAllRequiredFields => 'Please select all required fields';

  @override
  String get pleaseEnterValidMonthlyIncome => 'Please enter a valid monthly income';

  @override
  String get monthlyIncomeMustBePositive => 'Monthly income must be greater than zero';

  @override
  String get pleaseEnterValidAge => 'Please enter a valid age';

  @override
  String get ageRange => 'Age must be between 18 - 99';

  @override
  String get pleaseEnterValidChildrenCount => 'Please enter a valid number of children';

  @override
  String get childrenRange => 'Number of children must be between 0 - 99';

  @override
  String get pleaseEnterValidWeight => 'Please enter a valid weight';

  @override
  String get weightRange => 'Weight cannot exceed 300 and must be at least 30';

  @override
  String get pleaseEnterValidHeight => 'Please enter a valid height';

  @override
  String get heightRange => 'Height cannot exceed 250 and must be at least 50';

  @override
  String get deleteAccountError => 'Error deleting account';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get doYouWantToDeleteAccount => 'Do you want to delete your account permanently?';

  @override
  String get cannotUndoThisAction => 'This action cannot be undone';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get lifePartner => 'Life Partner';

  @override
  String get writeAboutLifePartner => 'Write about your life partner\'s characteristics';

  @override
  String get aboutMe => 'Talk about yourself';

  @override
  String get writeAboutYourself => 'Write about yourself';

  @override
  String get editWrittenContent => 'Edit Written Content';

  @override
  String get bodyStructure => 'Body Structure';

  @override
  String get enterWeightInKg => 'Enter weight in kilograms';

  @override
  String get enterHeightInCm => 'Enter height in centimeters';

  @override
  String get chooseSkinColor => 'Choose skin color';

  @override
  String get chooseBodyStructure => 'Choose body structure';

  @override
  String get editPhysicalAppearance => 'Edit Physical Appearance';

  @override
  String get editProfessionalInfo => 'Edit Professional Information';

  @override
  String get chooseEducationalQualification => 'Choose educational qualification';

  @override
  String get chooseFinancialStatus => 'Choose financial status';

  @override
  String get enterJob => 'Enter job';

  @override
  String get enterMonthlyIncome => 'Enter monthly income';

  @override
  String get chooseHealthStatus => 'Choose health status';

  @override
  String get recordHistory => 'Record History';

  @override
  String get futureSpouseDescription => 'Future Spouse Description';

  @override
  String get myDescription => 'My Description';

  @override
  String get sinceToday => 'Since Today';

  @override
  String get oneWeekAgo => 'One Week Ago';

  @override
  String get oneMonthAgo => 'One Month Ago';

  @override
  String get oneYearAgo => 'One Year Ago';

  @override
  String get oneHourAgo => 'One Hour Ago';

  @override
  String get centimeters => 'cm';

  @override
  String get kilograms => 'kg';

  @override
  String get next => 'Next';

  @override
  String get specialMember => 'Special Member';

  @override
  String get dragLoading => 'Drag to load';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get cannotUpdateSettingsBeforeLoading => 'Cannot update settings before loading them';

  @override
  String get noChatSettingsContactSupport => 'No chat settings - please contact technical support';

  @override
  String get connectionTimeoutRetry => 'Connection timeout - please try again';

  @override
  String get requestMethodError => 'Request method error - please try again';

  @override
  String get sessionExpiredRelogin => 'Session expired - please login again';

  @override
  String get serverErrorTryLater => 'Server error - please try later';

  @override
  String get connectionTimeoutCheckInternet => 'Connection timeout - please check your internet';

  @override
  String get settingsNotFoundContactSupport => 'Settings not found - please contact technical support';

  @override
  String get errorUpdatingSettings => 'Error updating settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get noNotificationsYet => 'There are no notifications yet';

  @override
  String get notificationsWillAppearHere => 'Your notifications will appear here when new messages arrive';

  @override
  String get view => 'View';

  @override
  String get startSearchToShowResults => 'Start searching to show results';

  @override
  String get yearsOld => 'years old';

  @override
  String get whoAddedMeToFavorites => 'Who added me to their favorites?';

  @override
  String get profileVisits => 'Profile visits';

  @override
  String get whoAddedMeToIgnoreList => 'Who added me to their ignore list?';

  @override
  String get whatIsYourNationality => 'What is your nationality';

  @override
  String get whatIsYourCountry => 'What is your country';

  @override
  String get whatIsYourCity => 'What is your city';

  @override
  String get thereIsNoResult => 'There is no result';

  @override
  String get thereIsNoAvailableNationality => 'There is no available nationality';

  @override
  String get thereIsNoAvailableCountry => 'There is no available country';

  @override
  String get thereIsNoAvailableCity => 'There is no available city';

  @override
  String get thereIsError => 'There is error';

  @override
  String get previous => 'Previous';

  @override
  String get yesIam => 'Yes';

  @override
  String get noIam => 'No';

  @override
  String get hijabAndVeil => 'Hijab and Veil';

  @override
  String get hijab_face => 'Hijab Face';

  @override
  String get smokingAsk => 'Smoking ?';

  @override
  String get hijabAsk => 'Hijab ?';

  @override
  String get beardAsk => 'Beard ?';

  @override
  String get whatIsYourSkinColor => 'What is your skin color';

  @override
  String get whatIsYourBodyShape => 'What is your body shape';

  @override
  String get youShouldChooseCityFirst => 'You should choose city first';

  @override
  String get youShouldChooseCountryFirst => 'You should choose country first';

  @override
  String get youShouldChooseNationalityFirst => 'You should choose nationality first';

  @override
  String get aboutPartner => 'What are the specifications of your life partner that you would like to marry?';

  @override
  String get writeHint => 'Write';

  @override
  String get textCannotContainNumbers => 'Text cannot contain numbers';

  @override
  String get cannotEnterPhoneNumber => 'Cannot enter phone number here';

  @override
  String get textCannotContainLinks => 'Text cannot contain links';

  @override
  String get agreeToTermsAndConditions => 'I agree to the Privacy Policy and Terms of Use';

  @override
  String get whatIsYourEducationalQualification => 'What is your educational qualification?';

  @override
  String get ageRequired => 'Age is required';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get numberOfChildrenRequired => 'Number of children is required';

  @override
  String get weightRequired => 'Weight is required';

  @override
  String get heightRequired => 'Height is required';

  @override
  String get jobHint => 'Job';

  @override
  String get incomeRequired => 'Income is required';

  @override
  String get incomeCannotBeNegative => 'Monthly income cannot be less than 0';

  @override
  String get whatIsYourHealthStatus => 'What is your health status?';

  @override
  String get registrationSuccessful => 'Registration successful';

  @override
  String get passwordRequired => 'You must enter a password';

  @override
  String get passwordMinLengthValidation => 'Password must be at least 6 characters';

  @override
  String get passwordNumberSymbolValidation => 'Must use one number (0-9) and symbol (@#\$& .... )';

  @override
  String get passwordCaseValidation => 'Must use at least one uppercase and lowercase letter';

  @override
  String get phoneRequired => 'You must enter your phone number';

  @override
  String get phoneMinLength => 'Phone number must be more than 8 digits';

  @override
  String get whatIsYourName => 'What is your name?';

  @override
  String get yourName => 'Your name';

  @override
  String get nameRequired => 'You must enter your name';

  @override
  String get whatIsYourEmail => 'What is your email?';

  @override
  String get yourEmail => 'Your email';

  @override
  String get emailRequired => 'You must enter your email';

  @override
  String get whatIsYourPhoneNumber => 'What is your phone number?';

  @override
  String get whatIsYourReligiousCommitment => 'What is your religious commitment?';

  @override
  String get singleMale => 'Single';

  @override
  String get divorcedMale => 'Divorced';

  @override
  String get widower => 'Widower';

  @override
  String get widow => 'Widow';

  @override
  String get errorUpdatingStatus => 'Error occurred while updating status';

  @override
  String get messageSentSuccessfully => 'Your message has been sent successfully';

  @override
  String get yourEmailAddress => 'Your email address';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get messageSubject => 'Message subject';

  @override
  String get pleaseEnterMessageSubject => 'Please enter the message subject';

  @override
  String get writeYourMessage => 'Write your message';

  @override
  String get pleaseEnterMessageContent => 'Please enter the message content';

  @override
  String get messageMustBeMoreThan10Chars => 'Message must be more than 10 characters';

  @override
  String get send => 'Send';

  @override
  String get chatSetting => 'Chat Settings';

  @override
  String get beardTitle => 'Beard';

  @override
  String get hijabTitle => 'Hijab';

  @override
  String get prayerTitle => 'Prayer';

  @override
  String get premiumCardDescription => 'We are pleased to communicate with you. Our support team is ready to serve you and answer your inquiries and comments at any time.';

  @override
  String get chats => 'Chats';

  @override
  String get noNewMatches => 'No new matches';

  @override
  String get failedToLoadMatches => 'Failed to load matches';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get selectCountry => 'Select Country';
}
