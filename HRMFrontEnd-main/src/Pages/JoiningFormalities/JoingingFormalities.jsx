import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { toast } from 'react-toastify';
import { port } from '../../App'

const JoingingFormalities = ({ id, getData, page, formObj, setFormObj, handleFormObj }) => {
    let navigate = useNavigate()
    let saveData = () => {
        console.log('saveData called, formObj:', formObj);
        if (formObj.id) {
            console.log('Updating existing record, ID:', formObj.id);
            update()
            return
        }
        console.log('Creating new record for candidate ID:', id);
        axios.post(`${port}/root/ems/employee_information/${id}/`, formObj).then((response) => {
            console.log('POST Success! Response:', response.data);
            setFormObj(response.data)
            toast.success('Employee information saved successfully!');
        }).catch((error) => {
            console.error('POST Error:', error);
            console.error('Error response:', error.response);

            // Display detailed validation errors
            if (error.response?.data) {
                const errorData = error.response.data;
                console.error('Validation errors:', errorData);

                // Format error message
                let errorMessage = 'Failed to save:\n';
                if (typeof errorData === 'object') {
                    Object.keys(errorData).forEach(key => {
                        errorMessage += `${key}: ${errorData[key]}\n`;
                    });
                } else {
                    errorMessage = errorData;
                }

                toast.error(errorMessage);
            } else {
                toast.error(`Failed to save: ${error.message}`);
            }
        })
    }
    let update = () => {
        delete formObj.Candidate_id
        console.log('Updating employee info, ID:', formObj.id);
        axios.patch(`${port}/root/ems/updating_employee_information/${formObj.id}/`, formObj).then((response) => {
            console.log(response.data);
            console.log('PATCH Success:', response.data);
            toast.success('Employee information updated!');
            // setFormObj(response.data);
            getData()
        }).catch((error) => {
            console.error('PATCH Error:', error);
            console.log(error);
            toast.error(`Failed to update: ${error.response?.data?.detail || error.message}`);
        })
    }
    useEffect(() => {
        getData()
    }, [])
    return (
        <div className=' inputbg p-3 rounded '>
            <div className={`p-3 `}>
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EMPLOYEE INFORMATION</h5>
                        <div className="col-lg-12 p-4 mt-2 border bg-white rounded-lg ">
                            <div className="row m-0 pb-2">
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Salutation </label>
                                    <select disabled={page} type="text" className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="salutation"
                                        value={formObj && formObj.salutation} onChange={(e) => handleFormObj(e)} >
                                        <option value="">Select</option>
                                        <option value='Mr.'> Mr </option>
                                        <option value='Mrs.'> Mrs </option>
                                        <option value='Miss.'> Miss </option>
                                    </select>
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">

                                    <label htmlFor="Name" className="form-label">First Name </label>
                                    <input disabled={page} type="text" placeholder='Jones' className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="full_name" value={formObj && formObj.full_name} onChange={(e) => handleFormObj(e)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">

                                    <label htmlFor="Name" className="form-label">Last Name </label>
                                    <input disabled={page} type="text" placeholder='Jones' className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="last_name" value={formObj && formObj.last_name} onChange={(e) => handleFormObj(e)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Date Of Birth </label>
                                    <input disabled={page} type="date" className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="date_of_birth" value={formObj && formObj.date_of_birth} onChange={(e) => handleFormObj(e)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Age </label>
                                    <input disabled type="text" placeholder='Jones' className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="age" value={formObj && formObj.age} onChange={(e) => handleFormObj(e)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Gender </label>
                                    <select disabled={page} type="text" className="p-2 block rounded inputbg w-full outline-none shadow-none" id="Name" name="gender"
                                        value={formObj && formObj.gender} onChange={(e) => handleFormObj(e)} >
                                        <option value="">Select</option>
                                        <option value='male'> Male </option>
                                        <option value='female'> Female </option>
                                        <option value='transgender'> Transgender </option>
                                        <option value='others'> Other </option>
                                    </select>
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="lastName" className="form-label">Weight</label>
                                    <input disabled={page} type="number" placeholder='Weight in kg' className="p-2 block rounded inputbg w-full outline-none shadow-none"
                                        value={formObj && formObj.weight} onChange={(e) => { if (e.target.value >= 0 && e.target.value <= 300) { handleFormObj(e) } }} id="LastName" name="weight" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="email" className="form-label">Height</label>
                                    <input disabled={page} type="number" placeholder='Hieght in CM' className="p-2 block rounded inputbg w-full outline-none shadow-none"
                                        value={formObj && formObj.height} onChange={(e) => { if (e.target.value >= 0 && e.target.value <= 300) { handleFormObj(e) } }} id="Email" name="height" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Mobile No</label>
                                    <input disabled={page} type="tel" placeholder='989878****' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.mobile} onChange={(e) => handleFormObj(e)} id="State" name="mobile" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Email Id</label>
                                    <input disabled={page} type="email" placeholder='Enter mail' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.email} onChange={(e) => handleFormObj(e)} id="State" name="email" />
                                </div>
                                <h6 className='col-12 fw-semibold my-3 '>Present Address  </h6>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}> Address line 1</label>
                                    <input disabled={page} type="text" placeholder='23/4 , Maheswaran nagar,' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.present_address} onChange={(e) => handleFormObj(e)} id="PrimaryContact" name="present_address" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">City</label>
                                    <input disabled={page} type="text" placeholder='Tirunelveli' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.present_City} onChange={(e) => handleFormObj(e)} id="SecondaryContact" name="present_City" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">State</label>
                                    <input disabled={page} type="text" placeholder='TamilNadu' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.present_state} onChange={(e) => handleFormObj(e)} id="State" name="present_state" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Pincode</label>
                                    <input disabled={page} type="number" placeholder='627006' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.present_pincode} onChange={(e) => handleFormObj(e)} id="State" name="present_pincode" />
                                </div>



                                <h6 className='col-12 fw-semibold my-3'>Permanent Address  </h6>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Permanent Address line 1</label>
                                    <input disabled={page} type="text" placeholder='23/4 , Maheswaran nagar,' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.permanent_address} onChange={(e) => handleFormObj(e)} id="State" name="permanent_address" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">City</label>
                                    <input disabled={page} type="text" placeholder='Tirunelveli' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.permanent_City} onChange={(e) => handleFormObj(e)} id="State" name="permanent_City" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">State</label>
                                    <input disabled={page} type="text" placeholder='TamilNadu' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.permanent_state} onChange={(e) => handleFormObj(e)} id="State" name="permanent_state" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Pincode</label>
                                    <input disabled={page} type="number" placeholder='627006' className="p-2 block rounded inputbg w-full outline-none shadow-none" value={formObj && formObj.permanent_pincode} onChange={(e) => handleFormObj(e)} id="State" name="permanent_pincode" />
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                {/* <button className=' ' onClick={saveData} >
                    save
                </button> */}
                {!page && <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/ed-form`); }}
                    className='p-2 bg-slate-400 text-white rounded my-2 flex ms-auto '>
                    Next
                </button>}
            </div>

        </div>
    )
}

export default JoingingFormalities