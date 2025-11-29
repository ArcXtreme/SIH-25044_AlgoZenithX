import axios from 'axios';

const API_BASE_URL = 'http://localhost:5000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Crop Data APIs
export const cropAPI = {
  getAll: (page = 1, limit = 50) => 
    api.get(`/crops?page=${page}&limit=${limit}`),
  
  getById: (id) => 
    api.get(`/crops/${id}`),
  
  create: (data) => 
    api.post('/crops', data),
  
  update: (id, data) => 
    api.put(`/crops/${id}`, data),
  
  delete: (id) => 
    api.delete(`/crops/${id}`),
  
  bulkDelete: (ids) => 
    api.post('/crops/bulk-delete', { ids }),
  
  getOptions: () => 
    api.get('/crops/options'),
  
  getStatistics: () => 
    api.get('/crops/statistics'),
  
  uploadCSV: (formData) => 
    api.post('/crops/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    }),
  
  exportCSV: () => 
    api.get('/crops/export', { responseType: 'blob' })
};

// Prediction APIs
export const predictionAPI = {
  predict: (data) => 
    api.post('/predictions', data),
  
  batchPredict: (predictions) => 
    api.post('/predictions/batch', { predictions }),
  
  getHistory: () => 
    api.get('/predictions/history')
};

// Model APIs
export const modelAPI = {
  train: () => 
    api.post('/model/train'),
  
  getStatus: () => 
    api.get('/model/status'),
  
  getMetrics: () => 
    api.get('/model/metrics')
};

export default api;