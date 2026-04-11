import React, { useContext, useEffect, useState } from 'react'
// import Sidebar from './Sidebar'
// import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'
import HrmContext, { HrmStore } from '../Context/HrmContext'
import { useNavigate } from 'react-router-dom'


const New_join_emp = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let navigate = useNavigate()
    const [AllEmployeelist, setAllEmployeelist] = useState([])
    let { setActivePage, setTopNav } = useContext(HrmStore)
    useEffect(() => {
        setActivePage("Employee")
        setTopNav("join-employee")
        fetchdata()
    }, [])

    const fetchdata = () => {
        axios.get(`${port}/root/ems/JoiningFormalityesSubmitedList`).then((res) => {
            console.log("Joining_Formalityes_Submited_List_res", res.data);
            setAllEmployeelist(res.data)
        }).catch((err) => {
            console.log("Joining_Formalityes_Submited_List_err", err.data);
        })
    }


    // SEARCH START

    const [searchValue, setSearchValue] = useState("");

    const handlesearchvalue = (value) => {

        console.log(value);
        setSearchValue(value)

        if (value.length > 0) {

            axios.get(`${port}/root/ems/Employee_search/${value}/`).then((res) => {
                console.log("search_res", res.data);
                setAllEmployeelist(res.data)
            }).catch((err) => {
                console.log("search_res", err.data);
            })
        }
        else {
            fetchdata()
        }
    }
    // SEARCH END

    const [ID, setID] = useState('')
    return (
        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', }}>
            {/* <div className=''>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4 flex-1 container mx-auto ' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav> */}
            <div className=' flex-1 container mx-auto ' style={{ borderRadius: '10px' }}>

                <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

                    <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>New Joining Employees List</h6>

                    <div>
                        <button className='btn btn-sm bg-info-subtle'>Add New</button>
                    </div>
                </div>

                <div className='d-flex justify-content-end mt-2'>
                    <input type="text" value={searchValue}
                        onChange={(e) => handlesearchvalue(e.target.value)} className='form-control w-25' />

                </div>

                <div className='tablebg table-responsive rounded    m-0 p-1 mt-3'>
                    <table className=" w-full ">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Name</th>
                                <th scope="col">Email</th>
                                <th scope="col">Employee ID</th>
                                <th scope="col">Phone</th>
                                <th scope="col">Action </th>

                            </tr>
                        </thead>
                        <tbody>
                            {AllEmployeelist != undefined && AllEmployeelist != undefined && AllEmployeelist.map((e, index) => {
                                return (
                                    <tr>
                                        <td key={e.id}> {index + 1}</td>
                                        <td style={{ cursor: 'pointer' }}> {e.full_name}</td>
                                        <td key={e.id}> {e.email}</td>
                                        <td key={e.id}> {e.employee_Id}</td>
                                        <td key={e.id}> {e.mobile}</td>
                                        <td key={e.id}>
                                            {/* <button className='text-blue-600 ' onClick={()=>{navigate(`/employeeVerification/${e.Candidate_id}`)}} ></button> */}
                                            <button className='text-blue-600 ' onClick={() => { navigate(`/employeeVerification/${e.Candidate_id}`) }} >
                                                View
                                            </button>
                                        </td>

                                        {/* <td>
                                            <button>✔</button>
                                            <button>❌</button>
                                        </td> */}


                                    </tr>


                                )
                            })}
                        </tbody>
                    </table>


                </div>

            </div>
        </div>
    )
}

export default New_join_emp