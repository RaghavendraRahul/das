import { Modal, ModalBody } from 'react-bootstrap'
import React from 'react'

const CandidateInformationModal = (props) => {
    let { show, setshow,Screening_screening_data,int_int_data,
        Screening_candidate_data } = props
    return (
        <div>
            {
                <Modal show={show} fullscreen onHide={() => setshow(false)} >
                    <Modal.Header closeButton>
                        <h4>Screening Status </h4>
                    </Modal.Header>
                    <Modal.Body>
                        <div className="row justify-content-center m-0">
                            <h4 className='mt-1 text-primary'>Candidate Information</h4>

                            <div className="col-lg-12 p-1 rounded-lg">

                                <table className="table table-bordered">
                                    <tbody>
                                        <tr>
                                            <th>Name</th>
                                            <td>{Screening_candidate_data.FirstName} {Screening_candidate_data.LastName}</td>
                                        </tr>
                                        <tr>
                                            <th>Email</th>
                                            <td>{Screening_candidate_data.Email}</td>
                                        </tr>
                                        <tr>
                                            <th>Gender</th>
                                            <td>{Screening_candidate_data.Gender}</td>
                                        </tr>
                                        <tr>
                                            <th>Primary Contact</th>
                                            <td>{Screening_candidate_data.PrimaryContact}</td>
                                        </tr>
                                        <tr>
                                            <th>Secondary Contact</th>
                                            <td>{Screening_candidate_data.SecondaryContact}</td>
                                        </tr>
                                        <tr>
                                            <th>Location</th>
                                            <td>{Screening_candidate_data.Location}</td>
                                        </tr>

                                        {/*  */}
                                        {/* Fresher start  */}

                                        <tr className={` ${Screening_candidate_data.Fresher ? ' ' : 'd-none'} `}>
                                            <th> {Screening_candidate_data.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                            {/* <td >{persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Fresher ? ' ' : 'd-none'} `}>
                                            <th>GeneralSkills</th>
                                            <td>{Screening_candidate_data.GeneralSkills}</td>
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Fresher ? ' ' : 'd-none'} `}>
                                            <th>TechnicalSkills</th>
                                            <td>{Screening_candidate_data.TechnicalSkills}</td>
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Fresher ? ' ' : 'd-none'} `}>
                                            <th>SoftSkills</th>
                                            <td>{Screening_candidate_data.SoftSkills}</td>
                                        </tr>

                                        {/*  Fresher end */}

                                        {/* Experience Start */}



                                        <tr className={` ${Screening_candidate_data.Experience ? ' ' : 'd-none'} `}>
                                            <th> {Screening_candidate_data.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                            {/* <th>Experience</th> */}
                                            {/* <td>{persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Experience ? ' ' : 'd-none'} `}>
                                            <th>GeneralSkills with Exp</th>
                                            <td>{Screening_candidate_data.GeneralSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Experience ? ' ' : 'd-none'} `}>
                                            <th>TechnicalSkills with Exp</th>
                                            <td>{Screening_candidate_data.TechnicalSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${Screening_candidate_data.Experience ? ' ' : 'd-none'} `}>
                                            <th>SoftSkills with Exp</th>
                                            <td>{Screening_candidate_data.SoftSkills_with_Exp}</td>
                                        </tr>
                                        {/* Experience Start */}

                                        {/*  */}

                                        <tr>
                                            <th>Highest Qualification</th>
                                            <td>{Screening_candidate_data.HighestQualification}</td>
                                        </tr>
                                        <tr>
                                            <th>University</th>
                                            <td>{Screening_candidate_data.University}</td>
                                        </tr>
                                        <tr>
                                            <th>Specialization</th>
                                            <td>{Screening_candidate_data.Specialization}</td>
                                        </tr>
                                        <tr>
                                            <th>Percentage</th>
                                            <td>{Screening_candidate_data.Percentage}</td>
                                        </tr>
                                        <tr>
                                            <th>Year of Passout</th>
                                            <td>{Screening_candidate_data.YearOfPassout}</td>
                                        </tr>
                                        <tr>
                                            <th>Applied Designation</th>
                                            <td>{Screening_candidate_data.AppliedDesignation}</td>
                                        </tr>
                                        <tr>
                                            <th>Expected Salary</th>
                                            <td>{Screening_candidate_data.ExpectedSalary}</td>
                                        </tr>
                                        <tr>
                                            <th>Contacted By</th>
                                            <td>{Screening_candidate_data.ContactedBy}</td>
                                        </tr>
                                        <tr>
                                            <th>Job Portal Source</th>
                                            <td>{Screening_candidate_data.JobPortalSource}</td>
                                        </tr>
                                        <tr>
                                            <th>Applied Date</th>
                                            <td>{Screening_candidate_data.AppliedDate}</td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                        <div className="row justify-content-center m-0">
                            <h4 className='mt-4 text-primary'>Screening Data</h4>

                            <div className="col-lg-12  rounded-lg">


                                <table className="table table-bordered">

                                    <tbody>



                                        {/* Screening Data */}
                                        <tr>
                                            <th>Recruiter Name</th>
                                            <td>{Screening_screening_data.recruiter_name}</td>
                                        </tr>
                                        <tr>
                                            <th>Assigner Name</th>
                                            <td>{Screening_screening_data.assigner_name}</td>
                                        </tr>
                                        <tr>
                                            <th>Recruiter EmployeeId</th>
                                            <td>{Screening_screening_data.recruiter_EmployeeId}</td>
                                        </tr>
                                        <tr>
                                            <th>Assigner EmployeeId</th>
                                            <td>{Screening_screening_data.assigner_EmployeeId}</td>
                                        </tr>
                                        <tr>
                                            <th>Date of Assigned</th>
                                            <td>{Screening_screening_data.Date_of_assigned}</td>
                                        </tr>
                                        {/* <tr>
                                          <th>Review CandidateId</th>
                                          <td>{Screening_screening_data.review.CandidateId}</td>
                                         </tr>
                                         <tr>
                                          <th>Position Applied For</th>
                                          <td>{Screening_screening_data.review.PositionAppliedFor}</td>
                                         </tr>
                                         <tr>
                                          <th>Source By</th>
                                          <td>{Screening_screening_data.review.SourceBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Source Name</th>
                                          <td>{Screening_screening_data.review.SourceName}</td>
                                         </tr>
                                         <tr>
                                          <th>Last CTC</th>
                                          <td>{Screening_screening_data.review.LastCTC}</td>
                                          </tr>
                                         <tr>
                                          <th>Expected CTC</th>
                                          <td>{Screening_screening_data.review.ExpectedCTC}</td>
                                          </tr>
                                         <tr>
                                          <th>Interview Schedule Date</th>
                                          <td>{Screening_screening_data.review.InterviewScheduleDate}</td>
                                         </tr>
                                         <tr>
                                          <th>Current Location</th>
                                          <td>{Screening_screening_data.review.CurrentLocation}</td>
                                         </tr>
                                         <tr>
                                          <th>Travell By</th>
                                          <td>{Screening_screening_data.review.TravellBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Native</th>
                                          <td>{Screening_screening_data.review.Native}</td>
                                         </tr>
                                         <tr>
                                          <th>Father Designation</th>
                                          <td>{Screening_screening_data.review.FatherDesignation}</td>
                                         </tr>
                                         <tr>
                                          <th>Mother Designation</th>
                                          <td>{Screening_screening_data.review.MotherDesignation}</td>
                                         </tr>
                                         <tr>
                                          <th>No of Siblings</th>
                                          <td>{Screening_screening_data.review.no_of_sibilings}</td>
                                         </tr>
                                         <tr>
                                          <th>Marital Status</th>
                                          <td>{Screening_screening_data.review.MeritalStatus}</td>
                                         </tr>
                                         <tr>
                                          <th>Languages Known</th>
                                          <td>{Screening_screening_data.review.LanguagesKnown}</td>
                                         </tr>
                                         <tr>
                                          <th>Screening Status</th>
                                          <td>{Screening_screening_data.review.Screening_Status}</td>
                                         </tr>
                                         <tr>
                                          <th>Comments</th>
                                          <td>{Screening_screening_data.review.Comments}</td>
                                         </tr>
                                         <tr>
                                          <th>Reviewed By</th>
                                          <td>{Screening_screening_data.review.ReviewedBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Reviewed On</th>
                                          <td>{Screening_screening_data.review.ReviewedOn}</td>
                                         </tr> */}

                                    </tbody>

                                </table>




                            </div>

                            <h4 className='mt-4 text-primary' >Screening Review</h4>

                            <div className="col-lg-12  rounded-lg">


                                <table className={`table table-bordered  `}>



                                    {/* <tbody>


                                         <tr>
                                          <th>Review CandidateId</th>
                                          <td>{Screening_screening_review1.CandidateId}</td>
                                         </tr>
                                         <tr>
                                          <th>Position Applied For</th>
                                          <td>{Screening_screening_review1.PositionAppliedFor}</td>
                                         </tr>
                                         <tr>
                                          <th>Source By</th>
                                          <td>{Screening_screening_review1.SourceBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Source Name</th>
                                          <td>{Screening_screening_review1.SourceName}</td>
                                         </tr>
                                         <tr>
                                          <th>Last CTC</th>
                                          <td>{Screening_screening_review1.LastCTC}</td>
                                         </tr>
                                         <tr>
                                          <th>Expected CTC</th>
                                          <td>{Screening_screening_review1.ExpectedCTC}</td>
                                         </tr>
                                         <tr>
                                          <th>Interview Schedule Date</th>
                                          <td>{Screening_screening_review1.InterviewScheduleDate}</td>
                                         </tr>
                                         <tr>
                                          <th>Current Location</th>
                                          <td>{Screening_screening_review1.CurrentLocation}</td>
                                         </tr>
                                         <tr>
                                          <th>Travell By</th>
                                          <td>{Screening_screening_review1.TravellBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Native</th>
                                          <td>{Screening_screening_review1.Native}</td>
                                         </tr>
                                         <tr>
                                          <th>Father Designation</th>
                                          <td>{Screening_screening_review1.FatherDesignation}</td>
                                         </tr>
                                         <tr>
                                          <th>Mother Designation</th>
                                          <td>{Screening_screening_review1.MotherDesignation}</td>
                                         </tr>
                                         <tr>
                                          <th>No of Siblings</th>
                                          <td>{Screening_screening_review1.no_of_sibilings}</td>
                                         </tr>
                                         <tr>
                                          <th>Marital Status</th>
                                          <td>{Screening_screening_review1.MeritalStatus}</td>
                                         </tr>
                                         <tr>
                                          <th>Languages Known</th>
                                          <td>{Screening_screening_review1.LanguagesKnown}</td>
                                         </tr>
                                         <tr>
                                          <th>Screening Status</th>
                                          <td>{Screening_screening_review1.Screening_Status}</td>
                                         </tr>
                                         <tr>
                                          <th>Comments</th>
                                          <td>{Screening_screening_review1.Comments}</td>
                                         </tr>
                                         <tr>
                                          <th>Reviewed By</th>
                                          <td>{Screening_screening_review1.ReviewedBy}</td>
                                         </tr>
                                         <tr>
                                          <th>Reviewed On</th>
                                          <td>{Screening_screening_review1.ReviewedOn}</td>
                                         </tr>



                                      </tbody> */}

                                </table>




                            </div>


                        </div>
                        {/* Interview Round end */}

                    </Modal.Body>
                    <Modal.Footer>
                        <div class={` gap-2 ${int_int_data != null ? 'd-none' : ''}`}>
                            <button className='btn btn-sm btn-success' data-bs-toggle="modal" data-bs-target="#exampleModal15" >Proceed</button>
                        </div>
                    </Modal.Footer>

                </Modal>

            }
        </div>
    )
}

export default CandidateInformationModal