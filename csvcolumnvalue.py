#@author: Olatunji Ajibode (Ola)
#This Python script assumes you have a CSV file that contains data in columns

filename = datafile.csv
f = open(filename, 'rb')
col = 7 #column from which you want to extract value
usertotal = len(f.readlines())
f.close()
print("Total number of users in file: " + str(usertotal))
with open(filename, 'rt', encoding='utf8') as fa:
    i  = 0
    sumUp = 0
    mycsv = csv.reader(fa)
    mycsv = list(mycsv)
    for row in mycsv:
        if i< usertotal:
            columnValue = sumUp + int(row[col])
            sumUp = columnValue
            i = i + 1
    print(sumUp)
print 'End of process' 
