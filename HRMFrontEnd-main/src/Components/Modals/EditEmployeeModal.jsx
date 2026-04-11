import React, { useContext, useEffect } from 'react'
import { Modal } from 'react-bootstrap';
import PermissionCheckBox from '../MiniComponent/PermissionCheckBox';
import { HrmStore } from '../../Context/HrmContext';
import CreateEmployeeShift from './CreateEmployeeShift';

const EditEmployeeModal = ({ resetEditModal, setAddresschecked,
    handleChangeEdit_data, editModal, setShowDepartment, Department_List,
    interviewers, Update_Employee, loading, EmployeeSalaryAdding, setEditModalPage,
    editModalPage, set_Edit_Data, setShowReligion, Call_Department, Desgination_List, religion, Edit_Data }) => {
    let { allShiftTiming, convertTo12Hour, getAllShiftTiming } = useContext(HrmStore)
    let handlePermissionChanges = (name) => {
        set_Edit_Data(prev => ({
            ...prev,
            [name]:
                !prev[name],
        }))
    }
    useEffect(() => {
        getAllShiftTiming()
        console.log(Edit_Data, 'editobj');

    }, [])
    return (
        <div>
            <Modal
                show={editModal}
                centered
                size="xl"
                onHide={() => {
                    resetEditModal();
                }}>
                <Modal.Header closeButton>
                    <h3
                        className="poppins"
                        style={{ color: 'rgb(76,53,117)' }}
                    >
                        Update Employee Information{' '}
                    </h3>
                </Modal.Header>
                <Modal.Body>
                    <div className="row justify-content-center m-0">
                        {editModalPage == 'Info' && (
                            <div className=" h-[70vh] overflow-y-scroll scrollmade2 col-lg-12 p-4 mt-2 border rounded-lg">
                                {/* ---------------------------------PERSONAL DETAILS--------------------------------------------------------- */}
                                <div className="row m-0  pb-2">
                                    <div className="row m-0 mt-2">
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="salutation"
                                                className="text-slate-500"
                                            >
                                                Salutation
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="salutation"
                                                name="salutation"
                                                onChange={handleChangeEdit_data}
                                                value={Edit_Data.salutation} // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select
                                                </option>
                                                {/* Empty value for the default option */}
                                                <option value="Mr.">Mr</option>
                                                <option value="Mrs.">Mrs</option>
                                                <option value="Miss.">Miss</option>
                                            </select>
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="firstName" className="text-slate-500 "  >
                                                First Name <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded "
                                                id="FirstName" name="full_name" value={Edit_Data.full_name}
                                                onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="firstName" className="text-slate-500 "  >
                                                Last Name <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded "
                                                id="LastName" name="last_name" value={Edit_Data.last_name}
                                                onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="lastName"
                                                className="text-slate-500"
                                            >
                                                Date of Birth <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="date"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id=" LastName"
                                                name="date_of_birth"
                                                value={Edit_Data.date_of_birth}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="firstName"
                                                className="text-slate-500 ">

                                                Age <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="text"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="age"
                                                name="age"
                                                disabled
                                                value={Edit_Data.age}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500"
                                            >
                                                Gender <span class="text-danger">*</span>{' '}
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="gender"
                                                onChange={handleChangeEdit_data}
                                                value={Edit_Data.gender} // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select Gender <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                <option value="male">Male</option>
                                                <option value="female">Female</option>
                                                <option value="other">Other</option>
                                            </select>
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="email"
                                                className="text-slate-500"
                                            >
                                                Personal Email ID<span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="email"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id=" Email"
                                                name="email"
                                                value={Edit_Data.email}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="email"
                                                className="text-slate-500"
                                            >
                                                Official Email ID<span class="text-danger"></span>{' '}
                                            </label>
                                            <input
                                                type="email"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id=" Email"
                                                name="secondary_email"
                                                value={Edit_Data.secondary_email}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>

                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="primaryContact"
                                                className="text-slate-500"
                                            >
                                                Personal Mobile Number <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="tel"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="PrimaryContact"
                                                name="mobile"
                                                value={Edit_Data.mobile}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="primaryContact"
                                                className="text-slate-500"
                                            >
                                                Alternative Contact Number <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="tel"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="PrimaryContact"
                                                name="secondary_mobile_number"
                                                value={Edit_Data.secondary_mobile_number}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="email"
                                                className="text-slate-500"
                                            >
                                                Attendence Id <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="text"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id=" Email"
                                                name="employee_attendance_id"
                                                value={Edit_Data.employee_attendance_id}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        {/* Date of joining */}
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="secondaryContact"
                                                className="text-slate-500"
                                            >
                                                Date of Joining / Hire Date <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="date"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="State"
                                                name="hired_date"
                                                value={Edit_Data.hired_date}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div>
                                        {/* <div className="col-md-6 col-lg-2 mb-3">
                                            <label
                                                htmlFor="secondaryContact"
                                                className="text-slate-500"
                                            >
                                                Weight{' '}
                                            </label>
                                            <input
                                                type="number"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="SecondaryContact"
                                                name="weight"
                                                value={Edit_Data.weight}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div> */}
                                        {/* <div className="col-md-6 col-lg-2 mb-3">
                                            <label
                                                htmlFor="secondaryContact"
                                                className="text-slate-500"
                                            >
                                                Height <span class="text-danger">*</span>{' '}
                                            </label>
                                            <input
                                                type="number"
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="State"
                                                name="height"
                                                value={Edit_Data.height}
                                                onChange={handleChangeEdit_data}
                                            />
                                        </div> */}

                                        {/* Present Address */}
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                Present Address </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="present_address" value={Edit_Data.present_address} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                City </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="present_City" value={Edit_Data.present_City} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                State </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="present_state" value={Edit_Data.present_state} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                Pincode </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="present_pincode" value={Edit_Data.present_pincode} onChange={handleChangeEdit_data} />
                                        </div>
                                        {/*   present_City: null,
    present_state: null,
    present_pincode: null,
    permanent_City: null,
    permanent_state: null,
    permanent_pincode: null, */}
                                        {/* Permanent Address */}
                                        <div className="col-md-6 mb-3">
                                            <article className='flex items-center gap-2 ' >
                                                <label htmlFor="secondaryContact" className="text-slate-500"
                                                >Permanent Address
                                                </label>
                                                <div className='flex items-center gap-1 text-xs ' >
                                                    <input type="checkbox" className='' id='addresseditcom' onChange={(e) => {
                                                        if (e.target.checked) {
                                                            setAddresschecked(true)
                                                            set_Edit_Data((prev) => ({
                                                                ...prev,
                                                                permanent_address: prev.present_address,
                                                                permanent_City: prev.present_City,
                                                                permanent_pincode: prev.present_pincode,
                                                                permanent_state: prev.present_state
                                                            }))
                                                        } else {
                                                            setAddresschecked(false)
                                                            set_Edit_Data((prev) => ({
                                                                ...prev,
                                                                permanent_address: '',
                                                                permanent_City: '',
                                                                permanent_pincode: '',
                                                                permanent_state: ''
                                                            }))
                                                        }
                                                    }} />
                                                    <label htmlFor="addresseditcom"> Same as present address </label>
                                                </div>
                                            </article>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded "
                                                id=" District" name="permanent_address"
                                                value={Edit_Data.permanent_address} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                City </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="permanent_City" value={Edit_Data.permanent_City} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                State </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="permanent_state" value={Edit_Data.permanent_state} onChange={handleChangeEdit_data} />
                                        </div>
                                        <div className="col-md-6 mb-3">
                                            <label htmlFor="secondaryContact" className="text-slate-500">
                                                Pincode </label>
                                            <input type="text" className="inputbg w-full outline-none p-2 rounded " id=" District"
                                                name="permanent_pincode" value={Edit_Data.permanent_pincode} onChange={handleChangeEdit_data} />
                                        </div>
                                        {/* END */}
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500"
                                            >
                                                Role  <span class="text-danger">*</span>{' '}
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="Dashboard"
                                                value={Edit_Data.Dashboard}
                                                onChange={handleChangeEdit_data} // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                <option value="HR">HR head</option>
                                                <option value="Admin">Admin</option>
                                                <option value="Employee">Employee</option>
                                                <option value="Recruiter">Recruiter</option>
                                            </select>
                                        </div>
                                        <div className="col-md-6  mb-3">
                                            <label htmlFor="gender" className=" text-slate-500 ">
                                                Religion  <span class='text-danger'>*</span> </label>
                                            <select
                                                className=" inputbg w-full outline-none p-2 rounded "
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
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500"
                                            >
                                                Employeement type <span class="text-danger">*</span>{' '}
                                            </label>
                                            <select
                                                value={Edit_Data.Employeement_Type}
                                                onChange={handleChangeEdit_data}
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="Employeement_Type" // Update gender state when the select input changes
                                                required
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                <option value="intern">Intern </option>
                                                <option value="permanent">Permanent </option>
                                                <option value="Trainee">Student Intern </option>
                                                <option value="Consulant">Consultant </option>

                                            </select>
                                        </div>
                                        {Edit_Data.Employeement_Type == 'intern' && (
                                            <section className="col-md-6 mb-3">
                                                <label
                                                    htmlFor="gender"
                                                    className="text-slate-500"
                                                >
                                                    Intern Duration <span class="text-danger">*</span>{' '}
                                                </label>
                                                <div>
                                                    <input
                                                        type="date"
                                                        value={Edit_Data.internship_Duration_From}
                                                        name="internship_Duration_From"
                                                        onChange={handleChangeEdit_data}
                                                        className="outline-none p-2 bg-light rounded border-1 "
                                                    />{' '}
                                                    -
                                                    <input
                                                        type="date"
                                                        value={Edit_Data.internship_Duration_To}
                                                        name="internship_Duration_To"
                                                        onChange={handleChangeEdit_data}
                                                        className="outline-none p-2 bg-light rounded border-1 "
                                                    />
                                                </div>
                                            </section>
                                        )}
                                        {Edit_Data.Employeement_Type == 'permanent' && (
                                            <div className="col-md-6 mb-3">
                                                <label
                                                    htmlFor="gender"
                                                    className="text-slate-500"
                                                >
                                                    Probation type <span class="text-danger">*</span>{' '}
                                                </label>
                                                <select
                                                    value={Edit_Data.probation_status}
                                                    onChange={handleChangeEdit_data}
                                                    className="inputbg w-full outline-none p-2 rounded "
                                                    id="gender"
                                                    name="probation_status"
                                                    // Update gender state when the select input changes
                                                    required
                                                >
                                                    <option value="">
                                                        Select <span class="text-danger">*</span>{' '}
                                                    </option>{' '}
                                                    {/* Empty value for the default option */}
                                                    <option value="probationer">Probationer </option>
                                                    <option value="confirmed"> Confirmed </option>
                                                </select>
                                            </div>
                                        )}
                                        {Edit_Data.probation_status == 'probationer' && (
                                            <section className="col-md-6 mb-3">
                                                <label
                                                    htmlFor="gender"
                                                    className="text-slate-500"
                                                >
                                                    Probation Duration
                                                    <span class="text-danger">*</span>
                                                </label>
                                                <div>
                                                    <input
                                                        type="date"
                                                        value={Edit_Data.probation_Duration_From}
                                                        name="probation_Duration_From"
                                                        onChange={handleChangeEdit_data}
                                                        className="outline-none p-2 bg-light rounded border-1 "
                                                    />{' '}
                                                    -
                                                    <input
                                                        type="date"
                                                        value={Edit_Data.probation_Duration_To}
                                                        name="probation_Duration_To"
                                                        onChange={handleChangeEdit_data}
                                                        className="outline-none p-2 bg-light rounded border-1 "
                                                    />
                                                </div>
                                            </section>
                                        )}
                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500 flex justify-between "
                                            >
                                                Department
                                                <button
                                                    className="text-xs "
                                                    onClick={() => setShowDepartment(true)}
                                                >
                                                    Create Department{' '}
                                                </button>{' '}
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="Department_id"
                                                value={Edit_Data.Department_id}
                                                onChange={e => {
                                                    Call_Department(e.target.value);
                                                    handleChangeEdit_data(e);
                                                }}
                                            // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                {Department_List.map((interviewer, index) => {
                                                    console.log('Update_Data', interviewer);
                                                    return (
                                                        <option
                                                            key={interviewer.id}
                                                            value={interviewer.id}
                                                        >
                                                            {`${interviewer.Dep_Name}`}
                                                        </option>
                                                    );
                                                })}
                                            </select>
                                        </div>
                                        {console.log(Edit_Data)}

                                        <div className="col-md-6 mb-3">
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500"
                                            >
                                                Designation <span class="text-danger">*</span>{' '}
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="Position_id"
                                                value={Edit_Data.Position_id}
                                                onChange={e => {
                                                    handleChangeEdit_data(e);
                                                }}
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                {Desgination_List.map(interviewer => (
                                                    <option
                                                        key={interviewer.id}
                                                        value={interviewer.id}
                                                    >
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
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="EmployeeShifts"
                                                name="EmployeeShifts"
                                                value={Edit_Data.EmployeeShifts}
                                                onChange={handleChangeEdit_data} // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
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
                                            <label
                                                htmlFor="gender"
                                                className="text-slate-500"
                                            >
                                                Reporting Manager Name <span class="text-danger">*</span>{' '}
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="gender"
                                                name="Reporting_To"
                                                value={Edit_Data.Reporting_To}
                                                onChange={handleChangeEdit_data} // Set the value of the select input to gender
                                            // Update gender state when the select input changes
                                            >
                                                <option value="">
                                                    Select <span class="text-danger">*</span>{' '}
                                                </option>{' '}
                                                {/* Empty value for the default option */}
                                                {interviewers.map(interviewer => (
                                                    <option
                                                        key={interviewer.EmployeeId}
                                                        value={interviewer.EmployeeId}
                                                    >
                                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                    </option>
                                                ))}
                                            </select>
                                        </div>


                                        <section className='col-md-6 mb-3 ' >
                                            <label
                                                htmlFor="activestatus"
                                                className="text-slate-500" >
                                                Employee status
                                            </label>
                                            <select
                                                className="inputbg w-full outline-none p-2 rounded "
                                                id="employee_status"
                                                name="employee_status"
                                                value={Edit_Data.employee_status}
                                                onChange={handleChangeEdit_data}>
                                                <option value=""> Select </option>
                                                <option value="active"> Active </option>
                                                <option value="in_active"> InActive </option>
                                                <option value="Resigned"> Resigned </option>

                                            </select>
                                        </section>
                                    </div>

                                    <section>
                                        <h4 className='my-3 ' >Permissions </h4>

                                        <article className="row  ">
                                            <h6 className='my-2 ' > Recuirtment Process </h6>
                                            <PermissionCheckBox checked={Edit_Data.interview_shedule_access}
                                                label='Interview shedule access' name='interview_shedule_access'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.interview_shedule_access} />
                                            <PermissionCheckBox checked={Edit_Data.applied_list_access}
                                                label='Applied list access' name='applied_list_access'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.applied_list_access} />
                                            <PermissionCheckBox checked={Edit_Data.final_status_access}
                                                label=' Final status access' name='final_status_access'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.final_status_access} />
                                            <PermissionCheckBox checked={Edit_Data.screening_shedule_access}
                                                label='Screening shedule access' name='screening_shedule_access'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.screening_shedule_access} />
                                            <h6 className='my-2 ' > Employee Management </h6>
                                            {/*  
                                            all_employees_edit:'',
    all_employees_view:'',
    assign_leave_apply:'',
    assign_offerletter_prepare:'',
    assign_resignation_apply:'',
    attendance_upload:'',
    employee_personal_details_view:'',
    holiday_calender_creation:'',
    job_post:'',
    leave_create:"",
    leave_edit:'',
    massmail_communication:"",
    salary_component_creation:'',
    salary_template_creation:'',
    self_activity_add:'' */}
                                            <PermissionCheckBox checked={Edit_Data.all_employees_view}
                                                label='All Employee List View' name='all_employees_view'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.all_employees_view} />
                                            <PermissionCheckBox checked={Edit_Data.all_employees_edit}
                                                label='All Employee List Edit ' name='all_employees_edit'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.all_employees_edit} />

                                            <PermissionCheckBox checked={Edit_Data.self_activity_add}
                                                label='Self Activity Assigning' name='self_activity_add'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.self_activity_add} />
                                            {/* <PermissionCheckBox checked={Edit_Data.assign_leave_apply}
                                                label='Applying leave for other' name='assign_leave_apply'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.assign_leave_apply} /> later have to uncomment */}



                                            <PermissionCheckBox checked={Edit_Data.employee_personal_details_view}
                                                label='Employee Personal Info View(14 forms)' name='employee_personal_details_view'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.employee_personal_details_view} />

                                            <PermissionCheckBox checked={Edit_Data.holiday_calender_creation}
                                                label='Holiday Calender Creation' name='holiday_calender_creation'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.holiday_calender_creation} />



                                            <h6 className='my-3 ' > Leave Module </h6>
                                            <PermissionCheckBox checked={Edit_Data.leave_create}
                                                label='Leave Type Creation' name='leave_create'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.leave_create} />
                                            <PermissionCheckBox checked={Edit_Data.leave_edit}
                                                label='Leave type editing' name='leave_edit'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.leave_edit} />
                                            <h6 className='my-3 ' >  HR Works </h6>
                                            <PermissionCheckBox checked={Edit_Data.job_post}
                                                label='Job Post' name='job_post'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.job_post} />
                                            <PermissionCheckBox checked={Edit_Data.massmail_communication}
                                                label='Mass Mail Communication' name='massmail_communication'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.massmail_communication} />
                                            <PermissionCheckBox checked={Edit_Data.assign_offerletter_prepare}
                                                label='Offer Letter Preparing' name='assign_offerletter_prepare'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.assign_offerletter_prepare} />

                                            <PermissionCheckBox checked={Edit_Data.assign_resignation_apply}
                                                label='Applying resignation for other' name='assign_resignation_apply'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.assign_resignation_apply} />

                                            <PermissionCheckBox checked={Edit_Data.attendance_upload}
                                                label='Attendace Updating' name='attendance_upload'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.attendance_upload} />
                                            <h6 className='my-2 ' >Payroll Process  </h6>
                                            <PermissionCheckBox checked={Edit_Data.salary_component_creation}
                                                label='Salary Component' name='salary_component_creation'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.salary_component_creation} />
                                            <PermissionCheckBox checked={Edit_Data.salary_template_creation}
                                                label='Salary Template Creation' name='salary_template_creation'
                                                handlePermissionChanges={handlePermissionChanges}
                                                value={Edit_Data.salary_template_creation} />




                                        </article>
                                    </section>
                                </div>
                                <div className="col-12 text-end mt-3">
                                    <button type="submit" disabled={loading == 'edit'} onClick={Update_Employee}
                                        // data-bs-dismiss="modal"
                                        className="btn btn-primary text-white fw-medium px-2 px-lg-5"
                                    >
                                        {loading == 'edit' ? 'loading...' : 'Next'}{' '}
                                    </button>
                                </div>
                            </div>
                        )}
                        {editModalPage == 'sal' && (
                            <EmployeeSalaryAdding
                                id={Edit_Data.id}
                                emp={Edit_Data}
                                setpage={setEditModalPage}
                            />
                        )}
                    </div>
                </Modal.Body>
            </Modal>
        </div>
    )
}

export default EditEmployeeModal