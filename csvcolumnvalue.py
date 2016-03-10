#@author: Olatunji Ajibode (Ola)
#This Python script assumes you have a CSV file that contains data in columns
import csv

#TODO: Replace with functional programming REDUCE function?

f = open("datafile.csv")
csvreader = csvreader(f)
views = list(csvreader)

col = 7 #column from which you want to extract value
sum_up = 0
for row in views:
    sum_up += int(row[7])

return sum_up

print('End of process') 
