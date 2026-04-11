import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import InputFieldform from '../SettingComponent/InputFieldform'
import { toast } from 'react-toastify'

const CandidateJoiningFormCrud = ({ inid, setshow }) => {
    let [formData, setFormData] = useState({
        client_interview: inid,
        joining_date: null,
        remarks: null,
        CTC: null,
        due_date: null,
        gst_percentage: null,
        commisition_percentage: null,
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormData((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let [loading, setLoading] = useState(false)
    let [dynamicField, setDynamicField] = useState({})
    let reset = () => {
        setFormData({
            client_interview: inid,
            joining_date: '',
            remarks: '',
            CTC: '',
            due_date: '',
            gst_percentage: '',
            commisition_percentage: '',
        })
    }
    useEffect(() => {
        setDynamicField({
            joining_date: { type: 'date', label: 'Joining Date', css: 'col-12', show: true },
            remarks: { type: 'textarea', label: 'Remarks', css: ' col-12 order-2', show: true },
            CTC: { type: '', label: 'CTC', css: 'col-12 ', show: true },
            due_date: { type: 'date', label: 'Due Date (Payment) ', css: 'col-12 ', show: true },
            gst_percentage: { type: '', label: 'GST percentage ', css: 'col-12', show: true },
            commisition_percentage: { type: '', label: 'Commission Percentage', css: 'col-12', show: true },
        })
    }, [])
    let postForm = () => {
        setLoading(true)
        console.log(formData, 'field23');
        axios.post(`${port}/root/cms/client-joining/`, formData).then((response) => {
            reset()
            console.log(response.data);
            setLoading(false)
            toast.success('Data has been uploaded')
            if (setshow)
                setshow(false)
        }).catch((error) => {
            setLoading(false)
            toast.error('Error occured')
            console.log(error);
        })
    }

    return (
        <div>
            <main className='container row bg-white rounded  ' >
                {
                    Object.keys(formData).map((field) => {
                        let fieldCredentials = dynamicField[field]
                        console.log(fieldCredentials, 'field');

                        return (
                            fieldCredentials && fieldCredentials.show &&
                            <InputFieldform label={fieldCredentials.label} type={fieldCredentials.type} value={formData[field]}
                                name={field} handleChange={handleChange} size={fieldCredentials.css} />
                        )
                    }
                    )
                }
                <div className=' order-3' >
                    <button onClick={() => postForm()} className='bluebtn p-2 text-sm rounded my-2 ' >
                        {loading ? 'Loading...' : 'Submit'}
                    </button>
                </div>
            </main>
        </div>
    )
}

export default CandidateJoiningFormCrud