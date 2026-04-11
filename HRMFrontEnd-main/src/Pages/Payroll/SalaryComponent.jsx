import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../../Components/Topnav'
import { Route, Routes, useNavigate } from 'react-router-dom'
import SalComEarning from './SalComEarning'
import SalComDeduction from './SalComDeduction'
import { HrmStore } from '../../Context/HrmContext'
import ScrollButton from '../../Components/SettingComponent/ScrollButton'
import SalComCreateComponent from './SalComCreateComponent'
import PreTaxDeduction from './PreTaxDeduction'
import PlusIcon from '../../SVG/PlusIcon'
import PostTaxDeduction from './PostTaxDeduction'

const SalaryComponent = () => {
    let { setActivePage, activeSetting, setActiveSetting, setTopNav } = useContext(HrmStore)
    let navigate = useNavigate()
    let [showDrop, setShowDrop] = useState(false)
    useEffect(() => {
        setActivePage('payroll')
        setTopNav('salarycom')
    }, [])
    
    return (
        <div  >
           <h5 className='poppins txtclr ' >Salary Component </h5>
            <section
                className=' relative w-fit flex items-center text-sm ms-auto my-3'>

                <button onClick={() => setShowDrop(!showDrop)} className='btngrd items-center px-4 text-white p-2 flex rounded '>
                    <PlusIcon size={14} /> Add Component
                </button>
                {showDrop &&
                    <div onMouseLeave={() => setShowDrop(false)}
                        className='min-h-[100px] z-10 text-sm shadow p-2 min-w-[100px] w-full top-10 bg-white rounded absolute '>
                        <button onClick={() => navigate('/payroll/salaryComponent/earning')}
                            className=' block hover:shadow hover:border-l-4 my-1 w-full p-2 text-start border-violet-800 '>
                            Earning type
                        </button>
                        <button onClick={() => navigate(`/payroll/salaryComponent/pre-tax-deduction`)} className='block hover:shadow hover:border-l-4 my-1 w-full p-2 text-start border-violet-800 '  >
                            Pre-Tax Deduction
                        </button>
                        <button onClick={() => navigate(`/payroll/salaryComponent/post-tax-deduction`)} className='block hover:shadow hover:border-l-4 my-1 w-full p-2 text-start border-violet-800'  >
                            Post-Tax Deduction
                        </button>
                    </div>}
            </section>
            <main className='flex gap-3 my-3 scrollmade overflow-x-scroll'>

                <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Earnings' path='/payroll/salaryComponent/' active='earning' />
                <ScrollButton activeSetting={activeSetting} setActiveSetting={setActiveSetting} name='Deductions' path='/payroll/salaryComponent/deduction' active='deduction' />



            </main>
            <Routes>
                <Route path='/*' element={<SalComEarning />} />
                <Route path='/deduction' element={<SalComDeduction />} />
                <Route path='/earning/:id?' element={<SalComCreateComponent />} />
                <Route path='/pre-tax-deduction/:id?' element={<PreTaxDeduction />} />
                <Route path='/post-tax-deduction/:id?' element={<PostTaxDeduction />} />

            </Routes>
        </div>
    )
}

export default SalaryComponent