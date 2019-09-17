public interface I {}
public class A implements I {}
public class C {}
public class B {
    public C c;
    public I m() {
	    return this.c;
    }
}
