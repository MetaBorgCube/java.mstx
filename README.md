# Statix Specification of (some of) Java's binding

Being a specification of the binding and typing of a subset of Java 11, focusing on some interesting binding features, such as packages, classes, and interfaces.

### Features

A more organized list of features based on the Java specfiication organization can be found in [./FEATURES.md](./FEATURES.md).
But some of the notable ones are:
 
- public packages
- public `class` definitions
- public fields/methods
- class extension
- inner classes
- literals
- variable declarations
- method calls
- return statements
- (qualified) `this` expressions
- casts on primitives and reference types
- variable assignment
- field access

Java examples that combine some of these features can be found in [./tests/comprehensive/](./tests/comprehensive). Tests that are comprised of multiple files are written in a single file format, and split into a directory structure by the test runner. [For example](./tests/packages/class-in-compilation-unit-shadows-on-demand-imported-class.yes.test):

```Java
[p/A.java]
package p;
import q.*;
public class A {
    // class in compilation unit shadows on demand imported class
    A a = (p.A) null;
}

[q/A.java]
package q;
public class A {
}
```

A personal favorite weird Java binding thing is [this gem](./tests/classes/inheritance/inheritedshadowself.no.test).

## Installation

Running the spec on Java programs requires MiniStatix, the Java Spoofax frontend, and
a Java compiler to be installed.

Instructions for MiniStatix can be found in the MiniStatix directory.

The Java Spoofax frontend can be build using the `javafront` make target.
This will download a Spoofax binary and build the parser in a project local directory.
 
## Usage

The root of the specification can be found in [src/java.mstx](./src/java.mstx).

This repository includes a handcrafted test suite of Java programs.
The parser understands a large subset of Java, but the type-specification is limited
to the features listed above.

You can run the entire test suite using:

    make test-clean test

You can run individual test cases using the `./run a/b/test.{yes,no}.test` 
script in the [./tests/](./tests/) directory.
This will run the java compiler on it (assuming it is installed) first.
The `yes/no` infix in the filename denotes whether the test is expected to typecheck or not.

Then the script will run the spoofax Java parser to produce an aterm, which
will then be fed into MiniStatix along with the specification entrypoint.

Finally the output of both type-checkers is compared to produce a test result.

# Notes on the implementation

This specification was developed as an expressivity case-study for MiniStatix.
MiniStatix implements a relatively small (core-like) language.
It does not, for example, offer any template-like facilities or 2nd-order constraints.
As a consequence this specification is more verbose than it needs to be;
e.g. mappings over lists are repeated spuriously.
For a more user-friendly specifiation the full Statix language has more useful features to be utilized.

A schema for the scope graph structure as specificied by the specification is
shown in [this diagram](doc/scopegraph.pdf).

## Scope schema

The following depicts a schema of the scoping structure of Java as implemented:

![Scope schema](./doc/scopegraph.pdf)

