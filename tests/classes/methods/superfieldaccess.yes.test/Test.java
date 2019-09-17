public class A {
    public A f;
}
public class B extends A {
    public A m() {
        return super.f;
    }
}
