import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFIdentityForm = ({ id, page, data }) => {
    let navigate = useNavigate()
    const [formObj, setFormObj] = useState({
        EMP_Information: data.id,
        aadhar_no: '',
        name_as_per_aadhar: '',
        aadher_proof: '',
        pan_no: '',
        pan_proof: '',
        passport_num: '',
        passport_proof: '',
        validate: '',
        driving_license: '',
        voter_id: ''
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        if (name == 'aadher_proof' || name == 'pan_proof' || name == 'passport_proof') {
            value = files[0]
        }
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let saveData = () => {
        if (formObj.id) {
            UpdateData()
        }
        else {
            const formData = new FormData()
            formData.append('EMP_Information', formObj.EMP_Information)
            formData.append('aadhar_no', formObj.aadhar_no)
            { formObj.aadher_proof && formData.append('aadher_proof', formObj.aadher_proof) }
            formData.append('name_as_per_aadhar', formObj.name_as_per_aadhar)
            formData.append('pan_no', formObj.pan_no)
            { formObj.pan_proof && formData.append('pan_proof', formObj.pan_proof) }
            { formObj.passport_proof && formData.append('passport_proof', formObj.passport_proof) }
            formData.append('passport_num', formObj.passport_num)
            formData.append('validate', formObj.validate)
            formData.append('voter_id', formObj.voter_id)
            formData.append('driving_license', formObj.driving_license)


            console.log(formObj);
            axios.post(`${port}/root/ems/employee-identity/${data.id}/`, formData).then((response) => {
                console.log(response.data);
                getData()
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let UpdateData = () => {
        const formData = new FormData()
        formData.append('EMP_Information', formObj.EMP_Information)
        formData.append('aadhar_no', formObj.aadhar_no)
        formData.append('aadher_proof', formObj.aadher_proof)
        formData.append('name_as_per_aadhar', formObj.name_as_per_aadhar)
        formData.append('pan_no', formObj.pan_no)
        formData.append('pan_proof', formObj.pan_proof)
        formData.append('passport_proof', formObj.passport_proof)
        formData.append('passport_num', formObj.passport_num)
        formData.append('validate', formObj.validate)
        formData.append('voter_id', formObj.voter_id)
        formData.append('driving_license', formObj.driving_license)

        axios.patch(`${port}/root/ems/update-employee-identity/${formObj.id}/`, formData).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/employee-identity/${data.id}/`).then((response) => {
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
        <div className='p-3 inputbg rounded '>
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}> Employee Identity Form</h5>
            <main className='p-3 bg-white rounded row '>
                <h5 className=' text-xl ' >Aadhar details </h5>
                <InputFieldform disabled={page} label='Driving License' placeholder='' value={formObj.driving_license} name='driving_license'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Voter ID' placeholder='' value={formObj.voter_id} name='voter_id'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Aadhar Number' limit={999999999999} placeholder='724578963452' value={formObj.aadhar_no} name='aadhar_no'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Name As Per Aadhar' placeholder='David' value={formObj.name_as_per_aadhar} name='name_as_per_aadhar'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Aadhar Proof' name='aadher_proof' link={formObj.aadher_proof}
                    handleChange={handleChange} type='file' />
                <h5 className=' text-xl ' >Pan Details </h5>

                <InputFieldform disabled={page} label='Pan Number' placeholder='BTX1Z4353' value={formObj.pan_no} name='pan_no'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Pan Proof' name='pan_proof' link={formObj.pan_proof}
                    handleChange={handleChange} type='file' />
                <h5 className=' text-xl ' >Passport Details </h5>
                <InputFieldform disabled={page} label='Passport No' value={formObj.passport_num} name='passport_num'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Passport Valid upto date' value={formObj.validate} name='validate'
                    handleChange={handleChange} type='date' />
                <InputFieldform disabled={page} label='Passport Proof' name='passport_proof' link={formObj.passport_proof}
                    handleChange={handleChange} type='file' />
            </main>
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/personal_info`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/bank_details`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>

            </section>}
        </div>
    )
}

export default JFIdentityForm