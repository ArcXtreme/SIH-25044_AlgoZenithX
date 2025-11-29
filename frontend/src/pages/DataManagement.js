import React, { useState, useEffect, useCallback } from 'react';
import { toast } from 'react-toastify';
import { FiEdit, FiTrash2, FiPlus, FiUpload, FiDownload } from 'react-icons/fi';
import { cropAPI } from '../services/api';

function DataManagement() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pagination, setPagination] = useState({ page: 1, totalPages: 1 });
  const [options, setOptions] = useState({ districts: [], crops: [], seasons: [] });
  const [showModal, setShowModal] = useState(false);
  const [editingRecord, setEditingRecord] = useState(null);
  const [selectedIds, setSelectedIds] = useState([]);
  const [formData, setFormData] = useState({
    year: new Date().getFullYear(),
    district: '',
    crop: '',
    season: '',
    rainfall_mm: '',
    avg_temp_c: '',
    area_ha: '',
    yield_t_ha: ''
  });

  const fetchData = useCallback(async (page = 1) => {
    setLoading(true);
    try {
      const response = await cropAPI.getAll(page, 20);
      setData(response.data.data);
      setPagination(response.data.pagination);
    } catch (error) {
      toast.error('Error fetching data');
    } finally {
      setLoading(false);
    }
  }, []);

  const fetchOptions = useCallback(async () => {
    try {
      const response = await cropAPI.getOptions();
      setOptions(response.data);
    } catch (error) {
      console.error('Error fetching options:', error);
    }
  }, []);

  useEffect(() => {
    fetchData();
    fetchOptions();
  }, [fetchData, fetchOptions]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingRecord) {
        await cropAPI.update(editingRecord.id, formData);
        toast.success('Record updated successfully');
      } else {
        await cropAPI.create(formData);
        toast.success('Record added successfully');
      }
      setShowModal(false);
      resetForm();
      fetchData(pagination.page);
    } catch (error) {
      toast.error(error.response?.data?.error || 'Operation failed');
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this record?')) {
      try {
        await cropAPI.delete(id);
        toast.success('Record deleted successfully');
        fetchData(pagination.page);
      } catch (error) {
        toast.error('Error deleting record');
      }
    }
  };

  const handleBulkDelete = async () => {
    if (selectedIds.length === 0) {
      toast.warning('No records selected');
      return;
    }
    if (window.confirm(`Delete ${selectedIds.length} records?`)) {
      try {
        await cropAPI.bulkDelete(selectedIds);
        toast.success('Records deleted successfully');
        setSelectedIds([]);
        fetchData(pagination.page);
      } catch (error) {
        toast.error('Error deleting records');
      }
    }
  };

  const handleEdit = (record) => {
    setEditingRecord(record);
    setFormData({
      year: record.year,
      district: record.district,
      crop: record.crop,
      season: record.season,
      rainfall_mm: record.rainfall_mm,
      avg_temp_c: record.avg_temp_c,
      area_ha: record.area_ha,
      yield_t_ha: record.yield_t_ha
    });
    setShowModal(true);
  };

  const handleFileUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await cropAPI.uploadCSV(formData);
      toast.success(`Processed: ${response.data.processed}, Errors: ${response.data.errors}`);
      fetchData();
    } catch (error) {
      toast.error('Error uploading file');
    }
  };

  const handleExport = async () => {
    try {
      const response = await cropAPI.exportCSV();
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', 'crop_data_export.csv');
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch (error) {
      toast.error('Error exporting data');
    }
  };

  const resetForm = () => {
    setFormData({
      year: new Date().getFullYear(),
      district: '',
      crop: '',
      season: '',
      rainfall_mm: '',
      avg_temp_c: '',
      area_ha: '',
      yield_t_ha: ''
    });
    setEditingRecord(null);
  };

  const toggleSelectAll = () => {
    if (selectedIds.length === data.length) {
      setSelectedIds([]);
    } else {
      setSelectedIds(data.map(item => item.id));
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
        <h1>Data Management</h1>
        <div style={{ display: 'flex', gap: '12px' }}>
          <label className="btn btn-secondary" style={{ cursor: 'pointer' }}>
            <FiUpload style={{ marginRight: '8px' }} />
            Upload CSV
            <input type="file" accept=".csv" onChange={handleFileUpload} style={{ display: 'none' }} />
          </label>
          <button className="btn btn-secondary" onClick={handleExport}>
            <FiDownload style={{ marginRight: '8px' }} />
            Export CSV
          </button>
          <button className="btn btn-primary" onClick={() => { resetForm(); setShowModal(true); }}>
            <FiPlus style={{ marginRight: '8px' }} />
            Add Record
          </button>
          {selectedIds.length > 0 && (
            <button className="btn btn-danger" onClick={handleBulkDelete}>
              Delete Selected ({selectedIds.length})
            </button>
          )}
        </div>
      </div>

      <div className="card">
        {loading ? (
          <div className="loading">
            <div className="spinner"></div>
          </div>
        ) : (
          <>
            <table>
              <thead>
                <tr>
                  <th>
                    <input
                      type="checkbox"
                      checked={selectedIds.length === data.length && data.length > 0}
                      onChange={toggleSelectAll}
                    />
                  </th>
                  <th>Year</th>
                  <th>District</th>
                  <th>Crop</th>
                  <th>Season</th>
                  <th>Rainfall (mm)</th>
                  <th>Avg Temp (°C)</th>
                  <th>Area (Ha)</th>
                  <th>Yield (t/ha)</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {data.map((record) => (
                  <tr key={record.id}>
                    <td>
                      <input
                        type="checkbox"
                        checked={selectedIds.includes(record.id)}
                        onChange={() => {
                          setSelectedIds(prev =>
                            prev.includes(record.id)
                              ? prev.filter(id => id !== record.id)
                              : [...prev, record.id]
                          );
                        }}
                      />
                    </td>
                    <td>{record.year}</td>
                    <td>{record.district}</td>
                    <td>{record.crop}</td>
                    <td>{record.season}</td>
                    <td>{record.rainfall_mm}</td>
                    <td>{record.avg_temp_c}</td>
                    <td>{record.area_ha}</td>
                    <td>{record.yield_t_ha}</td>
                    <td>
                      <button
                        className="btn btn-secondary"
                        style={{ padding: '6px 10px', marginRight: '8px' }}
                        onClick={() => handleEdit(record)}
                      >
                        <FiEdit />
                      </button>
                      <button
                        className="btn btn-danger"
                        style={{ padding: '6px 10px' }}
                        onClick={() => handleDelete(record.id)}
                      >
                        <FiTrash2 />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="pagination">
              <button
                disabled={pagination.page === 1}
                onClick={() => fetchData(pagination.page - 1)}
              >
                Previous
              </button>
              <span style={{ padding: '8px 16px' }}>
                Page {pagination.page} of {pagination.totalPages}
              </span>
              <button
                disabled={pagination.page === pagination.totalPages}
                onClick={() => fetchData(pagination.page + 1)}
              >
                Next
              </button>
            </div>
          </>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="modal-overlay" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">
                {editingRecord ? 'Edit Record' : 'Add New Record'}
              </h2>
              <button
                onClick={() => setShowModal(false)}
                style={{ background: 'none', border: 'none', fontSize: '24px', cursor: 'pointer' }}
              >
                ×
              </button>
            </div>

            <form onSubmit={handleSubmit}>
              <div className="grid grid-2">
                <div className="form-group">
                  <label>Year</label>
                  <input
                    type="number"
                    className="form-control"
                    value={formData.year}
                    onChange={(e) => setFormData({ ...formData, year: e.target.value })}
                    required
                  />
                </div>
                <div className="form-group">
                  <label>District</label>
                  <select
                    className="form-control"
                    value={formData.district}
                    onChange={(e) => setFormData({ ...formData, district: e.target.value })}
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
                    className="form-control"
                    value={formData.crop}
                    onChange={(e) => setFormData({ ...formData, crop: e.target.value })}
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
                    className="form-control"
                    value={formData.season}
                    onChange={(e) => setFormData({ ...formData, season: e.target.value })}
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
                    step="0.01"
                    className="form-control"
                    value={formData.rainfall_mm}
                    onChange={(e) => setFormData({ ...formData, rainfall_mm: e.target.value })}
                    required
                  />
                </div>
                <div className="form-group">
                  <label>Average Temperature (°C)</label>
                  <input
                    type="number"
                    step="0.01"
                    className="form-control"
                    value={formData.avg_temp_c}
                    onChange={(e) => setFormData({ ...formData, avg_temp_c: e.target.value })}
                    required
                  />
                </div>
                <div className="form-group">
                  <label>Area (Hectares)</label>
                  <input
                    type="number"
                    step="0.01"
                    className="form-control"
                    value={formData.area_ha}
                    onChange={(e) => setFormData({ ...formData, area_ha: e.target.value })}
                    required
                  />
                </div>
                <div className="form-group">
                  <label>Yield (t/ha)</label>
                  <input
                    type="number"
                    step="0.0001"
                    className="form-control"
                    value={formData.yield_t_ha}
                    onChange={(e) => setFormData({ ...formData, yield_t_ha: e.target.value })}
                    required
                  />
                </div>
              </div>

              <div style={{ display: 'flex', gap: '12px', marginTop: '20px' }}>
                <button type="submit" className="btn btn-primary">
                  {editingRecord ? 'Update' : 'Add'} Record
                </button>
                <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default DataManagement;