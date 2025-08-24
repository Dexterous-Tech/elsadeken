import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:elsadeken/features/profile/my_image/data/model/my_image_model.dart';
import 'package:elsadeken/features/profile/my_image/data/repo/my_image_repo%20.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'my_image_state.dart';

class MyImageCubit extends Cubit<MyImageState> {
  MyImageCubit(this.myImageRepoInterface) : super(MyImageInitial());

  final MyImageRepoInterface myImageRepoInterface;

  File? image;
  final ImagePicker _picker = ImagePicker();

  void pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(MyImageImageSelected(image!));
      }
    } catch (e) {
      emit(MyImageFailure('فشل في اختيار الصورة من المعرض'));
    }
  }

  void pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(MyImageImageSelected(image!));
      }
    } catch (e) {
      emit(MyImageFailure('فشل في التقاط الصورة من الكاميرا'));
    }
  }

  void updateImage() async {
    if (image == null) {
      emit(MyImageFailure('يرجى اختيار صورة أولاً'));
      return;
    }

    emit(MyImageLoading());

    var response =
        await myImageRepoInterface.updateImage(MyImageModel(image: image));

    response.fold((l) {
      emit(MyImageFailure(l.displayMessage));
    }, (r) {
      emit(MyImageSuccess(r));
    });
  }

  void deleteImage() {
    image = null;
    emit(MyImageInitial());
  }
}
