import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import Topnav from '../../Components/Topnav'
import HrmContext, { HrmStore } from '../../Context/HrmContext'
import { Modal } from 'react-bootstrap'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import { toast } from 'react-toastify'

const ShiftTiming = () => {
    
    let [loading, setLoading] = useState()
    let { convertTo12Hour,allShiftTiming, setAllShiftTiming,getAllShiftTiming } = useContext(HrmStore)
    
    let [shiftTimingObj, setShiftTimingObj] = useState()
    let handleShiftTiming = (e) => {
        let { value, name } = e.target
        setShiftTimingObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    useEffect(() => {
        getAllShiftTiming()
    }, [])
    let postShift = () => {
        setLoading('save')
        axios.post(`${port}/root/lms/shifts/`, shiftTimingObj).then((response) => {
            console.log(response.data);
            toast.success('Shift has been added')
            setLoading(false)
            setShiftTimingObj(false)
            getAllShiftTiming()
        }).catch((error) => {
            console.log(error);
            toast.error('Error occured')
            setLoading(false)
        })
    }
    let editShift = () => {
        setLoading('edit')
        axios.patch(`${port}/root/lms/shifts/${shiftTimingObj.id}/`, shiftTimingObj).then((response) => {
            console.log(response.data);
            toast.success('Shift has been Updated')
            setLoading(false)
            setShiftTimingObj(false)
            getAllShiftTiming()
        }).catch((error) => {
            console.log(error);
            toast.error('Error occured')
            setLoading(false)
        })
    }
    return (
        <div className='poppins ' >
            <Topnav />
            <div className='flex flex-wrap justify-between items-center ' >
                <h5 className=' ' > Shift Timings </h5>
                <button onClick={() => setShiftTimingObj({
                    Shift_Name: '',
                    start_shift: '',
                    end_shift: ''
                })} className='bg-blue-600 text-slate-50 p-2 px-3 rounded ' >
                    Add Shift Timing
                </button>
            </div>
            <main className='flex flex-wrap gap-3 my-3 ' >
                {
                    allShiftTiming && allShiftTiming.map((obj, index) => (
                        <section className='rounded w-[18rem] p-3 shadow ' >
                            <div className=' fw-semibold  ' >
                                Shift Name  : <span className='fw-normal ' >
                                    {obj.Shift_Name}  </span>
                            </div>

                            <div className=' fw-semibold  ' >
                                Shift start time  : <span className='fw-normal ' >
                                    {obj.start_shift && convertTo12Hour(obj.start_shift)}  </span>
                            </div>

                            <div className=' fw-semibold  ' >
                                Shift end time  : <span className='fw-normal ' >
                                    {obj.end_shift && convertTo12Hour(obj.end_shift)}  </span>
                            </div>
                            <button onClick={() => setShiftTimingObj(obj)} className='bg-slate-500 rounded p-2  text-slate-50 px-3 mx-auto flex mt-3 ' >
                                Edit
                            </button>
                        </section>
                    ))
                }
            </main>
            {/* Creation  */}
            {
                shiftTimingObj &&
                <Modal show={shiftTimingObj} centered className=' ' onHide={() => setShiftTimingObj(false)}  >
                    <Modal.Header closeButton className=' ' >
                        Shift Timing
                    </Modal.Header>
                    <Modal.Body>
                        <InputFieldform size='col-12' label='Shift Name :' value={shiftTimingObj.Shift_Name} name='Shift_Name'
                            handleChange={handleShiftTiming}
                        />
                        <InputFieldform size='col-12' label='Shift Start Time :' value={shiftTimingObj.start_shift} name='start_shift'
                            handleChange={handleShiftTiming} type='time'
                        />
                        <InputFieldform size='col-12' label='Shift End Time :' value={shiftTimingObj.end_shift} name='end_shift'
                            handleChange={handleShiftTiming} type='time'
                        />
                        {!shiftTimingObj.id && <button disabled={loading == 'save'} onClick={postShift}
                            className='bg-green-600 text-slate-50 p-2 px-3 mx-auto rounded flex ' >
                            {loading == 'save' ? 'Loading' : "Save"}
                        </button>}
                        {shiftTimingObj.id && <button disabled={loading == 'edit'} onClick={editShift}
                            className='bg-slate-600 text-slate-50 p-2 px-3 mx-auto rounded flex ' >
                            {loading == 'edit' ? 'Loading' : "Edit"}
                        </button>}
                    </Modal.Body>

                </Modal>
            }

        </div>
    )
}

export default ShiftTiming