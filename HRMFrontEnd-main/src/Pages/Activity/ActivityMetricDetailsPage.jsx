import React, { useState, useEffect, useCallback } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import axios from 'axios';
import { port } from '../../App';
import { toast } from 'react-toastify';
import DashboardFilter from '../../Components/ActivityComponents/DashboardFilter';
import BackButton from '../../Components/MiniComponent/BackButton';
import ActivityUploadModal from '../../Components/Modals/ActivityUploadModal';

const Loader = ({ height = '200px' }) => (
    <div className="flex justify-center items-center w-full" style={{ height }}>
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-blue-500"></div>
    </div>
);

const ActivityMetricDetailsPage = () => {
    const { metricType } = useParams();
    const navigate = useNavigate();
    const [searchParams, setSearchParams] = useSearchParams();
    const empid = JSON.parse(sessionStorage.getItem('user'))?.EmployeeId;

    // Initialize states from URL search parameters
    const [filterType, setFilterType] = useState(searchParams.get('filter_type') || 'this_month');
    const [customStartDate, setCustomStartDate] = useState(searchParams.get('start_date') || '');
    const [customEndDate, setCustomEndDate] = useState(searchParams.get('end_date') || '');
    const [targetEmpId, setTargetEmpId] = useState(searchParams.get('target_emp_id') || '');
    const [search, setSearch] = useState(searchParams.get('search') || '');

    const [data, setData] = useState([]);
    const [pagination, setPagination] = useState({
        count: 0,
        next: null,
        previous: null,
        currentPage: parseInt(searchParams.get('page')) || 1
    });
    const [isLoading, setIsLoading] = useState(true);
    const [debouncedSearch, setDebouncedSearch] = useState(search);

    // Action Modal States
    const [showActionForm, setShowActionForm] = useState(false);
    const [selectedItem, setSelectedItem] = useState(null);
    const [actionType, setActionType] = useState(''); // 'followup', 'reject', 'close', 'call_again', 'complete'
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [editModalAid, setEditModalAid] = useState(null);

    // Action Form Fields
    const [expectedDate, setExpectedDate] = useState('');
    const [expectedTime, setExpectedTime] = useState('');
    const [notes, setNotes] = useState('');
    const [rejectionType, setRejectionType] = useState('emp_rejected');

    const getTitle = () => {
        const titles = {
            'total-activities': 'Total Activities',
            'successful-outcomes': 'Successful Outcomes',
            'rejected': 'Rejected Leads',
            'closed': 'Closed Leads',
            'pending-followups': 'Pending Follow Ups',
            'completed-followups': 'Follow Ups Done',
            'interview-calls': 'Interview Calls',
            'client-calls': 'Client Calls',
            'job-posts': 'Job Posts'
        };
        return titles[metricType] || 'Activity Details';
    };

    const getEndpoint = () => {
        // Ensure port doesn't have trailing slash when concatenating with /root
        const basePort = port.endsWith('/') ? port.slice(0, -1) : port;
        return `${basePort}/root/activity/${metricType}`;
    };

    // URL Synchronization effect
    useEffect(() => {
        const params = new URLSearchParams();
        if (filterType !== 'this_month') params.set('filter_type', filterType);
        if (filterType === 'custom') {
            if (customStartDate) params.set('start_date', customStartDate);
            if (customEndDate) params.set('end_date', customEndDate);
        }
        if (targetEmpId) params.set('target_emp_id', targetEmpId);
        if (debouncedSearch) params.set('search', debouncedSearch);
        if (pagination.currentPage > 1) params.set('page', pagination.currentPage);

        setSearchParams(params, { replace: true });
    }, [filterType, customStartDate, customEndDate, targetEmpId, debouncedSearch, pagination.currentPage, setSearchParams]);

    // Debounce search effect
    useEffect(() => {
        // Only run if search actually differs (prevents reset on mount)
        if (search === debouncedSearch) return;

        const timer = setTimeout(() => {
            setDebouncedSearch(search);
            setPagination(prev => ({ ...prev, currentPage: 1 }));
        }, 500);

        return () => clearTimeout(timer);
    }, [search, debouncedSearch]);

    const fetchData = useCallback(async (page = 1) => {
        if (!empid) return;
        setIsLoading(true);

        try {
            const params = new URLSearchParams({
                login_emp_id: empid,
                filter_type: filterType,
                page: page,
                search: debouncedSearch
            });

            if (targetEmpId) params.append('target_emp_id', targetEmpId);
            if (filterType === 'custom' && customStartDate && customEndDate) {
                params.append('start_date', customStartDate);
                params.append('end_date', customEndDate);
            }

            const response = await axios.get(`${getEndpoint()}?${params.toString()}`);

            // Handle different response structures for Follow-ups vs others
            if (metricType === 'pending-followups') {
                setData(response.data.pending_followups || []);
            } else if (metricType === 'completed-followups') {
                setData(response.data.completed_followups || []);
            } else {
                setData(response.data.results || response.data);
            }

            setPagination({
                count: response.data.count || 0,
                next: response.data.next,
                previous: response.data.previous,
                currentPage: page
            });
        } catch (error) {
            console.error("Error fetching metric details:", error);
            toast.error("Failed to load data");
        } finally {
            setIsLoading(false);
        }
    }, [empid, metricType, filterType, debouncedSearch, customStartDate, customEndDate, targetEmpId]);

    const isFirstRender = React.useRef(true);

    useEffect(() => {
        if (isFirstRender.current) {
            isFirstRender.current = false;
            fetchData(pagination.currentPage);
        } else {
            fetchData(1);
        }
    }, [fetchData]);

    const handleSearchChange = (e) => {
        setSearch(e.target.value);
    };

    const handlePageChange = (newPage) => {
        if (newPage >= 1) {
            fetchData(newPage);
            window.scrollTo(0, 0);
        }
    };

    // Action Handlers
    const openActionForm = (item, type) => {
        setSelectedItem(item);
        setActionType(type);
        setShowActionForm(true);
        // Reset fields
        setExpectedDate('');
        setExpectedTime('');
        setNotes('');
        setRejectionType('emp_rejected');
    };

    const handleSubmitAction = async () => {
        const isFollowUpAction = metricType.includes('followup');
        const id = isFollowUpAction ? selectedItem.id : selectedItem.id;

        setIsSubmitting(true);
        try {
            if (actionType === 'followup') {
                await axios.post(`${port}/root/activity/convert-to-followup`, {
                    activity_record_id: selectedItem.id,
                    expected_date: expectedDate,
                    expected_time: expectedTime,
                    notes: notes,
                    login_emp_id: empid
                });
                toast.success('Converted to follow-up!');
            } else if (['complete', 'call_again', 'reject', 'close'].includes(actionType)) {
                // If it's a direct action from a non-followup list, we might need the two-step process
                // But if the list is already followups, we hit the action endpoint directly

                let endpoint;
                let method = 'patch';
                let payload = { action: actionType === 'reject' ? 'rejected' : actionType === 'close' ? 'closed' : actionType };

                if (!isFollowUpAction && (actionType === 'reject' || actionType === 'close')) {
                    // Two-step for direct reject/close from main list
                    const followUpResponse = await axios.post(`${port}/root/activity/convert-to-followup`, {
                        activity_record_id: selectedItem.id,
                        expected_date: new Date().toISOString().split('T')[0],
                        expected_time: new Date().toTimeString().split(' ')[0].substring(0, 5),
                        notes: notes,
                        login_emp_id: empid
                    });
                    endpoint = `${port}/root/activity/followup/${followUpResponse.data.follow_up.id}/action`;
                    payload.reason = notes;
                    payload.rejection_type = rejectionType;
                } else {
                    endpoint = `${port}/root/activity/followup/${selectedItem.id}/action`;
                    if (actionType === 'call_again') {
                        payload.expected_date = expectedDate;
                        payload.expected_time = expectedTime;
                        payload.notes = notes;
                    } else {
                        payload.reason = notes;
                        payload.rejection_type = rejectionType;
                    }
                }

                await axios({ method, url: endpoint, data: payload });
                toast.success(`Action ${actionType} successful!`);
            }

            setShowActionForm(false);
            fetchData(pagination.currentPage);
        } catch (error) {
            console.error("Action error:", error);
            toast.error(error.response?.data?.error || "Action failed");
        } finally {
            setIsSubmitting(false);
        }
    };

    const formatTimeTo12Hour = (time24) => {
        if (!time24) return '-';
        const [hours, minutes] = time24.split(':');
        const hour = parseInt(hours, 10);
        const ampm = hour >= 12 ? 'PM' : 'AM';
        const hour12 = hour % 12 || 12;
        return `${hour12}:${minutes} ${ampm}`;
    };

    return (
        <div className="container-fluid p-3 p-md-4 poppins">
            <div className="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
                <BackButton />
                <h2 className="text-xl md:text-2xl font-bold text-gray-800 m-0 text-center flex-grow-1">{getTitle()}</h2>
                <div className="hidden sm:block w-24"></div> {/* Spacer for symmetry on desktop */}
            </div>

            <div className="bg-white rounded-lg shadow-md p-3 p-md-4 mb-4">
                <div className="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-4">
                    <div className="d-flex flex-column flex-sm-row align-items-sm-center gap-3 flex-grow-1">
                        <h4 className="fw-bold mb-0 whitespace-nowrap text-lg">Activity Dashboard</h4>
                        <div className="d-flex flex-wrap align-items-center gap-2">
                            <select
                                className="form-select w-auto"
                                value={filterType}
                                onChange={(e) => setFilterType(e.target.value)}
                            >
                                <option value="today">Today</option>
                                <option value="this_month">This Month</option>
                                <option value="prev_month">Previous Month</option>
                                <option value="custom">Custom Date Range</option>
                            </select>
                            {filterType === 'custom' && (
                                <div className="d-flex gap-2 w-100 w-sm-auto mt-2 mt-sm-0">
                                    <input
                                        type="date"
                                        className="form-control form-control-sm"
                                        value={customStartDate}
                                        onChange={(e) => setCustomStartDate(e.target.value)}
                                    />
                                    <input
                                        type="date"
                                        className="form-control form-control-sm"
                                        value={customEndDate}
                                        onChange={(e) => setCustomEndDate(e.target.value)}
                                    />
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="w-100 lg:w-auto ms-lg-auto" style={{ maxWidth: '400px' }}>
                        <div className="input-group">
                            <span className="input-group-text bg-white border-end-0">
                                <i className="fas fa-search text-gray-400"></i>
                            </span>
                            <input
                                type="text"
                                className="form-control form-control-sm text-xs border-start-0 border-end-0 ps-0 focus:ring-0 focus:border-0"
                                placeholder="Search..."
                                value={search}
                                onChange={handleSearchChange}
                            />
                            <span className="input-group-text bg-white border-start-0" title="Search by name, phone, Role or Company">
                                <i className="fas fa-info-circle text-gray-400"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div className={`tablebg h-[calc(100vh-280px)] min-h-[400px] flex flex-col rounded-xl my-3 mt-3 p-0 mx-0 shadow-md bg-white border`}>
                {isLoading ? (
                    <Loader height="400px" />
                ) : (
                    <>
                        <div className="flex-grow overflow-auto w-full">
                            <div className="inline-block min-w-full align-middle">
                                <table className="min-w-full whitespace-nowrap table-auto">
                                    <thead className="sticky top-0 z-10 bg-white shadow-sm">
                                        <tr className="text-left">
                                            <th className="p-3 min-w-[100px]">Type</th>
                                            {metricType === 'client-calls' ? (
                                                <>
                                                    <th className="p-3 min-w-[200px]">Company Name</th>
                                                    <th className="p-3 min-w-[150px]">Name</th>
                                                    <th className="p-3 min-w-[150px]">Contact Person</th>
                                                    <th className="p-3 min-w-[200px]">Email</th>
                                                    <th className="p-3 min-w-[120px]">Phone</th>
                                                    <th className="p-3 min-w-[150px]">Status</th>
                                                    <th className="p-3 min-w-[250px]">Purpose</th>
                                                    <th className="p-3 min-w-[250px]">Notes</th>
                                                </>
                                            ) : metricType === 'interview-calls' ? (
                                                <>
                                                    <th className="p-3 min-w-[200px]">Candidate Name</th>
                                                    {/* <th>Applied Role</th> */}
                                                    <th className="p-3 min-w-[200px]">Designation</th>
                                                    <th className="p-3 min-w-[150px]">Experience</th>
                                                    <th className="p-3 min-w-[150px]">Contact</th>
                                                    <th className="p-3 min-w-[250px]">Notes</th>
                                                </>
                                            ) : (
                                                <>
                                                    <th className="p-3 min-w-[200px]">Name</th>
                                                    <th className="p-3 min-w-[150px]">Contact</th>
                                                    {metricType.includes('followup') ? (
                                                        <>
                                                            <th className="p-3 min-w-[150px]">Expected Date</th>
                                                            <th className="p-3 min-w-[120px]">Time</th>
                                                        </>
                                                    ) : (
                                                        <>
                                                            <th className="p-3 min-w-[200px]">Role / Purpose</th>
                                                            <th className="p-3 min-w-[200px]">Outcome / Status</th>
                                                        </>
                                                    )}
                                                    <th className="p-3 min-w-[250px]">Notes</th>
                                                </>
                                            )}
                                            <th className="p-3 min-w-[100px]">Lead Status</th>
                                            <th className="p-3 min-w-[100px]">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {data.length === 0 ? (
                                            <tr>
                                                <td colSpan="10" className="p-5 text-gray-500 text-center">No records found.</td>
                                            </tr>
                                        ) : (
                                            data.map(item => (
                                                <tr key={item.id} className="border-b hover:bg-gray-50">
                                                    <td className="p-3">
                                                        <span className={`badge ${(item.candidate_name || item.follow_up_type === 'interview') ? 'bg-cyan-500' :
                                                            (item.client_name || item.follow_up_type === 'client') ? 'bg-green-500' : 'bg-cyan-500'
                                                            }`}>
                                                            {item.candidate_name || item.follow_up_type === 'interview' ? 'Interview' :
                                                                item.client_name || item.follow_up_type === 'client' ? 'Client' : 'Job Post'}
                                                        </span>
                                                    </td>

                                                    {metricType === 'client-calls' ? (
                                                        <>
                                                            <td className="p-3">{item.client_company_name || '-'}</td>
                                                            <td className="p-3">
                                                                <span
                                                                    className="text-blue-600 hover:text-blue-800 hover:underline cursor-pointer"
                                                                    onClick={() => navigate(`/activity/lead-log/${item.id}`)}
                                                                >
                                                                    {item.client_name || '-'}
                                                                </span>
                                                            </td>
                                                            <td className="p-3">{item.client_spok || '-'}</td>
                                                            <td className="p-3">{item.client_email || '-'}</td>
                                                            <td className="p-3 text-nowrap">{item.client_phone || '-'}</td>
                                                            <td className="p-3 text-nowrap">{item.client_status || '-'}</td>
                                                            <td className="p-3">{item.client_enquire_purpose || '-'}</td>
                                                            <td className="p-3">{item.client_call_remarks || item.notes || '-'}</td>
                                                        </>
                                                    ) : metricType === 'interview-calls' ? (
                                                        <>
                                                            <td className="p-3">
                                                                <span
                                                                    className="text-blue-600 hover:text-blue-800 hover:underline cursor-pointer"
                                                                    onClick={() => navigate(`/activity/lead-log/${item.id}`)}
                                                                >
                                                                    {item.candidate_name || '-'}
                                                                </span>
                                                            </td>
                                                            <td className="p-3">{item.candidate_designation || '-'}</td>
                                                            <td className="p-3">{item.candidate_experience ? `${item.candidate_experience} Yrs` : 'Fresher'}</td>
                                                            <td className="p-3">{item.candidate_phone || '-'}</td>
                                                            <td className="p-3">{item.interview_call_remarks || item.notes || '-'}</td>
                                                        </>
                                                    ) : (
                                                        <>
                                                            <td className="p-3">
                                                                <span
                                                                    className="text-blue-600 hover:text-blue-800 hover:underline cursor-pointer"
                                                                    onClick={() => {
                                                                        const targetId = metricType.includes('followup') ? item.activity_record : item.id;
                                                                        navigate(`/activity/lead-log/${targetId}`);
                                                                    }}
                                                                >
                                                                    {item.candidate_name || item.client_name || item.candidate_or_client_name || item.position}
                                                                </span>
                                                            </td>
                                                            <td className="p-3">{item.candidate_phone || item.client_phone || item.candidate_or_client_phone || '-'}</td>

                                                            {metricType.includes('followup') ? (
                                                                <>
                                                                    <td className="p-3">{item.expected_date}</td>
                                                                    <td className="p-3">{formatTimeTo12Hour(item.expected_time)}</td>
                                                                </>
                                                            ) : (
                                                                <>
                                                                    <td className="p-3">{item.candidate_designation || item.client_enquire_purpose || '-'}</td>
                                                                    <td className="p-3">
                                                                        {item.interview_status ? (
                                                                            <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-sm capitalize">
                                                                                {item.interview_status.replace(/_/g, ' ')}
                                                                            </span>
                                                                        ) : item.client_status ? (
                                                                            <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-sm capitalize">
                                                                                {item.client_status.replace(/_/g, ' ')}
                                                                            </span>
                                                                        ) : (
                                                                            item.job_post_remarks || '-'
                                                                        )}
                                                                    </td>
                                                                </>
                                                            )}
                                                            <td className="p-3">{item.closure_reason || item.notes || item.job_post_remarks || item.client_call_remarks || item.interview_call_remarks || '-'}</td>
                                                        </>
                                                    )}
                                                    <td className="p-3">
                                                        {(() => {
                                                            const status = item.lead_status || item.activity_lead_status;
                                                            if (status === 'follow_up') return <span className="badge bg-purple-500 text-white">Follow-Up</span>;
                                                            if (status === 'rejected') return <span className="badge bg-red-500 text-white">Rejected</span>;
                                                            if (status === 'closed') return <span className="badge bg-gray-500 text-white">Closed</span>;
                                                            return <span className="badge bg-green-500 text-white">Active</span>;
                                                        })()}
                                                    </td>
                                                    <td className="p-3">
                                                        {metricType === 'completed-followups' ? (
                                                            <span className="text-muted text-sm">Completed</span>
                                                        ) : (item.lead_status || item.activity_lead_status) &&
                                                            (item.lead_status || item.activity_lead_status) !== 'active' &&
                                                            (item.lead_status || item.activity_lead_status) !== 'follow_up' &&
                                                            metricType !== 'pending-followups' ? (
                                                            <span className="text-muted text-sm capitalize">{item.lead_status || item.activity_lead_status}</span>
                                                        ) : (
                                                            <select
                                                                className="form-select form-select-sm"
                                                                onChange={(e) => {
                                                                    if (e.target.value === 'edit') {
                                                                        setEditModalAid(item.id);
                                                                        e.target.value = '';
                                                                    } else if (e.target.value) {
                                                                        openActionForm(item, e.target.value);
                                                                        e.target.value = '';
                                                                    }
                                                                }}
                                                            >
                                                                <option value="">Action</option>
                                                                <option value="edit">Edit</option>
                                                                {metricType === 'pending-followups' ? (
                                                                    <>
                                                                        <option value="complete">Done</option>
                                                                        <option value="call_again">Call Again</option>
                                                                    </>
                                                                ) : (
                                                                    <option value="followup">Follow Up</option>
                                                                )}
                                                                <option value="reject">Reject</option>
                                                                <option value="close">Close</option>
                                                            </select>
                                                        )}
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        {/* Pagination Controls */}
                        {pagination.count > 0 && (
                            <div className="flex justify-between items-center p-4 bg-white border-t rounded-b-xl">
                                {/* Left: Total */}
                                <div className="text-gray-700 font-medium whitespace-nowrap">
                                    Total : <span className="font-bold">{pagination.count}</span>
                                </div>

                                {/* Center: Navigation */}
                                <div className="flex items-center gap-2">
                                    <button
                                        className={`px-3 py-1.5 rounded text-white font-medium text-sm transition-all ${!pagination.previous ? 'bg-blue-300 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700 active:scale-95'}`}
                                        onClick={() => handlePageChange(pagination.currentPage - 1)}
                                        disabled={!pagination.previous}
                                    >
                                        Previous
                                    </button>

                                    <span className="bg-blue-600 text-white px-3 py-1.5 rounded text-sm font-medium whitespace-nowrap">
                                        {pagination.currentPage} of {Math.ceil(pagination.count / 10) || 1}
                                    </span>

                                    <button
                                        className={`px-3 py-1.5 rounded text-white font-medium text-sm transition-all ${!pagination.next ? 'bg-blue-300 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700 active:scale-95'}`}
                                        onClick={() => handlePageChange(pagination.currentPage + 1)}
                                        disabled={!pagination.next}
                                    >
                                        Next
                                    </button>
                                </div>

                                {/* Right: Go to Page */}
                                <div className="flex items-center gap-2">
                                    <span className="text-gray-600 text-sm whitespace-nowrap">Page</span>
                                    <input
                                        type="number"
                                        className="w-16 border rounded px-2 py-1 text-center text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                        placeholder={pagination.currentPage}
                                        onKeyDown={(e) => {
                                            if (e.key === 'Enter') {
                                                const page = parseInt(e.currentTarget.value);
                                                if (page > 0 && page <= Math.ceil(pagination.count / 10)) {
                                                    handlePageChange(page);
                                                    e.currentTarget.value = ''; // Clear after jump or keep? Usually clear or sync.
                                                }
                                            }
                                        }}
                                    />
                                </div>
                            </div>
                        )}
                    </>
                )}
            </div>

            {/* Action Form Modal - Reused logic from DetailsModal */}
            {showActionForm && (
                <div className="fixed inset-0 z-[1050] flex items-center justify-center bg-black/50 backdrop-blur-sm">
                    <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4 border">
                        <h3 className="text-lg font-bold mb-4 border-bottom pb-2">
                            {actionType === 'followup' || actionType === 'call_again' ? 'Schedule Follow-Up' :
                                actionType === 'reject' ? 'Reject Lead' :
                                    actionType === 'close' ? 'Close Lead' : 'Confirm Action'}
                        </h3>

                        <div className="mb-4">
                            <p className="text-sm mb-1 uppercase text-gray-500 font-bold">Name</p>
                            <p className="font-medium">{selectedItem?.candidate_name || selectedItem?.client_name || selectedItem?.candidate_or_client_name}</p>
                        </div>

                        <div className="space-y-4">
                            {(actionType === 'followup' || actionType === 'call_again') && (
                                <>
                                    <div className="row">
                                        <div className="col-6">
                                            <label className="form-label font-bold text-sm">Date *</label>
                                            <input type="date" className="form-control" value={expectedDate} onChange={e => setExpectedDate(e.target.value)} />
                                        </div>
                                        <div className="col-6">
                                            <label className="form-label font-bold text-sm">Time *</label>
                                            <input type="time" className="form-control" value={expectedTime} onChange={e => setExpectedTime(e.target.value)} />
                                        </div>
                                    </div>
                                    <div>
                                        <label className="form-label font-bold text-sm">Notes</label>
                                        <textarea className="form-control" rows="3" value={notes} onChange={e => setNotes(e.target.value)} placeholder="Next steps..."></textarea>
                                    </div>
                                </>
                            )}

                            {actionType === 'reject' && (
                                <>
                                    <label className="form-label font-bold text-sm">Rejection Type *</label>
                                    <div className="d-flex gap-4 mb-3">
                                        <label className="flex items-center cursor-pointer">
                                            <input type="radio" value="emp_rejected" checked={rejectionType === 'emp_rejected'} onChange={e => setRejectionType(e.target.value)} className="mr-2" />
                                            Employee
                                        </label>
                                        <label className="flex items-center cursor-pointer">
                                            <input type="radio" value="candidate_rejected" checked={rejectionType === 'candidate_rejected'} onChange={e => setRejectionType(e.target.value)} className="mr-2" />
                                            Candidate
                                        </label>
                                    </div>
                                    <div>
                                        <label className="form-label font-bold text-sm">Reason *</label>
                                        <textarea className="form-control" rows="3" value={notes} onChange={e => setNotes(e.target.value)} placeholder="Why rejected?"></textarea>
                                    </div>
                                </>
                            )}

                            {actionType === 'close' && (
                                <div>
                                    <label className="form-label font-bold text-sm">Closure Reason *</label>
                                    <textarea className="form-control" rows="3" value={notes} onChange={e => setNotes(e.target.value)} placeholder="Why closed?"></textarea>
                                </div>
                            )}

                            {actionType === 'complete' && (
                                <p>Are you sure you want to mark this follow-up as completed?</p>
                            )}
                        </div>

                        <div className="flex gap-3 mt-5">
                            <button
                                onClick={handleSubmitAction}
                                disabled={isSubmitting}
                                className="btn btn-primary flex-grow font-bold py-2"
                            >
                                {isSubmitting ? 'Wait...' : 'Confirm'}
                            </button>
                            <button
                                onClick={() => setShowActionForm(false)}
                                className="btn btn-light border flex-grow py-2"
                            >
                                Cancel
                            </button>
                        </div>
                    </div>
                </div>
            )}
            <ActivityUploadModal
                show={!!editModalAid}
                setshow={() => setEditModalAid(null)}
                aid={editModalAid}
                setAid={setEditModalAid}
                getData={() => fetchData(pagination.currentPage)}
                empid={empid}
            />
        </div>
    );
};

export default ActivityMetricDetailsPage;
