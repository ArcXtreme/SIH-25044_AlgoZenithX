import sys
import json
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import xgboost as xgb
import joblib
import os
import warnings
warnings.filterwarnings('ignore')

class CropYieldTrainer:
    def __init__(self):
        self.model = None
        self.label_encoders = {}
        self.feature_columns = ['Year', 'District', 'Crop', 'Season', 'Rainfall_mm', 'Avg_Temp_C', 'Area_Ha']
        self.categorical_columns = ['District', 'Crop', 'Season']
        self.model_dir = os.path.join(os.path.dirname(__file__), 'model')
        
        if not os.path.exists(self.model_dir):
            os.makedirs(self.model_dir)
    
    def load_data(self, filepath):
        df = pd.read_csv(filepath)
        return df
    
    def preprocess_data(self, df):
        df_processed = df.copy()
        
        for col in df_processed.columns:
            if df_processed[col].dtype in ['float64', 'int64']:
                df_processed[col].fillna(df_processed[col].median(), inplace=True)
            else:
                df_processed[col].fillna(df_processed[col].mode()[0], inplace=True)
        
        for col in self.categorical_columns:
            le = LabelEncoder()
            df_processed[col] = le.fit_transform(df_processed[col].astype(str))
            self.label_encoders[col] = le
        
        return df_processed
    
    def create_features(self, df):
        df_featured = df.copy()
        df_featured['Rainfall_Temp_Ratio'] = df['Rainfall_mm'] / (df['Avg_Temp_C'] + 1)
        df_featured['Area_Rainfall'] = df['Area_Ha'] * df['Rainfall_mm'] / 1000
        df_featured['Temp_Squared'] = df['Avg_Temp_C'] ** 2
        return df_featured
    
    def train(self, filepath):
        df = self.load_data(filepath)
        df_processed = self.preprocess_data(df)
        df_featured = self.create_features(df_processed)
        
        feature_cols = [col for col in df_featured.columns if col != 'Yield_t_ha']
        X = df_featured[feature_cols]
        y = df_featured['Yield_t_ha']
        
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        
        self.model = xgb.XGBRegressor(
            n_estimators=200, max_depth=6, learning_rate=0.1,
            subsample=0.8, colsample_bytree=0.8, random_state=42, n_jobs=-1
        )
        
        self.model.fit(X_train, y_train, eval_set=[(X_test, y_test)], verbose=False)
        
        y_pred = self.model.predict(X_test)
        
        metrics = {
            'mse': float(mean_squared_error(y_test, y_pred)),
            'rmse': float(np.sqrt(mean_squared_error(y_test, y_pred))),
            'mae': float(mean_absolute_error(y_test, y_pred)),
            'r2_score': float(r2_score(y_test, y_pred))
        }
        
        self.save_model(feature_cols)
        return metrics
    
    def save_model(self, feature_columns):
        joblib.dump(self.model, os.path.join(self.model_dir, 'xgboost_model.joblib'))
        joblib.dump(self.label_encoders, os.path.join(self.model_dir, 'label_encoders.joblib'))
        joblib.dump(feature_columns, os.path.join(self.model_dir, 'feature_columns.joblib'))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No data file provided"}))
        sys.exit(1)
    
    filepath = sys.argv[1]
    
    try:
        trainer = CropYieldTrainer()
        metrics = trainer.train(filepath)
        print(json.dumps(metrics))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)