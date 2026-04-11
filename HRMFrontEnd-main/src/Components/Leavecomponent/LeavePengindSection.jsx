import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'

const LeavePengindSection = ({ setActiveSection }) => {
    let { getPendingLeave, pendingLeave, setPendingLeave, changeDateYear } = useContext(HrmStore)
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

    let cancelLeave = (id) => {
        axios.patch(`${port}/root/lms/LeaveWithdraw/${id}/cancel/`, {
            login_user: empid
        }).then((response) => {
            console.log(response.data);
            toast.success('Leave request has been withdrawn!!')
            getPendingLeave()
        }).catch((error) => {
            console.log(error);
            toast.error("error Acquired")

        })
    }


    useEffect(() => {
        setActiveSection('pending')
        getPendingLeave()
    }, [])
    return (
        <div>
            {pendingLeave && pendingLeave.length > 0 ?
                <section className='rounded-xl h-[43vh] pt-0 scrollbar1 overflow-y-scroll 
             table-responsive tablebg'>
                    <table className='w-full pt-0'>
                        <thead >
                            <tr className='sticky top-0 bgclr1'>
                                <th className='w-20'>SI No</th>
                                <th>Leave Type </th>
                                <th className=''>Leave Reason </th>
                                <th>Applied Date</th>
                                <th>No of Days leave </th>
                                <th>Dates </th>
                                <th> Status</th>
                                <th>Action </th>
                            </tr>
                        </thead>
                        {[...pendingLeave].map((obj, index) => (
                            <tr key={index} className={` `} >
                                <td>{index + 1}</td>
                                <td> {obj.LeaveType} </td>
                                <td className='mb-0 w-[300px] text-start  text-wrap '>
                                    {obj.reason}</td>
                                <td>{changeDateYear(obj.applied_date)} </td>

                                <td>{obj.days} </td>
                                <td>{changeDateYear(obj.from_date)}{obj.days > 1 ? " to " + changeDateYear(obj.to_date) : ''} </td>
                                <td>{obj.approved_status} </td>
                                <td><button onClick={() => cancelLeave(obj.id)}
                                    className='p-1 px-2 text-sm shadow-sm rounded bg-red-600 text-white  '>Cancel </button> </td>

                            </tr>
                        ))}
                    </table>
                </section> :
                <section className='min-h-[40vh] bgclr 
                 container-fluid mx-auto rounded-xl flex w-full'>
                    <h4 className='poppins m-auto'>  No pending leave requests at the moment.</h4>
                </section>
            }

        </div>
    )
}

export default LeavePengindSection