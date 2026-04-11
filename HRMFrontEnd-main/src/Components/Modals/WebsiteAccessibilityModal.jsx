import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { domain, port } from '../../App'
import axios from 'axios'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';

const WebsiteAccessibilityModal = ({ obj, getData, showModal, name, id, setShowModal }) => {
    let empUser = JSON.parse(sessionStorage.getItem('user'))
    let [loading, setloading] = useState(false)
    let [formObj, setFormObj] = useState({
        interview_shedule_access: false,
        applied_list_access: false,
        final_status_access: false,
        screening_shedule_access: false,
        Reporting_To: '',
        Dashboard: '',
    })
    let [acceptObj, setAcceptObj] = useState({
        mailstatus: true,
        mail_content: ``,
        subject: 'Your Login Credentials for Merida'
    })
    console.log(obj);
    useEffect(() => {
        if (obj) {
            setAcceptObj((prev) => ({
                ...prev,
                mail_content: `<div class="container">
        <p>Dear <strong>${obj.full_name}  </strong>,</p>

        <p>Welcome to <strong> Merida </strong>!</p>

        <p>We are excited to have you join our team as a <strong>${obj.offered_position} </strong>. To help you get started, we have created your login credentials for our internal systems.</p>

        <h3>Your Login Information:</h3>
        <ul>
            <li><strong>Username:</strong> ${obj.employee_Id} </li>
            <li><strong>Temporary Password:</strong>MTM@123</li>
        </ul>

        <h3>Next Steps:</h3>
        <ol>
            <li><strong>Login:</strong> Please log in to our system at <strong> ${domain} </strong> using the credentials provided above.</li>
            <li><strong>Password Change:</strong> For security purposes, you will be prompted to change your temporary password upon your first login. Choose a strong, secure password that you can remember.</li>
            <li><strong>Setup:</strong> Once logged in, you can access (relevant systems, e.g., email, HR portal, company intranet) and complete any initial setup required for your role.</li>
        </ol>

        <h3>Additional Information:</h3>
        <ul>
            <li><strong>Support:</strong> If you encounter any issues or need assistance with your login, please contact our IT support team at <strong>(IT Support Email/Phone Number)</strong>.</li>
            <li><strong>Orientation:</strong> We will be in touch with details regarding your orientation and on-boarding schedule, which will help you get acquainted with our systems and processes.</li>
        </ul>

        <p>If you have any questions before your start date or need further assistance, please do not hesitate to reach out to us at <strong> ${obj.contact_info} </strong>.</p>

        <p>Best regards,</p>
    </div>`
            }))
        }
    }, [obj])
    let handleacceptObj = (e) => {
        let { name, value } = e.target
        setAcceptObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let [declineObj, setDeclineObj] = useState({
        mail: `Dear ${name} 
        We are going through your form which have submitted , there were some information need to be little clear , recheck the following forms
1)

click the below link to open the forms : ${domain}/Employeeallform/${id}/
Regards ,
Merida HR Team.`
    })
    let handleDeclineObj = (e) => {
        let { name, value } = e.target
        setDeclineObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let acceptEmployee = (objt) => {
        setloading(true)
        let formObj = {
            ProfileVerification: showModal,
            Verifier: empUser.EmployeeId,
            mail_send_status: objt.mailstatus,
            mail_content: objt.mail_content,
            subject: objt.subject,
            Password: 'MTM@123'
        }
        axios.post(`${port}/root/ems/EmployeeCreation/${obj.id}/`, formObj).then((response) => {
            console.log(response.data);
            setloading(false)
            getData()
            setShowModal('')
        }).catch((error) => {
            console.log(error);
            setloading(false)
        })
    }
    let updateData = () => {
        axios.patch(`${port}/root/ems/Employee-Update/${obj.id}/`, {
            Update_Data: {
                ...formObj
            }
        }).then((response) => {
            console.log(response.data);
            toast.success('Submitted successfully')
            setShowModal('')
        }).catch((error) => {
            console.log(error);
        })
    }
    const [interviewers, setInterviewers] = useState([]);

    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        })
        // sentparticularData()
    }, [])
    let navigate = useNavigate()
    let handleDecline = () => {
        let formObj = {
            ProfileVerification: showModal,
            Verifier: empUser.EmployeeId,
            mail_send_status: true,
            mail_content: declineObj.mail,
            // Password: 'MTM@123'
        }
        axios.post(`${port}/root/ems/EmployeeCreation/${obj.id}/`, formObj).then((response) => {
            console.log(response.data);
            getData()
            toast.success('Mail has been sended')
            navigate(`/New_Join_Employee`)
            setShowModal('')
        }).catch((error) => {
            console.log(error);
        })
    }
    return (
        <div>
            <Modal show={showModal} centered size='xl' onHide={() => setShowModal('')} >
                <Modal.Header closeButton>
                    Website accessibility for Employee
                </Modal.Header>
                <Modal.Body>
                    {
                        showModal == 'success' ?
                            <main className='formbg p-3 rounded'>
                                <div className=''>
                                    Do you wanna send a Mail ?
                                    <section className='flex gap-2 items-center'>

                                        <input type="radio" name='mailstatus'
                                            onClick={() => setAcceptObj((prev) => ({ ...prev, mailstatus: true }))} id='yes'
                                            checked={acceptObj.mailstatus} />
                                        <label htmlFor="yes">Yes </label>
                                        <input type="radio" name='mailstatus'
                                            onClick={() => {
                                                setAcceptObj((prev) => ({ ...prev, mailstatus: false }))
                                                console.log('testing', 'hellow');
                                            }} id='no'
                                            checked={!acceptObj.mailstatus} />
                                        <label htmlFor="no">No </label>
                                    </section>
                                </div>

                                {acceptObj.mailstatus == true &&
                                    <>
                                        <div>
                                            Mail Subject :
                                            <input type="text" className=' block bgclr p-2 w-full my-2
                                     rounded outline-none ' value={acceptObj.subject} name='subject'
                                                onChange={handleacceptObj} />
                                        </div>
                                        <div className=''>
                                            Mail Content :
                                            {/* <textarea className=' block bgclr p-2 w-full
                                     rounded outline-none ' name="mail_content"
                                                onChange={handleacceptObj} rows={8}
                                                value={acceptObj.mail_content} id="">

                                            </textarea> */}
                                            <ReactQuill
                                                theme="snow"
                                                value={acceptObj.mail_content}
                                                onChange={(content) => setAcceptObj(prev => ({ ...prev, mail_content: content }))}
                                                className='bg-white'
                                            />
                                        </div>
                                    </>}
                                <section className='row my-3'>

                                    <div className="col-md-6 col-lg-4 mb-3 ">
                                        <label className='my-2' htmlFor="gender" >Position <span class='text-danger'>*</span> </label>
                                        <select
                                            className="bgclr p-2 outline-none block
                                         rounded w-full shadow-none bg-light"
                                            id="gender"
                                            name="Dashboard"
                                            value={formObj.Dashboard}
                                            onChange={handleChange} // Set the value of the select input to gender
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
                                        <label htmlFor="gender" className="my-2 bg-transparent">Reporting To <span class='text-danger'>*</span> </label>
                                        <select
                                            className="bgclr p-2 outline-none block
                                         rounded w-full shadow-none bg-light"
                                            name="Reporting_To"
                                            value={formObj.Reporting_To} // Set the value of the select input to gender
                                            onChange={(e) => handleChange(e)} // Update gender state when the select input changes
                                            required>
                                            <option value="">Select  <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                                            {interviewers.map(interviewer => (
                                                <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                                    {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                </option>
                                            ))}
                                        </select>
                                    </div>

                                </section>
                                <section>
                                    <h4>Permissions </h4>
                                    <article className='flex flex-wrap items-center '>
                                        <div className="col-md-6 col-lg-4 mb-3 ">
                                            <input type="checkbox" className=''
                                                checked={formObj.interview_shedule_access} id='interview_shedule_access'
                                                value={formObj.interview_shedule_access}
                                                onChange={() => setFormObj((prev) => ({
                                                    ...prev,
                                                    interview_shedule_access: !prev.interview_shedule_access
                                                }))} />
                                            <label className='mx-2' htmlFor="interview_shedule_access">
                                                Interview shedule access
                                            </label>
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3 ">
                                            <input type="checkbox" className='' checked={formObj.applied_list_access} id='applied_list_access'
                                                value={formObj.applied_list_access}
                                                onChange={() => setFormObj((prev) => ({
                                                    ...prev,
                                                    applied_list_access: !prev.applied_list_access
                                                }))} />
                                            <label className='mx-2' htmlFor="applied_list_access">
                                                Applied list access
                                            </label>
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3 ">
                                            <input type="checkbox" className='' checked={formObj.final_status_access} id='final_status_access'
                                                value={formObj.final_status_access}
                                                onChange={() => setFormObj((prev) => ({
                                                    ...prev,
                                                    final_status_access: !prev.final_status_access
                                                }))} />
                                            <label className='mx-2' htmlFor="final_status_access">
                                                Final status access
                                            </label>
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3 ">
                                            <input type="checkbox" className='' checked={formObj.screening_shedule_access} id='screening_shedule_access'
                                                value={formObj.screening_shedule_access}
                                                onChange={() => setFormObj((prev) => ({
                                                    ...prev,
                                                    screening_shedule_access: !prev.screening_shedule_access
                                                }))} />
                                            <label className='mx-2' htmlFor="screening_shedule_access">
                                                Screening shedule access
                                            </label>
                                        </div>
                                    </article>

                                </section>
                                <button onClick={() => {
                                    // setloading(true)
                                    acceptEmployee(acceptObj)
                                    // setTimeout(() => {
                                    //     updateData()
                                    // }, 2000);
                                }} disabled={loading} className='flex ms-auto savebtn text-white p-2 rounded '>
                                    {loading ? 'Loading..' : "Submit"}
                                </button>
                            </main>
                            :
                            <main className='formbg p-2 rounded'>
                                <div className=''>
                                    Mail Content :
                                    <textarea className=' block bgclr p-2 w-full
                                     rounded outline-none ' name="mail"
                                        onChange={handleDeclineObj} rows={8}
                                        value={declineObj.mail} id="">

                                    </textarea>
                                </div>
                                <button onClick={handleDecline} className='my-2 bg-blue-500 text-white rounded p-2 flex ms-auto '>
                                    Send
                                </button>

                            </main>
                    }

                </Modal.Body>
            </Modal>

        </div>
    )
}

export default WebsiteAccessibilityModal