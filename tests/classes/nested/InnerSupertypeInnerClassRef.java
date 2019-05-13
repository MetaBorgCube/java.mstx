class A {
    class B {
    }
}
class C extends A {
}
class T {
    void m() {
        C c = new C();
        c.new B();
    }
}
