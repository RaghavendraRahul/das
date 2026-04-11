import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFAdditionalINfo = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        EMP_Information: data.id,
        marital_ineptness: null,
        court_proceeding: null,
        language_known: null,
        hobbies: null,
        intrests: null,
        goals_or_aims: null,
        three_principles: null,
        strengths1: null,
        strengths2: null,
        strengths3: null,
        three_principles1: null,
        three_principles2: null,
        three_principles3: null,

        weaknesses1: null,
        weaknesses2: null,
        weaknesses3: null,

        in_india: null,
        in_abroad: null,
        state_restrictions: null,
        passport_num: null,
        validate: null,
        employee_relation: null,
        association: null,
        publication: null,
        specialized_training: null
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let saveData = () => {
        console.log(formObj);
        if (formObj.id) {
            UpdateData()
        }
        else
            axios.post(`${port}/root/ems/additional-information/${data.id}/`, formObj).then((response) => {
                console.log(response.data);
                getData()
            }).catch((error) => {
                console.log(error);
            })
    }
    let UpdateData = () => {
        axios.patch(`${port}/root/ems/update-additional-information/${formObj.id}/`, formObj).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/additional-information/${data.id}/`).then((response) => {
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
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>Additional Information </h5>

            <main className='p-3 bg-white rounded row ' >
                <p className='col-12'> Have you : </p>
                <InputFieldform disabled={page} label='(1) Marital Ineptness' value={formObj.marital_ineptness} name='marital_ineptness'
                    handleChange={handleChange} options={['yes', 'no']} />
                <InputFieldform disabled={page} label='(2) Been Involved in Court Proceeding' value={formObj.court_proceeding} name='court_proceeding'
                    handleChange={handleChange} options={['yes', 'no']} />
                <InputFieldform disabled={page} label='Languages known' value={formObj.language_known} name='language_known'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Your Hobbies' value={formObj.hobbies} name='hobbies'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Your Interests' value={formObj.intrests} name='intrests'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='Your Goal / Aim In Life' value={formObj.goals_or_aims} name='goals_or_aims'
                    handleChange={handleChange} type='text' />


                <p className='col-12'>Three Principles / Ideals Which Have Guided You In Life </p>
                <InputFieldform disabled={page} label='1.' value={formObj.three_principles1} name='three_principles1'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='2.' value={formObj.three_principles2} name='three_principles2'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} label='3.' value={formObj.three_principles3} name='three_principles3'
                    handleChange={handleChange} type='text' />

                <p className='col-12'>List Down Three Of </p>
                <section className='col-sm-6 border-2 rounded-lg rounded-e-none my-2 p-3 border-white'>
                    <p className='text-center ' > Your strengths </p>
                    <InputFieldform disabled={page} label="1." value={formObj.strengths1} name='strengths1'
                        type='text' handleChange={handleChange} size='col-12' />
                    <InputFieldform disabled={page} label="2." value={formObj.strengths2} name='strengths2'
                        type='text' handleChange={handleChange} size='col-12' />
                    <InputFieldform disabled={page} label="3." value={formObj.strengths3} name='strengths3'
                        type='text' handleChange={handleChange} size='col-12' />

                </section>
                <section className='col-sm-6 border-2 rounded-lg my-2 rounded-s-none p-3 border-white'>
                    <p className='text-center ' > Your Weakness </p>
                    <InputFieldform disabled={page} label="1." value={formObj.weaknesses1} name='weaknesses1'
                        type='text' handleChange={handleChange} size='col-12' />
                    <InputFieldform disabled={page} label="2." value={formObj.weaknesses2} name='weaknesses2'
                        type='text' handleChange={handleChange} size='col-12' />
                    <InputFieldform disabled={page} label="3." value={formObj.weaknesses3} name='weaknesses3'
                        type='text' handleChange={handleChange} size='col-12' />
                </section>
                <h5>Willingness to travel  </h5>
                <InputFieldform disabled={page} label='In India' value={formObj.in_india} name='in_india'
                    handleChange={handleChange} type='text' options={['yes', 'no']} />
                <InputFieldform disabled={page} label='In Abroad' value={formObj.in_abroad} name='in_abroad'
                    handleChange={handleChange} type='text' options={['yes', 'no']} />
                   <div className='col-12'></div>
                <InputFieldform disabled={page} label='State Restrictions / Problems If Any' value={formObj.state_restrictions} name='state_restrictions'
                    handleChange={handleChange} type='text' />
               

                <InputFieldform disabled={page} label='Are you realted to any of our employee ? If yes his / her Name'
                    value={formObj.employee_relation} name='employee_relation'
                    handleChange={handleChange} type='text' size='col-lg-6' />



                <InputFieldform disabled={page} label='Membership of any professional institution / Association'
                    value={formObj.association} name='association'
                    handleChange={handleChange} type='text' size='col-lg-6' />
                <InputFieldform disabled={page} label='Publication if any '
                    value={formObj.publication} name='publication'
                    handleChange={handleChange} type='text' size='col-lg-6' />
                <InputFieldform disabled={page} label='Any specialized Training / Training program attended'
                    value={formObj.specialized_training} name='specialized_training'
                    handleChange={handleChange} type='text' size='col-lg-6' />


            </main>

            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/pf_details`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/attachment`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFAdditionalINfo