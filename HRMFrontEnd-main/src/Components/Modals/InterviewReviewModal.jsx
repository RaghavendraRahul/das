import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { useParams } from 'react-router-dom'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'

const InterviewReviewModal = ({ show, setshow, getData, client, inid }) => {
  let { id } = useParams()
  let [status, setStatus] = useState()
  const [final_status_value, setfinal_status_value] = useState("")
  let [username, setuserName] = useState("")
  // JSON.parse(sessionStorage.getItem('user')).UserName
  let [persondata, setPersondata] = useState()
  const [selectstatus, setselectstatus] = useState(false)
  const [date1, setDate1] = useState('');
  const [comments, setComments] = useState('');
  const [DOJ, setDOJ] = useState('');
  const [certificationSubmission, setCertificationSubmission] = useState('');
  const [relocationToCity, setRelocationToCity] = useState('');
  const [relocationToCenters, setRelocationToCenters] = useState('');
  const [signature, setSignature] = useState('');
  const [sixDaysWorking, setsixDaysWorking] = useState('')
  const [experience, setExperience] = useState('');
  const [jobStability, setJobStability] = useState('');
  const [reasonLeaving, setReasonLeaving] = useState('');
  const [appearancePersonality, setAppearancePersonality] = useState('');
  const [clarityThought, setClarityThought] = useState('');
  const [englishSkills, setEnglishSkills] = useState('');
  const [technicalAwareness, setTechnicalAwareness] = useState('');
  const [interpersonalSkills, setInterpersonalSkills] = useState('');
  const [confidenceLevel, setConfidenceLevel] = useState('');
  const [ageGroup, setAgeGroup] = useState('');
  const [logicalReasoning, setLogicalReasoning] = useState('');
  const [careerPlans, setCareerPlans] = useState('');
  const [achievementOrientation, setAchievementOrientation] = useState('');
  const [driveProblemSolving, setDriveProblemSolving] = useState('');
  const [takeUpChallenges, setTakeUpChallenges] = useState('');
  const [leadershipAbilities, setLeadershipAbilities] = useState('');
  const [companyInterest, setCompanyInterest] = useState('');
  const [researchCompany, setResearchCompany] = useState('');
  const [targetPressure, setTargetPressure] = useState('');
  const [customerService, setCustomerService] = useState('');
  const [overallRanking, setOverallRanking] = useState('');
  let [interviewRoundType, setInterviewRoundType] = useState('')
  const [codeans, setCodeAns] = useState()
  let { testing, convertToReadableDateTime, timeValidate, getCurrentDate } = useContext(HrmStore)
  let [carrylaptop, setcarrylaptop] = useState(false)
  let [interviewlist, setInterviewlist] = useState([])
  const [Interviewstatus, setInterviewStatus] = useState('');
  let [loading, setloading] = useState(false)
  useEffect(() => {
    let count = 0
    if (Number(jobStability) > 0)
      count++
    if (Number(codeans) > 0)
      count++
    if (Number(appearancePersonality) > 0)
      count++
    if (Number(clarityThought) > 0)
      count++
    if (Number(englishSkills) > 0)
      count++
    if (Number(technicalAwareness) > 0)
      count++
    if (Number(interpersonalSkills) > 0)
      count++
    if (Number(confidenceLevel) > 0)
      count++
    if (Number(logicalReasoning) > 0)
      count++
    if (Number(driveProblemSolving) > 0)
      count++
    if (Number(takeUpChallenges) > 0)
      count++
    if (Number(leadershipAbilities) > 0)
      count++
    if (Number(targetPressure) > 0)
      count++
    if (Number(customerService) > 0)
      count++
    if (count > 1) {
      console.log(count);
      let avg = (((Number(jobStability) + Number(englishSkills) + Number(technicalAwareness) + Number(confidenceLevel)
        + Number(interpersonalSkills) + Number(logicalReasoning) + Number(driveProblemSolving) + Number(takeUpChallenges)
        + Number(leadershipAbilities) + Number(targetPressure) + Number(customerService) + Number(codeans ? codeans : 0)
        + Number(appearancePersonality) + Number(clarityThought)) / count)).toFixed(2)
      setOverallRanking(avg)
      console.log(avg);
    }
    console.log(count);
  }, [codeans, jobStability, customerService, targetPressure, leadershipAbilities,
    takeUpChallenges, driveProblemSolving,
    confidenceLevel, logicalReasoning, driveProblemSolving, appearancePersonality,
    clarityThought, englishSkills,
    technicalAwareness, interpersonalSkills])
  useEffect(() => {
    if (id || inid) {
      axios.get(`${port}/root/InterviewScheduledCandidate/${inid ? inid : id}/`).then((response) => {
        console.log(response.data, 'getinterview');
        setPersondata(response.data.candidate_data)
        setInterviewRoundType(response.data.InterviewRoundName)
        setStatus(response.data.status)
      }).catch((error) => {
        console.log(error);
      })
    }
  }, [id, inid])
  let handleproceedingform = (e) => {
    e.preventDefault();
    let formData1 = new FormData()
    // formData1.append('login_user', Empid);
    formData1.append('id', inid ? inid : id);
    formData1.append('CandidateId', persondata.id);
    formData1.append('Can_Id', persondata.CandidateId);
    formData1.append('Name', persondata.FirstName);
    formData1.append('PositionAppliedFor', persondata.AppliedDesignation);
    formData1.append('SourceBy', persondata.JobPortalSource);
    formData1.append('Date', persondata.AppliedDate);
    formData1.append('LocationAppliedFor', persondata.AppliedDesignation);
    formData1.append('SourceName', persondata.JobPortalSource);
    formData1.append('OwnLoptop', carrylaptop)
    formData1.append('Qualification', persondata.HighestQualification);
    formData1.append('RelatedExperience', experience);
    formData1.append('JobStabilityWithPreviousEmployers', jobStability);
    formData1.append('ReasionForLeavingImadiateEmployer', reasonLeaving);
    formData1.append('Coding_Questions_Score', codeans)
    formData1.append('Appearence_and_Personality', appearancePersonality);
    formData1.append('ClarityOfThought', clarityThought);
    formData1.append('EnglishLanguageSkills', englishSkills);
    formData1.append('AwarenessOnTechnicalDynamics', technicalAwareness);
    formData1.append('InterpersonalSkills', interpersonalSkills);
    formData1.append('ConfidenceLevel', confidenceLevel);
    formData1.append('AgeGroupSuitability', ageGroup);
    formData1.append('Analytical_and_logicalReasoningSkills', logicalReasoning);
    formData1.append('CareerPlans', careerPlans);
    formData1.append('AchivementOrientation', achievementOrientation);
    formData1.append('ProblemSolvingAbilites', driveProblemSolving);
    formData1.append('AbilityToTakeChallenges', takeUpChallenges);
    formData1.append('LeadershipAbilities', leadershipAbilities);
    formData1.append('IntrestWithCompany', companyInterest);
    formData1.append('ResearchedAboutCompany', researchCompany);
    formData1.append('HandelTargets_Pressure', targetPressure);
    formData1.append('CustomerService', customerService);
    formData1.append('OverallCandidateRanking', overallRanking);
    formData1.append('Six_Days_Working', sixDaysWorking);
    formData1.append('LastCTC', persondata.CurrentCTC);
    formData1.append('ExpectedCTC', persondata.ExpectedSalary);
    formData1.append('NoticePeriod', persondata.NoticePeriod);
    formData1.append('DOJ', DOJ);
    formData1.append('CertificateSubmittion', certificationSubmission);

    formData1.append('RelocateToOtherCity', relocationToCity);
    formData1.append('RelocateToOtherCenters', relocationToCenters);
    formData1.append('interview_Status', Interviewstatus);
    formData1.append('ReviewedBy', username);
    formData1.append('InterviewerName', username);
    formData1.append('Signature', signature);
    formData1.append('ReviewedDate', date1);
    formData1.append('Comments', comments);


    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }
    setloading(true)

    if (username != '' && Interviewstatus != '' && comments != '') {
      axios.post(`${port}/root/InterviewReviewData`, formData1)
        .then((r) => {
          toast.success("Proceding Form Data Successfull")
          console.log("Proceding Form Data Successfull", r.data)
          setloading(false)
          if (setshow)
            setshow(false)
          if (getData)
            getData()
          setTimeout(() => {
            window.close()
          }, 4000);
        })
        .catch((err) => {
          if (err.response.data) {
            toast.error(err.response.data)
          }
          else { toast.error('Proceding Form Data Failed') }
          console.log("Interview Assessment Form Error", err)
          setloading(false)
        })
    }
    else {
      toast.warning('Enter the Required Field')
      setloading(false)
    }
  }

  return (
    <main>

      <div class=" container mx-auto">
        <div className=' d-flex justify-content-center w-100'>
          <h3 className='text-primary text-center'>INTERVIEW FORM</h3>
        </div>
      </div>
      {
        status == 'Completed' && !inid && <main>
          <div className='col-lg-6 p-4 my-4 bg-slate-50 border-2 border-white mx-auto rounded-xl  '>
            <h5 className='text-center  '>
              Review has been already submitted for this Interview.
            </h5>
          </div>
        </main>
      }
      {(status != 'Completed' || inid) && <main class="container">
        <form>
          {/* Top inputs  start */}

          <div className="row bg-white rounded shadow-sm justify-content-center m-0">
            <div className="col-lg-12 p-4 border rounded-lg">
              <div className="row m-0 pb-2">
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="Name" className="form-label">Canditate Id </label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={`${persondata && persondata.CandidateId}`} />
                </div>
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="Name" className="form-label">Name </label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={`${persondata && persondata.FirstName}`} />
                </div>
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="lastName" className="form-label">Position Applied For</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName"
                    name="LastName" value={persondata && persondata.AppliedDesignation} />
                </div>
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="email" className="form-label">Source By</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Email" name="Email" value={persondata && persondata.ContactedBy} />
                </div>
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="primaryContact" className="form-label"> Date</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact"
                    value={persondata && convertToReadableDateTime(persondata.AppliedDate)} />
                </div>
                {/* <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact"
                   value={persondata && persondata.AppliedDesignation} />
                </div> */}
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata && persondata.JobPortalSource} />
                </div>
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="secondaryContact" className="form-label">Mobile Number</label>
                  <input type="tel" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata && persondata.PrimaryContact} />
                </div>
              </div>
            </div>
          </div>
          {/* Top inputs  end */}


          {/* all inputs start */}
          <div className="row bg-white rounded shadow-sm justify-content-center m-0 mt-4">
            <div className="col-lg-12 flex flex-wrap  p-4 border rounded-lg">
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="qualification" className="form-label">Education qualification:</label>
                <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="qualification"
                  value={persondata && persondata.HighestQualification} />
              </div>
              {persondata && persondata && !persondata.Fresher && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="experience" className="form-label" >Related Experience:</label>
                <input type="number" placeholder='In years '
                  className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="experience"
                  value={persondata && persondata.TotalExperience} />
              </div>}
              {interviewRoundType == 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="" className="form-label">Coding questions score (1-5) :</label>
                <input type="number" placeholder='1-5 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id=""
                  value={codeans} onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setCodeAns("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setCodeAns(5)
                      return
                    }
                    else
                      setCodeAns(e.target.value)
                  }} />
              </div>}
              {interviewRoundType != 'technical_round' &&
                <div className="col-md-6 col-lg-4 p-3 mb-3">
                  <label htmlFor="jobStability" className="form-label">Job Stability with Previous Employer (1-5) :</label>
                  <input type="number" placeholder='1-5 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="jobStability"
                    value={jobStability} onChange={(e) => {

                      if (Number(e.target.value) <= 0) {
                        setJobStability("")
                        return
                      }
                      if (Number(e.target.value) > 5) {
                        setJobStability(5)
                        return
                      }
                      else
                        setJobStability(e.target.value)
                    }} />
                </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="reasonLeaving" className="form-label">Reason For Leaving previous employer:</label>
                <input type="text" placeholder='Looking for the different oppertunity ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="reasonLeaving"
                  value={reasonLeaving} onChange={(e) => setReasonLeaving(e.target.value)} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="appearancePersonality" className="form-label">Appearance & Personality (1-5) :</label>
                <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="appearancePersonality"
                  value={appearancePersonality}
                  placeholder='1-5'
                  onChange={(e) => {

                    if (Number(e.target.value) <= 0) {
                      setAppearancePersonality("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setAppearancePersonality(5)
                      return
                    }
                    else
                      setAppearancePersonality(e.target.value)

                  }} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="clarityThought" className="form-label">Clarity of Thought (1-5) :</label>
                <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                  id="clarityThought" value={clarityThought} placeholder='1-5'
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setClarityThought("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setClarityThought(5)
                      return
                    }
                    else
                      setClarityThought(e.target.value)

                  }} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="englishSkills" className="form-label">English Language Skills (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="englishSkills" value={englishSkills}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setEnglishSkills("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setEnglishSkills(5)
                      return
                    }
                    else
                      setEnglishSkills(e.target.value)
                  }} />
              </div>}
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="technicalAwareness" className="form-label">Awareness on Technical Dynamics (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="technicalAwareness" value={technicalAwareness}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setTechnicalAwareness("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setTechnicalAwareness(5)
                      return
                    }
                    else
                      setTechnicalAwareness(e.target.value)
                  }} />
              </div>
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="interpersonalSkills" className="form-label">Interpersonal Skills / Attitude (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="interpersonalSkills"
                  value={interpersonalSkills} onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setInterpersonalSkills("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setInterpersonalSkills(5)
                      return
                    }
                    else
                      setInterpersonalSkills(e.target.value)
                  }
                  } />
              </div>}
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="confidenceLevel" className="form-label">Confidence Level (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="confidenceLevel"
                  value={confidenceLevel} onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setConfidenceLevel("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setConfidenceLevel(5)
                      return
                    }
                    else
                      setConfidenceLevel(e.target.value)
                  }} />
              </div>
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="ageGroup" className="form-label">Age Group Suitability  :</label>
                <select className="form-select" id="ageGroup" value={ageGroup} onChange={(e) => setAgeGroup(e.target.value)}>
                  <option value="">Select</option>
                  <option value="yes">Yes</option>
                  <option value="no">No</option>
                </select>
              </div>}

              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="logicalReasoning" className="form-label">Analytical & Logical Reasoning Skills (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="logicalReasoning" value={logicalReasoning}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setLogicalReasoning("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setLogicalReasoning(5)
                      return
                    }
                    else
                      setLogicalReasoning(e.target.value)
                  }} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3                 ">
                <label htmlFor="careerPlans" className="form-label">Career Plans:</label>
                <input type="text" placeholder='Looking forward to the future' className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                  id="careerPlans" value={careerPlans} onChange={(e) => setCareerPlans(e.target.value)} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="achievementOrientation" className="form-label">Achievement Orientation  :</label>
                <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                  placeholder='type here..' id="achievementOrientation" value={achievementOrientation} onChange={(e) => setAchievementOrientation(e.target.value)} />
              </div>}
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="driveProblemSolving" className="form-label">Drive / Problem Solving Abilities (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="driveProblemSolving" value={driveProblemSolving}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setDriveProblemSolving("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setDriveProblemSolving(5)
                      return
                    }
                    else
                      setDriveProblemSolving(e.target.value)
                  }} />
              </div>
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="takeUpChallenges" className="form-label">Ability to Take Up Challenges (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="takeUpChallenges" value={takeUpChallenges}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setTakeUpChallenges("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setTakeUpChallenges(5)
                      return
                    }
                    else
                      setTakeUpChallenges(e.target.value)
                  }} />
              </div>
              <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="leadershipAbilities" className="form-label">Leadership Abilities (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="leadershipAbilities" value={leadershipAbilities}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setLeadershipAbilities("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setLeadershipAbilities(5)
                      return
                    }
                    else
                      setLeadershipAbilities(e.target.value)
                  }} />
              </div>
              {/* {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="companyInterest" className="form-label">Interest With The Company:</label>
                <select className="form-select" id="companyInterest" value={companyInterest} onChange={(e) => setCompanyInterest(e.target.value)}>
                  <option value="">Select</option>
                  <option value="yes">Yes</option>
                  <option value="no">No</option>
                </select>
              </div>} */}

              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                <label htmlFor="researchCompany" className="form-label">Researched About The Company:</label>
                <select className="form-select" id="researchCompany" value={researchCompany} onChange={(e) => setResearchCompany(e.target.value)}>
                  <option value="">Select</option>
                  <option value="yes">Yes</option>
                  <option value="no">No</option>
                </select>
              </div>}

              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                <label htmlFor="targetPressure" className="form-label">Ability to Handle Targets / Pressure (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="targetPressure" value={targetPressure}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setTargetPressure("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setTargetPressure(5)
                      return
                    }
                    else
                      setTargetPressure(e.target.value)
                  }} />
              </div>}
              {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                <label htmlFor="customerService" className="form-label">Customer Service (1-5) :</label>
                <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="customerService" value={customerService}
                  onChange={(e) => {
                    if (Number(e.target.value) <= 0) {
                      setCustomerService("")
                      return
                    }
                    if (Number(e.target.value) > 5) {
                      setCustomerService(5)
                      return
                    }
                    else
                      setCustomerService(e.target.value)
                  }} />
              </div>}
              <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                <label htmlFor="overallRanking" className="form-label">Overall Candidate Ranking (1 to 5):</label>
                <input type="number" disabled={true} className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="overallRanking"
                  value={overallRanking}
                  onChange={(e) => setOverallRanking(e.target.value)} />
              </div>
            </div>
          </div>                {/* all inputs End */}

          {/* For HRD Use only start */}
          {/* {interviewRoundType == 'hr_round' && <h6 className='mt-4 text-primary'>For HRD Use Only</h6>}
                  {interviewRoundType == 'hr_round' &&
                    <div className="row justify-content-center m-0 mt-4">
                      <div className="col-lg-12 p-4 border rounded-lg">
                        <div className="row m-0 pb-2">
                          {persondata&& persondata.CurrentCTC && < div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="Name" className="form-label">Last CTC </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastCTC" name="LastCTC"
                              value={persondata&& persondata.CurrentCTC} />
                          </div>}
                          <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="lastName" className="form-label">Expected CTC</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="ExpectedCTC" name="ExpectedCTC"
                              value={persondata&& persondata.ExpectedSalary} />
                          </div>
                          {persondata&& persondata.NoticePeriod && <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="email" className="form-label">Notice Period</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="NoticePeriod" name="NoticePeriod"
                              value={persondata&& persondata.NoticePeriod} />
                          </div>}
                          <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="primaryContact" className="form-label">DOJ</label>
                            <input type="date" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="DOJ" name="DOJ" value={DOJ} onChange={(e) => setDOJ(e.target.value)} />
                          </div>
                        </div>

                        <div className="row m-0 pb-2 mt-4">

                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label text-success">6 Days Working:</label>
                            <select className="form-select " id="ageGroup" value={sixDaysWorking} onChange={(e) => setsixDaysWorking(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label text-success">Flexibility on Working Timings:</label>
                            <select className="form-select " id="ageGroup" value={FlexibilityonWorkingTimings} onChange={(e) => setFlexibilityonWorkingTimings(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                        </div>

                        <div className="row m-0 pb-2 mt-4">



                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Certification Submission</label>
                            <select className="form-select " id="ageGroup" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} >
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>

                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Relocation to other city:</label>
                            <select className="form-select " id="ageGroup" value={relocationToCity} onChange={(e) => setRelocationToCity(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Able to carry the laptop:</label>
                            <select className="form-select " id="ageGroup" value={carrylaptop} onChange={(e) => setcarrylaptop(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>

                          <div className="mb-3 col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Relocation to other centers:</label>
                            <select className="form-select" id="ageGroup" value={relocationToCenters} onChange={(e) => setRelocationToCenters(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                        </div>
                      </div>
                    </div>
                  } */}

          {/* For HRD Use only end */}


          {/* Personal Details start */}

          {/* <h6 className='mt-4 text-primary'>Personal Details</h6>
                    <div className="row justify-content-center m-0 mt-4">
                      <div className="col-lg-12 p-4 border rounded-lg">
                        <div className="row m-0 pb-2">
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Father Designation </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={Fatherdesignation} onChange={(e) => setFatherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Mother Designation </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={Motherdesignation} onChange={(e) => setMotherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="lastName" className="form-label">Number Of Sibilings</label>
                            <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName" name="LastName" value={Numberofsib} onChange={(e) => setNumberofsib(e.target.value)} />
                          </div>

                          <div className="mb-3 col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Merital Status</label>
                            <select className="form-select" id="ageGroup" value={Meritalstatus} onChange={(e) => setMeritalStatus(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Single</option>
                              <option value="no">Marrid</option>
                              <option value="no">Widowed</option>
                              <option value="no">Divorced</option>
                            </select>
                          </div>

                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="primaryContact" className="form-label">Spouse Designation</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Languages Known</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={LanguagesKnown} onChange={(e) => setLanguagesKnown(e.target.value)} />
                          </div>


                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Current Location</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={CurrentLocation} onChange={(e) => setCurrentLocation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">TravellBy</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={TravellBy} onChange={(e) => setTravellBy(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Stay With</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={StayWith} onChange={(e) => setStayWith(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Native</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={Native} onChange={(e) => setNative(e.target.value)} />
                          </div>

                        </div>
                      </div>
                    </div> */}


          {/* Personal Details end */}

          {/* Comments Start  */}
          <h6 className='mt-4 text-primary'>Comments</h6>
          <div className="row bg-white rounded shadow-sm justify-content-center m-0 mt-4">
            <div className="col-lg-12 p-4 border rounded-lg">
              <div className="row m-0 pb-2">
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="InterviewerName" className="form-label">Interviewer Name <span className='text-red-500 '>*</span> </label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="InterviewerName"
                    name="InterviewerName" onChange={(e) => setuserName(e.target.value)} value={username} />
                </div>
                {/* <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Signature" className="form-label">Signature</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Signature" name="Signature" value={signature} onChange={(e) => setSignature(e.target.value)} />
                        </div> */}
                <div className="col-md-6 col-lg-4 mb-3">
                  <label htmlFor="Date" className="form-label">Interview Date</label>
                  <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Date"
                    name="Date" value={getCurrentDate()} onChange={(e) => setDate1(e.target.value)} />
                </div>
                <div className="mb-3 col-md-6 col-lg-4">
                  <label htmlFor="ageGroup" className="form-label">Interview Status : <span className='text-red-500 '>*</span></label>
                  <select className="form-select" id="ageGroup" value={Interviewstatus} onChange={(e) => setInterviewStatus(e.target.value)}>
                    <option value="">Select</option>
                    {!client && <option value="consider_to_client">Consider to Client for Merida</option>}
                    {!client && <option value="Internal_Hiring">Shortlisted to Next Round </option>}
                    {!client && <option value="Reject">Reject</option>}
                    {!client && <option value="On_Hold">On Hold</option>}

                    {client && <option value="client_offer_rejected">Offer Rejected By Candidate </option>}
                    {client && <option value="client_kept_on_hold">Client Kept on Hold </option>}
                    {client && <option value="client_rejected">Client Rejected</option>}
                    {client && <option value="client_offered"> Client Offered </option>}
                    {client && <option value="candidate_joined">Candidate Joined</option>}

                    {/* <option value="Offer_did_not_accept">Offerd Did't Accept</option> */}
                  </select>
                </div>

                <div className="col-md-12 col-lg-12 mb-3">
                  <label htmlFor="Comments" className="form-label">Comments <span className='text-red-500 '>*</span> </label>
                  <textarea className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="Comments" value={comments} onChange={(e) => setComments(e.target.value)}></textarea>
                </div>
              </div>
            </div>
          </div>

          {/* Comments end */}

        </form>
        <div className='d-flex mb-4 justify-end gap-2'>
          <button type="submit" disabled={loading} className='p-2 rounded bg-green-600 text-white'
            onClick={handleproceedingform} >{loading ? "Loading.." : "Submit"}</button>
        </div>
      </main>}


    </main>
  )
}

export default InterviewReviewModal