
"""
script reads first line of file and changes column names
"""

import os
import inspect

cwd = os.path.dirname( os.path.abspath( inspect.getfile( inspect.currentframe() ) ) )
print 'cwd: ' + cwd


def updateAccounts():
    f = open( cwd + '/accounts_severtrans.txt', 'r' )
    # new_file = open('d:/work/regiontrans-mysql/script/clients1_severtrans_test.txt','w')
    new_file = open( cwd + '/accounts1_severtrans.txt', 'w' )
    i = 0;
    for line in f:
        if i == 0:
            line = line.replace( 'Ident', 'id\tident', 1 )
            line = line.replace( 'Name', 'name', 1 )
            line = line.replace( 'Acronym', 'alias', 1 )
            line = line.replace( 'Dat', 'account_date_date', 1 )
            line = line.replace( 'Number', 'account_number', 1 )
            line = line.replace( 'SumNDS', 'nds\tsum\tsum_with_nds', 1 )
            new_file.write( line )
        # print line
#        line = line.lstrip('\n')
        if i >= 1:
            split_line = line.split( '\t' )
#             print split_line
            ident = split_line[0]
            name = split_line[1]
            alias = split_line[2]
            date = split_line[3]
            number = split_line[4]
            sum_str = split_line[5]
#             sum_str = sum_str.replace(chr(13), '')
#             last_tab = line.rfind('\t')
            n = float( sum_str )
            nds = n * 18 / 118
            s = n - nds
#             add_str = str(round(nds,2))+'\t'+str(round(sum,2))+'\t'+str(round(n,2));
#             line = str(i) + '\t' + line[:last_tab+1] + add_str + '\n'
            # line.encode('utf-8')#print line

            line = "\t".join( [str( i ), ident, name, alias, date, number,
                              str( round( nds, 2 ) ), str( round( s, 2 ) ),
                              str( round( n, 2 ) ) + '\n'] )

#             print split_line
            new_file.write( line )

        i = i + 1
    # TEK
    ft = open( cwd + '/accountstek_severtrans.txt', 'r' )
    it = 0;
    for line in ft:
        it = it + 1
        if it > 1:
            split_line = line.split( '\t' )
#             print split_line
            ident = split_line[0]
            name = split_line[1]
            alias = split_line[2]
            date = split_line[3]
            number = split_line[4]
            sum_str = split_line[5]
#             line = line.replace(chr(13), '')
#             last_tab = line.rfind('\t')
#             n = float(line[last_tab+1:])
#             n = float(sum_str)
            n = float( sum_str )
            nds = 0
            s = n
#             add_str = str(round(nds,2))+'\t'+str(round(sum,2))+'\t'+str(round(n,2));
#             line = str(i) + '\t' + line[:last_tab+1] + add_str + '\n'
            line = "\t".join( [str( i ), ident, name, alias, date, number,
                              str( round( nds, 2 ) ), str( round( s, 2 ) ),
                              str( round( n, 2 ) ) + '\n'] )
            new_file.write( line )
            i = i + 1

if __name__ == '__main__':
    print "Updating lines in accounts"
    updateAccounts()
    print "Finish"


