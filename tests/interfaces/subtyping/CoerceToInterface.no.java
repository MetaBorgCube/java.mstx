interface I {}
class A implements I {}
class C {}
class B {
    C c;
    I m() {
	return this.c;
    }
}
