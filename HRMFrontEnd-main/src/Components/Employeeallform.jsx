import React, { useState, useEffect, useContext } from 'react';
import axios from 'axios';
import Sidebar from './Sidebar';
import Topnav from './Topnav';
import { Route, Routes, useLocation, useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'
import JoingingFormalities from '../Pages/JoiningFormalities/JoingingFormalities';
import JFEducationForm from '../Pages/JoiningFormalities/JFEducationForm';
import JFFamilyDetails from '../Pages/JoiningFormalities/JFFamilyDetails';
import JFMedical from '../Pages/JoiningFormalities/JFMedical';
import JFEmergenciescontact from '../Pages/JoiningFormalities/JFEmergenciescontact';
import JFReference from '../Pages/JoiningFormalities/JFReference';
import JFExperience from '../Pages/JoiningFormalities/JFExperience';
import JFLastpositionHeld from '../Pages/JoiningFormalities/JFLastpositionHeld';
import JFPersonalForm from '../Pages/JoiningFormalities/JFPersonalForm';
import JFIdentityForm from '../Pages/JoiningFormalities/JFIdentityForm';
import JFBankAcctDetails from '../Pages/JoiningFormalities/JFBankAcctDetails';
import JFPfDetails from '../Pages/JoiningFormalities/JFPfDetails';
import JFAdditionalINfo from '../Pages/JoiningFormalities/JFAdditionalINfo';
import JFAttachments from '../Pages/JoiningFormalities/JFAttachments';
import JFDocumentSubmitted from '../Pages/JoiningFormalities/JFDocumentSubmitted';
import JFDeclaration from '../Pages/JoiningFormalities/JFDeclaration';
import { HrmStore } from '../Context/HrmContext';


const Employeeallform = () => {
    let { calculateAge } = useContext(HrmStore)
    const { id } = useParams();
    let location = useLocation();
    let queryParams = new URLSearchParams(location.search)
    let empid = queryParams.get('empid')

    let Empid = JSON.parse(sessionStorage.getItem('Employee_Info'))
    let [EmployeeInformation, setEmployeeInformation] = useState({
        salutation: null,
        full_name: null,
        last_name: null,
        date_of_birth: null,
        gender: null,
        weight: null,
        height: null,
        age: null,

        present_address: null,
        present_City: null,
        present_state: null,
        present_pincode: null,

        mobile: null,
        email: null,


        permanent_address: null,
        permanent_City: null,
        permanent_state: null,
        permanent_pincode: null,
    })
    const handleFormObj = (e) => {
        let { name, value } = e.target
        if (name == 'date_of_birth') {
            setEmployeeInformation((prev) => ({
                ...prev,
                age: calculateAge(value)
            }))
        }
        setEmployeeInformation((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let navigate = useNavigate()
    let getData = () => {
        if (id && typeof id == "number") {
            axios.get(`${port}/root/ems/candidate_employee_information/${id}/`).then((response) => {
                setEmployeeInformation(response.data)
                console.log(response.data, 'hellow');
            }).catch((error) => {
                console.log(error, 'hellow');
            })
        }
        if (id && typeof id != "number") {
            axios.get(`${port}/root/ems/Get_Employee_by_Emp/${id}/`).then((response) => {
                console.log(response.data, "empid");
                setEmployeeInformation(response.data)
            }).catch((error) => {
                console.log(error, 'empid');
            })
        }
    }
    useEffect(() => {
        getData()
    }, [id, empid])

    return (

        <div className='container-fluid p-3' style={{ width: '100%', minHeight: '100%' }}>
            {/* <section className='container-fluid w-full relative '>
                <button className='bg-red-700'>
                    Employee Information
                    <div className={`w-5 h-5 rounded-full bg-slate-600 `}>
                    </div>
                </button>
                <div className='absolute border-1 top-1/2 border-slate-900 w-[100%] border-dashed '>

                </div>
            </section> */}
            {
                // (EmployeeInformation && !EmployeeInformation.form_submitted_status) || typeof id != 'number' ?
                (EmployeeInformation && !EmployeeInformation.form_submitted_status) || !isNaN(id) ?

                    <Routes>
                        <Route path='/*'
                            element={<JoingingFormalities id={id} formObj={EmployeeInformation}
                                getData={getData} handleFormObj={handleFormObj}
                                setFormOb={setEmployeeInformation} />} />
                        <Route path='/ed-form' element={<JFEducationForm id={id} data={EmployeeInformation} />} />
                        <Route path='/fm-form' element={<JFFamilyDetails id={id} data={EmployeeInformation} />} />
                        <Route path='/med' element={<JFMedical id={id} data={EmployeeInformation} />} />
                        <Route path='/emergency_form' element={<JFEmergenciescontact id={id} data={EmployeeInformation} />} />
                        <Route path='/ref_form' element={<JFReference id={id} data={EmployeeInformation} />} />
                        <Route path='/exp_form' element={<JFExperience id={id} data={EmployeeInformation} />} />
                        <Route path='/last_position_held' element={<JFLastpositionHeld id={id} data={EmployeeInformation} />} />
                        <Route path='/personal_info' element={<JFPersonalForm id={id} data={EmployeeInformation} />} />
                        <Route path='/empl_info' element={<JFIdentityForm id={id} data={EmployeeInformation} />} />
                        <Route path='/bank_details' element={<JFBankAcctDetails id={id} data={EmployeeInformation} />} />
                        <Route path='/pf_details' element={<JFPfDetails id={id} data={EmployeeInformation} />} />
                        <Route path='/additional_info' element={<JFAdditionalINfo id={id} data={EmployeeInformation} />} />
                        <Route path='/attachment' element={<JFAttachments id={id} data={EmployeeInformation} />} />
                        <Route path='/document' element={<JFDocumentSubmitted id={id} data={EmployeeInformation} />} />
                        <Route path='/declaration' element={<JFDeclaration id={id} data={EmployeeInformation} />} />
                    </Routes> :
                    <main className='p-5 h-[90vh] flex rounded'>
                        <div className='bgclr text-center p-5 rounded h-fit m-auto  '>
                            <h5>Form has been submitted  </h5>
                            <h6>All the Best !!! </h6>
                        </div>
                    </main>
            }
        </div>
    );
};

export default Employeeallform;
