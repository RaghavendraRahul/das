import React, { useEffect, useState, useContext } from 'react';
import axios from 'axios';
import { port } from '../../App';
import LoadingData from '../../Components/MiniComponent/LoadingData';
import { HrmStore } from '../../Context/HrmContext';
import { toast } from 'react-toastify';
import { Modal, Button } from 'react-bootstrap';

const CorrectionApprovalTable = () => {
    const [requests, setRequests] = useState([]);
    const [loading, setLoading] = useState(false);
    const [processingId, setProcessingId] = useState(null); // ID of request being processed
    const [confirmModal, setConfirmModal] = useState({ show: false, id: null, action: '' });

    const { setTopNav } = useContext(HrmStore);

    // Get current logged-in user as approver
    const approverId = JSON.parse(sessionStorage.getItem('dasid'));

    useEffect(() => {
        setTopNav('approvals');
        fetchRequests();
    }, []);

    const fetchRequests = async () => {
        setLoading(true);
        try {
            // Fetch all requests
            const response = await axios.get(`${port}/root/lms/attendance/correction/`);
            // Filter only Pending requests for this view
            const pendingRequests = response.data.filter(req => req.request_status === 'Pending');
            setRequests(pendingRequests);
        } catch (error) {
            console.error("Error fetching requests:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleApproval = async (id, action) => {
        setConfirmModal({ show: true, id, action });
    };

    const confirmApproval = async () => {
        const { id, action } = confirmModal;
        setConfirmModal({ ...confirmModal, show: false });

        setProcessingId(id);
        try {
            await axios.post(`${port}/root/lms/attendance/correction/${id}/approve/`, {
                action: action,
                approver_id: approverId,
                approval_reason: `${action} by Admin`
            });
            toast.success(`Request ${action} successfully!`);
            // Remove from list or refresh
            setRequests(prev => prev.filter(req => req.id !== id));
        } catch (error) {
            console.error(`Error ${action} request:`, error);
            toast.error(`Failed to ${action} request.`);
        } finally {
            setProcessingId(null);
        }
    };

    return (
        <div className="bg-white p-4 rounded shadow poppins">
            <h2 className="text-xl font-bold mb-4">Pending Attendance Corrections</h2>

            {loading ? (
                <LoadingData />
            ) : requests.length === 0 ? (
                <p className="text-gray-500">No pending corrections.</p>
            ) : (
                <div className="overflow-x-auto">
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="bg-gray-100 text-sm uppercase text-gray-600">
                                <th className="p-3 border-b text-center">Employee</th>
                                <th className="p-3 border-b text-center">Date</th>
                                <th className="p-3 border-b text-center">Correction</th>
                                <th className="p-3 border-b text-center">Reason</th>
                                <th className="p-3 border-b text-center">Requested By</th>
                                <th className="p-3 border-b text-center">Created At</th>
                                <th className="p-3 border-b text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {requests.map((req) => (
                                <tr key={req.id} className="hover:bg-gray-50 border-b">
                                    <td className="p-3 text-center">
                                        <div className="font-semibold">{req.employee_name}</div>
                                        <div className="text-xs text-gray-500">{req.employee_id}</div>
                                    </td>
                                    <td className="p-3 text-center">{req.attendance_date}</td>
                                    <td className="p-3 text-center">
                                        <div className="text-xs text-gray-500">From: {req.previous_status || 'Data Missing'}</div>
                                        <div className="font-bold text-green-600">To: {req.requested_status}</div>
                                    </td>
                                    <td className="p-3 text-center text-sm italic">{req.reason}</td>
                                    <td className="p-3 text-center text-sm">{req.requested_by_name}</td>
                                    <td className="p-3 text-center text-sm">
                                        <div className="text-xs text-gray-600">
                                            {new Date(req.created_at).toLocaleDateString('en-IN', { 
                                                day: '2-digit', 
                                                month: 'short', 
                                                year: 'numeric' 
                                            })}
                                        </div>
                                        <div className="text-xs text-gray-500">
                                            {new Date(req.created_at).toLocaleTimeString('en-IN', { 
                                                hour: '2-digit', 
                                                minute: '2-digit' 
                                            })}
                                        </div>
                                    </td>
                                    <td className="p-3 text-center">
                                        <div className="flex gap-2 justify-center">
                                            <button
                                                onClick={() => handleApproval(req.id, 'Approved')}
                                                disabled={processingId === req.id}
                                                className="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded text-sm transition"
                                            >
                                                {processingId === req.id ? '...' : 'Approve'}
                                            </button>
                                            <button
                                                onClick={() => handleApproval(req.id, 'Rejected')}
                                                disabled={processingId === req.id}
                                                className="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-sm transition"
                                            >
                                                Reject
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* Confirmation Modal */}
            <Modal show={confirmModal.show} onHide={() => setConfirmModal({ show: false, id: null, action: '' })} centered>
                <Modal.Header closeButton>
                    <Modal.Title className="text-lg poppins">Confirm Action</Modal.Title>
                </Modal.Header>
                <Modal.Body className="py-4">
                    <p className="text-center font-medium poppins">
                        Are you sure you want to <span className={confirmModal.action === 'Approved' ? 'text-green-600 font-bold poppins' : 'text-red-600 font-bold poppins'}>{confirmModal.action.toLowerCase()}</span> this correction request?
                    </p>
                </Modal.Body>
                <Modal.Footer className="border-0">
                    <Button variant="secondary" onClick={() => setConfirmModal({ show: false, id: null, action: '' })} className="poppins">
                        Cancel
                    </Button>
                    <Button
                        variant={confirmModal.action === 'Approved' ? 'success' : 'danger'}
                        onClick={confirmApproval}
                        className="poppins"
                    >
                        Confirm {confirmModal.action}
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
};

export default CorrectionApprovalTable;
