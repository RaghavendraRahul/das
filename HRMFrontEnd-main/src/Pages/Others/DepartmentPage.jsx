import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import CreateDepartment from '../../Components/Modals/CreateDepartment'
import PlusIcon from '../../SVG/PlusIcon'
import ActionIcon from '../../Components/Icons/ActionIcon'
import ThreeDot from '../../SVG/ThreeDot'
import { toast } from 'react-toastify'

const DepartmentPage = () => {
    let { setTopNav } = useContext(HrmStore)
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    const [AllDepartmentlist, setAllDepartmentlist] = useState([])
    let [deptModal, setdeptmodal] = useState(false)
    let [deptIndex, setDepartmentIndex] = useState()

    useEffect(() => {
        setTopNav('department')
    }, [])
    let getDept = () => {
        axios.get(`${port}/root/ems/DepartmentList/${Empid}/`).then((res) => {
            console.log("DepartmentList_res", res.data);
            setAllDepartmentlist(res.data)
        }).catch((err) => {
            console.log("DepartmentList_err", err.data);
        })
    }

    useEffect(() => {
        getDept()
    }, [])
    return (
        <div>
            <section className='flex items-center justify-between ' >

                <h5 className=' ' > Department List </h5>
                <div>

                    <button onClick={() => { setdeptmodal(true); setDepartmentIndex(false) }} className='flex gap-2 items-center text-sm 
                        rounded p-2 px-3 shadow-sm bluebtn text-white'>
                        <PlusIcon />  Add Department
                    </button>
                </div>
                {setdeptmodal && <CreateDepartment did={deptIndex} show={deptModal} setshow={setdeptmodal} getdept={getDept} />}
            </section>
            {/* Tables */}
            <main className='tablebg my-2  table-responsive rounded  ' >
                <table className='w-full ' >
                    <tr className='sticky top-0 ' >
                        <th className='flex ' >
                            <span className='mx-auto text-center  ' >
                                <ActionIcon /> </span></th>
                        <th>Deapartment Name</th>
                        <th>Number of Employees </th>
                    </tr>
                    {
                        AllDepartmentlist && AllDepartmentlist.map((obj) => (
                            <tr className={` ${deptIndex == obj.id && ' bg-blue-50 '} `} >
                                <td className=' ' >
                                    
                                    <button onClick={() => {
                                        if (deptIndex != obj.id)
                                            setDepartmentIndex(obj.id)
                                        else
                                            setDepartmentIndex(-1)
                                    }} className='rotate-90 relative' >
                                        <ThreeDot size={5} />
                                        {deptIndex == obj.id &&
                                            <div
                                                className='absolute -rotate-90 bottom-5 p-3 z-10 bg-white shadow rounded text-start ' >
                                                <button onClick={() => setdeptmodal(true)} >
                                                    Edit
                                                </button>
                                                <button onClick={() => {
                                                    axios.delete(`${port}/root/ems/Departments/${deptIndex}/`).then((response) => {
                                                        toast.success('Deleted Successfully')
                                                        getDept()
                                                    }).catch((error) => { toast.error('error acquired'); console.log(error) })
                                                }} disabled={false}
                                                    className='z-10 block my-1 ' >
                                                    Delete
                                                </button>
                                            </div>
                                        }
                                    </button>
                                </td>
                                <td>{obj.Department}</td>
                                <td> {obj.No_Of_Employees} </td>
                            </tr>
                        ))
                    }

                </table>

            </main>
        </div>
    )
}

export default DepartmentPage