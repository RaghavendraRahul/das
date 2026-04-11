import React from 'react';

const MetricCard = ({ title, value, icon, metricType, onClick }) => (
    <div className="col-md-4 col-lg-3 mb-4 shadow-sm">
        <div
            className="h-100 card shadow-sm border-0 card-hover 
        hover:scale-105 transition-transform duration-300
        bg-white/10 backdrop-blur-lg border border-white/20
        rounded-2xl"
            onClick={() => value > 0 && onClick(metricType, title)}
            style={{ cursor: value > 0 ? 'pointer' : 'default' }}
        >
            <div className="card-body d-flex align-items-center">
                <div className="p-3 bg-light rounded-circle me-3">
                    <i className={`fa ${icon} fa-2x text-primary`}></i>
                </div>
                <div>
                    <h6 className="card-title text-muted mb-1">{title}</h6>
                    <h3 className="card-text fw-bold">{value}</h3>
                </div>
            </div>
        </div>
    </div>
);

export default MetricCard;