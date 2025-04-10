import os
import cv2
from dental_disease_model import DentalDiseaseModel

# ✅ Label Mapping
labels_dict = {
    0: "Healthy Teeth",
    1: "Dental Cavities",
    2: "Teeth Discoloration",
    3: "Plaque Buildup",
    4: "Mouth Ulcer",
    5: "Gum Disease"
}

def detect_disease(img_path, processed_img_path, model):
    """Predicts dental disease and saves processed image."""
    if not os.path.exists(img_path):
        print(f"❌ Error: Image not found - {img_path}")
        return None

    img = cv2.imread(img_path)
    if img is None:
        print(f"❌ Error: Unable to load image {img_path}")
        return None

    # ✅ Resize and process image
    img_resized = cv2.resize(img, (128, 128))
    img_gray = cv2.cvtColor(img_resized, cv2.COLOR_BGR2GRAY)  # Convert to grayscale

    prediction = model.predict(img_gray)
    label = labels_dict.get(prediction, "Unknown")

    # ✅ Draw bounding box and label
    h, w, _ = img.shape
    start_point = (int(w * 0.25), int(h * 0.25))
    end_point = (int(w * 0.75), int(h * 0.75))
    color = (0, 255, 0) if prediction == 0 else (0, 0, 255)

    cv2.rectangle(img, start_point, end_point, color, 2)
    cv2.putText(img, label, (start_point[0], start_point[1] - 10),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 2)

    # ✅ Save processed image
    cv2.imwrite(processed_img_path, img)

    print(f"✅ Predicted: {label}")
    return label

# ✅ Load model
model = DentalDiseaseModel()
model.load_model()
