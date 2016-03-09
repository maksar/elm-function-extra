module Function.Extra (..) where

{-| Higher-order helpers for working with functions.

# map, mapN, andMap, andThen
The `(x -> ...)` signatures are sometimes referred to as *"readers"* of `x`, where `x` represents some extra context are
function needs. We can map over readers similar to how we do for lists.

@docs map, map2, map3, map4, andMap, andThen

# Tuples
@docs both
## CurryN
@docs curry3, curry4, curry5
## UncurryN
@docs uncurry3, uncurry4, uncurry5

# Binary Functions
@docs on

-}


{-| Map into a function with a fixed input `x`. This function is just an alias for `(<<)`, the function composition operator.

    -- Note that `map` refers to Function.map not List.map!
    (f `map` g `map` h) == (f << g << h)

This allows `map` to transform a *"reader"* that produces an `a` into a *"reader"* that produces a `b`.
-}
map : (a -> b) -> (x -> a) -> x -> b
map =
  (<<)


{-| Send a single argument `x` into a binary function using two intermediate mappings.

    (map2 f ra rb) x == (f (ra x) (rb x)) x

This allows `map2` to read two variables from the environment `x` before applying them to a binary function `f`.
-}
map2 : (a -> b -> c) -> (x -> a) -> (x -> b) -> x -> c
map2 f ra rb x =
  f (ra x) (rb x)


{-| Send a single argument `x` into a ternary function using three intermediate mappings.

    (map3 f ra rb rc) x == (f (ra x) (rb x) (rc x)) x

This allows `map3` to read three variables from the environment `x` before applying them to a ternary function `f`.
-}
map3 : (a -> b -> c -> d) -> (x -> a) -> (x -> b) -> (x -> c) -> x -> d
map3 f ra rb rc x =
  f (ra x) (rb x) (rc x)


{-| Send a single argument `x` into a quaternary function using four intermediate mappings.
Use `andMap` as an infix combinator in order to deal with a larger numbers of arguments.

    (map4 f ra rb rc gd) x == (f (ra x) (rb x) (rc x) (gd x)) x

This allows `map4` to read four variables from the environment `x` before applying them to a quaternary function `f`.
-}
map4 : (a -> b -> c -> d -> e) -> (x -> a) -> (x -> b) -> (x -> c) -> (x -> d) -> x -> e
map4 f ra rb rc gd x =
  f (ra x) (rb x) (rc x) (gd x)


{-| Incrementally apply more functions, similar to `map`*N* where *N* is not fixed. This allows `andMap` to read an arbitrary number of arguments from the same environment `x`.

These are all equivalent:

    (f `andMap` ra `andMap` rb `andMap` rc) x
    f x (ra x) (rb x) (rc x)
    (map4 identity f ra rb rc) x
    (identity `map` f `andMap` ra `andMap` rb `andMap` rc) x

As are all of these:

    (f' `map` ra `andMap` rb `andMap` rc) x
    f' (ra x) (rb x) (rc x) x
    (map3 f' ra rb rc) x

Also notice the type signatures...

    ra                                      : x -> a
    rb                                      : x -> b
    rc                                      : x -> c

    f                                       : x -> a -> b -> c -> d
    (f `andMap` ra)                         : x -> b -> c -> d
    (f `andMap` ra `andMap` rb)             : x -> c -> d
    (f `andMap` ra `andMap` rb `andMap` rc) : x -> d

    f'                                      : a -> b -> c -> d
    (f' `map` ra)                           : x -> b -> c -> d
    (f' `map` ra `andMap` rb)               : x -> c -> d
    (f' `map` ra `andMap` rb `andMap` rc)   : x -> d

-}
andMap : (x -> a -> b) -> (x -> a) -> x -> b
andMap f ra x =
  f x (ra x)


{-| Connect the result `a` of the first function to the first argument of the second function to form a pipeline.
Then, send `x` into each function along the pipeline in order to execute it in a sequential manner.

This allows `andThen` to repeatedly read from the environment `x` and send the result into to the next function, which in turn reads from the environment `x` again and so forth.

    (f `andThen` g `andThen` h) x == (h (g (f x) x) x)
-}
andThen : (x -> a) -> (a -> x -> b) -> x -> b
andThen fa g x =
  g (fa x) x


{-| Map a function over both elements of a tuple.
-}
both : (a -> b) -> ( a, a ) -> ( b, b )
both f ( a1, a2 ) =
  ( f a1, f a2 )


{-| Change how arguments are passed to a function.
This splits 3-tupled arguments into three separate arguments.
-}
curry3 : (( a, b, c ) -> x) -> a -> b -> c -> x
curry3 f a b c =
  f ( a, b, c )


{-| Change how arguments are passed to a function.
This splits 4-tupled arguments into four separate arguments.
-}
curry4 : (( a, b, c, d ) -> x) -> a -> b -> c -> d -> x
curry4 f a b c d =
  f ( a, b, c, d )


{-| Change how arguments are passed to a function.
This splits 5-tupled arguments into five separate arguments.
-}
curry5 : (( a, b, c, d, e ) -> x) -> a -> b -> c -> d -> e -> x
curry5 f a b c d e =
  f ( a, b, c, d, e )


{-| Change how arguments are passed to a function.
This combines three arguments into a single 3-tuple.
-}
uncurry3 : (a -> b -> c -> x) -> ( a, b, c ) -> x
uncurry3 f ( a, b, c ) =
  f a b c


{-| Change how arguments are passed to a function.
This combines four arguments into a single 4-tuple.
-}
uncurry4 : (a -> b -> c -> d -> x) -> ( a, b, c, d ) -> x
uncurry4 f ( a, b, c, d ) =
  f a b c d


{-| Change how arguments are passed to a function.
This combines five arguments into a single 5-tuple.
-}
uncurry5 : (a -> b -> c -> d -> e -> x) -> ( a, b, c, d, e ) -> x
uncurry5 f ( a, b, c, d, e ) =
  f a b c d e


{-| Takes a binary function and a transformation. Returns a binary function that transforms its inputs first.

    (*) `on` f == \x y -> f x * f y
    sortBy (compare `on` fst) == sortBy (\x y -> fst x `compare` fst y)
-}
on : (b -> b -> c) -> (a -> b) -> a -> a -> c
on bi f x y =
  f x `bi` f y
