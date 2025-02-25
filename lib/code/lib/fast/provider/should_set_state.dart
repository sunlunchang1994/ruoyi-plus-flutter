class ShouldSetState {
  int _version = 0;

  int get version => _version;

  void updateVersion(){
    _version++;
  }
}
