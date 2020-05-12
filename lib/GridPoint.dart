class GridPoint {
  GridPoint(this.x, this.y);
  int x;
  int y;

  bool operator == (other) {
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode + y.hashCode;
}