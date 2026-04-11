import React, { useContext, useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import { HrmStore } from '../Context/HrmContext'
import PlusIcon from '../SVG/PlusIcon'
import CreateDepartment from './Modals/CreateDepartment'
import CreateDesignation from './Modals/CreateDesignation'
import ThreeDot from '../SVG/ThreeDot'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'



const Employeees = ({ subpage }) => {
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let navigate = useNavigate()
    const [AllDepartmentlist, setAllDepartmentlist] = useState([])
    const [AllDesignationlist, setAllDesignationlist] = useState([])
    const [AllEmployeelist, setAllEmployeelist] = useState([])
    let [deptModal, setdeptmodal] = useState(false)
    let [designationModal, setDesignationmodal] = useState(false)
    let [deptIndex, setDepartmentIndex] = useState()
    let [deptIdforDesignation, setDeptIdForDesignation] = useState()

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
    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('Employee')
    }, [])
    // useEffect(() => {

    //     fetchdata()

    // }, [])

    // const fetchdata = () => {
    //     axios.get(`${port}/root/ems/AllEmployeesList/${Empid}/`).then((res) => {
    //         console.log("AllEmployee_res", res.data);
    //         setAllEmployeelist(res.data)

    //     }).catch((err) => {
    //         console.log("AllEmployee_err", err.data);
    //     })
    // }

    let Call_Designation_list = (e) => {

        console.log("id", e);

        axios.get(`${port}/root/ems/SingleDesignation/List/${e}/`).then((res) => {
            console.log("AllDesignation_list_res", res.data);
            setAllDesignationlist(res.data)

        }).catch((err) => {
            console.log("AllDesignation_list_err", err.data);
        })

    }

    let Call_Employee_list = (e) => {
        console.log("id", e);
        axios.get(`${port}root/ems/SingleDesignation/Employee/List/${e}/`).then((res) => {
            console.log("AllDesignation_list_res", res.data);
            setAllEmployeelist(res.data)

        }).catch((err) => {
            console.log("AllDesignation_list_err", err.data);
        })
    }

    const sentparticularData = (id) => {

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

    let getDept = () => {
        axios.get(`${port}/root/ems/DepartmentList/${Empid}/`).then((res) => {
            console.log("DepartmentList_res", res.data);
            setAllDepartmentlist(res.data)

        }).catch((err) => {
            console.log("DepartmentList_err", err.data);
        })
    }

    useEffect(() => {
        getDept()
    }, [])




    const [DEPARTMENT_LIST, setDEPARTMENT_LIST] = useState(true)
    const [DESIGNATION_LIST, setDESIGNATION_LIST] = useState(false)
    const [EMPLOYEE_DATA_LIST, setEMPLOYEE_DATA_LIST] = useState(false)
    const [PERSONAL_EMP_DATA, setPERSONAL_EMP_DATA] = useState(false)

    let { setTopNav } = useContext(HrmStore)
    useEffect(() => {
        setTopNav('overview')
    }, [])
    return (
        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', }}>
            {!subpage && <div className='flex'>
                <Sidebar value={"dashboard"} ></Sidebar>
            </div>}
            <div className=' m-0 m-sm-4  flex-1  mx-auto ' style={{ borderRadius: '10px' }}>
                {!subpage && <Topnav></Topnav>}

                {/* DEPARTMENT LIST START */}

                <div className={` ${DEPARTMENT_LIST ? '' : 'd-none '}`}>

                    <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                        <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Department List</h6>
                        <section className='flex gap-3'>

                            <button onClick={() => { setdeptmodal(true); setDepartmentIndex(false) }} className='flex gap-2 items-center text-sm 
                        rounded p-2 px-3 shadow-sm btngrd text-white'>
                                <PlusIcon />  Add Department
                            </button>
                            <button onClick={() => { setDesignationmodal(true); setDepartmentIndex(false) }} className='flex gap-2 items-center text-sm 
                        rounded p-2 px-3 shadow-sm btngrd text-white'>
                                <PlusIcon />  Add Designation
                            </button>

                        </section>

                    </div>
                    {setdeptmodal && <CreateDepartment did={deptIndex} show={deptModal} setshow={setdeptmodal} getdept={getDept} />}


                    {designationModal && <CreateDesignation setdid={setDepartmentIndex}
                        deptid={deptIdforDesignation} getdesignation={Call_Designation_list}
                        did={deptIndex} show={designationModal} setshow={setDesignationmodal} />}

                    <div className='row  m-0 p-1 mt-3'>

                        {AllDepartmentlist != undefined && AllDepartmentlist &&
                            AllDepartmentlist.map((e, index) => {
                                return (

                                    <div onMouseLeave={() => setDepartmentIndex(-1)} className="col-md-12 col-lg-4 mb-3  p-2">
                                        <section className='relative  '>
                                            <button onClick={() => {
                                                if (deptIndex != e.id)
                                                    setDepartmentIndex(e.id)
                                                else
                                                    setDepartmentIndex(-1)
                                            }} className='absolute top-0 right-0 p-2 '>
                                                <ThreeDot size={5} />
                                            </button>
                                            {deptIndex == e.id && <article className='absolute text-xs top-1 rounded p-2 right-5 bg-white shadow ' >
                                                <button onClick={() => setdeptmodal(true)} className='block hover:text-blue-400 '>
                                                    Edit
                                                </button>
                                                <button onClick={() => {
                                                    axios.delete(`${port}/root/ems/Departments/${deptIndex}/`).then((response) => {
                                                        toast.success('Deleted Successfully')
                                                        getDept()
                                                    }).catch((error) => { toast.error('error acquired'); console.log(error) })
                                                }} className='block my-1 hover:text-red-600 '>
                                                    Delete
                                                </button>
                                            </article>}
                                            <div onClick={() => {
                                                setDEPARTMENT_LIST(false)
                                                setDESIGNATION_LIST(true)
                                                Call_Designation_list(e.id)
                                                setDeptIdForDesignation(e.id)
                                            }} className='p-2 border-2 rounded border-white cursor-pointer
                                     bg-slate-50 order-secondary' >
                                                <div className='d-flex'>
                                                    <div className='w-75'>
                                                        <h2 style={{ cursor: 'pointer' }} className='ps-3 text-xl '> {e.Department}</h2>
                                                        <h6 className='ps-3 text-slate-500 '> Department </h6>
                                                    </div>
                                                    <div className='w-25 text-center '>
                                                        <h2 style={{ color: 'rgb(76,53,117)' }} className='mt-3 '>{e.No_Of_Employees}</h2>
                                                    </div>
                                                </div>
                                            </div>

                                        </section>
                                    </div>
                                )
                            })}
                    </div>
                </div>
                {/* DEPARTMENT LIST END */}

                {/* DESIGNATION LIST START */}
                <div className={` ${DESIGNATION_LIST ? '' : 'd-none '}`}>

                    <div className='m-1  p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                        <div className=' d-flex'>
                            <h6
                                onClick={() => {


                                    setDEPARTMENT_LIST(true)
                                    setDESIGNATION_LIST(false)

                                }}

                                className='ms-1'><i style={{ color: 'black' }} class="fa-solid fa-arrow-left mt-2" ></i></h6>
                            <h6 className='mt-2 ms-4 heading' style={{ color: 'rgb(76,53,117)' }}>Designation List</h6>
                        </div>





                    </div>

                    <div className='row  m-0 p-1 mt-3'>

                        {AllDesignationlist != undefined && AllDesignationlist != undefined &&
                            AllDesignationlist.map((e, index) => {
                                return (

                                    <div onMouseLeave={() => setDepartmentIndex(-1)} className="col-md-12 col-lg-4 mb-3  p-2">
                                        <section className='relative  '>
                                            <button onClick={() => {
                                                if (deptIndex != e.id)
                                                    setDepartmentIndex(e.id)
                                                else
                                                    setDepartmentIndex(-1)
                                            }} className='absolute top-0 right-0 p-2 '>
                                                <ThreeDot size={5} />
                                            </button>
                                            {deptIndex == e.id && <article className='absolute text-xs top-1 rounded p-2 right-5 bg-white shadow ' >
                                                <button onClick={() => setDesignationmodal(true)}
                                                    className='block hover:text-blue-400 '>
                                                    Edit
                                                </button>
                                                <button onClick={() => {
                                                    axios.delete(`${port}/root/ems/Designations/${e.id}/`).then((response) => {
                                                        toast.success('Deleted Successfully')
                                                        Call_Designation_list(deptIdforDesignation)
                                                    }).catch((error) => { toast.error('error acquired'); console.log(error) })
                                                }} className='block my-1 hover:text-red-600 '>
                                                    Delete
                                                </button>
                                            </article>}
                                            <div onClick={() => {
                                                Call_Employee_list(e.id)
                                                setDESIGNATION_LIST(false)
                                                setEMPLOYEE_DATA_LIST(true)
                                            }
                                            } style={{ height: '100px' }}
                                                className='p-2 cursor-pointer w-full rounded-xl bg-slate-50 border-white border-2 border-secondary' >

                                                <div className='d-flex'>
                                                    <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'start' }} className='w-75 pt-1'>
                                                        <h5 style={{ cursor: 'pointer' }} className='ps-3 '


                                                        >{e.Designation}</h5>
                                                        <p style={{ color: 'rgb(76,53,117)' }} className='ps-3'></p>
                                                    </div>
                                                    <div className='w-25 text-center '>
                                                        <h1 style={{ color: 'rgb(76,53,117)' }} className='mt-2 '>{e.No_Of_Employees}</h1>
                                                    </div>

                                                </div>

                                            </div>
                                        </section>
                                    </div>



                                )
                            })}
                    </div>

                </div>
                {/* DESIGNATION LIST END */}

                {/* EMPLOYEE LIST START */}
                <div className={` ${EMPLOYEE_DATA_LIST ? '' : 'd-none '}`} >

                    <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                        <div className='d-flex'>
                            <h6
                                onClick={() => {
                                    setDESIGNATION_LIST(true)
                                    setEMPLOYEE_DATA_LIST(false)
                                }}

                                className='ms-1'><i style={{ color: 'black' }} class="fa-solid fa-arrow-left mt-2" ></i></h6>
                            <h6 className='mt-2 ms-4 heading' style={{ color: 'rgb(76,53,117)' }}>Employee List</h6>
                        </div>



                    </div>

                    <div className='row  m-0 p-1 mt-3'>

                        {AllEmployeelist != undefined && AllEmployeelist != undefined && AllEmployeelist.map((e, index) => {
                            return (

                                <div className="col-12 col-sm-3 mb-3  p-2">

                                    <div style={{ border: '.5px solid black', Width: '230px', height: '200px' }}
                                        className='p-2 bg-slate-50 rounded-xl border-2 border-white ' >
                                        <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
                                            <div style={{ position: 'relative' }}>
                                                <div style={{ position: "absolute" }} class="btn-group" >
                                                    <i style={{ position: "absolute", left: '96px', top: '4px', cursor: 'pointer' }}
                                                        class="fa-solid fa-ellipsis-vertical " data-bs-toggle="dropdown" aria-expanded="false" ></i>
                                                    <ul class="dropdown-menu dropdown-menu-end">
                                                        <li><button class="dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#exampleModaledit"><i class="fa-solid fa-pen me-2"></i>  Edit</button></li>
                                                        <li><button class="dropdown-item" type="button"><i class="fa-solid fa-trash me-2"></i> Delete</button></li>
                                                    </ul>
                                                </div>
                                            </div>

                                            <div>
                                                <img className='rounded-circle mt-3' src="https://smarthr.dreamstechnologies.com/html/template/assets/img/profiles/avatar-02.jpg" style={{ width: '90px' }} alt="" />
                                            </div>
                                            <div className='mt-2'>

                                                {/* <td onClick={() => sentparticularData(e.id)} data-bs-toggle="modal" data-bs-target="#exampleModal5" key={e.id} style={{ cursor: 'pointer' }}> {e.full_name}</td> */}

                                                <h6 style={{ cursor: 'pointer' }}
                                                    onClick={() => {

                                                        sentparticularData(e.Emp_profile_id)
                                                        setEMPLOYEE_DATA_LIST(false)
                                                        navigate(`/dash/employee/${e.Emp_profile_id}`)
                                                        // setPERSONAL_EMP_DATA(true)

                                                    }
                                                    }

                                                >{e.EmployeeName
                                                    }</h6>
                                            </div>
                                            <div>
                                                <small>{e.Designation}</small>
                                            </div>


                                        </div>

                                    </div>

                                </div>



                            )
                        })}
                    </div>

                </div>
                {/* EMPLOYEE EDIT MODAL START */}
                <div class="modal fade" id="exampleModaledit" tabindex="-1" aria-labelledby="exampleModalLabeledit" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalLabeledit">Edit Employee</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">

                                <div className="row m-0  ">
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="candidateID" className="form-label">Name</label>
                                        <input type="text" className="form-control shadow-none bg-light" placeholder='Rakesh' />
                                    </div>
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="candidateID" className="form-label">Employee Id</label>
                                        <input type="text" className="form-control shadow-none bg-light" placeholder='MTM23' />
                                    </div>
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="candidateID" className="form-label">Email</label>
                                        <input type="email" className="form-control shadow-none bg-light" placeholder='rakkiii49sh8@gmail.com' />
                                    </div>
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="candidateID" className="form-label">Joining Date</label>
                                        <input type="date" className="form-control shadow-none bg-light" placeholder='1/12/23' />
                                    </div>
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="candidateID" className="form-label">Phone</label>
                                        <input type="tel" className="form-control shadow-none bg-light" placeholder='6381849973' />
                                    </div>

                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label for="interviewer">Department*</label>
                                        <select id="interviewer" name="interviewer" required class="form-control">
                                            <option value="" selected>Select</option>
                                            <option value="" >It</option>
                                            <option value="" >Hr</option>
                                            <option value="" >Manager</option>

                                        </select>
                                    </div>
                                    <div className="col-md-6 col-lg-4 mb-3">
                                        <label for="interviewer">Designation*</label>
                                        <select id="interviewer" name="interviewer" required class="form-control">
                                            <option value="" selected>Select</option>
                                            <option value="" >Webdeveloper</option>
                                            <option value="" >Testing</option>
                                            <option value="" >Junior HR Manager</option>
                                            <option value="" >Business Development Manager</option>

                                        </select>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer">
                                {/* <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button> */}
                                <button style={{ backgroundColor: 'rgb(76,53,117)', color: 'white' }} type="button" class="btn " >Save changes</button>
                            </div>
                        </div>
                    </div>
                </div>
                {/* EMPLOYEE EDIT MODAL END */}
                {/* EMPLOYEE LIST END */}


                {/* EMPLOYEE PROFILE  START */}
                <div className={` ${PERSONAL_EMP_DATA ? '' : 'd-none '}`}>

                    <div className='d-flex'>
                        <h6
                            onClick={() => {


                                setEMPLOYEE_DATA_LIST(true)
                                setPERSONAL_EMP_DATA(false)

                            }}

                            className='ms-1'><i style={{ color: 'black' }} class="fa-solid fa-arrow-left mt-2" ></i></h6>
                        <h6 className='mt-2 ms-4 heading' style={{ color: 'rgb(76,53,117)' }}>Employee Profile</h6>
                    </div>

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
                                                    <h4>{EMPLOYEE_INFORMATION.full_name}</h4>
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
                                                <div className='d-flex' style={{ lineHeight: '45px' }}>


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
                                                </div>
                                                {/* <button className='btn btn-warning btn-sm' data-bs-target="#exampleModal7" data-bs-toggle="modal" >Change Password</button> */}





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
                {/* EMPLOYEE PROFILE  END */}


                {/* open Particular Data Start */}



                {/* open Particular Data End */}




            </div>



        </div>
    )
}

export default Employeees