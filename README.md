# Statix Specification of (some of) Java's binding

We specify the binding of Scala objects with the various imports in Scala in Statix.
The following features are specified:

### Compound objects

- public packages
- public `interface` definitions
- public `class` definitions
- public fields/methods
- class extension
- nested and inner classes
- interface implementation

### Statements and expressions

- literals
- variable declarations
- method calls
- return statements
- `this` expressions
- Qualified `this`
- Casts on primitives and reference types
- Variable assignment
- Field access

## Installation

Running the spec on Java programs requires MiniStatix, the Java Spoofax frontend, and
a Java compiler to be installed.

Instructions for MiniStatix can be found in the 
[MiniStatix](https://github.com/metaborg/ministatix.hs/) repository.

The Java Spoofax frontend can be build using the `javafront` make target.
This will download a Spoofax binary and build the parser in a project local directory.

If this recipe does not work for you, please report an 
[issue](https://github.com/metaborg/ministatix.hs/issues).
 
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

## Ambiguous names

TODO

## Packages

TODO

##
