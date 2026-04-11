import React, { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'

const JFPersonalForm = ({ id, page, data }) => {
    let navigate = useNavigate()
    let { religion, getReligion } = useContext(HrmStore)
    let [formObj, setFormObj] = useState({
        blood_group: null,
        fathers_name: null,
        marital_status: null,
        marriage_date: null,
        spouse_name: null,
        nationality: null,
        residential_status: null,
        place_of_birth: null,
        country_of_origin: null,
        religion: null,
        international_employee: null,
        physically_challenged: null
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
            UpdateData()
        }
        else
            axios.post(`${port}/root/ems/employee-personal-information/${data.id}/`, formObj).then((response) => {
                console.log(response.data);
                getData()
            }).catch((error) => {
                console.log(error);
            })
    }
    let UpdateData = () => {
        axios.patch(`${port}/root/ems/update-employee-personal-information/${formObj.id}/`, formObj).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/employee-personal-information/${data.id}/`).then((response) => {
                console.log("get", response.data);
                setFormObj(response.data)
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    useEffect(() => {
        getData()
        getReligion()
    }, [data])
    return (
        <div className='inputbg p-3 rounded '>
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EMPLOYEE PERSONAL INFORMATION </h5>
            <main className='bg-white row p-3'>
                 {/* <InputFieldform disabled={page} placeholder='AB+' label="Blood Group" value={formObj.blood_group} handleChange={handleChange}
                    name='blood_group' type='text' /> */}
                    {/* <InputFieldform disabled={page} placeholder='David ' label="Father Name" value={formObj.fathers_name} handleChange={handleChange}
                        name='fathers_name' type='text' /> */}
                 <InputFieldform disabled={page} placeholder=' ' label="Marital Status" options={['Single', 'Married', 'Widowed', 'Divorced']} value={formObj.marital_status} handleChange={handleChange}
                    name='marital_status' type='text' />
                {(formObj.marital_status == 'Married' || formObj.marital_status == 'Widowed') &&
                     <InputFieldform disabled={page} placeholder=' ' label="Marriage Date" value={formObj.marriage_date} handleChange={handleChange}
                        name='marriage_date' type='date' />}
                {(formObj.marital_status == 'Married' || formObj.marital_status == 'Widowed') &&
                     <InputFieldform disabled={page} placeholder='Damon ' label="Spouse Name" value={formObj.spouse_name} handleChange={handleChange}
                        name='spouse_name' type='text' />}
                 <InputFieldform disabled={page} placeholder=' Indian' label="Nationality" value={formObj.nationality} handleChange={handleChange}
                    name='nationality' type='text' />
                 <InputFieldform disabled={page} placeholder='Home ' label="Residential Status" value={formObj.residential_status} handleChange={handleChange}
                    name='residential_status' type='text' />
                 <InputFieldform disabled={page} placeholder='TamilNadu ' label="Place Of Birth" value={formObj.place_of_birth} handleChange={handleChange}
                    name='place_of_birth' type='text' />
                 <InputFieldform disabled={page} placeholder='India ' label="Country Of Origin" value={formObj.country_of_origin} handleChange={handleChange}
                    name='country_of_origin' type='text' />

                <div className='col-md-6 col-lg-4'>
                    <label htmlFor="" className='form-label'>Religion</label>
                    <select disabled={page} value={formObj.religion} onChange={handleChange}
                        className='p-2 block rounded bgclr w-full outline-none shadow-none  ' name="religion" id="">
                        <option value="">Select</option>
                        {religion && religion.map((obj) => (
                            <option value={obj.id}> {obj.religion_name} </option>
                        ))}
                    </select>
                </div>
                <div className='col-md-6 col-lg-4'>
                    <label htmlFor="" className='form-label'>International Employee</label>
                    <select disabled={page} value={formObj.international_employee} onChange={handleChange}
                        className='p-2 block rounded bgclr w-full outline-none shadow-none  ' name="international_employee" id="">
                        <option value="">Select</option>
                        <option value={true}>Yes</option>
                        <option value={false}>No</option>
                    </select>
                </div>
                <div className='col-md-6 col-lg-4'>
                    <label htmlFor="" className='form-label'>Physically Challenged</label>
                    <select disabled={page} value={formObj.physically_challenged} onChange={handleChange}
                        className='p-2 block rounded bgclr w-full outline-none shadow-none  ' name="physically_challenged" id="">
                        <option value="">Select</option>
                        <option value={true}>Yes</option>
                        <option value={false}>No</option>
                    </select>
                </div>


            </main>
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/last_position_held`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/empl_info`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFPersonalForm