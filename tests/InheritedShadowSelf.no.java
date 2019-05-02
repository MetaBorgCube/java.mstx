class A { class B {} }
class B extends A {
    B m() {
        return this; // error
    }
}
