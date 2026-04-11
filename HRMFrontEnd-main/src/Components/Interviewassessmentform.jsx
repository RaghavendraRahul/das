import React from 'react'

const Interviewassessmentform = () => {
  return (
    <div>
           <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="false">
                          <div class="modal-dialog modal-xl">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" style={{ backgroundColor: 'transparent !important' }} className='border-0 ' data-bs-dismiss="modal" aria-label="Close" > <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                                  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                                </svg></button>

                                <div className=' d-flex justify-content-center w-100'>
                                  <h3 className='text-primary text-center'>INTERVIEW ASSESSMENT FORM</h3>

                                </div>

                              </div>
                              <div class="modal-body container-fluid ">
                                <form>
                                  {/* Top inputs  start */}

                                  <div className="row justify-content-center m-0">
                                    <div className="col-lg-12 p-4 border rounded-lg">
                                      <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="Name" className="form-label">Name </label>
                                          <input type="text" className="form-control shadow-none" id="Name" name="Name" value={name} onChange={(e) => setName(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="lastName" className="form-label">Position Applied For</label>
                                          <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={position} onChange={(e) => setPosition(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="email" className="form-label">Source By</label>
                                          <input type="text" className="form-control shadow-none" id="Email" name="Email" value={sourceBy} onChange={(e) => setSourceBy(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="primaryContact" className="form-label">Date</label>
                                          <input type="date" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={date} onChange={(e) => setDate(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                                          <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={location} onChange={(e) => setLocation(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                                          <input type="text" className="form-control shadow-none" id="State" name="State" value={sourceName} onChange={(e) => setSourceName(e.target.value)} />
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  {/* Top inputs  end */}


                                  {/* all inputs start */}
                                  <div className="row justify-content-center m-0 mt-4">
                                    <div className="col-lg-12 p-4 border rounded-lg">
                                      <div className="mb-3">
                                        <label htmlFor="qualification" className="form-label">Qualification:</label>
                                        <input type="text" className="form-control" id="qualification" value={qualification} onChange={(e) => setQualification(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="experience" className="form-label">Related Experience:</label>
                                        <input type="number" className="form-control" id="experience" value={experience} onChange={(e) => setExperience(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="jobStability" className="form-label">Job Stability with Previous Employer:</label>
                                        <input type="number" className="form-control" id="jobStability" value={jobStability} onChange={(e) => setJobStability(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="reasonLeaving" className="form-label">Reason For Leaving The Immediate Employer:</label>
                                        <input type="text" className="form-control" id="reasonLeaving" value={reasonLeaving} onChange={(e) => setReasonLeaving(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="appearancePersonality" className="form-label">Appearance & Personality:</label>
                                        <input type="number" className="form-control" id="appearancePersonality" value={appearancePersonality} onChange={(e) => setAppearancePersonality(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="clarityThought" className="form-label">Clarity of Thought:</label>
                                        <input type="number" className="form-control" id="clarityThought" value={clarityThought} onChange={(e) => setClarityThought(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="englishSkills" className="form-label">English Language Skills:</label>
                                        <input type="number" className="form-control" id="englishSkills" value={englishSkills} onChange={(e) => setEnglishSkills(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="technicalAwareness" className="form-label">Awareness on Technical Dynamics:</label>
                                        <input type="number" className="form-control" id="technicalAwareness" value={technicalAwareness} onChange={(e) => setTechnicalAwareness(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="interpersonalSkills" className="form-label">Interpersonal Skills / Attitude:</label>
                                        <input type="number" className="form-control" id="interpersonalSkills" value={interpersonalSkills} onChange={(e) => setInterpersonalSkills(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="confidenceLevel" className="form-label">Confidence Level:</label>
                                        <input type="number" className="form-control" id="confidenceLevel" value={confidenceLevel} onChange={(e) => setConfidenceLevel(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="ageGroup" className="form-label">Age Group Suitability:</label>
                                        <select className="form-select" id="ageGroup" value={ageGroup} onChange={(e) => setAgeGroup(e.target.value)}>
                                          <option value="">Select</option>
                                          <option value="yes">Yes</option>
                                          <option value="no">No</option>
                                        </select>
                                      </div>

                                      <div className="mb-3">
                                        <label htmlFor="logicalReasoning" className="form-label">Analytical & Logical Reasoning Skills:</label>
                                        <input type="number" className="form-control" id="logicalReasoning" value={logicalReasoning} onChange={(e) => setLogicalReasoning(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="careerPlans" className="form-label">Career Plans:</label>
                                        <input type="text" className="form-control" id="careerPlans" value={careerPlans} onChange={(e) => setCareerPlans(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="achievementOrientation" className="form-label">Achievement Orientation:</label>
                                        <input type="text" className="form-control" id="achievementOrientation" value={achievementOrientation} onChange={(e) => setAchievementOrientation(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="driveProblemSolving" className="form-label">Drive / Problem Solving Abilities:</label>
                                        <input type="number" className="form-control" id="driveProblemSolving" value={driveProblemSolving} onChange={(e) => setDriveProblemSolving(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="takeUpChallenges" className="form-label">Ability to Take Up Challenges:</label>
                                        <input type="number" className="form-control" id="takeUpChallenges" value={takeUpChallenges} onChange={(e) => setTakeUpChallenges(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="leadershipAbilities" className="form-label">Leadership Abilities:</label>
                                        <input type="number" className="form-control" id="leadershipAbilities" value={leadershipAbilities} onChange={(e) => setLeadershipAbilities(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="companyInterest" className="form-label">Interest With The Company:</label>
                                        <select className="form-select" id="companyInterest" value={companyInterest} onChange={(e) => setCompanyInterest(e.target.value)}>
                                          <option value="">Select</option>
                                          <option value="yes">Yes</option>
                                          <option value="no">No</option>
                                        </select>
                                      </div>

                                      <div className="mb-3">
                                        <label htmlFor="researchCompany" className="form-label">Researched About The Company:</label>
                                        <select className="form-select" id="researchCompany" value={researchCompany} onChange={(e) => setResearchCompany(e.target.value)}>
                                          <option value="">Select</option>
                                          <option value="yes">Yes</option>
                                          <option value="no">No</option>
                                        </select>
                                      </div>

                                      <div className="mb-3">
                                        <label htmlFor="targetPressure" className="form-label">Ability to Handle Targets / Pressure:</label>
                                        <input type="number" className="form-control" id="targetPressure" value={targetPressure} onChange={(e) => setTargetPressure(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="customerService" className="form-label">Customer Service:</label>
                                        <input type="number" className="form-control" id="customerService" value={customerService} onChange={(e) => setCustomerService(e.target.value)} />
                                      </div>
                                      <div className="mb-3">
                                        <label htmlFor="overallRanking" className="form-label">Overall Candidate Ranking (1 to 5):</label>
                                        <input type="number" className="form-control" id="overallRanking" value={overallRanking} onChange={(e) => setOverallRanking(e.target.value)} />
                                      </div>
                                    </div>
                                  </div>
                                  {/* all inputs End */}

                                  {/* For HRD Use only start */}
                                  <h6 className='mt-4 text-primary'>For HRD Use Only</h6>
                                  <div className="row justify-content-center m-0 mt-4">
                                    <div className="col-lg-12 p-4 border rounded-lg">
                                      <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-3 mb-3">
                                          <label htmlFor="Name" className="form-label">Last CTC </label>
                                          <input type="text" className="form-control shadow-none" id="LastCTC" name="LastCTC" value={lastCTC} onChange={(e) => setLastCTC(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                          <label htmlFor="lastName" className="form-label">Expected CTC</label>
                                          <input type="text" className="form-control shadow-none" id="ExpectedCTC" name="ExpectedCTC" value={expectedCTC} onChange={(e) => setExpectedCTC(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                          <label htmlFor="email" className="form-label">Notice Period</label>
                                          <input type="text" className="form-control shadow-none" id="NoticePeriod" name="NoticePeriod" value={noticePeriod} onChange={(e) => setNoticePeriod(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                          <label htmlFor="primaryContact" className="form-label">DOJ</label>
                                          <input type="text" className="form-control shadow-none" id="DOJ" name="DOJ" value={DOJ} onChange={(e) => setDOJ(e.target.value)} />
                                        </div>
                                      </div>
                                      <div className='d-flex ms-3 mt-2'>
                                        <div>
                                          <h6 className='text-success'>6 Days Working_Yes / No</h6>
                                        </div>
                                        <div className='ms-4 ps-4'>
                                          <h6 className='text-success'>Flexibility on Working Timings Yes / No Comments if Any</h6>
                                        </div>
                                      </div>
                                      <div className="row m-0 pb-2 mt-4">
                                        <div className="col-md-6 col-lg-6 mb-3">
                                          <label htmlFor="lastName" className="form-label"></label>
                                          <input type="text" className="form-control shadow-none mt-2" id="CertificationSubmission" name="CertificationSubmission" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                          <label htmlFor="lastName" className="form-label">Certification Submission</label>
                                          <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                          <label htmlFor="email" className="form-label">Relocation to other city</label>
                                          <input type="text" className="form-control shadow-none" id="Email" name="Email" value={relocationToCity} onChange={(e) => setRelocationToCity(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                          <label htmlFor="primaryContact" className="form-label">Relocation to other centers</label>
                                          <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={relocationToCenters} onChange={(e) => setRelocationToCenters(e.target.value)} />
                                        </div>
                                        <div className="col-md-12 col-lg-12 mb-3">
                                          <label htmlFor="primaryContact" className="form-label">Screening Feedback</label>
                                          <textarea className="form-control" id="ScreeningFeedback" value={screeningFeedback} onChange={(e) => setScreeningFeedback(e.target.value)}></textarea>
                                        </div>
                                      </div>
                                    </div>
                                  </div>

                                  {/* For HRD Use only end */}

                                  {/* Comments Start  */}
                                  <h6 className='mt-4 text-primary'>Comments</h6>
                                  <div className="row justify-content-center m-0 mt-4">
                                    <div className="col-lg-12 p-4 border rounded-lg">
                                      <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="InterviewerName" className="form-label">Interviewer Name </label>
                                          <input type="text" className="form-control shadow-none" id="InterviewerName" name="InterviewerName" value={interviewerName} onChange={(e) => setInterviewerName(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="Signature" className="form-label">Signature</label>
                                          <input type="text" className="form-control shadow-none" id="Signature" name="Signature" value={signature} onChange={(e) => setSignature(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                          <label htmlFor="Date" className="form-label">Date</label>
                                          <input type="date" className="form-control shadow-none" id="Date" name="Date" value={date1} onChange={(e) => setDate1(e.target.value)} />
                                        </div>
                                        <div className="col-md-12 col-lg-12 mb-3">
                                          <label htmlFor="Comments" className="form-label">Comments</label>
                                          <textarea className="form-control" id="Comments" value={comments} onChange={(e) => setComments(e.target.value)}></textarea>
                                        </div>
                                      </div>
                                    </div>
                                  </div>

                                  {/* Comments end */}

                                </form>

                              </div>
                              <div class="modal-footer d-flex justify-content-end">

                                <div className='d-flex gap-2'>

                                  <button type="button" class="btn btn-primary btn-sm">Preview</button>

                                  <button type="submit" class="btn btn-success btn-sm" onClick={handleinterviewform} >Submit</button>


                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
    </div>
  )
}

export default Interviewassessmentform