import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import PlusIcon from '../../SVG/PlusIcon'
import HolidayModal from '../../Components/Modals/HolidayModal'
import axios from 'axios'
import { port } from '../../App'

const ShowHolidays = () => {
    let { activeSetting, setTopNav } = useContext(HrmStore)
    let [showHoliday, setShowHoliday] = useState(false)
    let year = new Date().getFullYear()
    let [selectedYear, setSelectedYear] = useState(year)
    let status = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    let permission = JSON.parse(sessionStorage.getItem('user'))?.user_permissions?.holiday_calender_creation
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let [data, setData] = useState([])
    let listedYear = []
    for (let i = 2000; i <= 2070; i++) {
        if (listedYear.indexOf(i) == -1)
            listedYear.push(i)
    }
    // function createStructure(value) {
    //     let months = ['Jan', 'Feb', 'Mar', 'Apr', 'may', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    //     let structure = []
    //     for (let val of months) {
    //         let obj = {
    //             month_name: val,
    //             holidays: []
    //         }
    //         structure.push(obj)
    //     }
    //     for (let i = 0; i < value.length; i++) {
    //         let month = Number(value[i].Date.slice(5,7))-1
    //         structure[month].holidays.push(value[i])
    //     }
    //     console.log('hellow', structure);
    // }
    // let value = [{
    //     Date: '2024-01-23',
    //     OccasionName: 'Diwali'
    // },
    // {
    //     Date: '2024-01-23',
    //     OccasionName: 'Diwali'
    // },
    // {
    //     Date: '2024-02-23',
    //     OccasionName: 'Diwali'
    // },
    // {
    //     Date: '2024-11-23',
    //     OccasionName: 'Diwali'
    // },
    // {
    //     Date: '2024-08-23',
    //     OccasionName: 'Diwali'
    // }]
    // createStructure(value)
    let getHoliday = () => {
        axios.get(`${port}/root/lms/CompanyHolidaysData/${selectedYear}/?login_emp=${empid}`).then((response) => {
            setData(response.data)
            console.log("hellow", response.data, selectedYear);
        }).catch((error) => {
            console.log(error);
        })
    }
    let [selectedholiday, setslectedHoliday] = useState()
    useEffect(() => {
        getHoliday()
        setTopNav('holidays')
    }, [selectedYear])
    return (
        <div>
            <HolidayModal selectedHoliday={selectedholiday} show={showHoliday} getHoliday={getHoliday} setshow={setShowHoliday} />
            <main className='tablebg rounded p-3'>
                <article className='flex justify-between items-center'>
                    <h5 className=' poppins '>Holiday Lists </h5>
                    {(status == 'HR' || status == 'admin' || permission) &&
                        <button onClick={() => setShowHoliday(true)}
                            className='flex items-center text-sm px-2 gap-2 btngrd p-1 rounded text-white'>
                            <PlusIcon />
                            Add Holiday
                        </button>}
                </article>
                <section className='flex gap-2 items-center w-fit ms-auto  my-2'>
                    Year :
                    <select name="" value={selectedYear} className='p-1 text-sm rounded w-20 outline-none'
                        onChange={(e) => setSelectedYear(e.target.value)} id="">
                        {listedYear.map((value) => (
                            <option value={value}>{value}</option>
                        ))}
                    </select>
                </section>
                <article className='flex my-2 flex-wrap justify-between gap-3'>
                    {
                        data && data.map((obj, index) => {
                            return (
                                <section key={index}
                                    className='border-1 p-2 hover:scale-[1.03] hover:bg-violet-50 bg-slate-50 hover:shadow rounded w-[20.4rem] h-[16rem] '>
                                    <p className='h-[2rem] px-2'>{obj.month_name} {selectedYear} </p>
                                    <div className='h-[11rem] px-2 overflow-y-scroll scrollmade2 '>
                                        {
                                            obj.holidays && obj.holidays.length > 0 ? obj.holidays.map((obj2, index) => (
                                                <article className='flex items-center gap-2'>
                                                    <div className='w-1/6 '>
                                                        <small className='fw-semibold text-slate-600'>{obj2.Date && obj2.Date.slice(-2)} </small> <br />
                                                        <small className='text-xs text-slate-500'> {obj2.Day && obj2.Day.slice(0, 3)}</small>
                                                    </div>
                                                    <small className='break-words text-slate-500'>{obj2.OccasionName} </small>
                                                    <small style={{ fontSize: '9px' }}
                                                        className={` ms-auto rounded-full p-[1px] px-[4px] border-1 `}>
                                                        {obj2.leave_type && obj2.leave_type.slice(0, 1)} </small>
                                                </article>
                                            )) :
                                                <div className='w-full flex text-slate-400 text-sm h-full m-auto'>
                                                    <small className='m-auto'>No Public Holidays</small>
                                                </div>
                                        }
                                        {
                                            obj.restricted_holidays && obj.restricted_holidays.length > 0 ? obj.restricted_holidays.map((obj2, index) => (
                                                <article className='flex items-center gap-2'>
                                                    <div className='w-1/6 '>
                                                        <small className='fw-semibold text-slate-600'>{obj2.holiday.Date && obj2.holiday.Date.slice(-2)} </small> <br />
                                                        <small className='text-xs text-slate-500'> {obj2.holiday.Day && obj2.holiday.Day.slice(0, 3)}</small>
                                                    </div>
                                                    <small className='break-words text-slate-500'>{obj2.holiday.OccasionName} </small>
                                                    <small style={{ fontSize: '9px' }}
                                                        className={` ms-auto rounded-full p-[1px] px-[4px] border-1 `}>
                                                        {obj2.holiday.leave_type && obj2.holiday.leave_type.slice(0, 1)} </small>
                                                </article>
                                            )) :
                                                <div className='w-full flex text-slate-400 text-sm h-full m-auto'>
                                                    <small
                                                        className='m-auto'>No Restricted Holidays</small>
                                                </div>
                                        }
                                        {
                                            obj.weekoffs && obj.weekoffs.length > 0 ? obj.weekoffs.map((obj2, index) => (
                                                <article className='flex items-center gap-2'>
                                                    <div className='w-1/6 '>
                                                        <small className='fw-semibold text-slate-600'>{obj2.date && obj2.date.slice(-2)} </small> <br />
                                                        <small className='text-xs text-slate-500'> {obj2.day && obj2.day.slice(0, 3)}</small>
                                                    </div>
                                                    <small className='break-words text-slate-500'>WeekOff </small>

                                                </article>
                                            )) :
                                                <div className='w-full flex text-slate-400 text-sm h-full m-auto'>
                                                    <small className='m-auto'>No Weekly Offs  </small>
                                                </div>
                                        }
                                    </div>
                                </section>
                            )
                        })
                    }
                </article>
                {/* <section className={`table-responsive `} >
                    <table className='w-full '>
                        <tr>
                            <th>SI NO </th>
                            <th>Holiday</th>
                            <th>Date </th>
                            <th>Day</th>
                            <th>Type </th>
                        </tr>
                        {
                            data && data.map((obj, index) => (
                                <tr>
                                    <td className=''>{index + 1} </td>
                                    <td>{obj.OccasionName} </td>
                                    <td>{obj.Date} </td>
                                    <td>{obj.Day} </td>
                                    <td>{obj.leave_type && obj.leave_type.replace(/_/g, ' ')} </td>
                                </tr>
                            ))
                        }
                    </table>
                </section> */}
            </main>
        </div>
    )
}

export default ShowHolidays