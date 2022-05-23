import numpy as np
import pandas as pd
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

print('CP-3')

df1 = pd.read_csv('data/epi4.csv', index_col=0)

ingredient_list = df1['ingredients'].tolist()

print('CP-4')

vecs = []
cnt = 0

for sen in ingredient_list:
    try:
        x = average_vector(sen)
        vecs.append(x)
        # cnt+=1
    except Exception as e:
        temp = np.zeros(100)
        vecs.append(temp)
        # cnt+=1



final_vecs = np.array(vecs)

print(final_vecs.shape)


np.savetxt('data/ingvec.txt', final_vecs)

# loadvecs = np.loadtxt('data/ingvec.txt')

# print()
# print(loadvecs.shape)
