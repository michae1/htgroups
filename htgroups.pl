#!/usr/bin/perl

use strict;

my $mode;
my $groupFile;
my $userName;
my $groupName;

while ( my $arg = shift @ARGV ) {
    if ( $arg eq '-l' ) {
      $mode = "list";
      $groupFile = shift @ARGV;
    } elsif ( $arg eq '-a' ) {
      $mode = "add"; 	
      $groupFile = shift @ARGV;
      $groupName = shift @ARGV;	
      $userName = shift @ARGV;
    } elsif ( $arg eq '-d' ) {
      $mode = "del";
      $groupFile = shift @ARGV;
      $groupName = shift @ARGV;
      $userName = shift @ARGV;	
    } else {
      usage();
      exit 1;
    }
 }

if (($mode eq "list")&&($groupFile eq "")){usage();exit 1;}
if (($mode eq "add")&&($groupFile eq "")&&($userName eq "")){usage();exit 1;}
if (($mode eq "del")&&($groupFile eq "")&&($userName eq "")){usage();exit 1;}
if ($mode eq ""){usage();exit 1;}

sub usage
{

print "Usage: htgroups.pl [mode] filename groupname [username]\nMode:\n -l: list\n -a: add\n-d delete\n";

}

sub readUsers
{
my %users;
open GRPFILE, $groupFile or die "Cannot open group file: $!\n";
while (<GRPFILE>)
{
	my $line = $_;
	my $group;
	$line =~ /(.*)\:\s?(.*)/;
	$group = $1;
	$users{$group} = [split(/\s?,\s?/,$2)];
}
close GRPFILE;
return %users;
}

if ($mode eq "list")
{
my %users = readUsers();
my $key;
for $key (sort keys %users){
    print "$key:"; 
    foreach my $elem(@{$users{$key}}){ 
                print $elem.",";
}
print "\n";
}
}
if ($mode eq "add")
{
	my %users = readUsers();
	open GRPFILE, ">".$groupFile or die "Cannot open group file: $!\n";
	my $key;
	for $key (sort keys %users){
	    print GRPFILE "$key: ";
	    my $splitter = ""; 
	    foreach my $elem(@{$users{$key}}){
	                print GRPFILE $splitter.$elem;
			$splitter = ", ";
    		}
	if ($key eq $groupName) {print GRPFILE $splitter.$userName;}
	print GRPFILE "\n";	
}    
if (!$users{$groupName}){print GRPFILE $groupName.": ".$userName;}

close GRPFILE;
}

if ($mode eq "del")
{
my %users = readUsers();
open GRPFILE, ">".$groupFile or die "Cannot open group file: $!\n";
my $key;
for $key (sort keys %users){
    print GRPFILE "$key: ";
    my $splitter = "";
    foreach my $elem(@{$users{$key}}){
                if (($elem eq $userName)&&($key eq $groupName))
			{}
		else
			{print GRPFILE $splitter.$elem}
    $splitter = ", ";
    }
    print GRPFILE "\n";
}

close GRPFILE;
}


