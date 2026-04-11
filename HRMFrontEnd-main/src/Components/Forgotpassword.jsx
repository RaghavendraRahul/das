import axios from 'axios'
import React, { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {port} from '../App' 


const Finalstatuscomment = ({ selectstatus,candidateid,final_status_value,setselectstatus}) => {


  let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

  console.log("Selected candidate id",candidateid)
  console.log("status",final_status_value)
  const [statusreview, setStatusreview] = useState("")

  
  const navi=useNavigate();


  let handlestatusreview = (e) => {
    e.preventDefault();
    // console.log(statusreview,candidateid);
   

    const formData1 = new FormData()

    formData1.append('Final_Result', final_status_value);
    formData1.append('CandidateId', candidateid);
    formData1.append('Comments', statusreview);
    formData1.append('ReviewedBy', Empid);


    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/FinalStatusUpdate`, formData1)
      .then((r) => {
        alert("Final status comment send Successfull")
        console.log("statusreview_res", r.data)
        setselectstatus((prev)=>!prev)

      })
      .catch((err) => {
        console.log("statusreview_err", err)
      })

  }



 


  return (
    <div className={`${selectstatus ? '' : 'd-none'}`} style={{ width: '100%',minHeight : '100vh', background: 'bg-transparent', position: 'absolute' }}>


      <form style={{ width: '350px', minHeight: '80px', backgroundColor: 'rgb(238,238,238)', borderRadius: '10px', position: 'relative', left: '750px', top: '200px', display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', position: 'absolute' }}>

          <div>
            <span style={{ position: 'relative', right: '80px', bottom: '80px', fontSize: '16px' }}>Status Review</span>
          </div>
          <button className='border-0' style={{ position: 'relative', left: '80px', bottom: '80px' }}>
            <small><i class="fa-solid fa-xmark" style={{ fontSize: '18px' }}></i></small>

          </button>
        </div>

        <div className="row m-0 pb-2 mt-5">
          <div className="col-md-12 col-lg-12 mb-3">
            <textarea name="" id="" style={{ width: '300px', minHeight: '100px' }} value={statusreview} onChange={(e) => setStatusreview(e.target.value)} ></textarea>
          </div>
        </div>


        <button type="submit" style={{ position: 'relative', left: '80px', bottom: '15px' }} onClick={handlestatusreview} className="btn btn-primary btn-sm text-white fw-medium px-2 px-lg-5 ">Send </button>


      </form>



    </div>
  )
}

export default Finalstatuscomment