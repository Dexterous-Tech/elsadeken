import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/profile/contact_us/data/models/contact_us_model.dart';
import 'package:elsadeken/features/profile/contact_us/data/repo/contact_us_repo.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this.contactUsRepoInterface) : super(ContactUsInitial());

  final ContactUsRepoInterface contactUsRepoInterface;

  static ContactUsCubit get(BuildContext context) => BlocProvider.of(context);

  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void contactUs() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    emit(ContactUsLoading());

    var response = await contactUsRepoInterface.contactUs(ContactUsModel(
      email: emailController.text,
      title: titleController.text,
      description: descriptionController.text,
    ));

    response.fold(
      (error) {
        emit(ContactUsFailure(error.displayMessage));
      },
      (contactUsResponseModel) {
        emit(ContactUsSuccess(contactUsResponseModel));
        // Clear form after success
        clearForm();
      },
    );
  }

  void clearForm() {
    emailController.clear();
    titleController.clear();
    descriptionController.clear();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
