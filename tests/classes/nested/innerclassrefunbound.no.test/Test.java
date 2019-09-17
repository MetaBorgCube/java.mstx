public class A {
}
public class B {}
public class C {
    public void m() {
        A a = new A();
        A.B ab = a.new B(); // B resolves in the type of a
    }
}
