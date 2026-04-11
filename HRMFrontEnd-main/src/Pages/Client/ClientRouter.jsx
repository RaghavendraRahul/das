import React, { useContext, useEffect } from 'react'
import NewSideBar from '../../Components/MiniComponent/NewSideBar'
import Topnav from '../../Components/Topnav'
import { Route, Routes } from 'react-router-dom'
import ParticularClientPage from './ParticularClientPage'
import ClientTablePage from './ClientTablePage'
import { RouterStore } from '../../Context/RouterContext'
import ClientCreation from './ClientCreation'
import ParticularRequirementPage from './ParticularRequirementPage'
import AllRequirementsPage from '../RecuirementClient/AllRequirementsPage'
import axios from 'axios'
import CandidatePageFinalStatus from '../RecuirementClient/CandidatePageFinalStatus'
import { HrmStore } from '../../Context/HrmContext'
import ClientCategoryList from '../RecuirementClient/ClientCategoryList'

const ClientRouter = () => {
    let { clientRouterLinks } = useContext(RouterStore)
    let { setActivePage } = useContext(HrmStore)
    let subNav = clientRouterLinks
    useEffect(() => {
        axios.get(`https://ipinfo.io/json?token=25dc5f39aa187d`).then((response) => {
            console.log(response.data, 'ipaddress');
        }).catch((error) => {
            console.log(error, 'ipaddress');

        })
    }, [])
    useEffect(() => {
        setActivePage('client')
    }, [])
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
                            <Route path='/*' element={<ClientTablePage subpage />} />
                            <Route path='/:id/*' element={<ParticularClientPage subpage />} />
                            <Route path='/addClient' element={<ClientCreation page />} />
                            <Route path='/recuirment/:rid' element={<ParticularRequirementPage />} />
                            <Route path='/recuirment/*' element={<AllRequirementsPage />} />
                            <Route path='/candidate/:rid?' element={<CandidatePageFinalStatus />} />
                            <Route path='/category/:cat' element={<ClientCategoryList />} />
                        </Routes>
                    </div>
                </article>
            </main>
        </div>
    )
}

export default ClientRouter