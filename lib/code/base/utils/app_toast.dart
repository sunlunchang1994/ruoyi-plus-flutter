import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToastBridge {
  static void showToast({msg = String}) {
    //BotToast.showText(text: msg);
    Fluttertoast.showToast(msg: msg,backgroundColor: Colors.black54);
  }
}
