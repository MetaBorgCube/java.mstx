class A {
    class I {}
}

class B extends A {}
class C {}

class Test {
    void m() {
	C.I i = new B().new I();
    }
}
