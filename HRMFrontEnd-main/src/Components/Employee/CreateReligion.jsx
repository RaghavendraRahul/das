import axios from 'axios'
import React, { useContext, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'

const CreateReligion = ({ show, setshow }) => {
    let [religion_name, setReligion] = useState()
    let { getReligion } = useContext(HrmStore)
    let postData = () => {
        console.log(religion_name);
        axios.post(`${port}/root/ems/Religions/`, { religion_name }).then((response) => {
            console.log(response.data);
            getReligion()
            setReligion('')
            setshow(false)
            toast.success('Religion has been added')
        }).catch((error) => {
            console.log(error);
        })
    }
    return (
        <Modal centered show={show} className='z-10' onHide={() => setshow(false)} >
            <Modal.Header closeButton >
                Create Religion
            </Modal.Header>
            <Modal.Body>
                <div>
                    Religion Name :
                    <input type="text" value={religion_name} onChange={(e) => setReligion(e.target.value)}
                        placeholder='Enter the Name'
                        className='p-2 rounded outline-none bgclr mx-2 ' />
                </div>
                <button onClick={postData} className='  bg-blue-500 text-white rounded p-2'>
                    Save
                </button>


            </Modal.Body>


        </Modal>
    )
}

export default CreateReligion