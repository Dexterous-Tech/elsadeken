import 'dart:io';

import 'package:dio/dio.dart';

class MyImageModel {
  final File? image;

  MyImageModel({this.image});

  FormData toFormData() {
    FormData formData = FormData.fromMap({
      'image': image != null
          ? MultipartFile.fromBytes(
              image!.readAsBytesSync(),
              filename:
                  image!.path.split('/').last, // Optional: Set the filename
            )
          : null,
    });
    return formData;
  }
}
