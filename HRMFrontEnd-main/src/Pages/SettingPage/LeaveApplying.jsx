import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import ScrollButton from '../../Components/SettingComponent/ScrollButton'
import { Route, Routes, useNavigate } from 'react-router-dom'
import LeaveApplyingSection from '../../Components/Leavecomponent/LeaveApplyingSection'
import LeavePengindSection from '../../Components/Leavecomponent/LeavePengindSection'
import LeaveHistorySection from '../../Components/Leavecomponent/LeaveHistorySection'
import Sidebar from '../../Components/Sidebar'
import RestrictedLeaveApply from './RestrictedLeaveApply'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'
import LeaveBalanceCard from '../../Components/Leavecomponent/LeaveBalanceCard'

const   LeaveApplying = ({ subpage }) => {
    let { activeSetting, setTopNav, getProperDate, getCurrentDate, timeValidate } = useContext(HrmStore)
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let reportingTo = ''
    try {
        const _lp = sessionStorage.getItem('Login_Profile_Information')
        if (_lp) {
            const parsed = JSON.parse(_lp)
            reportingTo = parsed && parsed.RepotringTo_Name ? parsed.RepotringTo_Name : ''
        }
    } catch (e) {
        reportingTo = ''
    }
    let [allocatedLeave, setAllocatedLeave] = useState()
    let [activeSection, setActiveSection] = useState('')

    let navigate = useNavigate()

    useEffect(() => {
        setTopNav('leave')
    }, [])
    let getAvailableLeaves = () => {
        axios.get(`${port}/root/lms/EmployeeLeaveEligibility/list/${empid}/`).then((response) => {
            console.log(response.data);
            setAllocatedLeave(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getAvailableLeaves()
    }, [])
    const renderTooltip = (text) => (
        <Tooltip id="button-tooltip">{text}</Tooltip>
    );
    return (
        <div className=' '>

            {/* <section className='flex flex-wrap bgclr rounded-full my-3 mx-auto w-fit'>
                <button>

                </button>
                <ScrollButton css="noBorder" activeSetting={activeSection} setTopNav={setActiveSection}
                    name='Apply' path='/leave' active='apply' />
                <ScrollButton css="noBorder" activeSetting={activeSection} setTopNav={setActiveSection}
                    name='Pending' path='/leave/pending' active='pending' />
                <ScrollButton css="noBorder" activeSetting={activeSection} setTopNav={setActiveSection}
                    name='History' path='/leave/history' active='history' />

            </section> */}
            {!subpage &&
                <main className='overflow-x-scroll scrollmade my-2 flex items-stretch gap-3 '>
                    {
                        allocatedLeave && [...allocatedLeave].map((obj, index) => (
                            <LeaveBalanceCard obj={obj} index={index} />
                        ))
                    }
                </main>
            }
            <section className='my-3 fw-medium poppins flex flex-wrap gap-3 items-center '>
                <button onClick={() => { navigate('/leave/apply/') }}
                    className={` ${activeSection == 'apply' && 'text-blue-600 fw-bold '} rounded-xl duration-500 fw-medium  w-fit p-2 px-2 `} >
                    Apply Leave
                </button>
                <button onClick={() => { navigate('/leave/apply/restrictedHoliday') }}
                    className={` ${activeSection == 'rh' && 'text-blue-600 fw-bold '} rounded-xl duration-300 w-fit p-2 px-2 `} >
                    Restricted Leave
                </button>
                <button onClick={() => { navigate('/leave/apply/pending') }}
                    className={` ${activeSection == 'pending' && 'text-blue-600 fw-bold '} rounded-xl duration-500 w-fit p-2 px-2 `} >
                    Pending
                </button>
                <button onClick={() => { navigate('/leave/apply/history') }}
                    className={` ${activeSection == 'history' && 'text-blue-600 fw-bold '} rounded-xl duration-300 w-fit p-2 px-2 `} >
                    History
                </button>

            </section>

            <Routes>
                <Route path='/*' element={<LeaveApplyingSection setActiveSection={setActiveSection} allocatedLeave={allocatedLeave} />} />
                <Route path='/pending' element={<LeavePengindSection setActiveSection={setActiveSection} />} />
                <Route path='/history' element={<LeaveHistorySection setActiveSection={setActiveSection} />} />
                <Route path='/restrictedHoliday' element={<RestrictedLeaveApply setActiveSection={setActiveSection} />} />
            </Routes>

        </div >
    )
}

export default LeaveApplying