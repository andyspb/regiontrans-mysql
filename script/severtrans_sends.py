
"""
script reads first line of file and changes column names
"""
def changeFirstLine():
    f = open('d:/work/regiontrans-mysql/script/accounts_severtrans.txt','r')
    #new_file = open('d:/work/regiontrans-mysql/script/clients1_severtrans_test.txt','w')
    new_file = open('d:/work/regiontrans-mysql/script/accounts1_severtrans.txt','w')
    i = 0;
    for line in f:
        line = line.replace('Ident', 'id\tident')
        line = line.replace('Name', 'name')
        line = line.replace('Acronym', 'alias')
        line = line.replace('Dat', 'account_date_date')
        line = line.replace('Number', 'account_number')
        line = line.replace('SumNDS', 'nds\tsum\tsum_with_nds')
        #print line
#        line = line.lstrip('\n')
        if i >= 1:
            line = line.replace(chr(13), '')
            last_tab = line.rfind('\t')
            n = float(line[last_tab+1:])
            nds = n *18/118
            sum = n - nds
            add_str = str(round(nds,2))+'\t'+str(round(sum,2))+'\t'+str(round(n,2));
            line = str(i) + '\t' + line[:last_tab+1] + add_str + '\n'
            #line.encode('utf-8')#print line
            
        new_file.write(line)
        i = i + 1
#         if i>=10:
#             break
#         print line
if __name__ == '__main__':
    print "Updating lines in sql backup "
    changeFirstLine()

