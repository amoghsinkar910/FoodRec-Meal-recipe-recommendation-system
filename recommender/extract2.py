import numpy as np
import pandas as pd
import json

df1 = pd.read_csv('data/epi3.csv', index_col=0)

num_rows = len(df1.index)
print(num_rows)
print()
col_list = list(df1.columns)

final_ing = []
for i in range(num_rows):
    ing1 = []
    for col in col_list:
        if df1.loc[i,col] == 1:
            ing1.append(col)
    s = " ".join(ing1)
    final_ing.append(s)

df2 = pd.read_csv('data/epi2.csv')

title_lis = df2['title'].tolist()



# print(final_ing)
# print(title_lis)

data = {
    'title' : title_lis ,
    'ingredients' : final_ing
}

df3 = pd.DataFrame(data)

print(df3.head())

df3.to_csv('data/epi4.csv')

# print(final_ing)