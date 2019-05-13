class A {
    class B {}
    class C {}  }
class B {}
class C {
    void m() {
        A a = new A();
        A.B ab = a.new C(); // B resolves in the type of a
    }
}
