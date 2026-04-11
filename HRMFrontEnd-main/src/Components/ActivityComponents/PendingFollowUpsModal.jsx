// New Follow-Up Enhancement Modal
import React, { useState } from 'react';
import axios from 'axios';
import { port } from '../../App';
import { toast } from 'react-toastify';

const Loader = ({ height = '200px' }) => (
    <div className="flex justify-center items-center" style={{ height }}>
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-blue-500"></div>
    </div>
);

// Utility function to convert 24-hour time to 12-hour format
const formatTimeTo12Hour = (time24) => {
    if (!time24) return '-';

    const [hours, minutes] = time24.split(':');
    const hour = parseInt(hours, 10);
    const ampm = hour >= 12 ? 'PM' : 'AM';
    const hour12 = hour % 12 || 12; // Convert 0 to 12 for midnight

    return `${hour12}:${minutes} ${ampm}`;
};

const PendingFollowUpsModal = ({ show, onHide, data, isLoading, onRefresh }) => {
    const empid = JSON.parse(sessionStorage.getItem('user'))?.EmployeeId;
    const [actionLoading, setActionLoading] = useState(null);
    const [showActionModal, setShowActionModal] = useState(false);
    const [selectedFollowUp, setSelectedFollowUp] = useState(null);
    const [actionType, setActionType] = useState('');

    // Form states for different actions
    const [callAgainDate, setCallAgainDate] = useState('');
    const [callAgainTime, setCallAgainTime] = useState('');
    const [callAgainNotes, setCallAgainNotes] = useState('');
    const [rejectionType, setRejectionType] = useState('emp_rejected');
    const [reason, setReason] = useState('');

    if (!show) return null;

    const closeOnOutsideClick = (e) => {
        if (e.target.id === 'modalBackdrop') {
            onHide();
        }
    };

    const handleAction = (followUp, action) => {
        setSelectedFollowUp(followUp);
        setActionType(action);
        setShowActionModal(true);
        // Reset form fields
        setCallAgainDate('');
        setCallAgainTime('');
        setCallAgainNotes('');
        setRejectionType('emp_rejected');
        setReason('');
    };

    const executeAction = async () => {
        if (!selectedFollowUp) return;

        setActionLoading(selectedFollowUp.id);

        try {
            let payload = { action: actionType };

            if (actionType === 'call_again') {
                if (!callAgainDate || !callAgainTime) {
                    toast.warning('Please provide date and time for the next call');
                    setActionLoading(null);
                    return;
                }
                payload.expected_date = callAgainDate;
                payload.expected_time = callAgainTime;
                payload.notes = callAgainNotes;
            } else if (actionType === 'reject') {
                payload.rejection_type = rejectionType;
                payload.reason = reason;
            } else if (actionType === 'close') {
                payload.reason = reason;
            }

            await axios.patch(
                `${port}/root/activity/followup/${selectedFollowUp.id}/action`,
                payload
            );

            toast.success(`Follow-up ${actionType === 'complete' ? 'completed' : actionType === 'call_again' ? 'rescheduled' : actionType}d successfully!`);
            setShowActionModal(false);
            setSelectedFollowUp(null);
            onRefresh(); // Refresh the data
        } catch (error) {
            console.error(`Error performing ${actionType}:`, error);

            // Check if error response contains suggested times
            if (error.response?.data?.suggested_times && error.response.data.suggested_times.length > 0) {
                const suggestedTimes = error.response.data.suggested_times;
                const errorMsg = error.response.data.error || `Failed to ${actionType} follow-up`;

                // Convert 24-hour to 12-hour format for display
                const formatTime = (time24) => {
                    const [hours, minutes] = time24.split(':');
                    const hour = parseInt(hours, 10);
                    const ampm = hour >= 12 ? 'PM' : 'AM';
                    const hour12 = hour % 12 || 12;
                    return `${hour12}:${minutes} ${ampm}`;
                };

                const suggestedTimesFormatted = suggestedTimes.map(formatTime).join(', ');
                toast.error(`${errorMsg}\n\n💡 Suggested times: ${suggestedTimesFormatted}`, {
                    autoClose: 6000 // Longer display time for suggestions
                });
            } else {
                const errorMsg = error.response?.data?.error || `Failed to ${actionType} follow-up`;
                toast.error(errorMsg);
            }
        } finally {
            setActionLoading(null);
        }
    };

    const renderActionModal = () => {
        if (!showActionModal) return null;

        return (
            <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 backdrop-blur-sm">
                <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
                    <h3 className="text-lg font-semibold mb-4">
                        {actionType === 'complete' && 'Mark as Complete'}
                        {actionType === 'call_again' && 'Schedule Another Call'}
                        {actionType === 'reject' && 'Reject Lead'}
                        {actionType === 'close' && 'Close Lead'}
                    </h3>

                    {actionType === 'call_again' && (
                        <div className="space-y-3">
                            <div>
                                <label className="block text-sm font-medium mb-1">Expected Date</label>
                                <input
                                    type="date"
                                    value={callAgainDate}
                                    onChange={(e) => setCallAgainDate(e.target.value)}
                                    className="w-full border rounded px-3 py-2"
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Expected Time</label>
                                <input
                                    type="time"
                                    value={callAgainTime}
                                    onChange={(e) => setCallAgainTime(e.target.value)}
                                    className="w-full border rounded px-3 py-2"
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Notes</label>
                                <textarea
                                    value={callAgainNotes}
                                    onChange={(e) => setCallAgainNotes(e.target.value)}
                                    className="w-full border rounded px-3 py-2"
                                    rows="3"
                                    placeholder="Add notes for next call..."
                                />
                            </div>
                        </div>
                    )}

                    {actionType === 'reject' && (
                        <div className="space-y-3">
                            <div>
                                <label className="block text-sm font-medium mb-2">Rejection Type</label>
                                <div className="space-y-2">
                                    <label className="flex items-center">
                                        <input
                                            type="radio"
                                            value="emp_rejected"
                                            checked={rejectionType === 'emp_rejected'}
                                            onChange={(e) => setRejectionType(e.target.value)}
                                            className="mr-2"
                                        />
                                        Employee Rejected
                                    </label>
                                    <label className="flex items-center">
                                        <input
                                            type="radio"
                                            value="candidate_rejected"
                                            checked={rejectionType === 'candidate_rejected'}
                                            onChange={(e) => setRejectionType(e.target.value)}
                                            className="mr-2"
                                        />
                                        Candidate Rejected
                                    </label>
                                </div>
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Reason</label>
                                <textarea
                                    value={reason}
                                    onChange={(e) => setReason(e.target.value)}
                                    className="w-full border rounded px-3 py-2"
                                    rows="3"
                                    placeholder="Reason for rejection..."
                                />
                            </div>
                        </div>
                    )}

                    {actionType === 'close' && (
                        <div>
                            <label className="block text-sm font-medium mb-1">Closure Reason</label>
                            <textarea
                                value={reason}
                                onChange={(e) => setReason(e.target.value)}
                                className="w-full border rounded px-3 py-2"
                                rows="3"
                                placeholder="e.g., Not interested, Found another job..."
                            />
                        </div>
                    )}

                    {actionType === 'complete' && (
                        <p className="text-gray-600">Are you sure you want to mark this follow-up as completed?</p>
                    )}

                    <div className="flex gap-2 mt-4">
                        <button
                            onClick={executeAction}
                            disabled={actionLoading}
                            className="flex-1 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
                        >
                            {actionLoading ? 'Processing...' : 'Confirm'}
                        </button>
                        <button
                            onClick={() => setShowActionModal(false)}
                            className="flex-1 bg-gray-300 px-4 py-2 rounded hover:bg-gray-400"
                        >
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        );
    };

    return (
        <>
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
                        <h2 className="text-xl font-semibold">Pending Follow Ups</h2>
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
                            <p className="text-center text-gray-500">No pending follow-ups found.</p>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="min-w-full border border-gray-300 rounded-md text-sm">
                                    <thead className="bg-gray-100">
                                        <tr>
                                            <th className="p-3 border">Type</th>
                                            <th className="p-3 border">Name</th>
                                            <th className="p-3 border">Phone</th>
                                            <th className="p-3 border">Expected Date</th>
                                            <th className="p-3 border">Expected Time</th>
                                            <th className="p-3 border">Notes</th>
                                            <th className="p-3 border">Actions</th>
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
                                                <td className="p-3 border">{formatTimeTo12Hour(followUp.expected_time)}</td>
                                                <td className="p-3 border">{followUp.notes || '-'}</td>
                                                <td className="p-3 border">
                                                    <select
                                                        onChange={(e) => {
                                                            if (e.target.value) {
                                                                handleAction(followUp, e.target.value);
                                                                e.target.value = ''; // Reset dropdown
                                                            }
                                                        }}
                                                        disabled={actionLoading === followUp.id}
                                                        className="text-xs px-2 py-1 border rounded bg-white cursor-pointer disabled:opacity-50"
                                                    >
                                                        <option value="">Select Action</option>
                                                        <option value="complete">Done</option>
                                                        <option value="call_again">Call Again</option>
                                                        <option value="reject">Reject</option>
                                                        <option value="close">Close</option>
                                                    </select>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            </div>
            {renderActionModal()}
        </>
    );
};

export default PendingFollowUpsModal;
