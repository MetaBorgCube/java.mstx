public class A1 {
    public class B {}
}
public class A2 extends A1 {
    public class B {}
}
public class C {
    public void m() {
        A2 a = new A2();
        A1.B b = ((A1)a).new B();
    }
}
