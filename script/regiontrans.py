
"""
script reads first line of file and changes column names
"""
def changeFirstLine():
    f = open('d:/work/regiontrans-mysql/script/clients.txt','r')
    new_file = open('d:/work/regiontrans-mysql/script/clients1.txt','w')
    for line in f:
        line = line.replace('Ident', 'id')
        line = line.replace('Acronym', 'alias')
        line = line.replace('Inn', 'inn')
        line = line.replace('KPP', 'kpp')
        line = line.replace('Email', 'email')
        line = line.replace('Saldo', 'saldo')
        line = line.replace('Kredit', 'kredit')
        line = line.replace('Name', 'city')
        line = line.replace('AdrName', 'address')
        new_file.write(line)

if __name__ == '__main__':
    print "Updating lines in sql backup "
    changeFirstLine()

