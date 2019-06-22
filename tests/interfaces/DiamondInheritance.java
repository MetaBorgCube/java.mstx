interface I {}
interface J extends I {}
interface K extends I {}
class A implements J, K {}
class Test {
    I f = new A();
}
