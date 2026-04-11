import React from 'react'
import { useNavigate } from 'react-router-dom'

const TableRow = ({ dates, empid, month, year, label, activityType, interviewData, objField }) => {
    let navigate = useNavigate()
    return (
        <tr>
            <td onClick={() => {
                navigate(`/activity/particularActivity/${empid}/?type=${activityType}&month=${month}&year=${year}`)
            }} style={{ minWidth: '250px' }} className='sticky-left cursor-pointer hover:bg-slate-50 ' >

                <p className='text-blue-600 mb-0 p-0 ' >
                    {label} </p>
            </td>
            <td className='sticky left-[260px] bg-white' >
                {interviewData && interviewData[activityType].reduce((acc, obj) => {
                    let num = obj[objField]?.length || 0
                    return acc + num
                }, 0)}
            </td>
            {
                dates && dates.map((date, index) => {
                    let findVal = interviewData[activityType].find((obj) => obj.date == date)
                    return (
                        <td onClick={() => {
                            if (findVal && findVal[objField].length > 0)
                                navigate(`/activity/particularActivity/${empid}?type=${activityType}&date=${date}`)
                        }} className={` ${findVal && findVal[objField].length > 0 && 'cursor-pointer hover:bg-slate-50'} `} >
                            <span className={` ${findVal && findVal[objField].length > 0 && ' text-blue-600 ' } `} >
                                {findVal ? findVal[objField].length : '--'}
                            </span>
                        </td>
                    )
                })}
        </tr>
    )
}

export default TableRow