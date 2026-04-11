import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import Topnav from '../../Components/Topnav'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'
import { toast } from 'react-toastify'

const LeaveAllHistory = ({ subpage }) => {
    let { getLeaveData, leaveData, setActivePage, changeDateYear, setTopNav } = useContext(HrmStore)
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let empstatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let empNormalId = JSON.parse(sessionStorage.getItem('Login_Profile_Information')).id
    let navigate = useNavigate()
    let [allLeaveHistory, setAllLeaveHistory] = useState()
    let [allStatus, setAllstatus] = useState()
    let [filteredAllHistory, setfilteredAllHistory] = useState()
    let getAllLeaveHistory = () => {
        axios.get(`${port}/root/lms/ReportingTeam/Leaves/History/${empid}/`).then((response) => {
            console.log("history", response.data);
            setAllLeaveHistory(response.data)
            setfilteredAllHistory(response.data)
            setAllstatus(Array.from(new Set(response.data.map((obj) => obj.approved_status))))
        }).catch((error) => {
            console.log(error);
            console.log("history", error);
        })
    }

    let [filterOption, setFilterOption] = useState({
        name: "",
        leaveType: '',
        status: '',
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFilterOption((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    const HandleFilterRequest = () => {
        console.log('hello');

        const { name, leaveType, status } = filterOption;
        const nameLowerCase = name.toLowerCase();
        const newArray = allLeaveHistory.filter((obj) => {
            const matchesStatus = status ? obj.approved_status == status : true;
            const matchesName = name ? obj.employee_name.toLowerCase().includes(nameLowerCase) : true; //it will return true if condition true or value not there
            const matchesLeaveType = leaveType ? obj.LeaveType === leaveType : true;
            return matchesStatus && matchesName && matchesLeaveType; //if both also true mean it will be added in the array
        });

        // Using Set to ensure unique entries based on id
        const uniqueArray = Array.from(new Set(newArray.map(obj => obj.id))) //here the New Set will be created with the [1,2,3,4]
            .map(id => newArray.find(obj => obj.id === id)); // here the we are getting the Value from the newArray with our unique id's

        console.log(uniqueArray);
        setfilteredAllHistory(uniqueArray);
    };
    useEffect(() => {
        getAllLeaveHistory()
        getLeaveData()
        setActivePage('leave')
        setTopNav('history')
    }, [])

    let changeLeaveStatus = (obj, status) => {
        axios.patch(`${port}/root/lms/LeavesRequest/Handling/ByAdmin/`, {
            id: obj.id,
            approved_by: empNormalId,
            approved_status: status
        }).then((response) => {
            getAllLeaveHistory()
            toast.success(`Leave request of ${obj.employee_name} for ${obj.reason} is ${status}`)
        }).catch((error) => {
            console.log(error);
        })
    }

    return (
        <div>
            {!subpage && <Topnav name="Total Leaves History" />}

            <main className='flex flex-wrap items-center justify-between'>
                <section className='my-3 flex items-center flex-wrap gap-3'>
                    <div className='rounded p-2 bgclr w-fit '>
                        <input onKeyDown={(e) => {
                            if (e.key == 'Enter')
                                HandleFilterRequest()
                        }}
                            type="text" value={filterOption.name} name='name'
                            onChange={handleChange}
                            placeholder='Employee name' className='outline-none bg-transparent ' />
                    </div>
                    <select name="leaveType" onChange={handleChange}
                        value={filterOption.leaveType}
                        className='p-2 text-slate-500 bgclr text-sm rounded w-40 outline-none' id="">
                        <option value="">Leave type </option>
                        {leaveData && leaveData.map((obj, index) => (
                            <option value={obj.leave_name}>{obj.leave_name}
                            </option>
                        ))}
                    </select>
                    <select name="status" onChange={handleChange}
                        value={filterOption.status}
                        className='p-2 text-slate-500 bgclr text-sm rounded w-40 outline-none' id="">
                        <option value="">Approval Status </option>
                        {allStatus && allStatus.map((obj, index) => (
                            <option value={obj}>{obj}
                            </option>
                        ))}
                    </select>
                    <button onClick={HandleFilterRequest} className='p-2 h-fit px-4 w-40 text-white savebtn rounded '>
                        Search
                    </button>
                </section>
                <button className='p-2 px-3 bluebtn w-36 text-white text-sm h-fit rounded '
                    onClick={() => navigate('/leave/approvals')}>
                    Request
                </button>
            </main>
            {/* Table for all the employee */}


            <main className='tablebg rounded h-[70vh]  pt-0 overflow-y-scroll table-responsive '>
                {filteredAllHistory && filteredAllHistory.length > 0 ?
                    <table className='w-full pt-0 ' >
                        <tr className='sticky top-0 bgclr1'>
                            <th>SI No </th>
                            <th>Employee Name </th>
                            <th>Leave Type</th>
                            <th className=''>Reason </th>
                            <th>Duration </th>
                            <th>Applied Date </th>
                            {/* <th>Decision Date</th> */}
                            <th>From Date </th>
                            <th>To Date </th>
                            <th>Status </th>
                            <th>Processed Date</th>
                            <th>Processed by </th>
                        </tr>
                        {
                            filteredAllHistory && [...filteredAllHistory].reverse().map((obj, index) => (

                                <tr className='' key={index}>
                                    <td>{index + 1} </td>
                                    <td className='text-start  '>{obj.employee_name} ({obj.employee}) </td>
                                    <td>{obj.LeaveType} </td>
                                    <td style={{width:'500px'}} className=' text-wrap '>{obj.reason} </td>
                                    <td>{obj.days} </td>
                                    <td> {obj.applied_date && changeDateYear(obj.applied_date)} </td>
                                    {/* <td> {obj.approved_date && changeDateYear(obj.approved_date.slice(0, 10))} </td> */}
                                    <td>{obj.from_date && changeDateYear(obj.from_date)} </td>
                                    <td>{obj.to_date && changeDateYear(obj.to_date)} </td>
                                    {(empstatus != 'Admin' || obj.approved_status != 'approved') && <td>{obj.approved_status} </td>}
                                    {empstatus == 'Admin' && obj.approved_status == 'approved' && <td>
                                        <select onChange={(e) => changeLeaveStatus(obj, e.target.value)} value={obj.approved_status} className={`bg-transparent outline-none text-blue-600`} name="" id="">
                                            {allStatus && allStatus.filter((x) => x != 'canceled').map((x) => (
                                                <option value={x}>{x} </option>
                                            ))}
                                        </select>
                                    </td>}
                                    <td>{obj.approved_date && changeDateYear(obj.approved_date.slice(0, 10))} </td>
                                    <td>{obj.approved_name} ({obj.approved_by}) </td>
                                </tr>

                            ))
                        }
                    </table> : <div className='flex h-full '>
                        <p className='m-auto poppins'>No History of leave found under your employees </p>
                    </div>
                }


            </main>


        </div>
    )
}

export default LeaveAllHistory