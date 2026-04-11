import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'

const WeekLeaveAprovedEmp = (props) => {
    let { approvedHistory, setApprovedHistory } = props
    let {changeDateYear}=useContext(HrmStore)

    return (
        <div className='tablebg h-[21vh] overflow-y-scroll table-responsive '>
            <table className='w-full text-xs'>
                <tr className='sticky top-0 bgclr1' >
                    <th> SI NO </th>
                    <th>Employee</th>
                
                    <th> Dates </th>
                    <th>Leave Type </th>
                    <th> Reason</th>
                    <th>Days </th>
                    <th>Applied Date </th>
                    
                </tr>
                {approvedHistory && approvedHistory.map((obj, index) => {
                    return (
                        <tr key={index} className={` `} >
                            <td className=' '>{index + 1}</td>
                            <td>{obj.employee_name} </td>
                            <td>{changeDateYear(obj.from_date)}{obj.days > 1 ? " to " + changeDateYear(obj.to_date) : ''} </td>
                            <td> {obj.LeaveType} </td>
                            <td className='w-[200px] xl:w-[400px] text-wrap '>{obj.reason} </td>
                            <td>{obj.days} </td>
                            <td>{changeDateYear(obj.applied_date)} </td>
                            {/* <td>{obj.approved_status} </td> */}
                           

                        </tr>
                    )
                })
                }

            </table>

        </div>
    )
}

export default WeekLeaveAprovedEmp