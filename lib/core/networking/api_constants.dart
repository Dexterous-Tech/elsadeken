class ApiConstants {
  // may use dotenv package and make file .env to save base url

  static String baseUrl = 'https://sadiqeen.com/api';

  // auth
  static String login = '/user/login';
  static String forgetPassword = '/user/forget-password';
  static String verifyOtp = '/user/forget-password/verify';
  static String resetPassword = '/user/forget-password/reset-password';
  static String listNationalities = '/user/list/nationalities';
  static String listCountries = '/user/list/countries';
  static String listCities(String id) => '/user/list/cities/$id';
  static String skinColors = '/user/list/skin-colors';
  static String physiques = '/user/list/physiques';
  static String qualifications = '/user/list/qualifications';
  static String financialSituations = '/user/list/financial-situations';
  static String healthConditions = '/user/list/health-conditions';
  static String incomes = '/user/list/incomes';
  static String signup = '/user/register';
  static String registerInformation = '/user/attributes';
  static String logout = '/user/logout';
  static String deleteUser = '/user/delete-account';
  static String getOnline = '/user/get-online';
  static String setOnline = '/user/set-online';

  // profile
  static String aboutUs = '/user/aboutUs';
  static String contactUs = '/user/contact-us';
  static String getProfile = '/user/profile';
  static String likeUser(int id) => '/user/like/user/$id';
  static String ignoreUser(int id) => '/user/ignore/user/$id';
  static String favUserList = '/user/like/list';
  static String interestingList = '/user/liked/people-list';
  static String ignoreUserList = '/user/ignore/list';
  static String userDetails(int userId) => '/user/show-one-user/$userId';
  static String updateImage = '/user/update-image';
  static String updateProfileLoginData = '/user/update-profile/personal-info';
  static String updateProfileLocationData =
      '/user/update-profile/location-info';
  static String updateProfileMarriageData =
      '/user/update-profile/marriage-info';
  static String updateProfilePhysicsData = '/user/update-profile/physical-info';
  static String updateProfileReligiousData =
      '/user/update-profile/religious-info';
  static String updateProfileWorkingData = '/user/update-profile/work-info';
  static String updateProfileAboutMeData = '/user/update-profile/aboutme-info';
  static String updateProfileAboutPartnerData =
      '/user/update-profile/lifepartner-info';
  static String getMembersProfile = '/user/members/images';
  static String reportUser(int userId) => '/user/report-user-profile/$userId';
  static String shareUser(int userId) => '/user/share/profile/$userId';
  static String updateImageSetting = '/user/update-image-setting';
  static String deleteImage = '/user/delete-image';

  //search-home
  static String matchesUsers = '/user/home/matches-users';
  static String personDetails(int id) => '/user/show-one-user/$id';

  // notifications
  static String getNotifications = '/user/get-notifications';
  static String countNotifications = '/user/get-count-unread-notifications';
  static String updateFcmToken = '/user/update-fcmtoken';
  static String getNotificationSetting = '/user/get-notification-setting';
  static String updateNotificationSetting(int id) =>
      '/user/update-notification-setting/$id';
  static String toggleNotify = '/user/notify';

  static const String defaultProfileImage =
      'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png';

  // members
  static String distinguishedMembers = '/user/members/distinguished';
  static String healthConditionMembers = '/user/members/health-condition';
  static String newMembers({int? countryId}) =>
      '/user/members/latest${countryId != null ? '?country_id=$countryId' : ''}';
  static String visitorsMembers = '/user/members/visitors';
  static String onlineMembers = '/user/members/online';

  // chat
  static String getChatsList = '/user/chats/list';
  static String userChat(String id) => '/user/chats/chat-messages/$id';
  static String sendMessage = '/user/chats/send-message';
  static String markAllMessagesAsRead = '/user/mark-all-messages-as-read';
  static String addChatToFavorite(int chatId) =>
      '/user/add-chat-to-favorite/$chatId';

  // chat settings
  static String getChatSettings = '/user/get-chat-setting';
  static String updateChatSettings(String id) =>
      '/user/update-chat-setting/$id';
  static String reportChatSettings(String id) => '/user/report-user-chat/$id';
  static String muteChatSettings(String id) => '/user/mute-chat/$id';
  static String deleteOneChatSettings(String id) => '/user/delete-chat/$id';
  static String deleteAllChatSettings = '/user/delete-all-chats';

// nationality and country lists
  static String getNationalities = '/user/list/nationalities';
  static String getCountries = '/user/list/countries';

  // Features
  static String getFeatures = '/user/my-features';

  // Packages
  static String getPackages = '/user/packages';
  static String assignPackageToUser(String id) =>
      '/user/assign-package-to-user/$id';
}
