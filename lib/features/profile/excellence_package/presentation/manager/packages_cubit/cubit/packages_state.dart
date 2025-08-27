import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';

abstract class PackagesState {
  const PackagesState();
}

class PackagesInitial extends PackagesState {}

class GetPackagesLoading extends PackagesState {}

class GetPackagesSuccess extends PackagesState {
  final PackagesModel packages;

  const GetPackagesSuccess(this.packages);
}

class GetPackagesFailure extends PackagesState {
  final String error;

  const GetPackagesFailure(this.error);
}

class AssignPackageLoading extends PackagesState {}

class AssignPackageSuccess extends PackagesState {
  final PackagesModel response;

  const AssignPackageSuccess(this.response);
}

class AssignPackageFailure extends PackagesState {
  final String error;

  const AssignPackageFailure(this.error);
}
