/* Example 8.1.4-3: Circular dependency -> type error */
class Point extends ColoredPoint { int x, y; }
class ColoredPoint extends Point { int color; }
