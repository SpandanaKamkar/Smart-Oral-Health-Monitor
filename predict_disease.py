import os
import cv2
import numpy as np
from dental_disease_model import DentalDiseaseModel

# Label mapping
labels_dict = {
    0: "Healthy Teeth",
    1: "Dental Cavities",
    2: "Teeth Discoloration",
    3: "Plaque Buildup",
    4: "Mouth Ulcer",
    5: "Gum Disease"
}

# Load model once
model = DentalDiseaseModel(['/Users/ssanjay/PycharmProjects/Smart-Oral-Health-Monitor/dental_disease.model'])
model.load_model()

def detect_disease(img_path, save_path):
    """ Predicts dental disease, processes the image, and saves it. """
    if not os.path.exists(img_path):
        print(f"Error: Image not found - {img_path}")
        return

    img = cv2.imread(img_path)
    if img is None:
        print(f"Error: Unable to load image {img_path}")
        return

    # Predict disease
    prediction = model.predict(img)
    label = labels_dict.get(prediction, "Unknown")

    # Draw bounding box & label
    h, w, _ = img.shape
    start_point = (int(w * 0.25), int(h * 0.25))
    end_point = (int(w * 0.75), int(h * 0.75))
    color = (0, 255, 0) if prediction == 0 else (0, 0, 255)

    cv2.rectangle(img, start_point, end_point, color, 2)
    # cv2.putText(img, label, (start_point[0], start_point[1] - 20), cv2.FONT_HERSHEY_SIMPLEX, 1, color, 4)

    # Save processed image
    cv2.imwrite(save_path, img)
    print(f"✅ Processed image saved at: {save_path}")

    return label