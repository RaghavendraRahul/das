import axios from 'axios'
import React, { useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'
import InputFieldform from '../SettingComponent/InputFieldform'

const AttendanceReviewAdding = ({ id, setShow, getAttendanceList }) => {
    let [showReview, setShowReview] = useState(false)
    let [loading, setLoading] = useState(false)
    let [review, setReview] = useState()
    let handleChange = (e) => {
        let { name, value } = e.target
        setReview(value)
    }
    let addReview = () => {
        setLoading(true)
        axios.patch(`${port}/root/lms/UpdateEmployeeAttendanceManually/?id=${id}`,
            { remarks: review }).then((response) => {
                console.log(response.data);
                toast.success('Review added')
                setReview('')
                setShowReview(false )
                if (getAttendanceList)
                    getAttendanceList()
                setLoading(false)
            }).catch((error) => {
                setLoading(false)
                console.log(error);
                toast.error("error occured")
            })
    }
    return (
        <div>
            <button onClick={() => { setShowReview(true) }} className='border-2 rounded px-2 text-sm p-1 hover:text-teal-600 hover:border-teal-300 ' >
                Review
            </button>
            <Modal className=' ' centered show={showReview}
                onHide={() => setShowReview(false)}>
                <Modal.Header className='  ' closeButton >
                    Add the review for the Day
                </Modal.Header>
                <Modal.Body>
                    <div className='' >
                        <InputFieldform label='Review' value={review} name='review' handleChange={handleChange}
                            size='col-12' />
                    </div>
                    <button onClick={addReview} disabled={loading}
                        className=' my-2 bg-blue-500 p-2 px-3 rounded text-white text-xs flex ms-auto ' >
                        {loading ? 'Loading...' : "Submit"}
                    </button>
                </Modal.Body>
            </Modal>
        </div>
    )
}

export default AttendanceReviewAdding