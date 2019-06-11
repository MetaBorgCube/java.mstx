class A1 { class B {} }
class A2 extends A1 { class B {} }
class C {
    void m() {
        A2 a = new A2();
        A1.B b = ((A1)a).new B();
    }
}
