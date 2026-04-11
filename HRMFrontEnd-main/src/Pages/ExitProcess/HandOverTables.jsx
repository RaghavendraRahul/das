import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import { Modal } from 'react-bootstrap'
import { toast } from 'react-toastify'

const HandOverTables = ({ setActiveSection }) => {
    let [handoverList, setHandOverList] = useState()
    let [showModal, setShowModal] = useState()
    let [loading, setLoading] = useState(false)
    let handleChange = (e) => {
        let { name, value } = e.target
        setShowModal((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    useEffect(() => {
        setActiveSection('handover')
    }, [])
    let updateData = async () => {
        setLoading(true)
        await axios.patch(`${port}/root/ems/Handovers`, showModal).then((response) => {
            console.log(response.data, 'updated');
            toast.success('Updated successfully.')
            setLoading(false)
            setShowModal(false)
            gethandOverList()
        }).catch((error) => {
            console.log(error, 'update');
            setLoading(false)
        })
    }
    let gethandOverList = () => {
        axios.get(`${port}/root/ems/HandoverAcknowledgement?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, "handover");
            setHandOverList(response.data)
        }).catch((error) => {
            console.log(error);
            setHandOverList([])
        })
    }
    useEffect(() => {
        gethandOverList()
    }, [])
    return (
        <div className=' ' >
           <h6 className='text-xl fw-semibold ' > HandOver table </h6>
            <main className='table-responsive my-3 rounded tablebg  h-[70vh] '>
                <table className='w-full ' >
                    <tr>
                        <th>SI No </th>
                        <th>Task Title </th>
                        <th>Description </th>
                        <th>Assigned Date </th>
                        <th> Responsible Employee</th>
                        <th>Status </th>
                        <th>Action </th>
                    </tr>
                    {
                        handoverList && handoverList.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td> {obj.handover_title} </td>
                                <td>{obj.description} </td>
                                <td>{obj.handover_ak_assigned_date} </td>
                                <td> {obj.handover_from} </td>
                                <td> {obj.assigned_handover_emp_accept_status} </td>
                                <td>
                                    <button onClick={() => setShowModal(obj)}
                                        className='bg-blue-500 text-white p-1 rounded text-sm ' >
                                        View
                                    </button>
                                </td>
                            </tr>
                        ))
                    }

                </table>
            </main>
            {/* Modal */}
            {showModal && <Modal show={showModal} onHide={() => setShowModal(false)} centered >
                <Modal.Header closeButton >
                    HandOvering
                </Modal.Header>
                <Modal.Body>

                    <main className=' ' >
                        <div className='flex ' >
                            <label htmlFor="" className='text-nowrap w-32' >  Acceptance :  </label>
                            <select name="assigned_handover_emp_accept_status" value={showModal && showModal.assigned_handover_emp_accept_status}
                                onChange={handleChange} className='w-full p-2 mx-3 border-2 rounded outline-none ' id="">
                                <option value="">Select </option>
                                <option value="pending">Pending</option>
                                <option value="rejected">Reject</option>
                                <option value="accepted">Accept </option>
                            </select>
                        </div>
                        <div className='flex my-2 ' >
                            <label htmlFor="" className='text-nowrap w-32' >Reason :  </label>
                            <textarea name="emp_accept_status_reason" value={showModal && showModal.emp_accept_status_reason}
                                onChange={handleChange} className='mx-3 p-2 w-full border-2 outline-none rounded ' id=""></textarea>
                        </div>
                        <button onClick={updateData} className='p-2 rounded bg-blue-600 text-white text-sm flex ms-auto ' >
                            {loading ? "loading" : "Submit"}
                        </button>
                    </main>


                </Modal.Body>

            </Modal>}

        </div>
    )
}

export default HandOverTables