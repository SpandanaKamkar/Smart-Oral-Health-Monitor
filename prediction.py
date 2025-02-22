import cv2
from dental_disease_model import DentalDiseaseModel

# Initialize model and load the trained file
model = DentalDiseaseModel({}, model_path="dental_disease.model")
model.load_model()

# Load an image for prediction
img_path = "D:/test_image.jpg"  # Change to your test image path
img = cv2.imread(img_path)

# Make prediction
prediction = model.predict(img)
print(f"Predicted Class: {prediction}")
