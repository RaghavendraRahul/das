import axios from 'axios'
import React, { useContext, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'

const HolidayModal = ({ show, setshow, getHoliday }) => {
    let [loading, setloading] = useState(false)
    let { religion } = useContext(HrmStore)
    let [obj, setobj] = useState({
        OccasionName: '',
        Religion: '',
        Date: '',
        Day: '',
        state: '',
        added_By: JSON.parse(sessionStorage.getItem('user')).EmployeeId,
        leave_type: ''
    })
    let setDay = (date) => {
        let arry = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        let newDate = new Date(date)
        let day = arry[newDate.getDay()]
        setobj((prev) => ({
            ...prev,
            Day: day
        }))
    }
    let handleChange = (e) => {
        let { value, name } = e.target
        if (name == 'Date') {
            setDay(value)
        }
        setobj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let handleSave = () => {
        if (obj.OccasionName != '' && obj.Date != '' &&
            obj.leave_type != '' && obj.Day != ''
        ) {
            setloading(true)
            axios.post(`${port}/root/lms/CompanyHolidaysDataAdding/`, obj).then((response) => {
                console.log(response.data);
                toast.success('Added successfully')
                setshow(false)
                getHoliday()
                setloading(false)
                setobj({
                    OccasionName: '',
                    Religion: '',
                    Date: '',
                    Day: '',
                    state: '',
                    added_By: JSON.parse(sessionStorage.getItem('user')).EmployeeId,
                    leave_type: ''
                })
            }).catch((error) => {
                console.log(error);
                setloading(false)

                toast.error('Error acquired')
            })
        }
    }
    return (
        <div>
            <Modal show={show} size='lg' centered onHide={() => setshow(false)} >
                <Modal.Header className='' >
                    Create Holiday
                </Modal.Header>
                <Modal.Body>
                    <section className='flex flex-wrap '>
                        <div className='col-lg-6'>
                            <label htmlFor="">Name of the Holiday </label>
                            <input type="text" value={obj.OccasionName} onChange={handleChange}
                                name='OccasionName' placeholder='Christmas' className='p-2 border-2 outline-none rounded block w-[90%] my-2 ' />
                        </div>
                        <div className='col-lg-6'>
                            <label htmlFor=""> Leave type </label>
                            <select type="text" value={obj.leave_type} onChange={handleChange}
                                name='leave_type' className='p-2 border-2 outline-none rounded block w-[90%] my-2 ' >
                                <option value="">Select Type</option>
                                <option value="Public_Leave">Public Holiday</option>
                                <option value="Restricted_Leave">Restricted Holiday</option>
                            </select>
                        </div>
                        {obj.leave_type == 'Restricted_Leave' && <div className='col-lg-6'>
                            <label htmlFor="">Restricted only for </label>
                            <select type="text" value={obj.Religion} onChange={handleChange}
                                name='Religion' className='p-2 border-2 outline-none rounded block w-[90%] my-2 ' >
                                <option value="">Select Relegion</option>
                                {
                                    religion && religion.map((obj) => (
                                        <option value={obj.id}> {obj.religion_name} </option>
                                    ))
                                }

                            </select>
                        </div>}

                        <div className='col-lg-6'>
                            <label htmlFor="">Date  </label>
                            <input type="date" value={obj.Date} onChange={handleChange}
                                name='Date' className='p-2 border-2 outline-none rounded block w-[90%] my-2 ' />
                        </div>
                        <div className='col-lg-6'>
                            <label htmlFor="">Day  </label>
                            <input type="text" value={obj.Day} disabled onChange={handleChange}
                                name='Day' className='p-2 border-2 outline-none rounded block w-[90%] my-2 ' />
                        </div>

                    </section>
                    <button onClick={handleSave} disabled={loading} className='p-2 px-3 savebtn rounded text-white w-40 text-center justify-center ms-auto flex'>
                        {loading ? 'Loading..' : "Save"}
                    </button>


                </Modal.Body>
            </Modal>

        </div>
    )
}

export default HolidayModal