import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import EmployeeTable from '../../Components/Tables/EmployeeTable'
import HolidayTable from '../../Components/Tables/HolidayTable'
import { useParams } from 'react-router-dom'
import LeaveHistorySection from '../../Components/Leavecomponent/LeaveHistorySection'

const LeaveSummary = ({ empId }) => {
    let { setTopNav } = useContext(HrmStore)
    let [selectedOption, setSelectedOption] = useState('schedule')
    let [data, setData] = useState()
    let getData = () => {
        axios.get(`${port}/root/DisplayEmployeeCelebrations`).then((response) => {
            console.log(response.data, 'celeration');
            setData(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getData()
        setTopNav('summary')
        if(empId)
            setSelectedOption('past')
    }, [empId])
    return (
        <div>
            <main className='row p-1 poppins ' >
                <section className='col-lg-6 p-2 ' >
                    <article className='bg-white shadow-sm rounded h-full w-full p-3  ' >
                        <select name="" value={selectedOption} onChange={(e) => setSelectedOption(e.target.value)}
                            className='p-2 rounded bg-opacity-40 px-2 outline-none bg-slate-300 ' id="">
                            <option value="schedule">Scheduled Leaves & Holidays </option>
                            <option value="past">Past Leave Records</option>
                        </select>
                        {data && selectedOption == 'schedule' && <HolidayTable data={data.upcoming_holidays} css='h-[48vh] ' />}
                        {selectedOption == 'past' && <LeaveHistorySection empId={empId} />}
                    </article>
                </section>
                <section className='col-lg-6 p-2 ' >
                    <article className='bg-white shadow-sm rounded h-full w-full p-3  ' >
                        <h5> On Leave </h5>
                        {data && < EmployeeTable data={data.on_leaves} css='h-[48vh] ' />}

                    </article>

                </section>
            </main>
        </div>
    )
}

export default LeaveSummary