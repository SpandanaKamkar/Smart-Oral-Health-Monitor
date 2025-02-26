import os
from flask import Flask, request, send_file, jsonify
from predict_disease import detect_disease  # Import function from predict_disease.py
from flask import send_from_directory

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
PROCESSED_FOLDER = "processed"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PROCESSED_FOLDER, exist_ok=True)

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
    label = detect_disease(img_path, processed_img_path)  # Call function from predict_disease.py

    print("✅ Detected Disease:", label)
    print("✅ Processed Image Path:", processed_img_path)

    # Ensure the processed image exists
    if not os.path.exists(processed_img_path):
        return jsonify({"error": "Processed image not found"}), 404

    response = {
        "processed_image_url": f"/processed/processed_{file.filename}",  # Ensure correct file path
        "predicted_disease": label
    }

    print("✅ Returning Response:", response)
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)
