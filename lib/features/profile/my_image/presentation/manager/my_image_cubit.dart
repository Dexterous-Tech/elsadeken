import 'dart:io';

import 'package:elsadeken/core/shared/shared_preferences_helper.dart';

import 'package:elsadeken/features/profile/my_image/data/model/my_image_model.dart';
import 'package:elsadeken/features/profile/my_image/data/repo/my_image_repo.dart';
import 'package:elsadeken/features/profile/profile/data/models/profile_action_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
      print('Gallery pick error: $e');
      if (e.toString().contains('permission')) {
        emit(MyImageFailure(
            'يرجى منح إذن الوصول إلى المعرض في إعدادات التطبيق'));
      } else {
        emit(MyImageFailure('فشل في اختيار الصورة من المعرض: ${e.toString()}'));
      }
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
      print('Camera pick error: $e');
      if (e.toString().contains('permission')) {
        emit(MyImageFailure(
            'يرجى منح إذن الوصول إلى الكاميرا في إعدادات التطبيق'));
      } else if (e.toString().contains('camera')) {
        emit(MyImageFailure(
            'فشل في فتح الكاميرا. تأكد من أن الكاميرا تعمل بشكل صحيح'));
      } else {
        emit(MyImageFailure(
            'فشل في التقاط الصورة من الكاميرا: ${e.toString()}'));
      }
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

    response.fold((l) async {
      emit(MyImageFailure(l.displayMessage));
    }, (r) async {
      final newImageUrl = r.data?.image ?? '';
      if (newImageUrl.isNotEmpty) {
        await SharedPreferencesHelper.deleteUserImage();
        await SharedPreferencesHelper.saveUserImage(newImageUrl);
      }
      emit(MyImageSuccess(r));
    });
  }

  void deleteImage() {
    image = null;
    emit(MyImageInitial());
  }

  void updateImageSetting(String photoVisibility) async {
    emit(UpdateImageSettingLoading());

    var response = await myImageRepoInterface.updateImageSetting(
      UpdateImageSetting(photoVisibility: photoVisibility),
    );

    response.fold((l) {
      emit(UpdateImageSettingFailure(l.displayMessage));
    }, (r) {
      emit(UpdateImageSettingSuccess(r));
    });
  }
}
