import React, { useContext, useEffect } from 'react'
import NewSideBar from '../../Components/MiniComponent/NewSideBar'
import Topnav from '../../Components/Topnav'
import { Route, Routes } from 'react-router-dom'
import MyReport from '../ReportRouter/MyReport'
import EmployeeActivitySheet from './EmployeeActivitySheet'
import { HrmStore } from '../../Context/HrmContext'
import { RouterStore } from '../../Context/RouterContext'
import Reporting_team from '../../Components/Reporting_team'
import MyTeamActivity from './MyTeamActivity'
import ParticularActivityPage from './ParticularActivityPage'
import InterviewPage from './InterviewPage'
import ActivityMetricDetailsPage from './ActivityMetricDetailsPage'
import LeadActivityLogPage from './LeadActivityLogPage'

const ActivityRouter = () => {
    let { setActivePage } = useContext(HrmStore)
    let { activityRouterLinks } = useContext(RouterStore)
    useEffect(() => {
        setActivePage('activity')
    }, [])
    let subNav = activityRouterLinks
    return (
        <div>
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
                    <Topnav navbar={subNav?.filter((obj) => obj.show == true)} />
                    <div className='p-2 ' >
                        <Routes>
                            <Route path='/*' element={<EmployeeActivitySheet subpage />} />
                            {/* <Route path='/myteam' element={<Reporting_team subpage />} /> */}
                            <Route path='/interview/' element={<InterviewPage />} />
                            <Route path='/myteam/*' element={<MyTeamActivity subpage />} />
                            <Route path='/myteam/:empid' element={<EmployeeActivitySheet subpage />} />
                            <Route path='/particularActivity/:empid' element={<ParticularActivityPage />} />
                            <Route path='/details/:metricType' element={<ActivityMetricDetailsPage />} />
                            <Route path='/lead-log/:activityId' element={<LeadActivityLogPage />} />
                        </Routes>

                    </div>
                </article>
            </main>

        </div>
    )
}

export default ActivityRouter