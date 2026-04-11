import React, { useState } from 'react'
import { useEffect } from 'react'
import axios from 'axios'
import { port } from '../App'
import { Link, useNavigate } from 'react-router-dom'
import '../assets/css/Login_.css'
import Topnav from './Topnav'
import EmployeeProfile from '../Pages/EmployeeProfile'




const Profile_page = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    const user = JSON.parse(sessionStorage.getItem('user'))
    let logindata = JSON.parse(sessionStorage.getItem('user'))
    // Leave applay form start

    const [Employee_Id, setEmployee_Id] = useState("");
    const [Name, setName] = useState("");
    const [phone, setphone] = useState("");
    const [email, setemail] = useState("");
    const [Reporting_manager, setReporting_manager] = useState("");
    const [Employee_type, setEmployee_type] = useState("");
    const [LeaveType, setLeaveType] = useState("");
    const [FromDate, setFromDate] = useState("");
    const [ToDate, setToDate] = useState("");
    const [Days, setDays] = useState("");
    const [Reason, setReason] = useState("");
    const [Any_proof, setAny_proof] = useState("");

    const handle_Leave_apply_form = (e) => {
        e.preventDefault();

        // Convert input date strings to Date objects
        const fromDateObj = new Date(FromDate);
        const toDateObj = new Date(ToDate);

        // Calculate the difference in milliseconds
        const differenceInTime = toDateObj.getTime() - fromDateObj.getTime();

        // Convert milliseconds to days
        const differenceInDays = differenceInTime / (1000 * 3600 * 24);

        // Set the calculated days
        setDays(differenceInDays);

        // Other form submission logic can follow
        alert("leave Form");

        const formData1 = new FormData();
        formData1.append('Employee_Id', Employee_Id);
        formData1.append('Name', Name);
        formData1.append('phone', phone);
        formData1.append('email', email);
        formData1.append('Reporting_manager', Reporting_manager);
        formData1.append('Employee_type', Employee_type);
        formData1.append('LeaveType', LeaveType);
        formData1.append('FromDate', FromDate);
        formData1.append('ToDate', ToDate);
        formData1.append('Days', differenceInDays); // Here we are sending the calculated difference
        formData1.append('Reason', Reason);
        formData1.append('Any_proof', Any_proof);

        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
    };
    // Leave applay form end

    // resignation Apply form Start

    let Profile_Info = JSON.parse(sessionStorage.getItem('Login_Profile_Information'))

    // EMPLOYEE RESIGNATION FORM  START

    const [Reason1, setReason1] = useState('');
    const [HRmanager, setHRmanager] = useState('');
    const [resigned_letter_file, setresigned_letter_file] = useState({});
    const [Confirm_resignation, setConfirm_resignation] = useState(false);

    const handle_employee_Resignation_info = (e) => {
        e.preventDefault()
        alert("EMPLOYEE RESIGNATION FORM ")

        // console.log(resigned_letter_file)
        const formData1 = new FormData()

        formData1.append('employee_id', Profile_Info.employee_Id);
        formData1.append('name', Profile_Info.full_name);
        formData1.append('position', Profile_Info.Position);
        formData1.append('reporting_manager_name', Profile_Info.RepotringTo_Id);
        formData1.append('HR_manager_name', HRmanager);
        formData1.append('reason', Reason1);
        formData1.append('resigned_letter_file', resigned_letter_file);
        formData1.append('Confirm_resignation', Confirm_resignation);


        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}root/ems/ResignationRequest`, formData1).then((res) => {

            console.log("EMPLOYEE_RESIGNATION_FORM_RES", res.data);
            alert(res.data)


        }).catch((err) => {

            console.log("EMPLOYEE_RESIGNATION_FORM_ERR", err.data);

        })

    }
    //  EMPLOYEE RESIGNATION FORM  END

    // HR Manager Start

    const [interviewers, setinterviewers] = useState([])

    useEffect(() => {

        axios.get(`${port}/root/ems/HRList`).then((res) => {
            console.log("HrManager", res.data);
            setinterviewers(res.data)
        }).catch((error) => console.log(error))
    }, [])
    // HR Manager End

    // resignation Apply form end

    // Profile Data START
    let [profile_info, setprofile_info] = useState({})
    useEffect(() => {

        axios.get(`${port}/root/loginuser/${Empid}/`).then((res) => {
            console.log("login_res", res.data);
            setprofile_info(res.data)



        }).catch((err) => {
            console.log("login_err", err.data);

        })

    }, [])
    // Profile Data END

    // Profile Img change Start
    const handleFileChange = (event) => {
        const file = event.target.files[0];

        const formData = new FormData();
        formData.append('profile_img', file);
        console.log("file", file);
        axios.patch(`${port}/root/UserProfileUpload/${Empid}/`, formData).then((res) => {
            console.log("profile_img_res", res);
            window.location.reload()


        }).catch((err) => {
            console.log("profile_img_err", err);

        })
    };
    // Profile Img change End

    // Change Password

    let [oldPassword, setoldPassword] = useState("")
    let [newPassword, setnewPassword] = useState("")


    const changepassword = (e) => {

        e.preventDefault();

        const formData = new FormData();
        formData.append('OldPassword', oldPassword);
        formData.append('NewPassword', newPassword);
        formData.append('EmployeeId', Empid);


        axios.post(`${port}/root/changepassword`, formData).then((res) => {
            console.log("changepassword_res", res.data);
            alert(res.data)
            window.location.reload();

        }).catch((err) => {
            console.log("changepassword_res", err);
            alert(err.data)
        })
    };

    // Logout
    const navigate = useNavigate()

    const logout = () => {
        // Store EmployeeId before clearing session
        const employeeId = user?.EmployeeId;
        
        // Call logout API if employeeId exists
        if (employeeId) {
            axios.post(`${port}/root/logout/${employeeId}/`)
                .then((r) => {
                    console.log(" Logout Successfull", r.data)
                    sessionStorage.removeItem('user')
                    navigate("/")
                })
                .catch((err) => {
                    console.log("Logout Error", err)
                    sessionStorage.removeItem('user')
                    navigate("/")
                })
        } else {
            // If no user, just clear and navigate
            sessionStorage.removeItem('user')
            navigate("/")
        }
    }

    // Employee Information start
    // const [EMPLOYEE_INFORMATION, setEMPLOYEE_INFORMATION] = useState([])

    // const sentparticularData = (id) => {

    //     console.log(id);

    //     axios.get(`${port}/root/ems/EmployeeProfile/${id}/`)
    //         .then(response => {

    //             console.log('Paticular_Employee_Data_Res', response.data);
    //             setEMPLOYEE_INFORMATION(response.data.EmployeeInformation)
    //             // setREFERENCE(response.data.CandidateReferenceDetails)
    //             // setEDUCATION_DETAILS(response.data.EducationDetails);
    //             // setCONTACT_EMERGENCY(response.data.EmergencyContactDetails);
    //             // setFAMILY_DETAILS(response.data.FamilyDetails);
    //             // setEMERGENCY_DETAILS(response.data.EmergencyDetails);
    //             // setLAST_POSITION_HELD(response.data.LastPositionHeldDetails);
    //             // setEXPERIENCE_LAST_POSITION(response.data.ExperienceDetails);

    //         })
    //         .catch(error => {

    //             console.error('Paticular_Employee_Data_Err', error.data);
    //         });
    // };

    // Employee Information End


    return (
        <div>
            <div className='container mx-auto' style={{ width: '100%', minHeight: '100vh' }}>
                <Topnav />
                <Link to={`/dashboard/${logindata.Disgnation}`} className='text-black'>

                    <i class="fa-solid fa-arrow-left" style={{ position: 'absolute', left: '47px', top: '35px' }}></i>
                </Link>

                <div className="row  m-0">

                    <div className="col-sm-8  ">

                        <div className='p-2 p-sm-4 bgclr rounded'>

                            <div className='d-flex row m-0'>
                                <div className="profile_img col-sm-4  ">

                                    <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
                                        <div className='rounded-circle' style={{ width: '150px', height: '150px', backgroundColor: 'rgb(76,53,117)', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                                            <img className='rounded-circle object-cover ' style={{ width: '150px', height: '150px' }} src={profile_info.profile_img} alt="Profile Image" />
                                        </div>
                                        <div className='text-center mt-3'>
                                            <h4>{profile_info.UserName} </h4>
                                            <h6 style={{ color: 'rgb(76,53,117)' }}> {user.Position}</h6>

                                        </div>
                                        <div style={{ position: 'relative', left: '63px', bottom: '120px', width: '25px', height: '25px', backgroundColor: 'rgb(251,239,178)', borderRadius: '50%', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>

                                            {/* <i class="fa-solid fa-upload " id="fileInput" type="file" onChange={handleFileChange} accept="image/*" style={{ fontSize: '12px' }}></i> */}
                                            <input id="fileInput" type="file" accept="image/*" onChange={handleFileChange} style={{ width: '25px', height: '25px', borderRadius: '50%', backgroundColor: 'red' }} />
                                        </div>
                                    </div>



                                </div>
                                <div className="details col-sm-6 ">

                                    <div className=' ms-4' style={{ lineHeight: '120px' }}>

                                        <div className='mt-3'>
                                            <h6 className={` rounded-3 border text-white p-1 ${user.is_login ? 'bg-success' : 'bg-red '}`} style={{ width: 'fit-content' }}> Active</h6>
                                        </div>

                                        <div className='mt-4'>
                                            <h6>Employee ID : <span className='text-secondary'> {user.EmployeeId}</span></h6>
                                        </div>
                                        <div className='mt-4'>
                                            <h6>Name :  <span className='text-secondary'>{user.UserName}</span> </h6>
                                        </div>
                                        <div className='mt-4'>
                                            <h6>Email   : <span className='text-secondary'>{user.Email} </span></h6>
                                        </div>
                                        <div className='mt-4'>
                                            <h6>Phone Number : <span className='text-secondary'>+91 {user.PhoneNumber}</span></h6>
                                        </div>




                                    </div>

                                </div>
                                <div className="Media col-sm-2   ">

                                    <div className=' '>

                                        <ul className='mt-3 media-icons me-sm-0  me-5' >
                                            <li className='nav-link border  border-success rounded-circle mt-2' style={{ width: '35px', height: '35px', display: 'flex', justifyContent: 'center', alignItems: 'center' }} ><i class="fa-solid fa-user-tie"></i></li>
                                            <li className='nav-link  border  border-success rounded-circle mt-2' style={{ width: '35px', height: '35px', display: 'flex', justifyContent: 'center', alignItems: 'center' }} ><i class="fa-brands fa-github"></i></li>
                                            <li className='nav-link  border  border-success rounded-circle mt-2' style={{ width: '35px', height: '35px', display: 'flex', justifyContent: 'center', alignItems: 'center' }} ><i class="fa-brands fa-linkedin"></i></li>
                                            <li className='nav-link  border  border-success rounded-circle mt-2' style={{ width: '35px', height: '35px', display: 'flex', justifyContent: 'center', alignItems: 'center' }}><i class="fa-brands fa-square-instagram"></i></li>
                                            <li className='nav-link  border  border-success rounded-circle mt-2' style={{ width: '35px', height: '35px', display: 'flex', justifyContent: 'center', alignItems: 'center' }}><i class="fa-brands fa-facebook"></i></li>
                                        </ul>

                                    </div>

                                </div>

                            </div>

                        </div>



                    </div>
                    <div className="col-sm-4   ">

                        <div className='p-4 bgclr rounded'>

                            <h4 className='bg-light p-1'> <i class="fa-solid fa-person-running me-4 " style={{ color: 'rgb(76,53,117)' }}> </i> Action</h4>

                            <ul style={{ position: 'relative', right: '30px' }}>

                                <li className='nav-link mt-4' data-bs-target="#exampleModal7" data-bs-toggle="modal" ><i class="fa-solid fa-key me-2"></i> Change Password</li>
                                {/* <li style={{ position: 'relative', top: '10px' }} className='nav-link mt-2'><i class="fa-solid fa-user me-2"></i> Edit Profile</li> */}
                                <li style={{ position: 'relative', top: '20px' }} onClick={logout} className='nav-link mt-2'><i class="fa-solid fa-right-from-bracket me-2"></i> Log Out</li>
                            </ul>

                        </div>

                        {/* <div className='p-4 m-3 bgclr rounded'> */}


                        {/* Change Password Start */}
                        {/* <div class="modal fade" id="exampleModal7" tabindex="-1" aria-labelledby="exampleModalLabel7" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel7">Change Password</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div className="col-md-12 col-lg-12 mb-3 text-start">
                                                <label htmlFor="Name" className="form-label text-start">Old Password </label>
                                                <input type="text" className="form-control shadow-none" id="Name" name="Name" value={oldPassword} onChange={(e) => setoldPassword(e.target.value)} />
                                            </div>
                                            <div className="col-md-12 col-lg-12 mb-3 text-start">
                                                <label htmlFor="Name" className="form-label text-start">New Password </label>
                                                <input type="text" className="form-control shadow-none" id="Name" name="Name" value={newPassword} onChange={(e) => setnewPassword(e.target.value)} />
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-primary" onClick={changepassword}>Submit</button>
                                        </div>
                                    </div>
                                </div>
                            </div> */}
                        <div class="modal fade" id="exampleModal7" tabindex="-1" aria-labelledby="exampleModalLabel7" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel7">Change Password</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form>
                                            <div class="mb-1 inputGroup w-100">
                                                <label for="oldPassword" class="form-label">Old Password</label>
                                                <input type="password" class="form-control shadow-none" id="oldPassword" name="oldPassword" value={oldPassword} onChange={(e) => setoldPassword(e.target.value)} required />
                                                <div class="invalid-feedback">
                                                    Please enter your old password.
                                                </div>
                                            </div>
                                            <div class="mb-3 inputGroup w-100">
                                                <label for="newPassword" class="form-label">New Password</label>
                                                <input type="password" class="form-control shadow-none" id="newPassword" name="newPassword" value={newPassword} onChange={(e) => setnewPassword(e.target.value)} required />
                                                <div class="invalid-feedback">
                                                    Please enter your new password.
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-primary" onClick={changepassword} >Submit</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/* Change Password End */}







                        {/* </div> */}

                    </div>

                </div>


                {/* <EmployeeProfile /> */}

            </div>

        </div>
    )
}

export default Profile_page