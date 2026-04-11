import React, { useState } from 'react'
import '../assets/css/login.css'
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { port } from '../App'



const Signup = () => {


  let Empid = JSON.parse(sessionStorage.getItem('user'))

  const [showPassword, setShowPassword] = useState(false);
  const [showPassword2, setShowPassword2] = useState(false);


  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  // Register form start

  const [employeeId, setEmployeeId] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [conpassword, setconPassword] = useState('');

  const [backendotp, setBackendotp] = useState("")

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formdata = new FormData()
    formdata.append('EmployeeId', employeeId)
    formdata.append('UserName', username)
    formdata.append('Email', email)
    formdata.append('PhoneNumber', phone)
    formdata.append('Password', password)



    for (let pair of formdata.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }


    axios.post(`${port}/root/signin`, formdata)
      .then((r) => {
        console.log("Signup Successfull", r.data)
        setBackendotp(r.data.OTP)
        setMess(r.data)
        setEmail('')
        setPassword('')
        setPhone('')
        setUsername('')
        setconPassword('')
      })
      .catch((err) => {
        const message = err.response ? err.response.data : "Network Error: Backend unreachable";
        alert(message)
        console.log("Signuop Error", message)
      })
  };
  // Register form end

  const navigate = useNavigate()

  const [OTP, setotp] = useState("")
  let [mess, setMess] = useState({})


  const sendotp = () => {
    const formdata = new FormData()
    formdata.append('OTP', OTP)
    formdata.append('OriginalOTP', backendotp)
    formdata.append('EmployeeId', employeeId)

    for (let pair of formdata.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    // formdata.append('sessionid', mess.sessionid)
    if (OTP === backendotp) {
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
    <div className='row m-0 p-0  p-sm-4 ' style={{ width: '100%', minHeight: '100vh' }}>

      <div className="col col-sm-4 p-4 d-lg-block  d-none sign-back ">



      </div>

      <div className="col col-sm-8 p-4">
        <div>
          <div className="logo d-flex justify-content-end me-4">
            <img src={require('../assets/logo/merida-logo.b828553ab6c128308899.png')} width={100} alt="" />
          </div>

          <form action="" onSubmit={handleSubmit}>

            <div className="input-con p-4 mt-3 ">
              <div>
                <h1 className='head'>Sign Up</h1>
              </div>
              <div className='mt-5'>
                <div className='d-flex justify-content-between' style={{ width: '100%' }}>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="Empid" className='head text-secondary'>Employee Id</label> <br />
                    <input type="tel" id="tel" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-2' value={employeeId} onChange={(e) => setEmployeeId(e.target.value)} required />
                  </div>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="text" className='head text-secondary'>User Name</label> <br />
                    <input type="text" id="usename" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-2' value={username} onChange={(e) => setUsername(e.target.value)} required />
                  </div>

                </div>
                <div className='d-flex justify-content-between mt-3' style={{ width: '100%' }}>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="email" className='head text-secondary'>Mail</label> <br />
                    <input type="email" id="email" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-1' value={email} onChange={(e) => setEmail(e.target.value)} required />
                  </div>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="phone" className='head text-secondary'>Phone</label> <br />
                    <input type="tel" id="phone" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-1' value={phone} onChange={(e) => setPhone(e.target.value)} required />
                  </div>

                </div>
                <div className='d-flex justify-content-between mt-3' style={{ width: '100%' }}>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="password" className='head text-secondary'>Password</label> <br />
                    <div className="password-input d-flex">
                      <input type={showPassword ? "text" : "password"} id="password" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-1' value={password} onChange={(e) => setPassword(e.target.value)} required />
                      <span onClick={() => {
                        setShowPassword(!showPassword)
                      }}><i class="fa-regular fa-eye text-body-tertiary"></i></span>

                    </div>
                  </div>
                  <div style={{ width: '48%' }}>
                    <label htmlFor="password" className='head text-secondary'>Re-Enter Password</label> <br />
                    <div className="password-input d-flex">
                      <input type={showPassword2 ? "text" : "password"} id="password" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-1' value={conpassword} onChange={(e) => setconPassword(e.target.value)} required />
                      <span onClick={() => {
                        setShowPassword2(!showPassword2)
                      }}><i class="fa-regular fa-eye text-body-tertiary"></i></span>

                    </div>
                  </div>

                </div>
                <div className='mt-4'>
                  <button className='btn bg-primary w-100 text-white head p-2' type='submit' data-bs-toggle="modal" data-bs-target="#otpModal">Register</button>
                </div>


                <div className='text-center mt-4'>
                  <p className='d-flex justify-content-center'>I have already account?

                    <Link to="/" className='nav-link ms-2'  >

                      <small className='text-primary'>Log in</small>
                    </Link>


                  </p>
                </div>
              </div>
            </div>

          </form>

          {/* ---------------------------------OTP MODAL------------------------------------------- */}
          <div class="modal fade" id="otpModal" tabindex="-1" aria-labelledby="otpModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5 text-center" id="exampleModalLabel">OTP Verification</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <div className='px-3'>
                    <input type="number" className='form-control shadow-none' onChange={(e) => {
                      setotp(e.target.value)
                    }} name="" id="" />
                    <button className='w-100 btn btn-primary text-white fw-medium mt-4' data-bs-dismiss="modal" onClick={sendotp}>VERIFY</button>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  )
}

export default Signup