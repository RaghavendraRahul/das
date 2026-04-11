import React, { useContext } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'
import DataNotFound from '../MiniComponent/DataNotFound'

const EmployeeTable = ({ nav, data, css }) => {
    let { changeDateYear } = useContext(HrmStore)
    let navigate = useNavigate()
    return (
        <div>
            {data && data.length > 0 ? <main className={` tablebg  ${css ? css : "h-[30vh]"} rounded table-responsive`} >
                {console.log(data, 'modal')
                }
                <table className='w-full ' >
                    <tr className=' sticky top-0 bg-white ' >
                        <th>SI No </th>
                        <th>Employee Id </th>
                        <th> Employee name </th>
                        {data[0].from_date && <th>Leave Start date </th>}
                        {data[0].date_of_birth && <th>Date of Brith</th>}
                        {data[0].hired_date && <th>Joined Date </th>}
                        <th> Department </th>
                        <th>Designation </th>

                    </tr>

                    {
                        data && data.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td onClick={() => {
                                    if (nav)
                                        navigate(`${nav}/${obj.employee_Id || obj.employee}`)
                                }} >
                                    <p className={` ${nav && 'text-blue-600 cursor-pointer  '} mb-0 `} >
                                        {obj.employee_Id || obj.employee} </p>
                                </td>
                                <td> {obj.full_name || obj.employee_name} </td>
                                {data[0].from_date && <td> {obj.from_date && changeDateYear(obj.from_date)} </td>}
                                {data[0].date_of_birth && <td> {obj.date_of_birth && changeDateYear(obj.date_of_birth)} </td>}
                                {data[0].hired_date && <td> {obj.hired_date && changeDateYear(obj.hired_date)} </td>}
                                <td> {obj.Department} </td>
                                <td> {obj.Designation} </td>

                            </tr>
                        ))
                    }
                </table>
            </main> :
                <DataNotFound />
            }
        </div>
    )
}

export default EmployeeTable