# Script pour remplir les tables Agent_Contract, Producer_contract

import csv
import random, time

id_artist = [i for i in range(1, 2001)]
random.shuffle(id_artist)

def random_date(start, end, prob_null):
    if random.random() > prob_null:
        stime = time.mktime(time.strptime(start, '%d/%m/%Y'))
        etime = time.mktime(time.strptime(end, '%d/%m/%Y'))
    else:
        return ''
    
    ptime = stime + random.random() * (etime - stime)
    return time.strftime('%d/%m/%Y', time.localtime(ptime))

def create_csv(table, size, size_duplicate, nb):
    id_agent_producer = [i for i in range(1, nb + 1)]
    random.shuffle(id_agent_producer)

    data = []
    for i in range(size - size_duplicate):
        agent_fee = "{:.2f}".format(round(random.uniform(1.0, 10.0), 2))
        if table == 'producer_contract':
            if random.random() > 0.5:
                agent_fee = 0.0
        
        start_date = random_date("01/01/2010", "01/01/2020", 0)
        end_date = random_date("01/01/2020", "09/05/2022", 0)
        
        data.append([id_artist[i], id_agent_producer[i], agent_fee, start_date, end_date])

    id_artist_dupl = []
    for i in range(size_duplicate):
        id_artist_dupl.append(id_artist[random.randint(0, size - size_duplicate - 1)])
    
    random.shuffle(id_agent_producer)
    for i in range(size_duplicate):
        agent_fee = "{:.2f}".format(round(random.uniform(1.0, 10.0), 2))
        if table == 'producer_contract':
            if random.random() > 0.5:
                agent_fee = 0.0
        
        start_date = random_date("01/01/2010", "01/01/2020", 0)
        end_date = random_date("01/01/2020", "09/05/2022", 0.25)
        
        data.append([id_artist_dupl[i], id_agent_producer[i], agent_fee, start_date, end_date])

    with open(table + ".csv","w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        if table == 'agent_contract':
            csvWriter.writerow(['id_artist', 'id_agent', 'agent_fee', 'start_date', 'end_date'])
        else:
            csvWriter.writerow(['id_artist', 'id_producer', 'agent_fee', 'start_date', 'end_date'])
    
        csvWriter.writerows(data)

create_csv('agent_contract', 800, 300, 1000)
create_csv('producer_contract', 400, 100, 800)
