import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import CreateDesignation from '../../Components/Modals/CreateDesignation'
import axios from 'axios'
import { port } from '../../App'
import PlusIcon from '../../SVG/PlusIcon'
import ThreeDot from '../../SVG/ThreeDot'
import ActionIcon from '../../Components/Icons/ActionIcon'
import { toast } from 'react-toastify'

const DesignationPage = () => {
    let { setTopNav } = useContext(HrmStore)
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [designationModal, setDesignationmodal] = useState(false)
    let [deptIndex, setDepartmentIndex] = useState()
    let [deptIdforDesignation, setDeptIdForDesignation] = useState()
    const [AllDepartmentlist, setAllDepartmentlist] = useState([])
    const [AllDesignationlist, setAllDesignationlist] = useState([])

    useEffect(() => {
        setTopNav('designation')
        getDept()
    }, [])
    let Call_Designation_list = (e) => {
        axios.get(`${port}/root/ems/SingleDesignation/List/${e}/`).then((res) => {
            console.log("AllDesignation_list_res", res.data);
            setAllDesignationlist(res.data)
        }).catch((err) => {
            console.log("AllDesignation_list_err", err);
            console.log(`${port}/root/ems/SingleDesignation/List/${e}/`, "AllDesignation_list_err");

        })
    }
    let getDept = () => {
        axios.get(`${port}/root/ems/DepartmentList/${Empid}/`).then((res) => {
            console.log("DepartmentList_res", res.data);
            setAllDepartmentlist(res.data)
            Call_Designation_list(res.data[0].id)
            setDeptIdForDesignation(res.data[0].id)
        }).catch((err) => {
            console.log("DepartmentList_err", err.data);
        })
    }
    return (
        <div>
            <section className='flex items-center justify-between ' >

                <h5 className=' ' > Designation List </h5>
                <div className='flex gap-2  ' >
                    {/* Select Option */}
                    <select name="" value={deptIdforDesignation}
                        onChange={(e) => { Call_Designation_list(e.target.value); setDeptIdForDesignation(e.target.value) }}
                        className='rounded p-2 px-3 outline-none shadow-sm ' id="">
                        {
                            AllDepartmentlist && AllDepartmentlist.map((obj) => (
                                <option value={obj.id}> {obj.Department} </option>
                            ))
                        }
                    </select>
                    <button onClick={() => { setDesignationmodal(true); setDepartmentIndex(false) }} className='flex gap-2 items-center text-sm 
                        rounded p-2 px-3 shadow-sm btngrd text-white'>
                        <PlusIcon />  Add Designation
                    </button>
                </div>

            </section>
            {designationModal && <CreateDesignation setdid={setDepartmentIndex}
                deptid={deptIdforDesignation} getdesignation={Call_Designation_list}
                did={deptIndex} show={designationModal} setshow={setDesignationmodal} />}
            {/* Tables */}
            <main className='tablebg my-2  table-responsive rounded  ' >
                <table className='w-full ' >
                    <tr className='sticky top-0 ' >
                        <th className='flex ' >
                            <span className='mx-auto text-center  ' >
                                <ActionIcon /> </span></th>
                        <th>Designation Name</th>
                        <th>Number of Employees </th>
                    </tr>
                    {
                        AllDesignationlist && AllDesignationlist.map((obj) => (
                            <tr className={` ${deptIndex == obj.id && ' bg-blue-50 '} `} >
                                <td className=' ' >

                                    <button onClick={() => {
                                        if (deptIndex != obj.id)
                                            setDepartmentIndex(obj.id)
                                    }} className='p-2 rotate-90 relative' >
                                        <ThreeDot size={5} />
                                        {deptIndex == obj.id &&
                                            <div onMouseLeave={() => setDepartmentIndex(-1)}
                                                className='absolute -rotate-90 bottom-5 p-3 z-10 bg-white shadow rounded text-start ' >
                                                <button onClick={() => setDesignationmodal(true)} >
                                                    Edit
                                                </button>
                                                <button onClick={() => {
                                                    axios.delete(`${port}/root/ems/Designations/${obj.id}/`).then((response) => {
                                                        toast.success('Deleted Successfully')
                                                        Call_Designation_list(deptIdforDesignation)
                                                    }).catch((error) => { toast.error('error acquired'); console.log(error) })
                                                }} disabled={false}
                                                    className='z-10 block my-1 ' >
                                                    Delete
                                                </button>
                                            </div>
                                        }
                                    </button>
                                </td>
                                <td>{obj.Designation}</td>
                                <td> {obj.No_Of_Employees} </td>
                            </tr>
                        ))
                    }

                </table>

            </main>
        </div>
    )
}

export default DesignationPage