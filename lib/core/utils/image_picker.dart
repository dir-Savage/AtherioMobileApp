import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}