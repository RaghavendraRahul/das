import React, { useContext, useEffect, useState } from 'react'
import InputFieldform from '../SettingComponent/InputFieldform'
import axios from 'axios'
import JFBankAcctDetails from '../../Pages/JoiningFormalities/JFBankAcctDetails'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'

const EmployeeSalaryAdding = ({ id, emp, setpage }) => {
    let { getTemplate, templates, } = useContext(HrmStore)
    // const [bankDetails, setBankDetails] = useState({

    // })
    let [salary_changes, setSalaryChanges] = useState()
    let [templateObj, settemplateObj] = useState({
        salary_template: '',
        employee_id: '',
        id: ''
    })
    let [bankDetails, setbankDetails] = useState({
        EMP_Information: id,
        bank_name: '',
        account_no: '',
        ifsc: '',
        branch: '',
        branch_address: '',
        account_proof: null,
        Holder_Name: ''
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        if (name == 'account_proof') {
            value = files[0]
        }
        setbankDetails((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let handleChangeTemplate = (e) => {
        let { name, value } = e.target
        settemplateObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getBranch = () => {
        axios.get(`https://bank-apis.justinclicks.com/API/V1/IFSC/${bankDetails.ifsc}/`).then((response) => {
            console.log(response.data);
            setbankDetails((prev) => ({
                ...prev,
                branch: response.data.BRANCH,
                bank_name: response.data.BANK,
                branch_address: response.data.ADDRESS

            }))
        }).catch((error) => {
            console.log(error);
            setbankDetails((prev) => ({
                ...prev,
                branch: '',
                bank_name: '',
                branch_address: ''

            }))
        })
    }
    const [salary_template, setSalary_Template] = useState()
    useEffect(() => {
        if (bankDetails.ifsc != '') {
            getBranch()
        }
        // console.log(emp.employee_Id);
    }, [bankDetails.ifsc])
    let saveData = () => {
        postSalary()
        if (bankDetails.id) {
            UpdateData()
        }
        else {
            const formData = new FormData()
            formData.append('EMP_Information', bankDetails.EMP_Information)
            formData.append('account_no', bankDetails.account_no)
            if (bankDetails.account_proof) {
                formData.append('account_proof', bankDetails.account_proof)
            }
            formData.append('bank_name', bankDetails.bank_name)
            formData.append('branch', bankDetails.branch)
            formData.append('ifsc', bankDetails.ifsc)
            formData.append('branch_address', bankDetails.branch_address)
            formData.append('Holder_Name', bankDetails.Holder_Name)

            console.log(bankDetails);

            axios.post(`${port}/root/ems/bank-account-details/${id}/`, formData).then((response) => {
                console.log(response.data);
                particularchange(emp.employee_Id, templateObj.salary_template || templateObj.id)
                toast.success('Employee Updated')
                getData()
            }).catch((error) => {
                console.log(error);
                toast.error('Error acquired')
            })
        }
    }
    let UpdateData = () => {
        const formData = new FormData()
        formData.append('EMP_Information', bankDetails.EMP_Information)
        formData.append('account_no', bankDetails.account_no)

        if (bankDetails.account_proof) {
            formData.append('account_proof', bankDetails.account_proof)
        }
        formData.append('bank_name', bankDetails.bank_name)
        formData.append('branch', bankDetails.branch)
        formData.append('ifsc', bankDetails.ifsc)
        formData.append('branch_address', bankDetails.branch_address)
        formData.append('Holder_Name', bankDetails.Holder_Name)

        console.log(bankDetails);
        axios.patch(`${port}/root/ems/update-bank-account-details/${bankDetails.id}/`, formData).then((response) => {
            console.log(response.data);
            getData()
            particularchange(emp.employee_Id, templateObj.salary_template)

            toast.success('Employee Updated')
        }).catch((error) => {
            console.log(error);
            toast.error('Error acquires')
        })
    }
    let getData = () => {
        if (id) {
            axios.get(`${port}/root/ems/bank-account-details/${id}/`).then((response) => {
                console.log("get", response.data);
                setbankDetails(response.data)
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let getSalary = () => {
        axios.get(`${port}/root/ems/EmployeeHistoryCreating/${id}/`).then((response) => {
            console.log("hari", response.data);
            if (response.data.emp_history)
                setSalaryChanges(response.data.emp_history.assigned_salary)
            setSalary_Template(response.data.emp_history)
            if (response.data.template)
                settemplateObj(response.data.template)
        }).catch((error) => {
            console.log(error, 'hari');
        })
    }
    let postSalary = () => {
        if (!salary_template?.id)
            axios.post(`${port}/root/ems/EmployeeHistoryCreating/${id}/`, { assigned_salary: salary_changes }).then((response) => {
                console.log(response.data);
            }).catch((error) => {
                console.log(error);
            })
        else
            axios.patch(`${port}/root/ems/UpdateEmployeeHistory/${salary_template.id}/`, { assigned_salary: salary_changes })
                .then((response) => {
                    console.log(response.data);
                }).catch((error) => {
                    console.log(error);
                })
    }
    let particularchange = (eid, tid) => {
        axios.post(`${port}/root/pms/EmployeeSalaryBreakUps`, {
            employee_id: [eid],
            salary_template: tid
        }).then((response) => {
            console.log(response.data);
            // toast.success('Template has been assigned for the employee')
            // getEmployees()
        }).catch((error) => {
            toast.error('error acquired while chaning the Template')
            console.log(error);
        })
    }

    useEffect(() => {
        getData()
        getSalary()
        getTemplate()
    }, [id])
    return (
        <div>

            <main className='bg-white p-2 rounded row ' >
                <InputFieldform label='Annual CTC' value={salary_changes} limit={99999999}
                    handleChange={(e) => setSalaryChanges(e.target.value)} />
                <div className=' col-md-6 col-lg-4 ' >
                    <label className='my-1' htmlFor="">Salary template </label>
                    <select value={templateObj.salary_template} onChange={handleChangeTemplate} name="salary_template"
                        className='p-2 outline-none w-full inputbg rounded ' id="">
                        <option value="">Select</option>
                        {
                            templates && templates.map((obj, index) => (
                                <option value={obj.id} >{obj.template_name} </option>
                            ))
                        }
                    </select>
                </div>
                <InputFieldform placeholder='BOI234420BS ' label='IFSC' value={bankDetails.ifsc} name='ifsc'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder='7220134250234 ' label='Account Number' value={bankDetails.account_no} name='account_no'
                    handleChange={handleChange} type='text' limit={9999999999999999} />
                <InputFieldform placeholder='Name according to Bank Passbook ' label='Full Name' value={bankDetails.Holder_Name} name='Holder_Name'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder='Kumbakonam ' disabled={true} label='Branch' value={bankDetails.branch} name='branch'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder='Bank of India' disabled={true} label='Bank Name' value={bankDetails.bank_name} name='bank_name'
                    handleChange={handleChange} type='text' />
                <InputFieldform placeholder=' ' label='Bank Proof' name='account_proof' link={bankDetails.account_proof}
                    handleChange={handleChange} type='file' />
                <InputFieldform placeholder='Bank Address' disabled={true} label='Bank Address' value={bankDetails.branch_address} name='branch_address'
                    handleChange={handleChange} type='textarea' />
            </main>
            <section className='my-3 flex justify-between text-sm '>
                <button onClick={() => setpage('Info')} className='p-2 border-2 text-blue-500 text-sm border-blue-500 rounded ' >
                    Previous
                </button>
                <button onClick={() => saveData()} className='p-2 bg-blue-600 border-2 border-blue-600 text-white rounded' >
                    Save
                </button>
            </section>

        </div>
    )
}

export default EmployeeSalaryAdding