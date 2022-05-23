import os
import cv2
import base64
import json
# import torch
from PIL import Image

from flask import Flask, request, jsonify

# model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5xf1.pt')  # local model
# model = torch.hub.load('', 'custom', path='v1food4.pt', source='local')  # local repo

app = Flask(__name__)

# cnt = 0

@app.route("/detect", methods=["POST"])
def detect():
    # global cnt
    b = request.json
    # print(b)
    img, t, name = base64.b64decode(b.get("base64")), b.get("type"), ''
    if t == "png":
        name = "input.png"
    elif t == "jpg":
        name = "input.jpg"
    else:
        name = "input.jpeg"
    with open(name, "wb") as f:
        f.write(img)

    # Load image and resize
    image = cv2.imread(name)
    size = (416, 416)
    resized_down = cv2.resize(image, size, interpolation=cv2.INTER_AREA)
    filename = 'resized.jpg'
    cv2.imwrite(filename, resized_down)

    if os.path.exists('negative.jpg'):
        os.remove('negative.jpg')
    
    resimg = cv2.imread('resized.jpg')
    img_neg = cv2.bitwise_not(resimg)
    cv2.imwrite('negative.jpg', img_neg)

    negString = ''
    with open('negative.jpg', "rb") as f:
        negString = base64.b64encode(f.read())
    negString = negString.decode('utf-8')
    
    veg = ['Carrot', 'Tomato', 'Grape']

    retDict = {'foods': '_'.join(veg), 'imString': negString}
    return jsonify(retDict)
    # Inference
    # Load resized image
    # im = 'resized.jpg'
    # results = model(im)

    # results.pandas().xyxy[0]  # Pandas DataFrame
    # print(results.pandas().xyxy[0])

    
    # imgName = "output.jpg"
    # if os.path.exists(imgName):
    #     os.remove(imgName)
    
    # jfile = results.pandas().xyxy[0].to_json(orient="records")  # JSON img1 predictions - type string
    # # print(type(jfile))
    # jfile = json.loads(jfile)  # Now jfile is a list of dicts

    # results.render()  # updates results.imgs with boxes and labels
    # for img in results.imgs:
    #     img_base64 = Image.fromarray(img)
    #     img_base64.save(imgName, format="JPEG")
    #     # jfile.append({'im64': img_base64}) # TODO: not a base64 string

    # veg, imString = [], ''
    
    # with open(imgName, "rb") as f:
    #     imString = base64.b64encode(f.read())

    # # f = open(imgName, 'rb')
    # # imString = base64.b64encode(f.read())
    # # f.flush()
    # # f.close()
    # # print(imString[-40:], imgName, sep = '\n\n\n')
    # imString = imString.decode('utf-8')
    # # print(imString[-40:], imgName, sep = '\n\n\n')
    # for i in jfile:
    #     veg.append(i.get("name"))
        


    # veg = list(set(veg)) # veg is a list of strings
    # retDict = {'foods': '_'.join(veg), 'imString': imString}
    # # print(cnt)


    # # if cnt>0:
    # #     s1, s2 = '', ''
    # #     n1 = "output" + str(cnt-1) + ".jpg"
    # #     n2 = "output" + str(cnt) + ".jpg"
    # #     with open(n1, "rb") as f:
    # #         s1 = base64.b64encode(f.read())
    # #         f.close()
    # #     s1 = s1.decode('utf-8')
    # #     with open(n2, "rb") as f:
    # #         s2 = base64.b64encode(f.read())
    # #         f.close()
    # #     s2 = s2.decode('utf-8')
    # #     print(len(s1), len(s2))
    # #     # print(s1[:20000]==s2[:20000])
    # #     print(retDict['imString']==s1)
    # #     print(retDict['imString']==s2)
    
    # # cnt+=1
    
    # return jsonify(retDict)


@app.route('/')
def hello():
    return '<h1>TESTING API</h1>'


app.run(host='0.0.0.0', debug=True)