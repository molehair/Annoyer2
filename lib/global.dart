// This file defines variables/classes used throughout the entire app

import 'package:flutter/material.dart';

enum ShowMessageType { notice, error }

class Global {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// show a message on the screen
  static void showMessage({
    required String msg,
    ShowMessageType type = ShowMessageType.notice,
  }) {
    BuildContext context = navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: type == ShowMessageType.error ? Colors.red[300] : null,
      ),
    );
  }

  /// show success dialog
  static void showSuccess() {
    BuildContext context = navigatorKey.currentContext!;
    double height = MediaQuery.of(context).size.height;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Icon(
          Icons.check,
          size: 32,
          color: Colors.white,
        ),
        margin: EdgeInsets.only(bottom: height / 3),
        duration: const Duration(milliseconds: 700),
        behavior: SnackBarBehavior.floating,
        shape: const CircleBorder(side: BorderSide.none),
        backgroundColor: Colors.green,
        // elevation: 100,
      ),
    );
  }

  /// show failure
  static void showFailure() {
    BuildContext context = navigatorKey.currentContext!;
    double height = MediaQuery.of(context).size.height;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Icon(
          Icons.clear,
          size: 32,
          color: Colors.white,
        ),
        margin: EdgeInsets.only(bottom: height / 3),
        duration: const Duration(milliseconds: 700),
        behavior: SnackBarBehavior.floating,
        shape: const CircleBorder(side: BorderSide.none),
        backgroundColor: Colors.red,
        // elevation: 100,
      ),
    );
  }

  /// remove non-word characters(,!? and so on)
  /// except hyphen
  static String removeSpecials(String sentence) {
    return sentence.replaceAll(RegExp(r'[!-,.-@\[-`\{-~]+'), ' ');
  }
}
