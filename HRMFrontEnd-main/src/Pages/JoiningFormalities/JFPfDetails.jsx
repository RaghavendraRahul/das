import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFPfDetails = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        EMP_Information: data.id,
        employee_is_covered_under_pf: null,
        uan: '',
        pf: '',
        pf_join_date: '',
        family_pf_no: '',
        is_existing_number_of_eps: '',
        allow_epf_excess_contribution: '',
        allow_eps_excess_contribution: ''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        if (value == 'true')
            value = true
        if (value == 'false')
            value = false
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
            axios.post(`${port}/root/ems/pf-details/${data.id}/`, formObj).then((response) => {
                console.log(response.data);
                getData()
            }).catch((error) => {
                console.log(error);
            })
    }
    let UpdateData = () => {
        axios.patch(`${port}/root/ems/update-pf-details/${formObj.id}/`, formObj).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/pf-details/${data.id}/`).then((response) => {
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
        <div className='input p-3 rounded '>
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>PF Details</h5>
            <main className='p-3 bg-white rounded row'>
                <InputFieldform disabled={page} placeholder=' ' name='employee_is_covered_under_pf' label='Employee Is Covered Under PF' value={formObj.employee_is_covered_under_pf}
                    handleChange={handleChange} type='text' optionObj={[{ value: true, label: 'Yes' }, { value: false, label: 'No' }]} />
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder='123421345 ' name='uan' label='UAN' value={formObj.uan}
                        handleChange={handleChange} type='text' />}
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder='PF number ' name='pf' label='PF No' value={formObj.pf}
                        handleChange={handleChange} type='text' />}
                {/* {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder='If fmaily has a pf Number ' name='family_pf_no' label='Family PF No' value={formObj.family_pf_no}
                        handleChange={handleChange} type='text' />} */}
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder='PF joining date ' name='pf_join_date' label='PF join date' value={formObj.pf_join_date}
                        handleChange={handleChange} type='date' />}
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder=' ' name='is_existing_number_of_eps' label='Is Existing Number Of EPS' value={formObj.is_existing_number_of_eps}
                        handleChange={handleChange} type='text' optionObj={[{ value: true, label: 'Yes' }, { value: false, label: 'No' }]} />}
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder=' ' name='allow_epf_excess_contribution' label='Allow EPF Excess Contribution' value={formObj.allow_epf_excess_contribution}
                        handleChange={handleChange} type='text' optionObj={[{ value: true, label: 'Yes' }, { value: false, label: 'No' }]} />}
                {(formObj.employee_is_covered_under_pf) &&
                    <InputFieldform disabled={page} placeholder=' ' name='allow_eps_excess_contribution' label='Allow EPS Excess Contribution' value={formObj.allow_eps_excess_contribution}
                        handleChange={handleChange} type='text' optionObj={[{ value: true, label: 'Yes' }, { value: false, label: 'No' }]} />}

            </main>
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/bank_details`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/additional_info`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}

        </div>
    )
}

export default JFPfDetails