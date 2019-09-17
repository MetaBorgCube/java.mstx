public class A {
    public class B {}
}
public class B extends A {
    public B m() {
        return this; // error
    }
}
