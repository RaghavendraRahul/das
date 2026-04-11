import React from 'react';

const DashboardFilter = ({ filterType, setFilterType, customStartDate, setCustomStartDate, customEndDate, setCustomEndDate }) => {
    return (
        <div className="card shadow-sm mb-4">
            <div className="card-body d-flex flex-wrap align-items-center justify-content-between">
                <h4 className="fw-bold mb-0">Activity Dashboard</h4>
                <div className="d-flex align-items-center gap-3">
                    <select className="form-select" value={filterType} onChange={(e) => setFilterType(e.target.value)}>
                        <option value="today">Today</option>
                        <option value="this_month">This Month</option>
                        <option value="prev_month">Previous Month</option>
                        <option value="custom">Custom Date Range</option>
                    </select>
                    {filterType === 'custom' && (
                        <>
                            <input type="date" className="form-control" value={customStartDate} onChange={(e) => setCustomStartDate(e.target.value)} />
                            <input type="date" className="form-control" value={customEndDate} onChange={(e) => setCustomEndDate(e.target.value)} />
                        </>
                    )}
                </div>
            </div>
        </div>
    );
};

export default DashboardFilter;