import os
import cv2
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

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
labels_dict = {
    0: "Healthy Teeth",
    1: "Dental Cavities",
    2: "Teeth Discoloration",
    3: "Plaque Buildup",
    4: "Mouth Ulcer",
    5: "Gum Disease"
}

# Function to load and preprocess images
def load_dataset(dataset_paths, img_size=(128, 128)):
    X, y = [], []

    for label, (class_name, dir_path) in enumerate(dataset_paths.items()):
        if not os.path.exists(dir_path):
            print(f"Warning: Directory not found - {dir_path}")
            continue

        for img_name in os.listdir(dir_path):
            img_path = os.path.join(dir_path, img_name)
            if os.path.isfile(img_path):
                img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
                img = cv2.resize(img, img_size)
                X.append(img.flatten())
                y.append(label)

    return np.array(X), np.array(y)

# Load data
X, y = load_dataset(dataset_paths)

# Split dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train an SVM classifier
svm_model = SVC(kernel='linear', probability=True)
svm_model.fit(X_train, y_train)

# Evaluate model performance
y_pred = svm_model.predict(X_test)
print(f"Model Accuracy: {accuracy_score(y_test, y_pred):.2f}")
print("Classification Report:\n", classification_report(y_test, y_pred))

# Function to test shuffled images from a directory
def test_random_images(model, img_dir, img_size=(128, 128)):
    if not os.path.exists(img_dir):
        print(f"Error: Test directory '{img_dir}' not found.")
        return

    img_names = os.listdir(img_dir)
    np.random.shuffle(img_names)  # Shuffle image order

    for img_name in img_names:
        img_path = os.path.join(img_dir, img_name)
        if os.path.isfile(img_path):
            img = cv2.imread(img_path)
            gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            resized_img = cv2.resize(gray_img, img_size)
            flat_img = resized_img.flatten().reshape(1, -1)

            # Predict the class label
            prediction = model.predict(flat_img)[0]
            label = labels_dict.get(prediction, "Unknown")
            color = (0, 255, 0) if prediction == 0 else (0, 0, 255)

            # Draw bounding box & label on image
            h, w, _ = img.shape
            start_point = (int(w * 0.25), int(h * 0.25))
            end_point = (int(w * 0.75), int(h * 0.75))
            cv2.rectangle(img, start_point, end_point, color, 2)
            cv2.putText(img, label, (start_point[0], start_point[1] - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 2)

            # Display result
            cv2.imshow('Dental Disease Detection', img)
            print(f"Processing {img_name}: {label}")
            cv2.waitKey(1000)  # Show for 1 second
            cv2.destroyAllWindows()

# Test directory path
test_dir = r"D:\Dental diseases\Combined dataset"

# Run test on shuffled images
test_random_images(svm_model, test_dir)