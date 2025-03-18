//Future 扩展，用于将处理数据转换
extension FutureExpand<T> on Future<T> {

  Stream<S> asMap<S>(S Function(T event) convert) {
    return asStream().map(convert);
  }


  Future<S> asMap2Single<S>(S Function(T event) convert) {
    return asMap(convert).single;
  }

}