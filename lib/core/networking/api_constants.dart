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
  static String signup = '/user/register';
  static String registerInformation = '/user/attributes';

  // profile
  static String aboutUs = '/user/aboutUs';
}
