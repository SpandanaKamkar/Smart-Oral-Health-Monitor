import os
import cv2
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
from dental_disease_model import DentalDiseaseModel

# Dataset paths
dataset_paths = {
    "Healthy Teeth": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Healthy Teeth and Gums Images',
    "Dental Cavities": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Dental caries',
    "Teeth Discoloration": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Tooth Discoloration',
    "Plaque Buildup": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Plaque Buildup DataSet',
    "Mouth Ulcer": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Mouth Ulcer',
    "Gum Disease": '/Users/ssanjay/Documents/FYP/Smart_oral_health_monitor/Dental diseases/Gum Diseases DataSet',
}

# Label mapping
labels_dict = {
    0: "Healthy Teeth",
    1: "Dental Cavities",
    2: "Teeth Discoloration",
    3: "Plaque Buildup",
    4: "Mouth Ulcer",
    5: "Gum Disease"
}

def load_dataset(dataset_paths, img_size=(128, 128)):
    """ Loads and preprocesses images from dataset folders. """
    X, y = [], []
    model = DentalDiseaseModel(dataset_paths)

    for label, (class_name, dir_path) in enumerate(dataset_paths.items()):
        if not os.path.exists(dir_path):
            print(f"Warning: Directory not found - {dir_path}")
            continue

        for img_name in os.listdir(dir_path):
            img_path = os.path.join(dir_path, img_name)
            if os.path.isfile(img_path):
                img = cv2.imread(img_path)
                img = cv2.resize(img, img_size)
                features = model.extract_features(img)
                X.append(features)
                y.append(label)

    return np.array(X), np.array(y)

# Load dataset
X, y = load_dataset(dataset_paths)

# Split dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Train model
model = DentalDiseaseModel()
model.train(X_train, y_train)

# Evaluate model
y_pred = model.model.predict(model.scaler.transform(X_test))
print(f"Model Accuracy: {accuracy_score(y_test, y_pred):.2f}")
print("Classification Report:\n", classification_report(y_test, y_pred))