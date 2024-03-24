class Custom_Point {
  final double x;
  final double y;

  Custom_Point(this.x, this.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';
}