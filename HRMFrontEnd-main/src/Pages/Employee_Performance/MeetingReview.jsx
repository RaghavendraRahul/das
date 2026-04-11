import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import EmployeeUpdate from '../../Components/Employee/EmployeeUpdate'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import AppraisalOffer from '../../Components/Employee/AppraisalOffer'

const MeetingReview = () => {
    let { id } = useParams()
    let [showTab, setshowtab] = useState('MR')
    let [meetingReview, setMeetingReview] = useState({
        EmployeeSelfEvaluation: '',
        Meeting_Date: '',
        Meetting_reviewed_by: '',
        Comments_Feedback: '',
        Performance_Achived: '',
        Goals_for_Next_Period: '',
        Strengths: '',
        Areas_for_Improvement: '',
        Potential_Development_Opportunities: '',
        Responsible_Parties: '',
    })
    let [empid, setEmp] = useState()
    let handleMeetingReview = (e) => {
        let { name, value } = e.target
        setMeetingReview((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let postData = () => {
        axios.patch(`${port}/root/lms/PerformanceMetrics/`, meetingReview).then((response) => {
            console.log("hellow", response.data);
            toast.success('Form submitted')
            getData()
        }).catch((error) => {
            toast.error('Error Acquired')
            console.log("hellow", error);
        })
    }
    let getData = () => {
        if (id) {
            axios.get(`${port}/root/lms/PerformanceMetrics/?self_app_id=${id}`).then((response) => {
                console.log("hellow", response.data);
                setMeetingReview(response.data)
                setEmp(response.data.Emp_info_Id)
            }).catch((error) => {
                console.log("hellow", error);
            })
        }
    }
    useEffect(() => {
        getData()
    }, [id])
    return (
        <div className='poppins'>
            {showTab == 'MR' && <main className='p-4 container bg-white rounded text-sm mx-auto'>
                <h4 className='text-center'>Meeting Review  </h4>
                <section className='formbg p-4 row my-3 rounded '>
                    <InputFieldform label='Meeting Date' type={'date'}
                        value={meetingReview.Meeting_Date && meetingReview.Meeting_Date.slice(0, 10)}
                        name='Meeting_Date' placeholder='comment on the meeting' handleChange={handleMeetingReview} />
                    <InputFieldform label='Achievements Satisfaction ' type={'text'} options={['Excellent', 'Verygood', 'Good', 'Fair', 'Poor']}
                        value={meetingReview.Performance_Achived}
                        name='Performance_Achived' placeholder='achievements so for any..' handleChange={handleMeetingReview} />

                    <InputFieldform label='Goals for the next period' type={'textarea'} value={meetingReview.Goals_for_Next_Period}
                        name='Goals_for_Next_Period' placeholder='explain abt future goals' handleChange={handleMeetingReview} />


                    <InputFieldform label='Potential Development for company' type={'textarea'} value={meetingReview.Potential_Development_Opportunities}
                        name='Potential_Development_Opportunities' placeholder='presence of employee how helps company?? ' handleChange={handleMeetingReview} />

                    <InputFieldform label='Area for improvements' type={'textarea'} value={meetingReview.Areas_for_Improvement}
                        name='Areas_for_Improvement' placeholder='is there any improvement need in employee? ' handleChange={handleMeetingReview} />

                    <InputFieldform label='Meeting Summary' type={'textarea'} value={meetingReview.Comments_Feedback}
                        name='Comments_Feedback' placeholder='give a short note on meeting' handleChange={handleMeetingReview} />

                    <InputFieldform label='Area of Strength ' type={'textarea'} value={meetingReview.Strengths}
                        name='Strengths' placeholder='sector good at?? ' handleChange={handleMeetingReview} />

                    <InputFieldform label='Future responsibility taken' type={'textarea'} value={meetingReview.Responsible_Parties}
                        name='Responsible_Parties' placeholder='Future responsibility taken on ' handleChange={handleMeetingReview} />
                </section>


                <button className='p-2 rounded text-white btngrd flex ms-auto ' onClick={() => {
                    postData()
                    setshowtab('EU')
                }}>
                    Next
                </button>

            </main>
            }

            {(showTab == 'EU' || showTab == 'AO') && <EmployeeUpdate showTab={showTab} setshowtab={setshowtab} id={empid} sid={id} />}




        </div>
    )
}

export default MeetingReview