package Glow::Repository;

use MooseX::Params::Validate;

with 'Glow::Role::Repository';

# use with Glow::Repository->spawn();

sub spawn {
    my $class = shift;
    my ( $dir ) = validated_list(
        \@_,
        dir   => { isa => 'Path::Class::Dir', optional => 1 },
    );
    $repo_class = Glow::Config->new(dir => ($dir // '.') )->get( key => 'glow.class' )
        || 'Glow::Repository::Git';
    eval "require $class" or die $@;
    $repo_class->new(@args);
}

# ABSTRACT: Factory class to build objects doing Glow::Role::Repository

=pod

=head1 SYNOPSIS

    use Glow::Repository;

    # .git is a Git repository's GIT_DIR
    my $r = Glow::Repository->new( directory => '.git' );

    # $r is now a Glow::Repository::Git object

=head1 DESCRIPTION

L<Glow::Repository> is a factory class that will instanciate the proper
repository class based on the repository configuration.

By default, a L<Glow> repository contain a single file named F<config>
that holds at least this configuration (readable by L<Glow::Config>):

    [glow]
    	class = Class::Doing::Glow::Role::Repository

By default (see the L</SYNOPSIS>), if the C<[glow]> configuration section
does not exist in the F<config> file, it is assumed the repository is a
Git repository, and the class defaults to L<Glow::Repository::Git>.

=cut
