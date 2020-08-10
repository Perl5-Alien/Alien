# Alien

External libraries wrapped up for your viewing pleasure!

# SYNOPSIS

```
% perldoc Alien
```

# DESCRIPTION

The intent of the Alien namespace is to provide a mechanism for specifying,
installing and using non-native dependencies on CPAN.  Frequently this is
a C library used by XS (see [perlxs](https://metacpan.org/pod/perlxs)) or FFI (see [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus)), but
it could be anything non-Perl usable from Perl.

Typical characteristics of an Alien distribution include:

- Probe for or install library during the build process

    Usually this means that [Module::Build](https://metacpan.org/pod/Module::Build) or [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) will
    be extended to probe for an existing system library that meets the
    criteria of the Alien module.  If it cannot be found the library is
    downloaded from the Internet and installed into a share directory (See
    [File::ShareDir](https://metacpan.org/pod/File::ShareDir)).

    Usually, though not necessarily, this is a C library.  It could be
    anything though, some JavaScript, Java `.class` files.  Anything imaginable.

- The module itself provides attributes needed to use the library

    This means that if you are writing `Alien::Foo` it will provide class
    or member functions that will provide the necessary information for using
    the library that was probed for or installed during the previous step.

    If, for example, `Alien::Foo` were providing a dependency on the C
    library `libfoo`, then you might provide `Alien::Foo->cflags`
    and `Alien::Foo->libs` class methods to return the compiler and
    library flags required for using the library.

These are guidelines, and this module does not provide an implementation
or a framework, because of the diverse nature of non-Perl dependencies
on CPAN.  The more common cases are handled by the [Alien::Base](https://metacpan.org/pod/Alien::Base) +
[Alien::Build](https://metacpan.org/pod/Alien::Build) system, which is recommended if you want to avoid
reinventing the wheel.  See the ["SEE ALSO"](#see-also) section below for helpful
resources.

# CAVEATS

This section contains some recommendations from my own experience in
writing Alien modules and from working on the [Alien::Base](https://metacpan.org/pod/Alien::Base) +
[Alien::Build](https://metacpan.org/pod/Alien::Build) team.  The [Alien::Build](https://metacpan.org/pod/Alien::Build) FAQ ([Alien::Build::Manual::FAQ](https://metacpan.org/pod/Alien::Build::Manual::FAQ))
also addresses a number of implementation specific gotchas.

- When building from source code, build static libraries whenever possible

    Or at least isolate the dynamic libraries so they can be used by FFI,
    but do not use them to build XS modules.  The reason for this is that if
    an end user upgrades their version of `Alien::Foo` it may break the
    already installed version of `Foo::XS` that used it when it was
    installed.

- On Windows (ActiveState, Strawberry Perl)

    Many open source libraries use `autoconf` and other Unix focused tools
    that may not be easily available to the native (non-Cygwin) windows
    Perl. [Alien::MSYS](https://metacpan.org/pod/Alien::MSYS) provides just enough of these tools for `autoconf`
    and may be sufficient for some other build tools.  Also, [Alien::Build](https://metacpan.org/pod/Alien::Build)
    and [Alien::Base](https://metacpan.org/pod/Alien::Base) have hooks to detect `autoconf` and inject
    [Alien::MSYS](https://metacpan.org/pod/Alien::MSYS) as a requirement on Windows when it is needed.

- MB vs EUMM

    The original Alien documentation recommends the use of [Module::Build](https://metacpan.org/pod/Module::Build)
    (MB), which at the time was recommended over [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker)
    (EUMM).  Many Alien distributions have been written using MB.  Including
    the original installer that came with [Alien::Base](https://metacpan.org/pod/Alien::Base),
    [Alien::Base::ModuleBuild](https://metacpan.org/pod/Alien::Base::ModuleBuild).  I believe this is because it is an easier
    build system to adapt to the Alien concept.  MB is no longer universally
    recommended over EUMM, and has been removed from Perl's core, so if you
    can, this author recommends using EUMM instead.  [Alien::Build](https://metacpan.org/pod/Alien::Build) and
    [Alien::Build::MM](https://metacpan.org/pod/Alien::Build::MM) provide tools for creating EUMM based Aliens.
    Another example worth looking at is [Alien::pkgconf](https://metacpan.org/pod/Alien::pkgconf), which uses EUMM,
    but isn't based on [Alien::Base](https://metacpan.org/pod/Alien::Base) or [Alien::Build](https://metacpan.org/pod/Alien::Build).

# ORIGINAL MANIFESTO

What follows is the original Alien manifesto written by Artur Bergman.
It is included here, because much of it is still largely true today,
but it was out of necessity quite aspirational at the time it was written.

## Why

James and I ended up doing a build system for Fotango, lots of people
have done a build system, it is a pretty boring task. The boring task
is really all the mindlessly stupid things you need to do to build C
libraries that Perl modules require, these C modules usually have
unusual installation systems or require vastly different options. So
CPAN modules install easy, 3rd party stuff is nasty.

So, suddenly an idea struck me, Alien packages! Imagine a CPAN module
that has as its only task to make sure a certain library is
installed! That means that you can write all the voodoo in your
Build.PL file and then just make sure the module requires the correct
Alien module! Then anything that install Perl modules will deal with
it automatically!

## How

So, what should an Alien module do? It should make sure that the
target is installed and it should provide the caller with enough
information to use it.

The idea is that you use it to make sure it is there, and you call
class methods to find out what to use. These class methods will be
individually specified by the stand alone Alien modules.

## No Framework!

The reason this is so loosely worded is because we have no idea what
common functionality will be needed, so we will let evolution work for
us and see what individual Alien packages need and then eventually
factor it out into this packages. I would like to avoid a top down
design approach.

## Responsibilities of a Alien module.

On installation, make sure the required package is there, otherwise install it.

On usage, make sure the required package is there, else croak.

Bundle the source with the module, or download it.

Allow module authors to access information it gathers.

Document itself well.

Preferably use [Module::Build](https://metacpan.org/pod/Module::Build). \[ see caveats above \]

Be sane.

# SEE ALSO

- [Alien::Build::Manual::Alien](https://metacpan.org/pod/Alien::Build::Manual::Alien)

    Documentation for building [Alien](https://metacpan.org/pod/Alien)s using the [Alien::Base](https://metacpan.org/pod/Alien::Base) + [Alien::Build](https://metacpan.org/pod/Alien::Build) system.
    Intended for as a starting point for Alien users and Alien authors.

- [Alien::Build::Manual::FAQ](https://metacpan.org/pod/Alien::Build::Manual::FAQ)

    Quick answers (FAQ) for many common Alien issues.

- [Alien::Build](https://metacpan.org/pod/Alien::Build)

    A new installer agnostic Alien builder, intended to replace
    [Alien::Base::ModuleBuild](https://metacpan.org/pod/Alien::Base::ModuleBuild).  See [Alien::Build::Manual::AlienAuthor](https://metacpan.org/pod/Alien::Build::Manual::AlienAuthor)
    for details on how to create your own [Alien::Build](https://metacpan.org/pod/Alien::Build) based Alien.

- [Alien::Base](https://metacpan.org/pod/Alien::Base)

    An (optional) base class and framework for creating Alien distributions.

- [#native on irc.perl.org](http://chat.mibbit.com/#native@irc.perl.org)

    This channel on IRC is dedicated to those interested in using native interfaces
    in Perl.  It is specifically geared to Alien, [Alien::Base](https://metacpan.org/pod/Alien::Base) and FFI.

- [Perl5 Alien mailing list](https://groups.google.com/forum/#!forum/perl5-alien)

    This mailing list is mainly for [Alien::Base](https://metacpan.org/pod/Alien::Base), and announcements for new
    versions will be posted there, but general Alien inquires are also welcome.

- [https://github.com/PerlAlien](https://github.com/PerlAlien)

    The Perl Alien organization on GitHub.

# AUTHORS

- Arthur Bergman <abergman@fotango.com>
- Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2003 by Arthur Bergman <abergman@fotango.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
