module Function.Extra where
{-| Higher-order helpers for working with functions.

# Higher-order helpers
@docs map, map2, map3, map4
@docs apply, andThen
@docs curry3, curry4, curry5
@docs uncurry3, uncurry4, uncurry5

-}

{-| Map into a function with a fixed input `x`. This function is just an alias for `(<<)`, the function composition operator.

    (Function.map f fa) == (f << fa)

The `(x -> ...)` pattern is sometimes refered to as a "Reader" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `map` to transform a "Reader" that produces an `a` into a "Reader" that produces a `b`.
-}
map : (a -> b) -> (x -> a) -> x -> b
map = (<<)

{-| Send a single argument `x` into a binary function using two intermediate mappings.
See also `apply`.

The `(x -> ...)` patterns are sometimes refered to as "Readers" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `map2` to read two variables from the environment `x` before applying them to a binary function `f`.
-}
map2 : (a -> b -> c) -> (x -> a) -> (x -> b) -> x -> c
map2 f fa fb x = f (fa x) (fb x)

{-| Send a single argument `x` into a ternary function using three intermediate mappings.

The `(x -> ...)` patterns are sometimes refered to as "Readers" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `map3` to read three variables from the environment `x` before applying them to a ternary function `f`.
-}
map3 : (a -> b -> c -> d) -> (x -> a) -> (x -> b) -> (x -> c) -> x -> d
map3 f fa fb fc x = f (fa x) (fb x) (fc x)

{-| Send a single argument `x` into a quaternary function using four intermediate mappings.
Use `apply` as an infix combinator in order to deal with a larger numbers of arguments.

The `(x -> ...)` patterns are sometimes refered to as "Readers" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `map4` to read four variables from the environment `x` before applying them to a quaternary function `f`.
-}
map4 : (a -> b -> c -> d -> e) -> (x -> a) -> (x -> b) -> (x -> c) -> (x -> d) -> x -> e
map4 f fa fb fc fd x = f (fa x) (fb x) (fc x) (fd x)

{-| Incrementally apply more functions, similar to `map*N*` where `*N*` is not fixed.

The `(x -> ...)` pattern is sometimes refered to as a "Reader" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `apply` to compose two function `f` and `fa` similar to `f << fa`, but instead passes the environment into both so that 

    (f `apply` g `apply` h) x == (f x << g x << h x)
-}
apply : (x -> a -> b) -> (x -> a) -> x -> b
apply f fa x = f x (fa x)

{-| Connect the result `a` of the first function to the first argument of the second function to form a pipeline.
Then, send `x` into each function along the pipeline in order to execute it in a sequential manner.

The `(x -> ...)` pattern is sometimes refered to as a "Reader" of `x`, where `x` represents some ancillary environment within which we would like to operate.
This allows `andThen` to repeatedly read from the environment `x` and send the result into to the next function, which in turn reads from the environment `x` again and so forth.

    (f `andThen` g `andThen` h) x == (h (g (f x) x) x)
-}
andThen : (x -> a) -> (a -> x -> b) -> x -> b
andThen fa f x = f (fa x) x

{-| Change how arguments are passed to a function.
This splits 3-tupled arguments into three separate arguments.
-}
curry3 : ((a,b,c) -> x) -> a -> b -> c -> x
curry3 f a b c = f (a,b,c)

{-| Change how arguments are passed to a function.
This splits 4-tupled arguments into four separate arguments.
-}
curry4 : ((a,b,c,d) -> x) -> a -> b -> c -> d -> x
curry4 f a b c d = f (a,b,c,d)

{-| Change how arguments are passed to a function.
This splits 5-tupled arguments into five separate arguments.
-}
curry5 : ((a,b,c,d,e) -> x) -> a -> b -> c -> d -> e -> x
curry5 f a b c d e = f (a,b,c,d,e)

{-| Change how arguments are passed to a function.
This combines three arguments into a single 3-tuple.
-}
uncurry3 : (a -> b -> c -> x) -> (a,b,c) -> x
uncurry3 f (a,b,c) = f a b c

{-| Change how arguments are passed to a function.
This combines four arguments into a single 4-tuple.
-}
uncurry4 : (a -> b -> c -> d -> x) -> (a,b,c,d) -> x
uncurry4 f (a,b,c,d) = f a b c d

{-| Change how arguments are passed to a function.
This combines five arguments into a single 5-tuple.
-}
uncurry5 : (a -> b -> c -> d -> e -> x) -> (a,b,c,d,e) -> x
uncurry5 f (a,b,c,d,e) = f a b c d e
