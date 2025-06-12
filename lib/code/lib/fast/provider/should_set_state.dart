
/// @author sunlunchang
/// 用于标记是否需要刷新状态
class ShouldSetState {
  int _version = 0;

  int get version => _version;

  void updateVersion(){
    _version++;
  }
}
