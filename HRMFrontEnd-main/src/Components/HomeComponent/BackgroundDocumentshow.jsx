import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { CloseButton, Modal } from 'react-bootstrap'
import { domain, port } from '../../App'
import { useNavigate, useParams } from 'react-router-dom'
import Topnav from '../Topnav'
import { toast } from 'react-toastify'

const BackgroundDocumentid = () => {
    let { id } = useParams()
    let [objform, setObj] = useState()
    let [mailModal, setMailModal] = useState(false)
    let [mailobj, setMailObj] = useState({
        option: '',
        email: '',
        mailContent: `Dear Sir/Madam , \n Please check the below link to BG verification \n `,
        altemail: ''
    })
    let [loading, setloading] = useState(false)
    let navigate = useNavigate()
    let handleMailObj = (e) => {
        let { name, value } = e.target
        if (name == 'email' && value != 'other') {
            setMailObj((prev) => ({
                ...prev,
                altemail: ''
            }))
        }
        setMailObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let resetMail = () => {
        setMailObj({
            option: '',
            email: '',
            mailContent: `Dear Sir/Madam , \n Please check the below link to BG verification \n `,
            altemail: ''
        })
        setMailModal(false)
    }
    useEffect(() => {
        axios.get(`${port}/root/DocumentsUploadedList/${id}/`).then((response) => {
            setObj(response.data)
            console.log("list", response.data);
        }).catch((error) => {
            console.log(error);
        })
    }, [id])
    let handleVerification = () => {
        if (mailobj.option == 'yourself') {
            window.open(`/BgverificationForm/${id}/${mailModal.id}`, '_blank')
        }
        else if (mailobj.option == 'mail') {
            setloading(true)
            axios.post(`${port}/root/BG_VerificationMailSend/`, {
                FormURL: `${domain}/BgverificationForm/${id}/${mailModal.id}`,
                message: mailobj.mailContent,
                CandidateID: id,
                to_mail: mailobj.altemail != '' ? mailobj.altemail : mailobj.email,
            }).then((response) => {
                console.log(response.data);
                toast.success('Mail Sended')
                setloading(false)
                resetMail()
            }).catch((error) => {
                console.log(error);
                setloading(false)
                toast.error('Error acquired')
            })

        }
        else {
            toast.warning('Select the Option')
        }
    }
    return (
        <div>
            <Topnav name='Background Document Verification' />
            <main className='poppins'>
                <section>
                    <div className='flex gap-3 my-3'>
                        <p className='mb-0 fw-semibold'> Candidate Id : <span className='text-slate-500' >{id} </span> </p>
                        <p className='mb-0 fw-semibold '>Candidate Name :  <span className='text-slate-500' >{objform && objform.length > 0 && objform[0].Name} </span></p>
                    </div>
                </section>
                <section className='tablebg h-[70vh] pt-0 pe-0 table-responsive'>
                    <table className='w-full pe-0'>
                        <tr>
                            <th>SI NO</th>
                            <th>Previous Company</th>
                            <th>Previous Designation </th>
                            <th>Experience</th>
                            <th>From date</th>
                            <th>To date</th>
                            <th>CTC </th>
                            <th>Reporting manager Name</th>
                            <th>Reporting manager Email</th>
                            <th>Reporting manager Phone</th>
                            <th>HR Name</th>
                            <th>HR Email</th>
                            <th>HR Phone </th>
                            <th>Document Uploded </th>
                            <th>Salary</th>
                            <th className='sticky right-0 bgclr1'>Action </th>
                        </tr>
                        {
                            objform && [...objform].map((obj, index) => (
                                <tr>
                                    {console.log(obj)
                                    }
                                    <td>{index + 1} </td>
                                    <td>{obj.Provious_Company} </td>
                                    <td>{obj.Provious_Designation} </td>
                                    <td>{obj.experience} </td>
                                    <td>{obj.from_date} </td>
                                    <td>{obj.To_date} </td>
                                    <td>{obj.Current_CTC} </td>
                                    <td>{obj.Reporting_Manager_name}</td>
                                    <td> {obj.Reporting_Manager_email}</td>
                                    <td>{obj.ReportingManager_phone} </td>
                                    <td>{obj.HR_name}</td>
                                    <td>{obj.HR_email} </td>
                                    <td>{obj.HR_phone}</td>
                                    <td> <a href={obj.Document} download>
                                        {obj.Document ? "Download" : "Not Uploaded"}</a> </td>
                                    <td><a href={obj.Salary_Drawn_Payslips} download >
                                        {obj.Salary_Drawn_Payslips ? " Download " : "Not Uploaded"} </a>  </td>
                                    <td className='sticky right-0 bgclr1 '> {obj.BG_Virification_status != 'Completed' &&
                                        <button onClick={() => {
                                            // window.open(`/BgverificationForm/${id}/${obj.id}`, '_blank')
                                            setMailModal(obj)
                                        }}
                                            className='btngrd p-1 text-xs rounded text-white  '> Verify </button>}
                                        {obj.BG_Virification_status == 'Completed' &&
                                            <button onClick={() => navigate(`/dash/bgverificationDetails/${obj.id}`)}
                                                className='savebtn p-1 text-xs rounded text-white ' >
                                                Verified
                                            </button>} </td>
                                </tr>
                            ))
                        }
                    </table>
                </section>

            </main>
            <Modal centered show={mailModal} onHide={() => resetMail()}>
                <Modal.Header closeButton>
                    Background Verification Method
                </Modal.Header>
                <Modal.Body>
                    <div className='flex my-2 items-center justify-between '>
                        Choose Verification Option
                        <select name="option" value={mailobj.option} onChange={handleMailObj} className='outline-none sm:w-1/2 rounded bgclr p-1' id="">
                            <option value="">select</option>
                            <option value="mail">Previous Company</option>
                            <option value="yourself">Ourself</option>
                        </select>
                    </div>
                    {mailobj.option == 'mail' &&
                        <>
                            <div className='flex my-2 items-center justify-between '>
                                Enter the mail
                                <select value={mailobj.email} name='email' onChange={handleMailObj}
                                    type="mail" className='outline-none sm:w-1/2 rounded bgclr p-1' >
                                    <option value="">Select</option>
                                    <option value={mailModal.Reporting_Manager_email}>
                                        Reporting Manager mail ({mailModal.Reporting_Manager_email}) </option>
                                    <option value={mailModal.HR_email}>HR mail ({mailModal.HR_email}) </option>
                                    <option value="other">Other</option>
                                </select>

                            </div>
                            {mailobj.email == 'other' &&
                                <input type="email" placeholder='enter the mail' onChange={handleMailObj}
                                    value={mailobj.altemail} name='altemail'
                                    className='w-1/2 outline-none sm:w-1/2 rounded bgclr p-1 ms-auto flex' />
                            }
                        </>}
                    {mailobj.option == 'mail' &&
                        <div className='flex my-2 items-center justify-between '>
                            Mail content
                            <textarea value={mailobj.mailContent} name='mailContent' onChange={handleMailObj}
                                rows={5} className='outline-none sm:w-1/2 rounded bgclr p-1' />
                        </div>}

                    <button onClick={handleVerification} disabled={loading} className='ms-auto my-2 p-2 bg-blue-600 text-white rounded flex '>
                        {loading ? 'Loading..' : mailobj.option == 'yourself' ? 'Verify' : "Send"}
                    </button>
                </Modal.Body>
            </Modal>

        </div>
    )
}

export default BackgroundDocumentid