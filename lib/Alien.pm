package Alien;

use strict;
use warnings;

# ABSTRACT: External libraries wrapped up for your viewing pleasure!
# VERSION

=head1 SYNOPSIS

 % perldoc Alien

=head1 DESCRIPTION

The intent of the Alien namespace is to provide a mechanism for specifying,
installing and using non-native dependencies on CPAN.  Frequently this is
a C library used by XS (see L<perlxs>) or FFI (see L<FFI::Platypus>), but
it could be anything non-Perl usable from Perl.

Typical characteristics of an Alien distribution include:

=over 4

=item Probe for or install library during the build process

Usually this means that L<Module::Build> or L<ExtUtils::MakeMaker> will
be extended to probe for an existing system library that meets the
criteria of the Alien module.  If it cannot be found the library is
downloaded from the Internet and installed into a share directory (See
L<File::ShareDir::Dist>).

Usually, though not necessarily, this is a C library.  It could be
anything though, some JavaScript, Java C<.class> files.  Anything imaginable.

=item The module itself provides attributes needed to use the library

This means that if you are writing C<Alien::Foo> it will provide class
or member functions that will provide the necessary information for using
the library that was probed for or installed during the previous step.

If, for example, C<Alien::Foo> were providing a dependency on the C
library C<libfoo>, then you might provide C<Alien::Foo-E<gt>cflags>
and C<Alien::Foo-E<gt>libs> class methods to return the compiler and
library flags required for using the library.

=back

These are guidelines, and this module does not provide an implementation
or a framework, because of the diverse nature of non-Perl dependencies
on CPAN.  The more common cases are handled by the L<Alien::Base> +
L<Alien::Build> system, which is recommended if you want to avoid
reinventing the wheel.  See the L</SEE ALSO> section below for helpful
resources.

=head1 CAVEATS

This section contains some recommendations from my own experience in
writing Alien modules and from working on the L<Alien::Base> +
L<Alien::Build> team.  The L<Alien::Build> FAQ (L<Alien::Build::Manual::FAQ>)
also addresses a number of implementation specific gotchas.

=over 4

=item When building from source code, build static libraries whenever possible

Or at least isolate the dynamic libraries so they can be used by FFI,
but do not use them to build XS modules.  The reason for this is that if
an end user upgrades their version of C<Alien::Foo> it may break the
already installed version of C<Foo::XS> that used it when it was
installed.

=item On Windows (ActiveState, Strawberry Perl)

Many open source libraries use C<autoconf> and other Unix focused tools
that may not be easily available to the native (non-Cygwin) windows
Perl. L<Alien::MSYS> provides just enough of these tools for C<autoconf>
and may be sufficient for some other build tools.  Also, L<Alien::Build>
and L<Alien::Base> have hooks to detect C<autoconf> and inject
L<Alien::MSYS> as a requirement on Windows when it is needed.

=item MB vs EUMM

The original Alien documentation recommends the use of L<Module::Build>
(MB), which at the time was recommended over L<ExtUtils::MakeMaker>
(EUMM).  Many Alien distributions have been written using MB.  Including
the original installer that came with L<Alien::Base>,
L<Alien::Base::ModuleBuild>.  I believe this is because it is an easier
build system to adapt to the Alien concept.  MB is no longer universally
recommended over EUMM, and has been removed from Perl's core, so if you
can, this author recommends using EUMM instead.  L<Alien::Build> and
L<Alien::Build::MM> provide tools for creating EUMM based Aliens.
Another example worth looking at is L<Alien::pkgconf>, which uses EUMM,
but isn't based on L<Alien::Base> or L<Alien::Build>.

=back

=head1 ORIGINAL MANIFESTO

What follows is the original Alien manifesto written by Artur Bergman.
It is included here, because much of it is still largely true today,
but it was out of necessity quite aspirational at the time it was written.

=head2 Why

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

=head2 How

So, what should an Alien module do? It should make sure that the
target is installed and it should provide the caller with enough
information to use it.

The idea is that you use it to make sure it is there, and you call
class methods to find out what to use. These class methods will be
individually specified by the stand alone Alien modules.

=head2 No Framework!

The reason this is so loosely worded is because we have no idea what
common functionality will be needed, so we will let evolution work for
us and see what individual Alien packages need and then eventually
factor it out into this packages. I would like to avoid a top down
design approach.

=head2 Responsibilities of a Alien module.

On installation, make sure the required package is there, otherwise install it.

On usage, make sure the required package is there, else croak.

Bundle the source with the module, or download it.

Allow module authors to access information it gathers.

Document itself well.

Preferably use L<Module::Build>. [ see caveats above ]

Be sane.

=head1 SEE ALSO

=over 4

=item L<Alien::Build::Manual::Alien>

Documentation for building L<Alien>s using the L<Alien::Base> + L<Alien::Build> system.
Intended for as a starting point for Alien users and Alien authors.

=item L<Alien::Build::Manual::FAQ>

Quick answers (FAQ) for many common Alien issues.

=item L<Alien::Build>

A new installer agnostic Alien builder, intended to replace
L<Alien::Base::ModuleBuild>.  See L<Alien::Build::Manual::AlienAuthor>
for details on how to create your own L<Alien::Build> based Alien.

=item L<Alien::Base>

An (optional) base class and framework for creating Alien distributions.

=item L<#native on irc.perl.org|http://chat.mibbit.com/#native@irc.perl.org>

This channel on IRC is dedicated to those interested in using native interfaces
in Perl.  It is specifically geared to Alien, L<Alien::Base> and FFI.

=item L<Perl5 Alien mailing list|https://groups.google.com/forum/#!forum/perl5-alien>

This mailing list is mainly for L<Alien::Base>, and announcements for new
versions will be posted there, but general Alien inquires are also welcome.

=item L<https://github.com/PerlAlien>

The Perl Alien organization on GitHub.

=back

=cut

1;

