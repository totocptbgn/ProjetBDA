# Script pour remplir les tables Agent, Artist et Producer
# Pour installer pandas : pip install pandas

import pandas
import random, time

def random_date(age):
    time_format = '%d/%m/%Y'
    year = str(2022 - int(age))
    stime = time.mktime(time.strptime("01/01/" + year, time_format))
    etime = time.mktime(time.strptime("31/12/" + year, time_format))
    ptime = stime + random.random() * (etime - stime)
    return time.strftime(time_format, time.localtime(ptime))

def create_csv(table, size):
    df = pandas.read_csv('sample.csv', low_memory=False)
    df = df[df.age < 60]
    df = df[df.age > 20]
    df = df.sample(size)
    df = df[['nom', 'prenom', 'age']].rename(columns={"nom": "name", "prenom": "firstname"})
    df['birthdate'] = df['age'].apply(random_date)
    df = df.drop(columns=['age'])

    df.to_csv(table + '.csv', index=False)

create_csv('artist', 2000)
create_csv('producer', 800)
create_csv('agent', 1000)