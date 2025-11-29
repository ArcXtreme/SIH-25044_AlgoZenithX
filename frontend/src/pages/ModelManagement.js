import React, { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import { modelAPI } from '../services/api';

function ModelManagement() {
  const [modelStatus, setModelStatus] = useState(null);
  const [loading, setLoading] = useState(true);
  const [training, setTraining] = useState(false);

  useEffect(() => {
    fetchModelStatus();
  }, []);

  const fetchModelStatus = async () => {
    try {
      const response = await modelAPI.getStatus();
      setModelStatus(response.data);
    } catch (error) {
      console.error('Error fetching model status:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleTrainModel = async () => {
    if (!window.confirm('This will retrain the model with current data. Continue?')) {
      return;
    }

    setTraining(true);
    try {
      const response = await modelAPI.train();
      toast.success('Model trained successfully!');
      setModelStatus({
        ...modelStatus,
        modelExists: true,
        lastTraining: {
          records_used: response.data.records_used,
          ...response.data.metrics,
          training_date: new Date().toISOString()
        }
      });
    } catch (error) {
      toast.error(error.response?.data?.error || 'Training failed');
    } finally {
      setTraining(false);
      fetchModelStatus();
    }
  };

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
      </div>
    );
  }

  return (
    <div>
      <h1 style={{ marginBottom: '24px' }}>Model Management</h1>

      <div className="grid grid-2">
        {/* Model Status */}
        <div className="card">
          <h3 style={{ marginBottom: '20px' }}>Model Status</h3>
          
          <div style={{ marginBottom: '20px' }}>
            <div style={{ 
              display: 'inline-flex', 
              alignItems: 'center', 
              padding: '8px 16px', 
              borderRadius: '20px',
              background: modelStatus?.modelExists ? '#d1fae5' : '#fee2e2',
              color: modelStatus?.modelExists ? '#065f46' : '#991b1b'
            }}>
              <span style={{ 
                width: '10px', 
                height: '10px', 
                borderRadius: '50%', 
                background: modelStatus?.modelExists ? '#10b981' : '#ef4444',
                marginRight: '8px'
              }}></span>
              {modelStatus?.modelExists ? 'Model Ready' : 'No Model Trained'}
            </div>
          </div>

          {modelStatus?.lastTraining && (
            <div>
              <h4 style={{ marginBottom: '12px', color: '#374151' }}>Last Training</h4>
              <table>
                <tbody>
                  <tr>
                    <td><strong>Date:</strong></td>
                    <td>{new Date(modelStatus.lastTraining.training_date).toLocaleString()}</td>
                  </tr>
                  <tr>
                    <td><strong>Records Used:</strong></td>
                    <td>{modelStatus.lastTraining.records_used}</td>
                  </tr>
                  <tr>
                    <td><strong>Status:</strong></td>
                    <td>
                      <span style={{ 
                        color: modelStatus.lastTraining.status === 'success' ? '#10b981' : '#ef4444' 
                      }}>
                        {modelStatus.lastTraining.status}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          )}

          <button
            className="btn btn-success"
            style={{ width: '100%', marginTop: '20px' }}
            onClick={handleTrainModel}
            disabled={training}
          >
            {training ? (
              <>
                <span className="spinner" style={{ 
                  width: '16px', 
                  height: '16px', 
                  marginRight: '8px',
                  display: 'inline-block'
                }}></span>
                Training...
              </>
            ) : (
              'Train / Retrain Model'
            )}
          </button>
        </div>

        {/* Model Metrics */}
        <div className="card">
          <h3 style={{ marginBottom: '20px' }}>Model Metrics</h3>
          
          {modelStatus?.lastTraining && modelStatus.lastTraining.status === 'success' ? (
            <div className="grid grid-2" style={{ gap: '16px' }}>
              <div className="stat-card">
                <div className="stat-value" style={{ fontSize: '24px' }}>
                  {parseFloat(modelStatus.lastTraining.r2_score).toFixed(4)}
                </div>
                <div className="stat-label">R² Score</div>
              </div>
              <div className="stat-card">
                <div className="stat-value" style={{ fontSize: '24px' }}>
                  {parseFloat(modelStatus.lastTraining.rmse).toFixed(4)}
                </div>
                <div className="stat-label">RMSE</div>
              </div>
              <div className="stat-card">
                <div className="stat-value" style={{ fontSize: '24px' }}>
                  {parseFloat(modelStatus.lastTraining.mae).toFixed(4)}
                </div>
                <div className="stat-label">MAE</div>
              </div>
              <div className="stat-card">
                <div className="stat-value" style={{ fontSize: '24px' }}>
                  {parseFloat(modelStatus.lastTraining.mse).toFixed(4)}
                </div>
                <div className="stat-label">MSE</div>
              </div>
            </div>
          ) : (
            <div className="alert alert-info">
              No metrics available. Train the model to see performance metrics.
            </div>
          )}

          <div style={{ marginTop: '20px' }}>
            <h4 style={{ marginBottom: '12px' }}>Metrics Explanation</h4>
            <ul style={{ paddingLeft: '20px', color: '#6b7280', lineHeight: '1.8' }}>
              <li><strong>R² Score:</strong> How well the model explains variance (closer to 1 is better)</li>
              <li><strong>RMSE:</strong> Root Mean Square Error (lower is better)</li>
              <li><strong>MAE:</strong> Mean Absolute Error (lower is better)</li>
              <li><strong>MSE:</strong> Mean Square Error (lower is better)</li>
            </ul>
          </div>
        </div>

        {/* Training History */}
        <div className="card" style={{ gridColumn: 'span 2' }}>
          <h3 style={{ marginBottom: '20px' }}>Training History</h3>
          
          {modelStatus?.trainingHistory && modelStatus.trainingHistory.length > 0 ? (
            <table>
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Records</th>
                  <th>R² Score</th>
                  <th>RMSE</th>
                  <th>MAE</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {modelStatus.trainingHistory.map((log) => (
                  <tr key={log.id}>
                    <td>{new Date(log.training_date).toLocaleString()}</td>
                    <td>{log.records_used}</td>
                    <td>{log.r2_score ? parseFloat(log.r2_score).toFixed(4) : '-'}</td>
                    <td>{log.rmse ? parseFloat(log.rmse).toFixed(4) : '-'}</td>
                    <td>{log.mae ? parseFloat(log.mae).toFixed(4) : '-'}</td>
                    <td>
                      <span style={{ 
                        padding: '4px 12px',
                        borderRadius: '12px',
                        fontSize: '12px',
                        background: log.status === 'success' ? '#d1fae5' : '#fee2e2',
                        color: log.status === 'success' ? '#065f46' : '#991b1b'
                      }}>
                        {log.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <p style={{ color: '#6b7280' }}>No training history available</p>
          )}
        </div>
      </div>
    </div>
  );
}

export default ModelManagement;