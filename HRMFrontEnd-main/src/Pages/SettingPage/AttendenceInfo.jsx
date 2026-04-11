import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import SwipingDetails from '../../Components/Modals/SwipingDetails'
import axios from 'axios'
import { port } from '../../App'
import AttendenceShowingadminTable from '../../Components/Tables/AttendenceShowingadminTable'

const AttendenceInfo = () => {
    let { setTopNav, getProperDate } = useContext(HrmStore)
    let empid = JSON.parse(sessionStorage.getItem('user'))?.EmployeeId
    let [attendanceList, setAttendanceList] = useState([])
    let [show, setshow] = useState('')
    let [filterObj, setFilterObj] = useState({
        fromtime: '',
        totime: ''
    })
    
    let handleChange = (e) => {
        let { name, value } = e.target
        setFilterObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    function currentMonthDates() {
        const currentDate = new Date()
        const year = currentDate.getFullYear();
        const month = currentDate.getMonth();
        const startDate = getProperDate(new Date(year, month, 1));
        const endDate = getProperDate(new Date(year, month + 1, 0));
        setFilterObj({
            fromtime: startDate,
            totime: endDate
        })
        getAttendanceList(startDate, endDate)
        console.log(startDate, endDate);
    }

    let getAttendanceList = (stdate, endate) => {
        if (empid && stdate && endate) {
            axios.get(`${port}/root/lms/employee-attendance/${empid}/${stdate}/${endate}/`).then((response) => {
                setAttendanceList(response.data.attendance_data)
                console.log(`${port}/root/lms/employee-attendance/${empid}/${stdate}/${endate}/`,'api');
                
                console.log("apiarry", response.data);
            }).catch((error) => {
                console.log("arry", error);
            })
        }
    }
    useEffect(() => {
        setTopNav('attendence')
        currentMonthDates()
    }, [empid])
    return (
        <div>
            <section className='flex flex-wrap items-center gap-3'>
                <div className='bgclr w-fit rounded ps-3'>
                    From :
                    <input onChange={handleChange} name='fromtime' value={filterObj.fromtime}
                        type="date" className='p-2 bg-transparent rounded outline-none' />
                </div>
                <div className='bgclr w-fit rounded ps-3'>
                    To :
                    <input onChange={handleChange} name='totime' value={filterObj.totime}
                        type="date" className='p-2 bg-transparent rounded outline-none' />
                </div>
                <button onClick={() => getAttendanceList(filterObj.fromtime, filterObj.totime)} className='savebtn p-2 rounded border-2 border-green-50 text-white w-40'>
                    Search
                </button>
            </section>
            {/* Table */}

            <main className='bgclr my-3 rounded p-2'>
                <h6>Attendence report </h6>
                {attendanceList &&
                    <AttendenceShowingadminTable type='personal' getAttendanceList={currentMonthDates} data={attendanceList} />}


            </main>
            <SwipingDetails show={show} setshow={setshow} />
        </div>
    )
}

export default AttendenceInfo