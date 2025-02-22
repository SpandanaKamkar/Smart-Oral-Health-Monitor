from dental_disease_model import DentalDiseaseModel  # Import the model class

# Define dataset paths
dataset_paths = {
    "Dental Cavities": r"D:\Dental diseases\Dental caries",
    "Teeth Discoloration": r"D:\Dental diseases\Tooth Discoloration",
    "Plaque Buildup": r"D:\Dental diseases\Plaque Buildup DataSet",
    "Mouth Ulcer": r"D:\Dental diseases\Mouth Ulcer",
    "Gum Disease": r"D:\Dental diseases\Gum Diseases DataSet",
    "Healthy Teeth": r"D:\Dental diseases\Healthy Teeth and Gums Images"
}

# Initialize and train the model
model = DentalDiseaseModel(dataset_paths)
model.train()