import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import CandidateAssignedToRequirementTable from '../../Components/Tables/CandidateAssignedToRequirementTable'
import axios from 'axios'
import { port } from '../../App'

const CandidateAssignedRequirment = ({ rid }) => {
    let [candidateAssigned, setCandidateAssigned] = useState()
    let [canAdd, setCanAdd] = useState(false)
    let navigate = useNavigate()
    let getCandidateAssigned = () => {
        axios.get(`${port}/root/cms/client-interviews-assigned?req_id=${rid}&login_emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, 'candidateassign');
            setCandidateAssigned(response.data)
        }).catch((error) => {
            console.log(error, 'candidateassign');
        })
    }
    let getCanAddAccess = () => {
        axios.get(`${port}/root/cms/recruiters-requirement-access?req_id=${rid}&login_emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`)
            .then((response) => {
                console.log(response.data.access, 'permission');
                setCanAdd(response.data.access)
            }).catch((error) => {
                console.log(error);
            })
    }
    useEffect(() => {
        if (rid) {
            getCandidateAssigned()
            getCanAddAccess()
        }
    }, [rid])
    return (
        <div className='py-3 ' >
            <h5 className='text-center ' >Candidate Assigned to Interview </h5>
            <main className='bg-white rounded p-2 ' >
                {canAdd && <button onClick={() => navigate(`/client/candidate/${rid}`)}
                    className='bluebtn rounded flex ms-auto p-2 px-3 text-sm ' >
                    Add Candidate
                </button>}

                {/* Candidate assined table */}
                <CandidateAssignedToRequirementTable
                    css='max-h-[50vh]' getData={getCandidateAssigned}
                    rid={rid} data={candidateAssigned} />
            </main>
        </div>
    )
}

export default CandidateAssignedRequirment