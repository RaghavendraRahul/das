import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'

const ClientINterviewDetails = ({ inid }) => {
    let [interviewDetails, setInterviewDetails] = useState()
    let {selectValueToNormal}=useContext(HrmStore)
    let getInterviewDetail = () => {
        axios.get(`${port}/root/cms/client-interviews-assigned?interview_id=${inid}`).then((response) => {
            console.log(response.data.review, 'interview');
            setInterviewDetails(response.data.review)
        }).catch((error) => {
            console.log(error, 'interview');
        })
    }
    let { convertToReadableDateTime, convertToNormalTime } = useContext(HrmStore)

    useEffect(() => {
        if (inid)
            getInterviewDetail()
    }, [inid])
    return (
        <div>
            {interviewDetails 
            && 
            <main >
                <hr />
                <h4 className='my-2 text-violet-700'>Interview Review </h4>

                <section className='flex flex-wrap'>
                    {interviewDetails && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Round : <span className='fw-normal break-words'>Client round </span>
                        </p></div>}
                    {interviewDetails.InterviewDate && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Interviewed  Date : <span className='fw-normal break-words'>{(interviewDetails.InterviewDate)} </span>
                        </p></div>}
                    {interviewDetails && interviewDetails.InterviewerName && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Interviewer  Name : <span className='fw-normal break-words'>{(interviewDetails.InterviewerName)} </span>
                        </p></div>}
                    {interviewDetails.InterviewTime && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Time : <span className='fw-normal break-words'>{convertToNormalTime(interviewDetails.InterviewTime)} </span>
                        </p>
                    </div>}
                    {interviewDetails.InterviewType && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Interview Mode : <span className='fw-normal break-words'>{(interviewDetails.InterviewType)} </span>
                        </p>
                    </div>}
                    {interviewDetails.ScheduledOn && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Scheduled Date : <span className='fw-normal break-words'>{(interviewDetails.ScheduledOn)} </span>
                        </p>
                    </div>}
                    {interviewDetails.ScheduledTime && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Scheduled Time : <span className='fw-normal break-words'>{convertToNormalTime(interviewDetails.ScheduledTime)} </span>
                        </p>
                    </div>}
                    {interviewDetails && interviewDetails.interview_Status && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                        <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                            Interview Status : <span className='fw-normal break-words'>{ selectValueToNormal(interviewDetails.interview_Status)} </span>
                        </p>
                    </div>}
                </section>
                {interviewDetails && 
                    <section className='flex flex-wrap '>
                        {interviewDetails.ReviewedOn && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Reviewed Date & Time : <span className='fw-normal break-words'>{convertToReadableDateTime(interviewDetails.ReviewedOn)} </span>
                            </p>
                        </div>}
                        {interviewDetails.AbilityToTakeChallenges && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Ability To Take Challenges : <span className='fw-normal break-words'>
                                    {(interviewDetails.AbilityToTakeChallenges)} </span>
                            </p>
                        </div>}
                        {interviewDetails.Comments && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Comments : <span className='fw-normal break-words'>
                                    {(interviewDetails.Comments)} </span>
                            </p>
                        </div>}
                        {interviewDetails.Coding_Questions_Score && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Coding Questions Score : <span className='fw-normal break-words'>
                                    {(interviewDetails.Coding_Questions_Score)} </span>
                            </p>
                        </div>}
                        {interviewDetails.AwarenessOnTechnicalDynamics && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Awareness On Technical Dynamics : <span className='fw-normal break-words'>{(interviewDetails.AwarenessOnTechnicalDynamics)} </span>
                            </p>
                        </div>}
                        {interviewDetails.CareerPlans && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Career Plans : <span className='fw-normal break-words'>{(interviewDetails.CareerPlans)} </span>
                            </p>
                        </div>}
                        {interviewDetails.ClarityOfThought && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Clarity Of Thought : <span className='fw-normal break-words'>{(interviewDetails.ClarityOfThought)} </span>
                            </p>
                        </div>}
                        {interviewDetails.CustomerService && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Customer Service : <span className='fw-normal break-words'>{(interviewDetails.CustomerService)} </span>
                            </p>
                        </div>}
                        {interviewDetails.EnglishLanguageSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                English Language Skills : <span className='fw-normal break-words'>{(interviewDetails.EnglishLanguageSkills)} </span>
                            </p>
                        </div>}
                        {interviewDetails.HandelTargets_Pressure && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Handel Targets Pressure : <span className='fw-normal break-words'>{(interviewDetails.HandelTargets_Pressure)} </span>
                            </p>
                        </div>}
                        {interviewDetails.InterpersonalSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Interpersonal Skills : <span className='fw-normal break-words'>{(interviewDetails.InterpersonalSkills)} </span>
                            </p>
                        </div>}
                        {interviewDetails.IntrestWithCompany && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Intrest With Company : <span className='fw-normal break-words'>{(interviewDetails.IntrestWithCompany)} </span>
                            </p>
                        </div>}
                        {interviewDetails.JobStabilityWithPreviousEmployers && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                JobStability With Previous Employers : <span className='fw-normal break-words'>{(interviewDetails.JobStabilityWithPreviousEmployers)} </span>
                            </p>
                        </div>}
                        {interviewDetails.ConfidenceLevel && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Confidence Level : <span className='fw-normal break-words'>{(interviewDetails.ConfidenceLevel)} </span>
                            </p>
                        </div>}
                        {interviewDetails.AchivementOrientation && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Achivement Orientation : <span className='fw-normal break-words'>{(interviewDetails.AchivementOrientation)} </span>
                            </p>
                        </div>}
                        {interviewDetails.Analytical_and_logicalReasoningSkills && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Analytical and logicalReasoningSkills : <span className='fw-normal break-words'>{(interviewDetails.Analytical_and_logicalReasoningSkills)} </span>
                            </p>
                        </div>}
                        {interviewDetails.Appearence_and_Personality && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Appearence and Personality : <span className='fw-normal break-words'>{(interviewDetails.Appearence_and_Personality)} </span>
                            </p>
                        </div>}
                        {interviewDetails.AgeGroupSuitability && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Age Group Suitability : <span className='fw-normal break-words'>{(interviewDetails.AgeGroupSuitability)} </span>
                            </p>
                        </div>}
                        {interviewDetails.LeadershipAbilities && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Leadership Abilities : <span className='fw-normal break-words'>{(interviewDetails.LeadershipAbilities)} </span>
                            </p>
                        </div>}

                        {interviewDetails.ProblemSolvingAbilites && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Problem Solving Abilites : <span className='fw-normal break-words'>{(interviewDetails.ProblemSolvingAbilites)} </span>
                            </p>
                        </div>}
                        {interviewDetails.ReasionForLeavingImadiateEmployeer && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Reasion For Leaving Imadiate Employeer : <span className='fw-normal break-words'>{(interviewDetails.ReasionForLeavingImadiateEmployeer)} </span>
                            </p>
                        </div>}
                        {interviewDetails.ResearchedAboutCompany && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Researched About Company : <span className='fw-normal break-words'>{(interviewDetails.ResearchedAboutCompany)} </span>
                            </p>
                        </div>}
                        {interviewDetails.OverallCandidateRanking && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Overall Candidate Ranking : <span className='fw-normal break-words'>{(interviewDetails.OverallCandidateRanking)} </span>
                            </p>
                        </div>}

                        {interviewDetails.RelocateToOtherCenters && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Relocate To Other Centers : <span className='fw-normal break-words'>{(interviewDetails.RelocateToOtherCenters)} </span>
                            </p>
                        </div>
                        }
                        {interviewDetails.RelocateToOtherCity && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Relocate To Other City : <span className='fw-normal break-words'>{(interviewDetails.RelocateToOtherCity)} </span>
                            </p>
                        </div>
                        }
                        {interviewDetails.Six_Days_Working && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Six Days Working : <span className='fw-normal break-words'>{(interviewDetails.Six_Days_Working)} </span>
                            </p>
                        </div>
                        }
                        {interviewDetails.RelocateToOtherCenters && <div className=' col-lg-4 p-2 col-md-6  py-3'>
                            <p className='bg-white p-3 shadow-sm border-1 border-slate-400 border-opacity-50 rounded mb-0  fw-semibold'>
                                Relocate To Other Centers : <span className='fw-normal break-words'>{(interviewDetails.RelocateToOtherCenters)} </span>
                            </p>
                        </div>
                        }
                    </section>}
            </main>
            }
        </div>
    )
}

export default ClientINterviewDetails