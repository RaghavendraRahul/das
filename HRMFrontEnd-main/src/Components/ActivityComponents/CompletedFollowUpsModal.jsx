// 28-01-2026: New Follow-Up Enhancement Modal
import React from 'react';

const Loader = ({ height = '200px' }) => (
    <div className="flex justify-center items-center" style={{ height }}>
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-blue-500"></div>
    </div>
);

const CompletedFollowUpsModal = ({ show, onHide, data, isLoading }) => {
    if (!show) return null;

    const closeOnOutsideClick = (e) => {
        if (e.target.id === 'modalBackdrop') {
            onHide();
        }
    };

    return (
        <div
            id="modalBackdrop"
            onClick={closeOnOutsideClick}
            className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-md p-4"
        >
            <div
                className="bg-white w-full max-w-6xl rounded-lg shadow-xl max-h-[80vh] overflow-hidden"
                onClick={(e) => e.stopPropagation()}
            >
                <div className="flex justify-between items-center p-4 border-b">
                    <h2 className="text-xl font-semibold">Completed Follow Ups</h2>
                    <button
                        onClick={onHide}
                        className="text-gray-600 hover:text-black text-2xl"
                    >
                        &times;
                    </button>
                </div>

                <div className="p-4 overflow-y-auto max-h-[60vh]">
                    {isLoading ? (
                        <Loader height="300px" />
                    ) : !data || data.length === 0 ? (
                        <p className="text-center text-gray-500">No completed follow-ups found.</p>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="min-w-full border border-gray-300 rounded-md text-sm">
                                <thead className="bg-gray-100">
                                    <tr>
                                        <th className="p-3 border">Type</th>
                                        <th className="p-3 border">Name</th>
                                        <th className="p-3 border">Phone</th>
                                        <th className="p-3 border">Expected Date</th>
                                        <th className="p-3 border">Completed On</th>
                                        <th className="p-3 border">Status</th>
                                        <th className="p-3 border">Notes</th>
                                        <th className="p-3 border">Created By</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {data.map((followUp) => (
                                        <tr key={followUp.id} className="hover:bg-gray-50">
                                            <td className="p-3 border text-center">
                                                <span className={`text-xs px-2 py-1 rounded text-white ${followUp.follow_up_type === 'interview' ? 'bg-blue-500' : 'bg-green-500'
                                                    }`}>
                                                    {followUp.follow_up_type === 'interview' ? 'Interview' : 'Client'}
                                                </span>
                                            </td>
                                            <td className="p-3 border">{followUp.candidate_or_client_name}</td>
                                            <td className="p-3 border">{followUp.candidate_or_client_phone}</td>
                                            <td className="p-3 border">{followUp.expected_date}</td>
                                            <td className="p-3 border">
                                                {new Date(followUp.completed_on).toLocaleString('en-IN', {
                                                    year: 'numeric',
                                                    month: 'short',
                                                    day: 'numeric',
                                                    hour: '2-digit',
                                                    minute: '2-digit'
                                                })}
                                            </td>
                                            {/* 28-01-2026: Status column to show completion type */}
                                            <td className="p-3 border text-center">
                                                {followUp.activity_lead_status === 'rejected' ? (
                                                    <span className="text-xs px-3 py-1 bg-red-100 text-red-700 rounded font-medium">
                                                        Rejected
                                                    </span>
                                                ) : followUp.activity_lead_status === 'closed' ? (
                                                    <span className="text-xs px-3 py-1 bg-gray-100 text-gray-700 rounded font-medium">
                                                        Closed
                                                    </span>
                                                ) : (
                                                    <span className="text-xs px-3 py-1 bg-green-100 text-green-700 rounded font-medium">
                                                        Done
                                                    </span>
                                                )}
                                            </td>
                                            <td className="p-3 border">{followUp.notes || '-'}</td>
                                            <td className="p-3 border">{followUp.created_by_name}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default CompletedFollowUpsModal;
