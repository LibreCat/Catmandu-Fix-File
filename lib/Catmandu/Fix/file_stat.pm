package Catmandu::Fix::file_stat;
use Catmandu::Sane;
use Moo;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::SimpleGetValue';

sub emit_value {
    my ($self, $var, $fixer) = @_;

    my $temp_var = $fixer->generate_var();

    my $perl = <<EOF;
    if (is_string(${var})) {

        my ${temp_var} = [stat(${var})];

        if( scalar(\@{${temp_var}}) ){

            ${var} = {
                dev => ${temp_var}->[0],
                ino => ${temp_var}->[1],
                mode => ${temp_var}->[2],
                nlink => ${temp_var}->[3],
                uid => ${temp_var}->[4],
                gid => ${temp_var}->[5],
                rdev => ${temp_var}->[6],
                size => ${temp_var}->[7],
                atime => ${temp_var}->[8],
                mtime => ${temp_var}->[9],
                ctime => ${temp_var}->[10],
                blksize => ${temp_var}->[11],
                blocks => ${temp_var}->[12]
            };

        }
        else{
            ${var} = undef;
        }

    }
EOF

}

1;
