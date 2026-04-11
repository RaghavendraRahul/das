import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import {port} from '../App' 


const Emp_leave_request = () => {

  let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

  const [All_Leave_Request, setAll_Leave_Request] = useState([])

  useEffect(() => {

    axios.get(`${port}/root/ems/AllEmployeesList/${Empid}/`).then((res) => {
      console.log("AllEmployee_res", res.data);
      setAll_Leave_Request(res.data)

    }).catch((err) => {
      console.log("AllEmployee_err", err.data);
    })

  }, [])

  return (
    <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

      <div className='side'>

        <Sidebar value={"dashboard"} ></Sidebar>
      </div>
      <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
        <Topnav></Topnav>

        <div className='m-1 p-1' style={{ display: 'flex', justifyContent: 'space-between' }}>

          <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Leave Request</h6>

          <div>
            <button className='btn btn-sm bg-info-subtle'>Add New</button>
          </div>
        </div>
        <div className='d-flex justify-content-end mt-2'>
          <input type="text" className='form-control w-25' />
          <button className='btn btn-sm bg-primary-subtle'> Search</button>
        </div>

        <div className='row m-0 p-1 mt-3'>
          <table class="table">
            <thead>
              <tr>
                <th scope="col">#</th>
                <th scope="col">Name</th>
                <th scope="col">Employee ID</th>
                <th scope="col">Leave Type</th>
                <th scope="col">Date</th>
                <th scope="col">Reason</th>
                <th scope="col">Action</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th scope="row">1</th>
                <td>Rakesh</td>
                <td>MTM123</td>
                <td>Medical Leave</td>
                <td>12/1/2023 to  12/1/2023</td>
                <td>Going to Development</td>
                <td>
                  <button>✔</button>
                  <button>❌</button>
                </td>
              </tr>
              {All_Leave_Request != undefined && All_Leave_Request != undefined && All_Leave_Request.map((e, index) => {
                return (


                  <tr>

                    <td key={e.id}> {index + 1}</td>
                    <td key={e.id}> {e.full_name}</td>
                    <td key={e.id}> {e.email}</td>
                    <td key={e.id}> {e.employee_Id}</td>
                    <td key={e.id}> {e.mobile}</td>
                    <td key={e.id}> {e.Date_of_Joining}</td>

                    <td>
                      <button>✔</button>
                      <button>❌</button>
                    </td>


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

export default Emp_leave_request