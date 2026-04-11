import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import Topnav from '../../Components/Topnav'
import { Modal } from 'react-bootstrap'
import axios from 'axios'
import { domain, port } from '../../App'
import InfoButton from '../../Components/SettingComponent/InfoButton'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'
import ReactQuill from 'react-quill'

const HRrequestPage = () => {
    let { setActivePage, getCurrentDate, convertToReadableDateTime } = useContext(HrmStore)
    let navigate = useNavigate()
    let [requestModal, setRequestModal] = useState(false)
    let [loading, setloading] = useState(false)
    let [invitationRequest, setRequest] = useState()
    let [employeeList, setAllEmployeelist] = useState()
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [mailSending, setMailsending] = useState()
    let [meetingMailContent, setMeetingMailContent] = useState({
        id: ''
    })

    let [employee, setEmployee] = useState({
        Emp_id: '',
        name: '',
        rep_name: '',
        invitation_reason: '',
        invited_by: Empid,
        mail: ``,
        reporting_mail_content: '',
        emp_form_link: `${domain}/selfEvaluation/`,
        rm_form_link: `${domain}/employePerformanceEvaluation/`

    })
    let handleChange = (e) => {
        let { name, value } = e.target
        if (name == 'Emp_id') {
            let obj = employeeList.find((o) => o.employee_Id == value)
            setEmployee((prev) => ({
                ...prev,
                name: obj.full_name,
                rep_name: obj.Reporting_To_Name
            }))
        }
        setEmployee((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    const sendMeetingMail = () => {
        setloading('mail')
        axios.post(`${port}/root/lms/PerformanceMetrics/`, {
            mail_content: meetingMailContent,
            EmployeeSelfEvaluation: mailSending.self_app_id
        }).then((response) => {
            setMailsending(false)
            toast.success('Mail sended for the Employee')
            console.log(response.data);
            getRequest()
        }).catch((error) => {
            setloading(false)
            console.log(error);
        })
    }
    const fetchdata = () => {
        if (Empid) {
            axios.get(`${port}/root/ems/AllEmployeesList/${Empid}/`).then((res) => {
                console.log("AllEmployee_res", res.data, Empid);
                if (Array.isArray(res.data))
                    setAllEmployeelist(res.data)
            }).catch((err) => {
                console.log("AllEmployee_err", err.data);
            })
        }
    }
    let sendRequest = () => {
        setloading(true)
        axios.post(`${port}/root/lms/AppraisalInvitation/`,
            {
                ...employee, invited_by: Empid, emp_form_link: `${domain}/selfEvaluation/`,
                rm_form_link: `${domain}/employePerformanceEvaluation/`
            }).then((response) => {
                console.log(response.data);
                toast.success('Mail has been sended')
                reset()
                setloading(false)
            }).catch((error) => {
                console.log(error);
                setloading(false)

            })
    }
    let getRequest = () => {
        axios.get(`${port}/root/lms/AppraisalInvitation/?inviter_id=${Empid}`).then((response) => {
            console.log("hellow", response.data);
            setRequest(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let reset = () => {
        setRequestModal(false)
        setEmployee({
            Emp_id: '',
            name: '',
            invitation_reason: '',
            mail: ``
        })
    }
    useEffect(() => {
        fetchdata()
        getRequest()
        setActivePage('perform')
        setEmployee((prev) => ({
            ...prev,
            mail: `Dear ${employee.name},
        We like a your work for our company , we would like to have a performance meeting. Kindly fill the form in the below link `,
            reporting_mail_content: `Dear ${employee.rep_name},
        We would like to inform you that we are choosing Mr/Ms ${employee.name} from your Department for Performance meeting , we could use your toughts about a Employee, fill the form in the below link `
        }))
    }, [employee.name, employee.Emp_id])
    useEffect(() => {
        if (mailSending) {
            setMeetingMailContent(`Dear ${mailSending.employee_name},\nWe would like to bring you a kind attention that we are conducting meeting for you regarind the perfomance. 
Date :${getCurrentDate()}
Timing : 11 AM
Regards ,
Merida HR Team. `)
        }
    }, [mailSending])
    return (
        <div>
            <Topnav name='Performance Meeting' />
            <main className='px-2 ' >
                <button onClick={() => setRequestModal(true)} className='p-2 text-white text-xs px-3 my-3 flex ms-auto rounded btngrd '>
                    + Add New
                </button>
                <section className='tablebg rounded table-responsive '>
                    <table className='w-full '>
                        <tr>
                            <th>SI No</th>
                            <th>Employee name </th>
                            <th>Department </th>
                            <th>Designation </th>
                            <th>Review Invitation Date </th>
                            <th>Self Evaluation </th>
                            <th>Reporting Manager's Feedback </th>
                            <th>Review Summary </th>
                        </tr>
                        {
                            invitationRequest && invitationRequest.map((obj, index) => (
                                <tr>
                                    <td>{index + 1} </td>
                                    <td>{obj.employee_name} </td>
                                    <td>{obj.Department} </td>
                                    <td>{obj.Designation} </td>
                                    <td>{obj.invited_on && convertToReadableDateTime(obj.invited_on)} </td>
                                    <td>
                                        {obj.is_filled ? <button className='text-blue-600 text-decoration-underline '
                                            onClick={() => navigate(`/selfEvaluation/${obj.self_app_id}`)} > view </button> : 'Pending'}
                                    </td>
                                    <td>
                                        {obj.is_rm_filled ? <button className='text-blue-600 text-decoration-underline '
                                            onClick={() => navigate(`/employePerformanceEvaluation/${obj.rm_app_id}`)} > view </button> : 'Pending'}
                                    </td>
                                    <td>
                                        {obj.is_rm_filled && obj.is_filled ?
                                            obj.meeting_mail_sent_status ?
                                                <button onClick={() => navigate(`/meetingReview/${obj.self_app_id}`)} className='bg-blue-500 text-white p-1 rounded'>
                                                    review
                                                </button> : <button onClick={() => setMailsending(obj)} className='bg-blue-500 text-white p-1 rounded'>
                                                    Assign
                                                </button> : 'Pending'
                                        }
                                    </td>
                                </tr>
                            ))
                        }
                    </table>
                </section>
            </main>
            {
                mailSending &&
                <Modal centered show={mailSending} onHide={() => setMailsending('')} >
                    <Modal.Header closeButton>
                        Performance meeting intimation
                    </Modal.Header>
                    <Modal.Body>
                        <div className='flex items-start  '>
                            <label className='w-2/5 ' htmlFor=""> Mail Content </label>
                            <textarea name="" className='w-3/5 inputbg rounded p-2 outline-none ' rows={5} value={meetingMailContent}
                                onChange={(e) => setMeetingMailContent(e.target.value)} id="">
                            </textarea>

                        </div>
                        <button disabled={loading == 'mail'} onClick={sendMeetingMail} className='bg-blue-500 text-white p-2 rounded flex ms-auto my-3 '>
                            {loading == 'mail' ? 'Loading' : "Send"}
                        </button>
                    </Modal.Body>
                </Modal>
            }

            {
                requestModal && <Modal size='lg' show={requestModal} onHide={() => reset()} centered >
                    <Modal.Header className='' closeButton >
                        Performance meeting request
                    </Modal.Header>
                    <Modal.Body>
                        <section className='row '>
                            <div className='flex col-sm-6 items-start my-3 '>
                                <label htmlFor="" className='relative sm:w-2/5 ' > Select Employee
                                    <span className='absolute  ' >
                                        <InfoButton size={10} content='If the employee’s name is updated, the review request email will be reset, and you will need to re-select the employee.' />
                                    </span> </label>
                                <select name="Emp_id" value={employee.Emp_id} onChange={(e) => {
                                    handleChange(e)
                                }}
                                    id="" className='p-2 sm:w-3/5 rounded inputbg outline-none'>
                                    <option value="">Select </option>
                                    {
                                        employeeList && employeeList.map((obj) => (
                                            <option value={obj.employee_Id}> {obj.full_name} </option>
                                        ))
                                    }
                                </select>
                            </div>
                            <div className='flex my-2 col-sm-6 items-start gap-2'>
                                <label htmlFor="" className=' sm:w-2/5 ' > Reason for Review </label>
                                <textarea name="invitation_reason" onChange={handleChange} rows={5} placeholder='write a reason for the employee appraisal....'
                                    className='sm:w-3/5 outline-none inputbg text-sm rounded p-2 '
                                    value={employee.invitation_reason} id=""></textarea>

                            </div>
                            <div className=' my-2 col-sm-12 items-start gap-2'>
                                <label htmlFor="" className=' sm:w-2/5 ' > Email to Employee </label>
                                <ReactQuill value={employee.mail} onChange={(con) => setEmployee((prev) => ({
                                    ...prev,
                                    mail: con
                                }))} className='my-2 inputbg '/>

                            </div>
                            <div className=' my-2 col-sm-12 items-start gap-2'>
                                <label htmlFor="" className=' sm:w-2/5 ' > Email to Reporting Manager </label>
                                <ReactQuill value={employee.reporting_mail_content}
                                    onChange={(content) => setEmployee((prev) => ({
                                        ...prev,
                                        reporting_mail_content: content
                                    }))} className='my-2 inputbg' />
                            </div>
                        </section>
                        <button disabled={loading} onClick={sendRequest} className='bg-blue-600 text-white p-2 px-3 rounded flex ms-auto'>
                            {loading ? 'Loading' : "Send"}
                        </button>

                    </Modal.Body>

                </Modal>
            }

        </div >
    )
}

export default HRrequestPage