import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'code/my_app_page.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;//这句话很关键
  runApp(const MyApp());
}
