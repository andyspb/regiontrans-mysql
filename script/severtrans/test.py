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

def getClientKredit(ident):
    print 'Ident='+str(ident)
    sum_ = 0
    sum1_ = 0
    s3 = 0
    s3_temp = 0
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT SumCount,Client_Ident FROM send_all WHERE Client_Ident=%s")
    print query
    cursor.execute(query, (str(ident),))
    for (count, ident) in cursor:
        print str(count) + ' ' +str(ident)
        sum_ = sum_ + float(count)
    print 'sum_=' + str(sum_)    
    
    query1 = ("SELECT SumNDS,Client_Ident FROM order_all WHERE Client_Ident=%s")
    print query1
    cursor.execute(query1, (str(ident),))
    for (count, ident) in cursor:
#        print str(count) + ' ' +str(ident)
        sum1_ = sum1_ + float(count)
    
    print 'sum1_=' + str(sum1_)    

    query2 = ("SELECT Sum,Client_Ident FROM paysheet_all WHERE Client_Ident=%s")
    print query2
    cursor.execute(query2, (str(ident),))
    for (count, ident) in cursor:
        print str(count) + ' ' +str(ident)
        s3_temp = count;
        s3 = abs(float(s3_temp)) 
#        print 's3_temp='+str(s3_temp) + '     s3='+str(s3)
        if float(s3_temp)>0:
            sum1_ = sum1_ + s3
        
        else:
            if sum1_==s3:
                sum1_=0
            else:
                sum1_ = sum1_ + s3
            
    print 'sum1=' + str(sum1_)    

    query3 = ("SELECT KreditTEK FROM clients WHERE Ident=%(client_ident)s")
    cursor.execute(query3, { 'client_ident':str(ident)})
    kreditTek = 0
    for (count) in cursor:
        kreditTek = float(str(count[0]))
    
    
    print 'kreditTek='+str(kreditTek)
  
    if (kreditTek > 0):
        sum1_ = sum1_ + kreditTek
    else:
        sum_ = sum_ - kreditTek


    kredit =  str(sum1_ - sum_)
    print '===================================='

    cursor.close()
    cnx.close()
    return kredit
        
if __name__ == '__main__':
    print "Test sql"
    print getClientKredit(51)
    print getClientKredit(87)
    print getClientKredit(10269)
    print getClientKredit(19233)
