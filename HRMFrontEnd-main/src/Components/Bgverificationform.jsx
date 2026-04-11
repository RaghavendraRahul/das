import React, { useEffect } from 'react'

import { useState } from 'react'
import axios from 'axios'

import { port } from '../App'
import { useParams } from 'react-router-dom'
import { toast } from 'react-toastify'


const BgverificationForm = () => {
    let { id, fid } = useParams()
    let BG_verification_Companydata = JSON.parse(sessionStorage.getItem('BG_verification_Companydata'))
    //  DOC verifcation
    let [formStatus, setFormStatus] = useState()
    let [formObj, setFormObj] = useState({
        candidate: id,
        Documents: fid,
        VerifiersName: '',
        VerifiersDesignation: '',
        VerifiersEmployer: '',
        VerifiersPhoneNumber: '',
        CandidateKnows: '',
        CandidateWorksFrom: '',
        CandidateDesignation: '',
        CandidatePositives: '',
        CandidateReportingTo: '',
        CandidateNegatives: '',
        CandidatesPerformanceFeedback: '',
        Candidates_ability: '',
        Candidates_Achieve_Targets: '',
        Candidate_Behavior_Feedback: '',
        Candidate_Leaving_Reason: '',
        Candidate_Rehire: '',
        Comments_On_Candidate: '',
        PackageOffered: '',
        Ever_Handled_Team: '',
        Remarks: '',
        TeamSize: 0,
        FinalVerifyStatus: ''
    })
    useEffect(() => {
        if (id && fid) {
            setFormObj((prev) => ({
                ...prev,
                candidate: id,
                Documents: fid
            }))
            getStatus()
        }

    }, [id, fid])
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let reset = () => {
        getStatus()
        setFormObj({
            candidate: id,
            Documents: fid,
            VerifiersName: '',
            VerifiersDesignation: '',
            VerifiersEmployer: '',
            VerifiersPhoneNumber: '',
            CandidateKnows: '',
            CandidateWorksFrom: '',
            CandidateDesignation: '',
            CandidatePositives: '',
            CandidateReportingTo: '',
            CandidateNegatives: '',
            CandidatesPerformanceFeedback: '',
            Candidates_ability: '',
            Candidates_Achieve_Targets: '',
            Candidate_Behavior_Feedback: '',
            Candidate_Leaving_Reason: '',
            Candidate_Rehire: '',
            Comments_On_Candidate: '',
            PackageOffered: '',
            Ever_Handled_Team: '',
            Remarks: '',
            TeamSize: 0,
            FinalVerifyStatus: ''
        })
    }
    let Documentverifyform = (e) => {
        e.preventDefault();
        if (formObj.CandidateDesignation != '' && formObj.CandidateKnows != '' && formObj.CandidateNegatives != '' &&
            formObj.CandidatesPerformanceFeedback != '' && formObj.CandidatePositives != '' && formObj.CandidateReportingTo != '' &&
            formObj.CandidateWorksFrom != '' && formObj.Candidate_Behavior_Feedback != '' && formObj.Candidate_Leaving_Reason != '' &&
            formObj.Candidate_Rehire != '' && formObj.Candidates_Achieve_Targets != '' && formObj.Candidates_ability != '' &&
            formObj.Comments_On_Candidate != '' && formObj.Ever_Handled_Team != '' && 
            formObj.PackageOffered != '' && formObj.Remarks != '' && formObj.VerifiersDesignation &&
            formObj.VerifiersEmployer != '' && formObj.VerifiersName != '' && formObj.VerifiersPhoneNumber != ''
        ) {
            axios.post(`${port}/root/BG_Verification/`, formObj)
            .then((response) => {
                console.log("Document_Verify_res", response.data);
                toast.success("Document Verification Successful");
                reset()
            })
            .catch((error) => {
                console.error("Document_Verify_error", error);
                toast.error('error Acquired')
            });
        }
        else {
            toast.warning('Fill all the fields')
        }
    }
    let getStatus = () => {
        axios.get(`${port}/root/BG_Status/${fid}/`).then((response) => {
            console.log(response.data);
            setFormStatus(response.data.status)
        }).catch((error) => {
            console.log(error);
        })
    }


    return (
        <div>

            <div className='p-4 border text-sm rounded-lg'>

                <h3 className='text-center'>BG Verification Form</h3>

                {
                    formStatus == 'Completed' ? <section className='bgclr text-center p-3 my-5 rounded col-6 mx-auto '>

                        <h4 className='text-center'>Thank you!!! </h4>
                        <h6>Response for this Form has been Submitted </h6>


                    </section> :


                        <form className='formbg mt-3'>
                            <div className="row justify-content-center m-0">
                                <div className="col-lg-12 p-4 border rounded-lg">
                                    <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="Name" className="form-label text-slate-600 poppins fw-medium">Candidate Id <span className='text-red-600'>*</span> </label>
                                            <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={formObj.candidate}
                                                id="Name" name="Name" required />
                                        </div>
                                    </div>

                                    <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="lastName" className="form-label text-slate-600 poppins fw-medium">Verifiers Name <span className='text-red-600'>*</span> </label>
                                            <input type="text" value={formObj.VerifiersName} className="bgclr block p-2 rounded w-full outline-none shadow-none" id="LastName" name="VerifiersName" onChange={handleChange} required />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="email" className="form-label text-slate-600 poppins fw-medium">Verifiers Designation <span className='text-red-600'>*</span> </label>
                                            <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={formObj.VerifiersDesignation} id="Email" name="VerifiersDesignation" onChange={handleChange} required />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="primaryContact" className="form-label text-slate-600 poppins fw-medium">Verifiers Employer <span className='text-red-600'>*</span> </label>
                                            <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" value={formObj.VerifiersEmployer} id="PrimaryContact" name="VerifiersEmployer" onChange={handleChange} required />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label text-slate-600 poppins fw-medium">Verifiers Phone Number <span className='text-red-600'>*</span> </label>
                                            <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="SecondaryContact" value={formObj.VerifiersPhoneNumber}
                                                onChange={(e) => { if (e.target.value >= 0) { handleChange(e) } }} name="VerifiersPhoneNumber" required />
                                        </div>

                                        {/*  */}

                                        <div className="row mt-4 pb-2">
                                            <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                                <label htmlFor="candidateKnows" className="form-label text-slate-600 poppins fw-medium">Do you know the candidate ? <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="candidateKnows" name='CandidateKnows' value={formObj.CandidateKnows} onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateDesignation" className="form-label text-slate-600 poppins fw-medium">Candidates designation when worked with you ? <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateDesignation" name="CandidateDesignation" value={formObj.CandidateDesignation} onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateWorksFrom" className="form-label text-slate-600 poppins fw-medium">For how long did the candidate work with you? <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateWorksFrom" name="CandidateWorksFrom" value={formObj.CandidateWorksFrom} onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateReportingTo" className="form-label text-slate-600 poppins fw-medium">Was the candidate directly reporting to you? <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateReportingTo" name="CandidateReportingTo" value={formObj.CandidateReportingTo} onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidatePositives" className="form-label text-slate-600 poppins fw-medium">Candidates Positives <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidatePositives" name="CandidatePositives" value={formObj.CandidatePositives} onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateNegatives" className="form-label text-slate-600 poppins fw-medium">Candidates Areas of Improvement (negatives) <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateNegatives" name="CandidateNegatives" value={formObj.CandidateNegatives} onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidatePerformanceFeedback" className="form-label text-slate-600 poppins fw-medium">Your feedback on the candidates performance <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="candidatePerformanceLevel" name="CandidatesPerformanceFeedback" value={formObj.CandidatesPerformanceFeedback}
                                                    onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="Excellent">Excellent</option>
                                                    <option value="Good">Good</option>
                                                    <option value="Average">Average</option>
                                                </select>
                                            </div>

                                            <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                                <label htmlFor="candidatePerformanceLevel" className="form-label text-slate-600 poppins fw-medium text-success">Candidate’s ability to work under Target & handle Target Pressure? <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="candidatePerformanceLevel" name='Candidates_ability' value={formObj.Candidates_ability} onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="Excellent">Excellent</option>
                                                    <option value="Good">Good</option>
                                                    <option value="Average">Average</option>
                                                </select>
                                            </div>

                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateAchieveTargets" className="form-label text-slate-600 poppins fw-medium">Candidate’s ability to achieve Targets? On an average what would be the Target Vs Achieved %? <span className='text-red-600'>*</span> </label>
                                                <input type="number" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateAchieveTargets" name="Candidates_Achieve_Targets" value={formObj.Candidates_Achieve_Targets}
                                                    placeholder='0-100' onChange={(e) => { if (e.target.value >= 0 && e.target.value <= 100) handleChange(e) }} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateBehaviorFeedback" className="form-label text-slate-600 poppins fw-medium">Your feedback on Candidates behavior, integrity & work ethics <span className='text-red-600'>*</span> </label>
                                                <input type="number" placeholder='0-10' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateBehaviorFeedback" name="Candidate_Behavior_Feedback" value={formObj.Candidate_Behavior_Feedback}
                                                    onChange={(e) => { if (e.target.value >= 0 && e.target.value <= 10) handleChange(e) }} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="candidateLeavingReason" className="form-label text-slate-600 poppins fw-medium">Candidates reason for leaving <span className='text-red-600'>*</span> </label>
                                                <input type="text" placeholder='Got better job...' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="candidateLeavingReason"
                                                    name="Candidate_Leaving_Reason" value={formObj.Candidate_Leaving_Reason} onChange={handleChange} required />
                                            </div>
                                            <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                                <label htmlFor="candidateRehire" className="form-label text-slate-600 poppins fw-medium text-success">Is the candidate eligible for rehire? <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="candidateRehire"
                                                    value={formObj.Candidate_Rehire} name='Candidate_Rehire' onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="commentsOnCandidate" className="form-label text-slate-600 poppins fw-medium">Your Comments on the Candidate? <span className='text-red-600'>*</span> </label>
                                                <input type="text" placeholder='Comments on the Employee...' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="commentsOnCandidate" name="Comments_On_Candidate" value={formObj.Comments_On_Candidate}
                                                    onChange={handleChange} required />
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="packageOffered" className="form-label text-slate-600 poppins fw-medium">Package offered? <span className='text-red-600'>*</span> </label>
                                                <input type="text" placeholder='4 LPA ' className="bgclr block p-2 rounded w-full outline-none shadow-none" id="packageOffered"
                                                    name="PackageOffered" value={formObj.PackageOffered} onChange={handleChange} required />
                                            </div>
                                            <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                                <label htmlFor="everHandledTeam" className="form-label text-slate-600 poppins fw-medium text-success">Ever Handled Team <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="everHandledTeam"
                                                    value={formObj.Ever_Handled_Team} name='Ever_Handled_Team' onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="teamSize" className="form-label text-slate-600 poppins fw-medium">Team Size </label>
                                                <input type="number" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="teamSize"
                                                    name="TeamSize" placeholder='10' value={formObj.TeamSize} onChange={(e) => { if (e.target.value >= 0) handleChange(e) }} required />
                                            </div>
                                            {/* <div className="mb-3  col-md-3 col-lg-4 my-2 flex flex-col justify-between">
                                                <label htmlFor="finalVerifyStatus" className="form-label text-slate-600 poppins fw-medium text-success">Final Verify Status <span className='text-red-600'>*</span> </label>
                                                <select className="bgclr p-2 outline-none w-full block rounded " id="finalVerifyStatus" value={formObj.FinalVerifyStatus} name='FinalVerifyStatus'
                                                    onChange={handleChange} required>
                                                    <option value="">Select</option>
                                                    <option value="True">Yes</option>
                                                    <option value="False">No</option>
                                                </select>
                                            </div> */}
                                            <div className="col-md-3 col-lg-4 my-2 flex flex-col justify-between mb-3">
                                                <label htmlFor="remarks" className="form-label text-slate-600 poppins fw-medium">Remarks <span className='text-red-600'>*</span> </label>
                                                <input type="text" className="bgclr block p-2 rounded w-full outline-none shadow-none" id="remarks"
                                                    name="Remarks" value={formObj.Remarks} onChange={handleChange} required />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className='d-flex justify-content-end gap-2 mt-3'>
                                <button type="submit" class="btn btn-success btn-sm" onClick={Documentverifyform} >Submit</button>
                            </div>
                        </form>
                }

            </div>




        </div>

    )
}

export default BgverificationForm