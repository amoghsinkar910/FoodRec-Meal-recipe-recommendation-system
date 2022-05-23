import numpy as np
import pandas as pd
from string import printable


# df1.to_csv('data/epi2.csv', index=False)

df1 = pd.read_csv('data/epi2.csv', index_col=0, encoding='utf8')

exclusion_list_1 = ['title','rating', 'calories', 'protein', 'fat', 'sodium']

exclusion_list_2 = [ 'title','rating', 'calories', 'protein', 'fat', 'sodium',
'calories', 'protein', 'fat', 'sodium', '#cakeweek', '#wasteless', '22-minute meals', 
'3-ingredient recipes', '30 days of groceries', 'advance prep required', 'alabama', 'alaska', 'alcoholic', 'anniversary',
 'anthony bourdain', 'appetizer', 'arizona', 'atlanta', 'australia', 'back to school', 'backyard bbq', 'bake', 'bastille day', 'beverly hills', 
 'birthday', 'blender', 'boil', 'bok choy', 'bon appétit', 'boston', 'braise', 'broil', 'brooklyn', 'brunch', 'buffalo', 
 'buffet', 'bulgaria', 'california', 'cambridge', 'camping', 'canada', 'candy thermometer', 'casserole/gratin', 'chicago', 'chile',
 'chill', 'christmas', 'christmas eve', 'cinco de mayo', 'cocktail', 'cocktail party', 'coffee grinder', 'colorado', 'columbus',
 'condiment', 'condiment/spread', 'connecticut', 'cook like a diner', 'cookbook critic', 'costa mesa', 'cuba', 'dairy', 'dairy free',
 'dallas', 'date', 'deep-fry', 'denver', 'dessert', 'dinner', 'dip', 'diwali', 'dominican republic', 'dorie greenspan', 'double boiler',
 'dried fruit', 'drink', 'drinks', 'easter', 'edible gift', 'egypt', 'emeril lagasse', 'engagement party', 'england', 'entertaining',
 'epi + ushg', 'epi loves the microwave', 'fall', 'fall', 'family reunion', 'fat free', "father's day", 'flaming hot summer',
 'florida', 'food processor', 'fourth of july', 'france', 'frankenrecipe', 'freeze/chill', 'freezer food', 'friendsgiving', 
 'fritter', 'frozen dessert', 'fruit juice', 'fry', 'game', 'georgia', 'germany', 'gourmet', 'graduation', 'grains', 'grill',
 'grill/barbecue', 'guam', 'haiti', 'halloween', 'hanukkah', 'harpercollins', 'hawaii', 'healdsburg', 'healthy', 'high fiber',
 'hollywood', "hors d'oeuvre", 'hot drink', 'house & garden', 'house cocktail', 'houston', 'ice cream machine', 'idaho',
 'illinois', 'indiana', 'iowa', 'ireland', 'israel', 'italy', 'jamaica', 'japan', 'jerusalem artichoke', 'juicer', 'kansas', 
 'kansas city', 'kentucky', 'kentucky derby', 'kid-friendly', 'kidney friendly', 'kitchen olympics', 'kosher',
 'kosher for passover', 'kwanzaa', 'labor day', 'lancaster', 'las vegas', 'london', 'long beach', 'los angeles', 'louisiana', 
 'louisville', 'low cal', 'low carb', 'low cholesterol', 'low fat', 'low sodium', 'low sugar', 'low/no sugar', 'lunar new year',
 'lunch', 'maine','mandoline', 'mardi gras', 'marinade', 'marinate', 'maryland', 'massachusetts', 'meat', 'mexico', 'miami', 
 'michigan', 'microwave', 'minneapolis', 'minnesota', 'mississippi', 'missouri', 'mixer', 'mortar and pestle', "mother's day",
 'nancy silverton', 'nebraska', 'new hampshire', 'new jersey', 'new mexico', 'new orleans', "new year's day", "new year's eve",
 'new york', 'no meat, no problem', 'no sugar added', 'no-cook', 'non-alcoholic', 'north carolina', 'ohio', 'oklahoma', 
 'oktoberfest', 'one-pot meal', 'oregon', 'organic', 'oscars', 'pacific palisades', 'paleo', 'pan-fry', 'parade', 'paris',
 'party', 'pasadena', 'passover', 'pasta maker', 'peanut free', 'pennsylvania', 'persian new year', 'peru', 'pescatarian',
 'philippines', 'picnic', 'pittsburgh', 'poach', 'poker/game night', 'portland', 'potluck', 'poultry', 'pressure cooker', 'providence',
 'purim', 'quail', 'quick & easy', 'quick and healthy', 'ramadan', 'ramekin', 'raw', 'rhode island', 'roast', 'rosh hashanah/yom kippur',
 'san francisco', 'sandwich theory', 'santa monica', 'sauté', 'seafood', 'seattle', 'self', 'shavuot', 'shower', 'side', 'simmer', 
 'skewer', 'slow cooker', 'smoker', 'south carolina', 'soy free', 'spain', 'spring', 'st. louis', "st. patrick's day", 
 'steam', 'stir-fry', 'stuffing/dressing', 'sugar conscious', 'sukkot', 'summer', 'super bowl', 'suzanne goin', 'switzerland', 
 'tailgating', 'tennessee', 'tested & improved', 'texas', 'thanksgiving', 'tree nut free', 'tropical fruit', 'utah', "valentine's day",
 'vegan', 'vegetarian', 'vermont', 'virginia', 'washington', 'washington, d.c.', 'wedding', 'weelicious',
 'west virginia', 'westwood', 'wheat/gluten-free', 'windsor', 'winter', 'wisconsin', 'wok', 'yonkers', 
 'cookbooks', 'leftovers', 'snack', 'snack week'] # incomplete


df2 = df1.drop(columns=exclusion_list_2)
# print(list(df2.columns))

col_lis = list(df2.columns)

final_list = []
special_char = []

for col in col_lis:
    if set(col).difference(printable):
        special_char.append(col)
    else:
        final_list.append(col)

xy = 0
for i in range(len(special_char)):
    if i!=0 and i!=3:
        xy+=1
        final_list.append(special_char[i])

final_list.sort()
df3 = df2[final_list]
df3 = df3.dropna(how='any',axis=0) 
df3.reset_index(drop=True, inplace=True)



print(df3.head())



df3.to_csv('data/epi3.csv')
# print(df11.columns)
# df2 = df1[df1.columns.difference(['alochol', 'anthony'])]

# any(not c.isalnum() for c in mystring)

print()
print(special_char)
print(xy)