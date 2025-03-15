import 'package:flutter/cupertino.dart';

abstract class Task {
  Future<void> run({BuildContext? context});
}
