import csv
import random
import datetime
import os
from lxml import etree

tree = etree.parse("casting.xml")
tree2 = etree.parse("casting2.xml")

with open('casting.csv','w') as csvfile:
    fieldnames = ['description']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for desc in tree.xpath("/rss/channel/item/description"):
        writer.writerow({'description':desc.text})
    for desc in tree2.xpath("/rss/channel/item/description"):
        writer.writerow({'description':desc.text})


"""
casting seniors
Chant
Danse
Comédien
Figuration
Hôte 
Hôtesse
Mannequin
"""

