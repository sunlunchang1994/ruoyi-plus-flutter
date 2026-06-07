import 'package:db_base/db_base/dp_manager.dart';

class {{Feature}}Config extends DpManager {
  {{Feature}}Config._privateConstructor() : super('{{feature}}_config');

  static final {{Feature}}Config _instance = {{Feature}}Config._privateConstructor();

  factory {{Feature}}Config() {
    return _instance;
  }

  void setEnabled(bool value) {
    getDp().putValue('enabled', value);
  }

  bool isEnabled() {
    return getDp().getBool('enabled', defValue: false) ?? false;
  }
}
