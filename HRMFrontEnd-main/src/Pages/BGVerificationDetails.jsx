import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { port } from '../App'
import Topnav from '../Components/Topnav'

const BGVerificationDetails = () => {
    let { id } = useParams()
    let [data, setdata] = useState()
    let getDetails = () => {
        axios.get(`${port}/root/BGVerification/${id}/`).then((response) => {
            console.log("list", response.data);
            setdata(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getDetails()
    }, [])
    return (
        <div>
            <Topnav />
            {
                data &&
                <form className='formbg mt-3'>
                    <div className="row justify-content-center m-0">
                        <div className="col-lg-12 p-4 border rounded-lg">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label text-slate-600 poppins fw-medium">Candidate Id</label>
                                    <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={data.candidate}
                                        id="Name" name="Name" required />
                                </div>
                            </div>

                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label text-slate-600 poppins fw-medium">Verifiers Name</label>
                                    <input type="text" value={data.VerifiersName} className="bgclr block p-2 rounded w-full outline-none shadow-none" id="LastName" name="VerifiersName" required />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label text-slate-600 poppins fw-medium">Verifiers Designation</label>
                                    <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={data.VerifiersDesignation} id="Email" name="VerifiersDesignation" required />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="primaryContact" className="form-label text-slate-600 poppins fw-medium">Verifiers Employer</label>
                                    <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={data.VerifiersEmployer} id="PrimaryContact" name="VerifiersEmployer" required />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label text-slate-600 poppins fw-medium">Verifiers Phone Number</label>
                                    <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="SecondaryContact" value={data.VerifiersPhoneNumber} name="VerifiersPhoneNumber" required />
                                </div>

                                {/*  */}

                                <div className="row mt-4 pb-2">
                                    <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                        <label htmlFor="candidateKnows" className="form-label text-slate-600 poppins fw-medium">Do you know the candidate ?</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="candidateKnows" name='CandidateKnows' value={data.CandidateKnows} required>
                                            <option value="">Select</option>
                                            <option value="yes">Yes</option>
                                            <option value="no">No</option>
                                        </select>
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateDesignation" className="form-label text-slate-600 poppins fw-medium">Candidates designation when worked with you ?</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateDesignation" name="CandidateDesignation" value={data.CandidateDesignation} required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateWorksFrom" className="form-label text-slate-600 poppins fw-medium">For how long did the candidate work with you?</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateWorksFrom" name="CandidateWorksFrom" value={data.CandidateWorksFrom} required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateReportingTo" className="form-label text-slate-600 poppins fw-medium">Was the candidate directly reporting to you?</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateReportingTo" name="CandidateReportingTo" value={data.CandidateReportingTo} required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidatePositives" className="form-label text-slate-600 poppins fw-medium">Candidates Positives</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidatePositives" name="CandidatePositives" value={data.CandidatePositives} required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateNegatives" className="form-label text-slate-600 poppins fw-medium">Candidates Areas of Improvement (negatives)</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateNegatives" name="CandidateNegatives" value={data.CandidateNegatives} required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidatePerformanceFeedback" className="form-label text-slate-600 poppins fw-medium">Your feedback on the candidates performance</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="candidatePerformanceLevel" 
                                        name="CandidatesPerformanceFeedback" value={data.CandidatesPerformanceFeedback}
                                         required>
                                            <option value="">Select</option>
                                            <option value="Excellent">Excellent</option>
                                            <option value="Good">Good</option>
                                            <option value="Average">Average</option>
                                        </select>
                                    </div>

                                    <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                        <label htmlFor="candidatePerformanceLevel" className="form-label text-slate-600 poppins fw-medium text-success">Candidate’s ability to work under Target & handle Target Pressure?</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="candidatePerformanceLevel" name='Candidates_ability' value={data.Candidates_ability} required>
                                            <option value="">Select</option>
                                            <option value="Excellent">Excellent</option>
                                            <option value="Good">Good</option>
                                            <option value="Average">Average</option>
                                        </select>
                                    </div>

                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateAchieveTargets" className="form-label text-slate-600 poppins fw-medium">Candidate’s ability to achieve Targets? On an average what would be the Target Vs Achieved %?</label>
                                        <input type="number" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateAchieveTargets" name="Candidates_Achieve_Targets" value={data.Candidates_Achieve_Targets}
                                            placeholder='0-100'  required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateBehaviorFeedback" className="form-label text-slate-600 poppins fw-medium">Your feedback on Candidates behavior, integrity & work ethics</label>
                                        <input type="number" placeholder='0-10' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateBehaviorFeedback" name="Candidate_Behavior_Feedback" value={data.Candidate_Behavior_Feedback}
                                             required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="candidateLeavingReason" className="form-label text-slate-600 poppins fw-medium">Candidates reason for leaving</label>
                                        <input type="text" placeholder='Got better job...' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateLeavingReason"
                                            name="Candidate_Leaving_Reason" value={data.Candidate_Leaving_Reason} required />
                                    </div>
                                    <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                        <label htmlFor="candidateRehire" className="form-label text-slate-600 poppins fw-medium text-success">Is the candidate eligible for rehire?</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="candidateRehire"
                                            value={data.Candidate_Rehire} name='Candidate_Rehire' required>
                                            <option value="">Select</option>
                                            <option value="yes">Yes</option>
                                            <option value="no">No</option>
                                        </select>
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="commentsOnCandidate" className="form-label text-slate-600 poppins fw-medium">Your Comments on the Candidate?</label>
                                        <input type="text" placeholder='Comments on the Employee...' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="commentsOnCandidate" name="Comments_On_Candidate" value={data.Comments_On_Candidate}
                                         required />
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="packageOffered" className="form-label text-slate-600 poppins fw-medium">Package offered?</label>
                                        <input type="text" placeholder='4 LPA ' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="packageOffered"
                                            name="PackageOffered" value={data.PackageOffered} required />
                                    </div>
                                    <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                        <label htmlFor="everHandledTeam" className="form-label text-slate-600 poppins fw-medium text-success">Ever Handled Team</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="everHandledTeam"
                                            value={data.Ever_Handled_Team} name='Ever_Handled_Team' required>
                                            <option value="">Select</option>
                                            <option value="yes">Yes</option>
                                            <option value="no">No</option>
                                        </select>
                                    </div>
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="teamSize" className="form-label text-slate-600 poppins fw-medium">Team Size</label>
                                        <input type="number" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="teamSize"
                                            name="TeamSize" placeholder='10' value={data.TeamSize}  required />
                                    </div>
                                    {/* <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                        <label htmlFor="finalVerifyStatus" className="form-label text-slate-600 poppins fw-medium text-success">Final Verify Status</label>
                                        <select className="bgclr p-2 outline-none w-full block rounded " id="finalVerifyStatus" 
                                        value={data.FinalVerifyStatus} name='FinalVerifyStatus'
                                         required>
                                            <option value="">Select</option>
                                            <option value="True">Yes</option>
                                            <option value="False">No</option>
                                        </select>
                                    </div> */}
                                    <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                        <label htmlFor="remarks" className="form-label text-slate-600 poppins fw-medium">Remarks</label>
                                        <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="remarks"
                                            name="Remarks" value={data.Remarks} required />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            }

        </div>
    )
}

export default BGVerificationDetails