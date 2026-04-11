import React from 'react'
import Sidebar from '../Components/Sidebar'
import { Route, Routes } from 'react-router-dom'
import Topnav from '../Components/Topnav'
import LeaveSetting from './LeaveCreation'
import LeavePage from './LeavePage'
import ApprovalPage from './Approval/ApprovalPage'
import LeaveAllHistory from './Approval/LeaveAllHistory'
import Empsidebar from '../Components/Empsidebar'
import Recsidebar from '../Components/Recsidebar'
import ReportingCheck from '../Components/AuthPermissions/ReportingCheck'
import AttendenceAdmin from './AttendenceAdmin'
import BGVerificationDetails from './BGVerificationDetails'
import BackgroundDocumentshow from '../Components/HomeComponent/BackgroundDocumentshow'
import OfferApprovalPage from './Approval/OfferApprovalPage'
import HRrequestPage from './Employee_Performance/HRrequestPage'
import EmployeeProfile from './EmployeeProfile'
import SalaryComponent from './Payroll/SalaryComponent'
import SalaryTemplate from './Payroll/SalaryTemplate'
import STEmployeeAssigning from './Payroll/STEmployeeAssigning'
import PaySlip from './Payroll/PaySlip'
import PayslipTable from './Payroll/PayslipTable'
import ShiftTiming from './Others/ShiftTiming'
import ClientTablePage from './Client/ClientTablePage'
import ClientCreation from './Client/ClientCreation'
import ParticularClientPage from './Client/ParticularClientPage'
import NewSideBar from '../Components/MiniComponent/NewSideBar'
import EmployeeActivitySheet from './Activity/EmployeeActivitySheet'
import CandidatePageFinalStatus from './RecuirementClient/CandidatePageFinalStatus'
import OverviewCandidatesPage from './RecuirementClient/OverviewCandidatesPage'


const DasRouter = () => {
    // let employeeStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    const user = sessionStorage.getItem('user');
    let employeeStatus = user ? JSON.parse(user).Disgnation : null;
    // let employeeStatus = 'HR'


    return (
        <div>
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
                    <Routes>
                        <Route path='/leaveSetting/:id' element={<LeaveSetting />} />
                        <Route path='/leaveCreation' element={<LeavePage />} />
                        <Route path='/approvals' element={<ReportingCheck Child={ApprovalPage} />} />
                        <Route path='/history' element={<LeaveAllHistory />} />
                        <Route path='/attendence-list' element={<AttendenceAdmin />} />
                        <Route path='/bgverificationDetails/:id' element={<BGVerificationDetails />} />
                        <Route path='/BackgroundVerification/:id' element={<BackgroundDocumentshow />} />
                        <Route path='/offerApproval' element={<OfferApprovalPage />} />
                        <Route path='/appraisalform' element={<HRrequestPage />} />
                        <Route path='/employee/:id?' element={<EmployeeProfile />} />
                        <Route path='/employeeactivity/:id?' element={<EmployeeActivitySheet />} />

                        <Route path='/salaryComponent/*' element={<SalaryComponent />} />
                        <Route path='/salary-templates/*' element={<SalaryTemplate />} />
                        <Route path='/salary-assigning' element={<STEmployeeAssigning />} />

                        <Route path='/payslip/:id' element={<PaySlip />} />
                        <Route path='/employeesPayslip' element={<PayslipTable />} />


                        <Route path='/shiftTimings' element={<ShiftTiming />} />
                        <Route path='/client/*' element={<ClientTablePage />} />
                        <Route path='/client/:id/*' element={<ParticularClientPage />} />
                        <Route path='/addClient' element={<ClientCreation />} />
                        <Route path='/shift-timing' element={<ShiftTiming />} />
                        <Route path='/overview-candidates/:status' element={<OverviewCandidatesPage />} />
                        <Route path='/candidate-final-status/:rid' element={<CandidatePageFinalStatus />} />



                    </Routes>

                </article>


            </main>
        </div>
    )
}

export default DasRouter