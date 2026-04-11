import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { port } from '../../App';
import LoadingData from '../../Components/MiniComponent/LoadingData';
import { toast } from 'react-toastify';

const AttendanceCorrectionModal = ({ employeeId, employeeName, month, year, onClose }) => {
    const [dailyData, setDailyData] = useState([]);
    const [latestRequests, setLatestRequests] = useState({}); // { 'YYYY-MM-DD': req_obj }
    const [loading, setLoading] = useState(false);

    // Edit Correction State
    const [editingDay, setEditingDay] = useState(null); // { date: 'YYYY-MM-DD', currentStatus: '', recordId: null }
    const [newStatus, setNewStatus] = useState('');
    const [reason, setReason] = useState('');
    const [submitting, setSubmitting] = useState(false);

    useEffect(() => {
        if (employeeId && month && year) {
            fetchAttendance();
        }
    }, [employeeId, month, year]);

    const fetchAttendance = async () => {
        setLoading(true);
        try {
            const startDate = `${year}-${month}-01`;
            // Calculate end date
            const lastDay = new Date(year, month, 0).getDate();
            const endDate = `${year}-${month}-${lastDay}`;

            const dailyResponse = await axios.get(`${port}/root/lms/employee-attendance/${employeeId}/${startDate}/${endDate}/`);

            // Fetch correction requests to find pending/rejected/approved ones
            const correctionResponse = await axios.get(`${port}/root/lms/attendance/correction/`);
            const requestsMap = {};
            if (Array.isArray(correctionResponse.data)) {
                // Requests are ordered newest first from backend
                correctionResponse.data.forEach(req => {
                    if (req.employee_id === employeeId) {
                        // Store the latest request for each day
                        if (!requestsMap[req.attendance_date]) {
                            requestsMap[req.attendance_date] = req;
                        }
                    }
                });
            }
            setLatestRequests(requestsMap);

            // Transform API data into a map for easy lookup
            const attendanceMap = {};
            if (Array.isArray(dailyResponse.data)) {
                dailyResponse.data.forEach(record => {
                    attendanceMap[record.date] = record;
                });
            } else if (dailyResponse.data && Array.isArray(dailyResponse.data.attendance_data)) {
                dailyResponse.data.attendance_data.forEach(record => {
                    attendanceMap[record.date] = record;
                });
            }

            // Generate all days for the month
            const fullMonthData = [];
            for (let d = 1; d <= lastDay; d++) {
                const dayStr = d.toString().padStart(2, '0');
                const dateStr = `${year}-${month}-${dayStr}`;
                const dateObj = new Date(dateStr);
                const dayName = dateObj.toLocaleDateString('en-US', { weekday: 'long' }); // e.g., 'Monday'

                if (attendanceMap[dateStr]) {
                    fullMonthData.push(attendanceMap[dateStr]);
                } else {
                    // Create a placeholder for missing days
                    fullMonthData.push({
                        date: dateStr,
                        Day: dayName,
                        Status: 'Not Logged',
                        InTime: '-',
                        OutTime: '-',
                        id: null // No record ID
                    });
                }
            }

            setDailyData(fullMonthData);
        } catch (error) {
            console.error("Error fetching daily attendance:", error);
            setDailyData([]);
        } finally {
            setLoading(false);
        }
    };

    const handleEditClick = (record) => {
        setEditingDay({
            date: record.date,
            currentStatus: record.Status,
            recordId: record.id
        });
        setNewStatus(record.Status !== 'Not Logged' ? record.Status : 'present');
        setReason('');
    };

    const handleSubmitCorrection = async () => {
        if (!newStatus || !reason) {
            toast.warning("Please provide New Status and Reason.");
            return;
        }

        setSubmitting(true);
        try {
            // Get Requester ID from session
            let requesterId = null;
            try {
                const sessionUser = sessionStorage.getItem('dasid');
                if (sessionUser) requesterId = JSON.parse(sessionUser);
            } catch (e) {
                console.warn("Could not parse requester ID from session");
            }

            const payload = {
                requested_status: newStatus,
                reason: reason,
                // Only send record_id if it exists
                attendance_record_id: editingDay.recordId,
                // Creating new record logic on backend uses these:
                attendance_date: editingDay.date,
                target_employee_id: employeeId,
                employee_id: requesterId // The person making the request
            };

            await axios.post(`${port}/root/lms/attendance/correction/`, payload);
            toast.success("Correction Request Submitted Successfully!");
            setEditingDay(null);
            fetchAttendance();
        } catch (error) {
            console.error("Error submitting correction:", error);
            toast.error("Failed to submit request.");
        } finally {
            setSubmitting(false);
        }
    };

    const STATUS_OPTIONS = [
        { value: "present", label: "Present" },
        { value: "absent", label: "Absent" },
        { value: "half_day", label: "Half Day" },
        { value: "week_off", label: "Week Off" },
        { value: "public_leave", label: "Public Leave" },
        { value: "restricted_leave", label: "Restricted Leave" }
    ];

    if (!employeeId) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 poppins">
            <div className="bg-white rounded-lg shadow-lg w-10/12 max-w-4xl max-h-[90vh] overflow-hidden flex flex-col">
                {/* Header */}
                <div className="flex justify-between items-center p-4 border-b">
                    <h2 className="text-xl font-bold">Attendance Correction: {employeeName} ({month}/{year})</h2>
                    <button
                        onClick={onClose}
                        className='text-2xl hover:text-red-500 font-bold'
                    >
                        &times;
                    </button>
                </div>

                {/* Content */}
                {/* Original version (Unoptimized layout / No sticky header):
                <div className="flex-1 overflow-auto p-4">
                    <div className="overflow-x-auto">
                        <table className="min-w-full bg-white border">
                            <thead>
                                <tr className="bg-gray-100 border-b">
                                    <th className="py-2 px-4 text-left">Date</th>
                                    <th className="py-2 px-4 text-left">Day</th>
                                    <th className="py-2 px-4 text-left">Current Status</th>
                                    <th className="py-2 px-4 text-left">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                {dailyData.map((record, index) => (
                                    <tr key={index} className="border-b hover:bg-gray-50">
                                        <td className="py-2 px-4">{record.date}</td>
                                        <td className="py-2 px-4">{record.Day}</td>
                                        <td className="py-2 px-4">
                                            <span className="px-2 py-1 rounded text-xs text-white bg-blue-500">
                                                {record.Status}
                                            </span>
                                        </td>
                                        <td className="py-2 px-4">
                                            <button className="bg-blue-600 text-white px-3 py-1 rounded text-sm">Edit</button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
                */}

                {/* Refined Content with Sticky Header and Center Alignment */}
                <div className="flex-1 overflow-auto p-4 pt-0">
                    {loading ? (
                        <div className="py-10"><LoadingData /></div>
                    ) : (
                        <table className="min-w-full bg-white border-separate border-spacing-0">
                            <thead>
                                <tr>
                                    <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t border-l first:rounded-tl-lg font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">Date</th>
                                    <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">Day</th>
                                    {/* <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">In Time</th> */}
                                    {/* <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">Out Time</th> */}
                                    <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">Current Status</th>
                                    <th className="py-3 px-4 text-center sticky top-0 bg-gray-100 z-10 border-b border-t border-r last:rounded-tr-lg font-semibold whitespace-nowrap shadow-[0_1px_0_0_rgba(0,0,0,0.1)]">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                {dailyData.map((record, index) => (
                                    <tr key={index} className="hover:bg-gray-50 transition-colors">
                                        <td className="py-3 px-4 text-center border-b border-l whitespace-nowrap">{record.date}</td>
                                        <td className="py-3 px-4 text-center border-b whitespace-nowrap">{record.Day}</td>
                                        {/* <td className="py-3 px-4 text-center border-b whitespace-nowrap">{record.InTime || '-'}</td> */}
                                        {/* <td className="py-3 px-4 text-center border-b whitespace-nowrap">{record.OutTime || '-'}</td> */}
                                        <td className="py-3 px-4 text-center border-b">
                                            <span className={`inline-block px-3 py-1 text-xs font-medium
                                                ${(() => {
                                                    const latest = latestRequests[record.date];
                                                    if (latest && latest.request_status === 'Pending') return 'text-orange-500';
                                                    if (latest && latest.request_status === 'Rejected') return 'text-red-500 font-bold';

                                                    const s = record.Status?.toLowerCase().replace(/[\s_]/g, '') || '';
                                                    if (s === 'present') return 'text-green-500';
                                                    if (s === 'absent') return 'text-red-500';
                                                    if (s === 'halfday') return 'text-yellow-500';
                                                    if (s === 'weekoff') return 'text-orange-400';
                                                    if (record.Status === 'Not Logged') return 'text-gray-400';
                                                    return 'text-blue-500';
                                                })()}`}>
                                                {(() => {
                                                    const latest = latestRequests[record.date];
                                                    if (latest) {
                                                        if (latest.request_status === 'Pending') {
                                                            return `Pending (${latest.requested_status.replace('_', ' ')})`;
                                                        }
                                                        if (latest.request_status === 'Rejected') {
                                                            return 'Rejected';
                                                        }
                                                    }
                                                    return record.Status?.replace('_', ' ') || 'Unknown';
                                                })()}
                                            </span>
                                        </td>
                                        <td className="py-3 px-4 text-center border-b border-r">
                                            {latestRequests[record.date]?.request_status === 'Pending' ? (
                                                <span className="text-xs text-gray-400 italic font-medium">Under Review</span>
                                            ) : (
                                                <button
                                                    onClick={() => handleEditClick(record)}
                                                    className="bg-blue-600 text-white px-4 py-1.5 rounded-md text-sm font-medium hover:bg-blue-700 active:scale-95 transition-all shadow-sm"
                                                >
                                                    {latestRequests[record.date]?.request_status === 'Rejected' ? 'Retry' : 'Edit'}
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    )}
                </div>

                {/* Correction Form Modal (Nested) */}
                {editingDay && (
                    <>
                        {/* Original version (Z-index issue):
                        <div className="absolute inset-0 z-60 bg-black bg-opacity-20 flex items-center justify-center">
                        */}
                        <div className="absolute inset-0 z-40 bg-black bg-opacity-40 flex items-center justify-center rounded-lg">
                            <div className="bg-white p-6 rounded-lg shadow-2xl w-96 border border-gray-200">
                                <h3 className="font-bold text-lg mb-4">Edit Attendance for {editingDay.date}</h3>

                                <div className="mb-4">
                                    <label className="block text-sm font-medium mb-1">New Status</label>
                                    <select
                                        value={newStatus}
                                        onChange={(e) => setNewStatus(e.target.value)}
                                        className="w-full border p-2 rounded"
                                    >
                                        <option value="">Select Status</option>
                                        {STATUS_OPTIONS.map(opt => (
                                            <option key={opt.value} value={opt.value}>{opt.label}</option>
                                        ))}
                                    </select>
                                </div>

                                <div className="mb-4">
                                    <label className="block text-sm font-medium mb-1">Reason</label>
                                    <textarea
                                        value={reason}
                                        onChange={(e) => setReason(e.target.value)}
                                        className="w-full border p-2 rounded"
                                        rows="3"
                                    ></textarea>
                                </div>

                                <div className="flex justify-end gap-2">
                                    <button
                                        onClick={() => setEditingDay(null)}
                                        className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400"
                                    >
                                        Cancel
                                    </button>
                                    <button
                                        onClick={handleSubmitCorrection}
                                        disabled={submitting}
                                        className="bg-orange-500 text-white px-4 py-2 rounded hover:bg-orange-600"
                                    >
                                        {submitting ? 'Submitting...' : 'Submit Request'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </>
                )}
            </div>
        </div>
    );
};

export default AttendanceCorrectionModal;
