import axios from 'axios'
import React, { useContext, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'
import InputFieldform from '../SettingComponent/InputFieldform'
import { HrmStore } from '../../Context/HrmContext'

const CreateEmployeeShift = ({ getData }) => {
    let { getAllShiftTiming } = useContext(HrmStore)
    let [loading, setloading] = useState(false)
    let [show, setShow] = useState(false)
    let [formData, setFormData] = useState({
        Shift_Name: '',
        start_shift: '',
        end_shift: ''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormData((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let postShift = async () => {
        setloading(true)
        if (formData.Shift_Name != '' && formData.end_shift != '' && formData.start_shift != '')
            await axios.post(`${port}/root/lms/shifts/`, formData).then((response) => {
                toast.success('Shift added successfully')
                getAllShiftTiming()
                setShow(false)
                setFormData({
                    Shift_Name: '',
                    start_shift: '',
                    end_shift: ''
                })
            }).catch((error) => {
                console.log(error);
            })
        else
            toast.warning('Fill all the fields')
        setloading(false)
    }
    return (
        <div>
            <button onClick={() => setShow(true)} className='text-xs text-slate-500 ' >
                Create Shifts
            </button>
            <Modal centered className=' ' show={show} onHide={() => setShow(false)} >
                <Modal.Header closeButton >
                    Work Shifts
                </Modal.Header>
                <Modal.Body>
                    <main>
                        <InputFieldform label='Shift Name' value={formData.Shift_Name} name='Shift_Name'
                            handleChange={handleChange} size='col-12' />
                        <InputFieldform label='Start Time' value={formData.start_shift} name='start_shift'
                            handleChange={handleChange} size='col-12' type='time' />
                        <InputFieldform label='End Time' value={formData.end_shift} name='end_shift'
                            handleChange={handleChange} size='col-12' type='time' />
                        <button onClick={() => postShift()} disabled={loading}
                            className='bluebtn p-2 rounded text-sm ms-auto flex ' >
                            {loading ? 'Loading' : "Submit"}
                        </button>
                    </main>

                </Modal.Body>
            </Modal>
        </div>
    )
}

export default CreateEmployeeShift