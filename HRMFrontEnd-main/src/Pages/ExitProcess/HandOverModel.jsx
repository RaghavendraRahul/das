import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import PlusIcon from '../../SVG/PlusIcon'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import DustbinIcon from '../../SVG/DustbinIcon'

const HandOverModel = ({ show, setshow }) => {
    let [allEmployee, setAllEmployee] = useState()
    let [formObj, setFormObj] = useState([{
        resignation: show.resignation && show.resignation.id,
        handover_title: null,
        description: null,
        handover_to: null,
        handover_status: null,
        comments: null,
        handover_from: "",
        assigned_handover_emp_accept_status: '',
        emp_accept_status_reason: '',
    }])
    let [loading, setLoading] = useState(false)
    let handleChange = (e, index) => {
        let { name, value } = e.target
        console.log(value);

        let arry = [...formObj]
        arry[index] = {
            ...arry[index],
            [name]: value
        }
        setFormObj(arry)
    }
    let saveAndUpdate = () => {
        let count = 0
        setLoading(true)
        for (const obj of formObj) {
            count++;
            console.log(obj);
            // continue;
            if (obj.id)
                updateHandOvers(obj)
            else
                saveHandOvers(obj)
        }
        setLoading(false)
        toast.success('Successfully added')
    }
    let getAllEmployees = () => {
        axios.get(`${port}/root/interviewschedule`).then((response) => {
            console.log(response.data);
            setAllEmployee(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let deleteHandovers = (id) => {
        axios.delete(`${port}/root/ems/Handovers/${id}/`).then((response) => {
            console.log(response.data, 'delete');
        }).catch((error) => {
            console.log(error);
        })
    }
    let saveHandOvers = async (obj) => {
        obj.resignation = show.resignation && show.resignation.id
        // obj.handover_from = show.resignation && show.resignation.employee_id
        console.log(obj);
        await axios.post(`${port}/root/ems/Handovers`, obj).then((response) => {
            console.log(response.data, 'saved');
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateHandOvers = async (obj) => {
        obj.resignation = show.resignation && show.resignation.id
        // obj.handover_from = show.resignation && show.resignation.employee_id
        await axios.patch(`${port}/root/ems/Handovers`, obj).then((response) => {
            console.log(response.data, 'updated');
        }).catch((error) => {
            console.log(error);
        })
    }
    let getHandovers = () => {
        axios.get(`${port}/root/ems/Handovers?resign_id=${show.resignation.id}`).then((response) => {
            setFormObj(response.data)
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let statusOptions = [
        {
            label: 'Pending',
            value: 'pending'
        },
        {
            label: 'Accepted',
            value: 'accepted'
        },
        {
            label: 'Rejected',
            value: 'rejected'
        },
    ]
    useEffect(() => {
        if (show.resignation && show.resignation.id)
            getHandovers()
        getAllEmployees()
    }, [show])
    return (
        <div>
            <Modal centered show={show} size='lg' onHide={() => setshow(false)} >
                <Modal.Header closeButton >
                    Handover process
                </Modal.Header>
                <Modal.Body className='p-0 '  >
                    <main className='inputbg p-3 m-0 rounded max-h-[60vh] overflow-y-scroll ' >
                        {
                            formObj && formObj.map((obj, index) => (
                                <section className='bg-white rounded p-3 row mx-auto my-2 ' >
                                    <p>   Project {index + 1} </p>
                                    {console.log(obj, 'handover')
                                    }
                                    <InputFieldform name="handover_title" handleChange={handleChange} index={index}
                                        label="Title : " value={formObj[index].handover_title} />
                                    <InputFieldform name="description" handleChange={handleChange} index={index}
                                        label="Description : " value={formObj[index].description} />
                                    <div className='col-md-6 col-lg-4 flex flex-col justify-between mb-3 ' >
                                        <p>Assigned to :</p>
                                        <select name="handover_to" onChange={(e) => handleChange(e, index)}
                                            value={formObj[index].handover_to} id=""
                                            className='p-2 block rounded inputbg w-full outline-none shadow-none ' >
                                            <option value="">Select </option>
                                            {
                                                allEmployee && allEmployee.map(interviewer => (
                                                    <option key={interviewer.EmployeeId}
                                                        value={interviewer.id}>
                                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                    </option>))
                                            }
                                        </select>
                                    </div>
                                    {/* Handover status */}
                                    <InputFieldform label='Handover status :' value={formObj[index].assigned_handover_emp_accept_status}
                                        name='assigned_handover_emp_accept_status' optionObj={statusOptions} handleChange={handleChange}
                                        index={index} />
                                    <InputFieldform label='Remarks' value={obj.emp_accept_status_reason} name='emp_accept_status_reason'
                                        handleChange={handleChange} />
                                    <InputFieldform label='Assigned date : ' value={obj.handover_ak_assigned_date} name='emp_accept_status_reason'
                                        disabled />
                                    <InputFieldform label='Resulted date : ' value={obj.handover_ak_received_date} name='emp_accept_status_reason'
                                        disabled />

                                    {/* Add button */}
                                    <div className='flex ' >
                                        {index + 1 == formObj.length &&
                                            <button onClick={() => setFormObj((prev) => [
                                                ...prev,
                                                {
                                                    resignation: show.resignation && show.resignation.id,
                                                    handover_title: null,
                                                    description: null,
                                                    handover_to: null,
                                                    handover_status: null,
                                                    comments: null
                                                }
                                            ])} className='p-1 border-slate-400 rounded-full border-2 w-fit  ' >
                                                <PlusIcon />
                                            </button>}
                                        {/* delete button */}
                                        {formObj.length > 1 &&
                                            <button onClick={() => {
                                                setFormObj((prev) => prev.filter((obj2, index2) => {
                                                    if (index2 != index)
                                                        return obj2
                                                    else if (obj2.id)
                                                        deleteHandovers(obj2.id)
                                                }
                                                ))
                                            }} className=' text-red-600 border-2 border-slate-600 rounded-full p-1 mx-2 ms-auto ' >
                                                <DustbinIcon />
                                            </button>
                                        }
                                    </div>
                                </section>
                            ))
                        }
                        <button onClick={saveAndUpdate} disabled={loading} className=' my-3 p-2 bg-green-500 text-white rounded ms-auto flex ' >
                            {loading ? "Loading.." : "Submit"}
                        </button>
                    </main>
                </Modal.Body>

            </Modal>
        </div >
    )
}

export default HandOverModel