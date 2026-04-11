import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import Topnav from '../../Components/Topnav'
import axios from 'axios'
import { port } from '../../App'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { toast } from 'react-toastify'
import LoadingData from '../../Components/MiniComponent/LoadingData'
import AttendanceCorrectionModal from './AttendanceCorrectionModal'

const PayslipTable = () => {
    let { setActivePage, setTopNav } = useContext(HrmStore)
    let navigate = useNavigate()
    let [searchParams, setSearchParams] = useSearchParams()

    // Initialize monthdata from URL if available, otherwise default to current month
    let mon = new Date().getMonth() < 10 ? `0${new Date().getMonth()}` : new Date().getMonth()
    let year = new Date().getFullYear()
    const defaultMonth = `${year}-${mon}`

    let [monthdata, setMonth] = useState(searchParams.get('month') || defaultMonth)
    let [loading, setLoading] = useState()

    // Sync state if URL changes (e.g., browser back/forward or manual URL edit)
    useEffect(() => {
        const urlMonth = searchParams.get('month')
        if (urlMonth && urlMonth !== monthdata) {
            setMonth(urlMonth)
        }
    }, [searchParams])

    let [payslipData, setPaySlip] = useState([])

    // Correction Modal State
    const [isCorrectionModalOpen, setIsCorrectionModalOpen] = useState(false)
    const [selectedEmpForCorrection, setSelectedEmpForCorrection] = useState(null)
    useEffect(() => {
        setActivePage('payroll')
    }, [])
    let getPayslip = () => {
        setLoading('data')
        axios.get(`${port}/root/pms/EmployeesPaySlip/${monthdata.slice(5)}/${monthdata.slice(0, 4)}/`).then((response) => {
            console.log("pay", response.data);
            if (Array.isArray(response.data))
                setPaySlip(response.data)
            else
                setPaySlip([])
            setLoading(false)
        }).catch((error) => {
            console.log("pay", error);
            setLoading(false)
        })
    }
    let generatePayslip = () => {
        setLoading('payslip')
        axios.post(`${port}/root/pms/EmployeesPaySlip/${monthdata.slice(5)}/${monthdata.slice(0, 4)}/`).then((response) => {
            console.log(response.data, "pay");
            toast.success("Payslips generated successfully!");
            setLoading(false)
            getPayslip()
        }).catch((error) => {
            setLoading(false)
            toast.error("Failed to generate payslips.");
            console.log(error);
        })
    }
    let downloadPayslip = () => {
        setLoading('download')
        axios.get(`${port}/root/pms/DownloadEmployeePaySlipExcel/${monthdata.slice(5)}/${monthdata.slice(0, 4)}/`,
            {
                responseType: 'blob'
            }).then((response) => {
                console.log(response.data, 'Download');
                const url = window.URL.createObjectURL(new Blob([response.data]));
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', 'Payslip.xlsx');
                document.body.appendChild(link);
                link.click();
                link.parentNode.removeChild(link);
                setLoading(false)
            }).catch((error) => {
                console.log(error, 'Download');
                setLoading(false)
            })
    }
    useEffect(() => {
        getPayslip()
        setTopNav('allpayslip')
    }, [monthdata])

    return (
        <div>
            {/* <Topnav name='Empoyees payslip' /> */}
            {/* Table */}
            <main className='flex justify-between items-center' >
                <section className='my-3 ' >
                    <input type="month" value={monthdata} onChange={(e) => {
                        console.log(e.target.value);
                        setMonth(e.target.value)
                        setSearchParams({ month: e.target.value })
                    }}
                        className='p-1 bgclr1 px-2 bg-white outline-none rounded ' />
                </section>
                <div>
                    <button disabled={loading == 'payslip'} onClick={generatePayslip} className='p-2 mx-3 px-3 h-fit btngrd rounded text-white ' >
                        {loading == 'payslip' ? 'Loading..' : "Generate Payslip"}
                    </button>
                    <button onClick={downloadPayslip} disabled={loading == 'download'}
                        className='bg-slate-600 text-slate-50 p-2 rounded px-3 ' >
                        {loading == 'download' ? 'Loading..' : "Download"}
                    </button>
                </div>
            </main>
            <main className='rounded table-responsive h-[80vh] tablebg ' >
                <table className='w-full ' >
                    <tr className='sticky top-0 bg-white shadow-sm ' >
                        <th> SI No </th>
                        <th>Employee Name  </th>
                        <th>Designation </th>
                        <th>Paid days </th>
                        <th>LOP days </th>
                        <th>Bank Account No</th>
                        <th>Gross Salary</th>
                        <th>Salary for the month </th>
                        <th> Earnings</th>
                        <th>Deductions  </th>
                        <th>Payslip </th>
                        <th>Actions</th>
                    </tr>
                    {
                        loading != 'data' && payslipData && payslipData.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td>{obj.employee_name} </td>
                                <td>{obj.designation} </td>
                                <td>{obj.worked_days} </td>
                                <td>{obj.lop_days} </td>
                                <td>{obj.account_number} </td>
                                <td>{obj.monthly_gross_pay} </td>
                                <td>{obj.net_salary} </td>
                                <td>{obj.total_earnings} </td>
                                <td>{obj.total_deductions} </td>
                                <td>
                                    <button onClick={() => navigate(`/payroll/payslip/${obj.employee_id}?month=${monthdata}`)} className='text-xs bg-blue-600 text-white p-1 rounded px-3 ' >
                                        view
                                    </button>
                                </td>
                                <td>
                                    <button
                                        onClick={() => {
                                            setSelectedEmpForCorrection({
                                                id: obj.employee_id,
                                                name: obj.employee_name
                                            })
                                            setIsCorrectionModalOpen(true)
                                        }}
                                        className='text-xs bg-orange-500 text-white p-1 rounded px-3 hover:bg-orange-600'
                                    >
                                        Edit
                                    </button>
                                </td>
                            </tr>
                        ))
                    }

                </table>
                {loading == 'data' && <LoadingData />}
            </main>


            {
                isCorrectionModalOpen && selectedEmpForCorrection && (
                    <AttendanceCorrectionModal
                        employeeId={selectedEmpForCorrection.id}
                        employeeName={selectedEmpForCorrection.name}
                        month={monthdata.slice(5)} // Extract month from YYYY-MM
                        year={monthdata.slice(0, 4)} // Extract year from YYYY-MM
                        onClose={() => {
                            setIsCorrectionModalOpen(false)
                            setSelectedEmpForCorrection(null)
                            getPayslip() // Refresh data after correction
                        }}
                    />
                )
            }

        </div >
    )
}

export default PayslipTable