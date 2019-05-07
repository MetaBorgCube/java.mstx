class A {
    A f;
}
class B extends A {
    A m() {
	return super.f;
    }
}
