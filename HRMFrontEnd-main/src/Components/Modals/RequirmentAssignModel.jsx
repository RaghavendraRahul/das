import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import InputFieldform from '../SettingComponent/InputFieldform'
import { toast } from 'react-toastify'

const RequirmentAssignModel = ({ show, setshow, getData, rid, cid }) => {
    let [recuirters, setRecuirters] = useState()
    let getRecuirters = () => {
        axios.get(`${port}/root/ScreeningAssigning/`).then((response) => {
            console.log(response.data, 'recruiter');
            setRecuirters(response.data)
        }).catch((error) => {
            console.log(error, 'recruiter');
        })
    }
    let [formdata, setFormData] = useState({
        requirement: rid,
        position_count: null,
        client: cid,
        assigned_by_employee: JSON.parse(sessionStorage.getItem('dasid')),
        assigned_to_recruiter: null,
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormData((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let postData = () => {
        axios.post(`${port}/root/cms/assign-requirements`, formdata).then((response) => {
            toast.success('Assigned successfully')
            setFormData({
                requirement: rid,
                position_count: null,
                client: cid,
                assigned_by_employee: JSON.parse(sessionStorage.getItem('dasid')),
                assigned_to_recruiter: null,
            })
            getData()
            setshow(false)
        }).catch((error) => {
            console.log(error, 'post');
            if (error.response.status === 406)
                toast.error(error.response.data)
            else
                toast.error('error occured')
        })
    }
    useEffect(() => {
        getRecuirters()
    }, [])
    return (
        <div>
            <Modal show={show} centered onHide={() => setshow(false)} >
                <Modal.Header closeButton >
                    Assigning Recruiter
                </Modal.Header>
                <Modal.Body className=' ' >
                    <main className='row  ' >
                        <InputFieldform size='col-sm-6 ' value={formdata.assigned_to_recruiter} name='assigned_to_recruiter' label='Select Recruiter '
                            optionObj={recuirters?.map((obj) => ({ label: obj.Name, value: obj.id }))}
                            handleChange={handleChange} />

                        <InputFieldform size='col-sm-6 ' value={formdata.position_count} name='position_count' label='Position allocation' handleChange={handleChange} />
                        <div>
                            <button onClick={() => postData()} className='bluebtn p-2 rounded text-sm flex ms-auto ' >
                                Submit
                            </button>
                        </div>
                    </main>
                </Modal.Body>
            </Modal>
        </div>
    )
}

export default RequirmentAssignModel