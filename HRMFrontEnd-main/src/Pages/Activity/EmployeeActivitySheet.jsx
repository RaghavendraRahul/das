//changes2
import React, { useContext, useEffect, useState, useRef } from 'react';
import { HrmStore } from '../../Context/HrmContext';
import Topnav from '../../Components/Topnav';
import ActivityUploadModal from '../../Components/Modals/ActivityUploadModal';
import ActivityDataTable from '../../Components/ActivityComponents/ActivityDataTable';
import axios from 'axios';
import { port } from '../../App';
import { useNavigate, useParams } from 'react-router-dom';
import BackButton from '../../Components/MiniComponent/BackButton';
import EmpNameCom from '../../Components/MiniComponent/EmpNameCom';
import { toast } from 'react-toastify';
import { Dropdown } from 'react-bootstrap';
import ActivityDashboard from './ActivityDashboard';
import InterviewActivityDashboard from '../../Components/ActivityComponents/InterviewActivityDashboard';
import InterviewDataSection from '../../Components/ActivityComponents/InterviewDataSection';
import QRCodeModal from '../../Components/Modals/QRCodeModal';
import { QrCode } from 'lucide-react';


const generateDates = (month, year) => {
    const dates = [];
    const date = new Date(year, month, 1);

    while (date.getMonth() === month) {
        const day = String(date.getDate()).padStart(2, '0');
        const monthFormatted = String(date.getMonth() + 1).padStart(2, '0');
        const yearFormatted = date.getFullYear();
        const formattedDate = `${yearFormatted}-${monthFormatted}-${day}`;
        dates.push(formattedDate);
        date.setDate(date.getDate() + 1);
    }
    return dates;
};


const EmployeeActivitySheet = ({ subpage }) => {
    let { empid } = useParams();
    let { setActivePage, setTopNav } = useContext(HrmStore);

    const loggedIn = JSON.parse(sessionStorage.getItem('user'));
    const targetEmpId = empid || loggedIn?.EmployeeId;

    const currentDate = new Date();
    const [dates, setDates] = useState(generateDates(currentDate.getMonth(), currentDate.getFullYear()));
    const [month, setMonth] = useState(currentDate.getMonth());
    const [year, setYear] = useState(currentDate.getFullYear());

    const [showActivityModal, setShowActivityModal] = useState(false);
    const [isUploading, setIsUploading] = useState(false);
    const [uploadTrigger, setUploadTrigger] = useState(false);
    const [uploadActivityId, setUploadActivityId] = useState(null);
    const [showQRModal, setShowQRModal] = useState(false);

    const uploadRef = useRef(null);
    const navigate = useNavigate();

    useEffect(() => {
        setActivePage('activity');
        if (!empid) setTopNav('personal');
        else setTopNav('myteam');
    }, [empid]);


    const handle_Month_Change = (e) => {
        const selectedYear = parseInt(e.slice(0, 4));
        const selectedMonth = parseInt(e.slice(5, 7)) - 1;
        setYear(selectedYear);
        setMonth(selectedMonth);

        const newDates = generateDates(selectedMonth, selectedYear);
        setDates(newDates);
    };


    const handleDownloadTemplate = (activityId) => {
        const url = `${port}/root/download-activity-template?activity_list_id=${activityId}`;
        window.location.href = url;
    };


    const triggerUpload = (activityId) => {
        setUploadActivityId(activityId);
        uploadRef.current.click();
    };


    const handleBulkUpload = async (event) => {
        const file = event.target.files[0];
        if (!file || !uploadActivityId) return;

        setIsUploading(true);

        const uploaderId = empid ? empid : loggedIn?.EmployeeId;

        const formData = new FormData();
        formData.append('file', file);

        try {
            const response = await axios.post(
                `${port}/root/bulk-activity-upload?activity_list_id=${uploadActivityId}&login_emp_id=${uploaderId}`,
                formData,
                { headers: { 'Content-Type': 'multipart/form-data' } }
            );

            toast.success(response.data.message || "File uploaded successfully!");
            setUploadTrigger(prev => !prev);

        } catch (error) {
            toast.error(`Upload Failed: ${error.response?.data?.error || 'Unknown error'}`);
        } finally {
            setIsUploading(false);
            event.target.value = null;
        }
    };


    return (
        <div>
            {!subpage && <Topnav name={`Activity Sheet`} />}

            <main className='p-2 poppins'>
                <div className='flex my-2 items-center flex-wrap gap-2'>

                    {empid && <BackButton />}

                    <div className='ms-auto flex items-center gap-2 flex-wrap'>

                        <button
                            onClick={() => setShowQRModal(true)}
                            className='btn btn-info rounded p-1.5'
                        >
                            <QrCode  />
                        </button>
                        
                        <input
                            type="file"
                            ref={uploadRef}
                            onChange={handleBulkUpload}
                            style={{ display: 'none' }}
                            accept=".csv, .xlsx"
                        />

                        <Dropdown>
                            <Dropdown.Toggle variant="success" className='greenbtn'>
                                Download Template
                            </Dropdown.Toggle>
                            <Dropdown.Menu>
                                <Dropdown.Item onClick={() => handleDownloadTemplate(1)}>Interview Calls</Dropdown.Item>
                                <Dropdown.Item onClick={() => handleDownloadTemplate(3)}>Client Calls</Dropdown.Item>
                            </Dropdown.Menu>
                        </Dropdown>

                        <Dropdown>
                            <Dropdown.Toggle variant="secondary" className='greybtn' disabled={isUploading}>
                                {isUploading ? 'Uploading...' : 'Bulk Upload'}
                            </Dropdown.Toggle>
                            <Dropdown.Menu>
                                <Dropdown.Item onClick={() => triggerUpload(1)}>Upload Interviews</Dropdown.Item>
                                <Dropdown.Item onClick={() => triggerUpload(3)}>Upload Client Calls</Dropdown.Item>
                            </Dropdown.Menu>
                        </Dropdown>


                        {(!empid || empid === loggedIn?.EmployeeId) && (
                            <button
                                onClick={() => setShowActivityModal(true)}
                                className='bluebtn rounded p-2'
                            >
                                Add activity
                            </button>
                        )}
                    </div>
                </div>

                <ActivityDashboard targetEmpId={empid} />

                <ActivityUploadModal
                    empid={empid}
                    show={showActivityModal}
                    setshow={setShowActivityModal}
                />

                {empid && <EmpNameCom empid={empid} />}

                <div className="my-3">
                    <input
                        type="month"
                        className='p-2 bgclr rounded outline-none'
                        value={`${year}-${String(month + 1).padStart(2, '0')}`}
                        onChange={(e) => handle_Month_Change(e.target.value)}
                    />
                </div>

                <ActivityDataTable
                    empid={targetEmpId}
                    dates={dates}
                    month={month}
                    year={year}
                    getTrigger={uploadTrigger}
                />

                {empid && (
                    <InterviewActivityDashboard
                        empid={empid}
                        month={month}
                        year={year}
                    />
                )}
                <InterviewDataSection
                    getTrigger={uploadTrigger}
                    empid={empid ? empid : JSON.parse(sessionStorage.getItem('dasid'))}
                    dates={dates} month={month} year={year}
                />

                <QRCodeModal
                    show={showQRModal}
                    onHide={() => setShowQRModal(false)}
                    empid={targetEmpId}
                />
            </main>
        </div>
    );
};

export default EmployeeActivitySheet;
