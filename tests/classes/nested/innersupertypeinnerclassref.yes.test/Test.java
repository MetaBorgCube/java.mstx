public class A {
    public class B {
    }
}
public class C extends A {
}
public class T {
    public void m() {
        C c = new C();
        c.new B();
    }
}
