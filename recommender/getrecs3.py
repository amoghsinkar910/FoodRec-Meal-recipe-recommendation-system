import numpy as np
import pandas as pd
import json
import re
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import sent_tokenize,word_tokenize

# nltk.download('wordnet')
# nltk.download('punkt')
# nltk.download('stopwords')

vec_path = 'glove/glove.6B.100d.txt' # Glove embeddings file
embeddings_file = open(vec_path, 'r', encoding="utf8")
print('CP-1')
embeddings = dict()

for line in embeddings_file:
    values = line.split()
    word = values[0]
    coefs = np.asarray(values[1:], dtype='float64')
    embeddings[word] = coefs

embeddings_file.close()

json_path = 'data/full_recipes2.json' # Path of json recipe data
json_file = open(json_path)
jsonlist = json.load(json_file) # Python list
json_file.close()
# jsondata = pd.read_json(json_path)
print('CP-2')

def clean(sentence):
    lem = WordNetLemmatizer()
    sentence = sentence.lower()
    sentence = re.sub(r'http\S+',' ',sentence)
    sentence = re.sub(r'[^a-zA-Z]',' ',sentence)
    sentence = sentence.split()
    sentence = [lem.lemmatize(word) for word in sentence if word not in stopwords.words('english')]
    sentence = ' '.join(sentence)
    return sentence

def average_vector(sentence):
    sentence = clean(sentence)
    words = sentence.split()
    size = len(words)
    average_vector = np.zeros((size,100))
    # unknown_words=[]

    for index, word in enumerate(words):
        try:
            average_vector[index] = embeddings[word].reshape(1,-1)
        except Exception as e:
            # unknown_words.append(word)
            average_vector[index] = 0

    if size != 0:
        average_vector = sum(average_vector)/size
    return average_vector

def cosine_similarity(s1, s2):
    v1 = average_vector(s1)
    v2 = average_vector(s2)
    cos_sim = 0
    try:
        cos_sim = (np.dot(v1,v2)/(np.linalg.norm(v1)*np.linalg.norm(v2)))
    except Exception as e :
        pass
    return cos_sim

def cosine_similarity_2(v1, v2):
    cos_sim = 0
    try:
        cos_sim = (np.dot(v1,v2)/(np.linalg.norm(v1)*np.linalg.norm(v2)))
    except Exception as e :
        pass
    return cos_sim

print('CP-3')


# print(jsondata.loc[jsondata['title'] == 'Baked Ham with Marmalade-Horseradish Glaze '])
loadvecs = np.loadtxt('data/ingvec.txt')
# df1 = pd.read_csv('data/epi2.csv', index_col=0, encoding='utf8')
# jsondata.set_index('title', inplace=True)


while True:
    print('\n')
    newings = input('Enter ingredients: ')
    newvec = average_vector(newings)
    simlist = []

    for ind, vec in enumerate(loadvecs):
        simscore = cosine_similarity_2(newvec, vec)
        simlist.append((simscore, ind))
    
    toplist = sorted(simlist, reverse=True) [:3]

    displist = []

    for tup in toplist:
        ind = tup[1]
        rec = jsonlist[ind]

        # ind2 = jsondata[jsondata['title'] == recipe_name].index[0]
        print("\nIndex: ", ind) # Prints index
        dish_title = rec['title']
        print('Recipe Name: ', dish_title)
        dish_match = round(tup[0]*100, 2)
        print('Match: ', dish_match)
        dish_sodium = rec['sodium']
        print('Sodium: ', dish_sodium)
        print('\n')
    
    cho = input('Do you wish to continue? (y/n) ')
    if cho=='n':
        break


print('\n\n***END***')

