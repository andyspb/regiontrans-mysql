
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
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
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
#    res = str(cursor.fetchone()[0].encode('utf-8'))
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
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
#    res = str(cursor.fetchone()[0].encode('utf-8'))
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
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
#    res = str(cursor.fetchone()[0].encode('utf-8'))
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
    cursor.close()
    cnx.close()
    return res

def getInvoiceNumber(ident):
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `Number` from `invoice_all`  WHERE `Ident`=%s")
    cursor.execute(query, (str(ident),))
#    res = str(cursor.fetchone()[0].encode('utf-8'))
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
    cursor.close()
    cnx.close()
    return res

def getAkttekNumber(ident):
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `Number` from `akttek_all`  WHERE `IDENT`=%s")
    cursor.execute(query, (str(ident),))
#    res = str(cursor.fetchone()[0].encode('utf-8'))
    res = 'NULL'
    cursor_value = cursor.fetchone()[0]
    if not cursor_value is None:
        res = str( cursor_value.encode( 'utf-8' ) )
    cursor.close()
    cnx.close()
    return res


def updateSends():
    f = open( cwd + '/sends_severtrans.txt', 'r' )
    new_file = open( cwd + '/sends1_severtrans.txt', 'w' )
    i = 0;
    for line in f:
        if i==0:
            line = line.replace('Ident', 'id\tident', 1)
            line = line.replace('Namber', 'number', 1)
            line = line.replace('Start', 'date', 1)
            line = line.replace('Client_Ident_Sender', 'sender', 1)
            line = line.replace('Client_Ident', 'name\talias', 1)
            line = line.replace('Acceptor_Ident', 'receiver', 1)
            line = line.replace('Weight', 'weight', 1)
            line = line.replace('Volume', 'volume', 1)
            line = line.replace('PackCount', 'seats', 1)
            line = line.replace('SumCount', 'total', 1)
            line = line.replace('City_Ident', 'destination',1)
            line = line.replace('DateSend', 'send_date',1)
            line = line.replace('Invoice_Ident', 'invoice_ident',1)
            line = line.replace('Akttek_Ident', 'invoice_number',1)
            
            new_file.write(line)
#        print line
#        line = line.lstrip('\n')
        if i >= 1:
#             print 'line: ' + str(i) + ' ' + line
            split_line = line.split('\t')
#             print "split_line="+str(split_line)
            ident = split_line[0]
            number = split_line[1].decode('cp1251').encode('utf-8')
            date = split_line[2]
            if split_line[3].isdigit():
                client_name = getClientName(int(split_line[3]))
                client_alias = getClientAcronym(int(split_line[3]))
            else:
                continue    
            sender = 'NULL'
            if split_line[4].isdigit():
                sender = getClientName(int(split_line[4]))
            receiver = 'NULL' 
            if split_line[5].isdigit():
                receiver = getAcceptor(int(split_line[5]))
            city = getCity(split_line[6])
            w = split_line[7]
            v = split_line[8]
            s = split_line[9].decode('cp1251').encode('utf-8')
            p = split_line[10]
            d = split_line[11]

            invoice_ident = 'NULL'
            invoice = split_line[12].rstrip();
            akttek = split_line[13].rstrip();
            invoice_number='NULL'        
            if invoice.isdigit():
                invoice_ident=str(invoice);
                invoice_number=getInvoiceNumber(invoice)
            elif akttek.isdigit():
                invoice_ident=str(akttek)
                invoice_number=getAkttekNumber(akttek)

            line = "\t".join([str(i), ident, number, date, client_name, client_alias, 
                                  sender, receiver, city, w, v, s, p, d, 
                                  invoice_ident, invoice_number])
#             print line
            new_file.write(line+'\n')
        i = i + 1
#         if i>=10:
#             break
#        print line
if __name__ == '__main__':
    print "Updating lines in sends"
    updateSends()
    print "Finish"

