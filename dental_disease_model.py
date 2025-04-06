import pickle
import os
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler

class DentalDiseaseModel:
    def __init__(self):
        self.model = SVC(kernel='linear', probability=True)
        self.scaler = StandardScaler()

    def train(self, X_train, y_train):
        """Trains the model and scales features."""
        self.scaler.fit(X_train)
        X_train_scaled = self.scaler.transform(X_train)
        self.model.fit(X_train_scaled, y_train)
        print("✅ Model training completed!")

    def predict(self, img):
        """Predicts dental disease from an image."""
        img = img.flatten().reshape(1, -1)
        img_scaled = self.scaler.transform(img)
        return self.model.predict(img_scaled)[0]

    def load_model(self):
        """Loads the trained model and scaler from files."""
        if not os.path.exists("dental_disease_model.pkl") or not os.path.exists("scaler.pkl"):
            raise FileNotFoundError("❌ Model or scaler file not found! Train the model first.")

        with open("dental_disease_model.pkl", "rb") as model_file:
            self.model = pickle.load(model_file)

        with open("scaler.pkl", "rb") as scaler_file:
            self.scaler = pickle.load(scaler_file)

        print("✅ Model and scaler loaded successfully!")
