class ApiConstants {
  // may use dotenv package and make file .env to save base url

  static String baseUrl = 'https://elsadkeen.sharetrip-ksa.com/api';

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
  static String signup = '/user/register';
  static String registerInformation = '/user/attributes';
  static String logout = '/user/logout';
  static String deleteUser = '/user/delete-account';

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

  //search-home
  static String matchesUsers = '/user/home/matches-users';
  static String personDetails(int id) => '/user/show-one-user/$id';

  // notifications
  static String getNotifications = '/user/get-notifications';
  static String countNotifications = '/user/get-count-unread-notifications';
  static String updateFcmToken = '/user/update-fcmtoken';

  static const String defaultProfileImage =
      'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png';
}
