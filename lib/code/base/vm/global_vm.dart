import '../../extras/user/vmbox/user_vm_box.dart';
import 'box/to_top_msg_vmbox.dart';

class GlobalVm {
  GlobalVm._privateConstructor();

  static final GlobalVm _instance = GlobalVm._privateConstructor();

  factory GlobalVm() {
    return _instance;
  }

  final Map<String, dynamic> globalCache = {};

  final UserVmBox userVmBox = UserVmBox();

  //final toTopMsgVmBox = ToTopMsgVmBox();

}
