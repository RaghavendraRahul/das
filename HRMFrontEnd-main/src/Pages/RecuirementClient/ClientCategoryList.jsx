import React, { useEffect, useState } from 'react'
import BackButton from '../../Components/MiniComponent/BackButton'
import { useLocation, useParams } from 'react-router-dom'
import axios from 'axios'
import { port } from '../../App'
import LoadingData from '../../Components/MiniComponent/LoadingData'
import CandidateTable from '../../Components/Tables/CandidateTable'
import DataNotFound from '../../Components/MiniComponent/DataNotFound'
import FinalResultCompleted from '../../Components/Modals/FinalResultCompleted'
import { Modal } from 'react-bootstrap'
import CandidateJoiningFormCrud from '../../Components/CRUD/CandidateJoiningFormCrud'

const ClientCategoryList = () => {
    let location = useLocation()
    let { cat } = useParams()
    let [loading, setLoading] = useState(false)
    let [finalResultObj, setFinalResultObj] = useState()
    let [selectedInterviewId, setSelectedinterviewId] = useState()
    let queryParams = new URLSearchParams(location.search)
    let rid = queryParams.get('req_id')
    let cid = queryParams.get('client_id')
    let [candidateDetails, setCandidateDetails] = useState()
    let getCandidateDetails = () => {
        setLoading(true)
        axios.get(`${port}/root/cms/client-finalstatus-count?final_status=${cat}${rid ? `&req_id=${rid}` : ''}${cid ? `&client_id=${cid}` : ''}`)
            .then((response) => {
                console.log(response.data, 'candidate data', `${port}/root/cms/client-finalstatus-count?final_status=${cat}${rid ? `&req_id=${rid}` : ''}${cid ? `&client_id=${cid}` : ''}`);
                setCandidateDetails(response.data)
                setLoading(false)
            }).catch((error) => {
                setLoading(false)
                console.log(error);
            })
    }
    useEffect(() => {
        getCandidateDetails()
    }, [rid, cid, cat])
    let closeCandidateDetails = (bool) => {
        setSelectedinterviewId(bool)
        setFinalResultObj(bool)
    }
    return (
        <div>
            <BackButton />
            {loading ? <LoadingData /> : candidateDetails ?
                <main className=' table-responsive tablebg my-3 '>
                    <table className='w-full'>
                        <tr>
                            <th>SI No </th>
                            <th>Candidate Name </th>
                            <th> Mail ID </th>
                            <th>Contact Number </th>
                            <th>Job Role </th>
                            <th>Candidate Experience/Fresher </th>
                            <th> Client Oranization </th>
                            <th>Final Status </th>
                            <th>Action </th>
                           {cat=='client_offered'&& <th>Joining Offer Form </th>}
                        </tr>
                        {candidateDetails.map((obj, index) => (
                            <tr>
                                <td> {index + 1} </td>
                                <td> {obj.CandidateId?.FirstName} </td>
                                <td> {obj.CandidateId?.Email} </td>
                                <td> {obj.CandidateId?.PrimaryContact} </td>
                                <td> {obj.requirement?.job_title} </td>
                                <td> {obj.CandidateId?.current_position} </td>
                                <td> {obj.requirement?.client_details?.company_name} </td>
                                <td> {obj.CandidateId?.Final_Results} </td>
                                <td> <button onClick={() => {
                                    setSelectedinterviewId(obj.interview_id);
                                    setFinalResultObj(obj.CandidateId)
                                }}
                                    className='bluebtn p-2 rounded text-sm ' > View </button>
                                </td>
                                {cat=='client_offered'&&  <td> <button onClick={() => setSelectedinterviewId(obj.interview_id)}
                                    className='bluebtn p-2 rounded text-sm ' >Form </button> </td>}
                            </tr>
                        ))}
                    </table>
                </main>

                : <DataNotFound />
            }
            <FinalResultCompleted inid={selectedInterviewId} show={finalResultObj} setshow={closeCandidateDetails} />

            {/* Model to add the value */}
            <Modal centered show={selectedInterviewId && !finalResultObj} onHide={() => setSelectedinterviewId(false)} >
                <Modal.Header closeButton ></Modal.Header>
                <Modal.Body>
                    <CandidateJoiningFormCrud setshow={setSelectedinterviewId} inid={selectedInterviewId} />
                </Modal.Body>
            </Modal>
        </div>
    )
}

export default ClientCategoryList