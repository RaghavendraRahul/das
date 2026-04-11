import React, { useContext, useEffect, useState } from 'react';
import { HrmStore } from '../Context/HrmContext';

const Employeeseparation = () => {



  

    // EMPLOYEE RESIGNATION FORM  START
    const [Employee_id, setEmployee_id] = useState('');
    const [Name, setName] = useState('');
    const [Position, setPosition] = useState('');
    const [Reporting_manager_name, setReporting_manager_name] = useState('');
    const [Reason, setReason] = useState('');
    const [resigned_letter_file, setresigned_letter_file] = useState('');
    const [Confirm_resignation, setConfirm_resignation] = useState(false);

    const handle_employee_Resignation_info = (e) => {
        e.preventDefault()
        alert("EMPLOYEE RESIGNATION FORM ")

        const formData1 = new FormData()

        formData1.append('Employee_id', Employee_id);
        formData1.append('Name', Name);
        formData1.append('Position', Position);
        formData1.append('Reporting_manager_name', Reporting_manager_name);
        formData1.append('Reason', Reason);
        formData1.append('resigned_letter_file', resigned_letter_file);
        formData1.append('Confirm_resignation', Confirm_resignation);


        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }



    }
    //  EMPLOYEE RESIGNATION FORM  END

    // EXIT INTERVIEW FORM  START
    const [Employee_id1, setEmployee_id1] = useState('');
    const [Name1, setName1] = useState('');
    const [Date, setDate] = useState('')
    const [interviewed_by, setinterviewed_by] = useState('')
    const [interviewed_contact, setinterviewed_contact] = useState('')

    const handle_employee_Exit_Interview_form = (e) => {
        e.preventDefault()
        alert("EXIT INTERVIEW FORM ")

        const formData2 = new FormData()

        formData2.append('Employee_id1', Employee_id1);
        formData2.append('Name1', Name1);
        formData2.append('Date', Date);
        formData2.append('interviewed_by', interviewed_by);
        formData2.append('interviewed_contact', interviewed_contact);



        for (let pair of formData2.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }


    }

    // EXIT INTERVIEW FORM  END

    // EXIT DETAILS FORM  START

    const [LeavingDate, setLeavingDate] = useState('')
    const [SettledOn, setSettledOn] = useState('')
    const [Employee_Has_Left_The_Organization, setEmployee_Has_Left_The_Organization] = useState('')
    const [NoticedServed, setNoticedServed] = useState('')
    const [FitToBeRehired, setFitToBeRehired] = useState('')
    const [AlternateEmail, setAlternateEmail] = useState('')
    const [AlternateMobile, setAlternateMobile] = useState('')

    const handle_Exit_Details = (e) => {
        e.preventDefault()
        alert("EXIT DETAILS FORM ")

        const formData3 = new FormData()

        formData3.append('Employee_id', Employee_id);
        formData3.append('Name', Name);
        formData3.append('Position', Position);
        formData3.append('Reporting_manager_name', Reporting_manager_name);
        formData3.append('Reason', Reason);
        formData3.append('resigned_letter_file', resigned_letter_file);
        formData3.append('Confirm_resignation', Confirm_resignation);


        for (let pair of formData3.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }



    }


    // EXIT DETAILS FORM  END

    // COMPANY POLICIES FORM  START 


    const [PolicyName, setPolicyName] = useState('')
    const [Description, setDescription] = useState('')
    const [SerialNo, setSerialNo] = useState('')
    const [CompanyPolicyCategory, setCompanyPolicyCategory] = useState('')
    const [UploadFile, setUploadFile] = useState(null)
    const [EmployeeFilter, setEmployeeFilter] = useState('')



    const handle_Company_Policies = (e) => {
        e.preventDefault()
        alert("COMPANY POLICIES FORM ")

        const formData3 = new FormData()

        formData3.append('PolicyName', PolicyName);
        formData3.append('Description', Description);
        formData3.append('SerialNo', SerialNo);
        formData3.append('CompanyPolicyCategory', CompanyPolicyCategory);
        formData3.append('UploadFile', UploadFile);
        formData3.append('EmployeeFilter', EmployeeFilter);


        for (let pair of formData3.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }



    }


    // COMPANY POLICIES FORM  END


    return (

        <div style={{ width: '100%', minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

            {/* EMPLOYEE RESIGNATION FORM START */}
            <div className='p-3' >
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EMPLOYEE RESIGNATION FORM </h5>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg ">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">Employee id* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Employee_id} onChange={(e) => setEmployee_id(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">Name* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Name} onChange={(e) => setName(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">Position*</label>
                                    <input type="text" className="form-control shadow-none" value={Position} onChange={(e) => setPosition(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">Reporting manager name*</label>
                                    <input type="text" className="form-control shadow-none" value={Reporting_manager_name} onChange={(e) => setReporting_manager_name(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-12 mb-3">
                                    <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Reason*</label>
                                    <input type="text" className="form-control shadow-none" value={Reason} onChange={(e) => setReason(e.target.value)} id="PrimaryContact" name="PrimaryContact" style={{ height: '60px' }} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">resigned_letter file*</label>
                                    <input type="text" className="form-control shadow-none" value={resigned_letter_file} onChange={(e) => setresigned_letter_file(e.target.value)} id="SecondaryContact" name="SecondaryContact" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3 mt-4 pt-3">
                                    <input type="checkbox" className=" shadow-none" value={Confirm_resignation} onChange={(e) => setConfirm_resignation(e.target.value)} id="State" name="State" />
                                    <label htmlFor="secondaryContact" className="form-label ms-4">Confirm resignation</label>
                                </div>


                            </div>
                        </div>
                    </div>
                    {/* form end */}
                    {/* Button start */}
                    <div class=" d-flex justify-content-end mt-2">

                        <div className='d-flex gap-2'>


                            <button type="submit" class="btn btn-success btn-sm" onClick={handle_employee_Resignation_info}  >Submit</button>



                        </div>
                    </div>
                    {/* Button end */}
                </form>
            </div>
            {/* EMPLOYEE RESIGNATION FORM  END */}


            {/* EXIT INTERVIEW FORM  START */}
            <div className='p-3' >
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>  EXIT INTERVIEW FORM</h5>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg ">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">Employee id* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Employee_id1} onChange={(e) => setEmployee_id1(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">Name* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Name1} onChange={(e) => setName1(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">Date*</label>
                                    <input type="text" className="form-control shadow-none" value={Date} onChange={(e) => setDate(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">interviewed by*</label>
                                    <input type="text" className="form-control shadow-none" value={interviewed_by} onChange={(e) => setinterviewed_by(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">interviewed contact*</label>
                                    <input type="text" className="form-control shadow-none" value={interviewed_contact} onChange={(e) => setinterviewed_contact(e.target.value)} id="Email" name="Email" />
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


            {/* EXIT DETAILS FORM  START */}
            <div className='p-3' >
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>  EXIT DETAILS FORM</h5>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg ">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">LeavingDate * </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={LeavingDate} onChange={(e) => setLeavingDate(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">SettledOn * </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={SettledOn} onChange={(e) => setSettledOn(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">Employee Has  Left TheOrganization*</label>
                                    <input type="text" className="form-control shadow-none" value={Employee_Has_Left_The_Organization} onChange={(e) => setEmployee_Has_Left_The_Organization(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">NoticedServed*</label>
                                    <input type="text" className="form-control shadow-none" value={NoticedServed} onChange={(e) => setNoticedServed(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">FitToBeRehired *</label>
                                    <input type="text" className="form-control shadow-none" value={FitToBeRehired} onChange={(e) => setFitToBeRehired(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">AlternateEmail </label>
                                    <input type="text" className="form-control shadow-none" value={AlternateEmail} onChange={(e) => setAlternateEmail(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">AlternateMobile</label>
                                    <input type="text" className="form-control shadow-none" value={AlternateMobile} onChange={(e) => setAlternateMobile(e.target.value)} id="Email" name="Email" />
                                </div>



                            </div>
                        </div>
                    </div>
                    {/* form end */}
                    {/* Button start */}
                    <div class=" d-flex justify-content-end mt-2">

                        <div className='d-flex gap-2'>


                            <button type="submit" class="btn btn-success btn-sm" onClick={handle_Exit_Details}  >Submit</button>



                        </div>
                    </div>
                    {/* Button end */}
                </form>
            </div>
            {/* EXIT DETAILS FORM  END */}



            {/* COMPANY POLICIES FORM  START */}
            <div className='p-3' >
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>COMPANY POLICIES</h5>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg ">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">PolicyName *</label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={PolicyName} onChange={(e) => setPolicyName(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="Name" className="form-label">Description  * </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Description} onChange={(e) => setDescription(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">SerialNo *</label>
                                    <input type="text" className="form-control shadow-none" value={SerialNo} onChange={(e) => setSerialNo(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">CompanyPolicyCategory *</label>
                                    <input type="text" className="form-control shadow-none" value={CompanyPolicyCategory} onChange={(e) => setCompanyPolicyCategory(e.target.value)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">UploadFile *</label>
                                    <input type="file" className="form-control shadow-none" onChange={(e) => setUploadFile(e.target.files)} id="Email" name="Email" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">EmployeeFilter* </label>
                                    <input type="text" className="form-control shadow-none" value={EmployeeFilter} onChange={(e) => setEmployeeFilter(e.target.value)} id="Email" name="Email" />
                                </div>


                            </div>
                        </div>
                    </div>
                    {/* form end */}
                    {/* Button start */}
                    <div class=" d-flex justify-content-end mt-2">

                        <div className='d-flex gap-2'>


                            <button type="submit" class="btn btn-success btn-sm" onClick={handle_Company_Policies}  >Submit</button>



                        </div>
                    </div>
                    {/* Button end */}
                </form>
            </div>
            {/* COMPANY POLICIES FORM  END */}







        </div>
    );
};

export default Employeeseparation;
