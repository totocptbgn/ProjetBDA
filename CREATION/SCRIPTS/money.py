# Script pour remplir la table Payment et Claim

import csv
import random, time, math

size_claim = 100

def random_date(start, end):
    time_format = '%d/%m/%Y'
    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime(end , time_format))
    ptime = stime + random.random() * (etime - stime)
    return time.strftime(time_format, time.localtime(ptime))

prod_data = []
try:
    with open('producer_contract.csv', 'r') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in spamreader:
            prod_data.append([i] + row)
            i += 1
except FileNotFoundError:
    print('Il faut le fichier producer_contract.csv dans le répertoire courrant pour générer amendment.csv.')


agent_data = []
try:
    with open('agent_contract.csv', 'r') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in spamreader:
            agent_data.append([i] + row)
            i += 1
except FileNotFoundError:
    print('Il faut le fichier agent_contract.csv dans le répertoire courrant pour générer amendment.csv.')

related_contract = []
for ag_row in agent_data[1:]:
    for prod_row in prod_data[1:]:
        if ag_row[1] == prod_row[1]:
            related_contract.append([ag_row[0], prod_row[0], prod_row[4], prod_row[5]])


for row in related_contract:
    if row[3] == '':
        row[3] = "07/05/2022"

random.shuffle(related_contract)

claim_data = []
cond = True
n = 0
ind = 0

while cond:
    a = math.floor(random.triangular(1, 3, 1))
    n += a 
    if n >= size_claim:
        cond = False
        if n != size_claim:
            a = a - (n - size_claim)

    for i in range(a):
        id_contract_agent = related_contract[ind][0]
        id_contract_producer = related_contract[ind][1]
        due_date = random_date(prod_row[4], prod_row[5])
        value = "{:.2f}".format(round(random.uniform(20.0, 10000.0), 2))

        claim_data.append([id_contract_agent, id_contract_producer, due_date, value])
    ind += 1

with open("claim.csv", "w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        csvWriter.writerow(['id_contract_agent', 'id_contract_producer', 'due_date', 'value'])
        csvWriter.writerows(claim_data)

payment_data = []
size_payment = 150

pay = [[i, 1] for i in range(size_claim)]

for i in range(size_payment - size_claim):
    pay[random.randint(0, size_claim - 1)][1] += 1

for i in range(size_claim):
    total = float(claim_data[i][3])
    a = pay[i][1]
    tt = list([round(total / a, 2)] * a)
    diff = round(total - sum(tt), 2)
    tt[len(tt) - 1] += diff

    for sub in tt:
        id_claim = i+1
        value = round(sub, 2)
        date = claim_data[i][2]
        payment_data.append([id_claim, value, date])

with open("payment.csv", "w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        csvWriter.writerow(['id_claim', 'value', 'date'])
        csvWriter.writerows(payment_data)