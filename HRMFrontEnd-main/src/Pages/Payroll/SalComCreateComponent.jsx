import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate, useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'

const SalComCreateComponent = () => {
    let { id } = useParams()
    let { setActiveSetting, deleteSalaryComponent } = useContext(HrmStore)
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        pay_type: '',
        
        name_in_payslip: '',
        earning_status: false,
        fixed_amount: '',
        percentage_of_ctc: '',
        caluculate_type: '',
        consider_for_esi: false,
        consider_for_epf: false,
        earning_name: '',
        type: 'Earning',
        caluculate_on_prorata_basic: false,
        epf_type: 'always'

    })
    let handlePayTypeChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getData = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating?id=${id}`).then((response) => {
            console.log(response.data);
            setFormObj(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateData = () => {
        axios.patch(`${port}/root/pms/AllowanceTemplateCreating?id=${id}`, formObj).then((response) => {
            console.log(response.data);
            toast.success('Component has been Updated')
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        setActiveSetting('earning')
        if (id)
            getData()
    }, [id])
    let postData = () => {
        axios.post(`${port}/root/pms/AllowanceTemplateCreating`, formObj).then((response) => {
            console.log(response.data);
            setFormObj({
                pay_type: '',
                caluculate_type: '',
                name_in_payslip: '',
                earning_status: false,
                fixed_amount: '',
                percentage_of_ctc: '',
                consider_for_esi: false,
                consider_for_epf: false,
                earning_name: '',
                type: 'Earning',
                caluculate_on_prorata_basic: false,
                epf_type: 'always'
            })
            toast.success('Salary Component created successfully')
            navigate('/dash/salaryComponent/')
        }).catch((error) => {
            console.log(error);
        })
    }
    return (
        <div>
            <main className='formbg poppins rounded min-h-[30vh] p-3 '>
                {/* <div className='col-lg-4 col-sm-6 '>

                    <label htmlFor=" " className='my-2 ' > Earning type </label>
                    <select className='w-full bgclr p-2 rounded outline-none ' name="" id="">
                        <option value="">Select</option>
                        <option value="Custom Allowance">Custom Allowance</option>
                    </select>
                </div> */}
                <hr />
                <main className=' row'>

                    <section className='col-md-6 '>
                        <InputFieldform size={'col-md-8'} label='Earning Name' placeholder='Basic' value={formObj.earning_name}
                            name='earning_name' handleChange={handlePayTypeChange} type='text' />
                        <InputFieldform size={'col-md-8'} label='Name on payslip ' value={formObj.name_in_payslip} name='name_in_payslip'
                            handleChange={handlePayTypeChange} type='text' placeholder='Basic Pay' />

                        <div className="col-md-8 col-sm-6 ">
                            <label className='mb-1'>Pay Type </label>
                            <select onChange={handlePayTypeChange} value={formObj.pay_type}
                                className='w-full bgclr p-2 rounded outline-none '
                                name="pay_type" id="">
                                <option value="">Select</option>
                                <option value="Fixed_Pay">Fixed Pay <span className='text-sm ' >(A set amount paid monthly.) </span>  </option>
                                <option value="Variable_Pay">Variable Pay <span className='text-sm ' >(Amount varies depending on payroll cycle.) </span>  </option>

                            </select>
                        </div>
                        <div className=" col-md-8 my-3 col-sm-6 ">
                            <label className='mb-1'>Calculation Type </label>
                            <select onChange={handlePayTypeChange} value={formObj.caluculate_type}
                                className='w-full bgclr p-2 rounded outline-none '
                                name="caluculate_type" id="">
                                <option value="">Select</option>
                                <option value="Flat_Amount">Flat amount <span className='text-sm ' >(Fixed value for this component.) </span>  </option>
                                <option value="Percentage_oF_CTC">Percentage of component <span className='text-sm ' >(Percentage based on total salary or specific component.) </span>  </option>

                            </select>
                        </div>
                        {formObj.caluculate_type == 'Flat_Amount' &&
                            <InputFieldform placeholder={0} value={formObj.fixed_amount} handleChange={handlePayTypeChange} name='fixed_amount' label='Enter Amount' limit={99999999} />}
                        {formObj.caluculate_type == 'Percentage_oF_CTC' &&
                            < InputFieldform value={formObj.percentage_of_ctc} handleChange={handlePayTypeChange} name='percentage_of_ctc'
                                info='Give a  percentage_of_ctc it will be consider as a  percentage_of_ctc of CTC only.'
                                placeholder={0} label='Enter Percentage' limit={100} />}
                    </section>
                    <section className='col-md-6'>
                        <h5 className='my-2 poppins fw-semibold ' >Other Configurations</h5>

                        <div className='flex my-2 gap-2 items-center ' >
                            <input type="checkbox" name='caluculate_on_prorata_basic' checked={formObj.caluculate_on_prorata_basic}
                                onChange={() => setFormObj((prev) => ({
                                    ...prev,
                                    caluculate_on_prorata_basic: !formObj.caluculate_on_prorata_basic
                                }))} id='proRata' />
                            <label htmlFor="proRata">Calculate on pro-rata basis
                                <span className='block text-sm  ' >
                                    Pay will be adjusted based on employee working days. </span>
                            </label>
                        </div>
                        <div className='flex my-2 gap-2 items-center ' >
                            <input type="checkbox" checked={formObj.consider_for_epf}
                                onChange={() => setFormObj((prev) => ({
                                    ...prev,
                                    consider_for_epf: !formObj.consider_for_epf
                                }))} id='EPF' />
                            <label htmlFor="EPF">Consider for EPF Contribution </label>
                        </div>
                        {formObj.consider_for_epf &&
                            <article className='text-sm text-slate-500 relative left-10 '>
                                <div className='flex items-center gap-1' >
                                    <input checked={formObj.epf_type == 'always'}
                                        onChange={() => {
                                            setFormObj((prev) => ({
                                                ...prev,
                                                epf_type: 'always'
                                            }))
                                        }}
                                        type="radio" id='always' name='epf_type' />
                                    <label htmlFor="always"> Always </label>
                                </div>
                                <div className='flex items-center gap-1 ' >
                                    <input checked={formObj.epf_type == 'pfwage'}
                                        onChange={() => {
                                            setFormObj((prev) => ({
                                                ...prev,
                                                epf_type: 'pfwage'
                                            }))
                                        }}
                                        type="radio" id='pfwage' name='epf_type' />
                                    <label htmlFor="pfwage"> Only when PF wage  is less than ₹ 15,000 </label>
                                </div>

                            </article>}
                        <div className='flex gap-2 items-center ' >
                            <input type="checkbox" checked={formObj.consider_for_esi}
                                onChange={() => setFormObj((prev) => ({
                                    ...prev,
                                    consider_for_esi: !formObj.consider_for_esi
                                }))} id='ESI' />
                            <label htmlFor="ESI">Consider for ESI Contribution </label>
                        </div>
                    </section>
                </main>
                <div className='flex gap-2 my-3 items-center ' >
                    <input type="checkbox" checked={formObj.earning_status}
                        onChange={() => setFormObj((prev) => ({
                            ...prev,
                            earning_status: !formObj.earning_status
                        }))} id='active' />
                    <label htmlFor="active"> Mark this as Active </label>
                </div>
                <div className='flex justify-end '>

                    {!id && <button onClick={() => postData()} className='savebtn text-white rounded p-2 px-3 text-sm '>
                        Save
                    </button>}
                    {id && <button onClick={() => updateData()} className='savebtn text-white rounded p-2 px-3 text-sm '>
                        Update
                    </button>}
                    <button onClick={() => navigate('/dash/salaryComponent/')} className='mx-2 p-2 px-3 bg-slate-500 text-white rounded text-sm ' >
                        Back
                    </button>
                    {id && <button onClick={() => {
                        deleteSalaryComponent(id)
                        navigate('/dash/salaryComponent')
                    }} className='bg-red-600 text-white p-2 text-sm rounded px-3' >
                        Delete
                    </button>}

                </div>
            </main>

        </div>
    )
}

export default SalComCreateComponent