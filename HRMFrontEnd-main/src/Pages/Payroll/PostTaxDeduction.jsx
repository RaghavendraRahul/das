import React, { useContext, useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { HrmStore } from '../../Context/HrmContext'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'

const PostTaxDeduction = () => {
    let { id } = useParams()
    let { deleteSalaryComponent, getPostTaxDeduction } = useContext(HrmStore)
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        name_in_payslip: '',
        type: 'Post_Tax_Deduction',
        deduction_frequency: '',
        post_tax_d_status: false,
        fixed_amount: '',
        percentage_of_ctc: '',
        caluculate_type: '',
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

    let postData = () => {
        if (formObj.name_in_payslip != '')
            axios.post(`${port}/root/pms/AllowanceTemplateCreating`, formObj).then((response) => {
                console.log(response.data);
                toast.success('Deduction has been added')
                setFormObj({
                    name_in_payslip: '',
                    type: 'Post_Tax_Deduction',
                    deduction_frequency: '',
                    post_tax_d_status: false
                })
                navigate('/dash/salaryComponent/deduction')
                getPostTaxDeduction()
            }).catch((error) => {
                console.log(error);
                toast.error('Error Acquired')
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
        if (id) {
            getData()
        }
        setActiveSetting('deduction')
    }, [id])
    return (
        <div className='poppins px-2'>
            <h4>Post-Tax Deduction </h4>
            <main className='bg-white row p-4 ' >
                <InputFieldform required={true} value={formObj.name_in_payslip} handleChange={handleChange}
                    type='text' name='name_in_payslip' label='Name in Payslip' />
                <div className=" col-md-4 col-sm-6 ">
                    <label className='mb-1 my-1'>Calculation Type </label>
                    <select onChange={handleChange} value={formObj.caluculate_type}
                        className='w-full inputbg p-2 rounded outline-none '
                        name="caluculate_type" id="">
                        <option value="">Select</option>
                        <option value="Flat_Amount">Flat amount <span className='text-sm ' >(Fixed value for this component.) </span>  </option>
                        <option value="Percentage_oF_CTC">Percentage of component <span className='text-sm ' >(Percentage based on total salary or specific component.) </span>  </option>

                    </select>
                </div>
                {formObj.caluculate_type == 'Flat_Amount' &&
                    <InputFieldform placeholder={0} value={formObj.fixed_amount} handleChange={handleChange} name='fixed_amount' label='Enter Amount' limit={99999999} />}
                {formObj.caluculate_type == 'Percentage_oF_CTC' &&
                    < InputFieldform value={formObj.percentage_of_ctc} handleChange={handleChange} name='percentage_of_ctc'
                        info='Give a  percentage_of_ctc it will be consider as a  percentage_of_ctc of CTC only.'
                        placeholder={0} label='Enter Percentage' limit={100} />}
                <section>
                    <p className='fw-semibold'> Select the deduction frequency </p>
                    <div className='flex gap-2 items-center' >
                        <input type="radio" checked={formObj.deduction_frequency == 'OneTime'}
                            onChange={() => {
                                setFormObj((prev) => ({
                                    ...prev,
                                    deduction_frequency: 'OneTime'
                                }))
                            }} id='d1' name='deduction' />
                        <label className='' htmlFor="d1"> One-Time deduction </label>
                    </div>
                    <div className='flex mb-3 gap-2 items-center' >
                        <input type="radio" checked={formObj.deduction_frequency == 'recurring'}
                            onChange={() => {
                                setFormObj((prev) => ({
                                    ...prev,
                                    deduction_frequency: 'recurring'
                                }))
                            }}
                            id='d2' name='deduction' />
                        <label className='' htmlFor="d2">  Recurring deduction for subsequent Payrolls </label>
                    </div>
                </section>
                <div className='flex gap-2 items-center' >
                    <input checked={formObj.post_tax_d_status} onChange={() => {
                        setFormObj((prev) => ({
                            ...prev,
                            post_tax_d_status: !formObj.post_tax_d_status
                        }))
                    }} type="checkbox" id='markactive' />
                    <label htmlFor="markactive"> Mark this as Active </label>
                </div>
                <div className='my-2 flex gap-3 text-sm col-12 justify-end '>
                    {!id && <button onClick={postData} className='savebtn p-2 rounded text-white px-3 '>
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

export default PostTaxDeduction