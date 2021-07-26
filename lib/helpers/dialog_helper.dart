import 'package:flutter/material.dart';
import 'package:lotto/widgets/checkedDialog.dart';


class DialogHelper {
  
  static exit(context,data) =>
      showDialog(context: context, builder: (context) => CheckedDialog(data,context));
}
