import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import InfoButton from '../../Components/SettingComponent/InfoButton'
import DownArrow from '../../SVG/DownArrow'
import PlusIcon from '../../SVG/PlusIcon'
import axios from 'axios'
import { port } from '../../App'
import TemplatesComponents from '../../Components/PayrollComponent/TemplatesComponents'
import { toast } from 'react-toastify'

const STcreation = () => {
    let { id } = useParams()
    let navigate = useNavigate()
    let [count, setCount] = useState(0)
    let [salaryTemplate, setSalaryTemplate] = useState({
        template_name: '',
        description: '',
        allowance_types: []
    })
    let handleChangeTemplate = (e) => {
        let { name, value } = e.target
        setSalaryTemplate((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let [salaryComponent, setsalaryComponent] = useState()
    let [annualSalary, setAnnualSalary] = useState(0)
    let [otherAllowance, setOtherAllowance] = useState(0)
    let [selectedComponent, setSelectedComponent] = useState([])
    let getComponent = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating`).then((response) => {
            setsalaryComponent(response.data)
            setCount(1)
            console.log("com", response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let changeOther = () => {
        let total = 0
        let deductions = 0
        selectedComponent.filter((obj, index) => obj.type == "Earning")
            .map((obj, index) => {
                if (obj.caluculate_type == 'Flat_Amount'
                    && obj.fixed_amount) {
                    total += Number(obj.fixed_amount)
                }
                else if (obj.percentage_of_ctc) {
                    total += ((obj.percentage_of_ctc / 100) * (annualSalary / 12))
                }
            })
        selectedComponent && selectedComponent
            .filter((obj, index) => obj.type && (obj.type.indexOf('P') != -1))
            .map((obj, index) => {
                if (obj.caluculate_type == 'Flat_Amount'
                    && obj.fixed_amount) {
                    deductions += Number(obj.fixed_amount)
                }
                else if (obj.percentage_of_ctc) {
                    deductions += ((obj.percentage_of_ctc / 100) * (annualSalary / 12))
                }
            })

        let otherSal = (annualSalary / 12) - total - deductions
        setOtherAllowance(otherSal)

    }
    useEffect(() => {
        if (selectedComponent && annualSalary) {
            changeOther()
        }
        if (selectedComponent) {
            setSalaryTemplate((prev) => ({
                ...prev,
                allowance_types: selectedComponent.map((obj) => obj.id)
            }))
        }
    }, [selectedComponent, annualSalary])
    useEffect(() => {
        getComponent()
    }, [])
    let removeComponent = (obj, name) => {
        setSelectedComponent((prev) => prev.filter((obj2) => obj2.id != obj.id))
        let objArry = [...salaryComponent[name], obj]
        console.log(objArry, name);
        setsalaryComponent((prev) => ({
            ...prev,
            [name]: objArry
        }))

    }
    let postData = () => {
        if (salaryTemplate.template_name != '' && salaryTemplate.allowance_types.length > 0) {
            axios.post(`${port}/root/pms/SalaryTemplates`, salaryTemplate).then((response) => {
                console.log(response.data);
                toast.success('Salary template created')
                setTimeout(() => {
                    navigate('/payroll/salary-templates')
                }, 2000);
            }).catch((error) => {
                console.log(error);
            })
        }
        else {
            toast.warning('Fill the required field , add the component')
        }
    }
    let updateData = () => {
        delete salaryTemplate.allowance_types
        delete salaryTemplate.created_at
        if (salaryTemplate.template_name != '') {
            axios.patch(`${port}/root/pms/EmployeeSalaryTemplate/${salaryTemplate.id}/`,
                {
                    ...salaryTemplate,
                    types: selectedComponent.map((obj) => obj.id)
                }).then((response) => {
                    console.log(response.data);
                    toast.success('Salary template updated')
                    getParticularData()
                }).catch((error) => {
                    console.log(error);
                })
        }
        else {
            toast.warning('Fill the required field , add the component')
        }
    }
    let getParticularData = () => {
        axios.get(`${port}/root/pms/SalaryTemplates?id=${id}`).then((response) => {
            console.log("par", response.data);
            setSalaryTemplate(response.data)
            setSelectedComponent(response.data.types)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        if (id && salaryComponent) {
            getParticularData()
        }
    }, [id, count])
    useEffect(() => {
        if (selectedComponent && salaryComponent) {
            let earnings = salaryComponent.earnings
            let post_tax_deduction = salaryComponent.post_tax_deduction
            let pre_tax_deduction = salaryComponent.pre_tax_deduction
            selectedComponent.forEach((obj) => {
                let ide = obj.id
                earnings = [...earnings.filter((obj3) => obj3.id != ide),]
                post_tax_deduction = [...post_tax_deduction.filter((obj3) => obj3.id != ide),]
                pre_tax_deduction = [...pre_tax_deduction.filter((obj3) => obj3.id != ide),]
            })
            setsalaryComponent({
                earnings,
                post_tax_deduction,
                pre_tax_deduction
            })
        }
    }, [selectedComponent])
    return (
        <div className='poppins  '>
            {id ?
                <div>
                    Template name
                </div>
                : <h5>New Salary Template </h5>}
            <article className='flex row  '>
                <section className='col-md-9 ' >
                    <main className=' bg-white rounded p-4 row ' >
                        <InputFieldform value={salaryTemplate.template_name} name='template_name'
                            handleChange={handleChangeTemplate} type='text' label='Template Name' />
                        <InputFieldform label='Description' value={salaryTemplate.description} name='description'
                            handleChange={handleChangeTemplate} type='text' placeholder='' />
                    </main>
                    <main className='bg-white rounded my-3 p-4 row ' >
                        <div className='flex gap-1 items-center '>
                            Annual CTC <InfoButton content='Use this field to calculate and validate different salary components for the selected CTC range.' size={10} />
                            <input type="number" value={annualSalary}
                                onChange={(e) => setAnnualSalary(e.target.value)}
                                placeholder='' className='inputbg mx-3 p-2 rounded outline-none ' />
                            per year
                        </div>
                        <section className='table-responsive tablebg my-3 rounded ' >
                            <table className='w-full ' >
                                <tr>
                                    <th>Component Name</th>
                                    <th> Calculation type </th>
                                    <th>Monthly amount</th>
                                    <th>Annual amount </th>
                                    <th>action </th>
                                </tr>
                                <tr>
                                    <td className='fw-semibold text-xl '>Earnings </td>
                                </tr>
                                {
                                    selectedComponent &&
                                    selectedComponent.filter((obj, index) => obj.type == "Earning")
                                        .map((obj, index) => {
                                            return (
                                                <tr>
                                                    {console.log(obj)}
                                                    <td> {obj.name_in_payslip} </td>

                                                    <td className=' '>
                                                        {obj.caluculate_type != "Flat_Amount" ?
                                                            <div className='rounded pe-1 mx-auto border-2 w-fit'>
                                                                <input type="number" value={obj.percentage_of_ctc}
                                                                    className='rounded outline-none p-2 w-20 ' />
                                                                <span> % of CTC </span>
                                                            </div> :
                                                            <div className='' >
                                                                Fixed
                                                            </div>
                                                        }
                                                    </td>
                                                    <td> {obj.caluculate_type == "Flat_Amount" && obj.fixed_amount}
                                                        {obj.caluculate_type != "Flat_Amount" &&
                                                            obj.percentage_of_ctc && ((obj.percentage_of_ctc / 100) * (Number(annualSalary) / 12)).toFixed(2)}
                                                    </td>
                                                    <td> {obj.caluculate_type == "Flat_Amount" && obj.fixed_amount * 12}
                                                        {obj.caluculate_type != "Flat_Amount" &&
                                                            obj.percentage_of_ctc && ((obj.percentage_of_ctc / 100) * (Number(annualSalary))).toFixed(2)} </td>
                                                    <td>
                                                        <button onClick={() => removeComponent(obj, 'earnings')} className=' rotate-45 ' >
                                                            <PlusIcon />
                                                        </button>
                                                    </td>
                                                </tr>
                                            )
                                        })
                                }



                                {/* Fixed Allowance */}
                                <tr>
                                    <td className='text-start '>
                                        <span className='flex gap-1'>
                                            Fixed Allowance
                                            <InfoButton size={12} content='Fixed allowance is a residual component of
                                     salary that is left after allocations are made for all other components.' />
                                        </span>
                                        <span className='text-sm '>
                                            Monthly CTC - The sum of all <br />
                                            salary components allocated for a month
                                        </span>
                                    </td>
                                    <td>Fixed </td>
                                    <td>
                                        {otherAllowance}
                                    </td>
                                    <td>{(otherAllowance * 12).toFixed(2)} </td>
                                </tr>
                                <tr>
                                    <td className='fw-semibold text-xl '>Deductions</td>
                                </tr>
                                {
                                    selectedComponent && selectedComponent
                                        .filter((obj, index) => obj.type && (obj.type.indexOf('P') != -1))
                                        .map((obj, index) => (
                                            <tr>
                                                {console.log(obj)}
                                                <td> {obj.name_in_payslip} </td>

                                                <td className=' '>
                                                    {obj.caluculate_type != "Flat_Amount" ?
                                                        <div className='rounded pe-1 mx-auto border-2 w-fit'>
                                                            <input type="number" value={obj.percentage_of_ctc}
                                                                className='rounded outline-none p-2 w-20 ' />
                                                            <span> % of CTC </span>
                                                        </div> :
                                                        <div className='' >
                                                            Fixed
                                                        </div>
                                                    }
                                                </td>
                                                <td> {obj.caluculate_type == "Flat_Amount" && obj.fixed_amount}
                                                    {obj.caluculate_type != "Flat_Amount" &&
                                                        obj.percentage_of_ctc && ((obj.percentage_of_ctc / 100) * (Number(annualSalary) / 12)).toFixed(2)}
                                                </td>
                                                <td> {obj.caluculate_type == "Flat_Amount" && obj.fixed_amount * 12}
                                                    {obj.caluculate_type != "Flat_Amount" &&
                                                        obj.percentage_of_ctc && ((obj.percentage_of_ctc / 100) * (Number(annualSalary))).toFixed(2)} </td>

                                                <td>
                                                    <button className='rotate-45 ' onClick={() => {
                                                        if (obj.type == 'Pre_Tax_Deduction')
                                                            removeComponent(obj, 'pre_tax_deduction')
                                                        if (obj.type == 'Post_Tax_Deduction')
                                                            removeComponent(obj, 'post_tax_deduction')
                                                    }} >
                                                        <PlusIcon />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))
                                }
                                {/* Total */}
                                <tr className='bg-blue-50 '>
                                    <td>
                                        Cost to Company
                                    </td>
                                    <td></td>
                                    <td>₹ {(annualSalary / 12).toFixed(2)} </td>
                                    <td>₹ {annualSalary} </td>
                                </tr>

                            </table>
                        </section>
                        <div className='flex justify-end '>

                            {!id && <button onClick={() => postData()} className='savebtn text-white rounded p-2 px-3 text-sm '>
                                Save
                            </button>}
                            {id && <button onClick={() => updateData()} className='savebtn text-white rounded p-2 px-3 text-sm '>
                                Update
                            </button>}
                            <button onClick={() => navigate('/payroll/salary-templates/')} className='mx-2 p-2 px-3 bg-slate-500 text-white rounded text-sm ' >
                                Cancel
                            </button>

                        </div>
                    </main>
                </section>
                <TemplatesComponents selectedComponent={selectedComponent} data={salaryComponent} setData={setsalaryComponent}
                    setSelectedComponent={setSelectedComponent} />
            </article>
        </div>
    )
}

export default STcreation