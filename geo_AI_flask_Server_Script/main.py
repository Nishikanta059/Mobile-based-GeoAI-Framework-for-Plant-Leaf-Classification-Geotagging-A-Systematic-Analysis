from flask import Flask,jsonify
from flask import Flask, make_response
from flask import request
from PIL import Image
from keras.models import  load_model
import numpy as np
import io
from skimage import  transform
import cv2
import requests
import base64
from datetime import date
from datetime import datetime




import torch
from torch.autograd import Variable
from torchvision import transforms
from numpy import asarray
import numpy as np
from PIL import Image
from model import U2NET # full size version 173.6 MB
from model import U2NETP # small version u2net 4.7 MB

app=Flask(__name__)



label2Class=['Acer Palmatum',
 'Acer buergerianum Miq',
 'Aesculus chinensis',
 'Berberis anhweiensis Ahrendt',
 'Cedrus deodara (Roxb.) G. Don',
 'Cercis chinensis',
 'Chimonanthus praecox L',
 'Cinnamomum camphora (L.) J. Presl',
 'Cinnamomum japonicum Sieb',
 'Citrus reticulata Blanco',
 'Ginkgo biloba L',
 'Ilex macrocarpa Oliv',
 'Indigofera tinctoria L',
 'Kalopanax septemlobus (Thunb. ex A.Murr.) Koidz',
 'Koelreuteria paniculata Laxm',
 'Lagerstroemia indica (L.) Pers',
 'Ligustrum lucidum Ait. f',
 'Liriodendron chinense (Hemsl.) Sarg',
 'Magnolia grandiflora L',
 'Mahonia bealei (Fortune) Carr',
 'Manglietia fordiana Oliv',
 'Nerium oleander L',
 'Osmanthus fragrans Lour',
 'Phoebe nanmu (Oliv.) Gamble',
 'Phyllostachys edulis (Carr.) Houz',
 'Pittosporum tobira (Thunb.) Ait. f',
 'Podocarpus macrophyllus (Thunb.) Sweet',
 'Populus ×canadensis Moench',
 'Prunus persica (L.) Batsch',
 'Prunus serrulata Lindl. var. lannesiana auct',
 'Tonna sinensis M. Roem',
 'Viburnum awabuki K.Koch']



def normPRED(d):
    ma = torch.max(d)
    mi = torch.min(d)

    dn = (d-mi)/(ma-mi)

    return dn


model_path="resnet50flavia_nor.h5"
img_size=128

model = load_model(model_path)
print('hi classification model loaded')


net = U2NET(3,1)
model_dir='u2net.pth'

if torch.cuda.is_available():
    net.load_state_dict(torch.load(model_dir))
    net.cuda()
else:
 net.load_state_dict(torch.load(model_dir, map_location='cpu'))
net.eval()
print('hi u2net model loaded')
transform = transforms.Compose([
    transforms.Resize((320, 320)),    # Rescale the image to 320x320
    transforms.ToTensor(),           # Convert the image to a PyTorch tensor
    transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]),  # Normalize the pixel values to the range [-1, 1]
])


@app.route('/')
def hello_world():
    now = datetime.now()
    return 'hello,world'+' '+str(now)



@app.route("/imsnew", methods=["POST"])
def process_image2():
    imglink = request.form["link"]
    f = open('tempimg.jpg','wb')
    f.write(requests.get(imglink).content)
    f.close()
    img = Image.open('tempimg.jpg')
    
   

    imz=img.size
    uimg = transform(img)
    umig = uimg.type(torch.FloatTensor)
    uimg = uimg.unsqueeze(0)

    if torch.cuda.is_available():
        inputs_test = Variable(uimg.cuda())
    else:
       inputs_test = Variable(uimg)

    d1,d2,d3,d4,d5,d6,d7= net(inputs_test)

    pred = d1[:,0,:,:]
    pred = normPRED(pred)
    pred = pred.squeeze()
    predict_np = pred.cpu().data.numpy()
    im = Image.fromarray(predict_np*255).convert('RGB')
    imo = im.resize((imz[0],imz[1]),resample=Image.BILINEAR)

    img_org=asarray(img)
    img_mask=asarray(imo)
    res= cv2.bitwise_and(img_org,img_mask, mask=None)

    cimg = img.resize((img_size,img_size))
    cimg = np.array(cimg,dtype="uint8")
    cimg=np.array([cimg])
    
    
    output = model(cimg)
    arr=output[0]
    sorted=np.argsort(-arr)
    classIds=sorted[:3]




    resString=""
    for i in classIds:
      resString+=str(i)+"-"+str(float(arr[i]))+"*"


   
    res=Image.fromarray(res)
    imgByteArr = io.BytesIO()
    res.save(imgByteArr, format='PNG')
    imgByteArr.seek(0)
    bimg=imgByteArr.getvalue()




    response = make_response(bimg)
    response.headers.set('Content-Type', 'image/png')
    response.headers.set('Content-Disposition',str(resString))

    del d1,d2,d3,d4,d5,d6,d7

    return response


if  __name__=="__main__":
    app.run(debug=True)    

