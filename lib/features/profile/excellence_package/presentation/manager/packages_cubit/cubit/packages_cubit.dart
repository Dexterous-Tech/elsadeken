import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/profile/excellence_package/data/repo/packages_repo.dart';
import 'packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepoInterface packagesRepo;

  PackagesCubit(this.packagesRepo) : super(PackagesInitial());

  Future<void> getPackages() async {
    emit(GetPackagesLoading());
    final result = await packagesRepo.getPackages();
    result.fold(
      (error) => emit(GetPackagesFailure(error.message ?? "Unknown error")),
      (packages) => emit(GetPackagesSuccess(packages)),
    );
  }

  Future<void> assignPackageToUser(String id) async {
    emit(AssignPackageLoading());
    final result = await packagesRepo.assignPackageToUser(id);
    result.fold(
      (error) => emit(AssignPackageFailure(error.message ?? "Unknown error")),
      (response) => emit(AssignPackageSuccess(response)),
    );
  }
}
