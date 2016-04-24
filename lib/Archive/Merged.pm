package Archive::Merged;
use strict;
use Carp qw(croak);
use vars qw($VERSION);
$VERSION = '0.01';

=head1 NAME

Archive::Merged - virtually merge two archives

=head1 SYNOPSIS

  my $merged = Archive::Merged->new(
      Archive::Tar->new( 'default_theme.tar' ),
      Archive::SevenZip->archiveTarApi( archivename => 'theme.zip' ),
      Archive::Dir->new( 'customized/' ),
  );

=head1 METHODS

=cut

sub new {
    my ($class, @archives) = @_;
    my $self = {
        archives => \@archives,
    };
    bless $self => $class;
    $self
};

sub directory {
    undef
};

sub archives {
    @{ $_[0]->{archives} }
}

sub contains_file {
    my( $self, $file ) = @_;
    for my $ar ($self->archives) {
        if( $ar->contains_file( $file ) ) {
            return $ar
        };
    };
};

=head2 C<< ->get_content( $file, %options ) >>

  my $content = $merged->get_content( $file, binmode => ':raw' )

Returns the content of the file, potentially with the encoding.

=cut

sub get_content {
    my( $self, $file, %options ) = @_;
    my $ar = $self->contains_file( $file );
    $ar->get_content( $file, %options )
};

=head2 C<< ->list_files( ) >>
sub list_files {
    my ($self,$properties) = @_;
    croak "Listing properties is not (yet) implemented"
        if $properties;
    my %seen;
    my @files;
    for my $ar ($self->archives) {
        for my $file ($ar->list_files) {
            if( ! $seen{ $file }++) {
                push @files, $file;
            };
        };
    };
    @files
}

sub extract_file {
    my ($self,$file,$target) = @_;
    my $ar = $self->contains_file( $file );
    $ar->extract_file( $file, $target );
};


1;

=head1 SEE ALSO

L<Archive::Tar>

L<Archive::SevenZip::API::ArchiveTar>

=cut