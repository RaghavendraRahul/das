import React, { useContext, useState } from 'react'
import SwipingDetails from '../Modals/SwipingDetails'
import { HrmStore } from '../../Context/HrmContext'

const AttendenceShowingadminTable = ({ data, getAttendanceList, type }) => {
    let [showInfo, setShowinfo] = useState(false)
    let { changeDateYear, formatISODate } = useContext(HrmStore)
    function formatTime(inputTime) {
        // Split the input time to extract hours and minutes
        const [hours, minutes] = inputTime.split(":");
        let hrs = hours && hours > 0 ? `${hours} h` : ''
        let min = minutes && minutes > 0 ? `${minutes} m` : ''
        return `${hrs} ${min}`;
    }

    return (
        <div className={`min-h-[50vh] max-h-[63vh] my-3 rounded-xl overflow-y-scroll tablebg table-responsive
         ${type == 'personal' && 'border-0'}`}>
            <table className='w-full '>
                <thead>
                    <tr className='sticky top-0 bgclr1'>
                        <th>SI no </th>
                        {type != 'personal' && <th>Employee Name</th>}
                        {type != 'personal' && <th>Employee ID</th>}
                        <th>Date</th>
                        <th> Day </th>
                        <th>In Time</th>
                        <th>Out Time</th>
                        <th> Break Taken </th>
                        <th>Total Hours Worked </th>
                        <th>Late Arrival </th>
                        <th>Early Depature </th>
                        <th>Status </th>
                        <th>Exception/Comments </th>
                        <th> Remarks </th>
                        <th>Information </th>
                    </tr>
                </thead>
                <tbody >
                    {
                        data && [...data].reverse().map((obj, index) => (
                            <tr className={` ${obj?.Late_Arrivals ? ' bg-orange-50 ' : obj?.Day == 'Sunday' ? 'bg-yellow-50' : obj.Status && obj.Status.toLowerCase() == 'absent' ? 'bg-red-50'
                                : obj.Status && obj.Status.toLowerCase() == 'week_off' ? 'bg-yellow-50' : 'bg-green-50'} `}>
                                <td>{index + 1} </td>

                                {type != 'personal' && <td>{obj.Emp_Id && obj.Emp_Id.Name} </td>}
                                {type != 'personal' && <td className='text-nowrap ' >{obj.Emp_Id && obj.Emp_Id.EmployeeId} </td>}
                                <td className='text-nowrap ' >{changeDateYear(obj.date)} </td>
                                <td className='text-nowrap ' > {obj.Day} </td>
                                <td className='text-nowrap '>{obj.InTime ? formatISODate(obj.InTime) : '-'} </td>
                                <td>{obj.OutTime ? formatISODate(obj.OutTime) : '-'} </td>
                                <td>{obj.break_timings ? formatTime(obj.break_timings) : '-'} </td>
                                <td>{obj.Hours_Worked ? formatTime(obj.Hours_Worked) : '-'} </td>
                                <td> {obj.Late_Arrivals ? formatTime(obj.Late_Arrivals) : '-'} </td>
                                <td>{obj.Early_Depature ? formatTime(obj.Early_Depature) : '-'} </td>
                                <td className='text-nowrap '> {obj.Status}</td>
                                <td>{obj.leave_information} </td>
                                <td> {obj.remarks ? obj.remarks : '--'} </td>
                                <td onClick={() => setShowinfo(obj)} className='text-blue-600'>
                                    <button className=' text-blue-600 ' >
                                        info</button></td>
                            </tr>))
                    }
                </tbody>
            </table>
            <SwipingDetails getAttendanceList={getAttendanceList} show={showInfo} setshow={setShowinfo} />



        </div>
    )
}

export default AttendenceShowingadminTable