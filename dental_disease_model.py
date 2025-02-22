import os
import cv2
import numpy as np
import joblib
from skimage.feature import hog
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

class DentalDiseaseModel:
    def __init__(self, dataset_paths, img_size=(128, 128), model_path='dental_disease.model'):
        self.dataset_paths = dataset_paths
        self.img_size = img_size
        self.model_path = model_path
        self.scaler = StandardScaler()
        self.model = SVC(kernel='rbf', C=10, gamma='scale', probability=True)

    def extract_features(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray = cv2.GaussianBlur(gray, (5, 5), 0)
        gray = cv2.equalizeHist(gray)
        gray = gray / 255.0  # Normalize pixel values
        features, _ = hog(gray, orientations=9, pixels_per_cell=(8, 8), cells_per_block=(2, 2), visualize=True)
        return features

    def load_dataset(self):
        X, y = [], []
        for label, (class_name, dir_path) in enumerate(self.dataset_paths.items()):
            if not os.path.exists(dir_path):
                print(f"Warning: Directory not found - {dir_path}")
                continue
            for img_name in os.listdir(dir_path):
                img_path = os.path.join(dir_path, img_name)
                if os.path.isfile(img_path):
                    img = cv2.imread(img_path)
                    img = cv2.resize(img, self.img_size)
                    features = self.extract_features(img)
                    X.append(features)
                    y.append(label)
        return np.array(X), np.array(y)

    def train(self):
        X, y = self.load_dataset()
        X = self.scaler.fit_transform(X)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

        self.model.fit(X_train, y_train)

        y_pred = self.model.predict(X_test)
        print(f"Model Accuracy: {accuracy_score(y_test, y_pred):.2f}")
        print("Classification Report:\n", classification_report(y_test, y_pred))

        # Save model
        self.save_model()

    def save_model(self):
        joblib.dump((self.model, self.scaler), self.model_path)
        print(f"Model saved as {self.model_path}")

    def load_model(self):
        self.model, self.scaler = joblib.load(self.model_path)
        print(f"Model loaded from {self.model_path}")

    def predict(self, img):
        img = cv2.resize(img, self.img_size)
        features = self.extract_features(img)
        features = self.scaler.transform([features])
        return self.model.predict(features)[0]