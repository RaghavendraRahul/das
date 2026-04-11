import React, { useContext, useEffect, useState } from 'react'
import NewSideBar from '../MiniComponent/NewSideBar'
import Topnav from '../Topnav'
import { Route, Routes, useLocation, useNavigate, useParams } from 'react-router-dom'
import ReportingCheck from '../AuthPermissions/ReportingCheck'
import ApprovalPage from '../../Pages/Approval/ApprovalPage'
import { HrmStore } from '../../Context/HrmContext'
import AttendenceAdmin from '../../Pages/AttendenceAdmin'
import LeaveAllHistory from '../../Pages/Approval/LeaveAllHistory'
import LeavePage from '../../Pages/LeavePage'
import { RouterStore } from '../../Context/RouterContext'
import LeaveSummary from '../../Pages/LeavePages/LeaveSummary'
import { port } from '../../App'
import axios from 'axios'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'
import LeaveApplying from '../../Pages/SettingPage/LeaveApplying'
import LeaveBalanceCard from '../Leavecomponent/LeaveBalanceCard'
import LeaveSetting from '../../Pages/LeaveCreation'
import BackButton from '../MiniComponent/BackButton'

const LeaveRouter = () => {
    let location = useLocation()
    let queryParams = new URLSearchParams(location.search)

    let empId = queryParams.get('empid')
    let { setActivePage, topnav } = useContext(HrmStore)
    let { leaveRouterLinks } = useContext(RouterStore)
    let [allocatedLeave, setAllocatedLeave] = useState()
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let status = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let subNav = leaveRouterLinks
    let getAvailableLeaves = () => {
        axios.get(`${port}/root/lms/EmployeeLeaveEligibility/list/${empId ? empId : empid}/`).then((response) => {
            console.log(response.data);
            setAllocatedLeave(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        setActivePage('leave')
        getAvailableLeaves()
    }, [])
    let navigate = useNavigate()
    return (
        <div>
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
                    <Topnav navbar={subNav?.filter((obj) => obj.show == true)} />
                    {/* Leave buttons */}
                    {(topnav == 'leave' || topnav == 'summary') && <main className='flex justify-between flex-wrap p-3 items-center ' >
                        {
                            empId && <BackButton />
                        }
                        <section className='flex flex-wrap gap-3 items-center ms-auto' >

                            {(status == 'Admin' || status == 'HR') && !empId &&
                                <button onClick={() => navigate('/leave/leaveCreation')} className='border-2 w-40 border-blue-600 rounded p-2 px-3 text-blue-600 ' >
                                    Add Leave +
                                </button>}
                            {!empId && <button onClick={() => navigate('/leave/apply')} className='bg-blue-600 text-slate-50 w-40 p-2 px-3 rounded border-2 border-blue-600 ' >
                                Apply Leave
                            </button>}
                        </section>
                    </main>}
                    <div className='p-3 ' >
                        {/* Balance cards */}
                        {(topnav == 'leave' || topnav == 'summary') && <main className='overflow-x-scroll scrollmade my-2 flex items-stretch gap-3 '>
                            {
                                allocatedLeave && [...allocatedLeave].map((obj, index) => (
                                    <LeaveBalanceCard obj={obj} index={index} />
                                ))
                            }
                        </main>}
                        <Routes>
                            <Route path='/approvals' element={<ReportingCheck prop Child={ApprovalPage} />} />
                            <Route path='/*' element={<LeaveSummary empId={empId} subpage />} />
                            <Route path='/attendence-list' element={<AttendenceAdmin subpage />} />
                            <Route path='/history' element={<LeaveAllHistory subpage />} />
                            <Route path='/leaveCreation' element={<LeavePage subpage />} />
                            <Route path='/apply/*' element={<LeaveApplying subpage />} />
                            <Route path='/leaveSetting/:id' element={<LeaveSetting subpage />} />
                        </Routes>
                    </div>
                </article>
            </main>
        </div>
    )
}

export default LeaveRouter