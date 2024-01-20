package Sort::Sub::by_similarity_using_fzf;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    return {
        v => 1,
        summary => 'Sort strings by similarity to target string (most similar first)',
        description => <<'MARKDOWN',

MARKDOWN
        args => {
            string => {
                schema => 'str*', # XXX: single_line_str*
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
