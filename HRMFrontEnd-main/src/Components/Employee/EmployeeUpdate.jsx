import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'
import AppraisalOffer from './AppraisalOffer'

const EmployeeUpdate = ({ sid, id, setshowtab, showTab }) => {
    let { religion } = useContext(HrmStore)
    const [Department_List, set_Department_List] = useState([]);
    const [Desgination_List, set_Desgination_List] = useState([]);
    const [Edit_Data, set_Edit_Data] = useState({
        full_name: '',
        date_of_birth: '',
        gender: '',
        email: '',
        mobile: '',
        weight: '',
        height: '',
        permanent_address: '',
        present_address: '',
        hired_date: '',
        Dashboard: '',
        Department_id: '',
        religion: '',
        Position_id: '',
        Reporting_To: '',
        'Employeement_Type': '',
        'internship_Duration_From': '',
        'internship_Duration_To': '',
        'probation_status': '',
        'probation_Duration_From': '',
        'probation_Duration_To': '',
        interview_shedule_access: '',
        screening_shedule_access: '',
        final_status_access: '',
        applied_list_access: ''

    })
    let getDepart = () => {
        axios.get(`${port}/root/ems/Departments/`)
            .then((r) => {
                set_Department_List(r.data)
                console.log("Departments_List_Res", r.data)
            })
            .catch((err) => {
                console.log("Departments_List_err", err)
            })
    }
    let Call_Department = (e) => {
        axios.get(`${port}/root/ems/Designation/${e}/`)
            .then((r) => {
                set_Desgination_List(r.data)
                console.log("Designation_List_Res", r.data)
            })
            .catch((err) => {
                console.log("Designation_List_err", err)
            })
    }
    useEffect(() => {
        getDepart()
    }, [])
    useEffect(() => {
        if (Edit_Data.Department_id) {
            Call_Department(Edit_Data.Department_id)
        }
    }, [Edit_Data.Department_id])

    // console.log("datas",Edit_Data);
    let handleChangeEdit_data = (e) => {
        let { name, value } = e.target
        // if (name == 'Employeement_Type' && value == 'intern') {
        //     set_Edit_Data((prev) => ({
        //         ...prev,
        //         probation_status: '',
        //         probation_Duration_From: '',
        //         probation_Duration_To: ''
        //     }))
        // }
        // if (name == 'Employeement_Type' && value == 'permanent') {
        //     set_Edit_Data((prev) => ({
        //         ...prev,
        //         internship_Duration_From: '',
        //         internship_Duration_To: '',
        //     }))
        // }
        if (name == 'internship_Duration_From' && value > Edit_Data.internship_Duration_To
            && Edit_Data.internship_Duration_To != '') {
            set_Edit_Data((prev) => ({
                ...prev,
                internship_Duration_From: Edit_Data.internship_Duration_To
            }))
            return
        }
        if (name == 'internship_Duration_To' && value < Edit_Data.internship_Duration_From) {
            set_Edit_Data((prev) => ({
                ...prev,
                internship_Duration_To: Edit_Data.internship_Duration_From
            }))
            return
        }
        if (name == 'probation_Duration_From' && value > Edit_Data.probation_Duration_To &&
            Edit_Data.probation_Duration_To != '') {
            set_Edit_Data((prev) => ({
                ...prev,
                probation_Duration_From: Edit_Data.probation_Duration_To
            }))
            return
        }
        if (name == 'probation_Duration_To' && value < Edit_Data.probation_Duration_From) {
            set_Edit_Data((prev) => ({
                ...prev,
                probation_Duration_To: Edit_Data.probation_Duration_From
            }))
            return
        }
        set_Edit_Data((prev) => ({
            ...prev,
            [name]: value
        }))
    }

    const [interviewers, setInterviewers] = useState([]);

    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        })
        // sentparticularData()
    }, [])
    let getEmployee = () => {

        console.log("adasdasd", id);
        if (id) {
            axios.get(`${port}/root/ems/Get-Employee/${id}/`).then((response) => {
                set_Edit_Data(response.data)
                console.log("hellow", response.data);
            }).catch((err) => {
                console.log("Employee_Data_err", err.data);
            })
        }
    }
    useEffect(() => {
        getEmployee()
    }, [id])
    let updateEmployee = () => {
        console.log("hellow-update ", Edit_Data);
        if (Edit_Data.emp_personal_info)
            axios.patch(`${port}/root/ems/update-employee-personal-information/${Edit_Data.emp_personal_info}/`, {
                religion: Edit_Data.religion
            }).then((response) => {
                console.log("hellow-reli", response.data);
            }).catch((error) => {
                console.log("hellow-reli", error);
            })
        else
            axios.post(`${port}/root/ems/employee-personal-information/${Edit_Data.id}/`, {
                religion: Edit_Data.religion
            }).then((response) => {
                console.log("hellow-post", response.data);
            }).catch((eror) => {
                console.log("hellow-post", eror)
            })
        // Second
        axios.patch(`${port}/root/ems/Employee-Update/${Edit_Data.id}/`, {
            Update_Data: {
                ...Edit_Data,
                "Department": Edit_Data.Department_id,
                "Position": Edit_Data.Position_id
            }
        }).then((response) => {
            console.log("hellow", response.data);
            toast.success('Update success')
            getEmployee()
        }).catch((error) => {
            console.log(error);
        })
    }
    return (
        <div className=' bg-white my-3 rounded p-4 container'>
            {showTab == 'EU' && <main>
                <h5>Employee Information </h5>
                <div className='row  mx-auto formbg p-4 rounded '>
                    <div className="col-md-6 col-lg-4  mb-3">
                        <label htmlFor="firstName" className="form-label">Name <span class='text-danger'>*</span> </label>
                        <input type="text" className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light" id="FirstName" name="full_name" value={Edit_Data.full_name} onChange={handleChangeEdit_data} />
                    </div>

                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label"> Religion  <span class='text-danger'>*</span> </label>
                        <select
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="religion"
                            value={Edit_Data.religion}
                            onChange={(e) => {
                                handleChangeEdit_data(e)
                            }}>
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            {religion && religion.map(interviewer => (
                                <option key={interviewer.id} value={interviewer.id}>
                                    {`${interviewer.religion_name}`}
                                </option>
                            ))}
                        </select>
                    </div>
                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label ">Role <span class='text-danger'>*</span> </label>
                        <select
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="Dashboard"
                            value={Edit_Data.Dashboard}
                            onChange={handleChangeEdit_data} // Set the value of the select input to gender
                        // Update gender state when the select input changes
                        >
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            <option value="HR">HR head</option>
                            <option value="Admin">Admin</option>
                            <option value="Employee">Employee</option>
                            <option value="Recruiter">Recruiter</option>
                        </select>
                    </div>

                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label">Department <span class='text-danger'>*</span> </label>
                        <select
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="Department_id"
                            value={Edit_Data.Department_id}
                            onChange={(e) => {
                                Call_Department(e.target.value)
                                handleChangeEdit_data(e)
                            }}
                        // Set the value of the select input to gender
                        // Update gender state when the select input changes
                        >
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            {Department_List.map((interviewer, index) => {
                                console.log("Update_Data", interviewer);
                                return (
                                    <option key={interviewer.id} value={interviewer.id}>
                                        {`${interviewer.Dep_Name}`}
                                    </option>
                                )
                            })}


                        </select>
                    </div>
                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label">Designation <span class='text-danger'>*</span> </label>
                        <select
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="Position_id"
                            value={Edit_Data.Position_id}
                            onChange={(e) => {
                                handleChangeEdit_data(e)
                            }}>
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            {Desgination_List.map(interviewer => (
                                <option key={interviewer.id} value={interviewer.id}>
                                    {`${interviewer.Name}`}
                                </option>
                            ))}
                        </select>
                    </div>

                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label ">Reporting To <span class='text-danger'>*</span> </label>
                        <select
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="Reporting_To"
                            value={Edit_Data.Reporting_To}
                            onChange={handleChangeEdit_data} // Set the value of the select input to gender
                        // Update gender state when the select input changes
                        >
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            {interviewers.map(interviewer => (
                                <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                    {`${interviewer.EmployeeId},${interviewer.Name}`}
                                </option>
                            ))}
                        </select>
                    </div>
                    <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label">Employeement type <span class='text-danger'>*</span> </label>
                        <select value={Edit_Data.Employeement_Type} onChange={handleChangeEdit_data}
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="Employeement_Type" // Update gender state when the select input changes
                            required>
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            <option value="intern">Intern </option>
                            <option value="permanent">Permanent </option>
                        </select>
                    </div>
                    {Edit_Data.Employeement_Type == 'intern' && <section className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label">Intern Duration <span class='text-danger'>*</span> </label>
                        <div className='flex items-center justify-between flex-wrap   text-sm'>
                            <input type="date" value={Edit_Data.internship_Duration_From} name='internship_Duration_From'
                                onChange={handleChangeEdit_data} className='outline-none bgclr p-2 bg-light rounded border-1 ' /> -
                            <input type="date" value={Edit_Data.internship_Duration_To} name='internship_Duration_To'
                                onChange={handleChangeEdit_data} className='outline-none  p-2 bg-light rounded border-1 ' />
                        </div>
                    </section>}
                    {Edit_Data.Employeement_Type == 'permanent' && <div className="col-md-6 col-lg-4 mb-3">
                        <label htmlFor="gender" className="form-label">Probation type <span class='text-danger'>*</span> </label>
                        <select value={Edit_Data.probation_status} onChange={handleChangeEdit_data}
                            className="p-2 bgclr rounded outline-none block w-full shadow-none bg-light"
                            id="gender"
                            name="probation_status"
                            // Update gender state when the select input changes
                            required>
                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                            <option value="probationer">Probationer </option>
                            <option value="confirmed"> Confirmed </option>
                        </select>
                    </div>}
                    {Edit_Data.probation_status == 'probationer' &&
                        <section className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="gender" className="form-label">Probation Duration <span class='text-danger'>*</span> </label>
                            <div className='flex items-center  flex-wrap justify-between  text-sm'>
                                <input type="date" value={Edit_Data.probation_Duration_From} name='probation_Duration_From'
                                    onChange={handleChangeEdit_data} className='outline-none p-2 bg-light rounded border-1 ' /> -
                                <input type="date" value={Edit_Data.probation_Duration_To} name='probation_Duration_To'
                                    onChange={handleChangeEdit_data} className='outline-none p-2 bg-light rounded border-1 ' />
                            </div>
                        </section>}

                </div>
                <h5 className='my-3 '>Permissions </h5>

                <section className='formbg my-3 p-4 rounded '>
                    <article className='flex flex-wrap  '>
                        <div className="col-md-6 col-lg-4 mb-3  flex items-center gap-2">
                            <input type="checkbox" className=''
                                checked={Edit_Data.interview_shedule_access} id='interview_shedule_access'
                                value={Edit_Data.interview_shedule_access}
                                onChange={() => set_Edit_Data((prev) => ({
                                    ...prev,
                                    interview_shedule_access: !prev.interview_shedule_access
                                }))} />
                            <label htmlFor="interview_shedule_access">
                                Interview shedule access
                            </label>
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3 flex items-center gap-2">
                            <input type="checkbox" className='' checked={Edit_Data.applied_list_access} id='applied_list_access'
                                value={Edit_Data.applied_list_access}
                                onChange={() => set_Edit_Data((prev) => ({
                                    ...prev,
                                    applied_list_access: !prev.applied_list_access
                                }))} />
                            <label htmlFor="applied_list_access">
                                Applied list access
                            </label>
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3 flex items-center gap-2">
                            <input type="checkbox" className='' checked={Edit_Data.final_status_access} id='final_status_access'
                                value={Edit_Data.final_status_access}
                                onChange={() => set_Edit_Data((prev) => ({
                                    ...prev,
                                    final_status_access: !prev.final_status_access
                                }))} />
                            <label htmlFor="final_status_access">
                                Final status access
                            </label>
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3 flex items-center gap-2">
                            <input type="checkbox" className='' checked={Edit_Data.screening_shedule_access} id='screening_shedule_access'
                                value={Edit_Data.screening_shedule_access}
                                onChange={() => set_Edit_Data((prev) => ({
                                    ...prev,
                                    screening_shedule_access: !prev.screening_shedule_access
                                }))} />
                            <label htmlFor="screening_shedule_access">
                                Screening shedule access
                            </label>
                        </div>
                    </article>

                </section>
                <section className='flex justify-between items-center '>
                    <button onClick={()=>setshowtab('MR')} className=' border-2 p-2 px-3 rounded border-violet-800 h-fit ' >
                        Previous
                    </button>
                    <button onClick={() => {
                        updateEmployee()
                        setshowtab('AO')
                    }} className='flex ms-auto btngrd text-white p-2 rounded '>
                        Next
                    </button>
                </section>
            </main>}

            {showTab == 'AO' && <AppraisalOffer setshowtab={setshowtab} obj={Edit_Data} id={id} sid={sid} />}
        </div >
    )
}

export default EmployeeUpdate