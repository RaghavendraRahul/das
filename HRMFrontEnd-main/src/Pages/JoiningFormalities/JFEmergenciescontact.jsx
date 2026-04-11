import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { port } from '../../App'
import axios from 'axios'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'

const JFEmergenciescontact = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        person_name: '',
        phone: '',
        email: '',
        relation: '',
        city: '',
        state: '',
        country: '',
        pincode: '',
        address: '',
        landline:''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let saveData = () => {
        if (formObj.id) {
            updateData()
        }
        else {
            axios.post(`${port}/root/ems/emergency-contact/${data.id}/`, formObj).then((res) => {
                console.log("CONTACT_PERSON_EMERGENCY_RES", res.data);
            }).catch((err) => {
                console.log("CONTACT_PERSON_EMERGENCY_ERR", err.data);
            })
        }
    }
    let updateData = () => {
        axios.patch(`${port}/root/ems/update-emergency-contact/${formObj.id}/`, formObj).then((response) => {
            getData();
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/emergency-contact/${data.id}/`).then((response) => {
                setFormObj(response.data)
                console.log(response.data);
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
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>Contact person in case of emergency</h5>
            <main className='row bg-white rounded p-3 '>
                <InputFieldform disabled={page} label="Name" placeholder='Parthiban' name='person_name' value={formObj.person_name}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="Mobile No" placeholder='897867****' name='phone' value={formObj.phone}
                    type='text' limit={9999999999} handleChange={handleChange} />
                     <InputFieldform disabled={page} label="Landline No" placeholder='420024**' name='landline' value={formObj.landline}
                    type='text' limit={9999999999999} handleChange={handleChange} />
                <InputFieldform disabled={page} label="Email" placeholder='parthi@gmail.com' name='email' value={formObj.email}
                    type='email' handleChange={handleChange} />
                <InputFieldform disabled={page} label="Relation" name='relation' placeholder='Brother' value={formObj.relation}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="Address Line 1" name='address' placeholder='34/5 , Sri Venkateswara nagar' value={formObj.address}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="City" name='city' placeholder='salem' value={formObj.city}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="State" name='state' placeholder='Tamilnadu' value={formObj.state}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="Country" name='country' placeholder='India' value={formObj.country}
                    type='text' handleChange={handleChange} />
                <InputFieldform disabled={page} label="Pincode" name='pincode' placeholder='627006' value={formObj.pincode}
                    type='text' handleChange={handleChange} limit={999999} />


            </main>
            {/* <button className='' onClick={saveData} >
                Save
            </button> */}
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/med`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/ref_form`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFEmergenciescontact