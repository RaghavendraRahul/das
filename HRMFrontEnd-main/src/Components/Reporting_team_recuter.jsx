import React, { useContext, useEffect, useState } from 'react'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import { useNavigate } from 'react-router-dom'
import Empsidebar from './Empsidebar'
import Recsidebar from './Recsidebar'
import { HrmStore } from '../Context/HrmContext'


const Reporting_team_recuter = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let UserName = JSON.parse(sessionStorage.getItem('user')).UserName
    let Disgnation = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let { setActivePage } = useContext(HrmStore)
    const [AllEmployeelist, setAllEmployeelist] = useState([])
    const [EMPLOYEE_INFORMATION, setEMPLOYEE_INFORMATION] = useState([])
    const [EDUCATION_DETAILS, setEDUCATION_DETAILS] = useState([])
    const [FAMILY_DETAILS, setFAMILY_DETAILS] = useState([])
    const [EMERGENCY_DETAILS, setEMERGENCY_DETAILS] = useState([])
    const [CONTACT_EMERGENCY, setCONTACT_EMERGENCY] = useState([])
    const [REFERENCE, setREFERENCE] = useState([])
    const [EXPERIENCE_LAST_POSITION, setEXPERIENCE_LAST_POSITION] = useState([])
    const [LAST_POSITION_HELD, setLAST_POSITION_HELD] = useState([])
    const [PERSONAL_INFORMATION, setPERSONAL_INFORMATION] = useState([])
    const [EMPLOYEEIDENTITY, setEMPLOYEEIDENTITY] = useState([])
    const [BANK_ACCOUNT_DETAILS, setBANK_ACCOUNT_DETAILS] = useState([])
    const [PFDETAILS, setPFDETAILS] = useState([])
    const [ADDITIONAL_INFORMATION, setADDITIONAL_INFORMATION] = useState([])
    const [ATTACHMENTS, setATTACHMENTS] = useState([])
    const [DOCUMENTS_SUBMITED, setDOCUMENTS_SUBMITED] = useState([])
    const [DECLARATION, setDECLARATION] = useState([])

    useEffect(() => {

        fetchdata()
        setActivePage('team')
    }, [])

    const fetchdata = () => {
        axios.get(`${port}/root/ems/ReportingTeam/${Empid}/`).then((res) => {
            console.log("ReportingTeam_res", res.data);
            setAllEmployeelist(res.data)

        }).catch((err) => {
            console.log("ReportingTeam_err", err.data);
        })
    }

    const sentparticularData = (id) => {

        console.log(id);

        axios.get(`${port}/root/ems/ReportingTeam/${id}/`)
            .then(response => {

                console.log('Paticular_Employee_Data_Res', response.data);
                setEMPLOYEE_INFORMATION(response.data.EmployeeInformation)
                setREFERENCE(response.data.CandidateReferenceDetails)
                setEDUCATION_DETAILS(response.data.EducationDetails);
                setCONTACT_EMERGENCY(response.data.EmergencyContactDetails);
                setFAMILY_DETAILS(response.data.FamilyDetails);
                setEMERGENCY_DETAILS(response.data.EmergencyDetails);
                setLAST_POSITION_HELD(response.data.LastPositionHeldDetails);
                setEXPERIENCE_LAST_POSITION(response.data.ExperienceDetails);

            })
            .catch(error => {

                console.error('Paticular_Employee_Data_Err', error.data);
            });
    };


    // SEARCH START

    const [searchValue, setSearchValue] = useState("");

    const handlesearchvalue = (value) => {

        console.log(value);
        setSearchValue(value)

        if (value.length > 0) {

            axios.get(`${port}/root/ems/ReportingTeam/${Empid}/`).then((res) => {
                console.log("search_res", res.data);
                setAllEmployeelist(res.data)
            }).catch((err) => {
                console.log("search_res", err.data);
            })
        }
        else {
            fetchdata()
        }
    }
    // SEARCH END




    const [ResignationRequest, setResignationRequest] = useState([])

    const [reform_id, set_reform_id] = useState()
    const [HR_manager_name, set_HR_manager_name] = useState('')
    const [Re_manager_name, set_Re_manager_name] = useState('')

    console.log("sdasdadsd", reform_id);

    // console.log("sdasass", ResignationRequest);
    const [LeaveRequests, setLeaveRequests] = useState([])
    const [Reporting_Team_List, setReporting_Team_List] = useState(true)
    const [All_request_data, setAll_request_data] = useState(false)

    useEffect(() => {

    })

    // Verfied Form start
    // const [Report_Manager_name, setReport_Manager_name] = useState("")
    // const [HR_Verified, set_HR_Verified] = useState("")
    // const [Verified_Date, set_Verified_Date] = useState("")
    // const [Date_Of_Interview, set_Date_Of_Interview] = useState("")
    // const [Remarks, set_Remarks] = useState("")

    const [Re_Verified, set_Re_Verified] = useState("")
    const [Re_Verified_Date, set_Re_Verified_Date] = useState("")
    const [Re_Remarks, set_Re_Remarks] = useState("")

    let Resignation_Request_Re_Verification = (e) => {
        e.preventDefault()

        alert("Re Verification")

        const formData1 = new FormData()

        formData1.append('id', reform_id);
        formData1.append('HR_manager_name', HR_manager_name);
        formData1.append('re_manager_name', Re_manager_name);
        formData1.append('is_rm_verified', Re_Verified);
        formData1.append('rm_verified_on', Re_Verified_Date);
        formData1.append('rm_remarks', Re_Remarks);

        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/ems/RM_ResignationVerification`, formData1).then((res) => {
            console.log("RM_Resignation_Verifivation_res", res.data);
            alert(res.data)

        }).catch((err) => {
            console.log("RM_Resignation_Verifivation_err", err.data);
        })

    }




    // let Resignation_Request_Verification = (e) => {
    //     e.preventDefault()

    //     alert("hello")

    //     const formData1 = new FormData()

    //     formData1.append('HR_manager_name', UserName);
    //     formData1.append('is_hr_verified', HR_Verified);
    //     formData1.append('hr_verified_on', Verified_Date);
    //     formData1.append('Date_of_Interview', Date_Of_Interview);
    //     formData1.append('hr_remarks', Remarks);

    //     for (let pair of formData1.entries()) {
    //         console.log(pair[0] + ': ' + pair[1]);
    //     }


    // }

    // Verfied Form end

    return (
        <div className=' d-flex' style={{ width: '100%', minHeight: '100%',  }}>

            <div className='d-none d-lg-flex'>
                <Recsidebar></Recsidebar>

            </div>
            <div className=' m-0 m-sm-4 flex-1 container-fluid mx-auto ' style={{ borderRadius: '10px' }}>
                <div style={{ marginLeft: '10px' }}>

                    <Topnav></Topnav>
                </div>

                {/* Reporting Team List Start */}
                <div className={`p-3 ${Reporting_Team_List ? '' : 'd-none'}`}>


                    <div className='mt-3 All_emp_Top_btns' >
                        <div>
                            <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Reporting Team List</h6>

                        </div>
                        <div>

                            <div className='' style={{ display: 'flex', justifyContent: 'end' }}>


                                <div class="input-group mb-3 me-3">
                                    <span class="input-group-text" id="basic-addon1" style={{ width: '40px', height: '32px', outline: 'none', fontSize: '14px' }}> <i class="fa-solid fa-magnifying-glass " ></i>  </span>
                                    <input type="text" value={searchValue} style={{ width: '180px', height: '32px', fontSize: '9px', outline: 'none' }}
                                        onChange={(e) => {
                                            handlesearchvalue(e.target.value)
                                        }} class="form-control shadow-none" aria-label="Username" aria-describedby="basic-addon1" />
                                </div>

                                <div>
                                    <button style={{ width: '100px', height: '32px', fontSize: '12px', outline: 'none ' }} className='btn  bg-info-subtle btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal9" >Add New</button>
                                </div>

                            </div>

                        </div>
                    </div>

                    <div className=' p-1 mt-3 tablebg rounded table-responsive' style={{ marginLeft: '0px' }}>
                        <table class="w-full" >
                            <thead >
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Employee ID</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Join Date</th>
                                    <th scope="col">Role</th>
                                    <th scope="col">Department</th>
                                    <th scope="col">Request</th>
                                </tr>
                            </thead>
                            <tbody>
                                {/* <tr>
                                <th scope="row">1</th>
                                <td>Rakesh</td>
                                <td>rakkiii49sh8@gmail.com</td>
                                <td>MTM123</td>
                                <td>6381849973</td>
                                <td>12/1/2023</td>
                                <td>FrontEnd Developer</td>
                                <td>
                                    <button>✔</button>
                                    <button>❌</button>
                                </td>
                            </tr> */}
                                {AllEmployeelist != undefined && AllEmployeelist != undefined && AllEmployeelist.map((e, index) => {
                                    return (


                                        <tr>

                                            <td key={e.id}> {index + 1}</td>
                                            <td onClick={() => sentparticularData(e.id)} data-bs-toggle="modal" data-bs-target="#exampleModal5" key={e.id} style={{ cursor: 'pointer' }}> {e.full_name}</td>
                                            <td key={e.id}> {e.email}</td>
                                            <td key={e.id}> {e.employee_Id}</td>
                                            <td key={e.id}> {e.mobile}</td>
                                            <td key={e.id}> {e.Date_of_Joining}</td>
                                            <td key={e.id}> {e.Designation}</td>
                                            <td key={e.id}> {e.Department}</td>

                                            <td>

                                                {/* <span className={`text-center ${e.Requests != undefined && e.Requests.LeaveRequests.length >= 0 ? 'd-none' : 'bg-warning'}`} style={{ position: 'relative', left: '33px', bottom: '10px', fontSize: '11px', color: 'red' }} > </span> */}
                                                <button className='btn '


                                                    onClick={() => {
                                                        if (e.Requests.ResignationRequest.length > 0) {

                                                            setResignationRequest(e.Requests.ResignationRequest)
                                                            set_reform_id(e.Requests.ResignationRequest[0].id)
                                                            setLeaveRequests(e.Requests.LeaveRequests)
                                                            set_HR_manager_name(e.Requests.ResignationRequest[0].reporting_manager_name)
                                                            set_Re_manager_name(e.Requests.ResignationRequest[0].HR_manager_name)
                                                            setAll_request_data(true)
                                                            setReporting_Team_List(false)
                                                        }
                                                        else {
                                                            alert('No Requests ')
                                                        }
                                                    }}




                                                >  <i class={`fa-solid fa-person-circle-question ${e.Requests.ResignationRequest.length > 0 ? ' text-success' : 'text-danger'}`}></i></button>

                                            </td>


                                        </tr>


                                    )
                                })}



                            </tbody>
                        </table>



                    </div>

                </div>
                {/* Reporting Team List End */}


                {/* All_request_data start */}

                <div className={`p-3 ${All_request_data ? '' : 'd-none'}`}>
                    <button onClick={(e) => {
                        e.preventDefault()
                        setReporting_Team_List(true)
                        setAll_request_data(false)
                    }}>Back</button>
                    <div className='mt-3' style={{ position: 'relative', left: '3px', width: '97%' }}>



                        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Resignation Request</h6>
                            </li>

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="false">Leave Request</h6>
                            </li>

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" type="button" role="tab" aria-controls="pills-contact" aria-selected="false">In Time / Out Time Request</h6>
                            </li>






                        </ul>

                        <div class="tab-content " id="pills-tabContent" style={{ position: 'relative', bottom: '20px' }}>
                            <div class="tab-pane fade show active " id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">
                                <div className='p-3 border'>
                                    {ResignationRequest != undefined && ResignationRequest != undefined && ResignationRequest.map((e) => {
                                        return (
                                            <div style={{ lineHeight: '40px' }}>

                                                <li class="list-group-item"><strong>Name  :</strong> {e.name} </li>
                                                <li class="list-group-item"><strong>Employee Id :</strong> {e.employee_id} </li>
                                                {/* <li class="list-group-item"><strong>Id  :</strong> {e.id} </li> */}
                                                <li class="list-group-item"><strong>Reason  :</strong> {e.reason}</li>
                                                <li class="list-group-item"><strong>position  :</strong> {e.position} </li>
                                                <li class="list-group-item"><strong>Reporting Manager Name  :</strong> {e.reporting_manager_name} </li>
                                                <li class="list-group-item"><strong>Resigned Letter File  :</strong> <a href={e.resigned_letter_file}>resigned_letter_file</a></li>

                                            </div>
                                        )
                                    })}
                                </div>

                                {/* Hr Manager Start */}

                                {/* <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">HR Verified* </label>
                                            <select className="form-select" id="ageGroup" value={HR_Verified} onChange={(e) => set_HR_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Verified_Date} onChange={(e) => set_Verified_Date(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Date Of Interview* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Date_Of_Interview} onChange={(e) => set_Date_Of_Interview(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Remarks} onChange={(e) => set_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div> */}
                                {/* Hr Manager End */}


                                {/* Reporting MAnager Start */}

                                <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified* </label>
                                            <select className="form-select" id="ageGroup" value={Re_Verified} onChange={(e) => set_Re_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="True">Yes</option>
                                                <option value="False">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Re_Verified_Date} onChange={(e) => set_Re_Verified_Date(e.target.value)} />
                                        </div>

                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Re_Remarks} onChange={(e) => set_Re_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Re_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div>

                                {/* Reporting MAnager End */}



                            </div>
                            <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">

                                <div className='p-3 border'>
                                    {ResignationRequest != undefined && ResignationRequest != undefined && ResignationRequest.map((e) => {
                                        return (
                                            <div style={{ lineHeight: '40px' }}>

                                                <li class="list-group-item"><strong>Name  :</strong> {e.name} </li>
                                                <li class="list-group-item"><strong>Employee Id :</strong> {e.employee_id} </li>
                                                {/* <li class="list-group-item"><strong>Id  :</strong> {e.id} </li> */}
                                                <li class="list-group-item"><strong>Reason  :</strong> {e.reason}</li>
                                                <li class="list-group-item"><strong>position  :</strong> {e.position} </li>
                                                <li class="list-group-item"><strong>Reporting Manager Name  :</strong> {e.reporting_manager_name} </li>
                                                <li class="list-group-item"><strong>Resigned Letter File  :</strong> <a href={e.resigned_letter_file}>resigned_letter_file</a></li>

                                            </div>
                                        )
                                    })}
                                </div>

                                {/* Hr Manager Start */}

                                {/* <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">HR Verified* </label>
                                            <select className="form-select" id="ageGroup" value={HR_Verified} onChange={(e) => set_HR_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Verified_Date} onChange={(e) => set_Verified_Date(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Date Of Interview* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Date_Of_Interview} onChange={(e) => set_Date_Of_Interview(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Remarks} onChange={(e) => set_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div> */}
                                {/* Hr Manager End */}


                                {/* Reporting MAnager Start */}

                                <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified* </label>
                                            <select className="form-select" id="ageGroup" value={Re_Verified} onChange={(e) => set_Re_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="True">Yes</option>
                                                <option value="False">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Re_Verified_Date} onChange={(e) => set_Re_Verified_Date(e.target.value)} />
                                        </div>

                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Re_Remarks} onChange={(e) => set_Re_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Re_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div>

                                {/* Reporting MAnager End */}

                            </div>
                            <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">
                                <div className='p-3 border'>
                                    {ResignationRequest != undefined && ResignationRequest != undefined && ResignationRequest.map((e) => {
                                        return (
                                            <div style={{ lineHeight: '40px' }}>

                                                <li class="list-group-item"><strong>Name  :</strong> {e.name} </li>
                                                <li class="list-group-item"><strong>Employee Id :</strong> {e.employee_id} </li>
                                                {/* <li class="list-group-item"><strong>Id  :</strong> {e.id} </li> */}
                                                <li class="list-group-item"><strong>Reason  :</strong> {e.reason}</li>
                                                <li class="list-group-item"><strong>position  :</strong> {e.position} </li>
                                                <li class="list-group-item"><strong>Reporting Manager Name  :</strong> {e.reporting_manager_name} </li>
                                                <li class="list-group-item"><strong>Resigned Letter File  :</strong> <a href={e.resigned_letter_file}>resigned_letter_file</a></li>

                                            </div>
                                        )
                                    })}
                                </div>

                                {/* Hr Manager Start */}

                                {/* <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">HR Verified* </label>
                                            <select className="form-select" id="ageGroup" value={HR_Verified} onChange={(e) => set_HR_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Verified_Date} onChange={(e) => set_Verified_Date(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Date Of Interview* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Date_Of_Interview} onChange={(e) => set_Date_Of_Interview(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Remarks} onChange={(e) => set_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div> */}
                                {/* Hr Manager End */}


                                {/* Reporting MAnager Start */}

                                <div className={` mt-4 `}>

                                    <div class="row">


                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified* </label>
                                            <select className="form-select" id="ageGroup" value={Re_Verified} onChange={(e) => set_Re_Verified(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="True">Yes</option>
                                                <option value="False">No</option>

                                            </select>
                                        </div>

                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Verified Date* </label>
                                            <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Re_Verified_Date} onChange={(e) => set_Re_Verified_Date(e.target.value)} />
                                        </div>

                                        <div className="col-md-6 col-lg-12 mb-3">
                                            <label htmlFor="Name" className="form-label">Remarks* </label>
                                            <textarea type="text" style={{ height: '70px' }} className="form-control shadow-none" id="Name" name="Name" value={Re_Remarks} onChange={(e) => set_Re_Remarks(e.target.value)} />
                                        </div>
                                        <div className="col-md-6 col-lg-12 mb-3 d-flex justify-content-end">

                                            <button className='btn btn-success ' onClick={Resignation_Request_Re_Verification} >submit</button>

                                        </div>
                                    </div>
                                </div>

                                {/* Reporting MAnager End */}

                            </div>
                            <div class="tab-pane fade" id="pills-contact1" role="tabpanel" aria-labelledby="pills-contact-tab1" tabindex="0">

                                <h1>4</h1>

                            </div>
                            <div class="tab-pane fade" id="pills-contact2" role="tabpanel" aria-labelledby="pills-contact-tab2" tabindex="0">

                                <h1>5</h1>

                            </div>
                        </div>

                    </div>
                </div>
                {/* All_request_data End */}


                {/* open Particular Data Start */}

                <div class="modal fade" id="exampleModal5" tabindex="-1" aria-labelledby="exampleModalLabel5" aria-hidden="true">
                    <div class="modal-dialog modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title " id="exampleModalLabel5">Employee All Information</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EMPLOYEE INFORMATION</h6>

                                <div className="border p-4">

                                    <div>
                                        {/* <li className="list-group-item"><strong>id:</strong> {EMPLOYEE_INFORMATION.id}</li> */}
                                        <li className="list-group-item"><strong>Employee ID:</strong> {EMPLOYEE_INFORMATION.employee_Id}</li>
                                        <li className="list-group-item"><strong>Created At:</strong> {EMPLOYEE_INFORMATION.created_at}</li>
                                        <li className="list-group-item"><strong>Full Name:</strong> {EMPLOYEE_INFORMATION.full_name}</li>
                                        <li className="list-group-item"><strong>Date of Birth:</strong> {EMPLOYEE_INFORMATION.date_of_birth}</li>
                                        <li className="list-group-item"><strong>Gender:</strong> {EMPLOYEE_INFORMATION.gender}</li>
                                        <li className="list-group-item"><strong>Mobile:</strong> {EMPLOYEE_INFORMATION.mobile}</li>
                                        <li className="list-group-item"><strong>Email:</strong> {EMPLOYEE_INFORMATION.email}</li>
                                        <li className="list-group-item"><strong>Weight:</strong> {EMPLOYEE_INFORMATION.weight}</li>
                                        <li className="list-group-item"><strong>Height:</strong> {EMPLOYEE_INFORMATION.height}</li>
                                        <li className="list-group-item"><strong>Permanent Address:</strong> {EMPLOYEE_INFORMATION.permanent_address}</li>
                                        <li className="list-group-item"><strong>Present Address:</strong> {EMPLOYEE_INFORMATION.present_address}</li>
                                        <li className="list-group-item"><strong>Designation:</strong> {EMPLOYEE_INFORMATION.Designation}</li>
                                        <li className="list-group-item"><strong>Profile Verification:</strong> {EMPLOYEE_INFORMATION.ProfileVerification ? "Yes" : "No"}</li>
                                        <li className="list-group-item"><strong>Candidate ID:</strong> {EMPLOYEE_INFORMATION.Candidate_id}</li>
                                        <li className="list-group-item"><strong>Offered Instances:</strong> {EMPLOYEE_INFORMATION.Offered_Instance}</li>
                                    </div>

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EDUCATION DETAILS</h6>

                                <div className="border p-4">

                                    {EDUCATION_DETAILS != undefined && EDUCATION_DETAILS != undefined && EDUCATION_DETAILS.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong>{e.id}</li> */}
                                                <li class="list-group-item"><strong>Qualification:</strong> {e.Qualification}</li>
                                                <li class="list-group-item"><strong>University:</strong> {e.University}</li>
                                                <li class="list-group-item"><strong>Year of Passout:</strong> {e.year_of_passout}</li>
                                                <li class="list-group-item"><strong>Percentage:</strong> {e.Persentage}</li>
                                                <li class="list-group-item"><strong>Major Subject:</strong> {e.Major_Subject}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        )
                                    })}


                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >FAMILY DETAILS</h6>

                                <div className="border p-4">

                                    {FAMILY_DETAILS != undefined && FAMILY_DETAILS.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong> {e.id}</li> */}
                                                <li class="list-group-item"><strong>Name:</strong> {e.name}</li>
                                                <li class="list-group-item"><strong>Relation:</strong> {e.relation}</li>
                                                <li class="list-group-item"><strong>Date of Birth:</strong> {e.dob}</li>
                                                <li class="list-group-item"><strong>Age:</strong> {e.age}</li>
                                                <li class="list-group-item"><strong>Blood Group:</strong> {e.blood_group}</li>
                                                <li class="list-group-item"><strong>Gender:</strong> {e.gender}</li>
                                                <li class="list-group-item"><strong>Profession:</strong> {e.profession}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        );
                                    })}

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EMERGENCY DETAILS</h6>

                                <div className="border p-4">

                                    {EMERGENCY_DETAILS != undefined && EMERGENCY_DETAILS.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong> {e.id}</li> */}
                                                <li class="list-group-item"><strong>Blood Group:</strong> {e.blood_group}</li>
                                                <li class="list-group-item"><strong>Allergic To:</strong> {e.allergic_to}</li>
                                                <li class="list-group-item"><strong>Blood Pressure:</strong> {e.blood_pessure}</li>
                                                <li class="list-group-item"><strong>Diabetics:</strong> {e.Diabetics}</li>
                                                <li class="list-group-item"><strong>Other Illness:</strong> {e.other_illness}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        );
                                    })}

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >CONTACT PERSON IN CASE OF EMERGENCY</h6>

                                <div className="border p-4">


                                    {CONTACT_EMERGENCY != undefined && CONTACT_EMERGENCY.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong> {e.id}</li> */}
                                                <li class="list-group-item"><strong>Person Name:</strong> {e.person_name}</li>
                                                <li class="list-group-item"><strong>Relation:</strong> {e.relation}</li>
                                                <li class="list-group-item"><strong>Address:</strong> {e.address}</li>
                                                <li class="list-group-item"><strong>Country:</strong> {e.country}</li>
                                                <li class="list-group-item"><strong>State:</strong> {e.state}</li>
                                                <li class="list-group-item"><strong>City:</strong> {e.city}</li>
                                                <li class="list-group-item"><strong>Pincode:</strong> {e.pincode}</li>
                                                <li class="list-group-item"><strong>Phone:</strong> {e.phone}</li>
                                                <li class="list-group-item"><strong>Email:</strong> {e.email}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        );
                                    })}

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >REFERENCE : NAME & ADDRESS OF AT LEAST TWO REFERENCES NOT RELATED TO YOU</h6>

                                <div className="border p-4">

                                    {REFERENCE != undefined && REFERENCE.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong> {e.id}</li> */}
                                                <li class="list-group-item"><strong>Person Name:</strong> {e.person_name}</li>
                                                <li class="list-group-item"><strong>Relation:</strong> {e.relation}</li>
                                                <li class="list-group-item"><strong>Address:</strong> {e.address}</li>
                                                <li class="list-group-item"><strong>Country:</strong> {e.country}</li>
                                                <li class="list-group-item"><strong>State:</strong> {e.state}</li>
                                                <li class="list-group-item"><strong>City:</strong> {e.city}</li>
                                                <li class="list-group-item"><strong>Phone:</strong> {e.phone}</li>
                                                <li class="list-group-item"><strong>Email:</strong> {e.email}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        );
                                    })}

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EXPERIENCE (CHRONOLOGICAL ORDER EXCLUDING LAST POSITION)</h6>

                                <div className="border p-4">

                                    {EXPERIENCE_LAST_POSITION !== undefined && EXPERIENCE_LAST_POSITION.map((employment, index) => (
                                        <div key={index}>
                                            {/* <li className="list-group-item"><strong>ID:</strong> {employment.id}</li> */}
                                            <li className="list-group-item"><strong>Organisation:</strong> {employment.organisation}</li>
                                            <li className="list-group-item"><strong>From Date:</strong> {employment.from_date}</li>
                                            <li className="list-group-item"><strong>To Date:</strong> {employment.to_date}</li>
                                            <li className="list-group-item"><strong>Last Position Held:</strong> {employment.last_position_held}</li>
                                            <li className="list-group-item"><strong>At the Time of Joining:</strong> {employment.at_the_time_of_joining}</li>
                                            <li className="list-group-item"><strong>Job Responsibility:</strong> {employment.job_responsibility}</li>
                                            <li className="list-group-item"><strong>Immediate Superior Designation:</strong> {employment.immediate_superior_designation}</li>
                                            <li className="list-group-item"><strong>Gross Salary Drawn:</strong> {employment.gross_salary_drawn}</li>
                                            <li className="list-group-item"><strong>Reason for Leaving:</strong> {employment.reason_for_leaving}</li>
                                            <li className="list-group-item"><strong>EMP Information:</strong> {employment.EMP_Information}</li>
                                        </div>
                                    ))}

                                </div>
                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >LAST POSITION HELD</h6>

                                <div className="border p-4">
                                    {LAST_POSITION_HELD != undefined && LAST_POSITION_HELD.map((e) => {
                                        return (
                                            <div key={e.id}>
                                                {/* <li class="list-group-item"><strong>id:</strong> {e.id}</li> */}
                                                <li class="list-group-item"><strong>Organisation:</strong> {e.organisation}</li>
                                                <li class="list-group-item"><strong>Designation:</strong> {e.designation}</li>
                                                <li class="list-group-item"><strong>Address:</strong> {e.address}</li>
                                                <li class="list-group-item"><strong>Reporting To Name:</strong> {e.repoting_to_name}</li>
                                                <li class="list-group-item"><strong>Reporting To Designation:</strong> {e.repoting_to_designation}</li>
                                                <li class="list-group-item"><strong>Reporting To Email:</strong> {e.repoting_to_email}</li>
                                                <li class="list-group-item"><strong>Reporting To Phone:</strong> {e.repoting_to_phone}</li>
                                                <li class="list-group-item"><strong>Gross Salary Per Month:</strong> {e.gross_salary_per_month}</li>
                                                <li class="list-group-item"><strong>Basic:</strong> {e.basic}</li>
                                                <li class="list-group-item"><strong>HRA:</strong> {e.HRA}</li>
                                                <li class="list-group-item"><strong>LTA:</strong> {e.LTA}</li>
                                                <li class="list-group-item"><strong>Medical:</strong> {e.medical}</li>
                                                <li class="list-group-item"><strong>Conveyance:</strong> {e.conveyance}</li>
                                                <li class="list-group-item"><strong>Provident Fund:</strong> {e.provident_fund}</li>
                                                <li class="list-group-item"><strong>Gratuity:</strong> {e.gratuity}</li>
                                                <li class="list-group-item"><strong>Others:</strong> {e.others}</li>
                                                <li class="list-group-item"><strong>Total:</strong> {e.total}</li>
                                                <li class="list-group-item"><strong>EMP Information:</strong> {e.EMP_Information}</li>
                                            </div>
                                        );
                                    })}

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EMPLOYEE PERSONAL INFORMATION</h6>

                                <div className="border p-4">

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >EMPLOYEE IDENTITY FORM</h6>

                                <div className="border p-4">

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >BANK ACCOUNT DETAILS</h6>

                                <div className="border p-4">

                                </div>
                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >PF DETAILS</h6>

                                <div className="border p-4">

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >ADDITIONAL INFORMATION</h6>

                                <div className="border p-4">

                                </div>

                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >ATTACHMENTS</h6>

                                <div className="border p-4">

                                </div>
                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >DOCUMENTS SUBMITED</h6>

                                <div className="border p-4">

                                </div>
                                <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} >DECLARATION</h6>

                                <div className="border p-4">

                                </div>


                            </div>
                            <div class="modal-footer d-flex justify-content-between">
                                <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                                <div className='d-flex gap-2'>

                                    {/* <button type="button" class="btn btn-primary">Assign Task</button> */}

                                    <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button>



                                    {/* <button type="button" class="btn btn-info">Offer Letter</button> */}


                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* open Particular Data End */}





            </div>



        </div>
    )
}

export default Reporting_team_recuter