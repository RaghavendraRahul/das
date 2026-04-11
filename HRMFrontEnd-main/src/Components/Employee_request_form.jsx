import React, { useContext, useEffect, useState } from 'react'
import Empsidebar from './Empsidebar';

import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import { HrmStore } from '../Context/HrmContext';
import { Transition } from 'react-d3-speedometer';
import InputFieldform from './SettingComponent/InputFieldform';
import { toast } from 'react-toastify';
import DownArrow from '../SVG/DownArrow';
import { useNavigate, useParams } from 'react-router-dom';
import { Modal } from 'react-bootstrap';



const Employee_request_form = ({ setActiveSection }) => {

    let Profile_Info = JSON.parse(sessionStorage.getItem('Login_Profile_Information'))
    let [loading, setLoading] = useState()
    let [allEmployee, setAllEmployee] = useState()
    let [showModal, setShowModal] = useState()
    let { id } = useParams()
    let status = JSON.parse(sessionStorage.getItem('user')).Disgnation

    let [formObj, setFormObj] = useState({

        Applied_On: null,
        Date_Of_Interview: null,
        HR_manager_name: null,
        Interviewer: null,
        additional_feedback: null,
        department: null,
        employee_id: null,
        hr_remarks: null,
        hr_verified_On: null,
        improve_welfare: null,
        is_hr_verified: false,
        is_rm_verified: false,
        liked_most: null,
        name: null,
        position: null,
        reason: null,
        reason_for_leaving: null,
        rejoin_interest: null,
        remarks: null,
        reporting_manager_name: null,
        resignation_verification: null,
        resigned_letter_file: null,
        rm_remarks: null,
        rm_verified_On: null,
        separation_type: null
    })

    let getParticularRequest = () => {
        axios.get(`${port}/root/ems/ResignationRequest?sep_id=${id}`).then((response) => {
            console.log(response.data, "particularResignation");
            setFormObj(response.data)
        }).catch((error) => {
            console.log(error, 'particularResignation');
        })
    }
    let getAllEmployeeList = () => {
        let dasid = JSON.parse(sessionStorage.getItem('dasid'))
        if (dasid) {
            axios.get(`${port}/root/ems/AllEmployeesList/${dasid}/`).then((response) => {
                setAllEmployee(response.data)
                console.log(response.data, 'allEmp');
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    const [interviewers2, setInterviewers2] = useState([]);
    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers2(e.data)
        })
        getAllEmployeeList()
        // sentparticularData()
    }, [])
    useEffect(() => {
        setActiveSection('request')
        if (id)
            getParticularRequest()
    }, [id])
    // EMPLOYEE RESIGNATION FORM  START
    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('Employee')
    }, [])

    let handleFormObj = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let reason_for_leaving = [
        { label: 'Career Growth/Better Opportunity', value: 'career_growth' },
        { label: 'Personal Reasons', value: 'personal_reasons' },
        { label: 'Health Issues', value: 'health_issues' },
        { label: 'Relocation', value: 'relocation' },
        { label: 'Pursuing Higher Education', value: 'higher_education' },
        { label: 'High Pay', value: 'high_pay' },
        { label: 'Death', value: 'Death' },
        { label: 'Retirement', value: 'retirement' },
        { label: 'Dismissed', value: 'Dismissed' },
        { label: 'Layoff/Company Downsizing', value: 'layoff' },
        { label: 'Performance Issues', value: 'performance' },
        { label: 'End of Contract', value: 'contract_end' },
        { label: 'Misconduct', value: 'misconduct' },
        { label: 'Job Dissatisfaction', value: 'job_dissatisfaction' },
    ]
    let separation_type = [
        { label: 'Voluntary', value: 'voluntary' },
        { label: 'Involuntary', value: 'involuntary' },

    ]
    const [Reason, setReason] = useState('');
    const [HRmanager, setHRmanager] = useState('');
    const [resigned_letter_file, setresigned_letter_file] = useState(null);
    const [Confirm_resignation, setConfirm_resignation] = useState(false);

    const handle_employee_Resignation_info = (e) => {
        e.preventDefault()
        setLoading(true)

        console.log(formObj, 'all')
        // return
        const formData1 = new FormData()
        formData1.append('employee_id', formObj.employee_id);
        formData1.append('name', formObj.name);
        formData1.append('position', formObj.position);
        formData1.append('reporting_manager_name', formObj.reporting_manager_name);
        formData1.append('HR_manager_name', formObj.HR_manager_name);
        if (resigned_letter_file)
            formData1.append('resigned_letter_file', resigned_letter_file);
        formData1.append('Confirm_resignation', Confirm_resignation);
        formData1.append('reason_for_leaving', formObj.reason_for_leaving)
        formData1.append('separation_type', formObj.separation_type)
        formData1.append('reason', formObj.reason)
        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}root/ems/ResignationRequest`, formData1).then((res) => {
            console.log("EMPLOYEE_RESIGNATION_FORM_RES", res.data);
            setLoading(false)
            toast.success('Request sended')
            setFormObj({
                employee_id: Profile_Info.employee_Id,
                name: Profile_Info.full_name,
                position: Profile_Info.Position,
                separtion_type: '',
                reason_for_leaving: '',
                reason: ''
            })
        }).catch((err) => {
            setLoading(false)
            toast.error('Error Acquired')
            console.log("EMPLOYEE_RESIGNATION_FORM_ERR", err.data);

        })

    }
    //  EMPLOYEE RESIGNATION FORM  END

    // HR Manager Start

    const [interviewers, setinterviewers] = useState([])

    useEffect(() => {
        getResignApplication()
        axios.get(`${port}/root/ems/HRList`).then((res) => {
            console.log("HrManager", res.data);
            setinterviewers(res.data)
        }).catch((error) => console.log(error))
    }, [])
    // HR Manager End
    let getResignApplication = () => {
        axios.get(`${port}/root/ems/ResignationRequest?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, 'resignation');
        }).catch((error) => {
            console.log(error);
        })
    }
    let navigate = useNavigate()
    useEffect(() => {
        if (Profile_Info && !id) {
            setFormObj((prev) => ({
                ...prev,
                employee_id: Profile_Info.employee_Id,
                name: Profile_Info.full_name,
                position: Profile_Info.Position,
                reporting_manager_name: Profile_Info.RepotringTo_Id
            }))
        }
    }, [Profile_Info.employee_Id])
    return (
        <div>
            <article className='flex justify-between ' >
                <button onClick={() => navigate('/employees/Employee_request_form')} className='rounded bg-black text-white p-2 text-sm px-3 ' >
                    Back
                </button>
                {!id && <a href='../assets/Images/exit_interview.pdf' download={"interview.pdf"} className='rounded bg-blue-700 text-white p-2 text-sm px-3 ' >
                    Download Template
                </a>}

            </article>
            <Modal className='' show={showModal} centered
                onHide={() => setShowModal(false)} >
                <Modal.Header closeButton >
                    All Employee List
                </Modal.Header>
                <Modal.Body>
                    <div>
                        <label htmlFor="">Select employee : </label>
                        <select name="" id="" onChange={(e) => {
                            let findEmp = allEmployee.find((obj, index) => obj.employee_Id == e.target.value)
                            console.log({
                                name: findEmp.full_name,
                                position: findEmp.Designation,
                                employee_id: findEmp.employee_Id,
                                reporting_manager_name: findEmp.Reporting_To
                            }, 'allemp');

                            setFormObj((prev) => ({
                                ...prev,
                                name: findEmp.full_name,
                                position: findEmp.Designation,
                                employee_id: findEmp.employee_Id,
                                reporting_manager_name: findEmp.Reporting_To
                            }))
                            setShowModal(false)
                        }} className='p-2 outline-none inputbg rounded mx-2 px-3 ' >
                            <option value="">Select </option>
                            {
                                allEmployee && allEmployee.map((obj, index) => (
                                    <option value={obj.employee_Id}>
                                        {obj.full_name} ({obj.employee_Id}) </option>
                                ))
                            }
                        </select>

                    </div>
                </Modal.Body>
            </Modal>

            {/* EMPLOYEE RESIGNATION FORM START */}
            <div className=' my-3 ' >
                {/* Form start */}
                <div className="row justify-content-center inputbg p-3 rounded m-0 ">
                    <section className='flex items-center justify-between ' >
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EMPLOYEE RESIGNATION FORM </h5>
                        {(status == 'Admin' || status == 'HR') && <button onClick={() => setShowModal(true)}
                            className='bg-blue-700 text-white rounded p-2 px-3  text-sm ' >
                            Apply for others
                        </button>}
                    </section>
                    <div className="col-lg-12 p-4 mt-4 bg-white rounded-lg ">
                        <div className="row m-0 pb-2">
                            <InputFieldform label="Employee Id" value={formObj.employee_id} disabled type='text' />
                            <InputFieldform label="Employee Name" value={formObj.name} disabled type='text' />
                            <InputFieldform label="Designation" value={formObj.position} disabled />
                            {/* <InputFieldform label="Reporting manager"
                                value={
                                    allEmployee && formObj && console.log(formObj.reporting_manager_name, 'allemp') &&
                                    allEmployee.find((obj, index) => obj.employee_Id == formObj.reporting_manager_name) &&
                                    allEmployee.find((obj, index) => obj.employee_Id == formObj.reporting_manager_name).full_name
                                } disabled /> */}

                            {/*  */}
                            <div class="col-md-6 col-lg-4 mb-3">
                                <label for="interviewer">HR Manager <span className='text-red-500 ' >* </span> </label>
                                <select id="interviewer" name="HR_manager_name" value={formObj.HR_manager_name} onChange={handleFormObj}
                                    className='p-2 block my-2 rounded inputbg w-full outline-none shadow-none'  >
                                    <option value="" selected>Select Name</option>
                                    {interviewers2 && interviewers2.map(interviewer => (
                                        <option key={interviewer.EmployeeId}
                                            value={interviewer.EmployeeId}>
                                            {`${interviewer.EmployeeId},${interviewer.Name}`}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <InputFieldform label="Separation Type" required value={formObj.separation_type} name='separation_type' handleChange={handleFormObj}
                                optionObj={separation_type} />
                            <InputFieldform label="Reason For Resignation" value={formObj.reason_for_leaving}
                                name='reason_for_leaving' handleChange={handleFormObj}
                                optionObj={reason_for_leaving} />
                            <div className="col-md-6 col-lg-4 mb-3">
                                <label htmlFor="secondaryContact" className="form-label flex justify-between items-center "> Resignation letter
                                    {id && formObj.resigned_letter_file && <a target='_blank' href={formObj.resigned_letter_file} className='    text-sm '>
                                        Click here </a>}
                                </label>
                                <input type="file" className="form-control shadow-none" onChange={(e) => setresigned_letter_file(e.target.files[0])} id="SecondaryContact" name="SecondaryContact" />
                            </div>
                            <InputFieldform label="Detailed Reason" value={formObj.reason} name='reason' handleChange={handleFormObj} type='textarea' />
                            {/*  */}
                            {
                                id && <div className='row m-0 p-0 ' >
                                    {/* To show the data */}
                                    <InputFieldform label="Date of Application " value={formObj.Applied_On} disabled />
                                    <InputFieldform label="HR Manager Verification" disabled value={formObj.is_hr_verified ? "Verified" : 'Not Verified Yet'} />
                                    <InputFieldform label="Reporting Manager Verification" disabled value={formObj.is_rm_verified ? "Verified" : 'Not Verified Yet'} />
                                    <InputFieldform label="HR Manager Report" type="textarea" disabled value={formObj.hr_remarks ? formObj.hr_remarks : 'Not Verified Yet'} />

                                    <InputFieldform label="Reporting Manager Report" type="textarea" disabled value={formObj.rm_remarks ? formObj.rm_remarks : 'Not Verified Yet'} />
                                    <InputFieldform label="Remarks" type="textarea" disabled value={formObj.remarks ? formObj.remarks : 'Not Verified Yet'} />
                                    <InputFieldform label="Exit Interview date" value={formObj.Date_Of_Interview} disabled />
                                    <div className='col-md-6 col-lg-4 ' >
                                        <label htmlFor="">Interviewer  </label>
                                        <select name="Assigned Interviewer" onChange={handleFormObj}
                                            value={formObj.Interviewer} id=""
                                            className='inputbg rounded block w-full p-2 my-2 outline-none ' >
                                            <option value="">Select </option>
                                            {interviewers && interviewers.map(interviewer => (
                                                <option key={interviewer.EmployeeId} value={interviewer.id}>
                                                    {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                </option>
                                            ))}
                                        </select>

                                    </div>


                                </div>
                            }




                            {/* <div className="col-md-6 col-lg-4 mb-3 mt-4 pt-3">
                                            <input type="checkbox" className=" shadow-none" value={Confirm_resignation} onChange={(e) => {
                                                setConfirm_resignation(!Confirm_resignation)
                                            }} id="State" name="State" />
                                            <label htmlFor="secondaryContact" className="form-label ms-4">Confirm resignation</label>
                                        </div> */}


                        </div>
                    </div>
                </div>
                {/* form end */}
                {/* Button start */}
                <div class=" d-flex justify-content-end mt-2">

                    <div className='d-flex gap-2'>


                        {!id && <button type="button" disabled={loading} class="btn btn-success btn-sm" onClick={handle_employee_Resignation_info} >
                            {loading ? 'Loading...' : "Submit"}
                        </button>}
                        {id && <button type="button" disabled={loading}
                            class="btn btn-success btn-sm" onClick={handle_employee_Resignation_info} >
                            {loading ? 'Loading...' : "Update"}
                        </button>}
                    </div>
                </div>
                {/* Button end */}
            </div>
            {/* EMPLOYEE RESIGNATION FORM  END */}





        </div >
    )
}

export default Employee_request_form