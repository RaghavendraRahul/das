import React, { useContext, useEffect } from 'react'
import Topnav from '../../Components/Topnav'
import { Route, Routes } from 'react-router-dom'
import STtable from './STtable'
import STcreation from './STcreation'
import { HrmStore } from '../../Context/HrmContext'

const SalaryTemplate = () => {
  let {setActivePage,setTopNav}=useContext(HrmStore)
  useEffect(() => {
    setActivePage('payroll')
    setTopNav('template')
  }, [])
  return (
    <div className='p-2 ' >
      {/* <Topnav name='Salary Templates' /> */}
      <Routes>
        <Route path='/*' element={<STtable />} />
        <Route path='/template/:id?' element={<STcreation />} />

      </Routes>

    </div>
  )
}

export default SalaryTemplate