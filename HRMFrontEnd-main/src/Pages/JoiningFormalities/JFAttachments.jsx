import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFAttachments = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        EMP_Information: data.id,
        Degree_mark_sheets: null,
        Offer_letter_copy: null,
        permanent_address_proof: null,
        present_address_proof: null,
        upload_photo: null
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: files[0]
        }))
    }
    let saveData = () => {
        if (formObj.id) {
            UpdateData()
        }
        else {
            const formData = new FormData()
            if (formObj.Degree_mark_sheets) {
                formData.append('Degree_mark_sheets', formObj.Degree_mark_sheets)
            }
            if (formObj.Offer_letter_copy) {
                formData.append('Offer_letter_copy', formObj.Offer_letter_copy)
            }
            if (formObj.permanent_address_proof) {
                formData.append('permanent_address_proof', formObj.permanent_address_proof)
            }
            if (formObj.present_address_proof) {
                formData.append('present_address_proof', formObj.present_address_proof)
            }
            if (formObj.upload_photo) {
                formData.append('upload_photo', formObj.upload_photo)
            }
            axios.post(`${port}/root/ems/attachments/${data.id}/`, formData).then((response) => {
                console.log(response.data);
                getData()
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let UpdateData = () => {
        const formData = new FormData()
        if (formObj.Degree_mark_sheets) {
            formData.append('Degree_mark_sheets', formObj.Degree_mark_sheets)
        }
        if (formObj.Offer_letter_copy) {
            formData.append('Offer_letter_copy', formObj.Offer_letter_copy)
        }
        if (formObj.permanent_address_proof) {
            formData.append('permanent_address_proof', formObj.permanent_address_proof)
        }
        if (formObj.present_address_proof) {
            formData.append('present_address_proof', formObj.present_address_proof)
        }
        if (formObj.upload_photo) {
            formData.append('upload_photo', formObj.upload_photo)
        }
        axios.patch(`${port}/root/ems/update-attachments/${formObj.id}/`, formData).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/attachments/${data.id}/`).then((response) => {
                console.log("get", response.data);
                setFormObj(response.data)
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    useEffect(() => {
        getData()
    }, [data])

    return (
        <div className='p-3 rounded inputbg '>
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>attachments </h5>
            <main className='bgclr p-3 rounded '>
                <p className='fw-semibold '>Please attach : </p>
                <ol className='list-decimal ' start={1} >
                    <li className=' '>Photocopies of all relevant certificates / Degree mark sheets etc.</li>
                    <li>Appointment / Offer letter of previous your Employeement</li>
                    <li>Permanent Address Proof </li>
                    <li>Present of address proof</li>
                    {/* <li>Photocopy of ID proof</li> */}
                    <li>Passport size photograph</li>
                </ol>
                <section className='bg-white p-3 rounded row '>
                    <p className='fw-semibold col-12 '>Select your Files </p>
                    <InputFieldform disabled={page} label='Degree mark sheets etc' link={formObj.Degree_mark_sheets} name='Degree_mark_sheets'
                        handleChange={handleChange} type='file' />
                    <InputFieldform disabled={page} label='Offer letter / Appointment Letter ' link={formObj.Offer_letter_copy} name='Offer_letter_copy'
                        handleChange={handleChange} type='file' />
                    <InputFieldform disabled={page} label='Permanent Address proof' link={formObj.permanent_address_proof} name='permanent_address_proof'
                        handleChange={handleChange} type='file' />
                    <InputFieldform disabled={page} label='Present address proof ' link={formObj.present_address_proof} name='present_address_proof'
                        handleChange={handleChange} type='file' />
                    <InputFieldform disabled={page} accept='image/*' label='Passport size photograph' link={formObj.upload_photo} name='upload_photo'
                        handleChange={handleChange} type='file' />

                </section>


            </main>

            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/additional_info`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/document`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFAttachments