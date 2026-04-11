import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import { useNavigate, useParams } from 'react-router-dom'

const ParticularResignationRequest = () => {
    let { id } = useParams()
    let navigate = useNavigate()
    let [data, setData] = useState({
        Applied_On: null,
        Date_Of_Interview: null,
        HR_manager_name: null,
        Interviewer: null,
        additional_feedback: null,
        department: null,
        employee_id: null,
        hr_remarks: null,
        hr_verified_On: null,
        improve_welfare: null,
        is_hr_verified: false,
        is_rm_verified: false,
        liked_most: null,
        name: null,
        position: null,
        reason: null,
        reason_for_leaving: null,
        rejoin_interest: null,
        remarks: null,
        reporting_manager_name: null,
        resignation_verification: null,
        resigned_letter_file: null,
        rm_remarks: null,
        rm_verified_On: null,
        separation_type: null
    })
    let getParticularRequest = () => {
        axios.get(`${port}/root/ems/ResignationRequest?sep_id=${id}`).then((response) => {
            console.log(response.data, "particularResignation");
            setData(response.data)
        }).catch((error) => {
            console.log(error, 'particularResignation');
        })
    }
    useEffect(() => {
        if (id)
            getParticularRequest()
    }, [id])
    return (
        <div>
            <button onClick={() => navigate('/Employee_request_form')} className='rounded bg-black text-white p-2 text-sm px-3 ' >
                Back
            </button>
            <main>

            </main>

        </div>
    )
}

export default ParticularResignationRequest