import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { port } from '../../App'
import ClientCreation from './ClientCreation'
import RecuirementCrud from '../../Components/ClientComponents/RecuirementCrud'
import BackButton from '../../Components/MiniComponent/BackButton'
import RecuirterAssigningToRecuirment from '../../Components/ClientComponents/RecuirterAssigningToRecuirment'
import CandidateAssignedRequirment from './CandidateAssignedRequirment'
import ClientDashCards from '../../Components/ClientComponents/ClientDashCards'
import LoadingData from '../../Components/MiniComponent/LoadingData'

const ParticularRequirementPage = () => {
    let { rid } = useParams()
    let empstatus = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    let [requirementDetails, setRequirementDetails] = useState()
    let [loading, setLoading] = useState()
    let getRequirementDetails = () => {
        setLoading(true)
        axios.get(`${port}/root/cms/add-clients-requirements?requirement_id=${rid}`).then((response) => {
            console.log(response.data, 'reuirment');
            setRequirementDetails(response.data)
            setLoading(false)
        }).catch((error) => {
            setLoading(false)
            console.log(error, 'reuirment');
        })
    }
    useEffect(() => {
        getRequirementDetails()
    }, [rid])
    return (
        <div className='poppins ' >
            {/* Client Details */}
            <BackButton />
            {/* Counts */}
            <ClientDashCards rid={rid} />

            {/* RequireAssigning */}
            {(empstatus == 'admin' || empstatus == 'HR') &&
                <RecuirterAssigningToRecuirment cid={requirementDetails?.client_details?.id} rid={rid} />}
                
            {/* Candidate assigned to rquirement */}
            <CandidateAssignedRequirment rid={rid} />
            {/* Requirement details */}
            <h5 className='text-center  my-3 fw-normal ' >Requirement Details </h5>
            {loading ? <LoadingData /> : <RecuirementCrud rid={rid} rdata={requirementDetails}
                getData={getRequirementDetails} />}
            <ClientCreation page='req' id={requirementDetails?.client_details?.id} />

        </div>
    )
}

export default ParticularRequirementPage