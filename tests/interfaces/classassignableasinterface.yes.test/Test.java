public interface I {}
public class A implements I {}
public class Test {
    public I f = new A();
}
