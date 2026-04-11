import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import FinalStatus from './FinalStatus'
import SchedulINterviewModalForm from '../ApplyList/SchedulINterviewModalForm'
import ClientINterviewDetails from '../ClientComponents/ClientINterviewDetails'

const InterviewCompletedModal = (props) => {
    let { show, setshow, id, rid, inid, getfunction, setinterviewReviewModal, page, rountstatus } = props
    let empStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let userPermission = JSON.parse(sessionStorage.getItem('user')).user_permissions
    let [finalStatus, setFinalStatus] = useState(false)
    let { convertToReadableDateTime, convertToNormalTime } = useContext(HrmStore)
    let [data, setdata] = useState()
    console.log(rountstatus, 'interview status');

    useEffect(() => {
        if (show) {
            axios.get(`${port}/root/New-Candidate-Interview-Completed-Details/${show}/`).then((response) => {
                setdata(response.data)
                console.log("interview_response", response.data);
            }).catch((error) => {
                console.log(error);
            })
        }
    }, [show])
    return (
        <div>

            {show && <Modal show={show} className=' ' centered size='xl' onHide={() => setshow(false)} >
                <Modal.Header className='bg-yellow-50 bg-opacity-50 ' closeButton>
                    <h4 className='text-violet-700 ' >Interviews so far Details</h4>
                </Modal.Header>
                <Modal.Body className='bg-yellow-50 bg-opacity-50 '>
                    {data && data.candidate_data && <main className=''>
                        <h4 className='text-violet-700 ' >Candidate Details </h4>
                        <section className='flex flex-wrap'>
                            <div className=' col-lg-4 p-2 py-3 col-md-6  '>
                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0 fw-semibold'>
                                    Name : <span className='fw-normal break-words'>{data.candidate_data.FirstName} </span> </p>
                            </div>
                            <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                    Email : <span className='fw-normal break-words'>{data.candidate_data.Email} </span> </p>
                            </div>
                            <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                    Primary Contact : <span className='fw-normal break-words'>{data.candidate_data.PrimaryContact} </span> </p>
                            </div>
                            {data.candidate_data.SecondaryContact && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                    Secondary Contact : <span className='fw-normal break-words'>{data.candidate_data.SecondaryContact} </span> </p>
                            </div>}
                            {
                                data.candidate_data.AppliedDesignation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Designation Applied for: <span className='fw-normal break-words'>{data.candidate_data.AppliedDesignation} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.ContactedBy && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Contacted by : <span className='fw-normal break-words'>{data.candidate_data.ContactedBy} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.ExpectedSalary && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Expected Salary : <span className='fw-normal break-words'>{data.candidate_data.ExpectedSalary} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.Gender && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Gender : <span className='fw-normal break-words'>{data.candidate_data.Gender} </span> </p>
                                </div>
                            }

                            {
                                data.candidate_data.JobPortalSource && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Job Portal Source : <span className='fw-normal break-words'>{data.candidate_data.JobPortalSource} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.Location && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Current Location : <span className='fw-normal break-words'>{data.candidate_data.Location} </span> </p>
                                </div>
                            }
                        </section>
                        <hr className='border-1 border-blue-600 ' />
                        <h4 className='my-2 text-violet-700'>Qualification </h4>
                        <section className='flex flex-wrap '>
                            {
                                data.candidate_data.HighestQualification && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Highest Qualification : <span className='fw-normal break-words'>{data.candidate_data.HighestQualification} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.Specialization && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Specification : <span className='fw-normal break-words'>{data.candidate_data.Specialization} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.Percentage && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Percentage : <span className='fw-normal break-words'>{data.candidate_data.Percentage} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.University && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        University : <span className='fw-normal break-words'>{data.candidate_data.University} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.YearOfPassout && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Year Of Passout : <span className='fw-normal break-words'>{data.candidate_data.YearOfPassout} </span> </p>
                                </div>
                            }
                        </section>
                        <hr className='border-1 border-blue-600 ' />

                        <h4 className='text-violet-700 ' >Skills   </h4>
                        <section className='flex flex-wrap '>
                            {
                                data.candidate_data.GeneralSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        General Skills : <span className='fw-normal break-words'>{data.candidate_data.GeneralSkills} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.SoftSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Soft Skills : <span className='fw-normal break-words'>{data.candidate_data.SoftSkills} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.TechnicalSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Technical Skills : <span className='fw-normal break-words'>{data.candidate_data.TechnicalSkills} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.SoftSkills_with_Exp && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Soft Skills : <span className='fw-normal break-words'>{data.candidate_data.SoftSkills_with_Exp} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.TechnicalSkills_with_Exp && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Technical Skills : <span className='fw-normal break-words'>{data.candidate_data.TechnicalSkills_with_Exp} </span> </p>
                                </div>
                            }
                            {
                                data.candidate_data.GeneralSkills_with_Exp && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        General Skills : <span className='fw-normal break-words'>{data.candidate_data.GeneralSkills_with_Exp} </span> </p>
                                </div>
                            }
                        </section>
                        <hr className='border-1 border-blue-600 ' />

                        {data.candidate_data.Experience && <h4 className='text-violet-700 ' >Employeement </h4>}
                        {
                            data.candidate_data.Experience && <section className='flex flex-wrap'>
                                {
                                    data.candidate_data.CurrentCTC && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Current CTC : <span className='fw-normal break-words'>{data.candidate_data.CurrentCTC} </span> </p>
                                    </div>
                                }
                                {
                                    data.candidate_data.CurrentDesignation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Current Designation : <span className='fw-normal break-words'>{data.candidate_data.CurrentDesignation} </span> </p>
                                    </div>
                                }
                                {
                                    data.candidate_data.NoticePeriod && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Notice period : <span className='fw-normal break-words'>{data.candidate_data.NoticePeriod} days </span>  </p>
                                    </div>
                                }

                            </section>
                        }

                    </main>}
                    {data && data.screening_data &&
                        <div>
                            <hr className='border-1 border-blue-600 ' />
                            <h4 className='text-violet-700 ' >Screening Review</h4>
                            <section className='flex flex-wrap'>
                                {data.screening_data.recruiter_name && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Recruiter Name : <span className='fw-normal break-words'>{data.screening_data.recruiter_name} </span>  </p>
                                </div>
                                }
                                {data.screening_data.assigner_name && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                        Assigned By : <span className='fw-normal break-words'>{data.screening_data.assigner_name} </span>  </p>
                                </div>
                                }
                                {
                                    data.screening_data && data.screening_data.Date_of_assigned && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Assigned At : <span className='fw-normal break-words'>
                                                {data.screening_data &&
                                                    convertToReadableDateTime(data.screening_data && data.screening_data.Date_of_assigned && data.screening_data.Date_of_assigned)}
                                            </span>
                                        </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.ReviewedBy && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Reviewed By: <span className='fw-normal break-words'>
                                                {(data.screening_data && data.screening_data.review && data.screening_data.review.ReviewedBy)}
                                            </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.ReviewedOn && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Reviewed On : <span className='fw-normal break-words'>
                                                {convertToReadableDateTime(data.screening_data && data.screening_data.review && data.screening_data.review.ReviewedOn)}
                                            </span>
                                        </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.SpouseName && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Spouse Name : <span className='fw-normal break-words'>{(data.screening_data.review.SpouseName)} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.About_Family && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            About Family : <span className='fw-normal break-words'>{data.screening_data.review.About_Family} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.no_of_kids && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            No of Children : <span className='fw-normal break-words'>{data.screening_data.review.no_of_kids} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.TotalYearOfExp && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Total years of Experience : <span className='fw-normal break-words'>{(data.screening_data.review.TotalYearOfExp)}
                                            </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.CurrentLocation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Current Location : <span className='fw-normal break-words'>{data.screening_data.review.CurrentLocation} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.LanguagesKnown && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Languages know : <span className='fw-normal break-words'>{data.screening_data.review.LanguagesKnown} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.LastCTC && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Previous CTC : <span className='fw-normal break-words'>{data.screening_data.review.LastCTC} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.MeritalStatus && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Material Status : <span className='fw-normal break-words'>{data.screening_data.review.MeritalStatus} </span>  </p>
                                    </div>
                                }{
                                    data.screening_data && data.screening_data.review && data.screening_data.review.ModeOfCommutation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Mode of Transporation : <span className='fw-normal break-words'>{data.screening_data.review.ModeOfCommutation} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.Native && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Native : <span className='fw-normal break-words'>{data.screening_data.review.Native} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.PositionAppliedFor && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Position applied for : <span className='fw-normal break-words'>{data.screening_data.review.PositionAppliedFor} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.Residingat && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Resident At : <span className='fw-normal break-words'>{data.screening_data.review.Residingat} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.Screening_Status && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Screening Status : <span className='fw-normal break-words'>{data.screening_data.review.Screening_Status} </span>  </p>
                                    </div>
                                }
                                {
                                    data.screening_data && data.screening_data.review && data.screening_data.review.Comments && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                            Comments : <span className='fw-normal break-words'>{data.screening_data.review.Comments} </span>  </p>
                                    </div>
                                }
                            </section>

                        </div>
                    }
                    {/* INterview */}
                    {inid && <ClientINterviewDetails inid={inid} />}
                    {
                        data && data.interview_data && !inid && <main>
                            {data.interview_data.map((obj, index) => {
                                return (
                                    <main key={index}  >
                                        <hr className='border-1 border-blue-600  ' />
                                        <h4 className='text-violet-700 ' >Interview round {index + 1} ({obj.InterviewRoundName}) </h4>

                                        <section className='flex flex-wrap'>
                                            {obj.InterviewRoundName && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Round : <span className='fw-normal break-words'>{obj.InterviewRoundName} </span>
                                                </p></div>}
                                            {obj.InterviewDate && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Interviewed  Date : <span className='fw-normal break-words'>{(obj.InterviewDate)} </span>
                                                </p></div>}
                                            {obj.review && obj.review.InterviewerName && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Interviewer  Name : <span className='fw-normal break-words'>{(obj.review.InterviewerName)} </span>
                                                </p></div>}
                                            {obj.InterviewTime && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Time : <span className='fw-normal break-words'>{convertToNormalTime(obj.InterviewTime)} </span>
                                                </p>
                                            </div>}
                                            {obj.InterviewType && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Interview Mode : <span className='fw-normal break-words'>{(obj.InterviewType)} </span>
                                                </p>
                                            </div>}
                                            {obj.ScheduledOn && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Scheduled Date : <span className='fw-normal break-words'>{(obj.ScheduledOn)} </span>
                                                </p>
                                            </div>}
                                            {obj.ScheduledTime && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Scheduled Time : <span className='fw-normal break-words'>{convertToNormalTime(obj.ScheduledTime)} </span>
                                                </p>
                                            </div>}
                                            {obj.review && obj.review.interview_Status && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                    Interview Status : <span className='fw-normal break-words'>{(obj.review.interview_Status)} </span>
                                                </p>
                                            </div>}
                                        </section>
                                        <h5>Review : </h5>
                                        {obj.review &&
                                            <section className='flex flex-wrap '>
                                                {obj.review.ReviewedOn && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Reviewed Date & Time : <span className='fw-normal break-words'>{convertToReadableDateTime(obj.review.ReviewedOn)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.AbilityToTakeChallenges && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Ability To Take Challenges : <span className='fw-normal break-words'>
                                                            {(obj.review.AbilityToTakeChallenges)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.Comments && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Comments : <span className='fw-normal break-words'>
                                                            {(obj.review.Comments)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.Coding_Questions_Score && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Coding Questions Score : <span className='fw-normal break-words'>
                                                            {(obj.review.Coding_Questions_Score)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.AwarenessOnTechnicalDynamics && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Awareness On Technical Dynamics : <span className='fw-normal break-words'>{(obj.review.AwarenessOnTechnicalDynamics)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.CareerPlans && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Career Plans : <span className='fw-normal break-words'>{(obj.review.CareerPlans)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.ClarityOfThought && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Clarity Of Thought : <span className='fw-normal break-words'>{(obj.review.ClarityOfThought)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.CustomerService && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Customer Service : <span className='fw-normal break-words'>{(obj.review.CustomerService)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.EnglishLanguageSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        English Language Skills : <span className='fw-normal break-words'>{(obj.review.EnglishLanguageSkills)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.HandelTargets_Pressure && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Handel Targets Pressure : <span className='fw-normal break-words'>{(obj.review.HandelTargets_Pressure)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.InterpersonalSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Interpersonal Skills : <span className='fw-normal break-words'>{(obj.review.InterpersonalSkills)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.IntrestWithCompany && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Intrest With Company : <span className='fw-normal break-words'>{(obj.review.IntrestWithCompany)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.JobStabilityWithPreviousEmployers && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        JobStability With Previous Employers : <span className='fw-normal break-words'>{(obj.review.JobStabilityWithPreviousEmployers)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.ConfidenceLevel && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Confidence Level : <span className='fw-normal break-words'>{(obj.review.ConfidenceLevel)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.AchivementOrientation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Achivement Orientation : <span className='fw-normal break-words'>{(obj.review.AchivementOrientation)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.Analytical_and_logicalReasoningSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Analytical and logicalReasoningSkills : <span className='fw-normal break-words'>{(obj.review.Analytical_and_logicalReasoningSkills)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.Appearence_and_Personality && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Appearence and Personality : <span className='fw-normal break-words'>{(obj.review.Appearence_and_Personality)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.AgeGroupSuitability && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Age Group Suitability : <span className='fw-normal break-words'>{(obj.review.AgeGroupSuitability)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.LeadershipAbilities && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Leadership Abilities : <span className='fw-normal break-words'>{(obj.review.LeadershipAbilities)} </span>
                                                    </p>
                                                </div>}

                                                {obj.review.ProblemSolvingAbilites && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Problem Solving Abilites : <span className='fw-normal break-words'>{(obj.review.ProblemSolvingAbilites)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.ReasionForLeavingImadiateEmployeer && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Reasion For Leaving Imadiate Employeer : <span className='fw-normal break-words'>{(obj.review.ReasionForLeavingImadiateEmployeer)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.ResearchedAboutCompany && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Researched About Company : <span className='fw-normal break-words'>{(obj.review.ResearchedAboutCompany)} </span>
                                                    </p>
                                                </div>}
                                                {obj.review.OverallCandidateRanking && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Overall Candidate Ranking : <span className='fw-normal break-words'>{(obj.review.OverallCandidateRanking)} </span>
                                                    </p>
                                                </div>}

                                                {obj.review.RelocateToOtherCenters && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Relocate To Other Centers : <span className='fw-normal break-words'>{(obj.review.RelocateToOtherCenters)} </span>
                                                    </p>
                                                </div>
                                                }
                                                {obj.review.RelocateToOtherCity && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Relocate To Other City : <span className='fw-normal break-words'>{(obj.review.RelocateToOtherCity)} </span>
                                                    </p>
                                                </div>
                                                }
                                                {obj.review.Six_Days_Working && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Six Days Working : <span className='fw-normal break-words'>{(obj.review.Six_Days_Working)} </span>
                                                    </p>
                                                </div>
                                                }
                                                {obj.review.RelocateToOtherCenters && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                                                    <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                                        Relocate To Other Centers : <span className='fw-normal break-words'>{(obj.review.RelocateToOtherCenters)} </span>
                                                    </p>
                                                </div>
                                                }
                                            </section>}

                                    </main>
                                )
                            })}
                        </main>
                    }


                </Modal.Body>
                <Modal.Footer>
                    {(empStatus == 'Admin' || empStatus == 'HR' ||

                        userPermission.final_status_access)
                        && (rountstatus != 'Assigned' ||
                            page == 'candidate')
                        &&
                        <button
                            onClick={() => { setFinalStatus(show); setshow(false) }}
                            className='bg-blue-600 text-white rounded p-2'>
                            Final Status
                        </button>}
                    {
                        rountstatus == 'Assigned' &&
                        <button onClick={() => {
                            setinterviewReviewModal(true);
                            setshow(false)
                        }} className='bg-blue-600 text-white rounded p-2' >
                            Proceed
                        </button>
                    }
                    {/* {(empStatus == 'Admin' || empStatus == 'HR' || userPermission.interview_shedule_access) &&
                        <button onClick={() => { setFinalStatus(show); setshow(false) }} className='bg-slate-600 text-white rounded p-2'>
                            Assign Interview
                        </button>} */}

                </Modal.Footer>
            </Modal>}
            {/* <SchedulINterviewModalForm /> */}
            {data &&
                <FinalStatus show={finalStatus} getfunction={getfunction} rid={rid}
                    name={data.candidate_data.FirstName + " " + (data.candidate_data.LastName && data.candidate_data.LastName)}
                    setshow={setFinalStatus} />}

        </div>
    )
}

export default InterviewCompletedModal