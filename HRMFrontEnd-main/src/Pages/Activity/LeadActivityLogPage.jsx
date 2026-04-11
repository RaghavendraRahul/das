
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import { port } from '../../App';
import BackButton from '../../Components/MiniComponent/BackButton';

const LeadActivityLogPage = () => {
    const { activityId } = useParams();
    const [leadData, setLeadData] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchLog = async () => {
            try {
                // Remove trailing slash from port if present
                const basePort = port.endsWith('/') ? port.slice(0, -1) : port;
                const response = await axios.get(`${basePort}/root/activity/lead-log/${activityId}`);
                setLeadData(response.data);
            } catch (err) {
                console.error("Error fetching lead log:", err);
                setError("Failed to load lead history.");
            } finally {
                setIsLoading(false);
            }
        };

        if (activityId) {
            fetchLog();
        }
    }, [activityId]);

    const formatTimeTo12Hour = (time24) => {
        if (!time24) return '-';
        const [hours, minutes] = time24.split(':');
        const hour = parseInt(hours, 10);
        const ampm = hour >= 12 ? 'PM' : 'AM';
        const hour12 = hour % 12 || 12;
        return `${hour12}:${minutes} ${ampm}`;
    };

    if (isLoading) {
        return (
            <div className="flex justify-center items-center h-screen">
                <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
            </div>
        );
    }

    if (error || !leadData) {
        return (
            <div className="container-fluid p-4">
                <BackButton />
                <div className="alert alert-danger mt-4">{error || "No data found"}</div>
            </div>
        );
    }

    return (
        <div className="container-fluid p-4 poppins bg-gray-50 min-h-screen">
            <div className="flex items-center gap-4 mb-6">
                <BackButton />
                <h2 className="text-2xl font-bold text-gray-800 m-0">Lead Activity Log</h2>
            </div>

            {/* Lead Details Card */}
            <div className="bg-white rounded-xl shadow-sm border p-6 mb-6">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div>
                        <p className="text-gray-500 text-sm font-semibold uppercase mb-1">Name</p>
                        <p className="text-lg font-bold text-gray-800">{leadData.lead_details.name || '-'}</p>
                    </div>
                    <div>
                        <p className="text-gray-500 text-sm font-semibold uppercase mb-1">Phone</p>
                        <p className="text-lg text-gray-800">{leadData.lead_details.phone || '-'}</p>
                    </div>
                    <div>
                        <p className="text-gray-500 text-sm font-semibold uppercase mb-1">Email</p>
                        <p className="text-gray-800">{leadData.lead_details.email || '-'}</p>
                    </div>
                    <div>
                        <p className="text-gray-500 text-sm font-semibold uppercase mb-1">Company</p>
                        <p className="text-gray-800 font-medium">{leadData.lead_details.company_name || '-'}</p>
                    </div>
                    <div>
                        <p className="text-gray-500 text-sm font-semibold uppercase mb-1">Current Status</p>
                        <span className={`px-3 py-1 rounded-full text-sm font-medium 
                            ${leadData.lead_details.current_status === 'active' ? 'bg-green-100 text-green-700' :
                                leadData.lead_details.current_status === 'closed' ? 'bg-gray-100 text-gray-700' :
                                    leadData.lead_details.current_status === 'rejected' ? 'bg-red-100 text-red-700' :
                                        'bg-blue-100 text-blue-700'}`}>
                            {leadData.lead_details.current_status || 'Active'}
                        </span>
                    </div>
                </div>
            </div>

            {/* Timeline */}
            <h3 className="text-xl font-bold text-gray-800 mb-4 px-1">History</h3>
            <div className="space-y-4">
                {leadData.history.map((log, index) => (
                    <div key={log.id} className="bg-white rounded-lg shadow-sm border p-4 hover:shadow-md transition-shadow">
                        <div className="flex flex-col md:flex-row justify-between gap-4">
                            <div className="md:w-1/4 border-r-0 md:border-r border-gray-100 md:pr-4">
                                <div className="flex items-center gap-2 mb-2">
                                    <span className={`w-2 h-2 rounded-full 
                                        ${log.status === 'active' ? 'bg-green-500' :
                                            log.status === 'closed' ? 'bg-gray-500' :
                                                log.status === 'rejected' ? 'bg-red-500' : 'bg-blue-500'}`}>
                                    </span>
                                    <span className="font-bold text-gray-700 capitalize">{log.status}</span>
                                </div>
                                <p className="text-sm text-gray-500">{new Date(log.created_date).toLocaleDateString()} {new Date(log.created_date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</p>
                                <p className="text-xs text-gray-400 mt-1">By: {log.employee_name}</p>
                            </div>

                            <div className="md:w-3/4">
                                <div>
                                    <span className="text-xs font-bold text-gray-500 uppercase mr-2">Note:</span>
                                    <span className="text-gray-800 whitespace-pre-wrap">{log.notes || 'No notes recorded.'}</span>
                                </div>

                                {log.sub_status && (
                                    <div className="mt-2">
                                        <span className="text-xs font-semibold text-gray-500 uppercase mr-2">Info:</span>
                                        <span className="text-sm bg-gray-100 px-2 py-1 rounded text-gray-600 capitalize">
                                            {String(log.sub_status).replace(/_/g, ' ')}
                                        </span>
                                    </div>
                                )}

                                {log.status === 'follow_up' && (
                                    <div className="mt-3 flex gap-4 text-sm bg-blue-50 p-2 rounded border border-blue-100 max-w-fit">
                                        <div>
                                            <span className="font-semibold text-blue-700 block">Next Follow-up:</span>
                                            <span className="text-blue-900">{log.expected_date} {formatTimeTo12Hour(log.expected_time)}</span>
                                        </div>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                ))}

                {leadData.history.length === 0 && (
                    <div className="text-center py-8 text-gray-500">
                        No history found for this lead.
                    </div>
                )}
            </div>
        </div>
    );
};

export default LeadActivityLogPage;
