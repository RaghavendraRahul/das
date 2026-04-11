import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import InputFieldform from '../SettingComponent/InputFieldform'
import PlusIcon from '../../SVG/PlusIcon'
import { toast } from 'react-toastify'

const ActivityTargetModal = ({ data }) => {
    let [show, setShow] = useState(false)
    let [allReportingEmp, setAllReporintgEmp] = useState()
    let [activityList, setActivityList] = useState()
    let [formData, setFormData] = useState({
        Employee: '',
        Activity: '',
        targets: '',
        activity_assigned_by: JSON.parse(sessionStorage.getItem('dasid'))
    })
    let getActivity = () => {
        axios.get(`${port}/root/activity-list/pending/${formData.Employee}`).then((response) => {
            console.log(response.data, 'activity');
            setActivityList(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormData((prev) => (
            {
                ...prev,
                [name]: value
            }))
    }
    const fetchdata = () => {
        let Empid = JSON.parse(sessionStorage.getItem('dasid'))
        axios.get(`${port}/root/ems/ReportingTeam/${Empid}/`).then((res) => {
            console.log("ReportingTeam_res", res.data);
            setAllReporintgEmp(res.data)
        }).catch((err) => {
            console.log("ReportingTeam_err", err.data);
        })
    }
    let createActivity = () => {
        axios.post(`${port}/root/new-employees-activity/${JSON.parse(sessionStorage.getItem('dasid'))}`,
            formData).then((response) => {
                console.log(response.data);
                setFormData({
                    Employee: '',
                    Activity: '',
                    targets: '',
                    activity_assigned_by: JSON.parse(sessionStorage.getItem('dasid'))
                })
                toast.success('Activity  Added Successfully')
            }).catch((error) => {
                toast.warning('Error occured')
                console.log(error);
            })
    }
    useEffect(() => {
        if (data)
            setAllReporintgEmp(data)
        else
            fetchdata()
    }, [])
    useEffect(() => {
        getActivity()
    }, [formData.Employee])
    return (
        <div>
            <button onClick={() => setShow(true)} className=' bluebtn p-2 rounded' >
                Add Activity Target
            </button>
            {
                show &&
                <Modal centered show={show} onHide={() => setShow(false)} >
                    <Modal.Header closeButton >
                        Activity Target
                    </Modal.Header>
                    <Modal.Body>
                        <main className='row poppins ' >
                            <InputFieldform size='col-12 ' label='Reporting Employees' name='Employee' value={formData.Employee}
                                handleChange={handleChange}
                                optionObj={allReportingEmp?.map((obj) => ({ value: obj.employee_Id, label: obj.full_name }))} />
                            <InputFieldform size='col-12' label='Activity' value={formData.Activity} name='Activity'
                                handleChange={handleChange}
                                optionObj={activityList?.map((obj) => ({
                                    value: obj.id, label:
                                        obj.activity_name?.replace(/_/g, " ").replace(/\b\w/g, (char) => char.toUpperCase())
                                }))}
                            />
                            <InputFieldform size='col-12' label='Target' limit={10000} value={formData.targets} name='targets'
                                handleChange={handleChange} />
                            <div>
                                <button onClick={createActivity} className='bluebtn p-2 rounded ms-auto flex ' >
                                    Save
                                </button>
                            </div>
                        </main>

                    </Modal.Body>
                </Modal>
            }
        </div>
    )
}

export default ActivityTargetModal