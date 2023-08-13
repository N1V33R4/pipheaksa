import 'package:flutter/material.dart';
import 'package:pipheaksa/main.dart';

void showSnackBar(BuildContext context, String text) {
  // ScaffoldMessenger.of(context)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar(SnackBar(content: Text(text)));

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
