import numpy as np
import pandas as pd

df1 = pd.read_csv('data/epi_r.csv')
print(df1.shape)
# df1 = df1.dropna(how='any',axis=0) 
df1.reset_index(drop=True, inplace=True)
print(df1.shape)
print(df1.head())

df1.to_csv('data/epi2.csv')

# df11 = pd.read_csv('data/epi2.csv')


# print()
# print(df1.equals(df11))
# print(df1.shape, df11.shape)
# print(df1.columns)
# print(df11.columns)
# df2 = df1[df1.columns.difference(['alochol', 'anthony'])]