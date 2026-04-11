import React, { useContext, useEffect, useState } from 'react'
import CandidateInformationModal from './CandidateInformationModal'
import axios from 'axios'
import { port } from '../../App'
import SceeringCompletedCandiateModal from '../Modals/SceeringCompletedCandiateModal'
import SchedulINterviewModalForm from './SchedulINterviewModalForm'
import { HrmStore } from '../../Context/HrmContext'
import { Modal } from 'react-bootstrap'
import { toast } from 'react-toastify'

const ScreeningAssigned = (props) => {
    let { convertToReadableDateTime } = useContext(HrmStore)
    let [show, setshow] = useState(false)
    const [id1, setEmpid1] = useState("")

    let username = JSON.parse(sessionStorage.getItem('user')).UserName
    const [InterviewScheduledate, setInterviewScheduledate] = useState('');
    const [signature, setSignature] = useState('');
    const [date1, setDate1] = useState('');

    let [screeningFormModal, setscreeningModal] = useState(false)
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    const [comments, setComments] = useState('');
    let [carrylaptop, setcarrylaptop] = useState(false)
    const [interviewtime, setinterviewtime] = useState('');

    let { handlescreenedsearchvalue, searchscreenValue, fetchdata, fetchdata2,
        handle_screened_filter_value, handleCheckboxChange1, fetchdata1,
        screeninglist_All, int_int_data, load1, screeninglistCompleted,
        search_filter_screened, screeninglist, Screening_screening_data, Screening_candidate_data } = props
    let [interviewSchedulForm, setInterviewScheduleForm] = useState(false)
    let [candidateIdInterview, setCandidateIdInterview] = useState()
    let userPermission = JSON.parse(sessionStorage.getItem('user')).user_permissions

    const [aboutFamily, setAboutfamily] = useState('')
    const [Meritalstatus, setMeritalStatus] = useState('');
    const [Spousedesignation, setspousejob] = useState('');
    const [Numberofkids, setNumberOfKids] = useState('');
    const [LanguagesKnown, setLanguagesKnown] = useState('');
    const [relocationToCity, setRelocationToCity] = useState('');
    const [relocationToCenters, setRelocationToCenters] = useState('');
    const [screeningstatus, setScreeningscreeningstatus] = useState('');
    const [sixDaysWorking, setsixDaysWorking] = useState('');
    const [FlexibilityonWorkingTimings, setFlexibilityonWorkingTimings] = useState('');
    const [CurrentLocation, setCurrentLocation] = useState('');
    const [TravellBy, setTravellBy] = useState('');
    const [StayWith, setStayWith] = useState('');
    const [motherTongue, setMotherTongue] = useState('')
    let [Leagel_cases, setLeagelCase] = useState('')
    let [FathersName, setFathersName] = useState('')
    let [FathersDesignation, setFatherDesignation] = useState('')
    let [SpouseDesignation, setSpouseDesignation] = useState('')
    let [devorced_statement, setDevorceStatement] = useState('')

    const [Native, setNative] = useState('');
    let [screeningCompletedApplicant, setScreeningCompletedApplicant] = useState()
    let [persondata, setPersondata] = useState()
    const [Candidateid, setCandidate] = useState("")
    let [screeningCompletedCandidateDetailModal, setscreeningCompletedCandidateDetailModal] = useState(false)
    let [filteredCandiates, setfilteredCandidates] = useState(screeninglist)
    // console.log(filteredCandiates);
    // console.log(screeninglist);
    useEffect(() => {
        if (screeninglist) {
            setfilteredCandidates(screeninglist)
        }
    }, [screeninglist])
    let [assignOrCompleted, setAssignedorCompleted] = useState('Assigned')
    useEffect(() => {
        if (assignOrCompleted == 'Assigned')
            setfilteredCandidates(screeninglist)
        if (assignOrCompleted == 'Completed') {
            console.log(screeninglistCompleted);
            setfilteredCandidates(screeninglistCompleted)
        }
    }, [assignOrCompleted])
    const sentparticularData2 = (id, emp_id) => {
        console.log('paticular data:', id);
        console.log("send_", id);
        setEmpid1(emp_id)

        // Define the data to be sent in the request
        const dataToSend = {
            id: id // Assuming id is the parameter passed to the function
        };
        // Send a POST request using Axios
        if (id != '') {
            console.log('paticular data:', id);
            axios.get(`${port}/root/Screening_Schedule_Data/${id}/${emp_id}/`, dataToSend)
                .then(response => {
                    // Handle the response if needed
                    console.log('paticular data:', response.data);
                    setPersondata(response.data.candidate_data)
                    setCandidate(response.data.CandidateId)
                    console.log("person data", response.data);
                })
                .catch(error => {
                    // Handle errors if any
                    console.error('Error sending data:', error);
                });
        }
    };
    const handleCompletedApplicant = (id) => {
        axios.get(`${port}/root/New-Candidate-Screening-Completed-Details/${id}/`).then((response) => {
            setScreeningCompletedApplicant(response.data)
            setscreeningCompletedCandidateDetailModal(true)
            console.log("Screening_Completed_Candidate", response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let handleScreeingform = (e) => {
        e.preventDefault();

        const formData1 = new FormData()
        // setInterviewScheduleForm(true)

        formData1.append('id', id1);
        formData1.append('login_user', Empid);
        formData1.append('CandidateId', persondata.id);
        formData1.append('Can_Id', persondata.CandidateId);
        // formData1.append('CandidateId', persondata.CandidateId);
        formData1.append('Name', persondata.FirstName);
        formData1.append('PositionAppliedFor', persondata.AppliedDesignation);
        formData1.append('SourceBy', persondata.ContactedBy);
        formData1.append('SourceName', persondata.JobPortalSource);
        formData1.append('ContactNumber', persondata.PrimaryContact);
        // formData1.append('Totalexperience', persondata.AppliedDesignation);
        formData1.append('LastCTC', persondata.CurrentCTC);
        formData1.append('ExpectedCTC', persondata.ExpectedSalary);
        formData1.append('InterviewScheduledate', InterviewScheduledate);
        formData1.append('Screening_Status', screeningstatus);
        formData1.append('MeritalStatus', Meritalstatus);
        formData1.append('SpouseName', Spousedesignation);
        formData1.append('About_Childrens', Numberofkids);

        formData1.append('Six_Days_Working', sixDaysWorking);
        formData1.append('OwnLoptop', carrylaptop)
        formData1.append('RelocateToOtherCity', relocationToCity);
        formData1.append('RelocateToOtherCenters', relocationToCenters);
        formData1.append('FlexibilityOnWorkTimings', FlexibilityonWorkingTimings)
        formData1.append('LastCTC', persondata.CurrentCTC);
        formData1.append('ExpectedCTC', persondata.ExpectedSalary);
        formData1.append('NoticePeriod', persondata.NoticePeriod);

        formData1.append('SpouseDesignation', SpouseDesignation);
        formData1.append('Leagel_cases', Leagel_cases);
        formData1.append('devorced_statement', devorced_statement);
        formData1.append('FathersDesignation', FathersDesignation);
        formData1.append('FathersName', FathersName);




        formData1.append('LanguagesKnown', LanguagesKnown);
        formData1.append('About_Family', aboutFamily);
        formData1.append('CurrentLocation', CurrentLocation);
        formData1.append('ModeOfCommutation', TravellBy);
        formData1.append('Residingat', StayWith);
        formData1.append('Native', Native);
        formData1.append('Mother_Tongue', motherTongue)
        formData1.append('InterviewerName', username);
        formData1.append('ReviewedBy', username);
        formData1.append('Signature', signature);
        formData1.append('Date1', date1);
        formData1.append('interviewtime', interviewtime);
        formData1.append('Comments', comments);


        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        if (Native.trim() != "" && Meritalstatus.trim() != "" && LanguagesKnown.trim() != "" &&
            CurrentLocation.trim() != "" && StayWith.trim() != "" && comments.trim() != "" &&
            TravellBy.trim() != "" && aboutFamily.trim() != "" && motherTongue.trim() != '' &&
            screeningstatus.trim() != ''
        ) {
            axios.post(`${port}/root/ScreeningReviewData`, formData1)
                .then((r) => {
                    toast.success("Proceding Form Data Successfull")
                    console.log("screeningformres", r.data)
                    if (screeningstatus == 'scheduled') {
                        setInterviewScheduleForm(true)
                        setCandidateIdInterview(persondata.CandidateId)
                    }
                    fetchdata1()
                    setNative(''); setTravellBy(''); setAboutfamily('');
                    setMeritalStatus(''); setComments('');
                    setScreeningscreeningstatus('')
                    setLanguagesKnown('')
                    setscreeningModal(false)
                })
                .catch((err) => {
                    console.log("screening form Error", err)
                })
        }
        else {
            toast.warning('Fill all the required input field')
        }
    }
    return (
        <div>
            {<SceeringCompletedCandiateModal show={screeningCompletedCandidateDetailModal}
                persondata={persondata} setPersondata={setPersondata}
                setshow={setscreeningCompletedCandidateDetailModal}
                data={screeningCompletedApplicant} />}


            {persondata && <SchedulINterviewModalForm fetchdata1={fetchdata1} candidateId={candidateIdInterview} setcandidateId={setCandidateIdInterview}
                fetchdata={fetchdata} fetchdata2={fetchdata2} show={interviewSchedulForm} persondata={persondata}
                setshow={setInterviewScheduleForm} setPersondata={setPersondata} />}


            <div className='d-flex justify-content-between mb-2 '>
                <div>
                    <div class="input-group mb-3 ">
                        <span class="input-group-text" id="basic-addon1"> <i class="fa-solid fa-magnifying-glass" ></i>  </span>
                        <input type="text" value={searchscreenValue} style={{ width: '200px', height: '30px', fontSize: '9px', outline: 'none' }}
                            onChange={(e) => {
                                handlescreenedsearchvalue(e.target.value, assignOrCompleted)
                            }} class="form-control shadow-none" aria-label="Username" aria-describedby="basic-addon1" />
                    </div>
                </div>
                <div>
                    <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >
                        {/* <select className="form-select shadow-none" id="ageGroup" style={{ width: '100px', height: '30px', fontSize: '9px', outline: 'none' }}
                            value={search_filter_screened} onChange={(e) => {
                                handle_screened_filter_value(e.target.value)
                            }} >
                            <option value="">Filter</option>
                            <option value="Today">Day</option>
                            <option value="Week">Week</option>
                            <option value="Month">Month</option>
                            <option value="Year">Year</option>
                        </select> */}

                    </li>
                </div>
            </div>
            <select name="" value={assignOrCompleted} onChange={(e) => setAssignedorCompleted(e.target.value)}
                className='btngrd border-2 flex ms-auto bg-opacity-70 outline-none rounded border-violet-100 text-white text-xs p-2 ' id="">
                <option value="Assigned" className='text-black bg-slate-50 '>Assigned</option>
                <option value="Completed" className='text-black bg-slate-50 '>Completed</option>
            </select>
            {/* <main className='border-1 bg-slate-400 rounded w-fit'>
                <button onClick={() => setAssignedorCompleted('Assigned')} className={`rounded transition duration-500 text-white p-2 ${assignOrCompleted == 'Assigned' ? "bg-blue-500" : 'bg-slate-400'}`}>
                    Assigned
                </button>
                <button onClick={() => setAssignedorCompleted('Completed')} className={`rounded transition duration-500 text-white p-2 ${assignOrCompleted == 'Completed' ? "bg-blue-500" : 'bg-slate-400'}`}>Completed</button>
            </main> */}

            {/* Second */}
            <div className='rounded h-[40vh] pt-0 overflow-y-scroll scrollbar1 tablebg table-responsive mt-4'>
                <table className="w-full ">

                    <tr className='sticky top-0 bgclr1 '>
                        <th className=' ' scope="col"><span className='fw-medium'>All</span></th>
                        <th scope="col"><span className='fw-medium'>Full Name</span></th>
                        <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                        <th scope="col"><span className='fw-medium'>Assigned To</span></th>
                        <th scope="col"><span className='fw-medium'>Assigned By</span></th>
                        <th scope="col"><span className='fw-medium'>Date Assigned</span></th>
                        {assignOrCompleted == 'Assigned' &&
                            <th scope="col"><span className='fw-medium'>Assigned Status</span></th>}
                        {assignOrCompleted != 'Assigned' &&
                            <th scope="col">
                                <span className='fw-medium'>Screened Status</span></th>}
                        {(assignOrCompleted != 'Assigned') &&
                            <th scope="col"><span className='fw-medium'>Assign Interview</span>
                            </th>}
                        {/* <th scope="col"><span className='fw-medium'>View</span></th> */}

                    </tr>

                    {/* STATIC VALUE START */}

                    {/* <tr>

                        <td > 123</td>
                        <td >jerold</td>
                        <td >Null</td>
                        <td >23-12-2001</td>
                        <td >Mathavan</td>
                        <td >Assigned</td>
                        <td >Assigned</td>
                        <td className='text-center'><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal5">
                          open
                        </button>
                        </td>
                      </tr> */}
                    {filteredCandiates != undefined && filteredCandiates != undefined &&
                        [...filteredCandiates].map((e) => {
                            // console.log(e);
                            return (<tr key={e.id}>
                                <td scope="row">
                                    <input type="checkbox" value={e.Candidate} onChange={handleCheckboxChange1} /></td>
                                {/* <td onClick={() => sentparticularData(e.Candidate)} data-bs-toggle="modal" data-bs-target="#exampleModal5" style={{ cursor: 'pointer', color: 'blue' }}>{e.Name}</td> */}
                                {assignOrCompleted == 'Assigned' &&
                                    <td onClick={() => sentparticularData2(e.Candidate, e.id)}
                                        data-bs-toggle="modal" data-bs-target="#exampleModal5"
                                        style={{ color: 'blue', cursor: 'pointer' }}> {e.Candidate_name} </td>}
                                {assignOrCompleted != 'Assigned' &&
                                    <td onClick={() => handleCompletedApplicant(e.Candidate)}
                                        style={{ color: 'green', cursor: 'pointer' }}>{e.Candidate_name}</td>}
                                <td>{e.Candidate}</td>
                                <td>{e.recruiter_name}</td>
                                {/* <td>{e.Date_of_assigned} </td> */}
                                <td>{e.assigner_name}</td>
                                <td>{convertToReadableDateTime(e.Date_of_assigned)}</td>
                                {assignOrCompleted == 'Assigned' && <td>{e.Assigned_Status}</td>}
                                {assignOrCompleted != 'Assigned' && <td>{e.Review != null ? e.Review.Screening_Status : null}</td>}
                                {assignOrCompleted == 'Completed' && <td>
                                    <button disabled={e.Review && e.Review.Screening_Status != 'scheduled'} onClick={() => {
                                        setCandidateIdInterview(e.Candidate)
                                        setInterviewScheduleForm(true);
                                        sentparticularData2(e.Candidate, e.id);
                                    }} className='p-1 text-xs rounded bg-blue-600 text-white'>Assign Interview </button>
                                </td>
                                }
                                {/* <td>{e.Review != null ? e.Review.ReviewedOn : null}</td> */}
                                {/* <td onClick={() => sentparticularData(e.Candidate)} className='text-center'>
                              <button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} className="btn btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal5">
                                Open
                              </button>
                            </td> */}
                            </tr>)
                        })}
                    {/* open Particular Data Start */}
                    <CandidateInformationModal show={show} setshow={setshow}
                        Screening_screening_data={Screening_screening_data}
                        int_int_data={int_int_data}
                        Screening_candidate_data={Screening_candidate_data} />
                    {/* open Particular Data End */}
                </table>
            </div>

            <main class="modal fade" tabindex="-1" id="exampleModal5" aria-labelledby="exampleModalLabel5" aria-hidden="false">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel5">Name : {persondata && persondata.FirstName}</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">

                            <h1>Screening Assigned Canditate Information</h1>

                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <th>Name</th>
                                        <td>{persondata && persondata.FirstName} {persondata && persondata.LastName}</td>
                                    </tr>
                                    <tr>
                                        <th>Email</th>
                                        <td>{persondata && persondata.Email}</td>
                                    </tr>
                                    <tr>
                                        <th>Gender</th>
                                        <td>{persondata && persondata.Gender}</td>
                                    </tr>
                                    <tr>
                                        <th>Primary Contact</th>
                                        <td>{persondata && persondata.PrimaryContact}</td>
                                    </tr>
                                    <tr>
                                        <th>Secondary Contact</th>
                                        <td>{persondata && persondata.SecondaryContact}</td>
                                    </tr>
                                    <tr>
                                        <th>Location</th>
                                        <td>{persondata && persondata.Location}</td>
                                    </tr>

                                    {/* Fresher start  */}

                                    <tr className={` ${persondata && persondata.Fresher ? ' ' : 'd-none'} `}>
                                        <th> {persondata && persondata.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                        {/* <td >{persondata && persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                    </tr>
                                    <tr className={` ${persondata && persondata.Fresher ? ' ' : 'd-none'} `}>
                                        <th>GeneralSkills</th>
                                        <td>{persondata && persondata.GeneralSkills}</td>
                                    </tr>
                                    <tr className={` ${persondata && persondata.Fresher ? ' ' : 'd-none'} `}>
                                        <th>TechnicalSkills</th>
                                        <td>{persondata && persondata.TechnicalSkills}</td>
                                    </tr>
                                    <tr className={` ${persondata && persondata.Fresher ? ' ' : 'd-none'} `}>
                                        <th>SoftSkills</th>
                                        <td>{persondata && persondata.SoftSkills}</td>
                                    </tr>

                                    {/*  Fresher end */}

                                    {/* Experience Start */}
                                    <tr className={` ${persondata && persondata.Experience ? ' ' : 'd-none'} `}>
                                        <th> {persondata && persondata.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                        {/* <th>Experience</th> */}
                                        {/* <td>{persondata && persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                    </tr>
                                    <tr className={` ${persondata && persondata.Experience ? ' ' : 'd-none'} `}>
                                        <th>GeneralSkills with Exp</th>
                                        <td>{persondata && persondata.GeneralSkills_with_Exp}</td>
                                    </tr>
                                    <tr className={` ${persondata && persondata.Experience ? ' ' : 'd-none'} `}>
                                        <th>TechnicalSkills with Exp</th>
                                        <td>{persondata && persondata.TechnicalSkills_with_Exp}</td>
                                    </tr>
                                    <tr className={` ${persondata && persondata.Experience ? ' ' : 'd-none'} `}>
                                        <th>SoftSkills with Exp</th>
                                        <td>{persondata && persondata.SoftSkills_with_Exp}</td>
                                    </tr>
                                    {/* Experience Start */}

                                    <tr>
                                        <th>Highest Qualification</th>
                                        <td>{persondata && persondata.HighestQualification}</td>
                                    </tr>
                                    <tr>
                                        <th>University</th>
                                        <td>{persondata && persondata.University}</td>
                                    </tr>
                                    <tr>
                                        <th>Specialization</th>
                                        <td>{persondata && persondata.Specialization}</td>
                                    </tr>
                                    <tr>
                                        <th>Percentage</th>
                                        <td>{persondata && persondata.Percentage}</td>
                                    </tr>
                                    <tr>
                                        <th>Year of Passout</th>
                                        <td>{persondata && persondata.YearOfPassout}</td>
                                    </tr>

                                    <tr>
                                        <th>Applied Designation</th>
                                        <td>{persondata && persondata.AppliedDesignation}</td>
                                    </tr>
                                    <tr>
                                        <th>Expected Salary</th>
                                        <td>{persondata && persondata.ExpectedSalary}</td>
                                    </tr>
                                    <tr>
                                        <th>Contacted By</th>
                                        <td>{persondata && persondata.ContactedBy}</td>
                                    </tr>
                                    <tr>
                                        <th>Job Portal Source</th>
                                        <td>{persondata && persondata.JobPortalSource}</td>
                                    </tr>
                                    <tr>
                                        <th>Applied Date</th>
                                        <td>{persondata && convertToReadableDateTime(persondata.AppliedDate)}</td>
                                    </tr>
                                </tbody>
                            </table>









                        </div>
                        <div class="modal-footer d-flex justify-content-between">
                            <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                            <div className='d-flex gap-2'>

                                {/* <button type="button" class="btn btn-primary">Assign Task</button> */}

                                {/* <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button> */}
                                <button className='btn btn-success btn-sm'
                                    onClick={() => setscreeningModal(true)}
                                    data-bs-dismiss="modal"
                                    data-bs-target="#exampleModal5"
                                >
                                    Proceed
                                </button>
                                {/* <button type="button" class="btn btn-info">Offer Letter</button> */}


                            </div>
                        </div>
                    </div>
                </div>
            </main>
            {screeningFormModal &&
                <Modal centered size='xl' show={screeningFormModal} onHide={() => setscreeningModal(false)} >
                    <Modal.Header closeButton>
                        <h3 className='text-primary text-center'>SCREENING  FORM</h3>

                    </Modal.Header>
                    <Modal.Body>
                        <form>
                            {/* Top inputs  start */}

                            <div className="row justify-content-center m-0">
                                <div className="col-lg-12 p-4 border rounded-lg">
                                    <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Canditate Id </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name"
                                                value={`${persondata.CandidateId}`} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Name </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={`${persondata.FirstName}`} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="lastName" className="form-label">Position Applied For</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName" name="LastName" value={persondata.AppliedDesignation} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="email" className="form-label">Source By</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Email" name="Email" value={persondata.ContactedBy} />
                                        </div>


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Mobile Number</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata.PrimaryContact} />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            {/* Top inputs  end */}


                            {/* Personal Details start */}

                            <h6 className='mt-4 text-primary'>Personal Details</h6>
                            <div className="row justify-content-center m-0 mt-4">
                                <div className="col-lg-12 p-4 border rounded-lg">
                                    <div className="row m-0 pb-2">
                                        {/* <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Name" className="form-label">Father Designation </label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={Fatherdesignation} onChange={(e) => setFatherDesignation(e.target.value)} />
                        </div> */}
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="Name" className="form-label">About Family <span className=' text-red-600' id='familyerror' >*  </span> </label>
                                            <textarea type="text" placeholder='Had a 2 Brother.... ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none text-sm shadow-none" id="Name" name="Name"
                                                value={aboutFamily}
                                                onChange={(e) => setAboutfamily(e.target.value)} />
                                        </div>

                                        {/* <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="lastName" className="form-label">Number Of Sibilings</label>
                          <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName" name="LastName" value={Numberofsib} onChange={(e) => setNumberofsib(e.target.value)} />
                        </div> */}

                                        <div className="mb-3 col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label">Marrital Status <span className=' text-red-600' id='marryerror' >*  </span> </label>
                                            <select className="form-select" id="ageGroup"
                                                value={Meritalstatus} onChange={(e) => setMeritalStatus(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="single">Single</option>
                                                <option value="marrid">Married</option>
                                                <option value="divorced">Divorced</option>
                                            </select>
                                        </div>
                                        {Meritalstatus == "single"
                                            && <>
                                                <div className="col-md-6 col-lg-6 mb-3">
                                                    <label htmlFor="" className="form-label">Father Name</label>
                                                    <input type="text" placeholder='Manoj' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact"
                                                        value={FathersName} onChange={(e) => setFathersName(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-6 mb-3">
                                                    <label htmlFor="" className="form-label">Father Designation</label>
                                                    <input type="text" placeholder='Bank Manager' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none"
                                                        id="" name="PrimaryContact"
                                                        value={FathersDesignation} onChange={(e) => setFatherDesignation(e.target.value)} />
                                                </div>
                                            </>
                                        }
                                        {Meritalstatus == "divorced" && <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="primaryContact" className="form-label">Devorce Statement</label>
                                            <select className='p-2 border-1 border-slate-400 w-full block outline-none shadow-none rounded ' name="" value={devorced_statement}
                                                onChange={(e) => setDevorceStatement(e.target.value)} id="">
                                                <option value="">Select</option>
                                                <option value="Legally seperated">Legally Seperated </option>
                                                <option value="Still not settled">Still not settled </option>
                                                {/* <option value="Not willing to answer">Not willing to answer </option> */}
                                            </select>
                                        </div>
                                        }

                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="primaryContact" className="form-label">Legal Suits</label>
                                            <input type="text" placeholder='Legal case description.' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact"
                                                value={Leagel_cases} onChange={(e) => setLeagelCase(e.target.value)} />
                                        </div>

                                        {Meritalstatus != "single" && Meritalstatus != "" && (
                                            <>
                                                <div className="col-md-6 col-lg-6 mb-3">
                                                    <label htmlFor="primaryContact" className="form-label">Spouse Name</label>
                                                    <input type="text" placeholder='Hari krishna' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact"
                                                        value={Spousedesignation} onChange={(e) => setspousejob(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-6 mb-3">
                                                    <label htmlFor="secondaryContact" className="form-label">About Children</label>
                                                    <input type="text" placeholder='2 kids age 7 & 4' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-6 mb-3">
                                                    <label htmlFor="secondaryContact" className="form-label">Spouse Designation  <span className=' text-red-600' id='languageerror' >*  </span>  </label>
                                                    <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State"
                                                        placeholder='Bank Manager ' value={SpouseDesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                                                </div>
                                            </>
                                        )}




                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Languages Known <span className=' text-red-600' id='languageerror' >*  </span>  </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" placeholder='Tamil , English ' value={LanguagesKnown} onChange={(e) => setLanguagesKnown(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Current Location <span className=' text-red-600' id='locationerror' >*  </span>  </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" placeholder='Bengaluru' name="State" value={CurrentLocation} onChange={(e) => setCurrentLocation(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Mode of Commutation to work <span className=' text-red-600' id='commutationerror' >*  </span> </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" placeholder='Bus / Bike' id="State" name="State" value={TravellBy} onChange={(e) => setTravellBy(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Residing at <span className=' text-red-600' id='residenterror' >*  </span>  </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" placeholder='PG / Home ' name="State" value={StayWith} onChange={(e) => setStayWith(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Native <span className=' text-red-600' id='nativeerror' >*  </span> </label>
                                            <input type="text" placeholder='tamilnadu' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={Native} onChange={(e) => setNative(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">Mother Tongue <span className=' text-red-600' id='tongueerror' >*  </span>  </label>
                                            <input type="text" placeholder='tamil' className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={motherTongue} onChange={(e) => setMotherTongue(e.target.value)} />
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <div className="row justify-content-center m-0 mt-4">
                                <div className="col-lg-12 p-4 border rounded-lg">
                                    <div className="row m-0 pb-2">
                                        {persondata.CurrentCTC && < div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="Name" className="form-label">Last CTC </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastCTC" name="LastCTC"
                                                value={persondata.CurrentCTC} />
                                        </div>}
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="lastName" className="form-label">Expected CTC</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="ExpectedCTC" name="ExpectedCTC"
                                                value={persondata.ExpectedSalary} />
                                        </div>
                                        {persondata.NoticePeriod && <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="email" className="form-label">Notice Period</label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="NoticePeriod" name="NoticePeriod"
                                                value={persondata.NoticePeriod} />
                                        </div>}
                                        {/* <div className="col-md-6 col-lg-3 mb-3">
                          <label htmlFor="primaryContact" className="form-label">DOJ</label>
                          <input type="date" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="DOJ" name="DOJ" value={DOJ} onChange={(e) => setDOJ(e.target.value)} />
                        </div> */}
                                    </div>

                                    {/*  */}

                                    <div className="row m-0 pb-2 mt-4">

                                        <div className="mb-3  col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label ">6 Days Working:</label>
                                            <select className="form-select " id="ageGroup" value={sixDaysWorking} onChange={(e) => setsixDaysWorking(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                            </select>
                                        </div>
                                        <div className="mb-3  col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label">Flexibility on work Timings:</label>
                                            <select className="form-select " id="ageGroup" value={FlexibilityonWorkingTimings} onChange={(e) => setFlexibilityonWorkingTimings(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                            </select>
                                        </div>
                                    </div>
                                    {/*  */}

                                    <div className="row m-0 pb-2 mt-4">



                                        {/* <div className="mb-3  col-md-6 col-lg-6">
                          <label htmlFor="ageGroup" className="form-label">Certification Submission</label>
                          <select className="form-select " id="ageGroup" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} >
                            <option value="">Select</option>
                            <option value="yes">Yes</option>
                            <option value="no">No</option>
                          </select>
                        </div> */}

                                        {/*  */}

                                        <div className="mb-3  col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label">Relocation to other city:</label>
                                            <select className="form-select " id="ageGroup" value={relocationToCity} onChange={(e) => setRelocationToCity(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                            </select>
                                        </div>
                                        <div className="mb-3  col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label"> Have personal Laptop for work purpose  : </label>
                                            <select className="form-select " id="ageGroup" value={carrylaptop} onChange={(e) => setcarrylaptop(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                            </select>
                                        </div>
                                        {/*  */}

                                        {/*  */}

                                        <div className="mb-3 col-md-6 col-lg-6">
                                            <label htmlFor="ageGroup" className="form-label">Relocation to other centers:</label>
                                            <select className="form-select" id="ageGroup" value={relocationToCenters} onChange={(e) => setRelocationToCenters(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                            </select>
                                        </div>

                                        {/*  */}

                                        {/*  */}


                                        {/*  */}



                                    </div>
                                </div>
                            </div>


                            {/* Personal Details end */}
                            {/* Comments Start  */}
                            <h6 className='mt-4 text-primary'>Comments</h6>
                            <div className="row justify-content-center m-0 mt-4">
                                <div className="col-lg-12 p-4 border rounded-lg">
                                    <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-6 mb-3">
                                            <label htmlFor="InterviewerName" className="form-label">Interviewer Name </label>
                                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="InterviewerName" name="InterviewerName" value={username} />
                                        </div>


                                        <div className="mb-3 col-md-6 col-lg-6">
                                            <label htmlFor="researchCompany" className="form-label">Screening Status: <span className=' text-red-600' id='statuserror' >*  </span> </label>
                                            <select className="form-select" id="researchCompany" value={screeningstatus} onChange={(e) => setScreeningscreeningstatus(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="scheduled">Shortlisted to Next Round</option>
                                                <option value="rejected"> Rejected </option>
                                                <option value="walkout">Walked-out </option>
                                                <option value="to_client">Consider to Client for Merida </option>
                                            </select>
                                        </div>
                                        <div className="col-md-12 col-lg-12 mb-3">
                                            <label htmlFor="Comments" className="form-label">Comments <span className=' text-red-600' id='commecterror' >*  </span>  </label>
                                            <textarea placeholder='Give a Comment on performance...' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="Comments"
                                                value={comments} onChange={(e) => setComments(e.target.value)}></textarea>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            {/* Comments end */}

                        </form>
                    </Modal.Body>
                    <Modal.Footer>
                        <div className='d-flex gap-2'>

                            {/* <button type="button" class="btn btn-primary btn-sm">Preview</button> */}

                            <button type="submit" class="btn btn-success btn-sm"
                                onClick={handleScreeingform}>
                                Submit</button>
                        </div>

                    </Modal.Footer>
                </Modal>
            }
        </div>
    )
}

export default ScreeningAssigned