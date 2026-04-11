import React, { useContext, useEffect } from 'react'
import NewSideBar from '../MiniComponent/NewSideBar'
import Topnav from '../Topnav'
import { Route, Routes } from 'react-router-dom'
import Allemp from '../Allemp'
import { HrmStore } from '../../Context/HrmContext'
import Mass_mail from '../Mass_mail'
import Employees from '../Employees'
import Employeees from '../Employeees'
import EmployeeProfile from '../../Pages/EmployeeProfile'
import OfferApprovalPage from '../../Pages/Approval/OfferApprovalPage'
import ExitProcessRouter from '../../Pages/ExitProcess/ExitProcessRouter'
import HrAdminAuth from '../AuthPermissions/HrAdminAuth'
import { RouterStore } from '../../Context/RouterContext'
import DesignationPage from '../../Pages/Others/DesignationPage'
import DepartmentPage from '../../Pages/Others/DepartmentPage'
import PendingJoiningForms from '../../Pages/JoiningFormalities/PendingJoiningForms'
import New_join_emp from '../New_join_emp'


const EmployeeRouter = () => {
    let { setActivePage } = useContext(HrmStore)
    let status = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let { employeeRouterLink } = useContext(RouterStore)
    useEffect(() => {
        setActivePage('Employee')
    }, [])
    let subNav = employeeRouterLink
    return (
        <div>
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
                    <Topnav navbar={subNav} />
                    <div className='p-2 ' >

                        <Routes>
                            <Route path='/*' element={<HrAdminAuth subpage Child={Allemp} />} />
                            <Route path='/designation' element={<DesignationPage />} />
                            <Route path='/department' element={<DepartmentPage />} />

                            <Route path='/Mass_Mail' element={<Mass_mail subpage />} />
                            <Route path='/Employee_Overview' element={<Employeees subpage />} />
                            <Route path='/profile/:id?' element={<EmployeeProfile subpage />} />
                            <Route path='/offerApproval' element={<OfferApprovalPage subpage />} />
                            <Route element={<ExitProcessRouter subpage />} path='/Employee_request_form/*'></Route>
                            <Route path='/pending-joining-forms' element={<PendingJoiningForms subpage />} />
                            <Route path='/New_Join_Employee' element={<New_join_emp subpage />} />

                        </Routes>
                    </div>
                </article>
            </main>
        </div>
    )
}

export default EmployeeRouter