class A<X> {
    class I {}
}

class B<X> extends A<X> {}
class C<X> extends A<X> {}

class Test {
    void m() {
	C<Integer>.I i = new B<Integer>().new I();
    }
}
