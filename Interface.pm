# O b j e c t : : I n t e r f a c e
#
# Perl Module List Entry:
#
# Name           DSLI  Description                                  Info
# -------------  ----  -------------------------------------------- -----
# Object::
# ::Interface    adpn  Specificy pure virtual base classes ala C++  GWELCH
#
#
# Author:    Gerad Welch <gwelch@computer.org>
#                        <welch.119@osu.edu> for development issues
#
# Copyright:
#   Copyright (c) 1999 Gerad Welch.  All rights reserved.
#   This program may be freely redistributed, though all useful
#   modifications must be sent back to the author for examination and
#   and possible incorporation into future versions. =)
#
# Revision Log:
#
# 1999.09.02 GMW  Finished preliminary version.
# 1999.09.18 GMW  Removed 'require' interface for simplicity.  Cleaned up
#                 things a /little/ bit....
#
# Note:
# Someday it might be nice to have an 'object' pragma, so one could say
# 'use object interface qw( required symbols )' instead of the current
# usage.  Maybe someday....

package Object::Interface;

use strict;

use vars qw( $VERSION );

$VERSION = '1.0';

sub import
{

  # Get rid of our package name
  shift;

  my @required = @_;
#  print STDERR "Interface methods:\n@required\n";

  # Find out what module called us
  my @caller;
  my $i = 0;
  while ( 1  ) {
    @caller = caller $i++;
    die "Unable to find derived class!\n" if ! @caller;
    last if defined $caller[7];
  }
#  print STDERR "caller() info:\n@caller\n";

  # Extract all sub names from the calling module
  my %syms;
  my $is_sub;
  eval '%syms = %' . $caller[0] . '::';
  my @present = map {
                      eval '$is_sub = defined ' . $syms{$_} . '{CODE}';
                      $is_sub ? ( $_ ) : ( );
                    } keys %syms;
#  print STDERR "Derived class's methods:\n@present\n";

  # Check to see what's there and what's not
  my $sym;
  my $flag;
  while ( 1 ) {
    $sym = shift @required;
    last if ! defined $sym;
    @present = map { ( $sym eq $_ ) ? ( $flag = $sym, () )[1] : ( $_ ) } @present;
    die "Pure virtual function '$sym' not defined in $caller[1].\n"
      if ! defined $flag;
    undef $flag;
  }

}

# Written to Shiina Ringo's "Koko de Kissu-shite" playing on really bad
# speakers.  Yo to Brian Lemieux and Ed Wahl.  KDM, go to school, dammit!

1;

__END__

=head1 NAME

Object::Interface - allows specification of an abstract base class

=head1 SUMMARY

    package abstract;

    use strict;
    use Object::Interface qw( func1 func2 func3 );

    1;

    # Any classes derived from abstract must now contain the functions
    # specified in the 'use' statement, e.g. func1, func2, and func3.

=head1 DESCRIPTION

C<Object::Interface> allows class modules to be declared as abstract base
classes, or in C++ parlance, pure virtual classes.  That is to say, any
class derived from a module using Object::Interface must implement the
specified routines from that module.  C<Object::Interface> differs from
C++'s pure virtual functions in that functions may be defined and coded in
the abstract base for the derived class to call (via C<SUPER>).  This
allows common code to be written in the base class.  For example:

    package IO::Base;

    use strict;
    use Object::Interface qw( open close read print eof ); # etc.

    sub open
    {
      return open @_;
    }

    # etc.

C<Object::Interface> simply specifies a signature of functions that any
derived class must implement, not what the derived class can or cannot
do with the methods.

=cut
