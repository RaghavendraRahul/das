import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import PlusIcon from '../../SVG/PlusIcon'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import { port } from '../../App'

const SalComEarning = () => {
    let { data, setActiveSetting, getEarningData } = useContext(HrmStore)
    let navigate = useNavigate()

    useEffect(() => {
        setActiveSetting('earning')
    }, [])
    useEffect(() => {
        getEarningData()
    }, [])
    return (
        <div>

            <section className='tablebg max-h-[67vh] rounded table-responsive  ' >
                <table className='w-full ' >
                    <thead>

                        <tr className='sticky top-0 bgclr1 ' >
                            <th>Name</th>
                            <th>Earning type  </th>
                            <th>Calculation type</th>
                            <th>Consider for EPF </th>
                            <th>Consider for ESI </th>
                            <th>Status  </th>
                        </tr>
                    </thead>
                    {
                        data && data.map((obj, index) => (
                            <tr key={index} >
                                <td onClick={() => navigate(`/dash/salaryComponent/earning/${obj.id}`)} className='cursor-pointer text-blue-600 '>
                                    {obj.name_in_payslip} </td>
                                <td>{obj.earning_name} </td>
                                <td>{obj.pay_type == "Fixed_Pay" ? 'Fixed' : 'Variable'} ;
                                    {obj.caluculate_type == "Flat_Amount" ? 'Flat amount' :
                                        `${obj.percentage_of_ctc}% of CTC`} </td>
                                <td>{obj.consider_for_epf ? "yes" : 'no'} </td>
                                <td>{obj.consider_for_esi ? "yes" : 'no'} </td>
                                <td> <span className={`${obj.earning_status ? "text-green-600" : 'text-slate-400'}  `} > {obj.earning_status ? "Active" : 'Inactive'} </span> </td>
                            </tr>
                        ))
                    }

                </table>

            </section>
        </div>
    )
}

export default SalComEarning