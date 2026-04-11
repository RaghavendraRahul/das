import React, { useContext, useEffect, useState } from 'react'
import Empsidebar from '../../Components/Empsidebar'
import Recsidebar from '../../Components/Recsidebar'
import Sidebar from '../../Components/Sidebar'
import { Route, Routes, useNavigate } from 'react-router-dom'
import Employee_request_form from '../../Components/Employee_request_form'
import Topnav from '../../Components/Topnav'
import ResignationIndex from './ResignationIndex'
import ParticularResignationRequest from './ParticularResignationRequest'
import ExitInterviewForm from './ExitInterviewForm'
import ExitInterviewTable from './ExitInterviewTable'
import { HrmStore } from '../../Context/HrmContext'
import HandOverTables from './HandOverTables'
import NewSideBar from '../../Components/MiniComponent/NewSideBar'

const ExitProcessRouter = ({ subpage }) => {
    let employeeStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let { setActivePage, setTopNav } = useContext(HrmStore)
    let status = JSON.parse(sessionStorage.getItem('status'))
    let [activeSection, setActiveSection] = useState('')
    let navigate = useNavigate()
    useEffect(() => {
        setActivePage('Employee')
        setTopNav('exit')
    }, [])
    return (
        <main className='flex flex-col lg:flex-row '>
            {!subpage && <article className='sticky z-10 top-0'>
                <NewSideBar />
            </article>}
            <article className='flex-1 container-fluid  overflow-hidden mx-auto'>
                {!subpage && <Topnav />}
                {/* Navigation */}
                <section className='my-3 ' >
                    <button onClick={() => navigate('/employees/Employee_request_form')}
                        className={`duration-500  ${activeSection == 'request' ? " text-blue-600 fw-semibold " : 'text-slate-800'} poppins
                     px-3  p-2 rounded `} >
                        Requests
                    </button>
                    {employeeStatus && (employeeStatus == 'HR' || employeeStatus == 'Admin') &&
                        <button onClick={() => navigate('/employees/Employee_request_form/interview')}
                            className={` duration-500 ${activeSection == 'interview' ? " text-blue-600 fw-semibold " : 'text-slate-800'} poppins
                     px-3  p-2 rounded `} >
                            Exit Interview
                        </button>}
                    <button onClick={() => navigate('/employees/Employee_request_form/handover')}
                        className={` duration-500 ${activeSection == 'handover' ? " text-blue-600 fw-semibold " : 'text-slate-800'} poppins
                     px-3  p-2 rounded `} >
                        Exit Formalities 
                    </button>
                </section>

                <Routes>
                    <Route path='/*' element={
                        // employeeStatus && (employeeStatus == 'HR' || employeeStatus == 'Admin') ?
                        < ResignationIndex setActiveSection={setActiveSection} />
                        //    : <Employee_request_form setActiveSection={setActiveSection} />
                    } >

                    </Route>
                    <Route path='/request/:id' element={<Employee_request_form setActiveSection={setActiveSection} />} />
                    <Route path='/apply' element={<Employee_request_form setActiveSection={setActiveSection} />} />
                    <Route path='/interview/*' element={<ExitInterviewTable setActiveSection={setActiveSection} />} />
                    <Route path='/interview/:id' element={<ExitInterviewForm setActiveSection={setActiveSection} />} />
                    <Route path='/handover' element={<HandOverTables setActiveSection={setActiveSection} />} />
                </Routes>

            </article>
        </main >
    )
}

export default ExitProcessRouter