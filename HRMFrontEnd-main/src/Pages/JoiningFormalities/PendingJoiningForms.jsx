import React, { useState, useEffect, useContext } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import { port } from '../../App';
import { HrmStore } from '../../Context/HrmContext';

const PendingJoiningForms = () => {
    const [pendingForms, setPendingForms] = useState([]);
    const [loading, setLoading] = useState(true);
    const [resendingId, setResendingId] = useState(null);
    const navigate = useNavigate();
    const { setTopNav } = useContext(HrmStore);

    const domain = window.location.origin;

    useEffect(() => {
        setTopNav('pending-forms');
        fetchPendingForms();
    }, []);

    const fetchPendingForms = async () => {
        try {
            setLoading(true);
            const response = await axios.get(`${port}/root/PendingJoiningForms`);
            setPendingForms(response.data.pending_forms || []);
        } catch (error) {
            console.error('Error fetching pending forms:', error);
            toast.error('Failed to fetch pending forms');
        } finally {
            setLoading(false);
        }
    };

    const handleResendEmail = async (offerId) => {
        try {
            setResendingId(offerId);
            const formURL = `${domain}/Employeeallform/`;

            await axios.post(`${port}/root/PendingJoiningForms`, {
                offer_id: offerId,
                FormURL: formURL
            });

            toast.success('Reminder email sent successfully!');
            fetchPendingForms();
        } catch (error) {
            console.error('Error resending email:', error);
            toast.error('Failed to send reminder email');
        } finally {
            setResendingId(null);
        }
    };

    const handleSendOfferManually = async (candidateId, offerId) => {
        try {
            await axios.patch(`${port}/root/PendingJoiningForms`, {
                offer_id: offerId
            });

            navigate(`/offerletter/${candidateId}`);
            toast.info('Redirecting to offer letter page...');
        } catch (error) {
            console.error('Error marking manual offer:', error);
            toast.error('Failed to process manual offer');
        }
    };

    const getOverdueColor = (daysOverdue) => {
        if (daysOverdue === 0) return 'bg-yellow-50';
        if (daysOverdue >= 1 && daysOverdue <= 3) return 'bg-orange-50';
        if (daysOverdue > 3) return 'bg-red-50';
        return '';
    };

    const getOverdueBadge = (daysOverdue) => {
        if (daysOverdue === 0) {
            return <span className="px-2 py-1 text-xs rounded bg-yellow-200 text-yellow-800">Due Today</span>;
        } else if (daysOverdue === 1) {
            return <span className="px-2 py-1 text-xs rounded bg-orange-200 text-orange-800">1 Day Overdue</span>;
        } else {
            return <span className="px-2 py-1 text-xs rounded bg-red-200 text-red-800">{daysOverdue} Days Overdue</span>;
        }
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center min-h-screen">
                <div className="text-xl">Loading...</div>
            </div>
        );
    }

    return (
        <div className=' d-flex font-poppins' style={{ width: '100%', minHeight: '100%', }}>
            <div className=' flex-1 container-fluid w-100 mx-auto ' style={{ borderRadius: '10px' }}>

                <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Pending Joining Forms</h6>
                    <div className="mt-3">
                        Total: {pendingForms.length}
                    </div>
                </div>

                {pendingForms.length === 0 ? (
                    <div className="bg-white rounded-lg shadow p-8 text-center mt-4">
                        <div className="text-gray-400 text-6xl mb-4">✓</div>
                        <h3 className="text-xl font-semibold text-gray-700 mb-2">All Clear!</h3>
                        <p className="text-gray-500">No pending joining forms at the moment.</p>
                    </div>
                ) : (
                    <div className='tablebg table-responsive rounded m-0 p-1 mt-3'>
                        <table className=" w-full " style={{ minWidth: '1200px' }}>
                            <thead>
                                <tr>
                                    <th scope="col">Candidate ID</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Position</th>
                                    <th scope="col">Joining Date</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Resent Count</th>
                                    <th scope="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {pendingForms.map((form) => (
                                    <tr key={form.offer_id} className={getOverdueColor(form.days_overdue)}>
                                        <td className="px-2">{form.candidate_id}</td>
                                        <td style={{ fontWeight: '500' }}>{form.name}</td>
                                        <td>{form.email}</td>
                                        <td>{form.phone || 'N/A'}</td>
                                        <td>
                                            <div>{form.position}</div>
                                            <div className="text-xs text-gray-400 capitalize">{form.employment_type}</div>
                                        </td>
                                        <td>{form.joining_date}</td>
                                        <td style={{ whiteSpace: 'nowrap' }}>{getOverdueBadge(form.days_overdue)}</td>
                                        <td className="text-center">
                                            {form.resend_count}
                                        </td>
                                        <td style={{ whiteSpace: 'nowrap' }}>
                                            <div className="flex gap-2">
                                                <button
                                                    onClick={() => handleResendEmail(form.offer_id)}
                                                    disabled={resendingId === form.offer_id}
                                                    className="px-2 py-1 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-400 text-xs"
                                                >
                                                    {resendingId === form.offer_id ? 'Wait...' : 'Resend'}
                                                </button>
                                                <button
                                                    onClick={() => handleSendOfferManually(form.candidate_id, form.offer_id)}
                                                    className="px-2 py-1 bg-green-600 text-white rounded hover:bg-green-700 text-xs"
                                                >
                                                    Offer
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>
        </div>
    );
};

export default PendingJoiningForms;
