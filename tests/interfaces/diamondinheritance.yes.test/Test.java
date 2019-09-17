public interface I {}
public interface J extends I {}
public interface K extends I {}
public class A implements J, K {}
public class Test {
    public I f = new A();
}
