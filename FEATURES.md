# Java Specification

A Mini Statix specification for a subset of Java. The aim is to
support interesting name binding features.

The following shows which features of the JLS we implement. Anything
listed between square brackets is omitted.

* 3 Lexical Structure
* 4 Types, Values, and Variables
  - ??? (whatever is relevant for the rest)
* 5 Conversions and Contexts
  - ??? (whatever is relevant for the rest)
* 6 Names
  - ??? (whatever is relevant for the rest)
* 7 Packages
  * 7.1 Package members
    - packages
    - type members
      - classes
      - [interfaces] ???
  * 7.3 Compilation units
  * 7.4 Package declarations
    - named
    - unnamed
  * 7.5 Import Declarations
    * 7.5.1 Single-Type-Import Declarations
    * 7.5.2 Type-Import-on-Demand Declarations
    * 7.5.3 [Single-Static-Import Declarations]
    * 7.5.4 [Static-Import-on-Demand Declarations]
* 8 Classes
  * 8.1 Class Declarations
    * 8.1.1 Class Modifiers
      - public
      - [protected, private, package, abstract, static, final, strictfp]
    * 8.1.2 [Generic Classes and Type Parameters]
    * 8.1.3 Inner Classes
    * 8.1.4 Superclasses and Subclasses
    * 8.1.6 Class Body and Member Declarations
  * 8.2 Class Members
  * 8.3 Field Declarations
    * 8.3.1 Field Modifiers
      - public
      - [protected, package, private, static, final, transient, volatile]
    * 8.3.2 Field Initialization
      - variable initializer
      - [class variables]
      - instance variables
    * 8.3.3 [Restrictions on Field References in Initializers]
  * 8.4 Method Declarations
    * 8.4.1 Formal Parameters
      - [final]
      - [variable arity parameter]
    * 8.4.3 Method Signature
    * 8.4.3 Method Modifiers
      - public
      - [protected, private, package, abstract, static, final, synchronized, native, strictfp]
    * 8.4.4 [Generic Methods]
    * 8.4.5 Method Result
      - type
      - void
    * 8.4.6 [Method Throws]
    * 8.4.7 Method Body
    * 8.4.8 Inheritance, Overriding, and Hiding
      - inherited methods
      * 8.4.8.1 [Overriding]
      * 8.4.8.2 [Hiding]
      * 8.4.8.3 [Requirements in Overriding and Hiding]
      * 8.4.8.4 [Inheriting Methods with Override-Equivalent Signatures]
    * 8.4.9 [Overloading]
  * 8.5 Member type declarations
    - member class
    - [member interface] ???
    * 8.5.1 [Static Member Type Declarations]
  * 8.6 [Instance Initializers]
  * 8.7 [Static Initializers]
  * 8.8 Constructor Declarations
    * 8.8.1 Formal Parameters
    * 8.8.2 Constructor Signature
    * 8.8.3 Constructor Modifiers
      - public
      - [protected, package, private]
    * 8.8.4 [Generic Constructors]
    * 8.8.5 [Constructor Throws]
    * 8.8.6 Type of a Constructor
    * 8.8.7 Constructor Body
      * 8.8.7.1 [Explicit Constructor Invokations]
    * 8.8.8 [Constructor Overloading]
    * 8.8.9 [Default Constructor]
    * 8.8.10 [Preventing Instantiation of a Class]
  * 8.9 [Enum types]
* 9 [Interfaces]
* 10 [Arrays]
* 11 [Exceptions]
* 12 [Execution]
* 13 [Binary Compatibility]
* 14 Blocks and Statements
  * 14.1 [Normal and Abrupt Completion of Statements]
  * 14.2 Blocks
  * 14.3 Local Class Declarations ???
  * 14.4 Local Variable Declarations
    - [final]
  * 14.5 Statements
  * 14.6 Empty Statement
  * 14.7 [Labeled Statements]
  * 14.8 Expression Statements
  * 14.9 [The `if` Statement]
  * 14.10 [The `assert` Statement]
  * 14.11 [The `switch` Statement]
  * 14.12 [The `while` Statement]
  * 14.13 [The `do` Statement]
  * 14.14 [The `for` Statement]
  * 14.15 [The `break` Statement]
  * 14.16 [The `continue` Statement]
  * 14.17 The `return` Statement
  * 14.18 [The `throw` Statement]
  * 14.19 [The `synchronized` Statement]
  * 14.20 [The `try` Statement]
  * 14.21 [Unreachable Statements]
* 15 Expressions
  * 15.1 [Evaluation, Denotation, and Result]
  * 15.2 Forms of Expressions
  * 15.3 Type of an Expression
  * 15.4 [FP-strict Expressions]
  * 15.5 [Expressions and Run-Time Checks]
  * 15.6 [Normal and Abrupt Completion of Evaluation]
  * 15.7 [Evaluation Order]
  * 15.8 Primary Expressions
    * 15.8.1 [Lexical Literals]
    * 15.8.2 [Class Literals]
    * 15.8.3 `this`
    * 15.8.4 Qualified `this` ???
    * 15.8.5 Parenthesized Expressions
  * 15.9 Class Instance Creation Expressions
    * 15.9.1 Determining the Class being Instantiated
    * 15.9.2 Determining Enclosing Instances
    * 15.9.3 Choosing the Constructor and its Arguments
    * 15.9.4 [Run-Time Evaluation of Class Instance Creation Expressions]
    * 15.9.5 [Anonymous Class Declarations]
  * 15.10 [Array Creation and Access Expressions]
  * 15.11 Field Access Expressions
    * 15.11.1 Field Access Using a Primary
    * 15.11.2 [Accessing Superclass Members using `super`]
  * 15.12 Method Invocation Expressions
    - [overloading]
  * 15.13 [Method Reference Expressions]
  * 15.14 [Postfix Expressions]
  * 15.15 [Unary Expression]
  * 15.16 Cast Expression
  * 15.17 [Multiplicative Operators]
  * 15.18 [Additive Operators]
  * 15.19 [Shift Operators]
  * 15.20 [Relational Operators]
  * 15.21 [Equality Operators]
  * 15.22 [Bitwise and Logical Operators]
  * 15.23 [Conditional-And Operator `&&`]
  * 15.24 [Conditional-Or Operator `||`]
  * 15.25 [Conditional Operator `?:`]
  * 15.26 Assignment Operators
    * 15.26.1 Simple Assignment Operator
    * 15.26.2 [Compound Assignment Operators]
  * 15.27 [Lambda Expressions]
  * 15.28 [Constant Expressions]
* 16 [Definite Assignment]
* 17 [Threads and Locks]
* 18 Type Inference
  - ???
* 19 Syntax
