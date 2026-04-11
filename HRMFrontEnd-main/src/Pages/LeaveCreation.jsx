import React, { useContext, useEffect, useState } from 'react'
import Sidebar from '../Components/Sidebar'
import Topnav from '../Components/Topnav'
import { HrmStore } from '../Context/HrmContext'
import PlusIcon from '../SVG/PlusIcon'
import EditPen from '../SVG/EditPen'
import { useNavigate, useParams } from 'react-router-dom'
import axios from 'axios'
import { port } from '../App'
import { toast } from 'react-toastify'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'

const LeaveSetting = ({ subpage }) => {
    let { id } = useParams()
    let { setActivePage, setTopNav } = useContext(HrmStore)
    let navigate = useNavigate()
    let [leaveData, setleaveData] = useState({
        description: null,
        leave_name: null,
        id: null
    })
    let currentYear = new Date().getFullYear()
    let [selectedYear, setSelectedYear] = useState(currentYear)
    let [yearArry, setyearArry] = useState()
    let [loading, setloading] = useState('')
    let handleLeaveData = (e) => {
        let { value, name } = e.target
        setleaveData((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let [leaveObj, setLeaveObj] = useState({
        leave_type: null,
        No_Of_leaves: null,
        carry_forward: null,
        max_carry_forward: null,
        earned_leave: null,
        applicable_year: new Date(),
        applicable_to: null,
        is_active: false,
        id: null
    })
    let [leaveObjArry, setLeaveObjArry] = useState([])
    let changeLeaveObj = (year) => {
        let filterObj = leaveObjArry.find((obj) => obj.applicable_year.slice(0, 4) == year)
        setLeaveObj(filterObj)
        console.log(filterObj, "asd");
    }
    useEffect(() => {
        if (selectedYear && leaveObjArry) {
            changeLeaveObj(selectedYear)
        }
    }, [leaveObjArry, selectedYear])
    let handleLeaveObj = (e) => {
        let { name, value } = e.target
        setLeaveObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let addNextYear = () => {
        let year = new Date(leaveObj.applicable_year)
        let newYear = `${year.getFullYear() + 1}-${year.getMonth() + 1}-${year.getDate()}`
        console.log('asd', newYear);
        axios.post(`${port}/root/lms/LeaveTypeDetailsCreating/`, {
            ...leaveObj,
            applicable_year: newYear
        }).then((response) => {
            console.log("asd", response.data);
            getParticular()
            setSelectedYear(year.getFullYear() + 1)
            toast.success('Data has been added for the Next year')
        }).catch((error) => {
            console.log("asd", error);
            if (error.response.data) {
                toast.error(error.response.data)
                return;
            }
            toast.error('error acquired')
        })
    }
    let updateLeaveObj = () => {
        console.log("asd", leaveObj);
        setloading('save')
        try {
            axios.patch(`${port}/root/lms/LeaveTypeDetails/${id}/${leaveObj.id}/`, leaveObj)
            axios.patch(`${port}/root/lms/LeaveTypes/${id}/`, leaveData)
            toast.success("Updated successfull")
        }
        catch (error) {
            console.log(error);
            toast.error("Error Acquired")
        }
    }
    let getParticular = () => {
        axios.get(`${port}/root/lms/LeaveTypes/${id}/`).then((response) => {
            console.log("sdbls", response.data)
            setleaveData(response.data)
        }).catch((error) => {
            console.log("sdbls", error);
        })
        axios.get(`${port}/root/lms/LeaveTypeDetails/${id}/`).then((response) => {
            setLeaveObjArry(response.data)
            setyearArry(response.data.map((obj) => obj.applicable_year.slice(0, 4)))
            console.log("sdbls", response.data)
        }).catch((erro) => {
            console.log(erro);
        })
    }
    useEffect(() => {
        setActivePage("leave")
        setTopNav('creation')
        if (id) {
            getParticular()
        }

    }, [id])
    const renderTooltip = (text) => (
        <Tooltip id="button-tooltip">{text}</Tooltip>
    );
    return (
        <div>
            {!subpage && <Topnav name='Leaves Setting' />}
            {/* Sections */}
            {/* <button className='flex hover:scale-[1.02] duration-300 items-center p-2 rounded-lg btngrd text-white px-3 gap-2 ms-auto '>
                <PlusIcon />  Add leave
            </button> */}
            <select name="" value={selectedYear} onChange={(e) => setSelectedYear(e.target.value)}
                className='inputbg text-xs outline-none bg-transparent ms-auto flex rounded p-1' id="">
                <option value="">Select</option>
                {
                    yearArry && yearArry.map((val, index) => (
                        <option value={val}> {val} </option>
                    ))
                }

            </select>
            <main className='row my-4 justify-between mx-auto gap-3 raleway'>
                <section className='col-md-5 p-3 rounded bg-white border-2 border-white min-h-[10vh]  '>
                    <div className=''>
                        <h4>Leave type :</h4>
                        <div className='flex p-[10px] rounded-xl shadow-md inputbg w-full gap-2 '>
                            <input type="text" value={leaveData.leave_name}
                                name='leave_name' onChange={handleLeaveData}
                                className='outline-none bg-transparent flex-1  ' />
                            <EditPen />
                        </div>
                    </div>
                    <div className='my-3'>
                        <h4>Description :</h4>
                        <div className='flex gap-2 w-full p-[10px] rounded-xl shadow-md inputbg  '>
                            <textarea type="text" rows={5} value={leaveData.description}
                                name='description' onChange={handleLeaveData} className='flex-1 outline-none bg-transparent ' />
                            <EditPen />
                        </div>
                    </div>
                    <div className='my-3'>
                        <h4>Active Status :</h4>
                        {leaveObj && <div className='flex items-center gap-2'>
                            <input value={leaveObj.is_active} onChange={(e) => {
                                setLeaveObj((prev) => ({
                                    ...prev,
                                    is_active: true
                                }))
                            }} type="radio" checked={leaveObj.is_active} id='ayes' name='a' />
                            <label htmlFor="ayes">Active </label>
                            <input value={leaveObj.is_active} onChange={(e) => {
                                setLeaveObj((prev) => ({
                                    ...prev,
                                    is_active: false
                                }))
                            }} type="radio" id='ino' name='a' checked={!leaveObj.is_active} />
                            <label htmlFor="ino">InActive </label>
                        </div>}
                    </div>
                </section>

                {leaveObj && <section className='col-md-5 p-3 rounded bg-white border-2 border-white min-h-[10vh] '>
                    <h4 className='break-words'>{leaveData && leaveData.leave_name + " "}
                        {leaveData && leaveObj.applicable_year ? (leaveObj.applicable_year + '').slice(0, 4) : ''}
                    </h4>
                    <p className='fw-semibold text-sm '>Number of Days </p>
                    <div className='flex p-[10px] rounded-xl shadow-md inputbg w-fit '>
                        <input type="number" value={leaveObj.No_Of_leaves}
                            onChange={(e) => { if (e.target.value >= 0 && e.target.value <= 365) handleLeaveObj(e) }}
                            name='No_Of_leaves' className='outline-none bg-transparent ' />
                        <EditPen />
                    </div>
                    <article className='my-2'>
                        <p className='fw-semibold  '>  Carry forward</p>
                        <section className='flex flex-wrap flex-xl-nowrap items-center justify-between gap-3'>
                            <div className='flex items-center gap-2'>
                                <input value={leaveObj.carry_forward} onChange={(e) => {
                                    setLeaveObj((prev) => ({
                                        ...prev,
                                        carry_forward: true
                                    }))
                                }} type="radio" checked={leaveObj.carry_forward} id='cfyes' name='a' />
                                <label htmlFor="cfyes">Yes </label>
                                <input value={leaveObj.carry_forward} onChange={(e) => {
                                    setLeaveObj((prev) => ({
                                        ...prev,
                                        carry_forward: false,
                                        max_carry_forward: null
                                    }))
                                }} type="radio" id='cfno' name='a' />
                                <label htmlFor="cfno">No </label>
                            </div>
                            {leaveObj.carry_forward &&
                                <div className='inputbg gap-2 items-center rounded-xl flex p-2 shadow-md '>
                                    <button className='rounded bg-slate-400 bg-opacity-60 shadow-sm p-1 px-2'>
                                        MAX </button>
                                    <input type="text" value={leaveObj.max_carry_forward} name='max_carry_forward'
                                        onChange={(e) => { if (e.target.value >= 0 && e.target.value < 366) handleLeaveObj(e) }} className='outline-none bg-transparent w-28' />
                                    <EditPen />
                                </div>}
                        </section>

                    </article>
                    <article className='my-2'>
                        <p className='fw-semibold m-0 '> Paid Leave</p>
                        <div className='flex items-center my-2 gap-2'>
                            <input value={leaveObj.earned_leave} checked={leaveObj.earned_leave}
                                onChange={(e) => setLeaveObj((prev) => ({
                                    ...prev,
                                    earned_leave: true
                                }))}
                                type="radio" id='elyes' name='b' />
                            <label htmlFor="elyes">Yes </label>
                            <input value={leaveObj.earned_leave} checked={!leaveObj.earned_leave}
                                onChange={(e) => setLeaveObj((prev) => ({
                                    ...prev,
                                    earned_leave: false
                                }))} type="radio" id='elno' name='b' />
                            <label htmlFor="elno">No </label>
                        </div>
                        <div className='flex flex-wrap gap-3 items-center'>

                            <p className='fw-semibold m-0 '>Applicable to </p>

                            <select name="applicable_to" id="" value={leaveObj.applicable_to} onChange={handleLeaveObj}
                                className='outline-none inputbg p-2 rounded mx-2 '>
                                <option value="">Select</option>
                                <option value="probationer">Probation Period </option>
                                <option value="confirmed">Confirmed Employee </option>
                                <option value="both">Both</option>
                            </select>
                        </div>

                    </article>
                    <OverlayTrigger placement="top" delay={{ show: 150, hide: 200 }}
                        overlay={renderTooltip('Add for the next year')}>
                        <button onClick={addNextYear} className='border-2 p-1 ms-auto flex rounded-full '>
                            <PlusIcon />
                        </button>
                    </OverlayTrigger>


                </section>}


            </main>
            <div className='flex gap-3 justify-end'>
                <button onClick={() => navigate('/dash/leaveCreation')}
                    className=' bg-slate-700  w-40 p-2 px-3 rounded-xl hover:scale-[1.02] duration-300 text-white  '>
                    Cancel
                </button>
                <button
                    onClick={updateLeaveObj}
                    className='savebtn w-40 p-2 px-3 rounded-xl hover:scale-[1.02] duration-300 text-white border-green-500 '>
                    Save
                </button>
            </div>

        </div>
    )
}

export default LeaveSetting