import '../../extras/mix/mix_manager.dart';
import '../../extras/user/vmbox/user_vm_box.dart';

/// @Author sunlunchang
/// 全局的vm，在系统初始化时就存在，多个模块的基础共享和缓存可在此处配置
/// 单利模式
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
