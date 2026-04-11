import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import CloseIcon from '../Icons/CloseIcon'
import { toast } from 'react-toastify'
import { Modal } from 'react-bootstrap'

const EmployeeWeekOff = ({ page, id }) => {
    console.log(id, 'employee data');

    let [data, setData] = useState({
        weekoff_days: [],
        employee_id: id ? id : JSON.parse(sessionStorage.getItem('dasid')),
        three_months: false,
        six_months: false,
        onetwo_months: false,
        year: new Date().getFullYear(),
        month: new Date().getMonth() + 1
    })

    let [loading, setLoading] = useState()
    const monthDropDown = [
        { mon: 'January', val: 1 }, { mon: 'February', val: 2 }, { mon: 'March', val: 3 }, { mon: 'April', val: 4 }, { mon: 'May', val: 5 }, { mon: 'June', val: 6 },
        { mon: 'July', val: 7 }, { mon: 'August', val: 8 }, { mon: 'September', val: 9 }, { mon: 'October', val: 10 }, { mon: 'November', val: 11 }, { mon: 'December', val: 12 }
    ];
    let [weekOffDays, setWeekOffDays] = useState()
    let getWeekOffDaysDropDown = () => {
        axios.get(`${port}/root/lms/Weekoffs`).then((response) => {
            setWeekOffDays(response.data)
            console.log(response.data, 'weekoff');
            setLoading(false)
        }).catch((error) => {
            console.log(error, 'weekoff remove');

            setLoading(false)
        })
    }
    let postWeekOff = async () => {
        setLoading(true)
        data = {
            ...data,
            weekoff_days: data.weekoff_days.map((obj) => obj.id)
        }
        console.log(data, 'employee data');

        if (data.id) {
            delete data.employee_id
            await axios.patch(`${port}/root/lms/Weekoffs?weekoff_id=${data.id}`, data).then((response) => {
                console.log(response.data);
                setLoading(false)
                toast.success('Updated Successfully')
            }).catch((error) => {
                console.log(error, 'weekoff update');
                setLoading(false)
                toast.error('Error occured')
            })
        }
        else
            await axios.post(`${port}/root/lms/Weekoffs`, data).then((response) => {
                toast.success('Added successful')
                setLoading(false)
                console.log(response.data,'Adding Data');
                window.location.reload()
            }).catch((error) => {
                console.log(error, 'Error adding');
                if (error?.response?.data)
                    toast.error(error.response.data)
                else
                    toast.error('Error occured')
                setLoading(false)
            })
    }
    let handleChange = (e) => {
        let { value, name } = e.target
        if (name === 'weekoff_days' && data.weekoff_days.find((val) => val === value)) {
            value = data.weekoff_days.filter((obj) => obj.id !== value);
        } else if (name === 'weekoff_days' && data.weekoff_days.findIndex((val) => val.id === value) === -1) {
            value = [...data.weekoff_days, weekOffDays.find((obj) => obj.id == value)];
        }
        setData((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getParticularEmpWeekOff = () => {
        console.log(`${port}/root/lms/Weekoffs?weekoff_emp=${id ? id :
            JSON.parse(sessionStorage.getItem('dasid'))}&month=${data.month}&year=${data.year}`);

        axios.get(`${port}/root/lms/Weekoffs?weekoff_emp=${id ? id :
            JSON.parse(sessionStorage.getItem('dasid'))}&month=${data.month}&year=${data.year}`).then((response) => {
                console.log(response.data, 'weekoff trigger');
                
                setData((prev) => ({
                    ...response.data[0],
                    employee_id: id ? id : JSON.parse(sessionStorage.getItem('dasid'))
                }))
            }).catch((error) => {
                console.log(error, 'weekoff trigger');
                setData((prev) => ({
                    ...prev,
                    weekoff_days: [],
                    id: null,
                }))
            })
    }
    useEffect(() => {
        getWeekOffDaysDropDown()
    }, [])
    useEffect(() => {
        console.log("weekoff triggered with:", data, data.year, data.month);
        if (data.year && data.month)
            getParticularEmpWeekOff()
    }, [data.year, data.month])
    return (
        <div className={` ${page == 'inner' && 'h-[40vh] '} p-3 rounded-xl bgclr w-full  `} >
            <h4 className=' '>Week Off Information </h4>
            {/* Day */}
            <div className=' my-2 flex  items-center ' >
                <label htmlFor="" className='w-52 ' >
                    Day :
                </label>
                <select className=' outline-none p-1 px-2 rounded flex-grow-1 ' name="weekoff_days" onChange={handleChange} id="">
                    <option value="">Select</option>
                    {
                        weekOffDays && weekOffDays.map((obj, index) => (
                            <option value={obj.id}>{obj.day} </option>
                        ))
                    }
                </select>
            </div>
            <div className='my-2 flex flex-wrap ' >
                <label htmlFor="" className='w-52 ' >
                    Year :  </label>
                <input type="text" name='year' onChange={handleChange}
                    value={data.year} className='outline-none p-1 px-2 rounded flex-grow-1 ' />
            </div>
            <div className='my-2 flex flex-wrap ' >
                <label htmlFor="" className='w-52 ' >
                    Month :  </label>
                <select className=' outline-none p-1 px-2 rounded flex-grow-1 '
                    value={data.month} name="month" onChange={handleChange} id="">
                    <option value="">Select</option>
                    {
                        monthDropDown && monthDropDown.map((obj, index) => (
                            <option value={obj.val}>{obj.mon} </option>
                        ))
                    }
                </select>
            </div>
            {/* Selected days */}
            <div className='my-2 flex flex-wrap items-center  ' >
                <label htmlFor="" className='w-52 ' >
                    Selected Days :  </label>
                <div className='flex flex-wrap ' >
                    {
                        data?.weekoff_days?.map((val) => (
                            <div className='mx-2 bg-slate-200 p-1 text-sm px-2 relative rounded my-1 ' >
                                <button onClick={() => {
                                    setData((prev) => (
                                        {
                                            ...prev,
                                            weekoff_days: data.weekoff_days.filter((obj) => obj !== val)
                                        }
                                    ))
                                }}
                                    className='p-1 text-red-600 rounded-full  ' >
                                    <CloseIcon size={13} />
                                </button>
                                {weekOffDays.find((obj) => obj.id == val.id)?.day}
                            </div>
                        ))
                    }
                </div>
            </div>
            <button disabled={loading} onClick={postWeekOff}
                className={` ms-auto flex my-3 text-center savebtn text-green-50 p-1 px-2 rounded `} >
                {loading ? 'Loading...' : "Submit"}
            </button>
        </div>
    )
}

export default EmployeeWeekOff