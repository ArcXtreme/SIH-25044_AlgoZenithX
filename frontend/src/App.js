import React from 'react';
import { BrowserRouter as Router, Routes, Route, NavLink } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

import Dashboard from './pages/Dashboard';
import DataManagement from './pages/DataManagement';
import Prediction from './pages/Prediction';
import ModelManagement from './pages/ModelManagement';

import './App.css';

function App() {
  return (
    <Router>
      <div className="app">
        <nav className="nav">
          <div className="nav-content">
            <div className="nav-brand">🌾 Crop Yield Predictor</div>
            <div className="nav-links">
              <NavLink to="/" className={({ isActive }) => isActive ? 'active' : ''}>
                Dashboard
              </NavLink>
              <NavLink to="/data" className={({ isActive }) => isActive ? 'active' : ''}>
                Data Management
              </NavLink>
              <NavLink to="/predict" className={({ isActive }) => isActive ? 'active' : ''}>
                Prediction
              </NavLink>
              <NavLink to="/model" className={({ isActive }) => isActive ? 'active' : ''}>
                Model
              </NavLink>
            </div>
          </div>
        </nav>

        <div className="container">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/data" element={<DataManagement />} />
            <Route path="/predict" element={<Prediction />} />
            <Route path="/model" element={<ModelManagement />} />
          </Routes>
        </div>

        <ToastContainer position="top-right" autoClose={3000} />
      </div>
    </Router>
  );
}

export default App;