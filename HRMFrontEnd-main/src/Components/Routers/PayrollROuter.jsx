import React, { useContext } from 'react'
import SalaryComponent from '../../Pages/Payroll/SalaryComponent'
import SalaryTemplate from '../../Pages/Payroll/SalaryTemplate'
import STEmployeeAssigning from '../../Pages/Payroll/STEmployeeAssigning'
import { Route, Routes } from 'react-router-dom'
import NewSideBar from '../MiniComponent/NewSideBar'
import Topnav from '../Topnav'
import PaySlip from '../../Pages/Payroll/PaySlip'
import PayslipTable from '../../Pages/Payroll/PayslipTable'
import { payrollRouters, payrollRoutersLinks } from './RouterLinks'
import RouterContext, { RouterStore } from '../../Context/RouterContext'
import CorrectionApprovalTable from '../../Pages/Payroll/CorrectionApprovalTable'

const PayrollROuter = () => {
    let { payrollRoutersLinks } = useContext(RouterStore)
    let status = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let subNav = payrollRoutersLinks
    return (
        <div>
            <main className='flex flex-col lg:flex-row '>
                <article className='sticky z-10 top-0'>
                    <NewSideBar />
                </article>
                <article className='flex-1 container-fluid px-0  overflow-hidden mx-auto'>

                    <Topnav navbar={subNav} />
                    <div className='p-2 ' >

                        <Routes>
                            <Route path='/*' element={<SalaryComponent />} />
                            <Route path='/salaryComponent/*' element={<SalaryComponent />} />
                            <Route path='/salary-templates/*' element={<SalaryTemplate />} />
                            <Route path='/salary-assigning' element={<STEmployeeAssigning subpage />} />
                            <Route path='/payslip/:id' element={<PaySlip />} />
                            <Route path='/employeesPayslip' element={<PayslipTable />} />
                            <Route path='/correction-approvals' element={<CorrectionApprovalTable />} />
                        </Routes>
                    </div>
                </article>
            </main>
        </div>
    )
}

export default PayrollROuter