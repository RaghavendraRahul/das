import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App';
import { HrmStore } from '../../Context/HrmContext';
import { useNavigate } from 'react-router-dom';
import LoadingData from '../MiniComponent/LoadingData';
import DataNotFound from '../MiniComponent/DataNotFound';

const ActivityDataTable = ({ empid, dates, month, year, getTrigger, }) => {
    let { changeDateYear, selectValueToNormal, trigger } = useContext(HrmStore)

    let [loading, setloading] = useState(false)
    let [activityData, setActivityData] = useState()
    let getActivityData = () => {
        console.log(`${port}/root/new-employees-activity/${empid ?
            empid : JSON.parse(sessionStorage.getItem('dasid'))}?current_month=${month + 1}&current_year=${year}`, 'prdata');
        setloading(true)
        axios.get(`${port}/root/new-employees-activity/${empid ?
            empid : JSON.parse(sessionStorage.getItem('dasid'))}?current_month=${month + 1}&current_year=${year}`).then((response) => {
                console.log(response.data, 'prdata');
                setActivityData(response.data)
                setloading(false)
            }).catch((error) => {
                console.log(error);
                setloading(false)
            })
    }
    let getInterviewData = () => {
        axios.get(`${port}/root`).then((response) => {
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getActivityData()
        getInterviewData()
    }, [empid, month, year, getTrigger, trigger])
    let navigate = useNavigate()
    return (
        <div>

            <main className='table-responsive tablebg h-[40vh] my-3' >
                {loading ? <LoadingData css={' h-[40vh] '} /> :
                    activityData && activityData.length > 0 ?
                        <table className='w-full ' >
                            <thead>
                                <tr className=' '>
                                    <th scope="col" colSpan={3} className='text-center break-words text-break sticky-left ' style={{ minWidth: '450px' }}>Date</th>
                                    {dates.map(date => (
                                        <th key={date} rowSpan={2} className='text-center pb-4'>{date && changeDateYear(date)}</th>
                                    ))}
                                </tr>
                                <tr className='sticky left-0 '>
                                    <th scope="col" className='ms-3 break-words text-break sticky-left ' style={{ width: '150px' }}>Activity Nam</th>
                                    <th scope="col" className='text-center break-words text-break sticky-left1 ' style={{ width: '150px' }}>Target  </th>
                                    <th scope="col" className='text-center break-words text-break sticky-left2' style={{ width: '150px' }}>Achieved <span className='text-xs'>(Overall) </span></th>
                                </tr>
                            </thead>
                            {
                                activityData && activityData.map((obj, mainIndex) => (
                                    <tr>
                                        <td onClick={() => {
                                            navigate(`/activity/particularActivity/${empid ? empid : JSON.parse(sessionStorage.getItem('dasid'))}?aid=${obj.Activity}&month=${month}&year=${year}`)

                                        }}
                                            className=' break-words text-break sticky-left cursor-pointer hover:bg-slate-50' >
                                            <p className='mb-0 p-0 text-blue-600' >
                                                {obj.activity_name && selectValueToNormal(obj.activity_name)}
                                            </p>
                                        </td>
                                        <td className='text-center break-words text-break sticky-left1 ' > {obj.targets} </td>
                                        <td className='text-center break-words text-break sticky-left2'> {obj.Achived_target} </td>
                                        {
                                            dates && dates.map((date) => {
                                                let value = activityData[mainIndex]?.MonthAchivesList?.find((planObj) => planObj.Date == date)

                                                console.log(value?.achieved, 'prdata');
                                                return (
                                                    <td onClick={() => {
                                                        navigate(`/activity/particularActivity/${empid ? empid : JSON.parse(sessionStorage.getItem('dasid'))}?aid=${obj.Activity}&date=${date}`)

                                                    }} className={` ${value && value.achieved > 0 && "cursor-pointer hover:bg-slate-50"}  `} >
                                                        <span className={`${value && value.achieved > 0 ? 'text-blue-500 ' : ''}`} >

                                                            {value ? value.achieved : '--'}
                                                        </span>
                                                    </td>
                                                )
                                            })}
                                    </tr>
                                ))
                            }
                        </table> : <DataNotFound css='h-[37vh]' />
                }
            </main>

        </div>
    )
}

export default ActivityDataTable