import cv2
import base64
import json
# import torch
from PIL import Image, ImageOps

from flask import Flask, request, jsonify

# model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5xf1.pt')  # local model
# model = torch.hub.load('', 'custom', path='v3food2.pt', source='local')  # local repo

# Image
# resize to 416x416 first
image = cv2.imread('images\\x6.jpg')
size = (416, 416)
resized_down = cv2.resize(image, size, interpolation= cv2.INTER_AREA)
filename = 'resized.jpg'
cv2.imwrite(filename, resized_down)


resimg = cv2.imread('resized.jpg')
img_neg = cv2.bitwise_not(resimg)
cv2.imwrite('negative.jpg', img_neg)

# # Inference
# # Then load resized image
# im = 'resized.jpg'
# results = model(im)

# # results.print()

# results.pandas().xyxy[0]  # Pandas DataFrame
# # print(results.pandas().xyxy[0])

# jfile = results.pandas().xyxy[0].to_json(orient="records")  # JSON img1 predictions
# jfile = json.loads(jfile)
# # print(type(jfile))
# print(jfile)


# results.render()  # updates results.imgs with boxes and labels
# for img in results.imgs:
#     img_base64 = Image.fromarray(img)
#     img_base64.save("output.jpg", format="JPEG")
#     # jfile.append({'im64': img_base64}) # TODO: not a base64 string




# veg, imString = [], ''
# with open("output.jpg", "rb") as f:
# 	imString = base64.b64encode(f.read())
# imString = imString.decode("utf-8")
# # print(imString)
# # print(type(imString))

# for i in jfile:
# 	veg.append(i.get("name"))
# # print(veg)
# veg = list(set(veg))
# print(veg)
# retDict = {'foods': veg, 'imString' : imString}

# # print(json.dumps(retDict))