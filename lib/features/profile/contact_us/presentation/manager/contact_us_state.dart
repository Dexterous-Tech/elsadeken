part of 'contact_us_cubit.dart';

abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final ProfileActionResponseModel responseModel;
  ContactUsSuccess(this.responseModel);
}

class ContactUsFailure extends ContactUsState {
  final String message;
  ContactUsFailure(this.message);
}
