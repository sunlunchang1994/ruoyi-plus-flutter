import 'package:fluttertoast/fluttertoast.dart';

class AppToastBridge {
  static void showToast({msg = String}) {
    //BotToast.showText(text: msg);
    Fluttertoast.showToast(msg: msg);
  }
}
