import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/chat/data/models/chat_settings_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_settings_request_model.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_settings_cubit/chat_settings_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_settings_cubit/lists_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_online_setting_cubit/chat_online_setting_cubit.dart';

import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool _isOnline = true;
  bool _newMessagesNotification = false;
  bool _profilePictureNotification = false;
  String _selectedAgeCategory = '';
  String _selectedNationalities = '';
  String _selectedCountries = '';

  // Age range for API
  int _fromAge = 18;
  int _toAge = 50;
  int _nationalityId = 0;
  int _countryId = 0;

  // Store original loaded settings for comparison
  int _originalFromAge = 18;
  int _originalToAge = 50;
  int _originalNationalityId = 0;
  int _originalCountryId = 0;

  // Track if initial settings have been loaded
  bool _hasLoadedInitialSettings = false;

  @override
  void initState() {
    super.initState();
    // Initialize localized strings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedAgeCategory = AppLocalizations.of(context)!.anyPerson;
          _selectedNationalities = AppLocalizations.of(context)!.allNationalities;
          _selectedCountries = AppLocalizations.of(context)!.allCountries;
        });
        print(
            '[ChatSettingsScreen] initState: Loading chat settings and lists...');
        context.read<ChatSettingsCubit>().loadChatSettings();
        context.read<ListsCubit>().loadLists();
        context.read<ChatOnlineSettingCubit>().getOnline();
      }
    });
  }

  // Load settings from API response
  void _loadSettingsFromApi(ChatSettingsModel settings) {
    _fromAge = settings.fromAge;
    _toAge = settings.toAge;
    _nationalityId = settings.nationalityId;
    _countryId = settings.countryId;

    // Store original values for comparison
    _originalFromAge = settings.fromAge;
    _originalToAge = settings.toAge;
    _originalNationalityId = settings.nationalityId;
    _originalCountryId = settings.countryId;

    // Update UI text based on IDs (you may need to map these to actual text values)
    _updateAgeCategoryText();
    _updateNationalitiesText();
    _updateCountriesText();

    // Log the user's chat settings ID
    print('[ChatSettingsScreen] Loaded settings with ID: ${settings.id}');
  }

  void _updateAgeCategoryText() {
    if (_fromAge == 0 && _toAge == 0) {
      _selectedAgeCategory = AppLocalizations.of(context)!.anyPerson;
    } else {
      _selectedAgeCategory = '$_fromAge - $_toAge';
    }
  }

  void _updateNationalitiesText() {
    if (_nationalityId == 0) {
      _selectedNationalities = AppLocalizations.of(context)!.allNationalities;
    } else {
      // Get nationality name from lists chat_settings_cubit
      final listsCubit = context.read<ListsCubit>();
      _selectedNationalities = listsCubit.getNationalityName(_nationalityId);
    }
  }

  void _updateCountriesText() {
    if (_countryId == 0) {
      _selectedCountries = AppLocalizations.of(context)!.allCountries;
    } else {
      // Get country name from lists chat_settings_cubit
      final listsCubit = context.read<ListsCubit>();
      _selectedCountries = listsCubit.getCountryName(_countryId);
    }
  }

  // Check if settings have changed from original values

  bool _hasSettingsChanged() {
    final hasChanged = _fromAge != _originalFromAge ||
        _toAge != _originalToAge ||
        _nationalityId != _originalNationalityId ||
        _countryId != _originalCountryId;

    // Debug logging
    print('[ChatSettingsScreen] _hasSettingsChanged check:');
    print(
        '  Current: fromAge=$_fromAge, toAge=$_toAge, nationalityId=$_nationalityId, countryId=$_countryId');
    print(
        '  Original: fromAge=$_originalFromAge, toAge=$_originalToAge, nationalityId=$_originalNationalityId, countryId=$_originalCountryId');
    print('  Has changes: $hasChanged');

    return hasChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<ChatSettingsCubit, ChatSettingsState>(
                listener: (context, state) {
                  print(
                      '[ChatSettingsScreen] ChatSettingsCubit state changed to: ${state.runtimeType}');

                  if (state is ChatSettingsLoaded && mounted) {
                    print(
                        '[ChatSettingsScreen] Settings loaded: ID=${state.chatSettings.id}, fromAge=${state.chatSettings.fromAge}, toAge=${state.chatSettings.toAge}');
                    _loadSettingsFromApi(state.chatSettings);
                    setState(() {});

                    // Show loading success message (optional - can be removed if not needed)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.settingsLoadedSuccessfully,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.blue,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else if (state is ChatSettingsUpdated && mounted) {
                    // Update original values to reflect the successful update
                    _originalFromAge = _fromAge;
                    _originalToAge = _toAge;
                    _originalNationalityId = _nationalityId;
                    _originalCountryId = _countryId;

                    // Show success snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );

                    // Trigger UI update to reflect the new "no changes" state
                    setState(() {});
                  } else if (state is ChatSettingsUpdateError && mounted) {
                    // Show error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else if (state is ChatSettingsError && mounted) {
                    // Show loading error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
                listenWhen: (previous, current) {
                  // Always listen to state changes
                  return true;
                },
              ),
              BlocListener<ListsCubit, ListsState>(
                listener: (context, state) {
                  if (state is ListsLoaded && mounted) {
                    // Lists loaded, update the UI text
                    setState(() {
                      _updateNationalitiesText();
                      _updateCountriesText();
                    });
                  }
                },
              ),
              BlocListener<ChatOnlineSettingCubit, ChatOnlineSettingState>(
                listener: (context, state) {
                  if (state is ChatOnlineSettingGetSuccess && mounted) {
                    // Update online status based on API response
                    setState(() {
                      _isOnline =
                          state.chatOnlineSettingModel.data?.enableOnline == 1;
                    });
                  } else if (state is ChatOnlineSettingSetSuccess && mounted) {
                    // Show success message when online status is updated
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.connectionStatusUpdatedSuccessfully,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                    // Refresh the online status after setting
                    context.read<ChatOnlineSettingCubit>().getOnline();
                  } else if (state is ChatOnlineSettingGetFailure && mounted) {
                    // Show error message when getting online status fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.error,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else if (state is ChatOnlineSettingSetFailure && mounted) {
                    // Show error message when setting online status fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.error,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<ChatSettingsCubit, ChatSettingsState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    // Background image should be behind content
                    /* Positioned(
                    top: 100.h,
                    right: -100.w,
                    child: _buildBackgroundImage(),
                  ),*/
                    // Fallback background decoration
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 300.w,
                        height: 300.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    // Content should be on top and interactive
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/chat/mail 1.png',
                                ),
                              ),
                            ),
                            child: _buildBody(state),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }



  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.h),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              color: AppColors.white,
            ),
            child: ProfileHeader(title: AppLocalizations.of(context)!.messageSettings),
          ),
          // Decorative background image above header but non-interactive
          IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 0,
              left: -20,
              child: Image.asset(
                AppImages.starProfile,
                width: 400.w,
                height: 250.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ChatSettingsState state) {
    // Show loading indicator
    if (state is ChatSettingsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error message if any
    if (state is ChatSettingsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: AppTextStyles.font16BlackSemiBoldLamaSans,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<ChatSettingsCubit>().loadChatSettings(),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    // Show success message if any
    if (state is ChatSettingsUpdated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
          ),
        );
      });
    }

    // Show update error message if any
    if (state is ChatSettingsUpdateError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConnectionStatusSection(),
                SizedBox(height: 50.h),
                _buildDivider(),
                SizedBox(height: 50.h),
                _buildWhoCanSendSection(),
                SizedBox(height: 50.h),
                _buildDivider(),
                SizedBox(height: 50.h),
                // _buildNotificationSettingsSection(),
              ],
            ),
          ),
        ),
        Spacer(),
        _buildSaveButton(),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildConnectionStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.showOnlineStatus,
          style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<ChatOnlineSettingCubit, ChatOnlineSettingState>(
          builder: (context, state) {
            return _buildSettingRow(
              title: _isOnline ? AppLocalizations.of(context)!.onlineStatus : AppLocalizations.of(context)!.offlineStatus,
              subtitle: AppLocalizations.of(context)!.showOnlineStatus,
              showGreenDot: true,
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _isOnline,
                  onChanged: (value) {
                    // Immediately update the UI
                    setState(() {
                      _isOnline = value;
                    });
                    // Call the cubit to update online status
                    context.read<ChatOnlineSettingCubit>().setOnline();
                  },
                  activeColor: Colors.orangeAccent,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.white,
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildWhoCanSendSection() {
    return Container(
      child: Column(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            textDirection: LocalizationService.instance.textDirection,
            AppLocalizations.of(context)!.whoCanSendMessages,
            style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSettingRow(
            title: AppLocalizations.of(context)!.ageGroup,
            subtitle: _selectedAgeCategory,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showAgeCategoryDialog,
          ),
          SizedBox(height: 4.h),
          _buildSettingRow(
            title: AppLocalizations.of(context)!.nationalities,
            subtitle: _selectedNationalities,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showNationalitiesDialog,
          ),
          SizedBox(height: 4.h),
          _buildSettingRow(
            title: AppLocalizations.of(context)!.countries,
            subtitle: _selectedCountries,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showCountriesDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.notifications,
          style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSettingRow(
          title: AppLocalizations.of(context)!.newMessages,
          subtitle: '',
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _newMessagesNotification,
              onChanged: (value) {
                setState(() {
                  _newMessagesNotification = value;
                });
              },
              activeColor: Colors.orangeAccent,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showGreenDot = false, // Add this flag
  }) {
    return InkWell(
      splashColor: Colors.blue.withOpacity(0.3),
      highlightColor: Colors.blue.withOpacity(0.1),
      onTap: onTap != null
          ? () {
              print('Tapped on: $title'); // Debug print
              onTap();
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFfbecef).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (showGreenDot) ...[
                    SizedBox(width: 8.w),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: _isOnline ? Colors.green : AppColors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: AppTextStyles.font14BlackRegularLamaSans.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      color: Colors.grey[300],
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<ChatSettingsCubit, ChatSettingsState>(
      builder: (context, state) {
        final isLoading = state is ChatSettingsUpdating;
        final hasSettings = _fromAge != 0 ||
            _toAge != 0 ||
            _nationalityId != 0 ||
            _countryId != 0;
        final hasChanges = _hasSettingsChanged();

        // Debug logging for save button state
        print('[ChatSettingsScreen] Save button state:');
        print('  isLoading: $isLoading');
        print('  hasSettings: $hasSettings');
        print('  hasChanges: $hasChanges');
        print(
            '  Button enabled: ${!(isLoading || !hasSettings || !hasChanges)}');

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomElevatedButton(
            onPressed: (isLoading || !hasSettings || !hasChanges)
                ? () {}
                : _saveSettings,
            textButton: isLoading ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.save,
            height: 56.h,
            radius: 28.r,
            styleTextButton: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor:
                (isLoading || !hasSettings || !hasChanges) ? Colors.grey : null,
          ),
        );
      },
    );
  }

  void _saveSettings() {
    print('[ChatSettingsScreen] _saveSettings called');

    // Check if we have valid settings to save
    if (!_hasSettingsChanged()) {
      print('[ChatSettingsScreen] No changes detected, showing snackbar');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noChangesMade),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    print('[ChatSettingsScreen] Changes detected, creating request model');

    // Create request model
    final request = ChatSettingsRequestModel(
      fromAge: _fromAge,
      toAge: _toAge,
      nationalityId: _nationalityId,
      countryId: _countryId,
    );

    print('[ChatSettingsScreen] Request model: ${request.toJson()}');
    print(
        '[ChatSettingsScreen] Calling updateChatSettings via chat_settings_cubit');

    // Get current chat_settings_cubit state for debugging
    final currentState = context.read<ChatSettingsCubit>().state;
    print(
        '[ChatSettingsScreen] Current ChatSettingsCubit state: ${currentState.runtimeType}');

    // Update settings via API
    context.read<ChatSettingsCubit>().updateChatSettings(request);

    print(
        '[ChatSettingsScreen] updateChatSettings called, waiting for response...');
  }

  void _showAgeCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectAgeCategory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDialogOption(AppLocalizations.of(context)!.anyPerson, () {
              setState(() {
                _selectedAgeCategory = AppLocalizations.of(context)!.anyPerson;
                _fromAge = 0;
                _toAge = 0;
              });
              Navigator.pop(context);
            }),
            _buildDialogOption('18-25', () {
              setState(() {
                _selectedAgeCategory = '18-25';
                _fromAge = 18;
                _toAge = 25;
              });
              Navigator.pop(context);
            }),
            _buildDialogOption('26-35', () {
              setState(() {
                _selectedAgeCategory = '26-35';
                _fromAge = 26;
                _toAge = 35;
              });
              Navigator.pop(context);
            }),
            _buildDialogOption('36-45', () {
              setState(() {
                _selectedAgeCategory = '36-45';
                _fromAge = 36;
                _toAge = 45;
              });
              Navigator.pop(context);
            }),
            _buildDialogOption('45+', () {
              setState(() {
                _selectedAgeCategory = '45+';
                _fromAge = 45;
                _toAge = 100;
              });
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showNationalitiesDialog() {
    final listsCubit = context.read<ListsCubit>();
    final currentState = listsCubit.state;

    print('[ChatSettingsScreen] Opening nationalities dialog');
    print('[ChatSettingsScreen] Current ListsCubit state: $currentState');

    // Only load if not already loaded or loading
    if (currentState is ListsInitial) {
      print('[ChatSettingsScreen] Lists not loaded yet, loading now...');
      listsCubit.loadLists();
    } else if (currentState is ListsLoaded) {
      print(
          '[ChatSettingsScreen] Using cached data (${currentState.fromCache ? 'from cache' : 'from API'})');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectNationalities),
        content: Builder(
          builder: (context) {
            if (currentState is ListsLoaded) {
              print(
                  '[ChatSettingsScreen] Showing ${currentState.nationalities.length} nationalities');
              return SizedBox(
                width: double.maxFinite,
                height: 400, // Fixed height to prevent overflow
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Option for "All Nationalities"
                      _buildDialogOption(AppLocalizations.of(context)!.allNationalities, () {
                        setState(() {
                          _selectedNationalities = AppLocalizations.of(context)!.allNationalities;
                          _nationalityId = 0;
                        });
                        Navigator.pop(context);
                      }),
                      // Dynamic options from API
                      ...currentState.nationalities.map(
                        (nationality) => _buildDialogOption(
                          nationality.name,
                          () {
                            setState(() {
                              _selectedNationalities = nationality.name;
                              _nationalityId = nationality.id;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (currentState is ListsLoading ||
                currentState is ListsInitial) {
              print('[ChatSettingsScreen] Lists are loading...');
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.loadingNationalities),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.pleaseWait,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else if (currentState is ListsError) {
              print(
                  '[ChatSettingsScreen] Lists error: ${currentState.message}');
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.errorLoadingNationalities),
                      const SizedBox(height: 8),
                      Text(
                        currentState.message,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          listsCubit.loadLists();
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              print('[ChatSettingsScreen] Unknown state: $currentState');
              return  SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.help_outline, color: Colors.orange, size: 48),
                      SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.settingUpLists),
                      SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.pleaseWaitMoment,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showCountriesDialog() {
    final listsCubit = context.read<ListsCubit>();
    final currentState = listsCubit.state;

    print('[ChatSettingsScreen] Opening countries dialog');
    print('[ChatSettingsScreen] Current ListsCubit state: $currentState');

    // Only load if not already loaded or loading
    if (currentState is ListsInitial) {
      print('[ChatSettingsScreen] Lists not loaded yet, loading now...');
      listsCubit.loadLists();
    } else if (currentState is ListsLoaded) {
      print(
          '[ChatSettingsScreen] Using cached data (${currentState.fromCache ? 'from cache' : 'from API'})');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCountries),
        content: Builder(
          builder: (context) {
            if (currentState is ListsLoaded) {
              print(
                  '[ChatSettingsScreen] Showing ${currentState.countries.length} countries');
              return SizedBox(
                width: double.maxFinite,
                height: 400, // Fixed height to prevent overflow
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Option for "All Countries"
                      _buildDialogOption(AppLocalizations.of(context)!.allCountries, () {
                        setState(() {
                          _selectedCountries = AppLocalizations.of(context)!.allCountries;
                          _countryId = 0;
                        });
                        Navigator.pop(context);
                      }),
                      // Dynamic options from API
                      ...currentState.countries.map(
                        (country) => _buildDialogOption(
                          country.name,
                          () {
                            setState(() {
                              _selectedCountries = country.name;
                              _countryId = country.id;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (currentState is ListsLoading ||
                currentState is ListsInitial) {
              print('[ChatSettingsScreen] Lists are loading...');
              return  SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.loadingCountries),
                      SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.pleaseWait,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else if (currentState is ListsError) {
              print(
                  '[ChatSettingsScreen] Lists error: ${currentState.message}');
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.errorLoadingCountries),
                      const SizedBox(height: 8),
                      Text(
                        currentState.message,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          listsCubit.loadLists();
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              print('[ChatSettingsScreen] Unknown state: $currentState');
              return  SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.help_outline, color: Colors.orange, size: 48),
                      SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.settingUpLists),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.pleaseWaitMoment,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDialogOption(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
