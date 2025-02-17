///树导航实体类
class SlcTreeNav {
  dynamic id;
  String treeName;
  bool? popNoAnimator;

  SlcTreeNav(this.id, this.treeName, {this.popNoAnimator});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlcTreeNav && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
