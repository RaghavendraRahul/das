import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { port } from '../../App'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'

const JFMedical = ({ data, id, page }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        blood_group: '',
        allergic_to: '',
        blood_pessure: '',
        Diabetics: '',
        other_illness: ''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let saveData = (e) => {

        if (formObj.id) {
            update()
        }
        else {
            axios.post(`${port}/root/ems/emergency-details/${data.id}/`, formObj).then((res) => {
                console.log("EMERGENCY_DETAILS_RES", res.data);
            }).catch((err) => {
                console.log("EMERGENCY_DETAILS_ERR", err.data);
            })
        }
    }
    let update = () => {
        axios.patch(`${port}/root/ems/update-emergency-details/${formObj.id}/`, formObj).then((response) => {
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/emergency-details/${data.id}/`).then((response) => {
                console.log(response.data);
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
        <div className='inputbg p-3 rounded '>
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>MEDICAL DETAILS</h5>
            <main className='bg-white my-2 row p-3'>
                <InputFieldform disabled={page} label='Blood Group' placeholder='AB+' handleChange={handleChange} type='text'
                    name='blood_group' value={formObj.blood_group} />
                <InputFieldform disabled={page} label='Allergic To' placeholder='Shell Fish' handleChange={handleChange} type='text'
                    name='allergic_to' value={formObj.allergic_to} />
                <InputFieldform disabled={page} label='Blood Pressure' placeholder='190 ' handleChange={handleChange} type='text'
                    name='blood_pessure' value={formObj.blood_pessure} />
                <InputFieldform disabled={page} label='Diabetics' placeholder='320' handleChange={handleChange} type='text'
                    name='Diabetics' value={formObj.Diabetics} />
                <InputFieldform disabled={page} placeholder='Last year had a operation' label='Any Other Illness That Needs To Be Disclosed' handleChange={handleChange} type='text'
                    name='other_illness' value={formObj.other_illness} />

            </main>
            {/* <button className='' onClick={saveData} >
                Save
            </button> */}
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/fm-form`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/emergency_form`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}

        </div>
    )
}

export default JFMedical