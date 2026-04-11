import React, { useEffect, useState } from 'react'
import InputFieldform from '../SettingComponent/InputFieldform';
import { port } from '../../App';
import axios from 'axios';
import { toast } from 'react-toastify';

const RecuirementCrud = ({ cid, getData, setshow, rid, rdata }) => {
    let [loading, setLoading] = useState(false)
    let [jobDetails, setJobDetails] = useState({
        job_title: '',
        job_location: '',
        required_skills: '',
        qualification: '',
        open_positions: '',
        experience_min: '',
        experience_max: '',
        package_min: '',
        package_max: '',
        hiring_start_date: '',
        hiring_end_date: '',
        client: cid,
        job_description: '',
        added_by: JSON.parse(sessionStorage.getItem('dasid'))
    })
    let [errorMsg, setErrorMsg] = useState({})
    let reset = () => {
        setJobDetails({
            job_title: '',
            job_location: '',
            required_skills: '',
            qualification: '',
            open_positions: '',
            experience_min: '',
            experience_max: '',
            package_min: '',
            package_max: '',
            hiring_start_date: '',
            hiring_end_date: '',
            client: cid,
            job_description: '',
            added_by: JSON.parse(sessionStorage.getItem('dasid'))
        })
    }
    useEffect(() => {
        if (rdata)
            setJobDetails(rdata)
    }, [rdata])
    let handleJobDetails = (e) => {
        let { name, value } = e.target
        if (name == 'hiring_end_date' && jobDetails.hiring_start_date && value < jobDetails.hiring_start_date)
            value = jobDetails.hiring_start_date
        if (name == 'hiring_start_date' && jobDetails.hiring_end_date && value > jobDetails.hiring_end_date)
            value = jobDetails.hiring_end_date
        setJobDetails((prev) => ({
            ...prev,
            [name]: value
        }))
        if (errorMsg[name]) {
            setErrorMsg({ ...errorMsg, [name]: undefined });
        }
    }
    let requiredFileds = ['job_title', 'qualification']
    let validateForm = () => {
        let newErrorMsg = {}
        requiredFileds.forEach((val) => {
            if (!jobDetails[val]?.trim()) {
                newErrorMsg[val] = `* This field is required`
            }
        })
        setErrorMsg(newErrorMsg)
        return Object.keys(newErrorMsg).length == 0
    }
    let postData = () => {
        if (validateForm())
            axios.post(`${port}/root/cms/add-clients-requirements`, jobDetails).then((response) => {
                console.log(response.data);
                reset()
                if (getData)
                    getData()
                if (setshow)
                    setshow(false)
                toast.success('Requirement has been added')
            }).catch((error) => {
                console.log(error);
                toast.error('Error occured')
            })
    }
    let updateData = async () => {
        setLoading('update')
        if (validateForm())
            axios.patch(`${port}/root/cms/add-clients-requirements?id=${rid}`, jobDetails).then((response) => {
                toast.success('Updated successfully')
                console.log(response.data, 'update');

            }).catch((error) => {
                console.log(error, 'update');

                toast.error('Error Occured')
            })
        setLoading(false)
    }
    let [dynamicsFields, setDynamicFields] = useState({})
    useEffect(() => {
        setDynamicFields({
            job_location: { type: '', css: '', inputcss: '', show: true, label: 'Job Location', placeholder: 'Banglore' },
            qualification: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Qualification', placeholder: 'B.E' },
            required_skills: { type: '', css: '', inputcss: '', show: true, label: 'Required skill ', placeholder: 'Java , SpringBoot' },
            experience_max: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Exp Max', placeholder: '3', limit: 50 },
            experience_min: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Exp Min', placeholder: '2', limit: 50 },
            package_max: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Package Max', placeholder: '400000', limit: 9999999999 },
            package_min: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Package Min', placeholder: '200000', limit: 9999999999 },
            hiring_end_date: { type: 'date', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Hiring end date ', placeholder: '' },
            hiring_start_date: { type: 'date', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Hirind start date', placeholder: '' },
            open_positions: { type: '', css: 'col-6 col-sm-4 col-lg-2', inputcss: '', show: true, label: 'Opening positions', placeholder: '25', limit: 500 },
            job_description: { type: 'textarea', css: 'col-12 order-2 ', inputcss: '', show: true, label: 'Job Description', placeholder: '' },
            job_title: { type: '', css: '', inputcss: '', show: true, label: 'Job Title', placeholder: 'Web Developer' },
        })
    }, [])
    useEffect(() => {
        if (cid) {
            setJobDetails((prev) => ({
                ...prev,
                client: cid
            }))
        }
    }, [cid])

    return (
        <div className='px-2 ' >
            <main className='bg-white row rounded py-3 ' >
                {
                    dynamicsFields &&
                    Object.keys(jobDetails).map((field) => {
                        let inputField = dynamicsFields[field]
                        console.log(inputField);
                        return (
                            inputField && inputField.show &&
                            <InputFieldform errormsg={errorMsg[field]} required={requiredFileds.some((val) => val == field)} label={inputField.label} type={inputField.type} size={inputField.css}
                                name={field} value={jobDetails[field]} limit={inputField.limit}
                                handleChange={handleJobDetails} placeholder={inputField.placeholder} />
                        )
                    })
                }
                <div className='flex order-3 ' >
                    {rid && <button onClick={updateData} className='bluebtn p-2 rounded ms-auto ' >
                        {loading == 'update' ? "Loading.." : "Update"}
                    </button>}
                    {!rid && <button onClick={postData} className='bluebtn p-2 rounded ms-auto ' >
                        Submit
                    </button>
                    }
                </div>
            </main>
        </div>
    )
}

export default RecuirementCrud