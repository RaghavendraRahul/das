import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'


const Otp_verifivation = ({ value, value1 ,value2 ,otp}) => {

  console.log("employee_Id", value);
  console.log("status", value1);
  console.log("Backend_otp",otp);
  // console.log("Status",value,value1,value2,otp);
  // console.log("status", value2);
  // setBackendotp(otp)

  const [OTP, setotp] = useState("")
  const [employeeId, setEmployeeId] = useState('');
  const [backendotp, setBackendotp] = useState(otp)

  const navigate = useNavigate()

  const sendotp = () => {

    const formdata = new FormData()
    formdata.append('OTP', OTP)
    formdata.append('OriginalOTP', otp)
    formdata.append('EmployeeId', value)

    for (let pair of formdata.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    // formdata.append('sessionid', mess.sessionid)
    if (OTP === otp) {
      axios.post(`${port}/root/verify`, formdata)
        .then((r) => {
          console.log("OTP sucessfully sent", r.data)
          setotp(0)
          // setvalue("login")
          navigate('/')

        })
        .catch((err) => {
          console.log("OTP error", err)
        })
    }
    else {
      alert("Invalid OTP")
    }
  }

  return (
    <div style={{position:'fixed',left:'0px',top:'0px' ,width:'100%',zIndex:5}} className={`p-1 p-sm-4 bg-light otp-verification-container ${value1 ? '' : ' d-none'}`}>
      <div className='otp_verification'>
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header border-bottom p-4" style={{ display: 'flex', justifyContent: 'space-between' }}>
              <h1 className="modal-title fs-5" id="exampleModalLabel">OTP Verification</h1>
              <button type="button" className="btn-close" onClick={()=>{ value2(false)}}></button>
            </div>
            <div className="modal-body border-bottom p-2">
              <div className='d-flex justify-content-center'>
                <div className="inputGroup w-sm-75">
                  <input type="text" placeholder='Enter Your OTP' onChange={(e) => {
                    setotp(e.target.value)
                  }} />
                </div>
              </div>
            </div>
            <div className="modal-footer p-3">
              <button type="button" onClick={sendotp} className="btn btn-primary">Send</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Otp_verifivation;
