import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../Components/Topnav'
import LeaveaddingModal from '../Components/Leavecomponent/LeaveaddingModal'
import PlusIcon from '../SVG/PlusIcon'
import axios from 'axios'
import { port } from '../App'
import { useNavigate } from 'react-router-dom'
import EditPen from '../SVG/EditPen'
import DustbinIcon from '../SVG/DustbinIcon'
import { HrmStore } from '../Context/HrmContext'
import ActionIcon from '../Components/Icons/ActionIcon'
import ThreeDot from '../SVG/ThreeDot'
import LoadingData from '../Components/MiniComponent/LoadingData'

const LeavePage = ({ subpage }) => {
    let { setActivePage, leaveData, setLeaveData, getLeaveData, setTopNav } = useContext(HrmStore)
    let [showLeaveAdding, setLeaveAdding] = useState(false)
    let navigate = useNavigate()
    let [showEditOptions, setEditOptions] = useState()

    useEffect(() => {
        getLeaveData()
        setTopNav('creation')
        setActivePage('leave')
    }, [])
    return (
        <div>
            {!subpage && <Topnav name="Leave adding" />}
            <button onClick={() => setLeaveAdding(true)}
                className='flex items-center p-2 rounded-lg bluebtn w-36 justify-center text-white px-3 gap-2 ms-auto '>
                <PlusIcon />  Add leave
            </button>
            <LeaveaddingModal getleave={getLeaveData} show={showLeaveAdding} setShow={setLeaveAdding} />

            <main className='tablebg rounded shadow p-3 my-3  '>
                <h4>Leave setting </h4>
                <div className='table-responsive'>
                    {leaveData ? <table className='w-full '>
                        <tr>
                            <th>
                                <ActionIcon />
                            </th>
                            <th className='w-14 '>SI no </th>
                            <th>Name </th>
                            <th>Description </th>
                            <th>No of Days </th>
                            {/* <th>Action </th> */}
                        </tr>
                        {leaveData && leaveData.map((obj, index) => (
                            <tr className={` ${showEditOptions == obj.id && 'bg-blue-50'} `} >
                                {console.log(obj, 'leaveobj')}
                                <td className='relative ' >
                                    <button onClick={() => {
                                        if (showEditOptions == obj.id)
                                            setEditOptions(-1)
                                        else
                                            setEditOptions(obj.id)
                                    }} className=' rotate-90 ' >
                                        <ThreeDot size={4} />
                                    </button>
                                    {showEditOptions == obj.id && <div
                                        className='absolute text-start bg-white z-10 left-9 top-1/3 p-2 rounded shadow   ' >
                                        <button className=' ' onClick={() => {
                                            navigate(`/leave/leaveSetting/${obj.id}`)
                                        }} >
                                            Edit
                                        </button>
                                        {/* <button className=' block
                                         my-2' >
                                            Delete
                                        </button> */}
                                    </div>}

                                </td>
                                <td>{index + 1} </td>
                                <td className='text-start'>{obj.leave_name} </td>
                                <td className='text-start break-words text-wrap '>{obj.description} </td>
                                <td className='w-28 '>  </td>
                                {/* <td className='w-20 flex justify-between '>
                                    <button onClick={() => navigate(`/leave/leaveSetting/${obj.id}`)}>
                                        <EditPen />
                                    </button>
                                    <button className='text-red-600'>
                                        <DustbinIcon />
                                    </button>
                                </td> */}
                            </tr>
                        ))

                        }

                    </table> : <LoadingData />}

                </div>

            </main>
        </div>
    )
}

export default LeavePage