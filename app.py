import os
from flask import Flask, request, send_file, jsonify, send_from_directory
from predict_disease import detect_disease
from dental_disease_model import DentalDiseaseModel  # ✅ Import model
from remedies import get_remedy_links

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
PROCESSED_FOLDER = "processed"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PROCESSED_FOLDER, exist_ok=True)

# ✅ Initialize the model
dataset_paths = ["D:/Dental diseases/Training dataset"]  # ✅ Update dataset path
model = DentalDiseaseModel(dataset_paths)  # ✅ Pass dataset_paths to the model
model.load_model()  # ✅ Load the model

@app.route('/processed/<filename>')
def serve_processed_image(filename):
    return send_from_directory(PROCESSED_FOLDER, filename)

@app.route('/detect', methods=['POST'])
def detect():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'Empty filename'}), 400

    # Save uploaded file
    img_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(img_path)

    # Process image
    processed_img_path = os.path.join(PROCESSED_FOLDER, f"processed_{file.filename}")
    label = detect_disease(img_path, processed_img_path, model)  # ✅ Pass the model

    if label is None:
        return jsonify({"error": "Failed to detect disease"}), 500

    print("✅ Detected Disease:", label)
    print("✅ Processed Image Path:", processed_img_path)

    # Ensure the processed image exists
    if not os.path.exists(processed_img_path):
        return jsonify({"error": "Processed image not found"}), 404

    # Fetch remedy links
    remedy_links = get_remedy_links([label]) if label else []

    SERVER_IP = "192.168.0.7"  # ✅ Use your actual local IP

    response = {
        "processed_image_url": f"http://{SERVER_IP}:5000/processed/processed_{file.filename}",
        "predicted_disease": label,
        "remedy_links": remedy_links
    }

    print("✅ Returning Response:", response)
    return jsonify(response)

if __name__ == '__main__':
    app.run(host="192.168.0.7", port=5000, debug=True)
