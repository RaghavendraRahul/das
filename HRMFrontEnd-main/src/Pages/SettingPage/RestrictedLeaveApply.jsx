import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import { toast } from 'react-toastify'

const RestrictedLeaveApply = ({ setActiveSection }) => {
    let [restrictedholidays, setRestrictedHolidays] = useState()
    let getRestrictedHoliday = () => {
        axios.get(`${port}/root/lms/EmployeeHolidays/${JSON.parse(sessionStorage.getItem('user')).EmployeeId}/`)
            .then((response) => {
                console.log(response.data);
                setRestrictedHolidays(response.data)
            }).catch((error) => {
                console.log(error);
            })
    }
    let [loading, setloading] = useState()
    useEffect(() => {
        getRestrictedHoliday()
        setActiveSection('rh')
    }, [])
    let handleSave = (obj, index) => {
        setloading(index)
        axios.post(`${port}/root/lms/Approve_Employee_Leave_Request/`, {
            restricted_leave_type: obj.id,
            days: 1,
            employee: JSON.parse(sessionStorage.getItem('user')).EmployeeId,
            from_date: obj.holiday.Date,
            to_date: obj.holiday.Date,
            reason: `Leave applying for the Restricted holiday on ${obj.holiday.OccasionName}`
        }).then((response) => {
            setloading(null)
            console.log(response.data);
            toast.success('Leave request has been sended')
            getRestrictedHoliday()
        }).catch((error) => {
            setloading(null)
            if (error.response.data) { toast.error(error.response.data) }

            console.log(error);
        })
    }
    return (
        <div>
            <main className='bgclr rounded-xl p-4 min-h-[40vh] '>
                <h5>Company Approved Holidays </h5>
                {
                    restrictedholidays && restrictedholidays.length > 0 ?
                        <article className='flex flex-wrap justify-between gap-3 '>
                            {restrictedholidays.map((obj, index) => (
                                <div className='w-[12rem] formbg flex flex-col rounded pt-3 h-[8rem] border-2 ' key={index} >
                                    <h5 className='text-center '>{obj.holiday.OccasionName} </h5>
                                    <p className='text-center mb-0'>{obj.holiday.Date} </p>
                                    <p className='text-center mb-0'>{(!obj.is_expired && !obj.is_utilised) ? 'Applicable' :
                                        obj.is_expired && !obj.is_utilised ? 'Expired' :
                                            obj.is_expired || obj.is_utilised ? 'Used ' : ''}
                                    </p>
                                    {!obj.is_expired && !obj.is_utilised && !obj.is_applied &&
                                        <button disabled={obj.is_expired || loading == index}
                                            onClick={() => handleSave(obj, index)}
                                            className={`relative w-fit px-3 p-[2px] shadow text-sm rounded-full border-2 border-green-100 mx-auto top-3 mt-auto savebtn text-white `}>
                                            {loading == index ? "Loading" : "Apply Now"}
                                        </button>}
                                </div>
                            ))}
                        </article> :
                        <article className='w-full h-[30vh] flex'>
                            <h5 className='m-auto  poppins '> No Restricted Holiday Available</h5>

                        </article>
                }

            </main>
        </div>
    )
}

export default RestrictedLeaveApply