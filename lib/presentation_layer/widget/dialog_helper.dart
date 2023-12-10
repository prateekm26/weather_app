import 'package:flutter/material.dart';

class DialogHelper {
  Future<void> showRetryAlertDialog(BuildContext context,
      {VoidCallback? retry}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Do you want to retry?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                retry!();
              },
            ),
          ],
        );
      },
    );
  }
}
