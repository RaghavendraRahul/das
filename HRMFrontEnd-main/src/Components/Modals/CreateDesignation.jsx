import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { toast } from 'react-toastify'

const CreateDesignation = (props) => {
    let { show, setshow, setdid, did, getdesignation, deptid } = props
    let [departments, set_Department_List] = useState()
    let [obj, setobj] = useState({
        Department: '',
        Name: ''
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setobj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getdepartments = () => {
        axios.get(`${port}root/ems/Departments/`)
            .then((r) => {
                set_Department_List(r.data)
                console.log("Departments_List_Res", r.data)
            })
            .catch((err) => {
                console.log("Departments_List_err", err)
            })
    }
    let handleSubmit = () => {
        console.log(obj);
        axios.post(`${port}/root/ems/Designation/${obj.Department}/`, obj).then((response) => {
            toast.success('Designation added successfully')
            console.log(response.data);

            setshow(false)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getParticularDesignation = () => {
        axios.get(`${port}/root/ems/Designations/${did}/`).then((response) => {
            console.log("hellow", response.data);
            setobj(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateParticularDesignation = () => {
        console.log("hellow", obj);
        delete obj.Department
        axios.patch(`${port}/root/ems/Designations/${obj.id}/`, obj).then((response) => {
            console.log("hellow", response.data);
            setshow(false)
            toast.success('Designation updated successfully')
            
            getdesignation(deptid)
            
        }).catch((error) => {
            console.log("hellow", error);
        })
    }

    useEffect(() => {
        getdepartments()
        console.log(did,'did');

        if (did && did != -1) {
            getParticularDesignation()
        }
    }, [did])
    return (
        show && <Modal show={show} centered onHide={() => setshow(false)}  >
            <Modal.Header closeButton>
                Designation
            </Modal.Header>
            <Modal.Body>
                {!did && <div className='flex items-center gap-2 my-3 '>
                    Choose a Department :
                    <select value={obj.Department} name="Department"
                        onChange={handleChange} className='p-2 rounded outline-none border-2 ' id="">
                        <option value="">Select</option>
                        {
                            departments && departments.map((obj) => (
                                <option value={obj.id}>{obj.Dep_Name} </option>
                            ))
                        }
                    </select>
                </div>}
                <div className='flex gap-3 my-3 items-center'>
                    Designation Name :
                    <input type="text" value={obj.Name} name='Name'
                        onChange={handleChange} className='p-2 outline-none border-2 rounded ' />
                </div>
                {(!did) &&
                    < button onClick={handleSubmit} className='p-2 rounded bg-blue-600 text-white '>Add Designation {did} </button>}
                {did && <button onClick={updateParticularDesignation} className='p-2 rounded bg-blue-600 text-white '>
                    Update Designation </button>}

            </Modal.Body>
        </Modal >
    )
}

export default CreateDesignation