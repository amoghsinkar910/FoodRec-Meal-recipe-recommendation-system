import cv2
import base64
import json
import torch
from PIL import Image

# model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5s.pt')  # local model
model = torch.hub.load('', 'custom', path='yolov5s.pt', source='local')  # local repo

# Image
im = 'images\\x2.jpg'

# Inference
results = model(im)

# results.print()

results.pandas().xyxy[0]  # Pandas DataFrame
# print(results.pandas().xyxy[0])

jfile = results.pandas().xyxy[0].to_json(orient="records")  # JSON img1 predictions
# print(type(jfile))
jfile = json.loads(jfile)
# print(jfile)

results.render()  # updates results.imgs with boxes and labels
for img in results.imgs:
    img_base64 = Image.fromarray(img)
    img_base64.save("image0.jpg", format="JPEG")
    # jfile.append({'im64': img_base64}) # TODO: not a base64 string

print(jfile)

