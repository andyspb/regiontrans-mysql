
"""
script reads first line of file and changes column names
a.krutogolov
"""
import mysql.connector
import os, inspect

cwd = os.path.dirname( os.path.abspath( inspect.getfile( inspect.currentframe() ) ) )
host = os.getenv( 'MYSQL_IP_ADDRESS', '192.168.1.99' )
print 'host ' + host

config = {
  'user': 'dba',
  'password': 'sql',
  'host': host,
  'port': '3307',
  'database': 'severtrans',
  'raise_on_warnings': True,
}

def getClientName(ident):
#     print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `name` from `clients` WHERE `Ident`=%s")
#     print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0].encode('utf-8'))
    cursor.close()
    cnx.close()
    return res

def getClientAcronym(ident):
#     print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `acronym` from `clients` WHERE `Ident`=%s")
#     print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0].encode('utf-8'))
    cursor.close()
    cnx.close()
    return res

def getAcceptor(ident):
#     print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `name` from `acceptor` WHERE `Ident`=%s")
#     print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0].encode('utf-8'))
    cursor.close()
    cnx.close()
    return res


def getCity(ident):
#     print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `name` from `city` WHERE `Ident`=%s")
#     print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0].encode('utf-8'))
    cursor.close()
    cnx.close()
    return res


def updateInvoices():
    f = open( cwd + '/invoices_severtrans.txt', 'r' )
    tek = open( cwd + '/aktstek_severtrans.txt', 'r' )

    #new_file = open('d:/work/regiontrans-mysql/script/clients1_severtrans_test.txt','w')
    new_file = open( cwd + '/invoices1_severtrans.txt', 'w' )
    i = 0;
    for line in f:
        if i==0:
            line = line.replace('Ident', 'id\tident', 1)
            line = line.replace('Number', 'number', 1)
            line = line.replace('Data', 'date', 1)
            line = line.replace('Clients_Ident', 'name\talias', 1)
            line = line.replace('Sum', 'sum', 1)
            line = line.replace('NDS', 'nds', 1)
            line = line.replace('ReportReturn', 'return', 1)
            
            new_file.write(line)
#        print line
#        line = line.lstrip('\n')
        if i >= 1:
#             print 'line: ' + str(i)
            split_line = line.split('\t')
#             print "split_line="+str(split_line)
            ident = split_line[0]
            number = split_line[1].decode('cp1251').encode('utf-8')
            date = split_line[2]
            client_name = getClientName(int(split_line[3]))
            client_alias = getClientAcronym(int(split_line[3]))
            s = split_line[4]
            nds = split_line[5]
            ret = split_line[6]

            line = "\t".join([str(i), ident, number, date, client_name, 
                              client_alias, str(s), str(nds), 
                              ret])
#             print line
            new_file.write(line)
        i = i + 1
# tek
    counter = 0
    for line in tek:
        counter = counter+1
        if counter==1:
            continue
#         print line
        line = line.lstrip('\n')
        if counter> 1:
#             print 'line: ' + str(i)
            split_line = line.split('\t')
#             print "split_line="+str(split_line)
            ident = split_line[0]
            number = split_line[1].decode('cp1251').encode('utf-8')
            date = split_line[2]
            client_name = getClientName(int(split_line[3]))
            client_alias = getClientAcronym(int(split_line[3]))
            s = split_line[4]
            nds = 0
            ret = split_line[5]

            line = "\t".join([str(i), ident, number, date, client_name, 
                              client_alias, str(s), str(nds), 
                              ret])
#             print line
            new_file.write(line)
        i = i + 1


#         if i>=10:
#             break
#         print line
if __name__ == '__main__':
    print "Updating lines in invoices"
    updateInvoices()
    print "Finish"

