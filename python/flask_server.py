import matlab
import matlab.engine
from flask import Flask, url_for
from flask import render_template, request
from flask import jsonify
from flask_cors import CORS
import unicodedata
import json
import numpy as np


app = Flask(__name__)
CORS(app)
matlab_engine = matlab.engine.start_matlab()
clustered_images = []




def normalize_unicode_string(data):
    return unicodedata.normalize('NFKD', data).encode('ascii', 'ignore')
    


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/images")
def images():
    return render_template('main.html')


@app.route("/seed", methods=['GET', 'POST'])
def startSeedProcessing():
    import matlab
    print('SEED REQUEST')
    if request.method == 'POST':
        json = request.get_json()
        xSeedsCoordinates = []
        ySeedsCoordinates = []
        image_name = normalize_unicode_string(request.args.get('fileName'))
        distance_ratio = normalize_unicode_string(request.args.get('ratio'))
        distance_type = normalize_unicode_string(request.args.get('distance'))
        neigbr_number = normalize_unicode_string(request.args.get('neighboursNumber'))

        for el in json['payload']:
            xSeedsCoordinates.append(el['x'])
            ySeedsCoordinates.append(el['y'])

        xSeedsMatlabCoordinates = matlab.double(xSeedsCoordinates)
        ySeedsMatlabCoordinates = matlab.double(ySeedsCoordinates)
        

        output_img = matlab_engine.multiple_seeds_py(image_name, float(distance_ratio), distance_type, int(neigbr_number),
                                                     xSeedsMatlabCoordinates, ySeedsMatlabCoordinates, nargout=1)
        print(output_img)
        return jsonify({'result': output_img})

@app.route("/fuzzy/step1", methods=['GET'])
@app.route("/kmeans/step1", methods=['GET'])
def startKmeansStep1():
    if request.method == 'GET':
        image_name = normalize_unicode_string(request.args.get('fileName'))
        clusters_number = normalize_unicode_string(request.args.get('clustersNumber'))

        if(request.path == '/kmeans/step1'):
            clustered_uint8_images = matlab_engine.kmeans_py_step1(image_name, float(clusters_number), nargout=1)
        elif(request.path == '/fuzzy/step1'):
            clustered_uint8_images = matlab_engine.fuzzy_py_step1(image_name, float(clusters_number), nargout=1)
        print('REQUESTED URL: ',request.path)
        global clustered_images
        clustered_images = clustered_uint8_images
        return jsonify({'arrayOfImgs': clustered_images })

@app.route("/kmeans/step2", methods=['GET','POST'])
@app.route("/fuzzy/step2", methods=['GET','POST'])
def startMorphology():
    import matlab    
    json = request.get_json()    
    filter_number = json['payload']['filterNumber']
    image_index = json['payload']['imgNumber']
    
    xReconstructionCoords = []
    yReconstructionCoords = []
    se_size = 5

    if (json.get('payload').get('reconstructionCoords')):

        for el in json['payload']['reconstructionCoords']:
            xReconstructionCoords.append(el['x'])
            yReconstructionCoords.append(el['y'])

        xReconstructionCoords = matlab.double(xReconstructionCoords)
        yReconstructionCoords = matlab.double(yReconstructionCoords)
        print('MORPHOLOGY STEP2: ',filter_number,xReconstructionCoords,yReconstructionCoords)
    elif (json.get('payload').get('seSize')):
        se_size = json['payload']['seSize']
 
    global clustered_images
    processed_image = matlab_engine.morphology(str(filter_number),matlab.logical(clustered_images[int(image_index)]),xReconstructionCoords,yReconstructionCoords,float(se_size),nargout=1)  
    clustered_images = []
    clustered_images.append(processed_image)
    return jsonify({'processedImage': processed_image})

# @app.route("/fuzzy/step1", methods=['GET'])
# def startFuzzyStep1():
#     if request.method == 'GET':
#         image_name = normalize_unicode_string(request.args.get('fileName'))
#         clusters_number = normalize_unicode_string(request.args.get('clustersNumber'))

#         clustered_uint8_images = matlab_engine.fuzzy_py_step1(image_name, float(clusters_number), nargout=1)
#         global clustered_images
#         clustered_images = clustered_uint8_images
#         return jsonify({'arrayOfImgs': clustered_images })





@app.route("/matlab")
def matlab():
    return "some matlab content"


if __name__ == "__main__":
    app.debug = True
    app.run(host='localhost', port=3000)
