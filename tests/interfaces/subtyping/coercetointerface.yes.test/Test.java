public interface I {}
public class A implements I {}

public class B {
    public A a;
    public I m() {
        return this.a;
    }
}
