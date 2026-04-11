import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import ClientRequirmentTable from '../../Components/Tables/ClientRequirmentTable'
import RecuirementaddingModal from './RecuirementaddingModal'
import axios from 'axios'
import { port } from '../../App'

const ParticularClientRecuirment = ({ id }) => {
    let { setActiveSetting, setTopNav } = useContext(HrmStore)
    let [show, setShow] = useState(false)
    let [clientRequirements, setClientRequirements] = useState()
    let getClientRequirements = () => {
        axios.get(`${port}/root/cms/add-clients-requirements?client_id=${id}`).then((response) => {
            console.log(response.data, 'allclientrequirement');
            setClientRequirements(response.data)
        }).catch((error) => {
            console.log(error, 'allclientrequirement', id);
        })
    }
    useEffect(() => {
        setActiveSetting('requirement')
        setTopNav('client')
        getClientRequirements()
    }, [])
    return (
        <div>

            <ClientRequirmentTable data={clientRequirements} />
            <button onClick={() => setShow(true)} className='flex ms-auto p-2 rounded bg-blue-700 text-white  text-sm ' >
                Add Recuirment  </button>
            <RecuirementaddingModal getData={getClientRequirements} cid={id} show={show} setshow={setShow} />
        </div>
    )
}

export default ParticularClientRecuirment