import React, { useContext, useState } from 'react'
import LoadingData from '../MiniComponent/LoadingData'
import { useNavigate } from 'react-router-dom'
import { Modal } from 'react-bootstrap'
import InterviewReviewModal from '../Modals/InterviewReviewModal'
import FinalResultCompleted from '../Modals/FinalResultCompleted'
import InterviewCompletedModal from '../Modals/InterviewCompletedModal'
import { HrmStore } from '../../Context/HrmContext'

const CandidateAssignedToRequirementTable = ({ data, rid, getData, loading, css }) => {
    let navigate = useNavigate()
    let { selectValueToNormal } = useContext(HrmStore)
    let [selectedId, setSelectedId] = useState()
    let [interviewCompletedDetailsModal, setInterviewCompleteDetailsModal] = useState()
    let [finalResultObj, setFinalResultObj] = useState()
    let [interviewId, setinterviewId] = useState()
    return (
        <div>
            <main className={` table-responsive tablebg ${css ? css : 'h-[50vh]'} `} >
                <table className={`w-full `} >
                    <tr className='sticky top-0 bg-white ' >
                        <th>SI NO</th>
                        <th>Candidate Name  </th>
                        <th>Candidate ID</th>
                        <th> Recruiter Name</th>
                        <th>Interviewer Name </th>
                        <th>Interview Status </th>
                        <th> Action </th>
                    </tr>
                    {
                        !loading && data && data.map((obj, index) => (
                            <tr>
                                <td> {index + 1} </td>
                                <td>{obj.candidate_data && obj.candidate_data.FirstName} </td>
                                <td> {obj.candidate_data && obj.candidate_data.CandidateId}</td>
                                <td>{obj.assigner_name} </td>
                                <td>{obj.Interviewer_name} </td>
                                <td> {obj.review && obj.review.interview_Status ? selectValueToNormal(obj.review.interview_Status) : '--'} </td>
                               
                                <td>
                                    {obj.candidate_data && obj.candidate_data.InterviewStatus != 'Completed' ?
                                        <button onClick={() => {
                                            // navigate(`/interviewreview/${obj.id}`)
                                            setSelectedId(obj.id)
                                        }} className=' bluebtn text-sm p-2 rounded ' >
                                            Review
                                        </button> :
                                        <button onClick={() => {
                                            // setSelectedId(obj.id)
                                            setinterviewId(obj.id)
                                            setInterviewCompleteDetailsModal(obj.candidate_data && obj.candidate_data.CandidateId)
                                        }}
                                            className=' bluebtn text-sm p-2 rounded '>
                                            View
                                        </button>
                                    }
                                </td>
                            </tr>
                        ))}
                </table>
                {
                    loading && <LoadingData />
                }

                {<InterviewCompletedModal
                    // setinterviewReviewModal={setinterviewFormFillingModal}
                    //     rountstatus={intervewAsssignedcompleted}
                    //     getfunction={fetchdata2}
                    page='candidate'
                    rid={rid}
                    inid={interviewId}
                    show={interviewCompletedDetailsModal}
                    setshow={setInterviewCompleteDetailsModal} />}

                {selectedId &&
                    <Modal centered fullscreen className='inputbg' show={selectedId} onHide={() => setSelectedId(false)} >
                        <Modal.Header closeButton className=' '  >
                            Interview Review Form
                        </Modal.Header>
                        <Modal.Body>
                            <InterviewReviewModal getData={getData} client inid={selectedId} setshow={setSelectedId} />
                        </Modal.Body>
                    </Modal>
                }
            </main>
        </div>
    )
}

export default CandidateAssignedToRequirementTable