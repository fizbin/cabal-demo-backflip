Backflip
--------

**UPDATE**: *I have a solution, and the beginnings of a theory as to
  why that solution works. See Below.*

This is a stupid haskell package created to ask the question "why do I
need to list transitive dependencies in my `.cabal` file". Basically,
I have a library and an executable that uses that library. I want the
executable to just depend on the library, but it seems that it needs
to transitively depend on the library's dependencies as well.

When I tried to build the package initially, this was the error I got:

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

Solution
--------

The solution, it appears, is to not put `BackflipDemo.hs` in the same
directory as `Backflip.hs`. The reason is that if you do, when `cabal`
asks `ghc` to go compile `BackflipDemo.hs`, `ghc` will read it, see
the import of `Fizbin.Test.Backflip` and determine "hey, I can see
that source code right over here" and will attempt to compile the
library a second time, rather than attempting to link in the already
compiled version.

Therefore, I now have my `main` and my library code separated. I'll
need to think about how to apply this to the production situation this
question comes from.

The state of the repository currently reflects the "solved"
variant. To see what I started with, check out the repository at an
earlier commit.
