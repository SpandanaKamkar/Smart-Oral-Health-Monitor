import os
import cv2
import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, classification_report
from dental_disease_model import DentalDiseaseModel

# Dataset paths
dataset_paths = {
    "Healthy Teeth": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Healthy Teeth and Gums Images",
    "Dental Cavities": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Dental caries",
    "Teeth Discoloration": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Tooth Discoloration",
    "Plaque Buildup": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Plaque Buildup DataSet",
    "Mouth Ulcer": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Mouth Ulcer",
    "Gum Disease": "/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Gum Diseases DataSet",
}

# Label mapping
labels_dict = {i: label for i, label in enumerate(dataset_paths.keys())}

def load_dataset(dataset_paths, img_size=(128, 128)):
    """Loads and preprocesses images from dataset folders."""
    X, y = [], []
    valid_extensions = ('.jpg', '.jpeg', '.png')

    for label, (class_name, dir_path) in enumerate(dataset_paths.items()):
        if not os.path.exists(dir_path):
            print(f"⚠ Warning: Directory not found - {dir_path}")
            continue  # Skip missing directories

        print(f"📂 Loading images from: {class_name}")

        for img_name in os.listdir(dir_path):
            if not img_name.lower().endswith(valid_extensions):
                continue  # Skip non-image files

            img_path = os.path.join(dir_path, img_name)
            if os.path.isfile(img_path):
                img = cv2.imread(img_path)

                if img is None:
                    print(f"⚠ Warning: Failed to load image - {img_path}")
                    continue  # Skip unreadable image

                img = cv2.resize(img, img_size)
                img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # Convert to grayscale
                X.append(img.flatten())  # Flatten image for ML model
                y.append(label)

    return np.array(X), np.array(y)

# Load dataset
X, y = load_dataset(dataset_paths)

# Ensure dataset is loaded correctly
if len(X) == 0:
    raise ValueError("❌ No valid images found! Check dataset paths.")

# Split dataset into training & testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Initialize model
model = DentalDiseaseModel()

# Train model
model.train(X_train, y_train)

# Evaluate model
y_pred = model.model.predict(model.scaler.transform(X_test))
print(f"✅ Model Accuracy: {accuracy_score(y_test, y_pred):.2f}")
print("📊 Classification Report:\n", classification_report(y_test, y_pred))

# Save trained model
with open("dental_disease_model.pkl", "wb") as model_file:
    pickle.dump(model.model, model_file)

# Save scaler
with open("scaler.pkl", "wb") as scaler_file:
    pickle.dump(model.scaler, scaler_file)

print("✅ Model and scaler saved successfully!")
