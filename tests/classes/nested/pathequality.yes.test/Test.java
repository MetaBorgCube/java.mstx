public class A {
    public class I {}
}

public class B extends A {}
public class C extends A {}

public class Test {
    public void m() {
        C.I i = new B().new I();
    }
}
