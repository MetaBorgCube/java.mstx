interface I {}
class A implements I {}

class B {
    A a;
    I m() {
	return this.a;
    }
}
