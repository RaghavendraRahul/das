import axios from 'axios';
import React, { useState, useEffect, useContext } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'
import '../assets/css/media.css'
import { HrmStore } from '../Context/HrmContext';
import ReactQuill from 'react-quill';

const Final_status_comment = ({ selectedName, selectstatus, fetchdata3,
    candidateid, final_status_value, setselectstatus, setfinalvalue }) => {
    useEffect(() => {
        console.log
            (selectstatus)
    }, [])
    let { mailContent } = useContext(HrmStore)
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [loading, setloading] = useState(false)
    const [statusreview, setStatusreview] = useState("")
    let [mailContentwritten, setMailContentwritten] = useState()
    let [subject, setSubject] = useState()
    let [sendStatus, setSendStatus] = useState(false)

    const navigate = useNavigate();
    useEffect(() => {
        console.log(selectedName);
        if (final_status_value && selectedName && selectstatus) {
            let content
            if (final_status_value == 'Internal_Hiring') {
                setSubject(`Congratulations! Offer for ${selectstatus.AppliedDesignation}`)
                setMailContentwritten(`Dear ${selectstatus.FirstName},
We are thrilled to inform you that you have been selected for the ${selectstatus.AppliedDesignation} role at
Merida! Congratulations on this achievement.

Next Steps:
Offer Letter: You will receive a formal offer letter with detailed terms and conditions via email shortly.
On-Boarding: Upon acceptance, we will provide you with additional information regarding the on-boarding process, including orientation details, required documents, and any other relevant information.


Contact Information:
If you have any questions or need further clarification regarding the offer or the on-boarding process, please do not hesitate to contact us.
Once again, congratulations and welcome to the team! We are excited about the skills and experience you will bring to (Your Company Name) and look forward to working with you.

Best regards,

HR TEAM
`)
            }
            if (final_status_value == 'Reject') {
                setSubject(`Update on Your Application for ${selectstatus.AppliedDesignation}`)
                setMailContentwritten(`
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <p>Dear <strong>${selectstatus.FirstName}</strong>,</p>

    <p>Thank you for taking the time to apply for the <strong>${selectstatus.AppliedDesignation}</strong> role at <strong>Merida</strong>. We appreciate your interest in our company and the effort you put into the interview process.</p>

    <p>After careful consideration and review, we regret to inform you that we have chosen to move forward with another candidate whose qualifications and experience more closely align with our current needs.</p>

    <p>We genuinely value your interest in <strong>(Your Company Name)</strong> and encourage you to apply for future openings that match your skills and career goals. We will keep your resume on file for potential opportunities that may arise.</p>

    <p>Thank you once again for considering a career with us. We wish you all the best in your future endeavors.</p>

    <p>Sincerely,</p>
    <p><strong>HR TEAM</strong></p>
</body>
`)
            }
            if (final_status_value == 'On_Hold') {
                setSubject(`Update on Your Application for ${selectstatus.AppliedDesignation}`)
                setMailContentwritten(`<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <p>Dear <strong> ${selectstatus.FirstName} </strong>,</p>

    <p>Thank you for your interest in the <strong> ${selectstatus.AppliedDesignation} </strong> role at <strong> Merida </strong> and for the time you have invested in the interview process.</p>

    <p>We wanted to provide you with an update on your application status. At this moment, we have decided to place your application on hold as we continue to review all potential candidates and finalize our selection process.</p>

    <h3 style="color: #4CAF50;">What This Means:</h3>

    <ul style="margin-left: 20px;">
        <li><strong>Review Status:</strong> Your application remains under active consideration, and we are continuing to assess it against the requirements of the role and other candidates.</li>
        <li><strong>Timeline:</strong> While we cannot provide a specific timeline at this point, we will keep you informed about any significant developments or changes in the status of your application.</li>
        <li><strong>Next Steps:</strong> Should we require any further information from you or wish to proceed with additional interviews, we will reach out to you directly.</li>
    </ul>

    <p>We appreciate your patience and understanding during this period. If you have any questions or need further clarification, please do not hesitate to contact us.</p>
    <p>Thank you once again for your interest in <strong>Merida</strong>. We will be in touch with you as soon as there is an update regarding your application.</p>
</body>`)
            }
            if (final_status_value == 'consider_to_client') {
                content = mailContent.consider_to_client
            }
        }
    }, [selectedName, final_status_value, selectstatus])

    let handlestatusreview = (e) => {
        e.preventDefault();
        // console.log(statusreview,candidateid);


        const formData1 = new FormData()

        formData1.append('Final_Result', final_status_value);
        formData1.append('CandidateId', candidateid);
        formData1.append('Comments', statusreview);
        formData1.append('ReviewedBy', Empid);
        formData1.append('Email_Message', mailContentwritten.replace(/\\n/g, '\n'));
        formData1.append('subject', subject)
        formData1.append('mail_status', sendStatus ? 'Yes' : 'No')

        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        setloading(true)
        {
            axios.post(`${port}/root/FinalStatusUpdate`, formData1)
                .then((r) => {
                    setfinalvalue(final_status_value)
                    setloading(false)
                    fetchdata3()
                    alert("Final status comment send Successfull")
                    setStatusreview('')
                    setMailContentwritten(`Dear Candidate \n Congratulations!! \n  We are glad to inform you that you have successfully cracked at Merida Tech Minds.We consider you for Internal Hiring`)
                    // navi('/dashboard/HR')
                    console.log("statusreview_res", r.data)
                    setselectstatus(false)


                })
                .catch((err) => {
                    setloading(false)
                    console.log("statusreview_err", err)
                })
        }

    }





    return (
        <div style={{ position: 'fixed', left: '0px', top: '0px', width: '100%', zIndex: 5 }} className={`p-1 p-sm-4  otp-verification-container ${selectstatus ? '' : 'd-none'} `}>
            <div className='otp_verification'>
                <div className="modal-dialog">
                    <div className="modal-content">
                        <div className="modal-header border-bottom p-4" style={{ display: 'flex', justifyContent: 'space-between' }}>
                            <h1 className="modal-title fs-5" id="exampleModalLabel">Status Review</h1>
                            <button type="button" className="btn-close" onClick={() => { setselectstatus(false) }}  ></button>
                        </div>
                        <div className="modal-body border-bottom p-2">
                            <div className='d-flex justify-content-center'>

                                <textarea className='no-border border-0 ' placeholder='write here ...' name="" id="" style={{ width: '100%' }}
                                    value={statusreview} onChange={(e) => setStatusreview(e.target.value)} ></textarea>
                            </div>
                        </div>

                        {/* Mail cotent */}
                        {(final_status_value == 'Reject' ||
                            final_status_value == 'On_Hold' ||
                            final_status_value == 'Internal_Hiring')
                            && <main >
                                <div>
                                    Wanna send a mail ?
                                    <div className='flex items-center gap-2 ' >
                                        Yes <div onClick={() => setSendStatus(!sendStatus)} className={`${sendStatus ? 'bg-green-200 ' : 'bg-red-200'} w-10 relative 
                                         duration-500 border-2 rounded-full h-5  `} >
                                            <button className={`w-4 ${sendStatus ? 'translate-x-[1px] ' : 'translate-x-[18px] '}
                                             duration-500 absolute rounded-full h-4  bg-white  `}>
                                            </button>
                                        </div>
                                        No
                                    </div>
                                </div>
                                {sendStatus && <section>
                                    <div className='my-2 ' >
                                        Mail subject :
                                        <input type="text" value={subject} onChange={(e) => setSubject(e.target.value)}
                                            className='block w-full outline-none border-2 rounded p-2 my-2 ' />

                                    </div>
                                    <div>
                                        <label htmlFor="" className='my-3'> Mail Content :
                                            <span className='text-blue-600 text-xs '> ( Use \n to insert the Line in the mail )
                                            </span>
                                        </label>
                                        <div className='h-[40vh] overflow-y-scroll ' >

                                            <ReactQuill className=' ' value={mailContentwritten} onChange={setMailContentwritten} />
                                        </div>
                                        {/* <textarea name=""
                                         value={mailContentwritten} 
                                         className='outline-none border-2 rounded p-2 block w-full ' 
                                         rows={5} onChange={(e) => setMailContentwritten(e.target.value)} id="">  </textarea> */}
                                    </div>
                                </section>}

                            </main>}
                        <div className="modal-footer p-3">
                            <button type="button" onClick={handlestatusreview} disabled={loading} className="btn btn-primary" > {loading ? "loading.." : "Send"} </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Final_status_comment;
