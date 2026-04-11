import React, { useEffect, useState } from 'react'
import JoingingFormalities from './JoingingFormalities'
import JFEducationForm from './JFEducationForm'
import JFFamilyDetails from './JFFamilyDetails'
import JFMedical from './JFMedical'
import JFEmergenciescontact from './JFEmergenciescontact'
import JFReference from './JFReference'
import JFExperience from './JFExperience'
import JFLastpositionHeld from './JFLastpositionHeld'
import JFPersonalForm from './JFPersonalForm'
import JFIdentityForm from './JFIdentityForm'
import JFBankAcctDetails from './JFBankAcctDetails'
import JFPfDetails from './JFPfDetails'
import JFAdditionalINfo from './JFAdditionalINfo'
import JFAttachments from './JFAttachments'
import JFDocumentSubmitted from './JFDocumentSubmitted'
import JFDeclaration from './JFDeclaration'
import { useParams } from 'react-router-dom'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { Modal } from 'react-bootstrap'
import WebsiteAccessibilityModal from '../../Components/Modals/WebsiteAccessibilityModal'

const JFPreview = () => {
    let { id } = useParams()
    let [EmployeeInformation, setEmployeeInformation] = useState()
    let [showModal, setShowModal] = useState()
    let [acceptObj, setAcceptObj] = useState()
    // let user = JSON.parse(sessionStorage.getItem('user'))
    let user = sessionStorage.getItem('user') ? JSON.parse(sessionStorage.getItem('user')) : null
    let getEmployeeINformation = () => {
        // Use different endpoints based on ID type (same logic as Employeeallform.jsx)
        if (!isNaN(id)) {
            // Numeric ID = Candidate
            axios.get(`${port}/root/ems/candidate_employee_information/${id}/`).then((response) => {
                setEmployeeInformation(response.data)
                console.log("testing", response.data);
            }).catch((error) => {
                console.log(error, 'testing - candidate endpoint failed');
                toast.error('Could not load employee information. Please try again.');
            })
        } else {
            // Alphanumeric ID = Employee
            axios.get(`${port}/root/ems/Get_Employee_by_Emp/${id}/`).then((response) => {
                setEmployeeInformation(response.data)
                console.log("testing", response.data);
            }).catch((error) => {
                console.log(error, 'testing - employee endpoint failed');
                toast.error('Could not load employee information. Please try again.');
            })
        }
    }
    useEffect(() => {
        getEmployeeINformation()
    }, [])
    let submitForm = () => {
        if (!EmployeeInformation || !EmployeeInformation.id) {
            toast.error('Employee information not loaded. Please refresh the page.');
            return;
        }
        axios.patch(`${port}/root/ems/updating_employee_information/${EmployeeInformation.id}/`, {
            form_submitted_status: true
        }).then((response) => {
            console.log(response.data);
            toast.success('Form has been submitted')
            getEmployeeINformation()
        }).catch((error) => {
            console.log(error);
            toast.error('Failed to submit form. Please try again.');
        })
    }
    return (
        <div className='bg-white p-3 m-0'>
            {/* {EmployeeInformation && !EmployeeInformation.form_submitted_status || */}
            {(EmployeeInformation && !EmployeeInformation.form_submitted_status) ||
                (user && EmployeeInformation
                    && (user.Disgnation == 'Admin' || user.Disgnation == 'HR'))
                ? <main className='container mx-auto '>
                    <JoingingFormalities getData={getEmployeeINformation} id={id} page='preview' formObj={EmployeeInformation} />
                    <JFEducationForm id={id} page='preview' data={EmployeeInformation} />
                    <JFFamilyDetails id={id} page='preview' data={EmployeeInformation} />
                    <JFMedical id={id} page='preview' data={EmployeeInformation} />
                    <JFEmergenciescontact id={id} page='preview' data={EmployeeInformation} />
                    <JFReference id={id} page='preview' data={EmployeeInformation} />
                    <JFExperience id={id} page='preview' data={EmployeeInformation} />
                    <JFLastpositionHeld id={id} page='preview' data={EmployeeInformation} />
                    <JFPersonalForm id={id} page='preview' data={EmployeeInformation} />
                    <JFIdentityForm id={id} page='preview' data={EmployeeInformation} />
                    <JFBankAcctDetails id={id} page='preview' data={EmployeeInformation} />
                    <JFPfDetails id={id} page='preview' data={EmployeeInformation} />
                    <JFAdditionalINfo id={id} page='preview' data={EmployeeInformation} />
                    <JFAttachments id={id} page='preview' data={EmployeeInformation} />
                    <JFDocumentSubmitted id={id} page='preview' data={EmployeeInformation} />
                    <JFDeclaration id={id} page='preview' data={EmployeeInformation} />

                    {EmployeeInformation && !EmployeeInformation.form_submitted_status &&
                        <button onClick={submitForm}
                            className='my-3 ms-auto flex rounded p-2 text-white btngrd ' >
                            Submit
                        </button>}
                    {user && (user.Disgnation == 'Admin' || user.Disgnation == 'HR') &&
                        EmployeeInformation && !EmployeeInformation.is_verified &&
                        <div className='flex my-3 justify-end '>
                            <button onClick={() => setShowModal('success')} className='p-2 rounded mx-2 savebtn text-white '>
                                Accept
                            </button>
                            <button onClick={() => setShowModal('failed')} className='p-2 rounded mx-2 bg-red-500 text-white '>
                                Decline
                            </button>
                        </div>
                    }
                </main> :
                <main className='  p-5 h-[100vh] flex rounded'>
                    <div className='bgclr text-center p-5 rounded h-fit m-auto  '>
                        <h5>Form has been submitted  </h5>
                        <h6>All the Best !!! </h6>
                    </div>
                </main>
            }

            {EmployeeInformation && showModal &&
                <WebsiteAccessibilityModal obj={EmployeeInformation}
                    id={EmployeeInformation.Candidate_id} name={EmployeeInformation.full_name}
                    getData={getEmployeeINformation}
                    showModal={showModal} setShowModal={setShowModal} />}

        </div>
    )
}

export default JFPreview