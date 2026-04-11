import React, { useContext, useEffect, useState } from 'react'
import NewSideBar from '../../Components/MiniComponent/NewSideBar'
import Topnav from '../../Components/Topnav'
import { Route, Router, Routes } from 'react-router-dom'
import { HrmStore } from '../../Context/HrmContext'
import { RouterStore } from '../../Context/RouterContext'
import MyReport from './MyReport'
import AnalyticPage from './AnalyticPage'

const ReportRouter = () => {
    let { setActivePage } = useContext(HrmStore)
    let { reportRouterLinks } = useContext(RouterStore)
    let subNav = reportRouterLinks
    useEffect(() => {
        setActivePage('report')
    }, [])
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
                            <Route path='/*' element={<MyReport />} />
                            <Route path='/analytics' element={<AnalyticPage/>} />
                        </Routes>

                    </div>

                </article>
            </main>

        </div>
    )
}

export default ReportRouter