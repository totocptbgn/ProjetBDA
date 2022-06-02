# Script pour remplir la table Amendment

import csv
import random, time, math

def random_date(start = "01/01/2010"):
    time_format = '%d/%m/%Y'
    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime("01/05/2022" , time_format))
    ptime = stime + random.random() * (etime - stime)
    return time.strftime(time_format, time.localtime(ptime))

def random_fee():
    return "{:.2f}".format(round(random.uniform(1.0, 10.0), 2))

prod_data = []
try:
    with open('producer_contract.csv', 'r') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',')
        for row in spamreader:
            prod_data.append(row)
except FileNotFoundError:
    print('Il faut le fichier producer_contract.csv dans le répertoire courrant pour générer amendment.csv.')



data = [['id_contract', 'attr', 'old_value', 'new_value', 'date']]
attr_list = ['bonus_fee', 'end_date']
size = 100
cond = True
n = 0
ind = 0

id_contract = [i for i in range(1, 401)]
random.shuffle(id_contract)

while cond:
    a = math.floor(random.triangular(1, 5, 1))
    n += a 
    if n >= size:
        cond = False
        if n != size:
            a = a - (n - size)

    old_attr = [random_fee(), random_date()]

    for i in range(a):
        idc = id_contract[ind]
        b = random.randint(0, 1)
        attr = attr_list[b]
        old_value = old_attr[b]

        if i == a - 1:
            if b == 0:
                new_value = prod_data[idc][2]
            else:
                new_value = prod_data[idc][4]
        else:
            if b == 0:
                new_value = random_fee()
            else:
                new_value = random_date(old_attr[1])

        if new_value == '':
            new_value = 'NULL'
        
        date = random_date(prod_data[idc][3])
        data.append([idc, attr, old_value, new_value, date])
        old_attr[b] = new_value

    ind += 1


with open("amendment.csv","w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        csvWriter.writerows(data)

