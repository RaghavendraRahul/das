import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'
import CreateDepartment from './CreateDepartment'
import CreateDesignation from './CreateDesignation'
import EmployeeSalaryAdding from './EmployeeSalaryAdding'
import { HrmStore } from '../../Context/HrmContext'
import CloseIcon2 from '../../SVG/CloseIcon2'
import CreateEmployeeShift from './CreateEmployeeShift'

const EmployeeCreation = (props) => {
    let { id, show, setshow, getEmp, religion, setShowReligion } = props
    let { calculateAge } = useContext(HrmStore)
    let [loading, setloading] = useState(false)
    let [page, setPage] = useState('Info')
    let [createDesignation, setCreatedesignation] = useState(false)
    let [addressChecked, setAddressChecked] = useState(false)
    let [obj, setobj] = useState({
        salutation: null,
        full_name: null,
        last_name: null,
        date_of_birth: null,
        age: null,
        gender: null,
        email: null,
        secondary_email: '',
        mobile: null,
        secondary_mobile_number: '',
        weight: null,
        EmployeeShifts: '',
        Designation: '',
        height: null,
        employee_attendance_id: null,
        hired_date: null,
        present_address: null,
        present_City: null,
        present_state: null,
        present_pincode: null,

        permanent_address: null,
        permanent_City: null,
        permanent_state: null,
        permanent_pincode: null,


        Dasboard_Dig: null,
        Department_id: null,
        religion: null,
        Designation: null,
        Reporting_To: null,
        'Employeement_Type': null,
        'internship_Duration_From': null,
        'internship_Duration_To': null,
        'probation_status': null,
        'probation_Duration_From': null,
        'probation_Duration_To': null,
        interview_shedule_access: null,
        screening_shedule_access: null,
        final_status_access: null,
        applied_list_access: null
    })
    let [errors, setErrors] = useState({})
    let requiredFields = ['full_name', 'salutation', 'present_City', 'present_state', 'present_pincode',
        'date_of_birth', 'present_address', 'hired_date', 'Department_id', 'Employeement_Type', 'Reporting_To',
        'mobile', 'gender', 'email', 'employee_attendance_id', 'Designation', 'Dasboard_Dig']
    let fieldStyles = {
        full_name: { name: 'First Name', css: '', type: '', show: true, inputcss: '', },
        last_name: { name: 'Last Name', css: '', type: '', show: true, inputcss: '', },

        salutation: { name: 'Salutation', css: '', type: '', show: true, inputcss: '', options: [{ name: 'Mrs', value: 'Mrs.' }, { name: 'Mr', value: 'Mr.' }, { name: 'Miss', value: 'Miss.' },] },
        date_of_birth: { name: 'Date of Birth', css: '', type: 'date', show: true, inputcss: '', },
        age: { name: 'Age', css: '', type: '', show: true, inputcss: '', disabled: true },
        gender: { name: 'Gender', css: '', type: '', show: true, inputcss: '', options: [{ name: 'Male', value: 'male' }, { value: 'female', name: 'Female' }, { name: 'Other', value: 'other' },] },
        email: { name: 'Personal Email ID', css: '', type: '', show: true, inputcss: '', },
        mobile: { name: 'Personal Mobile Number', css: '', type: 'number', show: true, inputcss: '', },
        weight: { name: 'Wieght', css: '', type: '', show: false, inputcss: '', },
        EmployeeShifts: { name: '', css: '', type: '', show: false, inputcss: '', },
        secondary_mobile_number: { name: 'Alternative Contact Number', css: '', type: '', show: true, inputcss: '', },
        height: { name: 'Height', css: '', type: '', show: false, inputcss: '', },
        employee_attendance_id: { name: 'Attendance ID', css: '', type: '', show: true, inputcss: '', },
        permanent_address: { name: 'Permanent Address Line 1 ', spl: 'address', css: '', type: '', show: true, inputcss: '', },
        permanent_City: { name: 'City', css: '', type: '', show: true, inputcss: '', },
        permanent_state: { name: 'State', css: '', type: '', show: true, inputcss: '', },
        permanent_pincode: { name: 'Pincode ', css: '', limit: '999999', type: '', show: true, inputcss: '', },
        present_address: { name: 'Present Address Line 1 ', css: '', type: '', show: true, inputcss: '', },
        present_City: { name: 'City', css: '', type: '', show: true, inputcss: '', },
        present_state: { name: 'State', css: '', type: '', show: true, inputcss: '', },
        present_pincode: { name: 'Pincode ', css: '', limit: '999999', type: '', show: true, inputcss: '', },
        secondary_email: { name: 'Official Email ID', css: '', type: '', show: true, inputcss: '', },
        hired_date: { name: 'Date of Joining / Hire Date', css: '', type: 'date', show: true, inputcss: '', },
        Dasboard_Dig: {
            name: 'Role', css: '', type: '', show: true, inputcss: '',
            options: [{ value: "HR", name: "HR head" },
            { value: "Admin", name: "Admin" },
            { value: "Employee", name: "Employee" },
            { value: "Recruiter", name: "Recruiter" },]
        },
        Department_id: { name: '', css: '', type: '', show: false, inputcss: '', },
        religion: { name: '', css: '', type: '', show: false, inputcss: '', },
        Designation: { name: '', css: '', type: '', show: false, inputcss: '', },
        Reporting_To: { name: '', css: '', type: '', show: false, inputcss: '', },
        'Employeement_Type': {
            name: 'Employment Type', css: '', type: '',
            options: [{ value: "intern", name: "Intern" },
            { value: "permanent", name: "Permanent" },
            { value: "Trainee", name: "Student Intern" },
            { value: "Consultant", name: "Consultant" },

            ], show: true, inputcss: '',
        },
        'internship_Duration_From': { name: '', css: '', type: '', show: false, inputcss: '', },
        'internship_Duration_To': { name: '', css: '', type: '', show: false, inputcss: '', },
        'probation_status': { name: '', css: '', type: '', show: false, inputcss: '', },
        'probation_Duration_From': { name: '', css: '', type: '', show: false, inputcss: '', },
        'probation_Duration_To': { name: '', css: '', type: '', show: false, inputcss: '', },
        interview_shedule_access: { name: '', css: '', type: '', show: false, inputcss: '', },
        screening_shedule_access: { name: '', css: '', type: '', show: false, inputcss: '', },
        final_status_access: { name: '', css: '', type: '', show: false, inputcss: '', },
        applied_list_access: { name: '', css: '', type: '', show: false, inputcss: '', }
    }
    let validateForm = () => {
        const newErrors = {}
        requiredFields.forEach((field) => {
            if (!obj[field]?.trim()) {
                newErrors[field] = `*This field Required`
            }
        });
        console.log(newErrors);
        setErrors(newErrors)
        return Object.keys(newErrors).length == 0
    }
    let { allShiftTiming, convertTo12Hour, getAllShiftTiming } = useContext(HrmStore)
    let [createDepartmentModal, setCreateDepartmentModal] = useState(false)
    const fieldMappings = {
        permanent_address: "present_address",
        present_address: "permanent_address",
        permanent_City: "present_City",
        present_City: "permanent_City",
        present_pincode: "permanent_pincode",
        permanent_pincode: "present_pincode",
        present_state: "permanent_state",
        permanent_state: "present_state",
    };
    let generateAge = (date) => {
        let today = new Date()
        let dob = new Date(date)
        let age = today.getFullYear() - dob.getFullYear();
        let monthDiff = today.getMonth() - dob.getMonth();
        // Adjust if birthday hasn't occurred yet this year
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
            age--;
        }
        return age;
    }
    let handleChange = (e) => {
        let { name, value } = e.target
        if (name == 'date_of_birth') {
            let age = generateAge(value)
            setobj((prev) => ({
                ...prev,
                age: age
            }))
        }
        if (addressChecked && fieldMappings[name]) {
            setobj((prev) => ({
                ...prev,
                [name]: value,
                [fieldMappings[name]]: value,
            }));
            return;
        }
        if (name == 'Employeement_Type' && value == 'intern') {
            setobj((prev) => ({
                ...prev,
                probation_status: null,
                probation_Duration_From: null,
                probation_Duration_To: null
            }))
        }
        if (name == 'Employeement_Type' && value == 'permanent') {
            setobj((prev) => ({
                ...prev,
                internship_Duration_From: null,
                internship_Duration_To: null,
            }))
        }
        if (name == 'internship_Duration_From' && value > obj.internship_Duration_To
            && obj.internship_Duration_To != null) {
            setobj((prev) => ({
                ...prev,
                internship_Duration_From: obj.internship_Duration_To
            }))
            return
        }
        if (name == 'internship_Duration_To' && value < obj.internship_Duration_From) {
            setobj((prev) => ({
                ...prev,
                internship_Duration_To: obj.internship_Duration_From
            }))
            return
        }
        if (name == 'probation_Duration_From' && value > obj.probation_Duration_To &&
            obj.probation_Duration_To != null) {
            setobj((prev) => ({
                ...prev,
                probation_Duration_From: obj.probation_Duration_To
            }))
            return
        }
        if (name == 'probation_Duration_To' && value < obj.probation_Duration_From) {
            setobj((prev) => ({
                ...prev,
                probation_Duration_To: obj.probation_Duration_From
            }))
            return
        }
        setobj((prev) => ({
            ...prev,
            [name]: value
        }))
        if (errors[name]) {
            setErrors({ ...errors, [name]: undefined });
        }
    }
    let reset = () => {
        setobj({
            salutation: null,
            full_name: null,
            last_name: null,
            date_of_birth: null,
            age: null,
            gender: null,
            email: null,
            secondary_email: '',
            mobile: null,
            secondary_mobile_number: '',
            weight: null,
            EmployeeShifts: '',
            Designation: '',
            height: null,
            employee_attendance_id: null,
            hired_date: null,
            present_address: null,
            present_City: null,
            present_state: null,
            present_pincode: null,

            permanent_address: null,
            permanent_City: null,
            permanent_state: null,
            permanent_pincode: null,


            Dasboard_Dig: null,
            Department_id: null,
            religion: null,
            Designation: null,
            Reporting_To: null,
            'Employeement_Type': null,
            'internship_Duration_From': null,
            'internship_Duration_To': null,
            'probation_status': null,
            'probation_Duration_From': null,
            'probation_Duration_To': null,
            interview_shedule_access: null,
            screening_shedule_access: null,
            final_status_access: null,
            applied_list_access: null
        })
    }
    const [Department_List, set_Department_List] = useState([]);
    const [Desgination_List, set_Desgination_List] = useState([]);
    let Add_Employee = async (e) => {
        console.log({
            applied_list_access: obj.applied_list_access ? "true" : 'false',
            screening_shedule_access: obj.screening_shedule_access ? "true" : 'false',
            interview_shedule_access: obj.interview_schedule_access ? "true" : 'false',
            final_status_access: obj.final_status_access ? "true" : 'false',
        });
        if (id)
            Update_Employee()
        setloading(true)
        if (validateForm())
            await axios.post(`${port}root/ems/NewEmployeesAdding/`, {
                ...obj,
                applied_list_access: obj.applied_list_access ? "true" : 'false',
                screening_shedule_access: obj.screening_shedule_access ? "true" : 'false',
                interview_shedule_access: obj.interview_schedule_access ? "true" : 'false',
                final_status_access: obj.final_status_access ? "true" : 'false',
            }).then((r) => {
                toast.success('Employee Added')
                console.log("NewEmployeesAdding_res.", r.data)
                getEmp()
                reset()
                setobj(r.data)
                setloading(false)
                setPage('sal')
            })
                .catch((err) => {
                    if (err.response?.data?.error)
                        toast.warning(err.response?.data?.error)
                    else
                        toast.error('Employee Adding Failed.')
                    console.log("NewEmployeesAdding_err", err)
                    setloading(false)
                })
        setloading(false)
    }

    let getDesignation = () => {
        axios.get(`${port}root/ems/Departments/`)
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
    const [interviewers, setInterviewers] = useState([]);

    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        })
        // sentparticularData()
        getAllShiftTiming()
    }, [show])
    useEffect(() => {
        getDesignation()
    }, [show])
    let getEmployeeData = (ide) => {
        axios.get(`${port}/root/ems/Get-Employee/${ide}/`).then((e) => {
            setobj(e.data)
            // console.log('Update_Data', e.data.Department_id);
            console.log('Update_Data', e.data);

            Call_Department(e.data.Department_id)
            console.log("Employee_Data", e.data);
        }).catch((err) => {
            console.log("Employee_Data_err", err.data);
        })
    }
    // useEffect(() => {
    //     if (id) {
    //         getEmployeeData(id)
    //     }
    // }, [id])
    let Update_Employee = () => {
        setloading('edit')
        axios.patch(`${port}root/ems/Employee-Update/${id}/`, {
            Update_Data: {
                ...obj,
                "Department": obj.Department_id,
                "Position": obj.Designation
            }
        }).then((r) => {
            console.log("Update_Data", r.data)
            toast.success('User Updated successfully')
            setPage('sal')
        }).catch((err) => {
            console.log("Update_Data", err)
            setloading(null)

        })
    }
    return (
        <div>
            <Modal className=' ' centered size='xl' show={show}
            >
                <Modal.Header >
                    <button onClick={() => { setshow(false); reset() }}
                        className='flex border-3 ms-auto rounded p-2  ' >
                        <CloseIcon2 />
                    </button>
                </Modal.Header>
                <Modal.Body>

                    <h3 className='mt-2 text-center p-3' style={{ color: 'rgb(76,53,117)' }}>Enter Employee Information</h3>
                    {/* Form start */}
                    {page == 'Info' &&
                        <div className="row justify-content-center m-0">

                            <div className="col-lg-12 p-4 mt-2 h-[60vh] overflow-y-scroll table-responsive border rounded-lg">
                                <form >
                                    {/* ---------------------------------PERSONAL DETAILS--------------------------------------------------------- */}
                                    <div className="row m-0  pb-2">
                                        <div className='row m-0 mt-2'>
                                            {/* New Fields */}
                                            {
                                                Object.keys(obj).map((field) => {
                                                    let inputobj = fieldStyles[field]
                                                    return (
                                                        inputobj && inputobj.show &&
                                                        <div className={` ${inputobj.css ? inputobj.css : 'col-lg-6'}  my-2 `} >
                                                            <div className={`  `} >
                                                                <article className={` flex gap-2 items-center `} >

                                                                    <label htmlFor="" className={`text-slate-500 `} >
                                                                        {inputobj.name}
                                                                        {requiredFields.find((val) => val == field) &&
                                                                            <span className='text-red-600 text-xs mx-2 ' >
                                                                                {errors[field] ? errors[field] : "*"}
                                                                            </span>}
                                                                    </label>
                                                                    {
                                                                        inputobj.spl == 'address' &&
                                                                        <div className='text-xs flex items-center gap-1 ' >
                                                                            <input type="checkbox" id='addressmark' onChange={(e) => {
                                                                                if (e.target.checked) {
                                                                                    setAddressChecked(true)
                                                                                    setobj((prev) => ({
                                                                                        ...prev,
                                                                                        permanent_address: prev.present_address,
                                                                                        permanent_City: prev.present_City,
                                                                                        permanent_pincode: prev.present_pincode,
                                                                                        permanent_state: prev.present_state
                                                                                    }))
                                                                                }
                                                                                else {
                                                                                    setAddressChecked(false)
                                                                                    setobj((prev) => ({
                                                                                        ...prev,
                                                                                        permanent_address: '',
                                                                                        permanent_City: '',
                                                                                        permanent_pincode: '',
                                                                                        permanent_state: ''
                                                                                    }))
                                                                                }
                                                                            }} />
                                                                            <label htmlFor="addressmark"> Same as Present Address </label>
                                                                        </div>
                                                                    }
                                                                </article>

                                                                {inputobj.type == 'textarea' ?
                                                                    <textarea name={field} value={obj[field]} onChange={handleChange}
                                                                        className={` ${inputobj.inputcss ? inputobj.inputcss : ''}
                                                                             outline-none block w-full my-1 inputbg p-2 rounded `}
                                                                        id=""></textarea>
                                                                    : inputobj.options ?
                                                                        <select name={field} value={obj[field]}
                                                                            className={` ${inputobj.inputcss ? inputobj.inputcss : ''}
                                                                             outline-none block w-full my-1 inputbg p-2 rounded `}
                                                                            onChange={handleChange} id="">
                                                                            <option value="">Select</option>
                                                                            {inputobj.options.map((inoption) => (
                                                                                <option value={inoption.value}> {inoption.name} </option>
                                                                            ))}
                                                                        </select> :
                                                                        <input disabled={inputobj.disabled} type={inputobj.type ? inputobj.type : "text"}
                                                                            className={` ${inputobj.inputcss ? inputobj.inputcss : ''}
                                                                        outline-none block w-full my-1 inputbg p-2 rounded `}
                                                                            value={obj[field]} name={field} onChange={(e) => {
                                                                                if (inputobj.limit) {
                                                                                    if (e.target.value <= Number(inputobj.limit))
                                                                                        handleChange(e)
                                                                                } else
                                                                                    handleChange(e)
                                                                            }} />
                                                                }
                                                            </div>
                                                        </div>
                                                    )
                                                })
                                            }

                                            {createDepartmentModal && <CreateDepartment getdept={getDesignation} setshow={setCreateDepartmentModal} show={createDepartmentModal} />}
                                            {obj.Employeement_Type == 'intern' && <section className="col-md-6 mb-3">
                                                <label htmlFor="gender" className="text-slate-500 my-1">Intern Duration
                                                    <span class='text-danger'>{'*'} </span> </label>
                                                <div className='flex items-center justify-between ' >
                                                    <input type="date" value={obj.internship_Duration_From} name='internship_Duration_From'
                                                        onChange={handleChange} className='outline-none p-2 inputbg rounded border-1 ' /> -
                                                    <input type="date" value={obj.internship_Duration_To} name='internship_Duration_To'
                                                        onChange={handleChange} className='outline-none p-2 inputbg rounded border-1 ' />
                                                </div>
                                            </section>}
                                            {obj.Employeement_Type == 'permanent' &&
                                                <div className="col-md-6 mb-3">
                                                    <label htmlFor="gender" className="text-slate-500 my-1">Probation type <span class='text-danger'>*</span> </label>
                                                    <select value={obj.probation_status} onChange={handleChange}
                                                        className="outline-none block w-full my-1 inputbg p-2 rounded"
                                                        id="gender"
                                                        name="probation_status"
                                                        // Update gender state when the select input changes
                                                        required>
                                                        <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                                                        <option value="probationer">Probationer </option>
                                                        {/* <option value="confirmed"> Confirmed </option> */}
                                                    </select>
                                                </div>}
                                            {obj.probation_status == 'probationer' &&
                                                <section className="col-md-6 mb-3">
                                                    <label htmlFor="gender" className="text-slate-500 my-1">Probation Duration <span class='text-danger'>*</span> </label>
                                                    <div>
                                                        <input type="date" value={obj.probation_Duration_From} name='probation_Duration_From'
                                                            onChange={handleChange} className='outline-none p-2 inputbg rounded border-1 ' /> -
                                                        <input type="date" value={obj.probation_Duration_To} name='probation_Duration_To'
                                                            onChange={handleChange} className='outline-none p-2 inputbg rounded border-1 ' />
                                                    </div>
                                                </section>}
                                            <div className="col-md-6 mb-3">
                                                <div className='flex justify-between items-center'>
                                                    <label htmlFor="gender" className="text-slate-500 ">Department
                                                        <span class='text-danger text-sm mx-2 '>
                                                            {errors.Department_id ? errors.Department_id : '*'}
                                                        </span> </label>
                                                    <button type='button' onClick={() => setCreateDepartmentModal(true)} className='text-xs'>Create Department </button>
                                                </div>
                                                <select
                                                    className="outline-none block w-full my-1 inputbg p-2 rounded "
                                                    id="gender"
                                                    name="Department_id"
                                                    value={obj.Department_id} // Set the value of the select input to gender
                                                    onChange={(e) => {
                                                        handleChange(e);
                                                        Call_Department(e.target.value)
                                                    }} // Update gender state when the select input changes
                                                    required>
                                                    <option value="">Select  </option> {/* Empty value for the default option */}


                                                    {Department_List.map(interviewer => (
                                                        <option key={interviewer.id} value={interviewer.id}>
                                                            {`${interviewer.Dep_Name}`}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            {createDesignation && <CreateDesignation show={createDesignation} setshow={setCreatedesignation} />}
                                            <div className="col-md-6 mb-3">
                                                <label
                                                    htmlFor="gender"
                                                    className="flex justify-between text-slate-500">

                                                    Religion
                                                    <button
                                                        className="text-xs "
                                                        onClick={() => setShowReligion(true)} >
                                                        create Religion
                                                    </button>
                                                </label>
                                                <select
                                                    className="inputbg w-full outline-none p-2 rounded "
                                                    id="gender"
                                                    name="religion"
                                                    value={obj.religion}
                                                    onChange={handleChange}>
                                                    <option value="">
                                                        Select <span class="text-danger">*</span>{' '}
                                                    </option>{' '}
                                                    {/* Empty value for the default option */}
                                                    {religion &&
                                                        religion.map(interviewer => (
                                                            <option
                                                                key={interviewer.id}
                                                                value={interviewer.id}
                                                            >
                                                                {`${interviewer.religion_name}`}
                                                            </option>
                                                        ))}
                                                </select>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <div className='flex justify-between'>
                                                    <label htmlFor="gender" className=" text-slate-500 ">Designation
                                                        <span class='text-danger text-sm mx-2 ' >
                                                            {errors.Designation ? errors.Designation : '*'} </span>
                                                    </label>
                                                    <button onClick={() => setCreatedesignation(true)} className='text-xs '>create Designation </button>

                                                </div>
                                                <select
                                                    className="outline-none block w-full my-1 inputbg p-2 rounded "
                                                    id="gender"
                                                    name="Designation"
                                                    value={obj.Designation} // Set the value of the select input to gender
                                                    onChange={handleChange} // Update gender state when the select input changes
                                                    required>
                                                    <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                                                    {Desgination_List.map(interviewer => (
                                                        <option key={interviewer.id} value={interviewer.id}>
                                                            {`${interviewer.Name}`}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <div className='flex items-center justify-between ' >
                                                    <label
                                                        htmlFor="gender"
                                                        className="text-slate-500"
                                                    >
                                                        Shift Timing
                                                    </label>
                                                    <CreateEmployeeShift getData={getAllShiftTiming} />
                                                </div>
                                                <select
                                                    className="outline-none block w-full my-1 inputbg p-2 rounded "
                                                    id="EmployeeShifts"
                                                    name="EmployeeShifts"
                                                    value={obj.EmployeeShifts}
                                                    onChange={handleChange} // Set the value of the select input to gender
                                                // Update gender state when the select input changes
                                                >
                                                    <option value="">
                                                        Select {' '}
                                                    </option>{' '}
                                                    {/* Empty value for the default option */}
                                                    {allShiftTiming && allShiftTiming.map(interviewer => (
                                                        <option
                                                            key={interviewer.id}
                                                            value={interviewer.id}
                                                        >
                                                            {`${interviewer.Shift_Name}
                                                         (${interviewer.start_shift && convertTo12Hour(interviewer.start_shift)}-
                                                         ${interviewer.end_shift && convertTo12Hour(interviewer.end_shift)}) `}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <label htmlFor="gender" className=" text-slate-500  ">Reporting Manager Name
                                                    <span class='text-danger text-sm '> {errors.Reporting_To ? errors.Reporting_To : '*'}</span> </label>
                                                <select
                                                    className="outline-none block w-full my-1 inputbg p-2 rounded"
                                                    id="gender"
                                                    name="Reporting_To"
                                                    value={obj.Reporting_To} // Set the value of the select input to gender
                                                    onChange={handleChange} // Update gender state when the select input changes
                                                    required>
                                                    <option value="">Select </option> {/* Empty value for the default option */}
                                                    {interviewers.map(interviewer => (
                                                        <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                                            {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>




                                        </div>
                                    </div>
                                    {obj.Dasboard_Dig != 'Admin' && obj.Dasboard_Dig != 'HR' && <section>
                                        <h4>Permissions </h4>
                                        <article className='flex flex-wrap'>
                                            <div className='w-fit cursor-pointer col-md-6 mb-3 '>
                                                <input onChange={() => {
                                                    setobj((prev) => ({
                                                        ...prev,
                                                        interview_schedule_access: !prev.interview_schedule_access
                                                    }))
                                                }}
                                                    value={obj.interview_schedule_access} checked={obj.interview_schedule_access}
                                                    type="checkbox" id='AssignInterview' />
                                                <label className='mx-2 cursor-pointer' htmlFor="AssignInterview"> Assign Interview </label>
                                            </div>
                                            <div className='w-fit cursor-pointer col-md-6 mb-3 '>
                                                <input onChange={() => {
                                                    setobj((prev) => ({
                                                        ...prev,
                                                        screening_shedule_access: !prev.screening_shedule_access
                                                    }))
                                                }}
                                                    value={obj.screening_shedule_access} checked={obj.screening_shedule_access} type="checkbox" id='AssignScreening' />
                                                <label className='mx-2 cursor-pointer' htmlFor="AssignScreening"> Assign Screening </label>
                                            </div>
                                            <div className='w-fit cursor-pointer col-md-6 mb-3 '>
                                                <input onChange={() => {
                                                    setobj((prev) => ({
                                                        ...prev,
                                                        applied_list_access: !prev.applied_list_access
                                                    }))
                                                }}
                                                    value={obj.applied_list_access} checked={obj.applied_list_access} type="checkbox"
                                                    id='applied' />
                                                <label className='mx-2 cursor-pointer' htmlFor="applied">Applied list access  </label>
                                            </div>
                                            <div className='w-fit cursor-pointer col-md-6 mb-3 '>
                                                <input onChange={() => {
                                                    setobj((prev) => ({
                                                        ...prev,
                                                        final_status_access: !prev.final_status_access
                                                    }))
                                                }}
                                                    value={obj.final_status_access} checked={obj.final_status_access} type="checkbox" id='finalstatus' />
                                                <label className='mx-2 cursor-pointer' htmlFor="finalstatus">Final status access </label>
                                            </div>
                                        </article>

                                    </section>}




                                </form>
                            </div>
                            <div className="col-12 text-end mt-3">
                                <button type="button" disabled={loading} onClick={() => {
                                    Add_Employee()

                                }}
                                    //  data-bs-dismiss="modal"  
                                    className="btn btn-primary text-white fw-medium px-2 px-lg-5">
                                    {loading ? "Loading.." : "Next"}
                                </button>
                            </div>
                        </div>}
                    {page == 'sal' && <EmployeeSalaryAdding id={obj.id} emp={obj} setpage={setPage} />}


                </Modal.Body >
            </Modal >
        </div >
    )
}

export default EmployeeCreation