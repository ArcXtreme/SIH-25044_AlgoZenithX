import React, { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import { cropAPI, predictionAPI } from '../services/api';

function Prediction() {
  const [options, setOptions] = useState({ districts: [], crops: [], seasons: [] });
  const [formData, setFormData] = useState({
    year: new Date().getFullYear(),
    district: '',
    crop: '',
    season: '',
    rainfall_mm: '',
    avg_temp_c: '',
    area_ha: ''
  });
  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    fetchOptions();
    fetchHistory();
  }, []);

  const fetchOptions = async () => {
    try {
      const response = await cropAPI.getOptions();
      setOptions(response.data);
    } catch (error) {
      console.error('Error fetching options:', error);
    }
  };

  const fetchHistory = async () => {
    try {
      const response = await predictionAPI.getHistory();
      setHistory(response.data.slice(0, 10));
    } catch (error) {
      console.error('Error fetching history:', error);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setPrediction(null);

    try {
      const response = await predictionAPI.predict(formData);
      setPrediction(response.data);
      fetchHistory();
      toast.success('Prediction successful!');
    } catch (error) {
      toast.error(error.response?.data?.error || 'Prediction failed');
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  return (
    <div>
      <h1 style={{ marginBottom: '24px' }}>Yield Prediction</h1>

      <div className="grid grid-2">
        {/* Prediction Form */}
        <div className="card">
          <h3 style={{ marginBottom: '20px' }}>Enter Parameters</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Year</label>
              <input
                type="number"
                name="year"
                className="form-control"
                value={formData.year}
                onChange={handleInputChange}
                required
              />
            </div>

            <div className="form-group">
              <label>District</label>
              <select
                name="district"
                className="form-control"
                value={formData.district}
                onChange={handleInputChange}
                required
              >
                <option value="">Select District</option>
                {options.districts.map((d) => (
                  <option key={d} value={d}>{d}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label>Crop</label>
              <select
                name="crop"
                className="form-control"
                value={formData.crop}
                onChange={handleInputChange}
                required
              >
                <option value="">Select Crop</option>
                {options.crops.map((c) => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label>Season</label>
              <select
                name="season"
                className="form-control"
                value={formData.season}
                onChange={handleInputChange}
                required
              >
                <option value="">Select Season</option>
                {options.seasons.map((s) => (
                  <option key={s} value={s}>{s}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label>Rainfall (mm)</label>
              <input
                type="number"
                name="rainfall_mm"
                step="0.01"
                className="form-control"
                value={formData.rainfall_mm}
                onChange={handleInputChange}
                placeholder="e.g., 150.5"
                required
              />
            </div>

            <div className="form-group">
              <label>Average Temperature (°C)</label>
              <input
                type="number"
                name="avg_temp_c"
                step="0.01"
                className="form-control"
                value={formData.avg_temp_c}
                onChange={handleInputChange}
                placeholder="e.g., 28.5"
                required
              />
            </div>

            <div className="form-group">
              <label>Area (Hectares)</label>
              <input
                type="number"
                name="area_ha"
                step="0.01"
                className="form-control"
                value={formData.area_ha}
                onChange={handleInputChange}
                placeholder="e.g., 1000"
                required
              />
            </div>

            <button 
              type="submit" 
              className="btn btn-primary" 
              style={{ width: '100%' }}
              disabled={loading}
            >
              {loading ? 'Predicting...' : 'Predict Yield'}
            </button>
          </form>
        </div>

        {/* Prediction Result */}
        <div>
          {prediction && (
            <div className="prediction-result" style={{ marginBottom: '20px' }}>
              <h3 style={{ marginBottom: '16px' }}>Predicted Yield</h3>
              <div className="prediction-value">
                {prediction.predicted_yield.toFixed(4)}
              </div>
              <div className="prediction-unit">tonnes per hectare</div>
              
              {prediction.lower_bound && prediction.upper_bound && (
                <div style={{ marginTop: '16px', fontSize: '14px', opacity: '0.9' }}>
                  <p>95% Confidence Interval:</p>
                  <p>{prediction.lower_bound.toFixed(4)} - {prediction.upper_bound.toFixed(4)} t/ha</p>
                </div>
              )}
            </div>
          )}

          {/* Prediction History */}
          <div className="card">
            <h3 style={{ marginBottom: '16px' }}>Recent Predictions</h3>
            {history.length > 0 ? (
              <table>
                <thead>
                  <tr>
                    <th>District</th>
                    <th>Crop</th>
                    <th>Predicted Yield</th>
                    <th>Date</th>
                  </tr>
                </thead>
                <tbody>
                  {history.map((item) => (
                    <tr key={item.id}>
                      <td>{item.district}</td>
                      <td>{item.crop}</td>
                      <td>{parseFloat(item.predicted_yield).toFixed(4)}</td>
                      <td>{new Date(item.created_at).toLocaleDateString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <p style={{ color: '#6b7280' }}>No predictions yet</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default Prediction;