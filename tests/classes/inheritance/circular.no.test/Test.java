/* Example 8.1.4-3: Circular dependency -> type error */
public class Point extends ColoredPoint {
    public int x, y;
}
public class ColoredPoint extends Point {
    public int color;
}
