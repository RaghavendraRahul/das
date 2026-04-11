import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFBankAcctDetails = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        EMP_Information: data && data.id,
        bank_name: '',
        account_no: '',
        ifsc: '',
        branch: '',
        branch_address: '',
        account_proof: '',
        Holder_Name: ''
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        if (name == 'account_proof') {
            value = files[0]
        }
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getBranch = () => {
        axios.get(`https://bank-apis.justinclicks.com/API/V1/IFSC/${formObj.ifsc}/`).then((response) => {
            console.log(response.data);
            setFormObj((prev) => ({
                ...prev,
                branch: response.data.BRANCH,
                bank_name: response.data.BANK,
                branch_address: response.data.ADDRESS

            }))
        }).catch((error) => {
            console.log(error);
            setFormObj((prev) => ({
                ...prev,
                branch: '',
                bank_name: '',
                branch_address: ''

            }))
        })
    }
    useEffect(() => {
        if (formObj.ifsc != '') {
            getBranch()
        }
    }, [formObj.ifsc])
    let saveData = () => {
        if (formObj.id) {
            UpdateData()
        }
        else {
            const formData = new FormData()
            formData.append('EMP_Information', formObj.EMP_Information)
            formData.append('account_no', formObj.account_no)
            formData.append('account_proof', formObj.account_proof)
            formData.append('bank_name', formObj.bank_name)
            formData.append('branch', formObj.branch)
            formData.append('ifsc', formObj.ifsc)
            formData.append('branch_address', formObj.branch_address)
            formData.append('Holder_Name', formObj.Holder_Name)

            console.log(formObj);

            axios.post(`${port}/root/ems/bank-account-details/${data && data.id}/`, formData).then((response) => {
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
        formData.append('account_no', formObj.account_no)
        formData.append('account_proof', formObj.account_proof)
        formData.append('bank_name', formObj.bank_name)
        formData.append('branch', formObj.branch)
        formData.append('ifsc', formObj.ifsc)
        formData.append('branch_address', formObj.branch_address)
        formData.append('Holder_Name', formObj.Holder_Name)


        console.log(formObj);
        axios.patch(`${port}/root/ems/update-bank-account-details/${formObj.id}/`, formData).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/bank-account-details/${data && data.id}/`).then((response) => {
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
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>Bank Account Details</h5>
            <main className='row bg-white p-3 rounded '>
                <InputFieldform disabled={page} placeholder='BOI234420BS ' label='IFSC' value={formObj.ifsc} name='ifsc'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} placeholder='7220134250234 ' label='Account Number' value={formObj.account_no} name='account_no'
                    handleChange={handleChange} type='text' limit={9999999999999999} />
                <InputFieldform placeholder='Name according to Bank Passbook ' label='Full Name' value={formObj.Holder_Name} name='Holder_Name'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder='Kumbakonam ' disabled={true} label='Branch' value={formObj.branch} name='branch'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder='Bank of India' disabled={true} label='Bank Name' value={formObj.bank_name} name='bank_name'
                    handleChange={handleChange} type='text' />
                <InputFieldform disabled={page} placeholder=' ' label='Bank Proof' name='account_proof' link={formObj.account_proof}
                    handleChange={handleChange} type='file' />
                <InputFieldform placeholder='Bank Address' disabled={true} label='Bank Address' value={formObj.branch_address} name='branch_address'
                    handleChange={handleChange} type='textarea' />


            </main>
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => {
                    saveData();
                    navigate(`/Employeeallform/${id}/empl_info`)
                }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => {
                    saveData();
                    navigate(`/Employeeallform/${id}/pf_details`)
                }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>

            </section>}

        </div>
    )
}

export default JFBankAcctDetails