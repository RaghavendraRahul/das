import React, { useContext, useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import { useNavigate } from 'react-router-dom'
import { HrmStore } from '../Context/HrmContext'
import InfoButton from './SettingComponent/InfoButton'
import { toast } from 'react-toastify'
import NewSideBar from './MiniComponent/NewSideBar'


const Reporting_team = ({ subpage }) => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let UserName = JSON.parse(sessionStorage.getItem('user')).UserName
    let Disgnation = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let [interviewList, setInterviewList] = useState()
    let [interviewListDA, setInterviewListDA] = useState()
    let [offerList, setOfferList] = useState()
    let [offerListDA, setOfferListDA] = useState()
    let [walkinList, setWalkInList] = useState()
    let [walkinListDA, setWalkInListDA] = useState()
    let [filteredList, setFilteredList] = useState()


    let [selectedName, setSelectedName] = useState()
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

    const [Activity_data, setActivityData] = useState([

        { Activity_Name: '', targets: '', day_or_month_wise: false }
    ]);

    const handleAddRow = (e) => {
        e.preventDefault();

        setActivityData([...Activity_data, { Activity_Name: '', targets: '', day_or_month_wise: false }]);
    };

    const handleInputChange = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Activity_data];
        updatedQualifications[index][name] = value;
        setActivityData(updatedQualifications);
    };
    // ADD MORE END

    // ADD MORE START

    const [Interview_Scheduled_Data, setInterview_Scheduled_Data] = useState([

        { position: '', targets: '', Walkins_target: '', Offers_target: '', No_Of_Open_Possitions: '', No_Of_Closed_Possitions: '' }
    ]);

    const handleAddRow1 = (e) => {
        e.preventDefault();
        setInterview_Scheduled_Data([...Interview_Scheduled_Data,
        { position: '', targets: '', Walkins_target: '', Offers_target: '', No_Of_Open_Possitions: '', No_Of_Closed_Possitions: '' }]);
    };

    const handleInputChange1 = (index, event) => {
        let { name, value } = event.target;
        if (name != 'position' && value < 0) {
            value = ''
        }
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
            setFilteredList(res.data)
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
    const handleActivitiesGet = (e, id) => {
        let { name, value } = e.target
        let newobj = activitiesget.find((obj) => obj.id == id)
        newobj[name] = value
        let newarry = activitiesget.map((prev) => {
            if (prev.id == id)
                return newobj
            else
                return prev
        })
        console.log(newarry);
        setgetActivities(newarry)
    }
    const [activitiesgetdaily_achives, setgetActivities_daily_achives] = useState([]);
    const [Employee_ID, setEmployee_ID] = useState("");


    const sentparticularData1 = (id) => {
        console.log(id);
        setEmployee_ID(id)
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
                toast.success('Activity added')
                setActivityData([{ Activity_Name: '', targets: '', day_or_month_wise: false }]);
                // window.location.reload()

            })
            .catch(error => {
                console.error('add_activity_res', error);
                toast.error('Error occured')

            });
    };
    const sendSelectedDataToApi1 = (e) => {
        e.preventDefault()

        console.log("EmployeeId", selectedCandidates);
        console.log("Interview_Scheduled_Data", Interview_Scheduled_Data);
        console.log("login_user", Empid);

        axios.post(`${port}/root/Interview_Schedule_activity`,
            { Interview_Scheduled_Data, EmployeeId: selectedCandidates, login_user: Empid })
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
            let filterValue = AllEmployeelist.filter((obj) =>
                obj.full_name.toLowerCase().indexOf(value.toLowerCase()) !== -1
            );
            console.log(filterValue, 'filter', filteredList);

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




    const [id, setid] = useState("");
    console.log("Daily1", activitiesgetdaily_achives);
    console.log("Daily2", Interview_Scheduled_achives);
    console.log("Daily3", Walkins_achives);
    console.log("Daily4", Offered_achives);


    const currentDate = new Date();
    const [month, setMonth] = useState(currentDate.getMonth());
    const [year, setYear] = useState(currentDate.getFullYear());
    const [dates, setDates] = useState(generateDates(currentDate.getMonth(), currentDate.getFullYear()));

    console.log("Ui_Date", dates);


    const formattedCurrentDate = formatDate(currentDate);

    let getActivities = (e) => {
        axios.get(`${port}root/ActivityList/Display/${e}/${Employee_ID}/`).then((res) => {
            console.log("activity_date_res", res.data);
            setgetActivities(res.data);
            setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));
        }).catch((err) => {
            console.log("activity_date_err", err);
        })
    }
    let getInterviewList = (e) => {
        axios.get(`${port}root/InterviewList/Display/${e}/${Employee_ID}/`).then((res) => {
            console.log("interview", res.data);
            setInterviewList(res.data.interview);
            setOfferList(res.data.offers)
            setWalkInList(res.data.walkins)

            setInterviewListDA(res.data.interview.map((x) => x.daily_achives))
            setOfferListDA(res.data.offers.map((x) => x.daily_achives))
            setWalkInListDA(res.data.walkins.map((x) => x.daily_achives))

            // setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));
        }).catch((err) => {
            console.log("activity_date_err", err);
        })
    }
    let handle_Month_Change = (e) => {

        console.log("Year_select", e, `${year}-${month}`);
        console.log("Employee_Id", Employee_ID);
        // console.log("Year_select", e.slice(0, 4));
        // console.log("Year_select", e.slice(5, 7));
        const selectedYear = parseInt(e.slice(0, 4));
        const selectedMonth = parseInt(e.slice(5, 7)) - 1;
        setYear(selectedYear);
        setMonth(selectedMonth);
        const newDates = generateDates(selectedMonth, selectedYear);
        setDates(newDates);
    }
    const handle_Activity_Name_Change = (e, id) => {
        let { name, value } = e.target
        console.log("enter", value, id);
        axios.patch(`${port}root/activity/updel/${id}/`, { [name]: value }).then((res) => {
            // setgetActivities(res.data)
            console.log("Activity_Name_Change_Res", res.data);
        }).catch((err) => {
            console.log("Activity_Name_Change_Err", err);
        })
    };

    const handle_InterviewList = (e, id, type) => {
        let { value, name } = e.target
        if (type == 'interview') {
            let newobj = interviewList.find((obj) => obj.id == id)
            newobj[name] = value
            let newarry = interviewList.map((prev) => {
                if (prev.id == id)
                    return newobj
                else
                    return prev
            })
            console.log(newarry);
            setInterviewList(newarry)
        }
        else if (type == 'walkin') {
            let newobj = walkinList.find((obj) => obj.id == id)
            newobj[name] = value
            let newarry = walkinList.map((prev) => {
                if (prev.id == id)
                    return newobj
                else
                    return prev
            })
            console.log(newarry);
            setWalkInList(newarry)
        }
        else if (type == 'offer') {
            let newobj = offerList.find((obj) => obj.id == id)
            newobj[name] = value
            let newarry = offerList.map((prev) => {
                if (prev.id == id)
                    return newobj
                else
                    return prev
            })
            console.log(newarry);
            setOfferList(newarry)
        }
        axios.patch(`${port}/root/Interview_Schedule_activity/updel/${id}/`,
            {
                [name]: value
            }).then((response) => {
                console.log(response.data);
            }).catch((error) => {
                console.log(error);
            })
    }

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


    }

    // ACTIVITY SHEET DATA END

    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('Reporting_team')
    }, [])

    useEffect(() => {
        if (Employee_ID) {
            getActivities(`${year}-${month + 1}`)
            getInterviewList(`${year}-${month + 1}`)
        }
    }, [dates, Employee_ID])
    return (
        <div className='flex flex-col lg:flex-row ' style={{ width: '100%', minHeight: '100%', }}>

            {!subpage && <div className='sticky z-10 top-0'>

                <NewSideBar />
            </div>}
            <div className=' m-0 p-sm-2 flex-1 mx-auto container-fluid overflow-hidden ' style={{ borderRadius: '10px' }}>
                {!subpage && < div style={{ marginLeft: '10px' }}>
                    <Topnav></Topnav>
                </div>}
                {/* Reporting Team List Start */}
                <div className={`p-3 ${Reporting_Team_List ? '' : 'd-none'}`}>


                    <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                        <h6 className='mt-2 heading ms-0 ms-sm-3' style={{ color: 'rgb(76,53,117)' }}>Reporting Team List</h6>

                        {/* <div>
                            <button className='btn btn-sm bg-info-subtle'>Add New</button>
                        </div> */}
                    </div>

                    <div className='Reporting_Team_List_Btns  mt-2'>
                        <div className='ms-0 ms-sm-3 Reporting_Team_Btns'>

                            {/* <button className='btn btn-sm btn-success ms-2'
                                data-bs-toggle="modal" data-bs-target="#exampleModal26">View</button> */}
                            <button disabled={selectedCandidates.length == 0}
                                className='btn btn-sm btn-warning ms-3' data-bs-toggle="modal"
                                data-bs-target="#exampleModal23">Add Activity</button>
                            <button
                                disabled={selectedCandidates.length == 0}
                                className='btn btn-sm btn-warning ms-4' data-bs-toggle="modal"
                                data-bs-target="#exampleModal25">Add Interview</button>
                        </div>
                        {/* Add Activity */}
                        <div class="modal fade" id="exampleModal23" tabindex="-1"
                            aria-labelledby="exampleModalLabel23" aria-hidden="true">
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
                                                        <div htmlFor="primaryContact"
                                                            className="form-label flex justify-between " style={{ color: 'rgb(76,53,117)' }}>
                                                            Targets *
                                                            <div className='text-sm flex items-center gap-2 ' >
                                                                Day wise
                                                                <button onClick={() => {
                                                                    const updatedQualifications = [...Activity_data];
                                                                    updatedQualifications[index].day_or_month_wise = !updatedQualifications[index].day_or_month_wise;
                                                                    setActivityData(updatedQualifications);
                                                                }} className={` w-8 h-4 rounded-full bg-slate-100 p-1  `} >
                                                                    <div className={` w-3 ${qualification.day_or_month_wise ? 'translate-x-3' : "translate-x-0"} duration-300
                                                                     -translate-y-[2px] bg-slate-500 rounded-full h-3 `} >

                                                                    </div>

                                                                </button>
                                                                Month wise
                                                            </div>

                                                        </div>
                                                        <input type="number" name="targets" value={qualification.targets}
                                                            onChange={(e) => handleInputChange(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                </div>
                                            </div>
                                        ))}

                                        {/* <button onClick={handleAddRow} className='btn btn-sm btn-success'>add</button> */}



                                    </div>
                                    <div class="modal-footer">
                                        <div className='d-flex justify-content-end '>


                                            <button onClick={handleAddRow} className='btn me-3  btn-success'>Add More</button>

                                            <button onClick={sendSelectedDataToApi} type="button" data-bs-dismiss="modal"
                                                class="btn btn-primary">Assign</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/* View */}

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
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>{index + 1} Postion Name</label>
                                                        <input type="text" name="position" value={qualification.position} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Number of Openings</label>
                                                        <input type="number" name="Offers_target" value={qualification.Offers_target} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Interview Scheduling Targets</label>
                                                        <input type="number" name="targets" value={qualification.targets} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
                                                    </div>
                                                    <div className="col-md-6 col-lg-6 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}> Walkins Targets </label>
                                                        <input type="number" name="Walkins_target" value={qualification.Walkins_target} onChange={(e) => handleInputChange1(index, e)} className="form-control  shadow-none" />
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
                        <div className='Reporting_Team_search ms-2 ms-sm-0' >

                            {/* <input type="text" value={searchValue}
                                onChange={(e) => handlesearchvalue(e.target.value)}
                                className='form-control' /> */}
                        </div>

                    </div>

                    <div className=' p-1 py-0 mt-3 h-[50vh] overflow-y-scroll tablebg table-responsive'>
                        <table class="w-full  " >
                            <thead >
                                <tr className='sticky top-0 bgclr1 ' >
                                    <th scope="col">#</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Employee ID</th>
                                    <th>Reporting To </th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Join Date</th>
                                    <th scope="col">Role</th>
                                    <th scope="col">Department</th>
                                    <th scope="col">Request</th>
                                </tr>
                            </thead>

                            {filteredList != undefined &&
                                filteredList.map((e, index) => {
                                    return (
                                        <tr key={index} >
                                            <td scope="row"><input type="checkbox"
                                                value={e.employee_Id} onChange={handleCheckboxChange} /></td>
                                            {/* <td key={e.id}> {index + 1}</td> */}
                                            <td onClick={() => {
                                                sentparticularData(e.id);
                                                sentparticularData1(e.employee_Id);
                                                setSelectedName(e.full_name)
                                            }} data-bs-toggle="modal" data-bs-target="#exampleModal6" key={e.id}
                                                style={{ cursor: 'pointer' }}> {e.full_name}</td>
                                            <td key={e.id}> {e.email}</td>
                                            <td key={e.id}> {e.employee_Id}</td>
                                            <td>{e.Reporting_To} </td>
                                            <td key={e.id}> {e.mobile}</td>
                                            <td key={e.id}> {e.hired_date}</td>
                                            <td key={e.id}> {e.Designation}</td>
                                            <td key={e.id}> {e.Department}</td>
                                            <td>
                                                {/* <span className={`text-center ${e.Requests != undefined && e.Requests.LeaveRequests.length >= 0 ? 'd-none' : 'bg-warning'}`} style={{ position: 'relative', left: '33px', bottom: '10px', fontSize: '11px', color: 'red' }} > </span> */}
                                                <button className='btn '
                                                    onClick={() => {
                                                        if (e.Requests.ResignationRequest.length > 0) {
                                                            setResignationRequest(e.Requests.ResignationRequest)
                                                            setLeaveRequests(e.Requests.LeaveRequests)
                                                            set_reform_id(e.Requests.ResignationRequest[0].id)
                                                            set_HR_manager_name(e.Requests.ResignationRequest[0].reporting_manager_name)
                                                            set_Re_manager_name(e.Requests.ResignationRequest[0].HR_manager_name)
                                                            setAll_request_data(true)
                                                            setReporting_Team_List(false)

                                                        }
                                                        else {
                                                            alert('No Requests ')
                                                        }

                                                    }}
                                                > <i class={`fa-solid fa-person-circle-question ${e.Requests.ResignationRequest.length > 0 ? ' text-success' : 'text-danger'}`}></i></button>
                                            </td>
                                        </tr>
                                    )
                                })}
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

                {/* open Particular Data Start */}

                <div class="modal fade" id="exampleModal6" tabindex="-1" aria-labelledby="exampleModalLabel6" aria-hidden="true">
                    <div class="modal-dialog modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title " id="exampleModalLabel6"> Activity Sheet : {selectedName} </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"> </button>
                            </div>
                            <div class="modal-body">

                                <main className="border p-4">




                                    <div className='mt-3 d-flex justify-content-end'>
                                        <input type="month" className='bgclr outline-none p-2 rounded '
                                            value={`${year}-${String(month + 1).padStart(2, '0')}`}
                                            onChange={(e) => handle_Month_Change(e.target.value)} />
                                    </div>

                                    <div>
                                        <div className='mt-4 tablebg  p-0 table-responsive'>
                                            <table className="w-full">
                                                <thead className=''>
                                                    <tr>
                                                        <th scope="col" colSpan={3} className='sticky-left  bgclr1  text-center '
                                                            style={{ minWidth: '450px' }}> Date </th>
                                                        {dates.map(date => (
                                                            <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                        ))}
                                                    </tr>
                                                    <tr className=' '>
                                                        <th scope="col" className='ms-3 sticky-left bgclr1 ' style={{ width: '150px' }}>Activity Name</th>
                                                        <th scope="col" className='text-center sticky-left1  bgclr1 ' style={{ minWidth: '150px' }}>Target
                                                        </th>
                                                        <th scope="col" className='text-center sticky-left2 bgclr1 ' style={{ minWidth: '150px' }}>Achieved</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {activitiesget.map((activity, mainindex) => {
                                                        let wholeTargetclr = ''
                                                        if (activity.day_or_month_wise) {
                                                            // monthwise
                                                            wholeTargetclr = (Number(activity.Total_Achived) / activity.targets) * 100 <= 50 ? 'bg-red-300' :
                                                                (Number(activity.Total_Achived) / activity.targets) * 100 <= 70 ? 'bg-yellow-300' :
                                                                    (activity.Total_Achived / activity.targets) * 100 <= 90 ? 'bg-blue-300 ' :
                                                                        'bg-green-300'
                                                        }
                                                        else {
                                                            //daywise
                                                            wholeTargetclr = Number(activity.Total_Achived) / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 50 ? 'bg-red-300' :
                                                                activity.Total_Achived / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 70 ? 'bg-yellow-300' :
                                                                    activity.Total_Achived / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 90 ? 'bg-blue-300 ' :
                                                                        'bg-green-300'
                                                        }
                                                        return (
                                                            <tr key={mainindex}>
                                                                {console.log(activity)}
                                                                <td className='sticky-left bgclr1 ' style={{ width: '150px' }} >
                                                                    <input type="text"
                                                                        value={activity.Activity_Name}
                                                                        name='Activity_Name'
                                                                        onChange={(e) => {
                                                                            handle_Activity_Name_Change(e, activity.id);
                                                                            handleActivitiesGet(e, activity.id)
                                                                        }}
                                                                        className={` form-control border-0 shadow-none  `} />
                                                                </td>
                                                                <td className='sticky-left1 bgclr1' style={{ width: '150px' }}>
                                                                    <span className='absolute top-3 right-3' >
                                                                        <InfoButton size={11} content={`Target for ${activity.day_or_month_wise ? 'a month' : 'a day'} `} />
                                                                    </span>
                                                                    <input type="number"
                                                                        value={`${activity.targets}`}
                                                                        name='targets'
                                                                        onChange={(e) => {
                                                                            handle_Activity_Name_Change(e, activity.id);
                                                                            handleActivitiesGet(e, activity.id)
                                                                        }}

                                                                        className="form-control border-0 shadow-none text-center" />
                                                                </td>
                                                                <td className='sticky-left2 bgclr1 ' style={{ width: '150px' }} >
                                                                    <p
                                                                        className={`p-2 text-black mb-0 rounded ${wholeTargetclr}  
                                                                        text-xs w-32 relative border-0 shadow-none text-center`} >
                                                                        {activity.Total_Achived} out of  {Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets)}

                                                                        <span className='absolute top-1 right-1 '> <InfoButton size={10}
                                                                            content={`Days filled = ${activity.daily_achives.filter((obj) => obj.achieved > 0).length} ,
                                                                    Target = ${activity.targets} `} />  </span>
                                                                    </p>
                                                                </td>
                                                                {dates.map((date) => {
                                                                    let obj = activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date)
                                                                    // console.log("sxdasdad", obj);
                                                                    // console.log(formattedCurrentDate);
                                                                    // console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                                    return (
                                                                        <td key={date}>

                                                                            <input type="number"
                                                                                value={obj && obj.achieved} disabled
                                                                                className={`p-2 w-24 rounded  border-0 shadow-none text-center 
                                                                                ${obj ? obj.status == '0' ? 'bg-red-300' : obj.status == '2' ? 'bg-yellow-300' : obj.status == '3' ?
                                                                                        'bg-green-300' : obj.status == '1' ? 'bg-orange-300' : '' : ''} `} />

                                                                        </td>
                                                                    )
                                                                }
                                                                )}
                                                            </tr>
                                                        )
                                                    }
                                                    )}


                                                </tbody>
                                            </table>
                                        </div>
                                        <div className="d-flex justify-content-end">
                                            {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                            {/* <button type="submit" onClick={Update_Changes} className="btn btn-primary btn-sm"> Update </button> */}
                                        </div>
                                    </div>

                                </main>
                                <main className="border p-4">
                                    <h4>Interviews  </h4>
                                    <div>
                                        <div className='mt-4 tablebg p-0 table-responsive'>
                                            <table className="">
                                                <thead className=''>
                                                    <tr>
                                                        <th scope="col" colSpan={3} className='sticky-left bgclr1 border-b-2 border-slate-700 text-center '
                                                            style={{ minWidth: '450px' }}> Date </th>
                                                        {dates.map(date => (
                                                            <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                        ))}
                                                    </tr>
                                                    <tr className=' '>
                                                        <th scope="col" className='ms-3 sticky-left bgclr1' style={{ width: '150px' }}>Position Name</th>
                                                        <th scope="col" className='text-center sticky-left1 bgclr1' style={{ width: '150px' }}>Target</th>
                                                        <th scope="col" className='text-center sticky-left2 bgclr1' style={{ width: '150px' }}>Achieved</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {interviewList && interviewList.map((activity, mainindex) => (

                                                        <tr key={mainindex}>
                                                            {console.log("interview", activity)}
                                                            <td className='sticky-left bgclr1 ' style={{ width: '150px' }} >
                                                                <input type="text"
                                                                    value={activity.position}
                                                                    name='position'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'interview')
                                                                        // handle_Activity_Name_Change(e, activity.id);
                                                                        // handleActivitiesGet(e, activity.id)
                                                                    }}
                                                                    className={` form-control border-0 shadow-none  `} />
                                                            </td>
                                                            <td className='sticky-left1 bgclr1 ' style={{ width: '150px' }}>
                                                                <input type="number"
                                                                    value={activity.targets}
                                                                    name='targets'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'interview')

                                                                        // handle_Activity_Name_Change(e, activity.id);
                                                                        // handleActivitiesGet(e, activity.id)
                                                                    }}

                                                                    className="form-control border-0 shadow-none text-center" />
                                                            </td>
                                                            <td className='sticky-left2 bgclr1 ' style={{ width: '150px' }} >
                                                                <p
                                                                    className={`p-2 text-black mb-0 rounded 
                                                                        ${Number(activity.Total_Achieved) / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 50 ? 'bg-red-300' :
                                                                            activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 70 ? 'bg-yellow-300' :
                                                                                activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets) * 100 <= 90 ? 'bg-blue-300 ' :
                                                                                    'bg-green-300'}  
                                                                        text-xs w-32 relative border-0 shadow-none text-center`} >
                                                                    {activity.Total_Achieved} out of  {Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.targets)}

                                                                    <span className='absolute top-1 right-1 '> <InfoButton size={10}
                                                                        content={`Days filled = ${activity.daily_achives.filter((obj) => obj.achieved > 0).length} ,
                                                                    Target = ${activity.targets} `} />  </span>
                                                                </p>
                                                            </td>
                                                            {dates.map((date) => {
                                                                let obj = interviewListDA[mainindex] && interviewListDA[mainindex].find((obj) => obj.Date == date)
                                                                // console.log("sxdasdad", obj);
                                                                // console.log(formattedCurrentDate);
                                                                // console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                                return (
                                                                    <td key={date}>

                                                                        <input type="number"
                                                                            value={obj && obj.achieved} disabled
                                                                            className={`p-2 w-24 rounded  border-0 shadow-none text-center 
                                            ${obj ? obj.status == '0' ? 'bg-red-300' : obj.status == '2' ? 'bg-yellow-300' : obj.status == '3' ?
                                                                                    'bg-green-300' : obj.status == '1' ? 'bg-orange-300' : '' : ''} `} />

                                                                    </td>
                                                                )
                                                            }
                                                            )}
                                                        </tr>
                                                    ))}


                                                </tbody>
                                            </table>
                                        </div>
                                        <div className="d-flex justify-content-end">
                                            {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                            {/* <button type="submit" onClick={Update_Changes} className="btn btn-primary btn-sm"> Update </button> */}
                                        </div>
                                    </div>

                                </main>
                                <main className="border p-4">
                                    <h4>Walkins </h4>
                                    <div>
                                        <div className='mt-4 tablebg p-0 table-responsive'>
                                            <table className="w-full">
                                                <thead className=''>
                                                    <tr className=''>
                                                        <th scope="col" colSpan={3} className='sticky-left bgclr1 bottom-2 border-slate-700 text-center '
                                                            style={{ minWidth: '450px' }}> Date </th>
                                                        {dates.map(date => (
                                                            <th key={date} rowSpan={2} className='border-b-2 border-slate-500 text-center pb-4'>{date}</th>
                                                        ))}
                                                    </tr>
                                                    <tr className=' '>
                                                        <th scope="col" className='ms-3 sticky-left bgclr1 ' style={{ width: '150px' }}>Position Name</th>
                                                        <th scope="col" className='text-center sticky-left1 bgclr1 ' style={{ width: '150px' }}>Target</th>
                                                        <th scope="col" className='text-center sticky-left2 bgclr1' style={{ width: '150px' }}>Achieved</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {walkinList && walkinList.map((activity, mainindex) => (

                                                        <tr key={mainindex}>
                                                            {console.log(activity)}
                                                            <td className='sticky-left bgclr1 ' style={{ width: '150px' }} >
                                                                <input type="text"
                                                                    value={activity.position}
                                                                    name='position'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'walkin')
                                                                    }}
                                                                    className={` form-control border-0 shadow-none  `} />
                                                            </td>
                                                            <td className='sticky-left1 bgclr1 ' style={{ width: '150px' }} >
                                                                <input type="number"
                                                                    value={activity.Walkins_target}
                                                                    name='Walkins_target'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'walkin')
                                                                    }}

                                                                    className="form-control border-0 shadow-none text-center" />
                                                            </td>
                                                            <td className='sticky-left2 bgclr1 ' style={{ width: '150px' }} >
                                                                <p
                                                                    className={`p-2 text-black mb-0 rounded 
                                                                        ${Number(activity.Total_Achieved) / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Walkins_target) * 100 <= 50 ? 'bg-red-300' :
                                                                            activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Walkins_target) * 100 <= 70 ? 'bg-yellow-300' :
                                                                                activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Walkins_target) * 100 <= 90 ? 'bg-blue-300 ' :
                                                                                    'bg-green-300'}  
                                                                        text-xs w-32 relative border-0 shadow-none text-center`} >
                                                                    {activity.Total_Achieved} out of  {Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Walkins_target)}

                                                                    <span className='absolute top-1 right-1 '> <InfoButton size={10}
                                                                        content={`Days filled = ${activity.daily_achives.filter((obj) => obj.achieved > 0).length} ,
                                                                    Target = ${activity.Walkins_target} `} />  </span>
                                                                </p>
                                                            </td>
                                                            {dates.map((date) => {
                                                                let obj = walkinListDA[mainindex] && walkinListDA[mainindex].find((obj) => obj.Date == date)
                                                                // console.log("sxdasdad", obj);
                                                                // console.log(formattedCurrentDate);
                                                                // console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                                return (
                                                                    <td key={date}>

                                                                        <input type="number"
                                                                            value={obj && obj.achieved} disabled
                                                                            className={`p-2 w-24 rounded  border-0 shadow-none text-center 
                                                                                 ${obj ? obj.status == '0' ? 'bg-red-300' :
                                                                                    obj.status == '2' ? 'bg-yellow-300' :
                                                                                        obj.status == '3' ?
                                                                                            'bg-green-300' : obj.status == '1' ? 'bg-orange-300' : '' : ''} `} />

                                                                    </td>
                                                                )
                                                            }
                                                            )}
                                                        </tr>
                                                    ))}


                                                </tbody>
                                            </table>
                                        </div>
                                        <div className="d-flex justify-content-end">
                                            {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                            {/* <button type="submit" onClick={Update_Changes} className="btn btn-primary btn-sm"> Update </button> */}
                                        </div>
                                    </div>

                                </main>
                                <main className="border p-4">
                                    <h4>Offered </h4>
                                    <div>
                                        <div className='mt-4 tablebg p-0 table-responsive'>
                                            <table className="w-full">
                                                <thead className=''>
                                                    <tr>
                                                        <th scope="col" colSpan={3} className='bgclr1 sticky-left text-center '
                                                            style={{ minWidth: '450px' }}> Date </th>
                                                        {dates.map(date => (
                                                            <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                        ))}
                                                    </tr>
                                                    <tr className=' '>
                                                        <th scope="col" className='ms-3 bgclr1 sticky-left ' style={{ width: '150px' }}>Position Name</th>
                                                        <th scope="col" className='text-center bgclr1 sticky-left1' style={{ width: '150px' }}>Target</th>
                                                        <th scope="col" className='text-center bgclr1 sticky-left2' style={{ width: '150px' }}>Achieved</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {offerList && offerList.map((activity, mainindex) => (

                                                        <tr key={mainindex}>
                                                            {console.log(activity)}
                                                            <td className='sticky-left bgclr1 ' style={{ width: '150px' }} >
                                                                <input type="text"
                                                                    value={activity.position}
                                                                    name='position'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'offer')
                                                                    }}
                                                                    className={` form-control border-0 shadow-none  `} />
                                                            </td>
                                                            <td className='sticky-left1 bgclr1 ' style={{ width: '150px' }} >
                                                                <input type="number"
                                                                    value={activity.Offers_target}
                                                                    name='Offers_target'
                                                                    onChange={(e) => {
                                                                        handle_InterviewList(e, activity.id, 'offer')
                                                                    }}

                                                                    className="form-control border-0 shadow-none text-center" />
                                                            </td>
                                                            <td className='sticky-left2 bgclr1 ' style={{ width: '150px' }} >
                                                                <p
                                                                    className={`p-2 text-black mb-0 rounded 
                                                                        ${Number(activity.Total_Achieved) / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Offers_target) * 100 <= 50 ? 'bg-red-300' :
                                                                            activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Offers_target) * 100 <= 70 ? 'bg-yellow-300' :
                                                                                activity.Total_Achieved / Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Offers_target) * 100 <= 90 ? 'bg-blue-300 ' :
                                                                                    'bg-green-300'}  
                                                                        text-xs w-32 relative border-0 shadow-none text-center`} >
                                                                    {activity.Total_Achieved} out of  {Number(activity.daily_achives.filter((obj) => obj.achieved > 0).length * activity.Offers_target)}

                                                                    <span className='absolute top-1 right-1 '> <InfoButton size={10}
                                                                        content={`Days filled = ${activity.daily_achives.filter((obj) => obj.achieved > 0).length} ,
                                                                    Target = ${activity.Offers_target} `} />  </span>
                                                                </p>
                                                            </td>
                                                            {dates.map((date) => {
                                                                let obj = offerListDA[mainindex] && offerListDA[mainindex].find((obj) => obj.Date == date)
                                                                // console.log("sxdasdad", obj);
                                                                // console.log(formattedCurrentDate);
                                                                // console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                                return (
                                                                    <td key={date}>
                                                                        <input type="number"
                                                                            value={obj && obj.achieved} disabled
                                                                            className={`p-2 w-24 rounded  border-0 shadow-none text-center 
                                            ${obj ? obj.status == '0' ? 'bg-red-300' : obj.status == '2' ? 'bg-yellow-300' : obj.status == '3' ?
                                                                                    'bg-green-300' : obj.status == '1' ? 'bg-orange-300' : '' : ''} `} />

                                                                    </td>
                                                                )
                                                            }
                                                            )}
                                                        </tr>
                                                    ))}


                                                </tbody>
                                            </table>
                                        </div>
                                        <div className="d-flex justify-content-end">
                                            {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                            {/* <button type="submit" onClick={Update_Changes} className="btn btn-primary btn-sm"> Update </button> */}
                                        </div>
                                    </div>

                                </main>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* open Particular Data End */}





        </div >




    )
}

export default Reporting_team