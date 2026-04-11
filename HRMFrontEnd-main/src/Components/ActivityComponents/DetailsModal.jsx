import React, { useState } from 'react';
import axios from 'axios';
import { port } from '../../App';
import { toast } from 'react-toastify';

const Loader = ({ height = '200px' }) => (
    <div className="flex justify-center items-center" style={{ height }}>
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-blue-500"></div>
    </div>
);

// const DetailsTable = ({ data }) => {
const DetailsTable = ({ data, onActionSelect }) => {
    if (!data || data.length === 0) {
        return <p className="text-center text-gray-500">No data found for this category.</p>;
    }

    return (
        <div className="overflow-x-auto text-center">
            <table className="min-w-full border border-gray-300 rounded-md text-sm">
                <thead className="bg-gray-100">
                    <tr>
                        <th className="p-3 border">Type</th>
                        <th className="p-3 border">Name / Position</th>
                        <th className="p-3 border">Contact</th>
                        <th className="p-3 border">Status / Purpose</th>
                        <th className="p-3 border">Details</th>
                        <th className="p-3 border">Notes</th>
                        <th className="p-3 border">Lead Status</th>
                        <th className="p-3 border">Actions</th>
                    </tr>
                </thead>

                <tbody>
                    {data.map(item => {
                        if (item.candidate_name) {
                            return (
                                <tr key={`interview-${item.id}`} className="hover:bg-gray-50 align-middle">
                                    <td className="p-3 border">
                                        <span className="text-xs px-2 py-1 bg-blue-500 text-white rounded">Interview</span>
                                    </td>
                                    <td className="p-3 border">{item.candidate_name}</td>
                                    <td className="p-3 border">{item.candidate_phone}</td>
                                    <td className="p-3 border">{item.interview_status}</td>
                                    <td className="p-3 border">{item.candidate_designation}</td>
                                    <td className="p-3 border">{item.closure_reason || '-'}</td>
                                    {/* Lead Status column */}
                                    <td className="p-3 border text-center">
                                        {item.lead_status === 'follow_up' ? (
                                            <span className="text-xs px-2 py-1 bg-purple-100 text-purple-700 rounded font-medium">
                                                Follow-Up
                                            </span>
                                        ) : item.lead_status === 'rejected' ? (
                                            <span className="text-xs px-2 py-1 bg-red-100 text-red-700 rounded font-medium">
                                                Rejected
                                            </span>
                                        ) : item.lead_status === 'closed' ? (
                                            <span className="text-xs px-3 py-1 bg-gray-100 text-gray-700 rounded font-medium">
                                                Closed
                                            </span>
                                        ) : (
                                            <span className="text-xs px-3 py-1 bg-green-100 text-green-700 rounded font-medium">
                                                Active
                                            </span>
                                        )}
                                    </td>
                                    {/* Show status or dropdown based on lead_status */}
                                    <td className="p-3 border">
                                        {item.lead_status === 'follow_up' ? (
                                            <span className="text-xs px-3 py-1 bg-purple-100 text-purple-700 rounded font-medium">
                                                Follow-Up
                                            </span>
                                        ) : item.lead_status === 'rejected' ? (
                                            <span className="text-xs px-3 py-1 bg-red-100 text-red-700 rounded font-medium">
                                                Rejected
                                            </span>
                                        ) : item.lead_status === 'closed' ? (
                                            <span className="text-xs px-3 py-1 bg-gray-100 text-gray-700 rounded font-medium">
                                                Closed
                                            </span>
                                        ) : (
                                            <select
                                                onChange={(e) => {
                                                    if (e.target.value) {
                                                        onActionSelect(item, e.target.value, 'interview');
                                                        e.target.value = ''; // Reset dropdown
                                                    }
                                                }}
                                                className="text-xs px-2 py-1 border rounded bg-white cursor-pointer"
                                            >
                                                <option value="">Select Action</option>
                                                <option value="followup">Follow Up</option>
                                                <option value="reject">Reject</option>
                                                <option value="close">Close</option>
                                            </select>
                                        )}
                                    </td>
                                </tr>
                            );
                        }

                        if (item.client_name) {
                            return (
                                <tr key={`client-${item.id}`} className="hover:bg-gray-50">
                                    <td className="p-3 border">
                                        <span className="text-xs px-2 py-1 bg-green-500 text-white rounded">Client Call</span>
                                    </td>
                                    <td className="p-3 border">{item.client_name}</td>
                                    <td className="p-3 border">{item.client_phone}</td>
                                    <td className="p-3 border">{item.client_enquire_purpose}</td>
                                    <td className="p-3 border">{item.client_status}</td>
                                    <td className="p-3 border">{item.closure_reason || '-'}</td>
                                    {/* Lead Status column */}
                                    <td className="p-3 border text-center">
                                        {item.lead_status === 'follow_up' ? (
                                            <span className="text-xs px-3 py-1 bg-purple-100 text-purple-700 rounded font-medium">
                                                Follow-Up
                                            </span>
                                        ) : item.lead_status === 'rejected' ? (
                                            <span className="text-xs px-3 py-1 bg-red-100 text-red-700 rounded font-medium">
                                                Rejected
                                            </span>
                                        ) : item.lead_status === 'closed' ? (
                                            <span className="text-xs px-3 py-1 bg-gray-100 text-gray-700 rounded font-medium">
                                                Closed
                                            </span>
                                        ) : (
                                            <span className="text-xs px-3 py-1 bg-green-100 text-green-700 rounded font-medium">
                                                Active
                                            </span>
                                        )}
                                    </td>
                                    {/* Show status or dropdown based on lead_status */}
                                    <td className="p-3 border">
                                        {item.lead_status === 'follow_up' ? (
                                            <span className="text-xs px-3 py-1 bg-purple-100 text-purple-700 rounded font-medium">
                                                Follow-Up
                                            </span>
                                        ) : item.lead_status === 'rejected' ? (
                                            <span className="text-xs px-3 py-1 bg-red-100 text-red-700 rounded font-medium">
                                                Rejected
                                            </span>
                                        ) : item.lead_status === 'closed' ? (
                                            <span className="text-xs px-3 py-1 bg-gray-100 text-gray-700 rounded font-medium">
                                                Closed
                                            </span>
                                        ) : (
                                            <select
                                                onChange={(e) => {
                                                    if (e.target.value) {
                                                        onActionSelect(item, e.target.value, 'client');
                                                        e.target.value = ''; // Reset dropdown
                                                    }
                                                }}
                                                className="text-xs px-2 py-1 border rounded bg-white cursor-pointer"
                                            >
                                                <option value="">Select Action</option>
                                                <option value="followup">Follow Up</option>
                                                <option value="reject">Reject</option>
                                                <option value="close">Close</option>
                                            </select>
                                        )}
                                    </td>
                                </tr>
                            );
                        }

                        if (item.position) {
                            return (
                                <tr key={`job-${item.id}`} className="hover:bg-gray-50">
                                    <td className="p-3 border">
                                        <span className="text-xs px-2 py-1 bg-cyan-500 text-white rounded">Job Post</span>
                                    </td>
                                    <td className="p-3 border">{item.position}</td>
                                    <td className="p-3 border">
                                        <a
                                            href={item.url}
                                            target="_blank"
                                            rel="noopener noreferrer"
                                            className="text-blue-600 underline"
                                        >
                                            View Post
                                        </a>
                                    </td>
                                    <td className="p-3 border">N/A</td>
                                    <td className="p-3 border">{item.job_post_remarks}</td>
                                    <td className="p-3 border">-</td>
                                    <td className="p-3 border">-</td>
                                    <td className="p-3 border">-</td>
                                </tr>
                            );
                        }

                        return null;
                    })}
                </tbody>
            </table>
        </div>
    );
};

// const DetailsModal = ({ show, onHide, title, data, isLoading }) => {
const DetailsModal = ({ show, onHide, title, data, isLoading, onRefresh }) => {
    const empid = JSON.parse(sessionStorage.getItem('user'))?.EmployeeId;

    // 28-01-2026: State for action forms
    const [showActionForm, setShowActionForm] = useState(false);
    const [selectedActivity, setSelectedActivity] = useState(null);
    const [actionType, setActionType] = useState(''); // 'followup', 'reject', 'close'

    // Form fields
    const [expectedDate, setExpectedDate] = useState('');
    const [expectedTime, setExpectedTime] = useState('');
    const [notes, setNotes] = useState('');
    const [rejectionType, setRejectionType] = useState('emp_rejected');
    const [isSubmitting, setIsSubmitting] = useState(false);

    if (!show) return null;

    const closeOnOutsideClick = (e) => {
        if (e.target.id === 'modalBackdrop') {
            onHide();
        }
    };

    // 28-01-2026: Handler when action is selected from dropdown
    const handleActionSelect = (activity, action, type) => {
        setSelectedActivity(activity);
        setActionType(action);
        setShowActionForm(true);
        // Reset form fields
        setExpectedDate('');
        setExpectedTime('');
        setNotes('');
        setRejectionType('emp_rejected');
    };

    // 28-01-2026: Handler to submit the action
    const handleSubmitAction = async () => {
        if (actionType === 'followup' && (!expectedDate || !expectedTime)) {
            toast.warning('Please provide expected date and time');
            return;
        }

        if ((actionType === 'reject' || actionType === 'close') && !notes) {
            toast.warning('Please provide a reason');
            return;
        }

        setIsSubmitting(true);
        try {
            if (actionType === 'followup') {
                // Convert to follow-up
                await axios.post(`${port}/root/activity/convert-to-followup`, {
                    activity_record_id: selectedActivity.id,
                    expected_date: expectedDate,
                    expected_time: expectedTime,
                    notes: notes,
                    login_emp_id: empid
                });
                toast.success('Successfully converted to follow-up!');
            } else if (actionType === 'reject') {
                // Direct reject (without creating follow-up first)
                // We need to create a follow-up and immediately reject it
                const followUpResponse = await axios.post(`${port}/root/activity/convert-to-followup`, {
                    activity_record_id: selectedActivity.id,
                    expected_date: new Date().toISOString().split('T')[0],
                    expected_time: new Date().toTimeString().split(' ')[0].substring(0, 5),
                    notes: notes,
                    login_emp_id: empid
                });

                // Then reject it
                await axios.patch(`${port}/root/activity/followup/${followUpResponse.data.follow_up.id}/action`, {
                    action: 'reject',
                    rejection_type: rejectionType,
                    reason: notes
                });
                toast.success('Lead rejected successfully!');
            } else if (actionType === 'close') {
                // Direct close (without creating follow-up first)
                const followUpResponse = await axios.post(`${port}/root/activity/convert-to-followup`, {
                    activity_record_id: selectedActivity.id,
                    expected_date: new Date().toISOString().split('T')[0],
                    expected_time: new Date().toTimeString().split(' ')[0].substring(0, 5),
                    notes: notes,
                    login_emp_id: empid
                });

                // Then close it
                await axios.patch(`${port}/root/activity/followup/${followUpResponse.data.follow_up.id}/action`, {
                    action: 'close',
                    reason: notes
                });
                toast.success('Lead closed successfully!');
            }

            setShowActionForm(false);
            setSelectedActivity(null);

            // 28-01-2026: Refresh dashboard to update counts
            if (onRefresh) {
                onRefresh();
            }

            // 28-01-2026: Close the DetailsModal after a short delay so user sees the toast
            setTimeout(() => {
                if (onHide) {
                    onHide();
                }
            }, 1500); // 1.5 second delay to show toast
        } catch (error) {
            console.error(`Error performing ${actionType}:`, error);

            // Check if error response contains suggested times
            if (error.response?.data?.suggested_times && error.response.data.suggested_times.length > 0) {
                const suggestedTimes = error.response.data.suggested_times;
                const errorMsg = error.response.data.error || `Failed to ${actionType} lead`;

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
                const errorMsg = error.response?.data?.error || `Failed to ${actionType} lead`;
                toast.error(errorMsg);
            }
        } finally {
            setIsSubmitting(false);
        }
    };

    // 28-01-2026: Action form modal
    const renderActionForm = () => {
        if (!showActionForm) return null;

        return (
            <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 backdrop-blur-sm">
                <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
                    <h3 className="text-lg font-semibold mb-4">
                        {actionType === 'followup' && 'Schedule Follow-Up'}
                        {actionType === 'reject' && 'Reject Lead'}
                        {actionType === 'close' && 'Close Lead'}
                    </h3>

                    <div className="mb-3">
                        <p className="text-sm text-gray-600">
                            <strong>Name:</strong> {selectedActivity?.candidate_name || selectedActivity?.client_name}
                        </p>
                        <p className="text-sm text-gray-600">
                            <strong>Phone:</strong> {selectedActivity?.candidate_phone || selectedActivity?.client_phone}
                        </p>
                    </div>

                    <div className="space-y-3">
                        {actionType === 'followup' && (
                            <>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Expected Date *</label>
                                    <input
                                        type="date"
                                        value={expectedDate}
                                        onChange={(e) => setExpectedDate(e.target.value)}
                                        className="w-full border rounded px-3 py-2"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Expected Time *</label>
                                    <input
                                        type="time"
                                        value={expectedTime}
                                        onChange={(e) => setExpectedTime(e.target.value)}
                                        className="w-full border rounded px-3 py-2"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Notes</label>
                                    <textarea
                                        value={notes}
                                        onChange={(e) => setNotes(e.target.value)}
                                        className="w-full border rounded px-3 py-2"
                                        rows="3"
                                        placeholder="Add notes for follow-up..."
                                    />
                                </div>
                            </>
                        )}

                        {actionType === 'reject' && (
                            <>
                                <div>
                                    <label className="block text-sm font-medium mb-2">Rejection Type *</label>
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
                                    <label className="block text-sm font-medium mb-1">Reason *</label>
                                    <textarea
                                        value={notes}
                                        onChange={(e) => setNotes(e.target.value)}
                                        className="w-full border rounded px-3 py-2"
                                        rows="3"
                                        placeholder="Reason for rejection..."
                                    />
                                </div>
                            </>
                        )}

                        {actionType === 'close' && (
                            <div>
                                <label className="block text-sm font-medium mb-1">Closure Reason *</label>
                                <textarea
                                    value={notes}
                                    onChange={(e) => setNotes(e.target.value)}
                                    className="w-full border rounded px-3 py-2"
                                    rows="3"
                                    placeholder="e.g., Not interested, Found another job..."
                                />
                            </div>
                        )}
                    </div>

                    <div className="flex gap-2 mt-4">
                        <button
                            onClick={handleSubmitAction}
                            disabled={isSubmitting}
                            className="flex-1 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
                        >
                            {isSubmitting ? 'Processing...' : 'Confirm'}
                        </button>
                        <button
                            onClick={() => setShowActionForm(false)}
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
                // className="fixe inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-md p-4 "
                className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-md p-4 "
            >
                <div
                    className="bg-white w-full max-w-6xl rounded-lg shadow-xl max-h-[80vh] overflow-hidden "
                    onClick={(e) => e.stopPropagation()}
                >
                    <div className="flex justify-between items-center p-4 border-b">
                        <h2 className="text-xl font-semibold">{title}</h2>
                        <button
                            onClick={onHide}
                            className="text-gray-600 hover:text-black text-2xl"
                        >
                            &times;
                        </button>
                    </div>

                    <div className="p-4 overflow-y-auto max-h-[60vh]">
                        {/* {isLoading ? <Loader height="300px" /> : <DetailsTable data={data} />} */}
                        {isLoading ? <Loader height="300px" /> : <DetailsTable data={data} onActionSelect={handleActionSelect} />}
                    </div>

                    <div className="p-4 border-t text-right">
                        {/* <button
                            onClick={onHide}
                            className="px-4 bg-gray-600 text-white rounded hover:bg-gray-700"
                        >
                            Close
                        </button> */}
                    </div>
                </div>
            </div>
            {renderActionForm()}
        </>
    );
};

export default DetailsModal;
