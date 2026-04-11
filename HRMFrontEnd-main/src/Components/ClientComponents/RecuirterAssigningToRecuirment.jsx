import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import RequirmentAssignModel from '../Modals/RequirmentAssignModel'
import RequirmentAssignRecruiterTable from '../Tables/RequirmentAssignRecruiterTable'

const RecuirterAssigningToRecuirment = ({ rid, cid }) => {
    let [assignedData, setAssignedData] = useState()
    let [showModal, setShowModal] = useState()
    let status = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    let getAssigninedData = () => {
        axios.get(`${port}/root/cms/assign-requirements?requirement_id=${rid}`).then((response) => {
            console.log(response.data, 'requirement23');
            setAssignedData(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getAssigninedData()
    }, [rid])

    return (
        <div>
            <h5 className='text-center fw-normal ' > Recruiter Assigned </h5>

            <main className='bg-white p-3 rounded container-fluid ' >
                {(status == 'admin' || status == 'HR') &&
                    <button onClick={() => setShowModal(true)} className='ms-auto flex text-sm bluebtn p-2 rounded '>
                        Assign Recruiter
                    </button>
                }
                <div className=' ' >
                    <RequirmentAssignRecruiterTable css='max-h-[40vh] ' data={assignedData} />
                </div>
            </main>
            <RequirmentAssignModel cid={cid} rid={rid}
                getData={getAssigninedData} show={showModal} setshow={setShowModal}
            />
        </div>
    )
}

export default RecuirterAssigningToRecuirment