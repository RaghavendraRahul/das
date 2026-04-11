import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import { useNavigate } from 'react-router-dom'
import '../assets/css/Checkbox.css'


const Hr_reporting_team = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let UserName = JSON.parse(sessionStorage.getItem('user')).UserName
    let Disgnation = JSON.parse(sessionStorage.getItem('user')).Disgnation


    const [EMPLOYEE_DATA_LIST, setEMPLOYEE_DATA_LIST] = useState(true)
    const [PERSONAL_EMP_DATA, setPERSONAL_EMP_DATA] = useState(false)

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

    const [selectedCandidates, setSelectedCandidates] = useState([]);


    // ADD MORE START

    const [Activity_data, setQualifications] = useState([

        { Activity_Name: '', targets: '' }
    ]);

    const handleAddRow = (e) => {
        e.preventDefault();

        setQualifications([...Activity_data, { Activity_Name: '', targets: '' }]);
    };

    const handleInputChange = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Activity_data];
        updatedQualifications[index][name] = value;
        setQualifications(updatedQualifications);
    };
    // ADD MORE END

    // ADD MORE START

    const [Interview_Scheduled_Data, setInterview_Scheduled_Data] = useState([

        { position: '', targets: '', No_Of_Open_Possitions: '', No_Of_Closed_Possitions: '' }
    ]);

    const handleAddRow1 = (e) => {
        e.preventDefault();

        setInterview_Scheduled_Data([...Interview_Scheduled_Data, { position: '', targets: '', No_Of_Open_Possitions: '', No_Of_Closed_Possitions: '' }]);
    };

    const handleInputChange1 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Interview_Scheduled_Data];
        updatedQualifications[index][name] = value;
        setInterview_Scheduled_Data(updatedQualifications);
    };
    // ADD MORE END

    const [Activity_Name, setActivity_Name] = useState([]);
    const [Target, setTarget] = useState([]);



    console.log("selectedCandidates", selectedCandidates);

    useEffect(() => {

        fetchdata()

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


        axios.get(`${port}/root/ems/EmployeeProfile/${id}/`)
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

    const [activitiesget, setgetActivities] = useState([]);
    const [activitiesgetdaily_achives, setgetActivities_daily_achives] = useState([]);
    const [Employee_ID, setEmployee_ID] = useState("");


    const sentparticularData1 = (id) => {

        console.log(id);
        setEmployee_ID(id)

        axios.get(`${port}/root/EmployeeActivity/${id}/`)
            .then(res => {
                console.log('EmployeeActivity_res', res.data);
                setgetActivities(res.data);
                setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));
                console.log(res.data.map((x) => x.daily_achives));
                console.log("activity_get_res", res.data);

            })
            .catch(error => {

                console.error('EmployeeActivity_err', error.data);
            });
    };

    const sentparticularData3 = (id) => {

        console.log(id);

        axios.get(`${port}/root/ems/EmployeeProfile/${id}/`)
            .then(response => {

                console.log('Paticular_Employee_Data_Res', response.data);
                setEMPLOYEE_INFORMATION(response.data.EmployeeInformation)
                // setREFERENCE(response.data.CandidateReferenceDetails)
                // setEDUCATION_DETAILS(response.data.EducationDetails);
                // setCONTACT_EMERGENCY(response.data.EmergencyContactDetails);
                // setFAMILY_DETAILS(response.data.FamilyDetails);
                // setEMERGENCY_DETAILS(response.data.EmergencyDetails);
                // setLAST_POSITION_HELD(response.data.LastPositionHeldDetails);
                // setEXPERIENCE_LAST_POSITION(response.data.ExperienceDetails);

            })
            .catch(error => {

                console.error('Paticular_Employee_Data_Err', error.data);
            });
    };
    // SELECTED EMPLOYEE


    const handleCheckboxChange = (e) => {
        const candidateId = e.target.value;
        if (e.target.checked) {
            setSelectedCandidates([...selectedCandidates, candidateId]);
        } else {
            setSelectedCandidates(selectedCandidates.filter(id => id !== candidateId));
        }
    };

    const sendSelectedDataToApi = (e) => {
        e.preventDefault()

        console.log("EmployeeId", selectedCandidates);
        console.log("Activity_data", Activity_data);
        console.log("login_user", Empid);

        axios.post(`${port}/root/add_activity/`, { Activity_data, EmployeeId: selectedCandidates, login_user: Empid })
            .then(response => {
                console.log('add_activit_res', response.data);
                window.location.reload()

            })
            .catch(error => {
                console.error('add_activity_res', error);

            });
    };
    const sendSelectedDataToApi1 = (e) => {
        e.preventDefault()

        console.log("EmployeeId", selectedCandidates);
        console.log("Interview_Scheduled_Data", Interview_Scheduled_Data);
        console.log("login_user", Empid);

        axios.post(`${port}/root/Interview_Schedule_activity`, { Interview_Scheduled_Data, EmployeeId: selectedCandidates, login_user: Empid })
            .then(response => {
                console.log('Interview_Schedule_activity_res', response.data);
                window.location.reload()

            })
            .catch(error => {
                console.error('Interview_Schedule_activity_err', error);

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

        alert("hello")

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


    // ACTIVITY SHEET DATA START 


    const generateDates = (month, year) => {
        const dates = [];
        const date = new Date(year, month, 1);

        while (date.getMonth() === month) {
            const day = String(date.getDate()).padStart(2, '0');
            const monthFormatted = String(date.getMonth() + 1).padStart(2, '0');
            const yearFormatted = date.getFullYear();

            // const formattedDate = `${day}-${monthFormatted}-${yearFormatted}`;
            const formattedDate = `${yearFormatted}-${monthFormatted}-${day}`;
            dates.push(formattedDate);

            date.setDate(date.getDate() + 1);
        }
        return dates;
    };

    const formatDate = (date) => {
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${year}-${month}-${day}`;
    };





    const [Interview_Scheduledget, setInterview_Scheduledget] = useState([]);
    const [Interview_Scheduled_achives, setInterview_Scheduled_achives] = useState([]);

    const [Walkinsget, setWalkinsget] = useState([]);
    const [Walkins_achives, setWalkins_achives] = useState([]);

    const [Offeredget, setOfferedget] = useState([]);
    const [Offered_achives, setOffered_achives] = useState([]);

    // const [Interview_Scheduled, setInterview_Scheduled] = useState([]);
    // const [Walkins, setWalkins] = useState([]);
    // const [Offered, setOffered] = useState([]);


    const [id, setid] = useState("");
    console.log("Daily1", activitiesgetdaily_achives);
    console.log("Daily2", Interview_Scheduled_achives);
    console.log("Daily3", Walkins_achives);
    console.log("Daily4", Offered_achives);

    const [month, setMonth] = useState(5); // 
    const [year, setYear] = useState(2024);
    const dates = generateDates(month, year);

    console.log("Ui_Date", dates);



    const currentDate = new Date();
    const formattedCurrentDate = formatDate(currentDate);


    // Activity Res Start

    // const Activity_get_res = () => {
    //     axios.get(`${port}root/activity/${Empid}/`).then((res) => {
    //         setgetActivities(res.data);
    //         setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));
    //         console.log(res.data.map((x) => x.daily_achives));
    //         console.log("activity_get_res", res.data);
    //     }).catch((err) => {
    //         console.log("activity_get_err", err.data);
    //     });
    // };

    // useEffect(() => {
    //     Activity_get_res();
    // }, []);

    // Activity res End

    // const calculateTotal = (field) => {
    //     return activitiesget.reduce((total, activity) => {
    //         return total + (parseFloat(activity[field]) || 0);
    //     }, 0);
    // };

    // const totalTarget = calculateTotal('targets');
    // const totalAchieved = calculateTotal('achieved');

    let handle_Month_Change = (e) => {

        console.log("Year_select", e);
        console.log("Employee_Id", Employee_ID);
        // console.log("Year_select", e.slice(0, 4));
        // console.log("Year_select", e.slice(5, 7));

        axios.get(`${port}root/ActivityList/Display/${e}/${Employee_ID}/`).then((res) => {
            console.log("activity_date_res", res.data);
            setgetActivities(res.data);
            setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));

        }).catch((err) => {

            console.log("activity_date_err", err);

        })

    }

    let Function_setgetActivities = () => {

    }

    const handle_Activity_Name_Change = (value, id) => {

        console.log("enter", value, id);
        axios.patch(`${port}root/activity/updel/${id}/`, { Activity_Name: value }, {
            achieved: value
        }).then((res) => {
            setgetActivities(res.data)
            Function_setgetActivities()

            console.log("Activity_Name_Change_Res", res.data);
        }).catch((err) => {

            console.log("Activity_Name_Change_Err", err);

        })
    };

    const handle_Targets_Name_Change = (value, id) => {

        console.log("enter", value);
        axios.patch(`${port}root/activity/updel/${id}/`, { targets: value }).then((res) => {
            // setgetActivities(res.data)
            console.log("Targets_Name_Change_Res", res.data);
        }).catch((err) => {

            console.log("Targets_Name_Change_Err", err);

        })
    };

    let Update_Changes = () => {

        window.location.reload()

    }

    const [isChecked, setIsChecked] = useState(true);

    const handleCheckboxChange1 = () => {
        setIsChecked(!isChecked);
    };

    // ACTIVITY SHEET DATA END


    return (
        <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
                <div style={{ marginLeft: '10px' }}>

                    <Topnav></Topnav>
                </div>

                {/* Reporting Team List Start */}
                <div className={`p-3 ${EMPLOYEE_DATA_LIST ? '' : 'd-none'}`}>


                    <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                        <h6 className='mt-2 heading ms-3' style={{ color: 'rgb(76,53,117)' }}>Reporting Team List</h6>

                        <input type="text" value={searchValue}
                            onChange={(e) => handlesearchvalue(e.target.value)} className='form-control w-25' />
                    </div>

                    <div className='d-flex justify-content-between mt-2'>

                        {/* Add Activity */}
                        <div class="modal fade" id="exampleModal23" tabindex="-1" aria-labelledby="exampleModalLabel23" aria-hidden="true">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel23">Assign Activity </h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">

                                        {Activity_data.map((qualification, index) => (
                                            <div key={index}>

                                                <div className="row">

                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>{index + 1} . Activity Name*</label>
                                                        <input type="text" name="Activity_Name" value={qualification.Activity_Name} onChange={(e) => handleInputChange(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Targets*</label>
                                                        <input type="number" name="targets" value={qualification.targets} onChange={(e) => handleInputChange(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                </div>



                                            </div>
                                        ))}

                                        {/* <button onClick={handleAddRow} className='btn btn-sm btn-success'>add</button> */}



                                    </div>
                                    <div class="modal-footer">
                                        <div className='d-flex justify-content-end '>


                                            <button onClick={handleAddRow} className='btn me-3  btn-success'>Add More</button>

                                            <button onClick={sendSelectedDataToApi} type="button" data-bs-dismiss="modal" class="btn btn-primary">Assign</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/* View */}
                        <div class="modal fade" id="exampleModal26" tabindex="-1" aria-labelledby="exampleModalLabel26" aria-hidden="true">
                            <div class="modal-dialog modal-fullscreen">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel26">View </h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div className=' p-1 mt-3 table-responsive' style={{ marginLeft: '10px' }}>
                                            <table class="table" >
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
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                    {AllEmployeelist != undefined && AllEmployeelist != undefined && AllEmployeelist.map((e, index) => {
                                                        return (


                                                            <tr>

                                                                <td key={e.id}> {index + 1}</td>

                                                                <td onClick={() => sentparticularData1(e.employee_Id)} data-bs-toggle="modal" data-bs-target="#exampleModal6" key={e.id} style={{ cursor: 'pointer' }}> {e.full_name}</td>
                                                                <td key={e.id}> {e.email}</td>
                                                                <td key={e.id}> {e.employee_Id}</td>
                                                                <td key={e.id}> {e.mobile}</td>
                                                                <td key={e.id}> {e.Date_of_Joining}</td>
                                                                <td key={e.id}> {e.Designation}</td>
                                                                <td key={e.id}> {e.Department}</td>



                                                            </tr>


                                                        )
                                                    })}



                                                </tbody>
                                            </table>



                                        </div>




                                    </div>
                                    <div class="modal-footer">
                                        <div className='d-flex justify-content-end '>

                                            {/* <button  type="button" data-bs-dismiss="modal" class="btn btn-primary">Assign</button> */}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/* Interview Scheduled */}
                        <div class="modal fade" id="exampleModal25" tabindex="-1" aria-labelledby="exampleModalLabel25" aria-hidden="true">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel25">Scheduled Interview </h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">

                                        {Interview_Scheduled_Data.map((qualification, index) => (
                                            <div key={index}>

                                                <div className="row">

                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>{index + 1} . Postion Name*</label>
                                                        <input type="text" name="position" value={qualification.position} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Targets*</label>
                                                        <input type="number" name="targets" value={qualification.targets} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>No of Open Possitions*</label>
                                                        <input type="number" name="No_Of_Open_Possitions" value={qualification.No_Of_Open_Possitions} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>No of Closed Possitions*</label>
                                                        <input type="number" name="No_Of_Closed_Possitions" value={qualification.No_Of_Closed_Possitions} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                </div>



                                            </div>
                                        ))}

                                        {/* <button onClick={handleAddRow} className='btn btn-sm btn-success'>add</button> */}



                                    </div>
                                    <div class="modal-footer">
                                        <div className='d-flex justify-content-end '>


                                            <button onClick={handleAddRow1} className='btn me-3  btn-success'>Add More</button>

                                            <button onClick={sendSelectedDataToApi1} type="button" data-bs-dismiss="modal" class="btn btn-primary">Assign</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                    </div>

                    <div className=' p-1 mt-3 table-responsive' style={{ marginLeft: '10px' }}>

                        <div className='row  m-0 p-1 mt-1'>

                            {AllEmployeelist != undefined && AllEmployeelist != undefined && AllEmployeelist.map((e, index) => {
                                console.log("AllEmployeelist", e.id);
                                return (

                                    <div className="col-md-12 col-lg-3 mb-3  p-2">

                                        <div style={{ backgroundColor: 'white', border: '.5px solid black', width: '230px', height: '200px' }} className='p-2 ' >

                                            <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
                                                <div style={{ position: 'relative' }}>
                                                    <div style={{ position: "absolute", left: '80px' }} class="btn-group" >
                                                        <label class="container">
                                                            <input type="checkbox" />

                                                        </label>

                                                    </div>
                                                </div>




                                                <div>
                                                    <img className='rounded-circle mt-3' src="https://smarthr.dreamstechnologies.com/html/template/assets/img/profiles/avatar-02.jpg" style={{ width: '90px' }} alt="" />
                                                </div>

                                                <div className='text-center mt-3'>
                                                    <h6 className='text-center' style={{ cursor: 'pointer' }} onClick={() => {
                                                        sentparticularData(e.id)
                                                        setEMPLOYEE_DATA_LIST(false)
                                                        setPERSONAL_EMP_DATA(true)
                                                    }
                                                    }>{e.full_name}</h6>
                                                    <small>{e.Designation}</small>
                                                </div>


                                            </div>

                                        </div>

                                    </div>



                                )
                            })}
                        </div>
                    </div>

                </div>
                {/* Reporting Team List End */}

                {/* All_request_data start */}

                <div className={`m-4 ${PERSONAL_EMP_DATA ? '' : 'd-none'}`}>
                    <button onClick={(e) => {
                        e.preventDefault()
                        setEMPLOYEE_DATA_LIST(true)
                        setPERSONAL_EMP_DATA(false)

                    }}>Back</button>
                    <div className='mt-3' style={{ width: '100%' }}>


                        <div className='border mt-4'>

                            <section className='  h-100 ' style={{ backgroundColor: 'rgb(249,251,253,.2)' }}>

                                <div class="row m-0 p-1 ">
                                    <div className=" col-md-4 col-lg-4  p-2">

                                        <div class="row m-0  ">

                                            <div className="col-sm-12  rounded p-2 border-warning" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='w-100 '>
                                                    <div className='d-flex mx-auto mt-2 w-100'>
                                                        <img class="mx-auto rounded-circle" src='https://smarthr.dreamstechnologies.com/html/template/assets/img/profiles/avatar-02.jpg' width={100} height={100} alt="" />
                                                    </div>



                                                    <div className='text-center mt-4'>
                                                        <h6>{EMPLOYEE_INFORMATION.full_name}</h6>
                                                        <p>UI Developer</p>
                                                    </div>
                                                    <div className='mt-3 d-flex justify-content-center '>

                                                        <ul className='d-flex justify-content-around w-75 mt-2 me-3'>
                                                            <li className='nav-link border border-success rounded-circle' style={{ padding: '4px 8px' }}><i class="fa-solid fa-user-tie"></i></li>
                                                            <li className='nav-link border border-success rounded-circle' style={{ padding: '4px 8px' }}><i class="fa-brands fa-github"></i></li>
                                                            <li className='nav-link border border-success rounded-circle' style={{ padding: '4px 8px' }}><i class="fa-brands fa-linkedin"></i></li>
                                                            <li className='nav-link border border-success rounded-circle' style={{ padding: '4px 8px' }}><i class="fa-brands fa-square-instagram"></i></li>
                                                            <li className='nav-link border border-success rounded-circle' style={{ padding: '4px 8px' }}><i class="fa-brands fa-facebook"></i></li>
                                                        </ul>

                                                    </div>

                                                </div>



                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-8 col-lg-8  p-2">
                                        <div class="row m-0 ms-2">

                                            <div className="col-sm-12 border border-success  rounded" style={{ backgroundColor: 'rgb(255,221,64,.4)' }} >

                                                <div className='w-100  p-3 ' >
                                                    <h4 className='text-success '>ABOUT</h4>
                                                    <div className='d-flex' style={{ lineHeight: '50px' }}>


                                                        <div>
                                                            <div className='fw-bold'>
                                                                Employee ID
                                                            </div>
                                                            <div className='fw-bold'>
                                                                Name
                                                            </div>
                                                            <div className='fw-bold'>
                                                                Email
                                                            </div>
                                                            <div className='fw-bold'>
                                                                Phone Number
                                                            </div>
                                                        </div>
                                                        <div className='ms-4 ps-5'>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.employee_Id}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.full_name}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.email}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.mobile}
                                                            </div>
                                                        </div>
                                                        <div className='ms-4 ps-5'>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.employee_Id}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.full_name}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.email}
                                                            </div>
                                                            <div>
                                                                {EMPLOYEE_INFORMATION.mobile}
                                                            </div>
                                                        </div>

                                                    </div>





                                                </div>


                                            </div>

                                        </div>
                                    </div>

                                </div>
                                <div class="row m-0 p-1 mt-1">
                                    <div className=" col-md-6 col-lg-12  p-2">

                                        <div class="row m-0  ">

                                            <h5 className='me-2'>Personal Informations</h5>
                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-6 col-lg-12  p-2">

                                        <div class="row m-0  ">

                                            <h5>Emergency Contact</h5>
                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-6 col-lg-12  p-2">

                                        <div class="row m-0  ">

                                            <h5>Bank information</h5>
                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-6 col-lg-12  p-2">

                                        <div class="row m-0  ">
                                            <h5>Family Informations</h5>

                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-6 col-lg-12 p-2">

                                        <div class="row m-0  ">

                                            <h5>Education Informations</h5>
                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div className=" col-md-6 col-lg-12  p-2">

                                        <div class="row m-0  ">

                                            <h5>Experience</h5>
                                            <div className="col-sm-12  rounded p-3 mt-2" style={{ backgroundColor: 'rgb(160,217,180)' }}>

                                                <div className='p-3 '>

                                                    <div className='mt-1'>
                                                        <h6> work</h6>

                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6> Attendance</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>Punctuality</h6>
                                                    </div>
                                                    <div className='mt-4'>

                                                        <h6>  Technical Skills</h6>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>


                                </div>




                            </section>
                        </div>



                    </div>
                </div>
                {/* All_request_data End */}



            </div>

            {/* open Particular Data End */}





        </div>




    )
}

export default Hr_reporting_team