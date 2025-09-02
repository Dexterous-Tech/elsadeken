// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبا';

  @override
  String get welcome => 'مرحبًا بك في تطبيقي';

  @override
  String get authTitle => 'تسجيل الدخول';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get noEmail => 'ليس لديك حساب ؟';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get location => 'الموقع';

  @override
  String get locationSearch => 'ابحث عن موقع';

  @override
  String get locationSelect => 'اختر الموقع';

  @override
  String get locationAddress => 'العنوان';

  @override
  String get locationCoordinates => 'الإحداثيات';

  @override
  String get locationCountry => 'الدولة';

  @override
  String get locationCity => 'المدينة';

  @override
  String get locationStreet => 'الشارع';

  @override
  String get locationZip => 'الرمز البريدي';

  @override
  String get emailError => 'البريد الالكتروني غير صحيح!';

  @override
  String get passwordError => 'كلمة المرور غير صحيحة!';

  @override
  // TODO: implement nosignup
  String get nosignup => 'ليس لديك حساب ؟ ';
}
