#!/usr/bin/perl

# (setenv "PERL5LIB" "/home/sakurai/nwork/apps/emacs-edbc/exlib/lib/perl5/x86_64-linux:/home/sakurai/nwork/apps/emacs-edbc/exlib/lib/perl5/:/home/sakurai/nwork/apps/emacs-edbc/RPC-EPC/lib" )

use RPC::EPC::Service;
use Data::Dumper;
use DBI;

sub db_connect {
  my $dbh;
  my $methods = 
    {
     'connect' => sub {
       my ($args) = @_;
       my $dbname = $args;
       $dbh = DBI->connect("dbi:SQLite:dbname=$dbname","","");
       return $dbh->get_info(18);
     },
     'query' => sub {
       my ($args) = @_;
       my $sql = $args;
       my $sth = $dbh->prepare($sql);
       $sth->execute();
       my $rs = $sth->fetchall_arrayref;
       unshift @$rs, $sth->{NAME};
       return $rs;
     },
    };
    my $server = RPC::EPC::Service->new(8888, $methods);
    $server->start;
}

db_connect;


