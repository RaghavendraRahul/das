import React, { useState } from 'react'
import { Modal } from 'react-bootstrap'

const AddSalary = ({ id }) => {
    let [salaryModal, setSalaryModal] = useState()
    return (
        <div>
            <button onClick={() => setSalaryModal(true)} className=' text-xs rounded p-1 bg-blue-600 text-white ' >
                Add Salary
            </button>
            {salaryModal && <Modal show={salaryModal} centered onHide={() => setSalaryModal(false)} >
                <Modal.Header>
                    Add salary for employee
                </Modal.Header>
                <Modal.Body>

                </Modal.Body>

            </Modal>}

        </div>
    )
}

export default AddSalary