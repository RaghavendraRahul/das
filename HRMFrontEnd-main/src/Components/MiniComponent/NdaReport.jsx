import axios from 'axios'
import React, { useState } from 'react'
import { port } from '../../App'
import { Modal } from 'react-bootstrap'
import { toast } from 'react-toastify'

const NdaReport = () => {
    let [show, setShow] = useState(JSON.parse(sessionStorage.getItem('user'))?.Policies_NDA_Accept)
    let [accepted, setAccepted] = useState(JSON.parse(sessionStorage.getItem('user'))?.Policies_NDA_Accept)
    let [loading, setLoading] = useState()
    let updateStatus = async () => {
        setLoading(true)
        console.log(`${port}/root/UserProfileUpload/${JSON.parse(sessionStorage.getItem('dasid'))}/?Policies_NDA_Accept=${accepted}`);
        if (accepted)
            await axios.get(`${port}/root/UserProfileUpload/${JSON.parse(sessionStorage.getItem('dasid'))}/?Policies_NDA_Accept=${accepted}`).then((response) => {
                console.log(response.data);
                let user = JSON.parse(sessionStorage.getItem('user'))
                user.Policies_NDA_Accept = true
                sessionStorage.setItem('user', JSON.stringify(user))
                setShow(true)
                setLoading(false)
                toast.success('NDA form has been checked')
            }).catch((error) => {
                toast.error('error occured')
                console.log(error);
                setLoading(false)
            })
        else
            toast.warning('Click the check Box')
        setLoading(false)
    }

    return (
        <div>
            <Modal show={false} centered size='xl'>
                <Modal.Header>
                    Terms & Condition
                </Modal.Header>
                <Modal.Body>
                    <main className='' >
                        <section className='table-responsive h-[50vh] ' >
                        </section>
                        <div>
                            <input type="checkbox" id='checkNDA' onChange={() => setAccepted(!accepted)}
                                checked={accepted} />
                            <label htmlFor="checkNDA"> I hereby declare the work of HRM to Hari. </label>
                        </div>
                        <button onClick={() => updateStatus()} disabled={loading}
                            className='bluebtn p-2 rounded ms-auto flex ' >
                            {loading ? 'Loading...' : "Submit"}
                        </button>
                    </main>
                </Modal.Body>
            </Modal>
        </div>
    )
}

export default NdaReport