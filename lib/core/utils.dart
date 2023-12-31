import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pipheaksa/router.dart' show scaffoldMessengerKey;

void showSnackBar(String text) {
  // ScaffoldMessenger.of(context)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar(SnackBar(content: Text(text)));

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
