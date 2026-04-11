import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'
import ReactQuill from 'react-quill'

const FinalStatus = (props) => {
    let { mailContent } = useContext(HrmStore)
    let { show, setshow, name, getfunction, rid } = props
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [loading, setLoading] = useState(false)
    let [obj, setObj] = useState({
        Final_Result: '',
        Comments: '',
        Email_Message: ``,
        mail_status: 'no',
        subject: ''
    })

    let handleSubmit = () => {
        console.log(obj.Email_Message.replace(/\\n/g, '\n'));
        console.log(obj);
        // return
        if (obj.Final_Result) {
            setLoading(true)
            axios.post(`${port}/root/FinalStatusUpdate`, {
                CandidateId: show,
                ReviewedBy: empid,
                mail_status: obj.mail_status,
                Final_Result: obj.Final_Result,
                Comments: obj.Comments,
                subject: obj.subject,
                Email_Message: obj.Email_Message,
                req_id: rid,
            }).then((response) => {
                console.log(response.data);
                setLoading(false)
                if (getfunction)
                    getfunction()
                toast.success('Final Result Submitted.')
                setObj({
                    Final_Result: '',
                    Comments: '',
                    Email_Message: ``
                })
                setshow(false)
            }).catch((error) => {
                console.log(error);
                setLoading(false)
            })
        }
        else {
            toast.warning('Give the final status for the interview')
        }
    }
    let handleChange = (e) => {
        let { value, name } = e.target
        setObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    useEffect(() => {
        if (obj.Final_Result) {
            let content;
            let subject;
            if (obj.Final_Result == 'Internal_Hiring') {
                content = mailContent.selected
                subject = `Update on Your Application`
            }
            if (obj.Final_Result == 'Reject') {
                content = mailContent.reject
                subject = `Update on Your Application`
            }
            if (obj.Final_Result == 'On_Hold') {
                content = mailContent.on_hold
                subject = `Update on Your Application`

            }
            if (obj.Final_Result == 'consider_to_client') {
                subject = `Update on Your Application`
                content = mailContent.consider_to_client
            }
            setObj((prev) => ({
                ...prev,
                subject: subject,
                Email_Message: `Dear ${name}, \n ${content} `
            }))
        }
    }, [obj.Final_Result])
    return (
        <div>
            {show && <Modal centered show={show} onHide={() => {
                setshow(false); setObj({
                    Final_Result: '',
                    Comments: '',
                    Email_Message: ``
                })
            }}>
                <Modal.Header closeButton>
                    Final Status for {name && name}
                </Modal.Header>
                <Modal.Body>
                    <main className=' '>
                        <div className='flex justify-between'>
                            <label className='w-52' htmlFor=""> Final Status :</label>
                            <select value={obj.Final_Result} name='Final_Result'
                                onChange={handleChange} className="p-2 w-full outline-none border-2 rounded " id="ageGroup" >
                                <option value="">Select</option>
                                {!rid && <option value="consider_to_client">Consider to Client for Merida </option>}
                                {!rid && <option value="Internal_Hiring"> Selected </option>}
                                {!rid && <option value="Reject">Reject</option>}
                                {!rid && <option value="On_Hold">On Hold</option>}
                                {!rid && <option value="Rejected_by_Candidate">Rejected by Candidate</option>}

                                {rid && <option value="client_offer_rejected">Offer Rejected By Candidate </option>}
                                {rid && <option value="client_kept_on_hold">Client Kept on Hold </option>}
                                {rid && <option value="client_rejected">Client Rejected</option>}
                                {rid && <option value="client_offered"> Client Offered </option>}
                                {rid && <option value="candidate_joined">Candidate Joined</option>}
                                {/* <option value="Offer_did_not_accept">Offerd Did't Accept</option> */}
                            </select>
                        </div>

                        <div className='flex justify-between items-center'>
                            <label className='w-52' htmlFor=""> Comment : </label>
                            <input value={obj.Comments} name='Comments' onChange={handleChange} type="text"
                                className='w-full outline-none border-2 rounded p-2 my-2 z-10 ' />
                        </div>

                        <div className='flex items-center ' >
                            <label className='w-52' htmlFor="">Have to send mail ? </label>
                            <section className='flex gap-2 items-center ' >
                                <div className='flex gap-2 items-center ' >

                                    <input type="radio" id='yesmail' checked={obj.mail_status == 'Yes'}
                                        onClick={() => setObj((prev) => ({
                                            ...prev,
                                            mail_status: 'Yes'
                                        }))} />
                                    <label htmlFor="yesmail">Yes </label>
                                </div>
                                <div className='flex gap-2 items-center ' >

                                    <input type="radio" id='nomail' checked={obj.mail_status != 'Yes'}
                                        onClick={() => setObj((prev) => ({
                                            ...prev,
                                            mail_status: 'No'
                                        }))} />
                                    <label htmlFor="nomail">No </label>
                                </div>
                            </section>
                        </div>
                        {obj.mail_status == 'Yes' && <div className='flex justify-between items-center'>
                            <label className='w-52' htmlFor="">Email Subject : </label>
                            <input value={obj.subject} name='subject' onChange={handleChange} type="text"
                                className='w-full outline-none border-2 rounded p-2 my-2 z-10 ' />
                        </div>}
                        {obj.mail_status == 'Yes' && 
                        <div className=' items-start justify-between '>
                            <label htmlFor="" className='' > Email Content :  </label>
                            <ReactQuill value={obj.Email_Message} className='rounded my-2 ' onChange={(value) => setObj((prev) => ({ ...prev, Email_Message: value }))} />
                        </div>
                        }

                    </main>
                </Modal.Body>
                <Modal.Footer>
                    <button onClick={handleSubmit} className='p-2 rounded bg-blue-600 text-white  '>
                        {loading ? "loading.." : " Submit"}
                    </button>
                </Modal.Footer>

            </Modal>}
        </div>
    )
}

export default FinalStatus