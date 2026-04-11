import React, { useContext, useEffect, useState } from 'react'
import Empsidebar from '../../Components/Empsidebar'
import { Route, Routes } from 'react-router-dom'
import LeaveApplying from './LeaveApplying'
import Topnav from '../../Components/Topnav'
import { HrmStore } from '../../Context/HrmContext'
import ScrollButton from '../../Components/SettingComponent/ScrollButton'
import ChangePassword from './ChangePassword'
import Recsidebar from '../../Components/Recsidebar'
import Sidebar from '../../Components/Sidebar'
import ShowHolidays from './ShowHolidays'
import AttendenceInfo from './AttendenceInfo'
import JobPosting from './JobPosting'
import JobListing from './JobListing'
import NewSideBar from '../../Components/MiniComponent/NewSideBar'
import { RouterStore } from '../../Context/RouterContext'

const SettingRouter = () => {
    let { setActivePage, activeSetting, setActiveSetting, } = useContext(HrmStore)
    let { settingRouterLinks } = useContext(RouterStore)
    let employeeStatus = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    useEffect(() => {
        setActivePage('setting')
    }, [])
    let subNav = settingRouterLinks
    return (
        <main className='flex flex-col lg:flex-row '>
            <article className='sticky z-10 top-0'>
                <NewSideBar />
            </article>
            <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
               
                <Topnav navbar={subNav?.filter((obj) => obj.show == true)} />
                {/* <main className='flex gap-3 my-3 scrollmade overflow-x-scroll'>

                        <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Apply Leave' path='/settings/leave' active='leave' />
                        <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Change Password' path='/settings/password' active='password' />
                        <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Holidays' path='/settings/holidays' active='holidays' />
                        <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Attendence' path='/settings/attendence' active='attendence' />
                        <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Job Posting' path='/settings/jobposting' active='jobposting' />
                    </main> */}
                <div className='p-2 ' >

                    <Routes>
                        <Route path='/*' element={<ShowHolidays />} />
                        {/* <Route path='/leave/*' element={<LeaveApplying />} /> */}
                        <Route path='/password' element={<ChangePassword />} />
                        <Route path='/holidays' element={<ShowHolidays />} />
                        <Route path='/attendence' element={<AttendenceInfo />} />
                        <Route path='/jobposting/*' element={<JobListing />} />
                        <Route path='/jobposting/:id' element={<JobPosting />} />
                        <Route path='/jobpost/' element={<JobPosting />} />


                    </Routes>
                </div>

            </article>

        </main>
    )
}

export default SettingRouter