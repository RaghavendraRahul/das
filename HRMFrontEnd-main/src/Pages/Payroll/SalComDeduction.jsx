import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import InfoButton from '../../Components/SettingComponent/InfoButton'
import axios from 'axios'
import { port } from '../../App'
import { useNavigate } from 'react-router-dom'

const SalComDeduction = () => {
    let { setActiveSetting, preTaxDeduction, postTaxDeduction, getPreTaxDeduction, getPostTaxDeduction, } = useContext(HrmStore)
    let navigate = useNavigate()

    useEffect(() => {
        setActiveSetting('deduction')
        getPostTaxDeduction()
        getPreTaxDeduction()
    }, [])
    return (
        <div>
            <section className='tablebg rounded table-responsive  ' >
                <table className='w-full ' >
                    <tr className='sticky top-0  ' >
                        <th>Name</th>
                        <th>Deduction type  </th>
                        <th>Calculation type</th>

                        <th>Deduction Frequency</th>
                        <th>Status  </th>
                    </tr>
                    {/* Pre tax */}
                    {preTaxDeduction && preTaxDeduction.length > 0 &&
                        < tr >
                            <td className=' fw-semibold flex gap-1' >
                                Pre-Tax Deductions
                                <InfoButton size={12} content={`A pre-tax deduction is money taken out of an employee's pay before
                                income tax is calculated.This helps reduce the taxable income. `} />
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>}
                    {preTaxDeduction && preTaxDeduction.map((obj, index) => (
                        < tr >
                            {console.log(obj)}
                            <td onClick={() => navigate(`/dash/salaryComponent/pre-tax-deduction/${obj.id}`)} className='text-blue-600 cursor-pointer '> {obj.name_in_payslip}  </td>
                            <td>{obj.deduction_associate_with ? obj.deduction_associate_with : obj.deducting_plan}  </td>
                            <td>
                                {obj.caluculate_type == "Flat_Amount" ? 'Flat amount' :
                                    `${obj.percentage_of_ctc}% of CTC`} </td>
                            <td>{obj.deduction_frequency && 'Recurring'} </td>
                            <td> <span className={` ${obj.pre_tax_d_status ? 'text-green-600' : 'text-slate-600'} `} > {obj.pre_tax_d_status ? 'Active' : 'Inactive'} </span> </td>
                        </tr>
                    ))}
                    {/* Post Tax */}
                    {postTaxDeduction && postTaxDeduction.length > 0 && <tr>
                        <td className='fw-semibold flex gap-1'>
                            Post-Tax Deductions
                            <InfoButton size={12} content={`Post-deduction refers to the remaining salary after mandatory deductions like taxes, EPF, and ESI. These deductions do not affect taxable income. `} />
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>}
                    {postTaxDeduction && postTaxDeduction.map((obj, index) => (

                        <tr>
                            {console.log(obj)}
                            <td onClick={() => navigate(`/dash/salaryComponent/post-tax-deduction/${obj.id}`)} className='text-blue-600 cursor-pointer '> {obj.name_in_payslip}  </td>
                            <td>{obj.deduction_associate_with ? obj.deduction_associate_with : obj.deducting_plan}  </td>
                            <td>
                                {obj.caluculate_type == "Flat_Amount" ? 'Flat amount' :
                                    `${obj.percentage_of_ctc}% of CTC`} </td>
                            <td>{obj.deduction_frequency == 'recurring' ? 'Recurring' :
                                obj.deduction_frequency == 'OneTime' ? 'One time' : ''} </td>
                            <td> <span className={` ${obj.post_tax_d_status ? 'text-green-600' : 'text-slate-600'} `} > {obj.post_tax_d_status ? 'Active' : 'Inactive'} </span> </td>
                        </tr>))}

                </table>

            </section>

        </div >
    )
}

export default SalComDeduction