import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'
import Forgot_pass_otp_verification from './Forgot_pass_otp_verification';

const Forgot_password = () => {


  const [Forgot_pass_otp_verification_Component, setForgot_pass_otp_verification__Component] = useState(false)

  const [EmployeeID, setEmployeeID] = useState('');
  const [OTP, setotp] = useState("")
  const [backendotp, setBackendotp] = useState("")

  const navigate = useNavigate()

  const HandleForgotsendMail = () => {

    const formData = new FormData();
    formData.append('EmployeeId', EmployeeID);


    axios.post(`${port}/root/forgotpassword`, formData).then((res) => {

      console.log("sentmail_res", res.data);

      setBackendotp(res.data.OTP)

      if (res.data.OTP.length === 6) {
        alert(res.data.message)
        // navigate('/Forgot_Otp_Verification')
        setForgot_pass_otp_verification__Component(true)
      }
      else {
        alert('ERROR')
      }

    }).catch((err) => {
      console.log("sentmail_err", err.data);
      alert(err.data)
    })
  }



  return (
    <div className='p-1 p-sm-4 bg-light otp-verification-container' >

      <div className='otp_verification' >

        <div class="modal-dialog">
          <div class="modal-content ">
            <div class="modal-header border-bottom p-4" style={{ display: 'flex', justifyContent: 'space-between' }}>
              <h1 class="modal-title fs-5" id="exampleModalLabel">Forgot Password</h1>

              <Link to='/Login__'>

                <button type="button" class="btn-close"  ></button>
              </Link>

            </div>
            <div class="modal-body border-bottom p-2">


              <div className='d-flex justify-content-center'>

                <div class="inputGroup w-75">

                  <input type="text" placeholder='Enter Your Employee ID' value={EmployeeID} onChange={(e) => setEmployeeID(e.target.value)} />

                </div>
              </div>

            </div>
            <div class="modal-footer p-3">

              <button type="button" class="btn btn-primary"
                onClick={HandleForgotsendMail}>Send</button>
            </div>

          </div>
        </div>

      </div>

      <Forgot_pass_otp_verification Set_Component_forgot={setForgot_pass_otp_verification__Component} Component_forgot={Forgot_pass_otp_verification_Component} backendotp={backendotp} EmployeeID={EmployeeID} ></Forgot_pass_otp_verification>


    </div>
  );
};

export default Forgot_password;
