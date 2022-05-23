# Flask API for getting recipe rcommendations from ingredients

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

import flask
from flask import request, jsonify


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

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Recipe Recommendation API</h1>'''

@app.route('/rec/<ings>', methods=['GET'])
def recs(ings):
    newvec = average_vector(str(ings))
    simlist = []

    for ind, vec in enumerate(loadvecs):
        simscore = cosine_similarity_2(newvec, vec)
        simlist.append((simscore, ind))
    
    toplist = sorted(simlist, reverse=True) [:5]  #Get top 5 recommendations

    retlist = [jsonlist[ind] for simscore,ind in toplist]

    # retlist = []
    # for tup in toplist:
    #     ind = tup[1]
    #     rec = jsonlist[ind]
    #     retlist.append(rec)
    
    return jsonify(retlist)

app.run(host='0.0.0.0', port = 9000)

