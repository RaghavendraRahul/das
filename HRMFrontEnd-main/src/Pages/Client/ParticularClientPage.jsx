import React, { useContext, useEffect } from 'react'
import ClientCreation from './ClientCreation'
import { Route, Routes, useNavigate, useParams } from 'react-router-dom'
import ScrollButton from '../../Components/SettingComponent/ScrollButton'
import { HrmStore } from '../../Context/HrmContext'
import Topnav from '../../Components/Topnav'
import ParticularClientRecuirment from './ParticularClientRecuirment'
import ClientDashCards from '../../Components/ClientComponents/ClientDashCards'

const ParticularClientPage = ({ subpage }) => {
    let { id } = useParams()
    let navigate = useNavigate()
    let { setActivePage, activeSetting, setTopNav, setActiveSetting } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('client')
        setTopNav('client')
    }, [])
    return (
        <div>
            {!subpage && <Topnav />}
            <div className='px-2 ' >

                <main className='flex gap-3 my-3 scrollmade overflow-x-scroll'>
                    <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Client Details' path={`/client/${id}`} active='client' />
                    <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Recuirment List ' path={`/client/${id}/recuirment`} active='requirement' />
                </main>
                <button onClick={() => navigate(`/client`)} className='p-2 text-sm bg-black text-white rounded ' >
                    Back  </button>
                {/* Router */}
                {id && <ClientDashCards cid={id} />}
                <Routes>
                    <Route path='/*' element={<ClientCreation page='client' id={id} />} />
                    <Route path='/recuirment' element={<ParticularClientRecuirment id={id} />} />
                </Routes>
            </div>
        </div>
    )
}

export default ParticularClientPage