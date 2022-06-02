# Script pour remplir la table Skill_needed

import csv
import random, time, math

size = 100
nb_casting = 70
data = []

nb_skill = [[i, 1] for i in range(nb_casting)]

for i in range(size - nb_casting):
    nb_skill[random.randint(0, nb_casting - 1)][1] += 1

for p in nb_skill:
    skills = []
    for i in range(p[1]):
        while True:
            id_skill = random.randint(1, 70)
            if not id_skill in skills:
                skills.append(id_skill)
                break
        data.append([p[0] + 1, id_skill])

with open("skill_needed.csv", "w+") as my_csv:
        csvWriter = csv.writer(my_csv, delimiter=',')
        csvWriter.writerow(['id_casting', 'id_skill'])
        csvWriter.writerows(data)
