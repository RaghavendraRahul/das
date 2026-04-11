import axios from 'axios'
import React, { useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'

const LeaveaddingModal = (props) => {
    let { show, setShow ,getleave} = props
    let userid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [loading, setloading] = useState()
    let [obj, setobj] = useState({
        leave_name: '',
        description: "",
        EmployeeId: userid
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setobj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let handleSave = () => {
        if (obj.leave_name) {
            console.log(obj);
            setloading('leave')
            axios.post(`${port}/root/lms/LeaveTypes/`, obj).then((response) => {
                setloading('')
                toast.success("Leave has been added")
                console.log(response.data);
                setloading('')
                getleave()
                setShow(false)
                setobj({
                    leave_name: '',
                    description: "",
                    EmployeeId: userid
                })
            }).catch((error) => {
                setloading('')
                toast.error("Error acquired")
            })
        }
    }
    return (
        <div>
            {show && <Modal centered size='md' className='' show={show} onHide={() => setShow(false)}>

                <Modal.Body className='bgmodal rounded-xl'>
                    <h4 className='text-center'>Add Leave Type </h4>
                    <input type=" text" placeholder='Enter Leave name *'
                        value={obj.leave_name} onChange={handleChange} name='leave_name' className='p-3 rounded-xl w-72 flex outline-none   mx-auto shadow
                         bg-slate-50 border-2 ' />
                    <textarea type=" text" placeholder='Provide a brief description of this leave' value={obj.description} onChange={handleChange} name='description'
                        className='p-3 my-3 rounded-xl w-72 flex outline-none   mx-auto shadow
                         bg-slate-50 border-2 ' />
                    <button onClick={handleSave} disabled={loading == 'leave'} className='savebtn p-2 px-5 mx-auto rounded-lg text-white flex text-center '>
                        {loading == 'leave' ? "Loading..." : " Save"}
                    </button>
                </Modal.Body>
            </Modal>
            }

        </div>
    )
}

export default LeaveaddingModal