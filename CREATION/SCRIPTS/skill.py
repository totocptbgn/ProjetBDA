# Script pour remplir la table People_skill

import csv
import random, time, math

from numpy import append

nb_people = 2000
size = 3000
data = []

nb_skill = [[i, 1] for i in range(nb_people)]

for i in range(size - nb_people):
    nb_skill[random.randint(0, nb_people - 1)][1] += 1

for p in nb_skill:
    skills = []
    for i in range(p[1]):
        while True:
            if i == 0:
                id_skill = random.randint(1, 9)
                skills.append(id_skill)
                break
            else:
                id_skill = random.randint(1, 70)
                if not id_skill in skills:
                    skills.append(id_skill)
                    break

        data.append([p[0] + 1, id_skill])

with open("people_skill.csv", "w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        csvWriter.writerow(['id_artist', 'id_skill'])
        csvWriter.writerows(data)