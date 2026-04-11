import React from 'react'
import '../assets/css/Login_.css'
// import AnimatedCursor from "react-animated-cursor"
import { useState } from 'react'
import '../assets/css/login.css'
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { port } from '../App'
import Otp_verifivation from './Otp_verifivation';

const Signup_ = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user'))

    const [showPassword, setShowPassword] = useState(false);
    const [showPassword2, setShowPassword2] = useState(false);

    const [Otp_component, setOtp_component] = useState(false)


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

    const [backendotp, setBackendotp] = useState('')
    let [mess, setMess] = useState({})

    const validateEmail = (email) => {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    }

    const navigate1 = useNavigate()


    const handleSubmit = async (e) => {
        e.preventDefault();


        // Check if any field is empty
        if (!employeeId.trim()) {
            alert("Please enter the Employee ID");
            return;
        }
        if (!username.trim()) {
            alert("Please enter User Name");
            return;
        }
        if (!email.trim()) {
            alert("Please enter Email");
            return;
        }
        if (!validateEmail(email)) {
            alert("Please enter a valid Email");
            return;
        }
        if (!phone.trim()) {
            alert("Please enter Phone Number");
            return;
        }
        if (phone.length !== 10) {
            alert("Phone number must be exactly 10 digits");
            return;
        }
        if (!password.trim()) {
            alert("Please enter the password");
            return;
        }
        if (!conpassword.trim()) {
            alert("Please enter the Confirm password");
            return;
        }
        if (password !== conpassword) {
            alert("Passwords do not match");
            return;
        }

        const formdata = new FormData();
        formdata.append('EmployeeId', employeeId);
        formdata.append('UserName', username);
        formdata.append('Email', email);
        formdata.append('PhoneNumber', phone);
        formdata.append('Password', password);

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/signin`, formdata)
            .then((r) => {

                setBackendotp(r.data.OTP)
                console.log("Signup_Successfull", r.data)
                if (r.data.Message === 'Employee Id Not Available!') {

                    alert(r.data.Message)

                }
                else {
                    setOtp_component(true)
                    setMess(r.data)
                    setEmail('')
                    setPassword('')
                    setPhone('')
                    setUsername('')
                    setconPassword('')

                }

            })
            .catch((err) => {
                const message = err.response ? err.response.data : "Network Error: Backend unreachable";
                alert(message)
                console.log("Signuop Error", message)
            })



    };
    // Register form end








    return (
        <div style={{ position: 'relative', width: '100%', minHeight: '100vh', backgroundColor: 'rgb(249,230,223)', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>

            <div className="container p-3 p-sm-4 ">
                <div className="row m-0">

                    <div className="col-md-4 col-lg-4 p-4 sign_img  ">

                        <div className='mt-0 mt-sm-5 ' style={{ position: 'relative', right: '50px' }}>
                            <img src={require('../assets/Images/undraw_creation_process_re_kqa9-removebg-preview.png')} style={{ width: '420px' }} alt="" />
                        </div>


                    </div>
                    <div className="col-md-8 col-lg-8 p-1   ">

                        <div className='sign_main' >
                            <div class="p-3 p-sm-4" style={{ width: '98%', minHeight: '450px', backgroundColor: 'white', borderRadius: '25px' }}>
                                <h4 className='text-sm-start ms-0 ms-sm-4 text-center' style={{ color: '#F5558D' }} >Sign Up</h4>
                                <form onSubmit={handleSubmit}>
                                    <div className='sign_up_inputs'>
                                        <div className="inputGroup">
                                            <input type="text" placeholder='Employee ID' value={employeeId} onChange={(e) => setEmployeeId(e.target.value)} required />
                                        </div>
                                        <div className="inputGroup ">
                                            <input type="text" placeholder='User Name' value={username} onChange={(e) => setUsername(e.target.value)} required />
                                        </div>
                                    </div>
                                    <div className='sign_up_inputs1 mt-3 mt-sm-0'>
                                        <div className="inputGroup ">
                                            <input type="email" placeholder='Mail' value={email} onChange={(e) => setEmail(e.target.value)} required />
                                        </div>
                                        <div className="inputGroup">
                                            <input type="tel" placeholder='Phone' value={phone} onChange={(e) => setPhone(e.target.value)} required />
                                        </div>
                                    </div>
                                    <div className='sign_up_inputs2 mt-3 mt-sm-0'>
                                        <div className="inputGroup">
                                            <input type={showPassword ? "text" : "password"} placeholder='Password' value={password} onChange={(e) => setPassword(e.target.value)} required />
                                            <span style={{ position: 'relative', bottom: '40px', left: '240px' }} onClick={() => {
                                                setShowPassword(!showPassword);
                                            }}><i className="fa-regular fa-eye text-body-tertiary"></i></span>
                                        </div>
                                        <div className="inputGroup ">
                                            <input type={showPassword2 ? "text" : "password"} placeholder='Re-Enter Password' value={conpassword} onChange={(e) => setconPassword(e.target.value)} required />
                                            <span style={{ position: 'relative', bottom: '40px', left: '240px' }} onClick={() => {
                                                setShowPassword2(!showPassword2);
                                            }}><i className="fa-regular fa-eye text-body-tertiary"></i></span>
                                        </div>
                                    </div>
                                    <div className='' style={{ display: 'flex', justifyContent: 'center', position: 'relative', bottom: '30px' }}>
                                        <button type='submit' className='btn text-white p-2' style={{ width: '94%', backgroundColor: 'rgb(245,85,141)' }}>Register</button>
                                    </div>
                                </form>

                                <div className='mt-4 ' style={{ display: 'flex', justifyContent: 'center', position: 'relative', bottom: '30px' }}>
                                    <span className='mt-1  ms-2' style={{ fontSize: '15px' }}>I have already account?</span>
                                    <Link to="/" className='nav-link '>
                                        <span className='mt-4  ms-3 ' style={{ fontSize: '15px', color: '#F5558D' }}>Log in</span>
                                    </Link>

                                </div>


                            </div>
                        </div>
                    </div>

                </div>

            </div>
            <Otp_verifivation value2={setOtp_component} value={employeeId} value1={Otp_component} otp={backendotp}></Otp_verifivation>
        </div>
    )
}

export default Signup_