import 'data_persistence.dart';
import 'db_sp.dart';

///数据持久化管理类
///具体功能或业务可继承此类实现
///@author slc
abstract class DpManager {
  late DataPersistence<dynamic> _dp;

  DpManager(String dpName) {
    _dp = createDp(dpName);
  }

  DataPersistence<dynamic> getDp() {
    return _dp;
  }

  DataPersistence<dynamic> createDp(String dpName) {
    return DbSp(dpName);
  }
}
