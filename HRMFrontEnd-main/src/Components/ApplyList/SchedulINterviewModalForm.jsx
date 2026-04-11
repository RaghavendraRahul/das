import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap';
import { domain, port } from '../../App';
import { toast } from 'react-toastify';
import { HrmStore } from '../../Context/HrmContext';

const SchedulINterviewModalForm = (props) => {
    let { show, fetchdata, setshow, fetchdata1, persondata,
        setPersondata, candidateId, setcandidateId, data, rid,
        fetchdata2 } = props
    console.log(show, 'interview');
    let [outsideMail, setOutSideMail] = useState()
    let [outsideINterview, setOutsideInterview] = useState(false)
    let [loading, setloading] = useState(false)
    let { changeDateYear, convertTimeTo12HourFormat, timeValidate } = useContext(HrmStore)
    const [formData, setFormData] = useState({
        Candidate: "",
        InterviewRoundName: '',
        TaskAssigned: '',
        interviewer: '',
        InterviewDate: '',
        InterviewTime: '',
        InterviewType: '',
        login_user: '',
        zoomLink: '',
        for_whom: rid ? 'client' : 'ours',
        assigned_requirement: rid,
    });
    let [sendStatus, setSendStatus] = useState(false)
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    const [Candidateid, setCandidate] = useState("")
    let [mailContent, setMailContent] = useState(``)

    // Define the function 
    const sentparticularData = (id) => {
        setCandidate(id)
        // Define the data to be sent in the request
        const dataToSend = {
            id: id // Assuming id is the parameter passed to the function
        };

        // Send a POST request using Axios
        axios.get(`${port}/root/appliedcandidate/${id}/`, dataToSend)
            .then(response => {
                // Handle the response if needed
                console.log('Data--:', response.data);
                setPersondata(response.data)
                setCandidate(response.data.CandidateId)
            })
            .catch(error => {
                // Handle errors if any
                console.error('Error sending data:', error);
            });
    };
    const handleInputChange = (e) => {
        let { name, value } = e.target;
        if (name == 'InterviewDate') {
            setMailContent(mailContent)
        }
        if (name == 'InterviewDate' && timeValidate() > value) {
            // alert(timeValidate())
            value = timeValidate()
        }
        setFormData({ ...formData, [name]: value });
    };
    const handleTimeInputChange = (e) => {
        setFormData({ ...formData, InterviewTime: e.target.value })
    }
    const handleSubmit = async (e) => {

        e.preventDefault();

        formData.Candidate = candidateId
        formData.login_user = Empid
        if (outsideMail) {
            formData.Other_EMP_Mail = outsideMail
            formData.review_form = `${domain}/interviewreview`
        }
        console.log("schedule_Interview",
            "formData", formData,
            "login_user", Empid);
        setloading(true)
        formData.mail_status = sendStatus ? 'Yes' : 'No'
        console.log(formData);
        if (!formData.assigned_requirement)
            delete formData.assigned_requirement
        console.log(formData, 'data');
        // return
        axios.post(`${port}/root/interviewschedule`, {
            ...formData,
            Email_Message: mailContent.replace(/\\n/g, '\n')
        }).then((res) => {
            toast.success("Interview schedule Successfully..")
            if (fetchdata) {
                fetchdata()
            }
            else {
                window.location.reload()
            }
            if (fetchdata2)
                fetchdata2()
            if (fetchdata1)
                fetchdata1()
            setloading(false)
            setFormData({
                Candidate: "",
                InterviewRoundName: '',
                TaskAssigned: '',
                interviewer: '',
                InterviewDate: '',
                InterviewTime: '',
                InterviewType: '',
                login_user: '',
                zoomLink: '',
                for_whom: rid ? 'client' : 'ours',
                assigned_requirement: rid,
            })
            setshow(false)
            console.log("schedule_Interview_Data_res", res.data);
        }).catch((err) => {
            setloading(false)
            toast.error('Error occured')
            console.log("schedule_Interview_Data_res_err", err);
        })
    };
    useEffect(() => {
        if (formData && show && (formData.InterviewTime || formData.InterviewDate || formData.zoomLink)) {
            setMailContent(`
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <p>Dear <strong> ${show.Candidate_name} </strong>,</p>

    <p>We are pleased to inform you that you have advanced to the next round of interviews for the
     <strong> ${show.Applied_Designation} </strong> role at 
     <strong> Merida </strong>.
    Congratulations!</p>

    <h3 style="color: #4CAF50;">Interview Details:</h3>
    <ul style="margin-left: 20px;">
        <li><strong>Date:</strong> ${formData.InterviewDate && changeDateYear(formData.InterviewDate)}.</li>
        <li><strong>Time:</strong>  ${formData.InterviewTime && convertTimeTo12HourFormat(formData.InterviewTime)}.</li>
       ${formData.InterviewType == 'online' ? `<li><strong>Location:</strong> ${formData.zoomLink} </li>  ` : ''}
    </ul>

    <h3 style="color: #4CAF50;">Preparation:</h3>
    <ul style="margin-left: 20px;">
        <li>Please review any specific materials, topics, or preparation guidelines, if applicable.</li>
        <li>If the interview is virtual, ensure that you have access to the specific platform (e.g., Zoom, Teams).</li>
    </ul>

    <p>Kindly acknowledge the above interview schedule.</p>

    <p>If you have any questions or need further information before the interview, please do not hesitate to reach out.</p>

    <p>Thank you for your continued interest in <strong> Merida </strong>. We look forward to speaking with you soon.</p>

    <p>Best regards,</p>
    <p><strong>HR TEAM</strong></p>
    </body>
         `)
        }
    }, [formData.InterviewTime, formData.InterviewDate, formData.zoomLink])
    useEffect(() => {
        sentparticularData()
        console.log(persondata);
    }, [persondata])
    const [interviewers, setInterviewers] = useState([]);
    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        })
        // sentparticularData()
    }, [])
    useEffect(() => {
        if (rid)
            setFormData((prev) => ({
                ...prev,
                InterviewRoundName: 'manager_round',
                for_whom: rid ? 'client' : 'ours',
                assigned_requirement: rid,
            }))
    }, [rid])
    return (
        <div>
            <Modal show={show} onHide={() => setshow(false)} >
                <Modal.Header closeButton>
                    <h1 class="modal-title fs-5" >Schedule Interview </h1>
                </Modal.Header>
                <Modal.Body className=' h-[80vh] overflow-y-scroll ' >
                    <form id="interviewForm" onSubmit={handleSubmit} class="styled-form">
                        <div class="form-group">
                            <label for="candidateId">Candidate ID:</label>
                            <input type="text" id="CandidateId" value={candidateId}
                                class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="InterviewRoundName">Interview Round Name:
                            </label>
                            <select id="InterviewRoundName" name="InterviewRoundName" disabled={rid} value={formData.InterviewRoundName} onChange={handleInputChange} required class="form-control">
                                <option value="" selected>Select Round</option>
                                <option value="ceo_round" >CEO Round</option>
                                <option value="hr_round" >HR Round</option>
                                <option value="manager_round" >{rid ? 'Client' : "Manager"} Round</option>
                                <option value="technical_round" >Technical Round </option>
                            </select>
                        </div>

                        {/* <div class="form-group">
                            <label for="taskAssign">Task Assign:</label>
                            <input type="text" id="TaskAssigned" name="TaskAssigned" value={formData.TaskAssigned} onChange={handleInputChange} required class="form-control" />
                        </div> */}
                        <div class="form-group">
                            <section className='flex justify-between my-2'>
                                <label for="interviewer">Interviewer:</label>
                                <article className='flex gap-2 items-center'>
                                    Consultant :
                                    <div type='button'
                                        onClick={() => {
                                            setOutsideInterview(!outsideINterview);
                                            setOutSideMail('')
                                            setFormData((prev) => ({
                                                ...prev,
                                                interviewer: ''
                                            }))
                                        }}
                                        className={`w-16 h-8 flex rounded-full  shadow-sm 
                                        ${outsideINterview ? 'bg-green-100' : 'bg-red-100'} bg-blue-100 `}>
                                        <p className={`w-6 ${outsideINterview ? 'translate-x-9 ' : 'translate-x-1'} h-6 my-auto m-0 duration-300 bg-white rounded-full shadow-sm `}> </p>
                                    </div>
                                </article>
                            </section>
                            {!outsideINterview && <select id="interviewer" name="interviewer" value={formData.interviewer} onChange={handleInputChange} required class="form-control">
                                <option value="" selected> Select Name </option>
                                {interviewers.map(interviewer => (
                                    <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                    </option>
                                ))}
                            </select>}
                            {outsideINterview && <input type="text" id="mailId" placeholder='Enter mail' value={outsideMail}
                                onChange={(e) => setOutSideMail(e.target.value)} class="form-control" />}
                        </div>
                        <div class="form-group">
                            <label for="interviewDate"> Interview Date : </label>
                            <input type="date" id="InterviewDate" name="InterviewDate" value={formData.InterviewDate}
                                onChange={handleInputChange} required class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="interviewTime"> Interview Time : </label>
                            <input type="time" id="InterviewTime" name="InterviewDTime" onChange={handleTimeInputChange} required class="form-control" />
                        </div>

                        <div class="form-group">
                            <label for="InterviewType"> Interview Type : </label>
                            <select id="InterviewType" name="InterviewType" value={formData.InterviewType} onChange={handleInputChange} required class="form-control">
                                <option value="" selected>Select Round</option>
                                <option value="online" >Online</option>
                                <option value="offline" >Offline</option>

                            </select>
                        </div>
                        {formData.InterviewType == 'online' && <div class="form-group">
                            <label for="candidateId">Link for online Interview :</label>
                            <input type="text" id="zoomLink" placeholder='Link for Interview'
                                name='zoomLink' onChange={handleInputChange}
                                value={formData.zoomLink}
                                class="form-control" />
                        </div>}
                        <div>
                            <label htmlFor="" className='my-3 flex items-center gap-2 '> Mail Content :
                                <div className='flex items-center gap-2 ' >
                                    Yes <div onClick={() => setSendStatus(!sendStatus)}
                                        className={`${sendStatus ? 'bg-green-200 ' : 'bg-red-200'} w-10 relative 
                                         duration-500 border-2 rounded-full h-5  `} >
                                        <span type='button' className={`w-4 ${sendStatus ? 'translate-x-[1px] ' : 'translate-x-[18px] '}
                                             duration-500 absolute rounded-full h-4  bg-white  `}>
                                        </span>
                                    </div>
                                    No
                                </div>
                            </label>
                            {sendStatus && <textarea name="" value={mailContent}
                                className='outline-none border-2 rounded p-2 block w-full ' rows={5}
                                onChange={(e) => setMailContent(e.target.value)} id="">  </textarea>}
                        </div>
                        <div class="form-group my-3 d-flex justify-content-between">
                            {/* <button class="btn btn-primary">Send Email</button> */}
                            <button disabled={loading} type="submit" class="btn ms-auto btn-success"> {loading ? "Loading" : "Schedule Interview"} </button>
                        </div>
                    </form>
                </Modal.Body>
            </Modal>






        </div>
    )
}

export default SchedulINterviewModalForm