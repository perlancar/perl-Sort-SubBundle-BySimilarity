package Sort::Sub::by_similarity_using_editdist;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub __min(@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    my $m = $_[0];
    for (@_) {
        $m = $_ if $_ < $m;
    }
    $m;
}

sub __editdist {
    my @a = split //, shift;
    my @b = split //, shift;

    # There is an extra row and column in the matrix. This is the distance from
    # the empty string to a substring of the target.
    my @d;
    $d[$_][0] = $_ for 0 .. @a;
    $d[0][$_] = $_ for 0 .. @b;

    for my $i (1 .. @a) {
        for my $j (1 .. @b) {
            $d[$i][$j] = (
                $a[$i-1] eq $b[$j-1]
                    ? $d[$i-1][$j-1]
                    : 1 + __min(
                        $d[$i-1][$j],
                        $d[$i][$j-1],
                        $d[$i-1][$j-1]
                    )
                );
        }
    }

    $d[@a][@b];
}

sub meta {
    return {
        v => 1,
        summary => 'Sort strings by similarity to target string (most similar first)',
        description => <<'MARKDOWN',

MARKDOWN
        args => {
            string => {
                schema => 'str*',
                req => 1,
            },
        },
    };
}

sub gen_sorter {
    my ($is_reverse, $is_ci, $args) = @_;

    sub {
        my $dist_a = __editdist(($is_ci ? lc($_[0]) : $_[0]), ($is_ci ? lc($args->{string}) : $args->{string}));
        my $dist_b = __editdist(($is_ci ? lc($_[1]) : $_[1]), ($is_ci ? lc($args->{string}) : $args->{string}));
        my $cmp = ($is_reverse ? -1:1) * ($dist_a <=> $dist_b);
    };
}

1;
# ABSTRACT:

=for Pod::Coverage ^(gen_sorter|meta)$

=cut
