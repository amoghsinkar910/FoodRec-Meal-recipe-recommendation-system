import numpy as np
import pandas as pd
import json
import re

df1 = pd.read_csv('data/epi2.csv', index_col=0, encoding='utf8')

json_path = 'data/full_format_recipes.json' # Path of json recipe data
json_file = open(json_path)
jsonlist = json.load(json_file) # Python list
json_file.close()

df_length = len(df1.index)
json_length = len(jsonlist)

print(df_length, json_length)

dp = 0
jp = 0

finlist = []
errlist = []

problist = set([1368, 5132, 14382, 14628, 19803])
for ind in range(df_length):
    recipe_name1 = df1.iloc[ind, 0]
    recipe_name1 = recipe_name1.strip()
    if ind in problist:
        recipe_name1 = recipe_name1.replace('\r', '')
    found = False
    for y in jsonlist:
        recipe_name2 = y.get('title')
        if recipe_name2 is not None:
            recipe_name2 = recipe_name2.strip()
        if recipe_name1 == recipe_name2:
            found = True
            finlist.append(y)
            break
    
    if found == False:
        errlist.append((ind,recipe_name1))

print(len(finlist))

print(errlist)

print(finlist[0]['title'], finlist[-1]['title'])

path2 = 'data/full_recipes2.json'


with open(path2, "w") as outfile:
    json.dump(finlist, outfile)
        
      
