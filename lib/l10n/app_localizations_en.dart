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
  String get locationCoordinates => 'Coordinates';

  @override
  String get locationCountry => 'Country';

  @override
  String get locationCity => 'City';

  @override
  String get locationStreet => 'Street';

  @override
  String get locationZip => 'Postal Code';

  @override
  String get emailError => 'Invalid email!';

  @override
  String get passwordError => 'Invalid password!';

  @override
  // TODO: implement nosignup
  String get nosignup => "You don't have email? ";
}
