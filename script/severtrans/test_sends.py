import mysql.connector
# from mysql.connector import errorcode

config = {
  'user': 'dba',
  'password': 'sql',
  'host': '192.168.1.40',
  'port': '3307',
  'database': 'severtrans',
  'raise_on_warnings': True,
}

def getClientName(ident):
    print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `name` from `clients` WHERE `Ident`=%s")
    print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0])
    cursor.close()
    cnx.close()
    return res

def getClientAcronym(ident):
    print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `acronym` from `clients` WHERE `Ident`=%s")
    print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0])
    cursor.close()
    cnx.close()
    return res

def getCity(ident):
    print 'Ident='+str(ident)
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT `name` from `city` WHERE `Ident`=%s")
    print query
    cursor.execute(query, (str(ident),))
    res = str(cursor.fetchone()[0])
    cursor.close()
    cnx.close()
    return res

        
if __name__ == '__main__':
    print "Test sql"
    print getClientName(20890)
    print getClientAcronym(20890)
    print getCity(205)

