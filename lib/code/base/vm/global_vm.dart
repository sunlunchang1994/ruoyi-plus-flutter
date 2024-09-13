import '../../extras/mix/mix_manager.dart';
import '../../extras/user/vmbox/user_vm_box.dart';

class GlobalVm {
  GlobalVm._privateConstructor();

  static final GlobalVm _instance = GlobalVm._privateConstructor();

  factory GlobalVm() {
    return _instance;
  }

  final Map<String, dynamic> globalCache = {};

  final UserVmBox userVmBox = UserVmBox();

  //final mixManager = MixManager();

}
