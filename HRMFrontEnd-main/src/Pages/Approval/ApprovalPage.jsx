import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../../Components/Topnav'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'
import { Modal } from 'react-bootstrap'
import QuestionIcon from '../../SVG/QuestionIcon'

const ApprovalPage = ({ page, subpage }) => {
    let { leaveRequestsReporting, openNavbar, setActivePage, getProperDate, changeDateYear,
        setLeaveRequestReporting, getLeaveRequestsReporting } = useContext(HrmStore)
    let { leaveData, setLeaveData, getLeaveData, setTopNav } = useContext(HrmStore)
    let [leaveResendModal, setLeaveResendModal] = useState()
    let id = JSON.parse(sessionStorage.getItem('Login_Profile_Information'))?.id
    let [reason, setreason] = useState()
    let userStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation

    let reportingStatus = JSON.parse(sessionStorage.getItem('user')).is_reporting_manager
    let [reasonModal, setreasonModal] = useState({
        obj: null,
        status: '',
        index: '',
    })

    let [filteredRequest, setFilteredRequest] = useState()
    // Safely parse profile info and compute approver id
    let loginId = {}
    try {
        const _l = sessionStorage.getItem('Login_Profile_Information')
        if (_l) loginId = JSON.parse(_l)
    } catch (e) {
        loginId = {}
    }
    // prefer explicit profile id, fall back to parsed loginId.id, then to session user EmployeeId
    let approverId = id || loginId.id || JSON.parse(sessionStorage.getItem('user'))?.EmployeeId || null
    let [loading, setloading] = useState('')
    let [filterOption, setFilterOption] = useState({
        name: "",
        leaveType: ''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFilterOption((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    useEffect(() => {
        if (!page)
            setActivePage('leave')
        getLeaveRequestsReporting()
        getLeaveData()
    }, [page])
    useEffect(() => {
        setTopNav('approval')
        setFilteredRequest(leaveRequestsReporting)
    }, [leaveRequestsReporting])

    let HandleFilterRequest = () => {
        let { name, leaveType } = filterOption
        let lowercaseName = name.toLowerCase()
        if (leaveRequestsReporting) {
            let filteredArry = leaveRequestsReporting.filter((obj) => {
                let nameMatching = name ? obj.employee_name.toLowerCase().includes(lowercaseName) : true
                let leavetypeMatchting = leaveType ? obj.LeaveType == leaveType : true
                return nameMatching && leavetypeMatchting
            })
            let uniquearry = Array.from(new Set(filteredArry.map((obj) => obj.id)))
                .map((id) => leaveRequestsReporting.find((obj) => obj.id == id))
            setFilteredRequest(uniquearry)
        }
    }
    let navigate = useNavigate()
    let handleRequest = (obj, status, index) => {
        setloading(`${status}${index}`)
        let boolean = status == 'rejected' ? false : true
        if (obj.is_hr_permission_required) {
            let formobj = {
                id: obj.id,
                approved_by: approverId,
                approved_status: 'pending'
            }
            if (userStatus == 'HR') {
                // formobj.is_approved_by_hr = boolean
                formobj.hr_reason = reason
                formobj.hr_status = status
                // formobj.is_approved_by_rm=''
            } else if (reportingStatus) {
                // formobj.is_approved_by_hr=''
                formobj.rm_reason = reason
                formobj.rm_status = status
                // formobj.is_approved_by_rm = boolean
            }
            console.log(userStatus);
            console.log(formobj);
            // alert('hellow')
            if (!approverId) {
                toast.error('Approver identity missing. Please login again.')
                setloading('')
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
                return
            }

            axios.patch(`${port}/root/lms/Approve_Employee_Leave_Request/`, formobj).then((response) => {
                console.log(response.data);
                setloading('')
                getLeaveRequestsReporting()
                toast.success(`Request got ${status}!!`)
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
            }).catch((error) => {
                console.log(error);
                toast.error('Error Acquired')
                setloading('')
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
            })
        }
        else
            if (!approverId) {
                toast.error('Approver identity missing. Please login again.')
                setloading('')
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
                return
            }

            axios.patch(`${port}/root/lms/Approve_Employee_Leave_Request/`, {
                id: obj.id,
                approved_status: status,
                approved_by: approverId,
                rm_reason: reason
            }).then((response) => {
                console.log(response.log);
                setloading('')
                getLeaveRequestsReporting()
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
                toast.success(`Request got ${status}!!`)
            }).catch((error) => {
                console.log(error);
                toast.error('Error Acquired')
                setloading('')
                setreasonModal({
                    obj: null,
                    status: '',
                    index: '',
                })
            })
    }
    return (
        <div className=''>
            {!page && !subpage && <Topnav name="Leave Approval" />}
            {!page && <main className='flex flex-wrap items-center justify-between'>
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
                        className='p-2 text-slate-500 bgclr rounded w-40 outline-none' id="">
                        <option value="">Leave type </option>
                        {leaveData && leaveData.map((obj, index) => (
                            <option key={index} value={obj.leave_name}>{obj.leave_name}
                            </option>
                        ))}
                    </select>

                    <button onClick={HandleFilterRequest}
                        className='p-2 h-fit px-4 w-40 text-white savebtn rounded '>
                        Search
                    </button>
                </section>
                <button className='p-2 w-36 px-3 bluebtn  text-sm h-fit rounded ' onClick={() => navigate('/leave/history')}>
                    History
                </button>
            </main>}
            {
                (leaveRequestsReporting && leaveRequestsReporting.length > 0) ?
                    <section className={`rounded-xl tablebg table-responsive `}>
                        <table className='w-full '>
                            <thead>
                                <tr>
                                    <th className='w-20'>SI No</th>
                                    <th>Employee Name</th>
                                    <th>Leave Type </th>
                                    <th className='w-[300px] '>Reason</th>
                                    <th>Duration </th>
                                    <th>Supporting Document </th>
                                    <th>Application Date </th>
                                    <th>Leave Period </th>
                                    <th>Approval Status</th>
                                    <th>Actions </th>
                                </tr>
                            </thead>
                            {filteredRequest && filteredRequest.map((obj, index) => (
                                <tr key={index} className={` `} >
                                    <td className=' '>{index + 1}</td>
                                    <td onClick={()=>{
                                        navigate(`/leave?empid=${obj.employee}`)
                                    }} className='cursor-pointer ' >
                                        <p className='mb-0 cursor pointer text-blue-600 ' >
                                            {obj.employee_name} </p>
                                    </td>
                                    <td> {obj.LeaveType} </td>
                                    <td className='w-[200px] xl:w-[400px] text-wrap '>{obj.reason} </td>
                                    <td>{obj.days} </td>
                                    <td>{obj.Document ? <a href={obj.Document} target='_blank'>
                                        Click Here </a> : 'None'}  </td>
                                    <td>{changeDateYear(obj.applied_date)} </td>
                                    <td>{changeDateYear(obj.from_date)}{obj.days > 1 ? "-" + changeDateYear(obj.to_date) : ''} </td>
                                    <td>{obj.approved_status} </td>
                                    <td className='flex gap-2 p-3 relative'>
                                        {(obj.hr_status || obj.rm_status) &&
                                            <button onClick={() => setLeaveResendModal(obj)}
                                                className='absolute top-1 right-0 '> <QuestionIcon size={12} />
                                            </button>}




                                        {((obj.hr_status == null && (userStatus == 'HR' || userStatus == 'Admin'))
                                            || (obj.rm_status == null && (userStatus != 'HR' || userStatus == 'Admin')))
                                            &&
                                            <button onClick={() => setreasonModal({
                                                obj: obj,
                                                status: 'rejected',
                                                index: index
                                            })} className='p-1 px-2 text-sm shadow-sm rounded bg-red-600 text-white  '>
                                                {loading == `rejected${index}` ? 'Loading..' : "Decline"}
                                            </button>}


                                        {(
                                            (obj.hr_status == null && (userStatus == 'HR' || userStatus == 'Admin'))
                                            || (obj.rm_status == null && (userStatus != 'HR' || userStatus == 'Admin'))

                                        )
                                            && <button onClick={() => setreasonModal({
                                                obj: obj,
                                                status: 'approved',
                                                index: index
                                            })} className='p-1 px-2 text-sm shadow-sm rounded bg-green-600 text-white  '>
                                                {loading == `approved${index}` ? 'Loading' : "Accept"}
                                                {console.log(userStatus != 'Admin')
                                                }
                                            </button>}

                                        {
                                            ((obj.hr_status != null && obj.rm_status != null) ||
                                                (userStatus != 'HR' && userStatus != 'Admin'))
                                            && <button onClick={() => setLeaveResendModal(obj)} className='btngrd text-white p-1 rounded '>
                                                view </button>
                                        }
                                    </td>

                                </tr>
                            ))}
                        </table>
                    </section> :
                    <section className='bgclr min-h-[40vh] rounded-xl flex container-fluid  mx-auto  '>
                        <h4 className='m-auto '>No Leave Requests are there!!!</h4>
                    </section>
            }
            {leaveResendModal && <Modal centered show={leaveResendModal} onHide={() => setLeaveResendModal(false)} className=''>
                <Modal.Header closeButton>
                    Leave Report
                </Modal.Header>
                <Modal.Body>
                    {console.log(leaveResendModal)}
                    {leaveResendModal.rm_status != '' && (userStatus == 'HR' || userStatus == 'Admin') && <>
                        Leave request got {leaveResendModal.rm_status} by the Reporting manager for the reason : {leaveResendModal.rm_reason}
                    </>
                    }
                    {leaveResendModal.hr_status != '' && userStatus != 'HR' && <>
                        Leave request got {leaveResendModal.hr_status ? leaveResendModal.hr_status : 'pending'} by the HR Team
                        {leaveResendModal.hr_status ? ` for the reason : ${leaveResendModal.hr_reason}` : ''}

                        {leaveResendModal.hr_status != null &&
                            <button onClick={() => {
                                axios.get(`${port}/root/lms/Employee_Leave_Conversation/${leaveResendModal.id}/`).then((response) => {
                                    console.log(response.data);
                                    setLeaveResendModal(false)
                                    toast.success('Leave Request has been submited')
                                }).catch((error) => {
                                    console.log(error);
                                })
                            }}
                                className='flex ms-auto btngrd text-white p-2 my-2 rounded text-sm '> Resend Request </button>}
                    </>}
                </Modal.Body>
            </Modal>
            }
            <Modal centered show={reasonModal.obj} onHide={() => setreasonModal({
                obj: null,
                status: '',
                index: '',
            })} >
                <Modal.Header closeButton>
                    Reason for the Leave
                </Modal.Header>
                <Modal.Body>
                    <div>
                        Comments :
                        <textarea name="" value={reason} onChange={(e) => setreason(e.target.value)}
                            rows={5} className='outline-none w-full block p-1 border-2  rounded bgclr ' id=""></textarea>
                    </div>
                    <button onClick={() => {
                        handleRequest(reasonModal.obj, reasonModal.status, reasonModal.index)
                        console.log(reasonModal);
                    }
                    } className='my-2 ms-auto flex p-2 rounded bg-blue-600 text-white '>
                        Send
                    </button>
                </Modal.Body>
            </Modal>

        </div >
    )
}

export default ApprovalPage