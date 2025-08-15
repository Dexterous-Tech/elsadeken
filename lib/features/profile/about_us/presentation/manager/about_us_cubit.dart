import 'package:bloc/bloc.dart';
import 'package:elsadeken/features/profile/about_us/data/models/about_us_model.dart';
import 'package:elsadeken/features/profile/about_us/data/repo/abouts_us_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit(this.aboutsUsRepoInterface) : super(AboutUsInitial());

  final AboutsUsRepoInterface aboutsUsRepoInterface;

  static AboutUsCubit get(context) => BlocProvider.of(context);

  void aboutUs() async {
    emit(AboutUsLoading());

    var response = await aboutsUsRepoInterface.aboutUs();

    response.fold((error) {
      emit(AboutUsFailure(error.displayMessage));
    }, (aboutUsResponseModel) {
      emit(AboutUsSuccess(aboutUsResponseModel));
    });
  }
}
