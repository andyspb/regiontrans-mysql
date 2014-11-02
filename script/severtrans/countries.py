#!/usr/bin/env python 
# -*- coding: utf-8 -*- '''

if __name__ == '__main__':
    f = open( 'd:/work/regiontrans-mysql/script/c.txt', 'r' )
    new_file = open( 'd:/work/regiontrans-mysql/script/c1.txt', 'w' )
    for line in f:
        split_line = line.split( '\t' )
        nl = "{ name:  '" + split_line[0] + "', code: '" + split_line[1] + "' },\n"
        print nl
        new_file.write( nl )
