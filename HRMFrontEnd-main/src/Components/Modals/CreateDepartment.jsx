import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'

const CreateDepartment = (props) => {
    let { show, setshow, did, getdept } = props
    let [department, setDepartment] = useState()
    let [loading, setloading] = useState()
    let [editId, setEditId] = useState()
    let submitDepartment = () => {
        if (department != '') {
            setloading(true)
            axios.post(`${port}/root/ems/Departments/`, {
                Dep_Name: department
            }).then((response) => {
                toast.success("Department Created Successfully")
                setshow(false)
                getdept()
                setloading(false)
                console.log(response.data);
            }).catch((error) => {
                setloading(false)
                console.log(error);
            })
        }
    }
    let getParticularDept = () => {
        axios.get(`${port}/root/ems/Departments/${did}/`).then((response) => {
            console.log(response.data);
            setDepartment(response.data.Dep_Name)
            setEditId(response.data.id)
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateParticularDept = () => {
        setloading(true)
        axios.patch(`${port}/root/ems/Departments/${editId}/`, {
            Dep_Name: department
        }).then((response) => {
            console.log(response.data);
            toast.success('Update Successfull')
            setshow(false)
            getdept()
            setloading(false)
        }).catch((error) => {
            setloading(false)
            console.log(error);
        })
    }
    useEffect(() => {
        if (did && did != -1)
            getParticularDept()
    }, [did])
    return (
        show && <Modal show={show} centered onHide={() => { setshow(false); setEditId(false); setDepartment('') }} className='' >
            <Modal.Header closeButton>
                Department
            </Modal.Header>
            <Modal.Body>
                <div className='flex items-center my-3 '>
                    <label htmlFor="">Department Name : </label>
                    <input type="text" value={department} onChange={(e) => setDepartment(e.target.value)}
                        className='p-2 outline-none border-2 rounded mx-2 z-10 ' />
                </div>
                {!editId
                    &&
                    < button onClick={submitDepartment} disabled={loading}
                        className='p-2 rounded bg-blue-600 text-white'>
                        {loading ? "Loading" : "  Add department"}
                    </button>}
                {(editId && editId > 0) &&
                    < button onClick={updateParticularDept} disabled={loading}
                        className='p-2 rounded bg-blue-600 text-white'>
                        {loading ? "Loading" : "  Update department"}
                    </button>}
            </Modal.Body>
        </Modal >
    )
}

export default CreateDepartment