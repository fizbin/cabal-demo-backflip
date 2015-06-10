Backflip
--------

This is a stupid haskell package created to ask the question "why do I
need to list transitive dependencies in my `.cabal` file". Basically,
I have a library and an executable that uses that library. I want the
executable to just depend on the library, but it seems that it needs
to transitively depend on the library's dependencies as well.

When I try to build the package currently, this is the error I get:

    backflip fizbin$ cabal --version
    cabal-install version 1.22.0.0
    using version 1.22.0.0 of the Cabal library
    backflip fizbin$ cabal configure
    Resolving dependencies...
    Configuring backflip-0.1.0.0...
    backflip fizbin$ cabal build
    Building backflip-0.1.0.0...
    Preprocessing library backflip-0.1.0.0...
    [1 of 1] Compiling Fizbin.Test.Backflip ( src/Fizbin/Test/Backflip.hs, dist/build/Fizbin/Test/Backflip.o )
    [1 of 1] Compiling Fizbin.Test.Backflip ( src/Fizbin/Test/Backflip.hs, dist/build/Fizbin/Test/Backflip.p_o )
    In-place registering backflip-0.1.0.0...
    Preprocessing executable 'BackflipDemo' for backflip-0.1.0.0...

    src/Fizbin/Test/Backflip.hs:13:8:
        Could not find module ‘Data.Array.MArray’
        It is a member of the hidden package ‘array-0.5.0.0’.
        Perhaps you need to add ‘array’ to the build-depends in your .cabal file.
        Use -v to see a list of the files searched for.

    src/Fizbin/Test/Backflip.hs:14:8:
        Could not find module ‘Data.Array.ST’
        It is a member of the hidden package ‘array-0.5.0.0’.
        Perhaps you need to add ‘array’ to the build-depends in your .cabal file.
        Use -v to see a list of the files searched for.

What's going on here? Why can't cabal use the library version of
`backflip`, since the demo program itself doesn't depend on `array`
directly?
