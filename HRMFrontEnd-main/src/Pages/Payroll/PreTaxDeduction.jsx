import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate, useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'

const PreTaxDeduction = () => {
    let { id } = useParams()
    let { getPreTaxDeduction, deleteSalaryComponent } = useContext(HrmStore)
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        type: 'Pre_Tax_Deduction',
        deducting_plan: '',
        deduction_associate_with: '',
        name_in_payslip: '',
        emp_contribution_ctc: false,
        pre_tax_d_status: false,
        caluculate_on_prorata_basic: false,
        deduction_frequency: 'recurring',
        fixed_amount: '',
        percentage_of_ctc: '',
        caluculate_type: '',
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let { setActiveSetting } = useContext(HrmStore)
    let assiociation = ['Life Insurance Premium', 'Public Provident Fund',
        'Unit-Linked insurance plan', 'ELSS Tax saving mutual fund',
        'Medi Claim Policy for self,spouse,children-80D', 'Medi Claim Policy for self,spouse,children for senior citizen - 80D',
        'Medi Claim Policy for parents - 80D', 'Medi Claim Policy for parents for senior citizen - 80D',
        'Preventive Health check up - 80D', 'Preventive Health check up for parents - 80D',
        'Medical Bills for self,spouse, Children for senior citizen - 80D', 'Medical Bills for parents for senior citizen - 80D',
        'Treatment of dependent with disability - 80DD', 'Treatment of dependent with severe disability - 80DD',
        'Medical expenditure for self or dependent - 80DDB', 'Medical expenditure for self or dependent for senior citizen - 80DDB',
        'Medical expenditure for self or dependent for very senior citizen - 80DDB'

    ]

    let saveData = () => {
        if (formObj.name_in_payslip != '')
            axios.post(`${port}/root/pms/AllowanceTemplateCreating`, formObj).then((response) => {
                console.log(response.data);
                toast.success('Deduction has been added')
                setFormObj({
                    type: 'Pre_Tax_Deducation',
                    deducting_plan: '',
                    deduction_associate_with: '',
                    name_in_payslip: '',
                    emp_contribution_ctc: false,
                    pre_tax_d_status: false,
                    caluculate_on_prorata_basic: false,
                    deduction_frequency: 'recurring'
                })
                navigate('/dash/salaryComponent/deduction')
                getPreTaxDeduction()
            }).catch((error) => {
                console.log(error);
            })
        else
            toast.warning('Enter the Name for payslip')
    }
    let updateData = () => {
        axios.patch(`${port}/root/pms/AllowanceTemplateCreating?id=${id}`, formObj).then((response) => {
            console.log(response.data);
            toast.success('Component has been Updated')
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating?id=${id}`).then((response) => {
            console.log(response.data);
            setFormObj(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        if (id)
            getData()
        setActiveSetting('deduction')
    }, [id])
    return (
        <div className='poppins px-2'>
            <h4>   Pre-Tax Deduction </h4>

            <main className='bg-white p-4 rounded row ' >
                <InputFieldform name='deducting_plan' handleChange={handleChange}
                    value={formObj.deducting_plan} label='Deduction Plan'
                    options={['National Pension Section', 'Other Non-Taxable Deduction']} />
                {formObj.deducting_plan == 'Other Non-Taxable Deduction' &&
                    <InputFieldform name='deduction_associate_with' value={formObj.deduction_associate_with}
                        label='Associate this deduction with' handleChange={handleChange}
                        options={assiociation} />}
                <InputFieldform required={true} label='Name on Payslip' value={formObj.name_in_payslip} name='name_in_payslip'
                    handleChange={handleChange} type='text' />

                <div className=" col-md-4 col-sm-6 ">
                    <label className='mb-1 my-1'>Calculation Type </label>
                    <select onChange={handleChange} value={formObj.caluculate_type}
                        className='w-full inputbg p-2 rounded outline-none '
                        name="caluculate_type" id="">
                        <option value="">Select</option>
                        <option value="Flat_Amount">Flat amount <span className='text-sm '> (Fixed value for this component) </span> </option>
                        <option value="Percentage_oF_CTC">Percentage of component <span className='text-sm ' >(Percentage based on total salary or specific component.) </span>  </option>

                    </select>
                </div>
                {formObj.caluculate_type == 'Flat_Amount' &&
                    <InputFieldform placeholder={0} value={formObj.fixed_amount} handleChange={handleChange} name='fixed_amount' label='Enter Amount' limit={99999999} />}
                {formObj.caluculate_type == 'Percentage_oF_CTC' &&
                    < InputFieldform value={formObj.percentage_of_ctc} handleChange={handleChange} name='percentage_of_ctc'
                        info='Give a  percentage_of_ctc it will be consider as a  percentage_of_ctc of CTC only.'
                        placeholder={0} label='Enter Percentage' limit={100} />}

                <div className='flex gap-2 items-center' >
                    <input type="checkbox" checked={formObj.emp_contribution_ctc}
                        onChange={() => setFormObj((prev) => ({
                            ...prev,
                            emp_contribution_ctc: !formObj.emp_contribution_ctc
                        }))} id='individual' />
                    <label htmlFor="individual"> Include employer's contribution in the CTC </label>
                </div>
                <div className='flex gap-2 my-3 items-start' >
                    <input type="checkbox" checked={formObj.caluculate_on_prorata_basic}
                        onChange={() => setFormObj((prev) => ({
                            ...prev,
                            caluculate_on_prorata_basic: !formObj.caluculate_on_prorata_basic
                        }))} id='individual2' />
                    <label htmlFor="individual2"> Calculate on pro-rata basis
                        <span className='block text-sm text-slate-500 '> Pay will be adjusted based on employee working days.</span> </label>
                </div>
                <div className='flex gap-2 items-center' >
                    <input type="checkbox" checked={formObj.pre_tax_d_status}
                        onChange={() => setFormObj((prev) => ({
                            ...prev,
                            pre_tax_d_status: !formObj.pre_tax_d_status
                        }))} id='individual3' />
                    <label htmlFor="individual3"> Mark this as Active </label>
                </div>
                <div className='my-2 flex gap-3 col-12 text-sm justify-end '>
                    {!id && <button onClick={saveData} className='savebtn p-2 rounded text-white px-3 '>
                        Save
                    </button>}
                    {id && <button onClick={updateData} className='savebtn p-2 rounded text-white px-3 '>
                        Update
                    </button>}
                    <button onClick={() => navigate('/dash/salaryComponent/deduction')} className='bg-slate-600 text-white p-2 rounded px-3  ' >
                        Back
                    </button>
                    {id && <button onClick={() => {
                        deleteSalaryComponent(id)
                        navigate('/dash/salaryComponent/deduction')
                    }} className='bg-red-600 text-white p-2 rounded px-3' >
                        Delete
                    </button>}
                </div>

            </main>


        </div>
    )
}

export default PreTaxDeduction