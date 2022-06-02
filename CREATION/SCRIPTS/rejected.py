# Script pour remplir la table Rejected

import csv
import random, time, math

size = 500
nb_casting = 70
nb_artist = 2000

casting_skills = []
with open('skill_needed.csv', 'r') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    i = 0
    for row in spamreader:
        casting_skills.append(row)
        i += 1

people_skills_data = []
with open('people_skill.csv', 'r') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    i = 0
    for row in spamreader:
        people_skills_data.append(row)
        i += 1

cast_skill = []
for i in range(nb_casting):
    skills = []
    for row in casting_skills:
        if row[0] == str(i + 1):
            skills.append(int(row[1]))
    cast_skill.append(skills)

artist_skill = []
for i in range(nb_artist):
    skills = []
    for row in people_skills_data:
        if row[0] == str(i + 1):
            skills.append(int(row[1]))
    artist_skill.append(skills)


def array_equals(artist, casting):
    if len(artist) < len(casting):
        return False
    
    for a, b in zip(artist, casting):
        if a != b:
            return False
    return True

potentials = []
for j, casting in enumerate(cast_skill):
    for i, artist in enumerate(artist_skill):
        if array_equals(artist, casting):
            potentials.append([j + 1, i + 1])

random.shuffle(potentials)
potentials = potentials[:size]

with open("rejected.csv", "w+") as my_csv:
    csvWriter = csv.writer(my_csv, delimiter=',')
    csvWriter.writerow(['id_casting', 'id_artist'])
    csvWriter.writerows(potentials)