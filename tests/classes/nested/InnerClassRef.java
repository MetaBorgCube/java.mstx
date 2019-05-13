class A { class B {} }
class B {}
class C {
    void m() {
        A a = new A();
        A.B ab = a.new B(); // B resolves in the type of a
    }
}
