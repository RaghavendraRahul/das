import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App';
import { HrmStore } from '../../Context/HrmContext';
import { Spinner } from 'react-bootstrap';
import DataNotFound from '../MiniComponent/DataNotFound';
import { useNavigate } from 'react-router-dom';

const MyAttendance = () => {
    const currentDate = new Date();
    let { formatISODate, formatTime, convertTo12Hour } = useContext(HrmStore)
    const formattedDate = currentDate.getFullYear() + '-' +
        ('0' + (currentDate.getMonth() + 1)).slice(-2) + '-' +
        ('0' + currentDate.getDate()).slice(-2);
    let [date, setDate] = useState(formattedDate)
    let [loading, setloading] = useState(false)
    let [data, setData] = useState()
    let getAttendence = () => {
        setloading(true)
        axios.get(`${port}/root/lms/Employees/Daily/Attendance?date=${date}&login_emp=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, "lms");
            setData(response.data)
            setloading(false)
        }).catch((error) => {
            console.log(error);
            setloading(false)
        })
    }
    useEffect(() => {
        if (date)
            getAttendence()
    }, [date])
    let navigate = useNavigate()
    return (
        <div className='poppins ' >

            <main className='w-full p-3 rounded-xl h-[40vh]  overflow-y-auto bg-white     ' >
                <section className='flex justify-between items-center ' >

                    <h5 className='text-lg ' >Attendance Logs </h5>
                    <div className='flex items-center gap-2 ' >
                        <button onClick={()=>navigate('/leave/attendence-list')} className=' bg-blue-600 text-white text-xs p-2 px-3 rounded ' >
                            Check page
                        </button>
                        <input type="date" value={date} onChange={(e) => setDate(e.target.value)}
                            className='outline-none p-2 rounded bg-slate-50 ' />
                    </div>
                </section>
                {
                    loading ? <div className='min-h-[10vh] flex  ' >
                        <Spinner className='m-auto ' />
                    </div> : data ? <>
                        {
                            (JSON.parse(sessionStorage.getItem('user'))?.Disgnation == 'Admin' ||
                                JSON.parse(sessionStorage.getItem('user')).Disgnation == 'HR' ||
                                JSON.parse(sessionStorage.getItem('user'))?.Disgnation.toLowerCase() == 'manager')
                            &&
                            <section className='outline-none bgclr1 my-3 ' >
                                <div className='table-responsive max-h-[30vh] tablebg ' >
                                    <table className='w-full  ' >
                                        <tr className='sticky top-0 bgclr1 ' >
                                            <th>SI NO </th>
                                            <th>Employee Name </th>
                                            <th>Log-In Time </th>
                                            <th>Late Time </th>
                                            <th>Log-Out Time </th>
                                            <th>Early Log-Out </th>
                                        </tr>
                                        {
                                            data && data.map((obj, index) => (
                                                <tr>
                                                    <td>{index + 1} </td>
                                                    <td>{obj.Emp_Id && obj.Emp_Id.Name} </td>
                                                    <td>{obj.InTime ? formatISODate(obj.InTime) : '--'} </td>
                                                    <td>{obj.Late_Arrivals ? formatTime(obj.Late_Arrivals) : '--'} </td>
                                                    <td>{obj.OutTime ? formatISODate(obj.OutTime) : '--'} </td>
                                                    <td>{obj.Early_Depature ? formatTime(obj.Early_Depature) : '--'} </td>
                                                </tr>
                                            ))
                                        }

                                    </table>

                                </div>

                            </section>
                        }
                        {JSON.parse(sessionStorage.getItem('user'))?.Disgnation != 'admin' &&
                            JSON.parse(sessionStorage.getItem('user'))?.Disgnation.toLowerCase() != 'hr' &&
                            <section className='flex flex-wrap gap-3 justify-between ' >
                                {data.Day && <div className='my-1 flex gap-2 ' >
                                    <p className='w-32 mb-0 text-blue-600 fw-semibold ' >Day : </p> <span> {data.Day} </span>
                                </div>}
                                {data.InTime && <div className='my-1 flex gap-2 ' >
                                    <p className='w-32 mb-0 text-blue-600 fw-semibold ' >Entry Time : </p> <span> {formatISODate(data.InTime)} </span>
                                </div>}
                                {data.Late_Arrivals && <div className='my-1 flex gap-2 ' >
                                    <p className='w-32 mb-0 text-blue-600 fw-semibold ' >Late Arrivals Time :  </p><span> {data.Late_Arrivals && formatTime(data.Late_Arrivals)}</span>
                                </div>}
                                {data.OutTime && <div className='my-1 flex gap-2 ' >
                                    <p className='w-32 mb-0 text-blue-600 fw-semibold ' >Out Time : </p> <span> {formatISODate(data.OutTime)} </span>
                                </div>}
                                {data.Early_Depature && <div className='my-1 flex gap-2 ' >
                                    <p className='w-32 mb-0 text-blue-600 fw-semibold ' >Early Depature : </p> <span> {data.Early_Depature && formatTime(data.Early_Depature)} </span>
                                </div>}
                            </section>}
                    </> :
                        <DataNotFound />
                }

            </main>


        </div>
    )
}

export default MyAttendance