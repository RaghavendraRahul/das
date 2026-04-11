import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { port } from '../../App';

const Loader = () => (
    <div className="d-flex justify-content-center align-items-center" style={{ height: '150px' }}>
        <div className="spinner-border" role="status"><span className="visually-hidden">Loading...</span></div>
    </div>
);

const MetricLinkCard = ({ label, count, onClick }) => (
    <div className="col-md-4 col-lg-3 mb-4 hover:scale-105 transition-transform duration-300">
        <div
            className="card shadow-sm border-0 h-100 card-hover"
            onClick={onClick}
            style={{ cursor: count > 0 ? 'pointer' : 'default' }}
        >
            <div className="card-body text-center">
                <h3 className="fw-bold text-primary">{count}</h3>
                <p className="text-muted mb-0">{label}</p>
            </div>
        </div>
    </div>
);

const InterviewActivityDashboard = ({ empid, month, year }) => {
    const navigate = useNavigate();
    const [dashboardCounts, setDashboardCounts] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    const metrics = [
        { label: "Interview Schedules", type: "interview_schedule" },
        { label: "Interview Attended", type: "interview_attended" },
        { label: "Screening", type: "screening" },
        { label: "Internal Hiring", type: "Internal_Hiring" },
        { label: "On Hold", type: "On_Hold" },
        { label: "Reject", type: "Reject" },
        { label: "Rejected by Candidates", type: "Rejected_by_Candidate" },
        { label: "Consider to Client", type: "consider_to_client" },
        { label: "Offers", type: "Offers" },
        { label: "Offer Rejected", type: "Offer_did_not_accept" },
        { label: "Walkout", type: "walkout" },
    ];

    useEffect(() => {
        if (!empid || month === undefined || !year) return;
        setIsLoading(true);
        axios.get(`${port}/root/employee-interview-dashboard/${empid}?month=${month + 1}&year=${year}`)
            .then(response => setDashboardCounts(response.data))
            .catch(error => console.error("Error fetching interview dashboard counts:", error))
            .finally(() => setIsLoading(false));
    }, [empid, month, year]);

    const handleCardClick = (type) => {
        const url = `/activity/particularActivity/${empid}/?aid=1&activity_name=interview_calls&type=${type}&month=${month + 1}&year=${year}`;
        navigate(url);
    };

    return (
        <div className="mt-4">
            <h5 className='my-4'>Interview Activity Dashboard</h5>
            {isLoading ? <Loader /> : (
                <div className="row">
                    {dashboardCounts ? (
                        metrics.map(metric => {
                            const count = dashboardCounts[metric.type] || 0;
                            return (
                                <MetricLinkCard
                                    key={metric.type}
                                    label={metric.label}
                                    count={count}
                                    onClick={() => count > 0 && handleCardClick(metric.type)}
                                />
                            );
                        })
                    ) : (
                        <p className="text-center">Could not load interview data.</p>
                    )}
                </div>
            )}
        </div>
    );
};

export default InterviewActivityDashboard;