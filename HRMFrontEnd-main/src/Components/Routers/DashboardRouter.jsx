import React from 'react'
import { Route, Routes } from 'react-router-dom'
import Protect from '../Protect'
import Hrdashpage from '../Hrdashpage'
import Recruiterdashpage from '../Recruiterdashpage'
import Empdashpage from '../Empdashpage'
import NewSideBar from '../MiniComponent/NewSideBar'
import Topnav from '../Topnav'
import NdaReport from '../MiniComponent/NdaReport'

const DashboardRouter = () => {

    return (
        <div>
            <NdaReport />
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>
                    <Topnav />
                    <div className='p-2 ' >
                        <Routes>
                            <Route element={<Protect prop Child={Hrdashpage} />} path='/HR'></Route>
                            <Route element={<Protect prop Child={Hrdashpage} />} path='/Admin'></Route>
                            <Route element={<Protect prop Child={Empdashpage} />} path='/Recruiter'></Route>
                            <Route element={<Protect prop Child={Empdashpage} />} path='/Employee'></Route>
                        </Routes>
                    </div>
                </article>
            </main>

        </div>
    )
}

export default DashboardRouter