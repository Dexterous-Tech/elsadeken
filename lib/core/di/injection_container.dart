import 'package:elsadeken/features/auth/forget_password/data/data_source/forget_data_source.dart';
import 'package:elsadeken/features/auth/forget_password/data/repo/forget_repo.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:elsadeken/features/auth/login/data/data_source/login_data_source.dart';
import 'package:elsadeken/features/auth/login/data/repo/login_repo.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:elsadeken/features/auth/new_password/data/data_source/reset_password_data_source.dart';
import 'package:elsadeken/features/auth/new_password/data/repo/reset_password_repo.dart';
import 'package:elsadeken/features/auth/new_password/presentation/manager/reset_password_cubit.dart';
import 'package:elsadeken/features/auth/signup/data/data_source/signup_data_source.dart';
import 'package:elsadeken/features/auth/signup/data/repo/signup_repo.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/verification_email/data/data_source/verification_data_source.dart';
import 'package:elsadeken/features/auth/verification_email/data/repo/verification_repo.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'package:elsadeken/features/chat/data/datasources/chat_list_data_source.dart';
import 'package:elsadeken/features/chat/data/repositories/chat_list_repo.dart';
import 'package:elsadeken/features/chat/presentation/manager/cubit/chatListCubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/home/notification/data/data_source/notification_data_source.dart';
import 'package:elsadeken/features/home/notification/data/repo/notification_repo.dart';
import 'package:elsadeken/features/home/notification/presentation/manager/notification_count_cubit.dart';
import 'package:elsadeken/features/home/notification/presentation/manager/notification_cubit.dart';
import 'package:elsadeken/features/profile/about_us/data/data_source/about_us_data_source.dart';
import 'package:elsadeken/features/profile/about_us/data/repo/abouts_us_repo.dart';
import 'package:elsadeken/features/profile/about_us/presentation/manager/about_us_cubit.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/data_source/terms_and_conditions_data_source.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/repo/terms_and_conditions_repo.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/presentation/manager/terms_and_conditions_cubit.dart';
import 'package:elsadeken/features/profile/contact_us/data/data_source/contact_us_data_source.dart';
import 'package:elsadeken/features/profile/contact_us/data/repo/contact_us_repo.dart';
import 'package:elsadeken/features/profile/contact_us/presentation/manager/contact_us_cubit.dart';
import 'package:elsadeken/features/profile/blog/data/datasources/blog_api.dart';
import 'package:elsadeken/features/profile/blog/data/repository/blog_repo_impl.dart';
import 'package:elsadeken/features/profile/blog/domain/repository/blog_repo.dart';
import 'package:elsadeken/features/profile/blog/domain/use_cases/get_blog_posts.dart';
import 'package:elsadeken/features/profile/blog/presentation/cubit/blog_cubit.dart';
import 'package:elsadeken/features/profile/interests_list/data/data_source/fav_user_data_source.dart';
import 'package:elsadeken/features/profile/interests_list/data/repo/fav_user_repo.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/data/data_source/manage_profile_data_source.dart';
import 'package:elsadeken/features/profile/manage_profile/data/repo/manage_profile_repo.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/features/profile/my_image/data/data_source/my_image_data_source.dart';
import 'package:elsadeken/features/profile/my_image/data/repo/my_image_repo%20.dart';
import 'package:elsadeken/features/profile/my_image/presentation/manager/my_image_cubit.dart';
import 'package:elsadeken/features/profile/my_interesting_list/data/data_source/interesting_list_data_source.dart';
import 'package:elsadeken/features/profile/my_interesting_list/data/repo/interesting_list_repo.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_cubit.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/data/data_source/ignore_user_data_source.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/data/repo/ignore_user_repo.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_cubit.dart';
import 'package:elsadeken/features/profile/profile/data/data_source/profile_data_source.dart';
import 'package:elsadeken/features/profile/profile/data/repo/profile_repo.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/data/data_source/profile_details_data_source.dart';
import 'package:elsadeken/features/profile/profile_details/data/repo/profile_details_repo.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/success_stories/data/datasources/success_story_api.dart';
import 'package:elsadeken/features/profile/success_stories/data/repository/success_story_repo_impl.dart';
import 'package:elsadeken/features/profile/success_stories/domain/repository/success_storie_repo.dart';
import 'package:elsadeken/features/profile/success_stories/domain/use_cases/get_success_story.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/profile/profile/presentation/manager/notification_settings_cubit.dart';
import '../../features/search/logic/use_cases/search_use_cases.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../networking/api_services.dart';
import '../networking/dio_factory.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Dio using DioFactory
  final dio = await DioFactory.getDio();

  // Register Dio as a singleton first
  sl.registerSingleton<Dio>(dio);

  // Register ApiServices as a singleton
  sl.registerSingleton<ApiServices>(ApiServices.internal(dio));

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<Dio>()),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchUseCase(sl()));

  // Cubit
  sl.registerFactory(() => SearchCubit(sl()));

  // blog
  sl.registerLazySingleton<BlogApi>(() => BlogApi(sl()));
  sl.registerLazySingleton<BlogRepo>(() => BlogRepoImpl(sl()));
  sl.registerLazySingleton<GetBlogPosts>(() => GetBlogPosts(sl()));
  sl.registerFactory<BlogCubit>(() => BlogCubit(sl()));

  // success stories
  sl.registerLazySingleton<SuccessStoryApi>(() => SuccessStoryApi(sl()));
  sl.registerLazySingleton<GetSuccessStories>(() => GetSuccessStories(sl()));
  sl.registerLazySingleton<SuccessStoryRepository>(
      () => SuccessStoryRepositoryImpl.create(sl()));
  sl.registerFactory<SuccessStoryCubit>(() => SuccessStoryCubit(sl()));

  // login
  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSource(sl()));
  sl.registerLazySingleton<LoginRepoInterface>(
      () => LoginRepoImplementation(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));

  //forget
  sl.registerLazySingleton<ForgetDataSource>(() => ForgetDataSource(sl()));
  sl.registerLazySingleton<ForgetRepoInterface>(
      () => ForgetRepoImplementation(sl()));
  sl.registerFactory<ForgetCubit>(() => ForgetCubit(sl()));

  //verification
  sl.registerLazySingleton<VerificationDataSource>(
      () => VerificationDataSource(sl()));
  sl.registerLazySingleton<VerificationRepoInterface>(
      () => VerificationRepoImplementation(sl()));
  sl.registerFactory<VerificationCubit>(() => VerificationCubit(sl()));

  //reset password
  sl.registerLazySingleton<ResetPasswordDataSource>(
      () => ResetPasswordDataSource(sl()));
  sl.registerLazySingleton<ResetPasswordRepoInterface>(
      () => ResetPasswordRepoImplementation(sl()));
  sl.registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(sl()));

  // signup
  sl.registerLazySingleton<SignupDataSource>(() => SignupDataSource(sl()));
  sl.registerLazySingleton<SignupRepoInterface>(
      () => SignupRepoImplementation(sl()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl()));
  sl.registerFactory<SignUpListsCubit>(() => SignUpListsCubit(sl()));

  // about us
  sl.registerLazySingleton<AboutUsDataSource>(() => AboutUsDataSource(sl()));
  sl.registerLazySingleton<AboutsUsRepoInterface>(() => AboutsUsRepoImpl(sl()));
  sl.registerFactory<AboutUsCubit>(() => AboutUsCubit(sl()));

  // terms and conditions (on_boarding)
  sl.registerLazySingleton<TermsAndConditionsDataSource>(
      () => TermsAndConditionsDataSource(sl()));
  sl.registerLazySingleton<TermsAndConditionsRepoInterface>(
      () => TermsAndConditionsRepoImpl(sl()));
  sl.registerFactory<TermsAndConditionsCubit>(
      () => TermsAndConditionsCubit(sl()));

  // contact us
  sl.registerLazySingleton<ContactUsDataSource>(
      () => ContactUsDataSource(sl()));
  sl.registerLazySingleton<ContactUsRepoInterface>(
      () => ContactUsRepoImplementation(sl()));
  sl.registerFactory<ContactUsCubit>(() => ContactUsCubit(sl()));

  // profile
  sl.registerLazySingleton<ProfileDataSource>(() => ProfileDataSource(sl()));
  sl.registerLazySingleton<ProfileRepoInterface>(() => ProfileRepoImp(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  // manage profile
  sl.registerLazySingleton<ManageProfileDataSource>(
      () => ManageProfileDataSource(sl()));
  sl.registerLazySingleton<ManageProfileRepoInterface>(
      () => ManageProfileRepoImp(sl()));
  sl.registerFactory<ManageProfileCubit>(() => ManageProfileCubit(sl()));
  sl.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(sl()));

  // Profile Details
  sl.registerLazySingleton<ProfileDetailsDataSource>(
      () => ProfileDetailsDataSource(sl()));
  sl.registerLazySingleton<ProfileDetailsRepoInterface>(
      () => ProfileDetailsRepoImp(sl()));
  sl.registerFactory<ProfileDetailsCubit>(() => ProfileDetailsCubit(sl()));

  // My Intersets Users
  sl.registerLazySingleton<FavUserDataSource>(() => FavUserDataSource(sl()));
  sl.registerLazySingleton<FavUserRepoInterface>(() => FavUserRepoImpl(sl()));
  sl.registerFactory<FavUserCubit>(() => FavUserCubit(sl()));

  // My Interesting Users
  sl.registerLazySingleton<InterestingListDataSource>(
      () => InterestingListDataSource(sl()));
  sl.registerLazySingleton<InterestingListRepo>(
      () => InterestingRepoImpl(sl()));
  sl.registerFactory<InterestingListCubit>(() => InterestingListCubit(sl()));

  // My Ignore Users
  sl.registerLazySingleton<IgnoreUserDataSource>(
      () => IgnoreUserDataSource(sl()));
  sl.registerLazySingleton<IgnoreUserRepoInterface>(
      () => IgnoreUserRepoImpl(sl()));
  sl.registerFactory<IgnoreUserCubit>(() => IgnoreUserCubit(sl()));

  // My Image
  sl.registerLazySingleton<MyImageDataSource>(() => MyImageDataSource(sl()));
  sl.registerLazySingleton<MyImageRepoInterface>(() => MyImageRepoImp(sl()));
  sl.registerFactory<MyImageCubit>(() => MyImageCubit(sl()));

  //Members
  sl.registerLazySingleton<MembersRepository>(() => MembersRepository());

  // notification
  sl.registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationRepoInterface>(
      () => NotificationRepoImp(sl()));
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(sl()));
  sl.registerFactory<NotificationCountCubit>(
      () => NotificationCountCubit(sl()));
  sl.registerFactory<NotificationSettingsCubit>(
      () => NotificationSettingsCubit());

  // Chat
  sl.registerLazySingleton<ChatListDataSource>(
      () => ChatListDataSource(sl()));
  sl.registerLazySingleton<ChatListRepoInterface>(
      () => ChatListRepoImpl(sl()));
  sl.registerFactory<ChatListCubit>(() => ChatListCubit(sl()));

}
