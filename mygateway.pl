#!/usr/bin/perl

$ns = `netstat -nr`;

$ns =~ m/0.0.0.0\s+([0-9]+.[0-9]+.[0-9]+.[0-9]+)/g;

print $1

