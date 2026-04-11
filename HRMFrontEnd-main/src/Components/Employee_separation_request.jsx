import React, { useContext } from 'react'
import Topnav from './Topnav'
import '../assets/css/fonts.css';
import '../assets/css/media.css'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Sidebar from './Sidebar';
import '../assets/css/modal.css'
import { port } from '../App'
import { HrmStore } from '../Context/HrmContext';



const Employee_separation_request = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('Employee')
    }, [])

    const [AllResignationList, setAllResignationList] = useState([])
    const [Completed_Resignation_List, setCompleted_Resignation_List] = useState([])



    useEffect(() => {

        axios.get(`${port}/root/ems/ExitEmployeeList/${Empid}/`).then((res) => {
            console.log("ExitEmployeeList_res", res.data);
            setCompleted_Resignation_List(res.data)

        }).catch((err) => {
            console.log("ExitEmployeeList_err", err.data);
        })

    }, [])

    useEffect(() => {

        fetchdata()

    }, [])

    const fetchdata = () => {
        axios.get(`${port}/root/ems/HR_ResignationVerification_List/${Empid}/`).then((res) => {
            console.log("HR_Resignationverification_List_res", res.data);
            setAllResignationList(res.data)

        }).catch((err) => {
            console.log("HR_Resignationverification_List_err", err.data);
        })
    }

    // Particular_Resignation_Data start

    const [id, setid] = useState('')
    const [HR_manager_name, set_HR_manager_name] = useState('')
    const [Re_manager_name, set_Re_manager_name] = useState('')
    const [HR_AllResignation_List, setHR_AllResignation_List] = useState(true)
    const [HR_AllResignation_Particular_Data, setHR_AllResignation_Particular_Data] = useState(false)
    const [HR_AllResignation_List1, setHR_AllResignation_List1] = useState(true)
    const [HR_AllResignation_Particular_Data1, setHR_AllResignation_Particular_Data1] = useState(false)
    const [HR_AllResignation_List2, setHR_AllResignation_List2] = useState(true)
    const [HR_AllResignation_Particular_Data2, setHR_AllResignation_Particular_Data2] = useState(false)


    // const [Report_Manager_name, setReport_Manager_name] = useState("")
    const [HR_Verified, set_HR_Verified] = useState("")
    // const [Verified_Date, set_Verified_Date] = useState("")
    const [Date_Of_Interview, set_Date_Of_Interview] = useState("")
    const [Remarks, set_Remarks] = useState("")



    // Particular_Resignation_Data end

    let Resignation_Request_Verification = (e) => {
        e.preventDefault()

        alert("Request Verification")

        const formData1 = new FormData()


        formData1.append('id', id);
        formData1.append('HR_manager_name', HR_manager_name);
        // formData1.append('re_manager_name', Re_manager_name);
        formData1.append('is_hr_verified', HR_Verified);
        // formData1.append('hr_verified_on', Verified_Date);
        formData1.append('Date_of_Interview', Date_Of_Interview);
        formData1.append('hr_remarks', Remarks);

        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/ems/HR_ResignationVerification`, formData1).then((res) => {
            alert(res.data)
            console.log("HR_Resignation_Verifivation_res", res.data);

        }).catch((err) => {
            console.log("HR_Resignation_Verifivation_err", err.data);
        })


    }

    const [ResignationRequestData, setResignationRequestData] = useState({})

    let hello = (x) => {



        axios.get(`${port}/root/ems/HR_ResignationVerification/${x}/`).then((res) => {
            console.log("HR_ResignationVerifivation_Res", res.data);
            setResignationRequestData(res.data)

        }).catch((err) => {
            console.log("HR_ResignationVerifivation_Err", err.data);
        })




    }

    const [EmpLeftOrganization_res, setEmpLeftOrganization_res] = useState([])

    // console.log("hello",EmpLeftOrganization_res);

    useEffect(() => {

        axios.get(`${port}/root/ems/EmpLeftOrganization`).then((res) => {
            console.log("EmpLeftOrganization_res", res.data);
            setEmpLeftOrganization_res(res.data)
            checkDateAndCallAPI()

        }).catch((err) => {
            console.log("EmpLeftOrganization_err", err.data);
        })


    }, [])

    useEffect(() => {

        // alert("EmpLeftOrganization_Post_Calling_useEffect")

        const currentDate = new Date().toISOString().slice(0, 10); // Get current date in "YYYY-MM-DD" format

        console.log("current_Date", currentDate);

        if (EmpLeftOrganization_res) {
            let arry = []
            EmpLeftOrganization_res.map((e, index) => {
                console.log(currentDate);
                console.log("Date_of_Joining", e.Leaving_date);
                if (e.Leaving_date == currentDate && !e.mail_sent) {
                    console.log("Date matched! Calling API..." + index);
                    arry.push(e.instance)
                }
            });
            console.log(arry);
            if (arry.length > 0) {
                axios.post(`${port}/root/ems/EmpLeftOrganization`, arry).then((res) => {
                    console.log("Leaving_res", res);
                }).catch((error) => console.log(error))
            }
        }

    }, [EmpLeftOrganization_res])

    const checkDateAndCallAPI = () => {

        // alert("EmpLeftOrganization_Post_Calling_method")

        const currentDate = new Date().toISOString().slice(0, 10); // Get current date in "YYYY-MM-DD" format

        // console.log( "sd",currentDate);

        EmpLeftOrganization_res.map((e, index) => {

            // console.log(e.Date_of_Joining);

            if (e.Leaving_date == currentDate && !e.mail_sent) {


                const formData = new FormData();
                formData.append('instance', e.instance);
                // formData.append('FormURL', `http://localhost:9000/Employeeallform/`);

                axios.post(`${port}/root/ems/EmpLeftOrganization`, formData).then((res) => {
                    console.log("Leaving_res", res);
                })
                console.log("Date matched! Calling API..." + index);
            } else {

                console.log("Date does not match. No API call needed." + index);
            }
        });
    };





    // EXIT INTERVIEW FORM  START
    const [Days_ToServeNotice, setDays_ToServeNotice] = useState('');
    const [Notice_period_agrry, setNotice_period_agrry] = useState('');
    const [Compantation, setCompantation] = useState('');
    const [Compantation_PayAgrry, setCompantation_PayAgrry] = useState('')
    const [Date_toLeave, setDate_toLeave] = useState('')
    const [Fit_ToBeRehired, setFit_ToBeRehired] = useState('')
    const [Alternate_Email, setAlternate_Email] = useState('')
    const [Alternate_Mobile, setAlternate_Mobile] = useState('')
    const [DesignationStatus, set_DesignationStatus] = useState('')
    const [FinalRemarks, setFinalRemarks] = useState('')

    const handle_employee_Exit_Interview_form = (e) => {
        e.preventDefault()
        alert("EXIT INTERVIEW FORM ")

        const formData2 = new FormData()

        formData2.append('id', id);
        formData2.append('Days_to_Serve_Notice', ResignationRequestData.notice_period);
        formData2.append('notice_period_agrry', Notice_period_agrry);
        formData2.append('compensation', ResignationRequestData.notice_pay);
        formData2.append('compensation_pay_agrry', Compantation_PayAgrry);
        formData2.append('Date_to_Leave', Date_toLeave);
        formData2.append('FitToBeRehired', Fit_ToBeRehired);
        formData2.append('AlternateEmail', Alternate_Email);
        formData2.append('AlternateMobile', Alternate_Mobile);
        formData2.append('resignation_verification', DesignationStatus);
        formData2.append('remarks', FinalRemarks);




        for (let pair of formData2.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/ems/EmployeeExitInterview`, formData2).then((res) => {
            console.log("EmployeeExitInterview_res", res.data);
            alert(res.data)

        }).catch((err) => {
            console.log("EmployeeExitInterview_err", err.data);
        })

    }

    // EXIT INTERVIEW FORM  END

    // let date = '2024-05-23'


    const [currentDate, setCurrentDate] = useState('');

    useEffect(() => {
        const date = new Date();
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(date.getDate()).padStart(2, '0');
        setCurrentDate(`${year}-${month}-${day}`);
    }, []);




    return (

        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', }}>

            <div className=''>

                <Sidebar value={"dashboard"} ></Sidebar>

            </div>
            <div className=' m-0 m-sm-4 flex-1 container mx-auto ' style={{ borderRadius: '10px' }}>
                <Topnav ></Topnav>

                {/* <div className='d-flex justify-content-between mt-4 ms-3' >
                    <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Resignation Request</h6>
                </div> */}

                <ul class="nav nav-pills mb-3 mt-4" id="pills-tab" role="tablist">
                    <li class="nav-item text-primary d-flex " role="presentation">
                        <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Resignation Request</h6>

                        {/* <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Applyed Canditates List</h6> */}
                    </li>

                    <li class="nav-item text-primary d-flex" role="presentation">
                        <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false">Exit  Interview List </h6>
                    </li>
                    <li class="nav-item text-primary d-flex" role="presentation">
                        <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" role="tab" aria-controls="pills-contact" aria-selected="false">Completed Resignation List</h6>
                    </li>
                    {/* <li class="nav-item text-primary d-flex" role="presentation">
                        <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-completed-tab" data-bs-toggle="pill" data-bs-target="#pills-completed" role="tab" aria-controls="pills-completed" aria-selected="false">Final Status List</h6>
                    </li> */}
                </ul>

                <div class="tab-content p-1" id="myTabContent">
                    <div class="tab-pane fade show active mt-1" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
                        <div class="table-responsive ">

                            {/* Nav Tabs  start */}

                            <div class="tab-content" id="pills-tabContent">
                                {/* Tab 1 start */}
                                <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">

                                    <div className={`p-1   ${HR_AllResignation_List ? '' : 'd-none'}`}>
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">Name</th>
                                                    {/* <th scope="col">Email</th> */}
                                                    <th scope="col">Employee ID</th>
                                                    <th scope="col">reporting_manager_name</th>
                                                    <th scope="col">position</th>
                                                    <th scope="col">Applied Date</th>
                                                    <th scope="col">RM Verification Date </th>
                                                    <th scope="col">RM Verification Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                {AllResignationList != undefined && AllResignationList != undefined && AllResignationList.map((e, index) => {
                                                    return (


                                                        <tr>

                                                            <td key={e.id}> {index + 1}</td>
                                                            <td style={{ color: 'rgb(76,53,117)', cursor: 'pointer' }} onClick={() => {
                                                                setid(e.id)
                                                                set_HR_manager_name(e.HR_manager_name)
                                                                set_Re_manager_name(e.reporting_manager_name)
                                                                hello(e.id)
                                                                setHR_AllResignation_List(false)
                                                                setHR_AllResignation_Particular_Data(true)
                                                            }
                                                            } > {e.name}</td>
                                                            {/* <td key={e.id}> {e.email}</td> */}
                                                            <td key={e.id}> {e.employee_id}</td>
                                                            <td key={e.id}> {e.reporting_manager_name}</td>
                                                            <td key={e.id}> {e.position}</td>
                                                            <td key={e.id}> {e.Applied_On}</td>
                                                            <td key={e.id}> {e.rm_verified_On}</td>
                                                            <td key={e.id} className={`text-center ${e.is_rm_verified ? 'text-success fw-bold ' : 'text-danger fw-bold'} `}> {e.is_rm_verified ? 'Completed' : 'Pending'} </td>



                                                        </tr>


                                                    )
                                                })}




                                            </tbody>
                                        </table>
                                    </div>
                                    <div className={`p-1 mt-3  ${HR_AllResignation_Particular_Data ? '' : 'd-none'}`}>
                                        <button onClick={(e) => {
                                            e.preventDefault()
                                            setHR_AllResignation_Particular_Data(false)
                                            setHR_AllResignation_List(true)
                                        }}>Back</button>


                                        {/* Hr Manager Start */}

                                        <div className={` mt-4 `}>

                                            <div className='p-3 border'>

                                                <div style={{ lineHeight: '40px' }}>

                                                    <li class="list-group-item"><strong>Name  :</strong> {ResignationRequestData.name} </li>
                                                    <li class="list-group-item"><strong>Employee Id :</strong> {ResignationRequestData.employee_id} </li>
                                                    {/* <li class="list-group-item"><strong>Id  :</strong> {e.id} </li> */}
                                                    <li class="list-group-item"><strong>Reason  :</strong> {ResignationRequestData.reason}</li>
                                                    <li class="list-group-item"><strong>position  :</strong> {ResignationRequestData.position} </li>
                                                    <li class="list-group-item"><strong>Reporting Manager Name  :</strong> {ResignationRequestData.reporting_manager_name} </li>
                                                    <li class="list-group-item"><strong>Reporting Manager Remarks  :</strong> {ResignationRequestData.rm_remarks} </li>
                                                    <li class="list-group-item"><strong>Reporting Manager Verified Date  :</strong> {ResignationRequestData.rm_verified_On} </li>
                                                    <li class="list-group-item"><strong>Resigned Letter File  :</strong> <a href={ResignationRequestData.resigned_letter_file}>resigned_letter_file</a></li>

                                                </div>

                                            </div>

                                            <div class="row  mt-5">


                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Name" className="form-label">HR Verified* </label>
                                                    <select className="form-select" id="ageGroup" value={HR_Verified} onChange={(e) => set_HR_Verified(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="True">Yes</option>
                                                        <option value="False">No</option>
                                                    </select>
                                                </div>

                                                {/* <div className="col-md-6 col-lg-4 mb-3">
                                <label htmlFor="Name" className="form-label">Verified Date* </label>
                                <input type="date" className="form-control shadow-none" id="Name" name="Name" value={Verified_Date} onChange={(e) => set_Verified_Date(e.target.value)} />
                            </div> */}
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


                                        </div>
                                        {/* Hr Manager End */}

                                    </div>

                                </div>
                                {/* Tab 1 end */}

                                {/* Tab 2 start */}
                                <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">

                                    <div className={`p-1   ${HR_AllResignation_List1 ? '' : 'd-none'}`}>
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">Name</th>
                                                    {/* <th scope="col">Email</th> */}
                                                    <th scope="col">Employee ID</th>
                                                    {/* <th scope="col">reporting_manager_name</th> */}
                                                    <th scope="col">position</th>
                                                    <th scope="col">Applied_On</th>
                                                    {/* <th scope="col">RM Verification Status</th> */}
                                                    {/* <th scope="col">RM Verification Status</th> */}
                                                    <th scope="col">HR Verification Date</th>
                                                    <th scope="col">HR Verification Status</th>
                                                    <th scope="col">Date Of Interview</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                {AllResignationList != undefined && AllResignationList != undefined && AllResignationList.map((e, index) => {
                                                    return (


                                                        <tr>

                                                            <td key={e.id}> {index + 1}</td>
                                                            <td style={{ color: 'rgb(76,53,117)', cursor: 'pointer' }} onClick={() => {
                                                                if (currentDate === e.Date_Of_Interview) {
                                                                    setid(e.id)
                                                                    set_HR_manager_name(e.HR_manager_name)
                                                                    set_Re_manager_name(e.reporting_manager_name)
                                                                    hello(e.id)
                                                                    setHR_AllResignation_List1(false)
                                                                    setHR_AllResignation_Particular_Data1(true)

                                                                }
                                                                else {
                                                                    alert(` It has to open on ${e.Date_Of_Interview} Date`)
                                                                }

                                                            }
                                                            } > {e.name}</td>
                                                            {/* <td key={e.id}> {e.email}</td> */}
                                                            <td key={e.id}> {e.employee_id}</td>
                                                            {/* <td key={e.id}> {e.reporting_manager_name}</td> */}
                                                            <td key={e.id}> {e.position}</td>
                                                            <td key={e.id}> {e.Applied_On}</td>
                                                            <td key={e.id}> {e.hr_verified_On}</td>
                                                            {/* <td key={e.id} className={`text-center ${e.is_rm_verified ? 'text-success fw-bold ' : 'text-danger fw-bold'} `}> {e.is_rm_verified ? 'Completed' : 'Pending'} </td> */}
                                                            <td key={e.id} className={`text-center ${e.is_hr_verified ? 'text-success fw-bold ' : 'text-danger fw-bold'} `}> {e.is_hr_verified ? 'Completed' : 'Pending'} </td>
                                                            <td key={e.id} className={` fw-bold  ${currentDate === e.Date_Of_Interview ? 'text-success' : 'text-danger'}  `}> {e.Date_Of_Interview}</td>




                                                        </tr>


                                                    )
                                                })}




                                            </tbody>
                                        </table>
                                    </div>
                                    <div className={`p-1 mt-3  ${HR_AllResignation_Particular_Data1 ? '' : 'd-none'}`}>
                                        <button onClick={(e) => {
                                            e.preventDefault()
                                            setHR_AllResignation_Particular_Data1(false)
                                            setHR_AllResignation_List1(true)
                                        }}>Back</button>


                                        {/* Hr Manager Start */}

                                        <div className={` mt-4 `}>



                                            {/* EXIT INTERVIEW FORM  START */}
                                            <div className='p-1' >
                                                <form>
                                                    {/* Form start */}
                                                    <div className="row justify-content-center m-0 ">
                                                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>  EXIT INTERVIEW FORM</h5>
                                                        <div className="col-lg-12 p-4 mt-2 border rounded-lg ">
                                                            <div className="row m-0 pb-2">
                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="Name" className="form-label">Notice Period * </label>
                                                                    <input type="number" className="form-control shadow-none" id="Name" name="Name" value={ResignationRequestData.notice_period} />
                                                                </div>

                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="Name" className="form-label">Notice Period Agrry* </label>
                                                                    <select className="form-select" id="ageGroup" value={Notice_period_agrry} onChange={(e) => setNotice_period_agrry(e.target.value)}>
                                                                        <option value="">Select</option>
                                                                        <option value="True">Yes</option>
                                                                        <option value="False">No</option>

                                                                    </select>
                                                                </div>

                                                                {/* {Notice_period_agrry === "True" && (
                                                <>

                                                    <div className="col-md-6 col-lg-4 mb-3">
                                                        <label htmlFor="email" className="form-label">Compantation*</label>
                                                        <input type="date" className="form-control shadow-none" value={Compantation} onChange={(e) => setCompantation(e.target.value)} id="Email" name="Email" />
                                                    </div>

                                                    <div className="col-md-6 col-lg-4 mb-3">
                                                        <label htmlFor="Name" className="form-label">Compantation PayAgrry* </label>
                                                        <select className="form-select" id="ageGroup" value={Compantation_PayAgrry} onChange={(e) => setCompantation_PayAgrry(e.target.value)}>
                                                            <option value="">Select</option>
                                                            <option value="True">Yes</option>
                                                            <option value="False">No</option>

                                                        </select>
                                                    </div>
                                                </>
                                            )} */}
                                                                {Notice_period_agrry === "False" && (
                                                                    <>

                                                                        <div className="col-md-6 col-lg-4 mb-3">
                                                                            <label htmlFor="email" className="form-label">Compantation*</label>
                                                                            <input type="number" className="form-control shadow-none" value={ResignationRequestData.notice_pay} id="Email" name="Email" />
                                                                        </div>

                                                                        <div className="col-md-6 col-lg-4 mb-3">
                                                                            <label htmlFor="Name" className="form-label">Compantation PayAgrry* </label>
                                                                            <select className="form-select" id="ageGroup" value={Compantation_PayAgrry} onChange={(e) => setCompantation_PayAgrry(e.target.value)}>
                                                                                <option value="">Select</option>
                                                                                <option value="True">Yes</option>
                                                                                <option value="False">No</option>

                                                                            </select>
                                                                        </div>
                                                                    </>
                                                                )}
                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="email" className="form-label">Date to Leave*</label>
                                                                    <input type="date" className="form-control shadow-none" value={Date_toLeave} onChange={(e) => setDate_toLeave(e.target.value)} id="Email" name="Email" />
                                                                </div>

                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="Name" className="form-label">Fit To Be Rehired* </label>
                                                                    <select className="form-select" id="ageGroup" value={Fit_ToBeRehired} onChange={(e) => setFit_ToBeRehired(e.target.value)}>
                                                                        <option value="">Select</option>
                                                                        <option value="True">Yes</option>
                                                                        <option value="False">No</option>

                                                                    </select>
                                                                </div>

                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="email" className="form-label">Alternate Email*</label>
                                                                    <input type="email" className="form-control shadow-none" value={Alternate_Email} onChange={(e) => setAlternate_Email(e.target.value)} id="Email" name="Email" />
                                                                </div>
                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="email" className="form-label">Alternate Mobile*</label>
                                                                    <input type="tel" className="form-control shadow-none" value={Alternate_Mobile} onChange={(e) => setAlternate_Mobile(e.target.value)} id="Email" name="Email" />
                                                                </div>

                                                                <div className="col-md-6 col-lg-4 mb-3">
                                                                    <label htmlFor="Name" className="form-label">Designation Status* </label>
                                                                    <select className="form-select" id="ageGroup" value={DesignationStatus} onChange={(e) => set_DesignationStatus(e.target.value)}>
                                                                        <option value="">Select</option>
                                                                        <option value="approved">Approved</option>
                                                                        <option value="declined">Declined</option>

                                                                    </select>
                                                                </div>

                                                                <div className="col-md-6 col-lg-12 mb-3">
                                                                    <label htmlFor="email" className="form-label" >Final Remarks*</label>
                                                                    <textarea type="tel" className="form-control shadow-none" value={FinalRemarks} onChange={(e) => setFinalRemarks(e.target.value)} id="Email" name="Email" />
                                                                </div>



                                                            </div>
                                                        </div>
                                                    </div>
                                                    {/* form end */}
                                                    {/* Button start */}
                                                    <div class=" d-flex justify-content-end mt-2">

                                                        <div className='d-flex gap-2'>


                                                            <button type="submit" class="btn btn-success btn-sm" onClick={handle_employee_Exit_Interview_form}  >Submit</button>



                                                        </div>
                                                    </div>
                                                    {/* Button end */}
                                                </form>
                                            </div>
                                            {/* EXIT INTERVIEW FORM  END */}
                                        </div>
                                        {/* Hr Manager End */}

                                    </div>

                                </div>
                                {/* Tab 2 end */}

                                {/* Tab 3 start */}
                                <div class="tab-pane fade " id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">

                                    <div className={`p-1   ${HR_AllResignation_List2 ? '' : 'd-none'}`}>
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">Name</th>
                                                    <th scope="col">Employee ID</th>
                                                    <th scope="col">position</th>
                                                    <th scope="col">Applied Date</th>
                                                    <th scope="col">RM Verified Date</th>
                                                    <th scope="col">HR Verified Date</th>
                                                    <th scope="col">Exit Interview Date</th>

                                                </tr>
                                            </thead>
                                            <tbody>

                                                {Completed_Resignation_List != undefined && Completed_Resignation_List != undefined && Completed_Resignation_List.map((e, index) => {
                                                    return (


                                                        <tr>

                                                            <td key={e.id}> {index + 1}</td>
                                                            <td style={{ color: 'rgb(76,53,117)', cursor: 'pointer' }} onClick={() => {
                                                                setid(e.id)
                                                                set_HR_manager_name(e.HR_manager_name)
                                                                set_Re_manager_name(e.reporting_manager_name)
                                                                hello(e.id)
                                                                setHR_AllResignation_List2(false)
                                                                setHR_AllResignation_Particular_Data2(true)
                                                            }
                                                            } > {e.name}</td>
                                                            {/* <td key={e.id}> {e.email}</td> */}
                                                            <td key={e.id}> {e.employee_id}</td>
                                                            <td key={e.id}> {e.position}</td>
                                                            <td key={e.id}> {e.Applied_On}</td>
                                                            <td key={e.id}> {e.rm_verified_On}</td>
                                                            <td key={e.id}> {e.hr_verified_On}</td>
                                                            <td key={e.id}> {e.Date_Of_Interview}</td>





                                                        </tr>


                                                    )
                                                })}




                                            </tbody>
                                        </table>
                                    </div>
                                    <div className={`p-1 mt-3  ${HR_AllResignation_Particular_Data2 ? '' : 'd-none'}`}>
                                        <button onClick={(e) => {
                                            e.preventDefault()
                                            setHR_AllResignation_Particular_Data2(false)
                                            setHR_AllResignation_List2(true)
                                        }}>Back</button>


                                        {/* Hr Manager Start */}

                                        <div className={` mt-4 `}>

                                            <h5>Employee Resignation Details</h5>

                                            <div className='p-3 border mt-2'>

                                                <div style={{ lineHeight: '40px' }}>

                                                    <li class="list-group-item"><strong>Name  :</strong> {ResignationRequestData.name} </li>
                                                    <li class="list-group-item"><strong>Employee Id :</strong> {ResignationRequestData.employee_id} </li>
                                                    {/* <li class="list-group-item"><strong>Id  :</strong> {e.id} </li> */}
                                                    <li class="list-group-item"><strong>position  :</strong> {ResignationRequestData.position} </li>
                                                    <li class="list-group-item"><strong>Reporting Manager Name:</strong>{ResignationRequestData.reporting_manager_name}</li>
                                                    <li class="list-group-item"><strong>HR Manager Name:</strong>{ResignationRequestData.HR_manager_name}</li>
                                                    <li class="list-group-item"><strong>Reason  :</strong> {ResignationRequestData.reason}</li>
                                                    <li class="list-group-item"><strong>Resigned Letter File  :</strong> <a href={ResignationRequestData.resigned_letter_file}>resigned_letter_file</a></li>

                                                </div>

                                            </div>


                                        </div>
                                        {/* Hr Manager End */}

                                    </div>



                                </div>

                                {/* Tab 3 end */}

                                {/* Tab 4 start */}
                                <div class="tab-pane fade " id="pills-completed" role="tabpanel" aria-labelledby="pills-completed-tab" tabindex="0" >


                                    <h1>hello 4</h1>



                                </div>
                                {/* Tab 4 end */}

                            </div>

                            {/* Nav Tabs end  */}

                        </div>
                    </div>
                </div>










            </div >



        </div >
    )
}

export default Employee_separation_request