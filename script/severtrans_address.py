
"""
script reads first line of file and changes column names
a.krutogolov
"""

import mysql.connector
import os

config_regiontrans = {
  'user': 'dba',
  'password': 'sql',
  'host': '192.168.1.40',
  'port': '3306',
  'database': 'severtrans',
  'raise_on_warnings': True,
}

config_severtrans = {
  'user': 'dba',
  'password': 'sql',
  'host': '192.168.1.40',
  'port': '3307',
  'database': 'severtrans',
  'raise_on_warnings': True,
}

def getAddresses():
    print 'Get addresses from severtrans and regiontrans'
    cd = os.getcwd()
    print 'Current dir='+cd

def updateAddresses():
    regiontrans = open('d:/work/regiontrans-mysql/script/address_regiontrans.txt','r')
    severtrans = open('d:/work/regiontrans-mysql/script/address_severtrans.txt','r')
    new_file = open('d:/work/regiontrans-mysql/script/address1_severtrans.txt','w')

    print 'Create set aff couples (ident, type) in severtrans first'
    idents_severtrans = set([])
    for line in severtrans:
        split_line = line.split('\t')
        Clients_Ident = split_line[1]
        type = split_line[2]
#         if Clients_Ident in ('42482', '42529', '42606'):
#             print 'found Clients_Ident:' + Clients_Ident + ' line: ' + line
        if (Clients_Ident.isdigit()): 
            idents_severtrans.add((Clients_Ident,type))
    print "Total number of clients_idents(include dups) in address_severtrans: " + str(len(idents_severtrans))
#     print "address_severtrans: " + str(idents_severtrans)
    
    print 'Reading reiontrans, each couple (ident, type) looking in severtrans'
    print 'if not found - add into new file'
    i = 0
    total = 0
    print '~~~~ looking in regiontrans'
    
    for line in regiontrans:
        total = total +1 
        split_line = line.split('\t')
        ident = split_line[1]
        type = split_line[2]
        if (ident,type) not in idents_severtrans:
            new_file.write(line)
            i = i + 1

    print "Total number in reiontrans: " + str(total)

    print "Found " + str(i) + " missed addresses"
            
    
#         if i>=10:
#             break
if __name__ == '__main__':
    getAddresses()
    print "Updating lines in addresses"
    updateAddresses()
    print "Finish"

