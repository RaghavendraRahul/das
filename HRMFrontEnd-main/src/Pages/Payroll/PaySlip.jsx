import React, { useContext, useEffect, useRef, useState } from 'react'
import Topnav from '../../Components/Topnav'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import { useParams, useSearchParams } from 'react-router-dom'
import { Spinner } from 'react-bootstrap'
import DownloadButton from '../../Components/Employee/DownloadButton'
import { usePDF } from 'react-to-pdf'
import DownloadContent from '../../Components/AuthPermissions/DownloadContent'
import GeneratePDF from '../../Components/ApplyList/GeneratePDF'

const PaySlip = () => {
    let { id } = useParams()
    let { getMonthYear, setActivePage, numberToWords, setTopNav } = useContext(HrmStore)
    let slipRef = useRef()
    let [payslip, setPayslip] = useState()
    let [loading, setLoading] = useState(false)
    let mon = new Date().getMonth() < 10 ? `0${new Date().getMonth()}` : new Date().getMonth()
    let year = new Date().getFullYear()
    const { toPDF, targetRef } = usePDF({ Offer_Letter: 'page.pdf' });

    let [searchParams, setSearchParams] = useSearchParams()

    // Initialize monthdata from URL if available, otherwise default to current month
    const defaultMonth = `${year}-${mon}`
    let [monthdata, setMonth] = useState(searchParams.get('month') || defaultMonth)

    // Sync state if URL changes (e.g., browser back/forward or manual URL edit)
    useEffect(() => {
        const urlMonth = searchParams.get('month')
        if (urlMonth && urlMonth !== monthdata) {
            setMonth(urlMonth)
        }
    }, [searchParams])
    let [salaryTemplate, setSalaryTemplate] = useState()
    let getTemplate = (ide) => {
        axios.get(`${port}/root/pms/SalaryTemplates?id=${ide}`).then((response) => {
            console.log("pay24", response.data);
            console.log("pay23", response.data);

            setSalaryTemplate(response.data.types)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getParticularPayslip = () => {
        setLoading(true)
        // axios.get(`${port}/payroll/retrieve-payslip/${id}/${monthdata.split('-')[1]}/${monthdata.split('-')[0]}`)
        axios.get(`${port}/root/pms/SingleEmployeesPaySlip/${monthdata.split('-')[1]}/${monthdata.split('-')[0]}/${id}/`).then((response) => {
            setPayslip(response.data)
            setLoading(false)
            getTemplate(response.data.salary_breakups.salary_template)
            console.log("pay", response.data);
        }).catch((error) => {
            setLoading(false)
            setPayslip(null)
            console.log(error);
        })

    }
    let [otherAllowance, setOtherAllowance] = useState()
    useEffect(() => {
        if (id && monthdata)
            getParticularPayslip()
        setActivePage('payroll')
        setTopNav('allpayslip')
    }, [id, monthdata])
    useEffect(() => {
        if (salaryTemplate && payslip)
            changeOther()
    }, [salaryTemplate, payslip])
    let changeOther = () => {
        let total = 0
        let deductions = 0
        salaryTemplate.filter((obj, index) => obj.type == "Earning")
            .map((obj, index) => {
                console.log("hi", obj);
                if (obj.caluculate_type == 'Flat_Amount'
                    && obj.fixed_amount) {
                    total += Number(obj.fixed_amount)
                }
                else if (obj.percentage_of_ctc) {
                    total += ((obj.percentage_of_ctc / 100) * (Number(payslip.net_salary) + Number(payslip.total_deductions)))
                }
            })
        // salaryTemplate && salaryTemplate
        //     .filter((obj, index) => obj.type && (obj.type.indexOf('P') != -1))
        //     .map((obj, index) => {
        //         if (obj.caluculate_type == 'Flat_Amount'
        //             && obj.fixed_amount) {
        //             deductions += Number(obj.fixed_amount)
        //         }
        //         else if (obj.percentage_of_ctc) {
        //             deductions += ((obj.percentage_of_ctc / 100) * (Number(payslip.net_salary) + Number(payslip.total_deductions) / 12))
        //         }
        //     })

        let otherSal = (Number(payslip.net_salary) + Number(payslip.total_deductions)) > total ?
            (Number(payslip.net_salary) + Number(payslip.total_deductions)) - total : 0
        console.log(total);
        setOtherAllowance(otherSal)

    }
    return (
        <div>
            {/* <Topnav name='Payslip' /> */}
            <section className='my-3 ' >
                <input type="month" value={monthdata} onChange={(e) => {
                    console.log(e.target.value);
                    setMonth(e.target.value)
                    setSearchParams({ month: e.target.value })
                }}
                    className='p-1 flex ms-auto bg-white px-2 bgclr1 outline-none rounded ' />
            </section>
            {!loading ? payslip ?
                <main ref={slipRef} className='bg-white my-3 poppins w-full p-4 ' >
                    {/* Header */}
                    <section className='poppins flex items-center justify-between '>
                        <div className=''>
                            <img className='w-24 h-fit' src={require('../../assets/logo/Merida_Tech_Minds_logo2.png')}
                                alt="Logo" />

                            {/* <span className='text-sm my-2 block '>
                                Merida, 4th Block of Jayanagar Bengaluru Karnataka 627006 India 
                                </span> */}
                        </div>
                        <div>
                            <span className='text-sm my-2 block '>
                                {/* Merida Tech Minds, <br /> 4th Block of Jayanagar, <br /> Bengaluru , <br /> Karnataka - 560011. <br /> */}
                                Merida Tech Minds, <br /> 1st Floor, 334/28, 14th Cross Rd, <br /> 2nd Block, Jayanagar, <br /> Bengaluru, Karnataka 560011
                            </span>
                            {/* <p className=' mb-1 text-sm '>Payslip For the Month </p>
                            <span className='fw-semibold '> {getMonthYear(monthdata)} </span> */}
                        </div>
                    </section>
                    <p className=' mb-2 text-sm flex gap-1 fw-semibold mx-auto w-fit'>Payslip For the Month of
                        <span className='fw-semibold '>     {monthdata && "  " + getMonthYear(monthdata)} </span></p>
                    {/* <hr /> */}
                    {/* Employee section */}
                    {/* <section className='flex justify-between border-2 items-center text-sm' >
                        <article className='sm:w-1/2 p-2 ' >
                            <h6 className=' uppercase  ' >Employee Summary </h6>
                            <div className='flex    ' >
                                <p className='sm:w-1/2 '>Employee Name  </p>
                                <p>: {payslip.employee_name} </p>
                            </div>
                            <div className='flex    ' >
                                <p className='sm:w-1/2 '>Designation </p>
                                <p>: {payslip.designation} </p>
                            </div>
                            <div className='flex    ' >
                                <p className='sm:w-1/2 '>Employee ID  </p>
                                <p>: {payslip.employee_id} </p>
                            </div>
                            <div className='flex    ' >
                                <p className='sm:w-1/2 '>Date of Joining  </p>
                                <p>: {payslip.doj} </p>
                            </div>
                           
                            <div className='flex    ' >
                                <p className='sm:w-1/2 '>Bank Account Number  </p>
                                <p>: {payslip.account_number}  </p>
                            </div>
                        </article>
                        <article>
                            <div className='border rounded '>
                                <article className=' bg-green-100 p-3 ' >
                                    <div className='border-s-2 border-green-400  px-3 ' >
                                        {payslip.net_salary}
                                        <span className='block '>
                                            Employee net pay
                                        </span>
                                    </div>
                                </article>
                                <article className='p-3 ' >
                                    <div className='flex  ' >
                                        <p className='mb-1 w-[100px] '>Paid days  </p>
                                        <p className='mb-1 '> : {payslip.worked_days} </p>
                                    </div>
                                    <div className='flex '>
                                        <p className='mb-1 w-[100px] '>LOP days  </p>
                                        <p className='mb-1 '> : {payslip.lop_days && Math.round(payslip.lop_days)} </p>
                                    </div>

                                </article>
                            </div>
                        </article>
                    </section> */}
                    {/* <hr /> */}
                    <main className='border-2 border-slate-800  ' >
                        <section className='flex justify-between text-sm' >
                            <article className='sm:w-1/2 p-2 ' >
                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Employee Name  </p>
                                    <p className='mb-2 ' >: {payslip.employee_name} </p>
                                </div>
                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Designation </p>
                                    <p className='mb-2 ' >: {payslip.designation} </p>
                                </div>
                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Employee ID  </p>
                                    <p className='mb-2 ' >: {payslip.employee_id} </p>
                                </div>
                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Date of Joining  </p>
                                    <p className='mb-2 ' >: {payslip.doj} </p>
                                </div>

                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Bank Account Number  </p>
                                    <p className='mb-2 ' >: {payslip.account_number}  </p>
                                </div>
                            </article>
                            <article className='sm:w-1/2 p-2 ' >

                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>No. of days working  </p>
                                    <p className='mb-2 ' >: {payslip.worked_days} </p>
                                </div>
                                <div className='flex    ' >
                                    <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>No of LOP Days  </p>
                                    <p className='mb-2 ' >: {payslip.lop_days} days </p>
                                </div>

                            </article>
                        </section>
                        {/* Structre */}
                        <main className='table-responsive flex my-2 border-slate-800  '>
                            <table className='w-full ' >
                                <tr className='border-y-2  ' >
                                    <th className=' p-2 text-center ' >EARNINGS</th>
                                    <th className=' p-2 text-center border-e-2 ' > ACTUAL AMOUNT </th>
                                    <th className=' p-2 text-center ' >DEDUCTION</th>
                                    <th className=' p-2 text-center ' > ACTUAL AMOUNT </th>
                                </tr>

                                {
                                    salaryTemplate && Array.from({
                                        length: Math.max((salaryTemplate.filter((obj) => obj.type == "Earning").length),
                                            (salaryTemplate.filter((obj) => obj.type && obj.type.indexOf('P') != -1).length)
                                        )
                                    }, (_, index) => {
                                        let earning = salaryTemplate.filter((obj) => obj.type == "Earning")[index]
                                        let deduction = salaryTemplate.filter((obj) => obj.type && obj.type.indexOf('P') != -1)[index]
                                        console.log(earning, deduction, 'earn');

                                        return (
                                            <tr className='my-0 ' >
                                                <td>
                                                    {earning && earning.name_in_payslip}
                                                </td>
                                                {/* <td className='p-1 border-e-2 ' >
                                                    {!earning ? '' : earning.caluculate_type == "Flat_Amount" ?
                                                        Number(payslip.monthly_gross_pay) != 0 ?
                                                            `₹${earning.fixed_amount}` : '₹0' : ''}

                                                    {!earning ? '' : earning.caluculate_type != "Flat_Amount" &&
                                                        `₹${(earning.percentage_of_ctc / 100) *
                                                        (Number(payslip.net_salary) + Number(payslip.total_deductions))}`
                                                    }
                                                </td> */}
                                                <td className='p-1 border-e-2'>
                                                    {!earning ? '' : earning.caluculate_type === "Flat_Amount" ? (
                                                        Number(payslip.monthly_gross_pay) !== 0
                                                            ? `₹${Number(earning.fixed_amount).toFixed(2)}`
                                                            : '₹0.00'
                                                    ) : (
                                                        `₹${(
                                                            (earning.percentage_of_ctc / 100) *
                                                            (Number(payslip.net_salary) + Number(payslip.total_deductions))
                                                        ).toFixed(2)}`
                                                    )}
                                                </td>

                                                <td className='p-1 ' >{deduction && deduction.name_in_payslip} </td>
                                                <td className='p-1 '>
                                                    {!deduction ? '' : deduction.caluculate_type === "Flat_Amount" ? (
                                                        Number(payslip.monthly_gross_pay) !== 0
                                                            ? `₹${Number(deduction.fixed_amount).toFixed(2)}`
                                                            : '₹0.00'
                                                    ) : (
                                                        deduction.percentage_of_ctc &&
                                                        `₹${(
                                                            (deduction.percentage_of_ctc / 100) *
                                                            (Number(payslip.net_salary) + Number(payslip.total_deductions))
                                                        ).toFixed(2)}`
                                                    )}
                                                </td>
                                            </tr>
                                        )
                                    })
                                }
                                <tr>
                                    <td></td>
                                    <td className='p-1 border-e-2 ' ></td>
                                    <td className='p-1 ' >LOP </td>
                                    <td className='p-1 ' >
                                        {/* {Number(payslip.total_deductions) > 0 ? `₹${(payslip.lop_days && Math.round(payslip.lop_days) */}
                                        {Number(payslip.total_deductions) > 0 ? `₹${(payslip.lop_days
                                            * (Number(payslip.monthly_gross_pay) / Number(payslip.total_working_days))).toFixed(2)}` : `₹0.00`}
                                    </td>
                                    {console.log(Number(payslip.total_deductions) > 0 ? `₹${(payslip.lop_days
                                        * (Number(payslip.monthly_gross_pay) / Number(payslip.total_working_days))).toFixed(2)}` : `₹0.00`, "amnt", ((payslip.total_working_days)))}
                                </tr>
                                {/* <tr>
                                    <td className='p-1 ' >Other Allowance </td>
                                    <td className='p-1 ' > ₹{Math.round(otherAllowance)} </td>
                                </tr> */}
                                <tr className='border-y-2 ' >
                                    <td className='p-2 rounded-s ' >Total earning </td>
                                    <td className='p-2 rounded-e border-e-2'>₹{(Number(payslip.net_salary) + Number(payslip.total_deductions)).toFixed(2)} </td>
                                    <td className=' rounded-s p-2' >Total Deduction </td>
                                    <td className=' rounded-e p-2'>₹{Number(payslip.total_deductions).toFixed(2)} </td>
                                </tr>
                            </table>
                            {/* <table className='w-full h-fit ' >
                                <tr className='border-y-2  ' >
                                    <th className=' p-2 text-center ' >DEDUCTION</th>
                                    <th className=' p-2 text-center ' > ACTUAL AMOUNT </th>
                                </tr>

                                {
                                    salaryTemplate && salaryTemplate.filter((obj) => obj.type && obj.type.indexOf('P') != -1)
                                        .map((obj, index) => (
                                            <tr>
                                                <td className='p-1 ' >{obj.name_in_payslip} </td>
                                                <td className='p-1 ' >{obj.caluculate_type == "Flat_Amount" ?
                                                    Number(payslip.monthly_gross_pay) != 0 ?
                                                        `₹${obj.fixed_amount}` : '₹0' : ''}
                                                    {obj.caluculate_type != "Flat_Amount" && obj.percentage_of_ctc &&
                                                        `₹${(obj.percentage_of_ctc / 100) *
                                                        (Number(payslip.net_salary) + Number(payslip.total_deductions))}`
                                                    }

                                                </td>
                                            </tr>
                                        ))
                                }
                                <tr>
                                    <td className='p-1 ' >LOP </td>
                                    <td className='p-1 ' >
                                        {Number(payslip.total_deductions) > 0 ? `₹${payslip.lop_days && Math.round(payslip.lop_days)
                                            * (Number(payslip.monthly_gross_pay) / Number(payslip.total_working_days))}` : `₹0`}
                                    </td>
                                    {console.log(Number(payslip.total_deductions) > 0 ? `₹${payslip.lop_days
                                        * (Number(payslip.monthly_gross_pay) / Number(payslip.total_working_days))}` : `₹0`, "amnt", ((payslip.total_working_days)))}
                                </tr>
                                <tr className=' ' >
                                    <td className=' rounded-s p-1' >Total Deduction </td>
                                    <td className=' rounded-e p-1'>₹{Number(payslip.total_deductions)} </td>
                                </tr>
                            </table> */}
                        </main>
                        <section className='p-2 sm:w-1/2 ' >

                            <div className='flex    ' >
                                <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Net Pay  </p>
                                <p className='mb-2 ' >: {payslip.net_salary && Math.round(payslip.net_salary)} </p>
                            </div>
                            <div className='flex    ' >
                                <p className='sm:w-1/3  mb-1 fw-semibold text-slate-900 '>Amount In Words  </p>
                                <p className='mb-2 ' >: {payslip.net_salary && numberToWords(Math.round(payslip.net_salary))} </p>
                            </div>
                        </section>
                    </main>
                    {/* Structre */}

                    {/* <section className='flex w-full justify-center gap-3' >
                        <article className='tablebg col-sm-5 rounded table-responsive ' >
                            <table className='w-full' >
                                <tr>
                                    <th className=' p-2 text-center ' >Earnings </th>
                                    <th className=' p-2 text-center ' >Amount </th>
                                </tr>
                                {
                                    salaryTemplate && salaryTemplate.filter((obj) => obj.type == "Earning")
                                        .map((obj, index) => (
                                            <tr>
                                                <td>{obj.name_in_payslip} </td>
                                                <td>{obj.caluculate_type == "Flat_Amount" ?
                                                    Number(payslip.monthly_gross_pay) != 0 ?
                                                        `₹${obj.fixed_amount}` : '₹0' : ''}
                                                    {obj.caluculate_type != "Flat_Amount" &&
                                                        `₹${(obj.percentage_of_ctc / 100) *
                                                        (Number(payslip.net_salary) + Number(payslip.total_deductions))}`
                                                    }

                                                </td>
                                            </tr>
                                        ))
                                }
                                <tr>
                                    <td>Other Allowance </td>
                                    <td> ₹{Math.round(otherAllowance)} </td>
                                </tr>
                                <tr className=' ' >
                                    <td className='bg-blue-100 rounded-s ' >Gross earning </td>
                                    <td className='bg-blue-100 rounded-e '>₹{Number(payslip.net_salary) + Number(payslip.total_deductions)} </td>
                                </tr>
                            </table>

                        </article>
                        <article className='tablebg col-sm-5 rounded table-responsive ' >
                            <table className='w-full' >
                                <tr>
                                    <th className=' p-2 text-center ' >Deduction </th>
                                    <th className=' p-2 text-center ' >Amount </th>
                                </tr>
                                {
                                    salaryTemplate && salaryTemplate.filter((obj) => obj.type && obj.type.indexOf('P') != -1)
                                        .map((obj, index) => (
                                            <tr>
                                                <td>{obj.name_in_payslip} </td>
                                                <td>{obj.caluculate_type == "Flat_Amount" ?
                                                    Number(payslip.monthly_gross_pay) != 0 ?
                                                        `₹${obj.fixed_amount}` : '₹0' : ''}
                                                    {obj.caluculate_type != "Flat_Amount" && obj.percentage_of_ctc &&
                                                        `₹${(obj.percentage_of_ctc / 100) *
                                                        (Number(payslip.net_salary) + Number(payslip.total_deductions))}`
                                                    }

                                                </td>
                                            </tr>
                                        ))
                                }
                                <tr>
                                    <td>LOP </td>
                                    <td> {Number(payslip.total_deductions) > 0 ? `₹${payslip.lop_days && Math.round(payslip.lop_days)
                                        * (Number(payslip.monthly_gross_pay) / Number(payslip.total_working_days))}` : `₹0`}
                                    </td>

                                </tr>
                                <tr className=' ' >
                                    <td className='bg-blue-100 rounded-s ' >Total Deduction </td>
                                    <td className='bg-blue-100 rounded-e '>₹{Number(payslip.total_deductions)} </td>
                                </tr>
                            </table>

                        </article>
                    </section> */}
                    {/* Net payable */}
                    {/* <section className='border flex justify-between rounded my-3 '>
                        <div className='p-2 text-sm ' >
                            <p className='mb-1 fw-semibold ' > Total Net Payable </p>
                            <p className='mb-1 '>Gross Earnings - Total Deductions </p>
                        </div>
                        <div className='bg-green-100 px-3 flex rounded-e ' >
                            <p className='m-auto '> ₹{Math.round(payslip.net_salary)} </p>

                        </div>
                    </section> */}
                    {/* Amount In Words : Indian Rupee One Lakh Seven Thousand Four Hundred Fifty-Eight Only */}
                    {/* <p className='ms-auto'>Amount In Words : Indian Rupee
                        {payslip.net_salary && numberToWords(Math.round(payslip.net_salary))
                        }
                    </p> */}
                    {/* <hr /> */}
                    <p className='text-center '>-- This is a system-generated document. -- </p>

                </main> :
                <main className='h-[50vh] flex w-full  ' >
                    <div className=' m-auto bgclr1 p-5 rounded' >
                        Payslip is not generated for {getMonthYear(monthdata)}

                    </div>

                </main>
                : <main className='h-[50vh] flex w-full ' >
                    <Spinner className='m-auto' />
                </main>}
            {/* {payslip && !loading && <DownloadButton toPDF={toPDF} />} */}
            {payslip && !loading && (
                <GeneratePDF
                    divRef={slipRef}
                    filename={`${(payslip.employee_name || 'Employee').replace(/\s+/g, '_')}_${monthdata.split('-')[1]}_${monthdata.split('-')[0]}_payslip.pdf`.toLowerCase()}
                />
            )}

        </div>
    )
}

export default PaySlip