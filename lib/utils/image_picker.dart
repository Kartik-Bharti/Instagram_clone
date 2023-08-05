import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<Uint8List?> pickimage(ImageSource imagesource, double y) async {
  final ImagePicker imagepicker = ImagePicker();
  final XFile? pickedimage = await imagepicker.pickImage(source: imagesource);

  if (pickedimage != null) {
    // We were not using File File(file.path); because its package "dart.io" is not supported in flutter web
    // return File(file.path);
    if (kDebugMode) print("Imaged pick sucessfully🤩🤩🤩");

    XFile? cropedimage = await croptosquare(pickedimage, y);
    if (cropedimage != null) {
      Uint8List? uploadableimage = await cropedimage.readAsBytes();
      return uploadableimage;
    }
  }

  if (kDebugMode) print("image not selected😕😕😕");
  return null;
}

Future<XFile?> croptosquare(XFile selectedimage, double y) async {
  CroppedFile? croppedimage = await ImageCropper().cropImage(
    sourcePath: selectedimage.path,
    compressQuality: 60,
    compressFormat: ImageCompressFormat.jpg,
    aspectRatioPresets: [CropAspectRatioPreset.square],
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: y),
  );

  if (croppedimage != null) return XFile(croppedimage.path);
  return null;
}
