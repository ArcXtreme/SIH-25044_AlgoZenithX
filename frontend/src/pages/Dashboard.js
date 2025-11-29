import React, { useState, useEffect } from 'react';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, 
  LineChart, Line, PieChart, Pie, Cell, ResponsiveContainer 
} from 'recharts';
import { cropAPI } from '../services/api';

const COLORS = ['#4f46e5', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6'];

function Dashboard() {
  const [statistics, setStatistics] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStatistics();
  }, []);

  const fetchStatistics = async () => {
    try {
      const response = await cropAPI.getStatistics();
      setStatistics(response.data);
    } catch (error) {
      console.error('Error fetching statistics:', error);
    } finally {
      setLoading(false);
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
      <h1 style={{ marginBottom: '24px' }}>Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-4" style={{ marginBottom: '24px' }}>
        <div className="stat-card">
          <div className="stat-value">{statistics?.totalRecords || 0}</div>
          <div className="stat-label">Total Records</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{statistics?.avgYield || 0}</div>
          <div className="stat-label">Avg Yield (t/ha)</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{statistics?.yieldByCrop?.length || 0}</div>
          <div className="stat-label">Crop Types</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{statistics?.yieldByDistrict?.length || 0}</div>
          <div className="stat-label">Districts</div>
        </div>
      </div>

      {/* Charts */}
      <div className="grid grid-2">
        {/* Yield by Crop */}
        <div className="card">
          <h3 style={{ marginBottom: '16px' }}>Average Yield by Crop</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={statistics?.yieldByCrop || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="crop" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="avg_yield" fill="#4f46e5" name="Avg Yield (t/ha)" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Yield by District */}
        <div className="card">
          <h3 style={{ marginBottom: '16px' }}>Average Yield by District</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={statistics?.yieldByDistrict || []}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ district, avg_yield }) => `${district}: ${parseFloat(avg_yield).toFixed(2)}`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="avg_yield"
              >
                {(statistics?.yieldByDistrict || []).map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Yearly Trend */}
        <div className="card" style={{ gridColumn: 'span 2' }}>
          <h3 style={{ marginBottom: '16px' }}>Yearly Yield Trend</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={statistics?.yearlyTrend || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="year" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line 
                type="monotone" 
                dataKey="avg_yield" 
                stroke="#10b981" 
                strokeWidth={2}
                name="Avg Yield (t/ha)"
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;