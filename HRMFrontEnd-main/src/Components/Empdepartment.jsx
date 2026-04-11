import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'



const Empdepartment = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

    const [AllDepartmentlist, setAllDepartmentlist] = useState([])
    const [paticularDepartmentEmp, setpaticularDepartmentEmp] = useState([])

    useEffect(() => {

        axios.get(`${port}/root/ems/DepartmentList/${Empid}/`).then((res) => {
            console.log("DepartmentList_res", res.data);
            setAllDepartmentlist(res.data)

        }).catch((err) => {
            console.log("DepartmentList_err", err.data);
        })

    }, [])

    let callDepartmentEmp = (id) => {


        axios.get(`${port}/root/ems/SingleDepartmentEmployee/${Empid}/${id}/`).then((res) => {
            console.log("callDepartmentEmp_res", res.data);
            setpaticularDepartmentEmp(res.data)


        }).catch((err) => {
            console.log("callDepartmentEmp_err", err.data);
        })
    }

    const [DEPARTMENT_NAMES, setDEPARTMENT_NAMES] = useState(true)
    const [DEPARTMENT_EMPLOYEES, setDEPARTMENT_EMPLOYEES] = useState(false)
    const [DEPARTMENT_NAME, setDEPARTMENT_NAME] = useState("")

    return (
        <div className=' d-flex' style={{ width: '100%',minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav>

                <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                    <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Department List</h6>

                    <div>
                        <button className='btn btn-sm bg-info-subtle'>Add New</button>
                    </div>
                </div>
                <div className='d-flex justify-content-end mt-2'>
                    <input type="text" className='form-control w-25' />
                    <button className='btn btn-sm bg-primary-subtle'> Search</button>
                </div>

                <div className='row m-0 p-1 mt-3'>

                    <div className={`p-3 ${DEPARTMENT_NAMES ? '' : 'd-none'}`}>

                        <table class="table">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col" style={{ cursor: 'pointer' }}>Department Name</th>

                                    <th scope="col">Total Employee</th>

                                </tr>
                            </thead>
                            <tbody>

                                {AllDepartmentlist != undefined && AllDepartmentlist != undefined && AllDepartmentlist.map((e, index) => {
                                    return (


                                        <tr>

                                            <td key={e.id}> {index + 1}</td>
                                            <td style={{ cursor: 'pointer', color: 'rgb(76,53,120)' }} key={e.id} onClick={(x) => {
                                                x.preventDefault()
                                                callDepartmentEmp(e.id)
                                                setDEPARTMENT_NAME(e.Department)
                                                setDEPARTMENT_EMPLOYEES(true)
                                                setDEPARTMENT_NAMES(false)

                                            }}> {e.Department}</td>
                                            <td key={e.id}> {e.No_Of_Employees}</td>



                                        </tr>


                                    )
                                })}


                            </tbody>
                        </table>
                    </div>
                    <div style={{ position: 'relative', bottom: '30px' }} className={`p-3 ${DEPARTMENT_EMPLOYEES ? '' : 'd-none'} `} >

                        <div className='d-flex'>
                            <h6
                                onClick={(x) => {
                                    x.preventDefault()

                                    setDEPARTMENT_NAMES(true)
                                    setDEPARTMENT_EMPLOYEES(false)

                                }}

                                className='ms-1'><i style={{ color: 'rgb(76,53,117)' }} class="fa-solid fa-arrow-left " ></i></h6>
                            <h6 className='ms-4'>{DEPARTMENT_NAME}  Department  Employees</h6>
                        </div>

                        <table class="table mt-3">
                            <thead>

                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Employee ID</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Join Date</th>
                                    <th scope="col">Role</th>

                                </tr>

                            </thead>
                            <tbody>




                                {paticularDepartmentEmp != undefined && paticularDepartmentEmp != undefined && paticularDepartmentEmp.map((e, index) => {
                                    return (


                                        <tr>

                                            <td key={e.id}> {index + 1}</td>
                                            <td > {e.full_name}</td>
                                            <td key={e.id}> {e.email}</td>
                                            <td key={e.id}> {e.employee_Id}</td>
                                            <td key={e.id}> {e.mobile}</td>
                                            <td key={e.id}> {e.Date_of_Joining}</td>
                                            <td key={e.id}> {e.Designation}</td>



                                        </tr>


                                    )
                                })}


                            </tbody>
                        </table>
                    </div>

                </div>






            </div>



        </div>
    )
}

export default Empdepartment