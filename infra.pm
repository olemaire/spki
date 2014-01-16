# SPKI -  Simple Perl Key Infrastructur
#   Copyright © 2013 Senso-Rezo
#   All rights reserved.
#   See LICENSE file for licensing information.
#   See http://github.com/olemaire/spki for more information.

# infra.pm - spki infrastructural functions 
package infra;
use strict;
use warnings;
#use Exporter 'import';
#our $VERSION = '1.00';
#our @EXPORT = qw(LogToSyslog, DieLogging);

   $0		=	"spki";
my $loggerchan	=	"daemon";
my $loggertag	=	"$0 [$$]";
my $logfile	=	"/tmp/$0.log";

sub Usage {
    # will display usage message
    # Usage: &Usage();
    print "Copyright (C) Senso-Rezo - SPKI (http://github.com/olemaire/spki)\n\n";
    print "Usage: $0 \n";
    print "\n";
    print "Example: $0 \n\n";
    exit(0);    # warning - exit(-1) will not allow to perl pack using perl packer :(
}


sub DieLogging {
    # will log error message to syslog and logfile, then die
    # Usage: &DieLogging("message");
    my ($msg)   = shift;
    my $prio    = "err";
    &LogToSyslog("$prio","$msg");
    die("$msg");
}

sub LogToSyslog {
    # will log $message to $logfile and syslog with $prio priority
    # Usage: &LogToSyslog("priority","message");
    # Remind: priority may be one of the following:
    #       emerg,alert,crit,err,warning,notice,info,debug
    my ($prio,$msg) = @_;
    system ("/usr/bin/logger -p $loggerchan.$prio -t $loggertag \"$prio - $msg\"");
    my $timestamp = localtime();
    open(LOGFILE, ">>$logfile") or die "Can't output to $logfile: $!";
        print LOGFILE "$timestamp - $loggertag - $prio - $msg\n";
    close(LOGFILE);
}

1;
# - This Is The End
