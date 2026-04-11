import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import FinalResultShowTab from '../HomeComponent/FinalResultShowTab'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'
import InvoiceModal from './InvoiceModal'

const FinalResultCompleted = (props) => {
    let { show, setshow, id, inid } = props
    let { convertToReadableDateTime, convertToNormalTime } = useContext(HrmStore)
    let [allDetails, setAllDetails] = useState()
    let [showInvoice, setInvoice] = useState()
    let [listOption, setListOptions] = useState()
    let [selectedOption, setSelectedOption] = useState()
    let [joiningData, setJoiningData] = useState()
    let [dataShowing, setDataShowing] = useState()
    let reset = () => {
        setshow(false)
        setAllDetails(null)
        setListOptions(null)
        setSelectedOption(null)
        setDataShowing(null)
    }
    let getAllDetails = () => {
        axios.get(`${port}/root/CompleteFinalStatus/${id ? id : show.CandidateId}/`).then((response) => {
            console.log("helloww", Object.keys(response.data));
            console.log("helloww", (response.data));
            setAllDetails(response.data)
            setListOptions(Object.keys(response.data))
            setDataShowing(response.data[Object.keys(response.data)[0]])
            setSelectedOption(Object.keys(response.data)[0])
        }).catch((error) => {
            console.log("helloww", error);
        })
    }
    let getOfferDetails = (val) => {
        axios.get(`${port}/root/cms/client-joining/?interview_id=${inid}`).then((response) => {
            console.log(response.data, 'client details');
            setJoiningData(response.data.Joining_History)
            if (val == 'open') {
                setDataShowing(response.data.Joining_History)
                setSelectedOption('offer_history')
            }
        }).catch((error) => {
            console.log(error, 'client details');
        })
    }
    useEffect(() => {
        console.log("helloww", show);
        if (show) {
            getAllDetails()
        }
        if (inid)
            getOfferDetails()
    }, [show, inid])
    return (
        <div>
            {show && <Modal centered fullscreen show={show} onHide={() => reset()}>
                <Modal.Header closeButton>
                    Candidate Final Evaluation Report
                </Modal.Header>
                <Modal.Body className='inputbg ' >
                    <section className='ms-auto flex items-center justify-end'>
                        Data  :
                        <select name="" id="" value={selectedOption} onChange={(e) => {
                            if (e.target.value == 'offer_history')
                                setDataShowing(joiningData)
                            else
                                setDataShowing(allDetails[e.target.value])
                            setSelectedOption(e.target.value)
                        }}
                            className='outline-none p-1 ms-1 bgclr rounded '>
                            {listOption && listOption.map((val, index) => (
                                <option value={val}>{val} </option>
                            ))}
                            {joiningData && <option value="offer_history">Offer History </option>}
                        </select>
                    </section>
                    <main>
                        {
                            dataShowing && <article className='my-3 rounded p-3 bg-white shadow-sm ' >
                                <h6 className='uppercase '>{selectedOption && selectedOption.replace(/_/g, " ")} </h6>
                                {
                                    dataShowing.map((obj, index) => (
                                        <section className='row '>

                                            {console.log("hello1", obj)}
                                            {obj.FirstName && <FinalResultShowTab label="First Name" value={obj.FirstName} />}
                                            {obj.LastName && <FinalResultShowTab label="Last Name" value={obj.LastName} />}
                                            {obj.AppliedDate && <FinalResultShowTab label="Application Date" value={convertToReadableDateTime(obj.AppliedDate)} />}

                                            {obj.Gender && <FinalResultShowTab label="Gender" value={obj.Gender} />}
                                            {obj.AppliedDesignation && <FinalResultShowTab label="Applied Position" value={obj.AppliedDesignation} />}
                                            {obj.CandidateId && <FinalResultShowTab label="Candidate ID" value={obj.CandidateId} />}
                                            {obj.ContactedBy && <FinalResultShowTab label="Contacted By" value={obj.ContactedBy} />}
                                            {obj.DOB && <FinalResultShowTab label="Date of Birth" value={obj.DOB} />}
                                            {obj.Location && <FinalResultShowTab label="Current Location" value={obj.Location} />}
                                            {obj.PrimaryContact && <FinalResultShowTab label="Primary Contact Number" value={obj.PrimaryContact} />}
                                            {obj.SecondaryContact && <FinalResultShowTab label="Secondary Contact Number" value={obj.SecondaryContact} />}
                                            {obj.ExpectedSalary && <FinalResultShowTab label="Expected Salary" value={obj.ExpectedSalary} />}
                                            {obj.CurrentCTC && <FinalResultShowTab label="Current Salary" value={obj.CurrentCTC} />}
                                            {obj.JobPortalSource && <FinalResultShowTab label="Job Portal Source" value={obj.JobPortalSource} />}

                                            {obj.HighestQualification && <p className='fw-semibold '><hr /> Education Details </p>}
                                            {obj.HighestQualification && <FinalResultShowTab label="Highest Qualification" value={obj.HighestQualification} />}
                                            {obj.Specialization && <FinalResultShowTab label="Specialization" value={obj.Specialization} />}
                                            {obj.Percentage && <FinalResultShowTab label="Academic Performance (Percentage/GPA)" value={obj.Percentage} />}
                                            {obj.University && <FinalResultShowTab label="University/Institution Name" value={obj.University} />}
                                            {obj.YearOfPassout && <FinalResultShowTab label="Year of Graduation" value={obj.YearOfPassout} />}
                                            {/* Fresher */}
                                            {obj.Fresher && <p className='fw-semibold '><hr /> Fresher </p>}

                                            {/* {obj.Fresher && <FinalResultShowTab label="Fresher" value={obj.Fresher} />} */}
                                            {obj.TechnicalSkills && <FinalResultShowTab label="TechnicalSkills" value={obj.TechnicalSkills} />}
                                            {obj.SoftSkills && <FinalResultShowTab label="SoftSkills" value={obj.SoftSkills} />}
                                            {obj.GeneralSkills && <FinalResultShowTab label="General Skills" value={obj.GeneralSkills} />}

                                            {/* experience */}
                                            {obj.Experience && <p className='fw-semibold '><hr /> Work Experience </p>}
                                            {obj.CurrentDesignation && <FinalResultShowTab label="Current Job Title" value={obj.CurrentDesignation} />}
                                            {/* {obj.Experience && <FinalResultShowTab label="Experience" value={obj.Experience} />} */}
                                            {obj.GeneralSkills_with_Exp && <FinalResultShowTab label="General Skills with Exp" value={obj.GeneralSkills_with_Exp} />}
                                            {obj.NoticePeriod && <FinalResultShowTab label="Notice Period" value={obj.NoticePeriod} />}
                                            {obj.SoftSkills_with_Exp && <FinalResultShowTab label="Soft Skills with Exp" value={obj.SoftSkills_with_Exp} />}
                                            {obj.TechnicalSkills_with_Exp && <FinalResultShowTab label="Technical Skills with Exp" value={obj.TechnicalSkills_with_Exp} />}
                                            {obj.TotalExperience && <FinalResultShowTab label="Years of Experience" value={obj.TotalExperience} />}

                                            {/* Screening data */}
                                            {obj.screening_review && <div>
                                                <p className='fw-semibold '><hr /> Screening Overview</p>
                                            </div>}
                                            {obj.screening_review && obj.screening_review.Name && <FinalResultShowTab label="Candidate Name" value={obj.screening_review && obj.screening_review.Name} />}

                                            {obj.assigner_name && <FinalResultShowTab label="Assigned By" value={obj.assigner_name} />}
                                            {obj.Date_of_assigned && <FinalResultShowTab label="Date Assigned" value={convertToReadableDateTime(obj.Date_of_assigned)} />}
                                            {obj.recruiter_name && <FinalResultShowTab label="Assigned To" value={obj.recruiter_name} />}
                                            {obj.screening_review && obj.screening_review.ReviewedOn && <FinalResultShowTab label="Review Date" value={convertToReadableDateTime(obj.screening_review.ReviewedOn)} />}
                                            {obj.screening_review && obj.screening_review.Screening_Status && <FinalResultShowTab label="Screening Status" value={obj.screening_review && obj.screening_review.Screening_Status} />}
                                            {obj.screening_review && obj.screening_review.ReviewedBy && <FinalResultShowTab label="Reviewed By" value={obj.screening_review.ReviewedBy} />}
                                            {obj.screening_review && obj.screening_review.Signature && <FinalResultShowTab label="Signature By" value={obj.screening_review.Signature} />}

                                            {obj.screening_review && obj.screening_review.Comments && <FinalResultShowTab label="Reviewer Comments" cmnt={obj.screening_review.Comments} />}

                                            {obj.screening_review && (obj.screening_review.About_Family ||
                                                obj.screening_review.ModeOfCommutation || obj.screening_review.LanguagesKnown)
                                                && <p className='fw-semibold '><hr />  Candidate Details </p>}

                                            {obj.screening_review && obj.screening_review.CurrentLocation && <FinalResultShowTab label="Current Location" value={obj.screening_review && obj.screening_review.CurrentLocation} />}
                                            {obj.screening_review && obj.screening_review.DOJ && <FinalResultShowTab label="Date of Joining" value={obj.screening_review && obj.screening_review.DOJ} />}
                                            {obj.screening_review && obj.screening_review.LastCTC && <FinalResultShowTab label="Current Salary" value={obj.screening_review.LastCTC} />}
                                            {obj.screening_review && obj.screening_review.ExpectedCTC && <FinalResultShowTab label="Expected Salary" value={obj.screening_review.ExpectedCTC} />}
                                            {obj.screening_review && obj.screening_review.ModeOfCommutation && <FinalResultShowTab label="Preferred Mode of Commutation" value={obj.screening_review && obj.screening_review.ModeOfCommutation} />}
                                            {obj.screening_review && obj.screening_review.LanguagesKnown && <FinalResultShowTab label="Languages Known" value={obj.screening_review && obj.screening_review.LanguagesKnown} />}
                                            {obj.screening_review && obj.screening_review.Residingat && <FinalResultShowTab label="Residential Status" value={obj.screening_review && obj.screening_review.Residingat} />}
                                            {obj.screening_review && obj.screening_review.TotalYearOfExp && <FinalResultShowTab label="Total Year Of Experience" value={obj.screening_review.TotalYearOfExp} />}


                                            {/* About Family */}
                                            {obj.screening_review && obj.screening_review.About_Family && <p className='fw-semibold '><hr /> Family Background </p>}
                                            {obj.screening_review && obj.screening_review.MeritalStatus && <FinalResultShowTab label="Merital Status" value={obj.screening_review && obj.screening_review.MeritalStatus} />}
                                            {obj.screening_review && obj.screening_review.MothersDesignation && <FinalResultShowTab label="Mothers Designation" value={obj.screening_review && obj.screening_review.MothersDesignation} />}
                                            {obj.screening_review && obj.screening_review.MothersName && <FinalResultShowTab label="Mother sName" value={obj.screening_review && obj.screening_review.MothersName} />}
                                            {obj.screening_review && obj.screening_review.FathersDesignation && <FinalResultShowTab label="Fathers Designation" value={obj.screening_review && obj.screening_review.FathersDesignation} />}
                                            {obj.screening_review && obj.screening_review.FathersName && <FinalResultShowTab label="Fathers Name" value={obj.screening_review && obj.screening_review.FathersName} />}
                                            {obj.screening_review && obj.screening_review.About_Childrens && <FinalResultShowTab label="Children Details" value={obj.screening_review && obj.screening_review.About_Childrens} />}
                                            {obj.screening_review && obj.screening_review.About_Family && <FinalResultShowTab label="Family Background " value={obj.screening_review && obj.screening_review.About_Family} />}
                                            {obj.screening_review && obj.screening_review.Native && <FinalResultShowTab label="Hometown/Native" value={obj.screening_review && obj.screening_review.Native} />}
                                            {obj.screening_review && obj.screening_review.SpouseDesignation && <FinalResultShowTab label="Spouse’s Job Title" value={obj.screening_review.SpouseDesignation} />}
                                            {obj.screening_review && obj.screening_review.SpouseName && <FinalResultShowTab label="Spouse’s Name" value={obj.screening_review.SpouseName} />}
                                            {obj.screening_review && obj.screening_review.devorced_statement && <FinalResultShowTab label="Devorced statement" value={obj.screening_review.devorced_statement} />}
                                            {/* Company required */}
                                            {obj.screening_review && obj.screening_review.PositionAppliedFor &&
                                                <p className='fw-semibold '><hr />  Company Requirements </p>}

                                            {obj.screening_review && obj.screening_review.OwnLoptop && <FinalResultShowTab label="Laptop Availability" value={obj.screening_review && obj.screening_review.OwnLoptop} />}
                                            {obj.screening_review && obj.screening_review.NoticePeriod && <FinalResultShowTab label="Notice Period" value={obj.screening_review && obj.screening_review.NoticePeriod} />}
                                            {obj.screening_review && obj.screening_review.PositionAppliedFor && <FinalResultShowTab label="Position Applied For" value={obj.screening_review && obj.screening_review.PositionAppliedFor} />}
                                            {obj.screening_review && obj.screening_review.RelocateToOtherCenters && <FinalResultShowTab label="Open to Relocate (Centers)" value={obj.screening_review && obj.screening_review.RelocateToOtherCenters} />}
                                            {obj.screening_review && obj.screening_review.RelocateToOtherCity && <FinalResultShowTab label="Open to Relocate (Cities)" value={obj.screening_review && obj.screening_review.RelocateToOtherCity} />}
                                            {obj.screening_review && obj.screening_review.FlexibilityOnWorkTimings && <FinalResultShowTab label="Flexibility in Work Timings" value={obj.screening_review && obj.screening_review.FlexibilityOnWorkTimings} />}
                                            {obj.screening_review && obj.screening_review.Six_Days_Working && <FinalResultShowTab label="Availability for Six-Day Work Week" value={obj.screening_review.Six_Days_Working} />}

                                            {/* Interview rounds */}
                                            {obj.InterviewRoundName && <p className='fw-bold text-lg '> Round {index + 1} :
                                                <span className='text-uppercase '> {obj.InterviewRoundName.replace(/_/g, " ")}</span>
                                            </p>}
                                            {obj.InterviewDate && <FinalResultShowTab label='Interview Date' value={obj.InterviewDate} />}
                                            {obj.InterviewTime && <FinalResultShowTab label='Interview Time' value={convertToNormalTime(obj.InterviewTime)} />}
                                            {obj.InterviewType && <FinalResultShowTab label='Interview Type' value={obj.InterviewType} />}
                                            {obj.ScheduledOn && <FinalResultShowTab label='Scheduled On' value={obj.ScheduledOn} />}
                                            {/* INterview Review */}
                                            {obj.Intrview_review && obj.Intrview_review.ReviewedBy && <p className='fw-semibold'> <hr /> Review report </p>}
                                            {obj.Intrview_review && obj.Intrview_review.ReviewedBy && <FinalResultShowTab label="Reviewed By" value={obj.Intrview_review.ReviewedBy} />}
                                            {obj.Intrview_review && obj.Intrview_review.InterviewerName && <FinalResultShowTab label="Interviewer Name" value={obj.Intrview_review.InterviewerName} />}
                                            {obj.Intrview_review && obj.Intrview_review.ReviewedOn && <FinalResultShowTab label="Reviewed On" value={convertToReadableDateTime(obj.Intrview_review.ReviewedOn)} />}
                                            {obj.Intrview_review && obj.Intrview_review.interview_Status && <FinalResultShowTab label="Interview Status" value={obj.Intrview_review.interview_Status} />}
                                            {obj.Intrview_review && obj.Intrview_review.Comments && <FinalResultShowTab label="Comments" cmnt={obj.Intrview_review.Comments} />}



                                            {obj.Intrview_review && (obj.Intrview_review.OverallCandidateRanking || obj.Intrview_review.AbilityToTakeChallenges)
                                                && <p className='fw-semibold'> <hr />
                                                    Interview Marks
                                                </p>}
                                            {obj.Intrview_review && obj.Intrview_review.AbilityToTakeChallenges && <FinalResultShowTab label="Ability To Take Challenges" value={obj.Intrview_review.AbilityToTakeChallenges} />}
                                            {obj.Intrview_review && obj.Intrview_review.AchivementOrientation && <FinalResultShowTab label="Achivement Orientation" value={obj.Intrview_review.AchivementOrientation} />}
                                            {obj.Intrview_review && obj.Intrview_review.AgeGroupSuitability && <FinalResultShowTab label="Age Group Suitability" value={obj.Intrview_review.AgeGroupSuitability} />}
                                            {obj.Intrview_review && obj.Intrview_review.Analytical_and_logicalReasoningSkills && <FinalResultShowTab label="Analytical and logical Reasoning Skills" value={obj.Intrview_review.Analytical_and_logicalReasoningSkills} />}
                                            {obj.Intrview_review && obj.Intrview_review.Appearence_and_Personality && <FinalResultShowTab label="Appearence and Personality" value={obj.Intrview_review.Appearence_and_Personality} />}
                                            {obj.Intrview_review && obj.Intrview_review.AwarenessOnTechnicalDynamics && <FinalResultShowTab label="Awareness On Technical Dynamics" value={obj.Intrview_review.AwarenessOnTechnicalDynamics} />}

                                            {obj.Intrview_review && obj.Intrview_review.CareerPlans && <FinalResultShowTab label="Career Plans" value={obj.Intrview_review.CareerPlans} />}
                                            {obj.Intrview_review && obj.Intrview_review.ClarityOfThought && <FinalResultShowTab label="Clarity Of Thought" value={obj.Intrview_review.ClarityOfThought} />}
                                            {obj.Intrview_review && obj.Intrview_review.ConfidenceLevel && <FinalResultShowTab label="Confidence Level" value={obj.Intrview_review.ConfidenceLevel} />}
                                            {obj.Intrview_review && obj.Intrview_review.CustomerService && <FinalResultShowTab label="Customer Service" value={obj.Intrview_review.CustomerService} />}
                                            {obj.Intrview_review && obj.Intrview_review.EnglishLanguageSkills && <FinalResultShowTab label="English Language Skills" value={obj.Intrview_review.EnglishLanguageSkills} />}
                                            {obj.Intrview_review && obj.Intrview_review.HandelTargets_Pressure && <FinalResultShowTab label="Handel Targets Pressure" value={obj.Intrview_review.HandelTargets_Pressure} />}
                                            {obj.Intrview_review && obj.Intrview_review.InterpersonalSkills && <FinalResultShowTab label="Interpersonal Skills" value={obj.Intrview_review.InterpersonalSkills} />}
                                            {obj.Intrview_review && obj.Intrview_review.IntrestWithCompany && <FinalResultShowTab label="IntrestWithCompany" value={obj.Intrview_review.IntrestWithCompany} />}
                                            {obj.Intrview_review && obj.Intrview_review.JobStabilityWithPreviousEmployers && <FinalResultShowTab label="Job Stability With Previous Employers" value={obj.Intrview_review.JobStabilityWithPreviousEmployers} />}
                                            {obj.Intrview_review && obj.Intrview_review.LeadershipAbilities && <FinalResultShowTab label="Leadership Abilities" value={obj.Intrview_review.LeadershipAbilities} />}
                                            {obj.Intrview_review && obj.Intrview_review.ProblemSolvingAbilites && <FinalResultShowTab label="Problem Solving Abilites" value={obj.Intrview_review.ProblemSolvingAbilites} />}
                                            {obj.Intrview_review && obj.Intrview_review.ReasionForLeavingImadiateEmployeer && <FinalResultShowTab label="Reasion For Leaving Imadiate Employeer" value={obj.Intrview_review.ReasionForLeavingImadiateEmployeer} />}
                                            {obj.Intrview_review && obj.Intrview_review.RelatedExperience && <FinalResultShowTab label="Related Experience" value={obj.Intrview_review.RelatedExperience} />}
                                            {obj.Intrview_review && obj.Intrview_review.ResearchedAboutCompany && <FinalResultShowTab label="Researched About Company" value={obj.Intrview_review.ResearchedAboutCompany} />}


                                            {obj.Intrview_review && obj.Intrview_review.OverallCandidateRanking && <FinalResultShowTab label="Overall Candidate Marks" value={obj.Intrview_review.OverallCandidateRanking} />}
                                            {/* Final Result */}


                                            {obj.Final_Result && <FinalResultShowTab label='Final Result' value={obj.Final_Result} />}
                                            {obj.ReviewedBy && <FinalResultShowTab label='Reviewed By' value={obj.ReviewedBy} />}

                                            {obj.ReviewedOn && <FinalResultShowTab label='Reviewed On' value={convertToReadableDateTime(obj.ReviewedOn)} />}


                                            {obj.Comments && <FinalResultShowTab label='Comments' cmnt={obj.Comments} />}
                                            {/* Document */}
                                            {obj.Provious_Company && <p className='fw-bold text-lg' >Company {index + 1} </p>}
                                            {obj.Provious_Company && <FinalResultShowTab label=" Company" value={obj.Provious_Company} />}
                                            {obj.Current_CTC && <FinalResultShowTab label="CTC" value={obj.Current_CTC} />}
                                            {obj.Provious_Designation && <FinalResultShowTab label=" Designation" value={obj.Provious_Designation} />}
                                            {obj.HR_email && <FinalResultShowTab label="HR email" value={obj.HR_email} />}
                                            {obj.HR_name && <FinalResultShowTab label="HR name" value={obj.HR_name} />}
                                            {obj.HR_phone && <FinalResultShowTab label="HR phone" value={obj.HR_phone} />}
                                            {obj.ReportingManager_phone && <FinalResultShowTab label="ReportingManager phone" value={obj.ReportingManager_phone} />}
                                            {obj.Reporting_Manager_email && <FinalResultShowTab label="Reporting Manager email" value={obj.Reporting_Manager_email} />}

                                            {obj.Reporting_Manager_name && <FinalResultShowTab label="Reporting Manager name" value={obj.Reporting_Manager_name} />}
                                            {/* Experience in that comapny */}
                                            {obj.experience && <p className='fw-semibold '><hr /> Duration </p>}
                                            {obj.experience && <FinalResultShowTab label="experience" value={obj.experience} />}
                                            {obj.from_date && <FinalResultShowTab label="From date" value={obj.from_date} />}
                                            {obj.To_date && <FinalResultShowTab label="To date" value={obj.To_date} />}

                                            {obj.bg_verification && <p className='fw-semibold'><hr /> Background Verification    </p>}
                                            {obj.bg_verification && obj.bg_verification.CandidateDesignation && <FinalResultShowTab label="Candidate Designation" value={obj.bg_verification && obj.bg_verification.CandidateDesignation} />}
                                            {obj.bg_verification && obj.bg_verification.CandidateKnows && <FinalResultShowTab label="Candidate Knows" value={obj.bg_verification && obj.bg_verification.CandidateKnows} />}
                                            {obj.bg_verification && obj.bg_verification.CandidateNegatives && <FinalResultShowTab label="Candidate Negatives" value={obj.bg_verification && obj.bg_verification.CandidateNegatives} />}
                                            {obj.bg_verification && obj.bg_verification.CandidatePerformanceLevel && <FinalResultShowTab label="Candidate Performance Level" value={obj.bg_verification && obj.bg_verification.CandidatePerformanceLevel} />}
                                            {obj.bg_verification && obj.bg_verification.CandidatePositives && <FinalResultShowTab label=" Candidate Positives" value={obj.bg_verification && obj.bg_verification.CandidatePositives} />}
                                            {obj.bg_verification && obj.bg_verification.CandidateReportingTo && <FinalResultShowTab label="Candidate Reporting To" value={obj.bg_verification && obj.bg_verification.CandidateReportingTo} />}
                                            {obj.bg_verification && obj.bg_verification.CandidateWorksFrom && <FinalResultShowTab label="Candidate Works From" value={obj.bg_verification && obj.bg_verification.CandidateWorksFrom} />}
                                            {obj.bg_verification && obj.bg_verification.Candidate_Behavior_Feedback && <FinalResultShowTab label="Candidate Behavior Feedback" value={obj.bg_verification && obj.bg_verification.Candidate_Behavior_Feedback} />}
                                            {obj.bg_verification && obj.bg_verification.Candidate_Leaving_Reason && <FinalResultShowTab label="Candidate Leaving Reason" value={obj.bg_verification && obj.bg_verification.Candidate_Leaving_Reason} />}
                                            {obj.bg_verification && obj.bg_verification.Candidate_Rehire && <FinalResultShowTab label="Candidate Rehire" value={obj.bg_verification && obj.bg_verification.Candidate_Rehire} />}
                                            {obj.bg_verification && obj.bg_verification.CandidatesPerformanceFeedBack && <FinalResultShowTab label="Candidates Performance FeedBack" value={obj.bg_verification && obj.bg_verification.CandidatesPerformanceFeedBack} />}
                                            {obj.bg_verification && obj.bg_verification.Candidates_Achieve_Targets && <FinalResultShowTab label="Candidates Achieve Targets" value={obj.bg_verification && obj.bg_verification.Candidates_Achieve_Targets} />}
                                            {obj.bg_verification && obj.bg_verification.Candidates_ability && <FinalResultShowTab label="Candidates ability" value={obj.bg_verification && obj.bg_verification.Candidates_ability} />}
                                            {obj.bg_verification && obj.bg_verification.Comments_On_Candidate && <FinalResultShowTab label="Comments On Candidate" cmnt={obj.bg_verification && obj.bg_verification.Comments_On_Candidate} />}
                                            {obj.bg_verification && obj.bg_verification.Ever_Handled_Team && <FinalResultShowTab label="Ever Handled Team" value={obj.bg_verification && obj.bg_verification.Ever_Handled_Team} />}
                                            {obj.bg_verification && obj.bg_verification.TeamSize && <FinalResultShowTab label="Team Size" value={obj.bg_verification && obj.bg_verification.TeamSize} />}

                                            {obj.bg_verification && obj.bg_verification.FinalVerifyStatus && <FinalResultShowTab label="Final Verify Status" value={obj.bg_verification && obj.bg_verification.FinalVerifyStatus} />}
                                            {obj.bg_verification && obj.bg_verification.PackageOffered && <FinalResultShowTab label="Package Offered" value={obj.bg_verification && obj.bg_verification.PackageOffered} />}
                                            {obj.bg_verification && obj.bg_verification.VerifiersDesignation && <FinalResultShowTab label="Verifiers Designation" value={obj.bg_verification && obj.bg_verification.VerifiersDesignation} />}
                                            {obj.bg_verification && obj.bg_verification.VerifiersEmployer && <FinalResultShowTab label="Verifiers Employer" value={obj.bg_verification && obj.bg_verification.VerifiersEmployer} />}
                                            {obj.bg_verification && obj.bg_verification.VerifiersPhoneNumber && <FinalResultShowTab label="Verifiers PhoneNumber" value={obj.bg_verification && obj.bg_verification.VerifiersPhoneNumber} />}

                                            {obj.bg_verification && obj.bg_verification.Remarks && <FinalResultShowTab label="Remarks" cmnt={obj.bg_verification && obj.bg_verification.Remarks} />}

                                            {obj.Document && <p className='fw-semibold '><hr /> Documents to download </p>}
                                            {obj.Document && <FinalResultShowTab label="Document" link={obj.Document} />}
                                            {obj.Salary_Drawn_Payslips && <FinalResultShowTab label="Salary Drawn Payslips" link={obj.Salary_Drawn_Payslips} />}

                                            {/* Offer letter map */}
                                            {obj.due_date && <FinalResultShowTab label="Due Date" value={obj.due_date} />}
                                            {obj.CTC && <FinalResultShowTab label="Salary Assigned" value={obj.CTC} />}
                                            {obj.commisition_percentage && <FinalResultShowTab label="Commission Percentage" value={obj.commisition_percentage} />}
                                            {obj.gst_percentage && <FinalResultShowTab label="GST percentage" value={obj.gst_percentage} />}
                                            {obj.joining_date && <FinalResultShowTab label="Joining Date" value={obj.joining_date} />}
                                            {obj.remarks && <FinalResultShowTab label="Remark" value={obj.remarks} />}
                                            {obj.is_active && !obj.is_invoice_created &&
                                                <div className='my-2 text-sm flex gap-2 justify-betwee col-md-6 ' >
                                                    <label htmlFor="" className={` text-sm poppins w-[11rem] break-words  fw-medium text-slate-600 `}> Invoice  </label>
                                                    {!obj.is_invoice_created && <button onClick={() => {
                                                        axios.get(`${port}/root/cms/client-requirement-invoice-generate?interview_id=${inid}`).then((response) => {
                                                            console.log(response.data);
                                                            toast.success('Generated')
                                                            getOfferDetails('open')
                                                        }).catch((error) => {
                                                            console.log(error);
                                                            toast.error('Error occured')
                                                        })
                                                    }} className=' bluebtn p-2 rounded ' >
                                                        Generate Invoice
                                                    </button>}
                                                </div>
                                            }
                                            {obj.is_invoice_created &&
                                                <div className='my-2 text-sm flex gap-2 justify-betwee col-md-6 ' >
                                                    <label htmlFor="" className={` text-sm poppins w-[11rem] break-words  fw-medium text-slate-600 `}> Invoice  </label>
                                                    <button onClick={() => setInvoice(true)} className='bluebtn p-2 rounded  ' >
                                                        view  Invoice
                                                    </button>
                                                </div>
                                            }

                                            <hr />

                                        </section>
                                    ))
                                }
                            </article>
                        }
                    </main>
                </Modal.Body>

            </Modal>
            }
            <InvoiceModal inid={inid} show={showInvoice} setshow={setInvoice} />
        </div>
    )
}

export default FinalResultCompleted