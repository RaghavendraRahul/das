import axios from 'axios'
import React, { useState } from 'react'

const BlockedEmpToggle = ({ setActiveEmployeeStatus, activeEmployeeStatus, setemployee, getEmployeee }) => {
    return (
        <div className='flex gap-2 items-center p-1 px-2 bg-slate-100 w-fit rounded-full ' >
            <button onClick={() => {
                setActiveEmployeeStatus('active');
                getEmployeee()
            }} className={` ${activeEmployeeStatus == 'active' ? ' bg-green-300 ' : ''} p-1 px-3 rounded-full duration-500 `} >
                Active
            </button>
            <button onClick={() => {
                setActiveEmployeeStatus('in_active')
                getEmployeee('in_active')
            }} className={` ${activeEmployeeStatus == 'in_active' ? 'bg-red-300 ' : ''} p-1 px-3 rounded-full duration-500  `} >
                Inactive
            </button>

        </div>
    )
}

export default BlockedEmpToggle