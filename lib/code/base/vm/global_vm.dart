import 'package:ruoyi_plus_flutter/code/feature/component/dict/vm/dict_share_vm.dart';

import '../../feature/bizapi/user/vm/user_vm_box.dart';

/// @author sunlunchang
/// 全局的vm，在系统初始化时就存在，多个模块的基础共享和缓存可在此处配置
/// 单利模式
class GlobalVm {
  GlobalVm._privateConstructor();

  static final GlobalVm _instance = GlobalVm._privateConstructor();

  factory GlobalVm() {
    return _instance;
  }

  final Map<String, dynamic> globalCache = {};

  final UserShareVm userShareVm = UserShareVm();

  final DictShareVm dictShareVm = DictShareVm();

  //final mixManager = MixManager();

}
