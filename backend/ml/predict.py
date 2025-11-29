import sys
import json
import pandas as pd
import numpy as np
import joblib
import os
import warnings
warnings.filterwarnings('ignore')

class CropYieldPredictor:
    def __init__(self):
        self.model_dir = os.path.join(os.path.dirname(__file__), 'model')
        self.model = None
        self.label_encoders = None
        self.feature_columns = None
        self.load_model()
    
    def load_model(self):
        model_path = os.path.join(self.model_dir, 'xgboost_model.joblib')
        
        if not os.path.exists(model_path):
            raise FileNotFoundError("Model not found. Please train the model first.")
        
        self.model = joblib.load(model_path)
        self.label_encoders = joblib.load(os.path.join(self.model_dir, 'label_encoders.joblib'))
        self.feature_columns = joblib.load(os.path.join(self.model_dir, 'feature_columns.joblib'))
    
    def preprocess_input(self, data):
        if isinstance(data, dict):
            df = pd.DataFrame([data])
        else:
            df = pd.DataFrame(data)
        
        column_mapping = {
            'year': 'Year', 'district': 'District', 'crop': 'Crop', 'season': 'Season',
            'rainfall_mm': 'Rainfall_mm', 'avg_temp_c': 'Avg_Temp_C', 'area_ha': 'Area_Ha'
        }
        df.rename(columns=column_mapping, inplace=True)
        
        for col, le in self.label_encoders.items():
            if col in df.columns:
                df[col] = df[col].apply(lambda x: le.transform([x])[0] if x in le.classes_ else -1)
        
        df['Rainfall_Temp_Ratio'] = df['Rainfall_mm'] / (df['Avg_Temp_C'] + 1)
        df['Area_Rainfall'] = df['Area_Ha'] * df['Rainfall_mm'] / 1000
        df['Temp_Squared'] = df['Avg_Temp_C'] ** 2
        
        for col in self.feature_columns:
            if col not in df.columns:
                df[col] = 0
        
        return df[self.feature_columns]
    
    def predict(self, data):
        X = self.preprocess_input(data)
        prediction = self.model.predict(X)
        return prediction
    
    def predict_with_confidence(self, data):
        X = self.preprocess_input(data)
        prediction = self.model.predict(X)
        std_estimate = prediction * 0.1
        
        return {
            'predicted_yield': float(prediction[0]),
            'lower_bound': float(prediction[0] - 1.96 * std_estimate[0]),
            'upper_bound': float(prediction[0] + 1.96 * std_estimate[0])
        }


def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No input data provided"}))
        sys.exit(1)
    
    input_data = json.loads(sys.argv[1])
    
    try:
        predictor = CropYieldPredictor()
        result = predictor.predict_with_confidence(input_data)
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


if __name__ == "__main__":
    main()