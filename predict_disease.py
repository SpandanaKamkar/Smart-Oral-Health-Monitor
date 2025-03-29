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

def detect_disease(img_path, model):
    """ Predicts dental disease and displays result with bounding box. """
    if not os.path.exists(img_path):
        print(f"Error: Image not found - {img_path}")
        return

    img = cv2.imread(img_path)
    if img is None:
        print(f"Error: Unable to load image {img_path}")
        return

    prediction = model.predict(img)
    label = labels_dict.get(prediction, "Unknown")

    # Draw bounding box & label on image
    h, w, _ = img.shape
    start_point = (int(w * 0.25), int(h * 0.25))
    end_point = (int(w * 0.75), int(h * 0.75))
    color = (0, 255, 0) if prediction == 0 else (0, 0, 255)

    cv2.rectangle(img, start_point, end_point, color, 2)
    cv2.putText(img, label, (start_point[0], start_point[1] - 10),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 2)

    # Display result
    cv2.imshow('Dental Disease Detection', img)
    print(f"Predicted: {label}")
    cv2.waitKey(2000)  # Show for 2 seconds
    cv2.destroyAllWindows()

# Load model
model = DentalDiseaseModel()
model.load_model()

# Test dataset path
test_dir = r"D:\Dental diseases\Test dataset - Final"

# Run test on multiple images
for img_name in os.listdir(test_dir):
    img_path = os.path.join(test_dir, img_name)
    detect_disease(img_path, model)