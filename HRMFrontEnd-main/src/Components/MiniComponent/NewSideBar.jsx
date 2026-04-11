import React, { useContext, useState } from 'react'
import DasIcon from '../Icons/DasIcon'
import DashboardIcon from '../Icons/DashboardIcon'
import AppliedListIcon from '../Icons/AppliedListIcon'
import ClientIcon from '../Icons/ClientIcon'
import ActivityIcon from '../Icons/ActivityIcon'
import PayrollIcon from '../Icons/PayrollIcon'
import EmployeeIcon from '../Icons/EmployeeIcon'
import PerformanceIcon from '../Icons/PerformanceIcon'
import LeaveIcon from '../Icons/LeaveIcon'
import HrIcon from '../Icons/HrIcon'
import SettingIcon from '../Icons/SettingIcon'
import { HrmStore } from '../../Context/HrmContext'
import MyTeamIcon from '../Icons/MyTeamIcon'
import NewSideBarButton from './NewSideBarButton'
import { das, port } from '../../App'
import DashBoardIconFill from '../Icons/DashBoardIconFill'
import LeaveIconFill from '../Icons/LeaveIconFill'
import HrIconFill from '../Icons/HrIconFill'
import EmployeeWhiteIcon from '../Icons/EmployeeWhiteIcon'
import { Offcanvas } from 'react-bootstrap'
import BurgerIcon from '../Icons/BurgerIcon'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import QrIcon from '../Icons/QrIcon'
import QrCodeGenerator from '../../Pages/QRscanner/QrCodeGenerator'
import ReportIcon from '../Icons/ReportIcon'
import ReportIconFill from '../Icons/ReportIconFill'

const NewSideBar = () => {
    let { activePage, setActivePage, employeeData, setIsInsideOffice } = useContext(HrmStore)
    let logindata = JSON.parse(sessionStorage.getItem('user'))
    let employeeStatus = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    let Empid = JSON.parse(sessionStorage.getItem('dasid'))
    let [showOff, setShowOff] = useState()
    let showTrainee = employeeData?.Employeement_Type != 'Trainee'
    // Trainee
    // alert(showTrainee)
    let navbarButtons = [
        {
            label: 'DashBoard',
            Icon: DashboardIcon,
            FillIcon: DashBoardIconFill,
            size: '20',
            active: 'dashboard',
            path: `/dashboard/${logindata?.Disgnation}`,
            show: true
        },
        {
            label: 'Client',
            Icon: ClientIcon,
            active: 'client',
            path: `/client`,
            show: (employeeStatus == 'Admin' || employeeStatus == 'HR' || employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Activity',
            Icon: ActivityIcon,
            active: 'activity',
            // path: `/Recruiter_Activity`,
            path: `/activity`,

            show: (employeeStatus == 'Employee' || employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Request',
            Icon: ClientIcon,
            active: 'Employee',
            path: `/Employee_request_form`,
            show: (employeeStatus == 'Employee' || employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Applyied List',
            Icon: AppliedListIcon,
            active: 'applylist',
            path: `/Applaylist`,
            show: (employeeStatus == 'Admin' || employeeStatus == 'HR') && showTrainee
        },
        {
            label: 'Applicants',
            Icon: AppliedListIcon,
            active: 'Applicants',
            path: `/Employee_interview_applicants`,
            show: (employeeStatus == 'Employee') && showTrainee
        },
        {
            label: 'Applicants',
            Icon: HrIcon,
            FillIcon: HrIconFill,
            active: 'Applicants',
            path: `/Applicants`,
            show: (employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Apply List',
            Icon: AppliedListIcon,
            active: 'applylist',
            path: `/Rec_applyed_list`,
            show: (employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'DAS',
            Icon: DasIcon,
            active: 'das',
            onClick: async () => {
                const user = JSON.parse(sessionStorage.getItem('user'));
                if (!user?.Email) {
                    console.error('User email not found');
                    return;
                }
                
                try {
                    const response = await axios.post(`${port}api/generate-das-code/`, {
                        email: user.Email
                    });
                    
                    if (response.data.redirect_url) {
                        window.location.href = response.data.redirect_url;
                    }
                } catch (error) {
                    console.error('Error generating DAS code:', error);
                    const errorMessage = error.response?.data?.error || error.message || 'Failed to connect to DAS';
                    alert(errorMessage + '. Please try again.');
                }
            },
            show: true
        },
        {
            label: 'My team',
            Icon: MyTeamIcon,
            active: 'Reporting_team',
            path: `/Reporting_team`,
            show: (employeeStatus == 'Admin' || employeeStatus == 'HR') && showTrainee
        },
        {
            label: 'Reporting team',
            Icon: MyTeamIcon,
            active: 'team',
            path: `/Report_Manager_Reporting_team`,
            show: (employeeStatus == 'Employee') && showTrainee
        },
        {
            label: 'Reporting team',
            Icon: MyTeamIcon,
            active: 'team',
            path: `/Reporting_team_recuter`,
            show: (employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Activities',
            Icon: AppliedListIcon,
            active: 'activity',
            // path: `/dash/employeeactivity`,
            // path:'/Sample_acti',
            path: '/activity',
            show: employeeStatus == 'Admin' || employeeStatus == 'HR'
        },
        {
            label: 'Payroll',
            Icon: PayrollIcon,
            active: 'payroll',
            path: `/payroll`,
            show: employeeStatus == 'Admin' || employeeStatus == 'HR'
        },
        {
            label: 'PaySlip',
            Icon: PayrollIcon,
            active: 'payroll',
            path: `/dash/payslip/${logindata?.EmployeeId}`,
            show: (employeeStatus == 'Employee' || employeeStatus == 'Recruiter') && showTrainee
        },
        {
            label: 'Employee',
            Icon: EmployeeWhiteIcon,
            FillIcon: EmployeeIcon,
            active: 'Employee',
            path: `/employees`,
            show: employeeStatus == 'Admin' || employeeStatus == 'HR'
        },
        {
            label: 'Performance',
            Icon: PerformanceIcon,
            active: 'perform',
            path: `/dash/appraisalform`,
            show: employeeStatus == 'Admin' || employeeStatus == 'HR'
        },
        {
            label: 'Report',
            Icon: ReportIcon,
            FillIcon: ReportIconFill,
            active: 'report',
            path: `/reports/`,
            show: employeeStatus == 'Admin' || employeeStatus == 'HR'
        },
        {
            label: 'Leave',
            Icon: LeaveIcon,
            FillIcon: LeaveIconFill,
            active: 'leave',
            path: `/leave`,
            show: true
        },
        {
            label: 'Leave',
            Icon: LeaveIcon,
            FillIcon: LeaveIconFill,
            active: 'leave',
            path: `/leave`,
            show: (employeeStatus == 'Employee' || employeeStatus == 'Recruiter') && logindata.is_reporting_manage
        },
        {
            label: 'Setting',
            Icon: SettingIcon,
            active: 'setting',
            path: `/settings`,
            show: true
        },

    ]
    let navigate = useNavigate()
    return (
        <div className='sticky top-0 ' >
            {/* Mobile Nav */}
            <main className='bg-white p-3 flex justify-between d-lg-none ' >
                <img
                    onClick={() => {
                        setIsInsideOffice((prev) => !prev)
                    }}
                    // onClick={() => navigate(navbarButtons[0].path)}
                    src={require('../../assets/logo/Merida_Tech_Minds_logo2.png')}
                    alt="MeridaLogo"
                    className=' w-[7rem] h-fit ' />
                <div className='flex items-center gap-2 ' >
                    <QrCodeGenerator />

                    <button onClick={() => setShowOff(true)} className='p-3 rounded bg-slate-100 px-3 ' >
                        <BurgerIcon />
                    </button>
                </div>
                <Offcanvas placement='end' show={showOff} onHide={() => setShowOff(false)} >
                    <Offcanvas.Header closeButton >
                        <img
                            onClick={() => {
                                setIsInsideOffice((prev) => !prev)
                            }}
                            src={require('../../assets/logo/Merida_Tech_Minds_logo2.png')} alt="MeridaLogo"
                            className=' w-[7rem] ' />
                    </Offcanvas.Header>
                    <Offcanvas.Body className='poppins ' >
                        <button className=' ' onClick={() => navigate(`/dash/employee/${Empid}`)} >
                            My Profile
                        </button>
                        {
                            navbarButtons.map((obj, index) => (
                                obj.show &&
                                <div className='poppins my-3 cursor-pointer '
                                    onClick={() => {
                                        setShowOff(false);
                                        if (obj.onClick) {
                                            obj.onClick()
                                        } else if (obj.href) {
                                            window.open(obj.href, '_blank')
                                        } else {
                                            navigate(obj.path)
                                        }
                                    }} >
                                    {obj.label}
                                </div>
                            ))
                        }
                        <button className=' ' onClick={() => {
                            navigate("/")
                            axios.post(`${port}/root/logout/${Empid}/`)
                                .then((r) => {
                                    sessionStorage.removeItem('user')
                                    navigate("/")
                                })
                                .catch((err) => {
                                    console.log("Logout Error", err)
                                })
                        }} >
                            Log Out
                        </button>
                    </Offcanvas.Body>
                </Offcanvas>
            </main>
            {/* Desktop Nav */}
            <div className=' text-slate-50 sidebarbg w-[100px] duration-300
        justify-between d-none d-lg-flex flex flex-col items-center gap-3 h-[100vh] py-3 ' >
                <img
                    onClick={() => {
                        setIsInsideOffice((prev) => !prev)
                    }}
                    src={require('../../assets/logo/favicon.ico')} alt="Icon" className='w-[30px] ' />
                <main className=' h-[90vh] overflow-y-scroll 
            text-slate-50 w-full navscrollbar1  ' >
                    {
                        navbarButtons.map((obj, index) => (
                            <NewSideBarButton index={index} data={obj} />
                        ))
                    }
                </main>
            </div>
        </div>
    )
}

export default NewSideBar