import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import {port} from '../App' 



const Empattendance = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

    const [AllDepartmentlist, setAllDepartmentlist] = useState([])

    useEffect(() => {

        axios.get(`${port}/root/ems//${Empid}/`).then((res) => {
            console.log("AllEmployee_res", res.data);
            setAllDepartmentlist(res.data)

        }).catch((err) => {
            console.log("AllEmployee_err", err.data);
        })

    }, [])


    const [currentMonthDays, setCurrentMonthDays] = useState([]);


    useEffect(() => {
        const daysInMonth = getDaysInMonth(new Date().getMonth() + 1, new Date().getFullYear());
        setCurrentMonthDays([...Array(daysInMonth).keys()].map(i => i + 1));


    }, []);



    // Function to get the number of days in a month
    const getDaysInMonth = (month, year) => {
        return new Date(year, month, 0).getDate();
    };
    return (
        <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav>

                <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                    <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Attendance</h6>

                    <div>
                        <button className='btn btn-sm bg-info-subtle'>Add New</button>
                    </div>
                </div>
                <div className='d-flex justify-content-end mt-2'>
                    <input type="text" className='form-control w-25' />
                    <button className='btn btn-sm bg-primary-subtle'> Search</button>
                </div>




                <div className='row  p-1 mt-3 '    >

                    <table className='table p-3'  >
                        <thead>
                            <tr >
                                <th scope="col">EMPLOYEE</th>
                                {currentMonthDays.map(day => (
                                    <th key={day} scope="col">{day}</th>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            

                        </tbody>
                    </table>

                </div>






            </div>



        </div>
    )
}

export default Empattendance