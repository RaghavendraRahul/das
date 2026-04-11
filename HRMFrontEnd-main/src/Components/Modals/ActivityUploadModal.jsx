import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import InputFieldform from '../SettingComponent/InputFieldform'
import { css } from '@emotion/react'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'
import CloseIcon from '../Icons/CloseIcon'

const ActivityUploadModal = ({ show, setAid, getData, setshow, empid, aid }) => {
    let [activity, setActivity] = useState()
    let [loading, setLoading] = useState(false)
    let { getDesignations, designation, setTrigger } = useContext(HrmStore)
    let interviewStatusOptions = [
        { value: 'call_notpicked', label: 'Call Not Picked' },
        { value: 'dis_connect', label: 'Disconnect' },
        { value: 'will_revert_back', label: 'Will Revert Back' },
        { value: 'interview_scheduled', label: 'Interview Scheduled' },
        { value: 'walkin', label: 'Interview Attended' },
        { value: 'rejected', label: 'Rejected' },
        { value: 'Rejected_by_Candidate', label: 'Rejected by Candidate' },
        { value: 'to_client', label: 'Consider to Client' },
        { value: 'offer', label: 'Offer' },
    ]

    let clientStatusOptions = [
        { value: 'converted_to_client', label: 'Converted to client' },
        { value: 'closed', label: 'Closed' },
        { value: 'followup', label: 'Follow Up' },
    ]
    let [formData, setFormData] = useState(
        {
            Activity_instance: null,
            activity_list_id: null,
            position: null,
            source: null,
            url: null,
            job_post_remarks: null,

            candidate_name: null,
            candidate_phone: null,
            candidate_email: null,
            candidate_location: null,
            candidate_designation: null,
            other_designation: null,
            candidate_current_status: null,
            // fresher,experience
            candidate_experience: null,
            candidate_for: null,
            message_to_candidates: null,
            interview_status: null,
            interview_scheduled_date: null,
            interview_call_remarks: null,
            // New
            industries_worked: null,
            source: null,
            expected_ctc: null,
            current_ctc: null,
            DOJ: null,
            have_laptop: null,


            service_name: null,


            service_name: null,
            client_email: null,
            client_company_name: null,
            client_name: null,
            client_phone: null,
            client_enquire_purpose: null,
            domain_expertise: null,
            client_looking_for: null,
            client_spok: null,
            client_call_remarks: null,
            client_status: null,
            // Campaign
            college_visit: null,
            visit_date: null,
            // mail
            mail_sent: null,
            mail_count: null,
            service_name: null
        }
    )
    let [serviceName, setServiceName] = useState()
    let [dynamicCredentials, setDynamicCredentials] = useState({})
    let handleChange = (e) => {
        let { name, value } = e.target
        if (name == 'candidate_phone' && value?.length > 10) {
            return
        }
        else if (name == 'Activity_instance') {
            setFormData((prev) => ({
                ...prev,
                activity_list_id: activity.find((obj) => obj.activity_name == value)?.id,
                [name]: value
            }))
        }
        else
            setFormData((prev) => ({
                ...prev,
                [name]: value
            }))
    }
    let validate = () => {
        let count = 0
        Object.keys(formData).forEach((field) => {
            if (dynamicCredentials[field] && dynamicCredentials[field].required && dynamicCredentials[field].show && (formData[field] == null || formData[field] == '')) {
                count += 1
            }
        })
        if (formData.Activity_instance == 'interview_calls' && formData.interview_status == '') {
            count += 1
        } else
            return count == 0 ? true : false
    }
    useEffect(() => {
        setDynamicCredentials({
            // campaign activity


            Created_Date: { required: false, show: false, label: 'Created Date', css: null, inputcss: null, type: null },
            position: { required: false, show: formData.Activity_instance === 'job_posts', label: 'Position Posted', css: null, inputcss: null, type: null },
            source: { required: false, show: formData.Activity_instance === 'job_posts' || formData.Activity_instance == 'mails' || formData.Activity_instance === 'interview_calls', label: 'Source', css: null, inputcss: null, type: null },
            url: { required: false, show: formData.Activity_instance === 'job_posts', label: `Post's URL`, css: null, inputcss: null, type: null },
            job_post_remarks: { required: false, show: formData.Activity_instance === 'job_posts', label: 'Remark', css: 'col-12 order-2', inputcss: null, type: 'textarea' },
            Activity_instance: {
                required: false, show: true, label: 'Activity Category', css: null, inputcss: null, type: null,
                options: [
                    ...(activity?.map((obj) => ({
                        label: obj.activity_name
                            ?.replace(/_/g, " ")
                            .replace(/\b\w/g, (char) => char.toUpperCase()),
                        value: obj.activity_name
                    })) || []) // Fallback to an empty array if activity is undefined or null
                ]
            },
            candidate_name: { required: true, show: formData.Activity_instance === 'interview_calls', label: 'Candidate Name', css: null, inputcss: null, type: null },
            candidate_phone: { required: true, show: formData.Activity_instance === 'interview_calls', label: 'Candidate Phone', css: null, inputcss: null, type: null },
            candidate_email: { required: true, show: formData.Activity_instance === 'interview_calls', label: 'Candidate Email', css: null, inputcss: null, type: null },
            candidate_location: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Candidate Location', css: null, inputcss: null, type: null },
            candidate_designation: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Designation', css: null, inputcss: null, type: null, options: designation?.map((obj) => ({ value: obj.Name, label: obj.Name }))?.concat({ value: 'other', label: 'Other' }) },
            other_designation: { required: false, show: formData.Activity_instance === 'interview_calls' && formData.candidate_designation == 'other', label: 'Other designation', css: null, inputcss: null, type: null },
            // New
            industries_worked: { required: false, show: formData.Activity_instance === 'interview_calls' && formData.candidate_current_status == 'experience', label: 'Industries Worked', css: null, inputcss: null, type: null },
            expected_ctc: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Expected CTC', css: null, inputcss: null, type: null },
            current_ctc: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Current CTC', css: null, inputcss: null, type: null },
            DOJ: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Date of Joining', type: 'date', css: null, inputcss: null, },
            have_laptop: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Able to bring laptop', css: null, inputcss: null, type: null, options: [{ value: true, label: 'Yes' }, { value: false, label: 'No' }, { value: null, label: 'Can arrange' }] },
            candidate_for: { required: false, show: formData.Activity_instance === 'interview_calls' && formData.candidate_current_status == 'fresher', label: 'Candidate for (OJT/Internal Hiring)', css: null, inputcss: null, type: null, options: [{ value: 'OJT', label: 'OJT' }, { value: 'Internal_Hiring', label: 'Internal Hiring' }] },
            candidate_current_status: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Fresher/Experience', css: null, inputcss: null, type: null, options: [{ value: 'fresher', label: 'Fresher' }, { value: 'experience', label: 'Experience' }] },
            candidate_experience: { required: false, show: formData.Activity_instance === 'interview_calls' && formData.candidate_current_status == 'experience', label: 'Experience', css: null, inputcss: null, type: null },
            message_to_candidates: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Message Sent to Candidate', css: null, inputcss: null, type: null },
            interview_status: { required: true, show: formData.Activity_instance === 'interview_calls', label: 'Candidate Status', css: 'order-2 col-md-6 col-lg-4 ', inputcss: null, type: null, options: interviewStatusOptions },
            interview_scheduled_date: { required: false, show: formData.Activity_instance === 'interview_calls' && formData.interview_status == 'interview_scheduled', label: 'Interview Scheduled Date', css: null, inputcss: null, type: 'date' },

            interview_call_remarks: { required: false, show: formData.Activity_instance === 'interview_calls', label: 'Interview Call Remark', css: 'col-12 order-2', inputcss: null, type: 'textarea' },
            client_status: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Status', css: null, inputcss: null, type: null, options: clientStatusOptions },
            client_name: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Name', css: null, inputcss: null, type: null },
            client_company_name: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Organization', css: null, inputcss: null, type: null },
            client_email: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Email', css: null, inputcss: null, type: 'email' },
            client_phone: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Phone', css: null, inputcss: null, type: null },
            client_enquire_purpose: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Purpose', css: null, inputcss: null, type: null },
            domain_expertise: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Domain Expertise', css: null, inputcss: null, type: null },
            client_looking_for: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Looking for', css: null, inputcss: null, type: null },
            client_spok: { required: false, show: formData.Activity_instance === 'client_calls', label: `Client's Spoke`, css: '', inputcss: null, type: '' },
            client_call_remarks: { required: false, show: formData.Activity_instance === 'client_calls', label: 'Client Remarks', css: 'col-12 order-2', inputcss: null, type: 'textarea' },


            service_name: { show: false },
            // Campaign
            college_visit: { required: false, show: formData.Activity_instance === 'campaign', label: 'College/Institution Name', css: '', inputcss: null, type: null },
            visit_date: { required: false, show: formData.Activity_instance === 'campaign', label: 'Visited Date', css: '', inputcss: null, type: 'date' },
            // mail
            mail_sent: { required: false, show: formData.Activity_instance === 'mails', label: 'Mail Sent for (reason)', css: '', inputcss: null, type: null },
            mail_count: { required: false, show: formData.Activity_instance === 'mails', label: 'Mail sended count', css: '', inputcss: null, type: null },
        });
    }, [formData.Activity_instance, designation, formData.candidate_designation,
    formData.interview_status, formData.candidate_current_status, activity]);
    let getActivity = () => {
        axios.get(`${port}/root/activity-list/assigned/${empid ? empid : JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, 'yyyy');
            setActivity(response.data)

        }).catch((error) => {
            console.log(error);
        })
    }
    let reset = () => {
        setFormData({
            Activity_instance: null,
            activity_list_id: null,
            position: null,
            source: null,
            url: null,
            job_post_remarks: null,

            candidate_name: null,
            candidate_phone: null,
            candidate_email: null,
            candidate_location: null,
            candidate_designation: null,
            other_designation: null,
            candidate_current_status: null,
            // fresher,experience
            candidate_experience: null,
            candidate_for: null,
            message_to_candidates: null,
            interview_status: null,
            interview_scheduled_date: null,
            interview_call_remarks: null,
            // New
            industries_worked: null,
            source: null,
            expected_ctc: null,
            current_ctc: null,
            DOJ: null,
            have_laptop: null,


            service_name: null,


            service_name: null,
            client_email: null,
            client_company_name: null,
            client_name: null,
            client_phone: null,
            client_enquire_purpose: null,
            domain_expertise: null,
            client_looking_for: null,
            client_spok: null,
            client_call_remarks: null,
            client_status: null,
            // Campaign
            college_visit: null,
            visit_date: null,
            // mail
            mail_sent: null,
            mail_count: null,
            service_name: null
        })
    }
    let postActivity = async () => {
        if (formData.interview_scheduled_date == null)
            delete formData.interview_scheduled_date
        if (formData.other_designation)
            formData = {
                ...formData,
                candidate_designation: formData.other_designation
            }
        console.log(formData, 'yeah');
        setLoading('save')
        if (formData.service_name == null)
            delete formData.service_name
        if (validate())
            await axios.post(`${port}/root/create-daily-achieved-activity?login_emp_id=${empid ? empid : JSON.parse(sessionStorage.getItem('dasid'))}`, formData).then((response) => {
                console.log(response.data, 'result');
                setshow(false)
                setLoading(false)
                reset()
                if (getData)
                    getData()
                toast.success('Created Successfully')
            }).catch((error) => {
                console.log(error, formData);
                setLoading(false)
                toast.warning('Error occured')
            })
        else
            toast.warning('Fill the required fields')
        setLoading(false)
        setTrigger((prev) => !prev)
    }
    let getParticulatActivity = () => {
        // Backend developer using the patch method for the get uhhh
        axios.patch(`${port}/root/create-daily-achieved-activity?achieved_act_id=${aid}`).then((response) => {
            console.log(response.data, 'getdata');
            setFormData({ ...response.data, interview_scheduled_date: response.data?.interview_scheduled_date?.slice(0, 10) })

        }).catch((error) => {
            console.log(error, 'getdata');
        })
    }
    let updateParticularActivity = async () => {
        console.log(formData, 'getdata');

        setLoading('edit')
        if (validate())
            await axios.patch(`${port}/root/create-daily-achieved-activity/${aid}`, formData).then((response) => {
                toast.success('Update successfully')
                // setFormData(response.data)
                if (getData)
                    getData()
                setLoading(false)
            }).catch((error) => {
                console.log(error, 'getdata');
                setLoading(false)
                toast.error('Error Occured')
            })
        else
            toast.warning('Enter the required fields')
        setLoading(false)
    }
    useEffect(() => {
        getActivity()
        getDesignations()
        if (aid)
            getParticulatActivity()
    }, [empid, aid])
    return (
        <div>
            {(show || aid) &&
                <Modal show={show || aid} onHide={() => {
                    setshow(false);
                    reset()
                    if (setAid)
                        setAid(false)
                }} centered size='xl' >
                    <Modal.Header closeButton >
                        Activity Sheet {formData.activity_list_id}
                    </Modal.Header>
                    <Modal.Body className='  ' >
                        <main className='row  ' >
                            {
                                Object.keys(formData).map((field) => {
                                    let inputField = dynamicCredentials[field]
                                    return (
                                        inputField && inputField.show &&
                                        <InputFieldform size={inputField.css} name={field} value={formData[field]}
                                            label={inputField.label} type={inputField.type} required={inputField.required && inputField.show}
                                            optionObj={inputField.options ? inputField.options : false}
                                            handleChange={handleChange} />
                                    )
                                })
                            }
                            {
                                formData.Activity_instance == 'client_calls' &&
                                <section className='col-sm-4 ' >
                                    Service
                                    <article className=' inputbg p-2 rounded  my-2 '  >
                                        <input type="text" onKeyDown={(e) => {
                                            if (e.key === "Enter") {
                                                e.preventDefault(); // Prevent default form submission behavior
                                                let service = e.target.value.trim();
                                                console.log(service);

                                                if (service) {
                                                    setFormData((prev) => ({
                                                        ...prev,
                                                        service_name: [...(prev.service_name || []), service],
                                                    }));
                                                    e.target.value = ""; // Clear input field after adding
                                                }
                                            }
                                        }} className='outline-none w-full bg-transparent ' />
                                        {/* COntents */}
                                        <section className='flex gap-2 items-center flex-wrap' >
                                            {
                                                formData.service_name &&
                                                formData.service_name.map((val) => (
                                                    <div className='rounded-full flex gap-2 items-center 
                                                 p-1 bg-white w-fit text-sm px-2 ' >
                                                        {val}
                                                        <button onClick={() => {
                                                            setFormData((prev) => ({
                                                                ...prev,
                                                                service_name: [...formData.service_name].filter((value) => value != val)
                                                            }))
                                                        }} className=' ' >
                                                            <CloseIcon size={14} />
                                                        </button>
                                                    </div>
                                                ))
                                            }
                                        </section>
                                    </article>
                                </section>
                            }
                            <div className='flex order-3 ' >
                                {!aid && <button disabled={loading == 'save'}
                                    onClick={postActivity} className='rounded p-2 bluebtn ms-auto  ' >
                                    {loading == 'save' ? "Loading..." : "Submit"}
                                </button>}
                                {aid && <button disabled={loading == 'edit'}
                                    onClick={updateParticularActivity} className='rounded p-2 bluebtn ms-auto  ' >
                                    {loading == 'edit' ? "Loading..." : "Update"}
                                </button>}
                            </div>
                        </main>

                    </Modal.Body>
                </Modal>
            }

        </div>
    )
}

export default ActivityUploadModal