# Disambiguation

## Example

    package p;
    class A {
        class B {}
    }
    
    package t;
    class Test {
        p.A.B f; // <== a, A are pkg or type name
    }

## Current Rules

The current rules resolve to both package and type declarations, each
with the expected regular expression. However, 

    lexical-package-or-type-name(s, id, n) :- {names, id-names, id-names', p, l}
      query s `LEX*`EXT*`IMPL*`TYPE | `LEX*`PKG as names
    , filter names ((id', _) where id' == id) id-names
    , true // <== cannot express .*`TYPE < .*`PKG
    , min id-names
          lexico( `TYPE < `LEX, `TYPE < `EXT, `TYPE < `IMPL
                , `PKG < `LEX
                , `EXT < `IMPL, `EXT < `LEX
                , `IMPL < `LEX
                )
          id-names'
    , only(id-names', p)
    , tgt-lbl(p, l)
    , l match
        { `TYPE -> n == TYPE(p)
        | `PKG  -> n == PKG(p)
        }.

## Limitations in Mini-Statix

The general pattern is to resolve multiple relations at once, each
with their own regular expression. However, using the step-wise label
order we cannot prefer one relation over the other.

An easy and pragmatic solution would be to allow more expressive
(arbitrary?) orders over path labels. In this case, we initially want
to disambiguate only on the last label (which is the relation in 
Statix proper).

## Counter-part in Statix

This encoding cannot simply be translated to full Statix. It depends
on a few features of Mini-Statix that diverge from Statix.

First, in Mini-Statix there is no difference between the relation and
other edge labels. This allows us to query `PKG` and `TYPE` in a
single query. In Statix, this could only be achieved by putting types
and packages in the same relation.

Second, it is easy to allow arbitrary path orders in Mini-Statix,
since `min` is a separate operator. In Statix, this would mean the
name resolution algorithm needs to be changed, and it would (until we
find another solution) lose the cut-off feature that if we resolve a
declaration, we do not visit more parts of the graph. Even though the
experiments with Mini-Statix suggest that this might be less important
for completeness than we thought, it might mean a hit on performance.

Finally, the fact that Mini-Statix is untyped makes it easier to write
these patterns. Even if we would allow querying multiple relations in
Statix similar to Mini-Statix, we would need to reconcile the type of
the data. In the current typing scheme, it requires the same type for
`PKG` and `TYPE` (e.g. `Name * Type`). Of course adding a `PKG : scope
-> Type` is a pragmatic solution, but conceptually
questionable. Imagine requiring exhaustiveness and all relations over
types require a (bogus) case for `PKG` because at one point we query
types and package together.

Finally, we should note that in Statix we could encode this ambiguity
by trying the cases in order, matching on the result (which is a
list). However, since this is fundamentally unsound (the list answer
sets breaks confluence), we want a more principled solution.

## Desired Solution?

Ideally we would be able to query (in a single query) multiple
relations, and these queries should be able to have differently typed
data.

A related question is if we can make the scope graph model more
uniform, by taking either (scope edges + scope data), or (relations +
edges between scope-scope relations) as the primitive notion. The
first choice would probably require a notion of scope schemas or
something similar to be able to type specifications.

We could also provide a predicate/function argument to unify the
output of different relations. However, we may only want to do that
after minimization. In general, it seems that query may result
heterogeneous results, filtering is on heterogeneous results,
minimization is on paths/labels and independent of (potentially
heterogeneous) data. The query result may finally be made homogeneous
again, e.g. by returning the scopes of types or packages, which may
both be queried for type members.

## Notes

Scopes+data
+ easier to add properties to declarations (open world)
- not clear which properties are there, potential typing issues

Only relations
+ Clearly typed
- Querying multiple relations might require them to have the same types
- Spec design should consider 'extension points', where properties are
  necessary

Flow typing?
- Case distinction that reveals the relation and forces the type of
  the data
