import 'package:flutter/material.dart';
import 'package:swa/core/utilts/My_Colors.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return  AlertDialog(
          content: Row(
            children: [
              Text(
                "Loading...",
                style: TextStyle(color: MyColors.primaryColor),
              ),
              Spacer(),
              CircularProgressIndicator(),
            ],
          ),
        );
      });
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:  Text(
            "Error",
            style: TextStyle(color: MyColors.darkRed),
          ),
          content: Text(
            errorMessage,
            style: TextStyle(color: MyColors.white),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      });
}