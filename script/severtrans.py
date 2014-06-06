
"""
script reads first line of file and changes column names
"""
import mysql.connector

config = {
  'user': 'dba',
  'password': 'sql',
  'host': '192.168.1.40',
  'port': '3307',
  'database': 'severtrans',
  'raise_on_warnings': True,
}

def getClientKredit(ident):
#     print 'Ident='+str(ident)
    sum_ = 0
    sum1_ = 0
    s3 = 0
    s3_temp = 0
    cnx = mysql.connector.connect(**config)
    cursor=cnx.cursor(buffered=True)
    query = ("SELECT SumCount,Client_Ident FROM send_all WHERE Client_Ident=%s")
#     print query
    cursor.execute(query, (str(ident),))
    for (count, ident) in cursor:
#         print str(count) + ' ' +str(ident)
        sum_ = sum_ + float(count)
#     print 'sum_=' + str(sum_)    
    
    query1 = ("SELECT SumNDS,Client_Ident FROM order_all WHERE Client_Ident=%s")
#     print query1
    cursor.execute(query1, (str(ident),))
    for (count, ident) in cursor:
#        print str(count) + ' ' +str(ident)
        sum1_ = sum1_ + float(count)
    
#     print 'sum1_=' + str(sum1_)    

    query2 = ("SELECT Sum,Client_Ident FROM paysheet_all WHERE Client_Ident=%s")
#     print query2
    cursor.execute(query2, (str(ident),))
    for (count, ident) in cursor:
#          str(count) + ' ' +str(ident)
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
            
#     print 'sum1=' + str(sum1_)    
  
    query3 = ("SELECT KreditTEK FROM clients WHERE Ident=%(client_ident)s")
    cursor.execute(query3, { 'client_ident':str(ident)})
    kreditTek = 0
    for (count) in cursor:
        if count[0] == None:
            kreditTek = 0
        elif count[0] == 'null':
            kreditTek = 0
        else:
            kreditTek = float(str(count[0]))
    
#     print 'kreditTek='+str(kreditTek)

    if (kreditTek > 0):
        sum1_ = sum1_ + kreditTek
    else:
        sum_ = sum_ - kreditTek

    kredit =  str(sum1_ - sum_)
#     print '===================================='

    cursor.close()
    cnx.close()
    return kredit

def getIdentFromLine(line):
    tab_pos = line.find('\t')
#     print 'tab_pos'+str(tab_pos)
#     print line[0:tab_pos]
    ident = int(line[0:tab_pos])
    return ident

def rfind3thTab(line):
    t = line.rfind('\t')
    t = line[0:t-1].rfind('\t')
    t = line[0:t-1].rfind('\t')
    return t

def rfind2thTab(line):
    t = line.rfind('\t')
    t = line[0:t-1].rfind('\t')
    return t


def updateLines():
    f = open('d:/work/regiontrans-mysql/script/clients_severtrans.txt','r')
    #new_file = open('d:/work/regiontrans-mysql/script/clients1_severtrans_test.txt','w')
    new_file = open('d:/work/regiontrans-mysql/script/clients1_severtrans.txt','w')
    i = 0;
    for line in f:
        line = line.replace('AdrName', 'address')
        line = line.replace('Ident', 'id\tident')
        line = line.replace('Name', 'name')
        line = line.replace('Acronym', 'alias')
        line = line.replace('Inn', 'inn')
        line = line.replace('KPP', 'kpp')
        line = line.replace('Email', 'email')
        line = line.replace('Saldo', 'saldo')
        line = line.replace('Kredit', 'kredit')
        line = line.replace('Name', 'city')
        #print line
#        line = line.lstrip('\n')
        if i >= 1:
            
            ident = getIdentFromLine(line)
            kredit = getClientKredit(ident)
            
            line = line.replace(chr(13), '')
            #ws = line.find('\t')
            rt3 = rfind3thTab(line)
            rt2 = rfind2thTab(line)
            line = str(i) + '\t' + line[0:rt3] + '\t'+ kredit + '\t' + line[rt2+1:]
            #line.encode('utf-8')#print line
            
        new_file.write(line)
        i = i + 1
#         if i>=10:
#             break
#         print line
if __name__ == '__main__':
    print "Updating lines in sql backup "
    updateLines()

