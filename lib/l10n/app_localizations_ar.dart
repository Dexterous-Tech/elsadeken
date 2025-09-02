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
  String get nosignup => 'ليس لديك حساب ؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور (اختياري)';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get emailError => 'البريد الإلكتروني غير صالح';

  @override
  String get passwordError => 'كلمة المرور مطلوبة';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'الغاء';

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
  String get locationCountry => 'الدولة';

  @override
  String get locationCity => 'المدينة';

  @override
  String get locationStreet => 'الشارع';

  @override
  String get manageAccount => 'ادارة حسابي';

  @override
  String get interestsList => 'قائمة الاهتمام';

  @override
  String get ignoringList => 'قائمة التجاهل';

  @override
  String get whoInterestsMe => 'من يهتم بي';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get membersPhotos => 'صور الأعضاء';

  @override
  String get excellencePackage => 'باقه التميز';

  @override
  String get successStories => 'قصص نجاح';

  @override
  String get blog => 'مدونه الصادقين والصادقات';

  @override
  String get aboutUs => 'نبذه عننا';

  @override
  String get shareApp => 'مشاركه التطبيق';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get personalInfo => 'معلومات شخصية';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get notifications => 'الاشعارات';

  @override
  String get deleteMyPhoto => 'مسح صورتي';

  @override
  String get personalAccount => 'الحساب الشخصي';

  @override
  String get confirm => 'تأكيد';

  @override
  String get areYouSure => 'هل انت متاكد؟';

  @override
  String get close => 'إغلاق';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get continueButton => 'استمر';

  @override
  String get ok => 'حسناً';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get deleteImage => 'حذف الصورة';

  @override
  String get deleteImageSuccess => 'تم حذف الصورة بنجاح';

  @override
  String get deleteImageError => 'خطأ في حذف الصورة';

  @override
  String get deleteImageLoading => 'جاري حذف الصورة...';

  @override
  String get deleteImageConfirm => 'هل تريد حذف صورة الملف الشخصي؟';

  @override
  String get deleteAccountConfirm => 'هل تريد حذف حسابك نهائياً؟';

  @override
  String get deleteAccountWarning => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get messageSettings => 'إعدادات الرسائل';

  @override
  String get showOnlineStatus => 'حالة الاتصال الخاصة بك';

  @override
  String get newMessages => 'رسائل جديدة';

  @override
  String get ageGroup => 'الفئة العمرية';

  @override
  String get nationalities => 'الجنسيات';

  @override
  String get countries => 'الدول';

  @override
  String get selectAgeGroup => 'اختر الفئة العمرية';

  @override
  String get selectNationalities => 'اختر الجنسيات';

  @override
  String get selectCountries => 'اختر الدول';

  @override
  String get loadingNationalities => 'جاري تحميل الجنسيات...';

  @override
  String get loadingCountries => 'جاري تحميل الدول...';

  @override
  String get nationalitiesError => 'حدث خطأ في تحميل الجنسيات';

  @override
  String get countriesError => 'حدث خطأ في تحميل الدول';

  @override
  String get setupListsLoading => 'جاري إعداد القوائم...';

  @override
  String get chatDeleted => 'المحادثة محذوفة - يمكنك بدء محادثة جديدة';

  @override
  String chatDeletedSuccess(Object name) {
    return 'تم حذف محادثة \"$name\" بنجاح';
  }

  @override
  String get chatBlockedSuccess => 'تم حظر الشات بنجاح';

  @override
  String get chatMutedSuccess => 'تم كتم الصوت';

  @override
  String addedToFavorites(Object name) {
    return 'تم إضافة $name إلى المفضلة';
  }

  @override
  String get markAllAsReadConfirm => 'هل تريد وضع علامة مقروء على جميع الرسائل؟';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get selectAll => 'الكل';

  @override
  String get choose => 'اختار';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get nationality => 'الجنسية';

  @override
  String get country => 'الدولة';

  @override
  String get city => 'المدينة';

  @override
  String get age => 'العمر';

  @override
  String get marriageType => 'نوع الزواج';

  @override
  String get skinColor => 'لون البشرة';

  @override
  String get height => 'الطول';

  @override
  String get weight => 'الوزن';

  @override
  String get appearancePreferences => 'تفضيلات المظهر والطول والوزن';

  @override
  String get sortResults => 'ترتيب النتائج';

  @override
  String get quickSearch => 'البحث السريع';

  @override
  String get searchByUsername => 'بحث بإسم المستخدم';

  @override
  String get noNationalitiesAvailable => 'لا توجد جنسيات متاحة';

  @override
  String get noCitiesAvailable => 'لا توجد مدن متاحة';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get share => 'مشاركة';

  @override
  String get interest => 'اهتمام';

  @override
  String get ignore => 'تجاهل';

  @override
  String get report => 'ابلاغ';

  @override
  String get liked => 'تم الاعجاب';

  @override
  String get ignored => 'تم التجاهل';

  @override
  String get reported => 'تم الابلاغ';

  @override
  String get actionFailed => 'فشل في تسجيل الإجراء';

  @override
  String get likedMessage => 'تم الإعجاب!';

  @override
  String addedToInterestsList(Object name) {
    return 'تم إضافة $name إلى المفضلة';
  }

  @override
  String get search => 'بحث';

  @override
  String searchResults(Object count) {
    return 'تم العثور على $count نتيجة';
  }

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get createPassword => 'إنشاء كلمه المرور';

  @override
  String get confirmPasswordField => 'تاكيد كلمه المرور';

  @override
  String get passwordsNotMatch => 'كلمة المرور وتأكيد كلمة المرور غير متطابقين';

  @override
  String get confirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get selectAllRequiredFields => 'يرجى اختيار جميع الحقول المطلوبة';

  @override
  String get maritalStatus => 'الحالة الإجتماعية';

  @override
  String get whatIsMaritalStatus => 'ما هي الحالة الاجتماعية ؟';

  @override
  String get whatIsMarriageType => 'ما هو نوع الزواج ؟';

  @override
  String get single => 'أعزب';

  @override
  String get married => 'متزوج';

  @override
  String get divorced => 'مطلق';

  @override
  String get singleFemale => 'عزباء';

  @override
  String get marriedFemale => 'متزوجة';

  @override
  String get divorcedFemale => 'مطلقة';

  @override
  String get onlyWife => 'الزوجة الوحيدة';

  @override
  String get noPolygamy => 'لا مانع من تعدد الزوجات';

  @override
  String get firstWife => 'زوجة اولي';

  @override
  String get secondWife => ' زوجة ثانية';

  @override
  String get onlyHusband => 'الزوج الوحيد';

  @override
  String get noPolygamyHusband => 'لا مانع من تعدل الزوجات';

  @override
  String get dataUpdatedSuccessfully => 'تم تحديث البيانات بنجاح';

  @override
  String get noChanges => 'لم يتم إجراء أي تغييرات';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get financialStatus => 'الوضع المادي';

  @override
  String get job => 'الوظيفة';

  @override
  String get monthlyIncome => 'الدخل الشهري';

  @override
  String get healthStatus => 'الحالة الصحية';

  @override
  String get socialStatus => 'الحالة الاجتماعية';

  @override
  String get children => 'الاطفال';

  @override
  String get members => 'الاعضاء';

  @override
  String get onlineMembers => 'المتواجدون الان';

  @override
  String get profileVisitors => 'من زار بياناتي';

  @override
  String get newMembers => 'اعضاء جدد';

  @override
  String get premiumMembers => 'الاعضاء المميزين';

  @override
  String get healthStatuses => 'الحالات الصحية';

  @override
  String get all => 'الكل';

  @override
  String get males => 'الذكور';

  @override
  String get females => 'الإناث';

  @override
  String get deleteAllChats => 'حذف جميع المحادثات';

  @override
  String get markAllAsRead => 'وضع علامة مقروء على جميع المحادثات';

  @override
  String get deleteChat => 'مسح الدردشة';

  @override
  String get muteChat => 'وضع الصامت';

  @override
  String get blockUser => 'حظر المستخدم';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get favoritesList => 'القائمة المفضلة';

  @override
  String get errorLoadingMessages => 'حدث خطأ في تحميل الرسائل';

  @override
  String get tryAgainButton => 'إعادة المحاولة';

  @override
  String get now => 'الآن';

  @override
  String get minute => 'دقيقة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get hour => 'ساعة';

  @override
  String get hours => 'ساعة';

  @override
  String get day => 'يوم';

  @override
  String get days => 'يوم';

  @override
  String get greetingSalam => 'السلام عليكم ورحمة الله';

  @override
  String get freeRegistration => 'لإتاحة الفرصة لجميع الأعضاء، فإن التسجيل مجاني.';

  @override
  String get oathFormat => 'صيغة القسم:';

  @override
  String get mainOath => 'أقسم بالله العظيم أنني سجلت في هذا التطبيق زواجًا شرعيًا، وأن قصدي جاد وصادق في بناء أسرة قائمة على المودة والرحمة، وفقًا لأحكام الشريعة الإسلامية.';

  @override
  String get commitmentPart1 => 'وأتعهد بالالتزام الكامل ';

  @override
  String get termsAndConditions => 'بشروط وقوانين';

  @override
  String get commitmentPart2 => ' هذا التطبيق، وعدم استخدامه لأي غرض يسيء للدين أو الأخلاق أو يخالف ما وضع له من أهداف، والله على ما أقول شهيد.';

  @override
  String get oathAcceptance => 'لقد قمت باداء القسم وسالتزم به';

  @override
  String get registerMaleFree => 'تسجيل كزوج مجانا (ذكر)';

  @override
  String get registerFemaleFree => 'تسجيل كزوجة مجانا (انثي)';

  @override
  String get homeLabel => 'الرئيسية';

  @override
  String get messagesLabel => 'الرسائل';

  @override
  String get membersLabel => 'الاعضاء';

  @override
  String get accountLabel => 'الحساب';

  @override
  String get anyPerson => 'أي شخص';

  @override
  String get allCountries => 'كل الدول';

  @override
  String get allNationalities => 'كل الجنسيات';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get unknown => 'غير معروف';

  @override
  String get noData => 'لا يوجد';

  @override
  String get premiumMember => 'عضو مميز';

  @override
  String get whoCanSendMessages => 'من يستطيع إرسال الرسائل إليك؟';

  @override
  String get errorLoadingNationalities => 'حدث خطأ في تحميل الجنسيات';

  @override
  String get errorLoadingCountries => 'حدث خطأ في تحميل الدول';

  @override
  String get errorLoadingLists => 'حدث خطأ أثناء تحميل القوائم';

  @override
  String get settingUpLists => 'جاري إعداد القوائم...';

  @override
  String get pleaseWait => 'يرجى الانتظار';

  @override
  String get onlineStatus => 'متصل الآن';

  @override
  String get offlineStatus => 'غير متصل';

  @override
  String get connectionStatusUpdated => 'تم تحديث حالة الاتصال بنجاح';

  @override
  String get savingInProgress => 'جاري الحفظ...';

  @override
  String get profilePictureNotification => 'صور الأعضاء';

  @override
  String get manageMyAccount => 'ادارة حسابي';

  @override
  String get myInterestsList => 'قائمه الاهتمام';

  @override
  String get alsadeqenBlog => 'مدونه الصادقين والصادقات';

  @override
  String get freeRegistrationOnboarding => 'التسجيل مجاناً';

  @override
  String get notSpecifiedTime => 'غير محدد';

  @override
  String get currentlyOnline => 'متواجد حاليا';

  @override
  String get aboutPerson => 'عن الشخص';

  @override
  String get historyRecord => 'تاريخ السجل';

  @override
  String get registeredSince => 'مسجل منذ';

  @override
  String get lastVisitDate => 'تاريخ آخر زيادة';

  @override
  String get information => 'المعلومات';

  @override
  String get residence => 'الاقامه';

  @override
  String get typeOfMarriage => 'نوع الزواج';

  @override
  String get numberOfChildren => 'عدد الاطفال';

  @override
  String get cm => 'سم';

  @override
  String get kg => 'كجم';

  @override
  String get invalidPersonId => 'Invalid person ID provided';

  @override
  String get noDataFound => 'No data found for this user';

  @override
  String get failedToLoadUserDetails => 'Failed to load user details. Please try again.';

  @override
  String get noDataFoundShort => 'No data found';

  @override
  String get selectAgeCategory => 'اختر الفئة العمرية';

  @override
  String get pleaseWaitMoment => 'يرجى الانتظار قليلاً';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get save => 'حفظ';

  @override
  String get noChangesMade => 'لم يتم إجراء أي تغييرات';

  @override
  String get settingsLoadedSuccessfully => 'تم تحميل الإعدادات بنجاح';

  @override
  String get connectionStatusUpdatedSuccessfully => 'تم تحديث حالة الاتصال بنجاح';

  @override
  String get onlineNow => 'متصل الآن';

  @override
  String get offline => 'غير متصل';

  @override
  String get showThatYouAreOnline => 'أظهر أنك متصل';

  @override
  String get yourConnectionStatus => 'حالة الاتصال الخاصة بك';

  @override
  String get loadingNationalitiesPleaseWait => 'جاري تحميل الجنسيات...';

  @override
  String get blogTitle => 'مدونة الصادقون و الصادقات';

  @override
  String get successStoriesTitle => 'القصص الناجحة';

  @override
  String successStoriesCount(Object count) {
    return 'بحمد الله $count قصة ناجحة';
  }

  @override
  String get nationalityAndResidence => 'الجنسية و الإقامة';

  @override
  String get heightCm => 'الطول (سم)';

  @override
  String get weightKg => 'الوزن (كم)';

  @override
  String get educationalQualification => 'المؤهل التعليمي';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get mostVisitedFirst => 'الأكثر دخولاً أولاً';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String foundResults(Object count) {
    return 'تم العثور على $count نتيجة';
  }

  @override
  String get editMyData => 'تعديل بياناتي';

  @override
  String get loginData => 'بيانات تسجيل الدخول';

  @override
  String get myAppearance => 'مظهرك';

  @override
  String get religion => 'الدين';

  @override
  String get studyAndWork => 'الدراسة و العمل';

  @override
  String get partnerDescription => 'موصفات شريكة حياتك التي ترغب الإرتباط بها';

  @override
  String get talkAboutYourself => 'تحدث عن نفسك';

  @override
  String get myImage => 'صورتي';

  @override
  String get importantInformation => 'معلومات هامة :';

  @override
  String get imageGuidelines1 => 'يجب ان تكون الصورة محترمة ، ولائقة بطابع التطبيق الإسلامي';

  @override
  String get imageGuidelines2 => 'أي إستخدام سيء لهذه الخدمة يؤدي إاى حظر إشتراكك بدون سابق إنذار';

  @override
  String get allowedToViewMyImage => 'المسموح لهم بمشاهدة صورتي';

  @override
  String get noOne => 'لا احد';

  @override
  String get hideMyImage => '(حجب صورتي)';

  @override
  String get allMembers => 'كل الاعضاء';

  @override
  String get noOneCanSeeYourImage => 'لا احد يسمح برؤية صورتك';

  @override
  String get uploadImage => 'تحميل صوره';

  @override
  String get chooseImageSource => 'اختر مصدر الصورة';

  @override
  String get takePhotoFromCamera => 'التقاط صورة من الكاميرا';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get updatingPrivacySettings => 'جاري تحديث إعدادات الخصوصية...';

  @override
  String get noOneWillSeeYourImage => 'لا احد سوف يري صورتك';

  @override
  String get everyoneWillSeeYourImage => 'سوف يري صورتك الجميع';

  @override
  String get imageUploadedSuccessfully => 'تم رفع الصورة بنجاح';

  @override
  String get successGuide => 'دليلـــــك نحــــــو النجــــــــاح';

  @override
  String get zeroMembers => '0 عضو';

  @override
  String get loadingMore => 'جاري تحميل المزيد...';

  @override
  String get noDataAvailable => 'لا يوجد';

  @override
  String get membershipNumber => 'رقم العضوية';

  @override
  String get registrationDate => 'تاريخ التسجيل';

  @override
  String get today => 'اليوم';

  @override
  String get oneDayAgo => 'منذ يوم واحد';

  @override
  String daysAgo(Object count) {
    return 'منذ $count أيام';
  }

  @override
  String weeksAgo(Object count) {
    return 'منذ $count أسابيع';
  }

  @override
  String monthsAgo(Object count) {
    return 'منذ $count أشهر';
  }

  @override
  String yearsAgo(Object count) {
    return 'منذ $count سنوات';
  }

  @override
  String get editLoginData => 'تعديل بيانات تسجيل الدخول';

  @override
  String get enterUsername => 'أدخل اسم المستخدم';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get newPassword => 'كلمة المرور (اختياري)';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get enterConfirmPassword => 'أدخل تأكيد كلمة المرور';

  @override
  String get editNationalityCountryCity => 'تعديل الجنسية والدولة والمدينة';

  @override
  String get chooseNationality => 'اختر الجنسية';

  @override
  String get chooseCountry => 'اختر الدولة';

  @override
  String get chooseCity => 'اختر المدينة';

  @override
  String get deleteMyAccount => 'حذف حسابي';

  @override
  String get logoutError => 'خطأ في تسجيل الخروج';

  @override
  String get logoutSuccessful => 'تم تسجيل الخروج بنجاح';

  @override
  String get doYouWantToLogout => 'هل تريد تسجيل الخروج؟';

  @override
  String get unreportUser => 'إلغاء الإبلاغ';

  @override
  String get confirmUnreport => 'تأكيد إلغاء الإبلاغ';

  @override
  String get areYouSureUnreport => 'هل أنت متأكد من إلغاء الإبلاغ عن هذا المستخدم؟';

  @override
  String get unreportSuccessful => 'تم إلغاء الإبلاغ عن المستخدم بنجاح';
}
