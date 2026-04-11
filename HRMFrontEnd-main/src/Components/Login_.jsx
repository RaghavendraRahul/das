import React from 'react'
import '../assets/css/Login_.css'
// import AnimatedCursor from "react-animated-cursor"
import { useState } from 'react'
import '../assets/css/login.css'
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { port } from '../App'

const Login_ = () => {

    console.log(port);

    const [employeeId1, setEmployeeId1] = useState("");
    const [password1, setPassword1] = useState("");
    const [showPassword, setShowPassword] = useState(false);


    const togglePasswordVisibility = () => {
        setShowPassword(!showPassword);
    };

    const navigate = useNavigate()


    // LOGIN START

    const handleSubmit1 = async (e) => {
        e.preventDefault();
        // Check if employeeId1 and password1 are not empty
        if (!employeeId1.trim()) {
            alert("Please enter the Employee ID");
            return;
        }

        if (!password1.trim()) {
            alert("Please enter the password");
            return;
        }
        const formdata = new FormData()
        console.log(employeeId1, password1)
        formdata.append('EmployeeId', employeeId1)
        formdata.append('Password', password1)
        // axios.post('http://192.168.0.107:9000/root/login', formdata)
        axios.post(`${port}/root/login`, formdata)
            .then((r) => {
                console.log("Login", r.data)
                sessionStorage.setItem('user', JSON.stringify(r.data))
                navigate(`/dashboard/${r.data.Disgnation}`)

            })
            .catch((err) => {
                const message = err.response ? err.response.data : "Network Error: Backend unreachable";
                alert(message)
                console.log("Login Error", message)
            })
    };

    // LOGIN END


    // FORGOT PASSWORD 

    const [EmployeeID, setEmployeeID] = useState('');
    const [OTP, setotp] = useState("")
    const [backendotp, setBackendotp] = useState("")


    const HandleForgotsendMail = () => {

        const formData = new FormData();
        formData.append('EmployeeId', EmployeeID);


        axios.post(`${port}/root/forgotpassword`, formData).then((res) => {
            console.log("sentmail_res", res.data);
            setBackendotp(res.data.OTP)
            alert(res.data)

        }).catch((err) => {
            const message = err.response ? err.response.data : "Network Error: Backend unreachable";
            console.log("sentmail_err", message);

        })
    }

    const handleSubmit = async (e) => {
        e.preventDefault();
        const formdata = new FormData()
        // axios.post('http://192.168.0.107:9000/root/signin', formdata)
        //     .then((r) => {
        //         console.log("Signup Successfull", r.data)
        //         setBackendotp(r.data.OTP)        
        //     })
        //     .catch((err) => {
        //         console.log("Signuop Error", err)
        //     })
    };

    const sendotp = (e) => {
        e.preventDefault();
        const formdata = new FormData()
        formdata.append('OTP', OTP)
        formdata.append('OriginalOTP', backendotp)
        formdata.append('EmployeeId', EmployeeID)
        // formdata.append('sessionid', mess.sessionid)
        if (OTP === backendotp) {
            // axios.post('http://192.168.0.107:9000/root/verify', formdata)
            axios.post(`${port}/root/forgotpasswordverify`, formdata)
                .then((r) => {
                    console.log("OTP sucessfully sent", r.data)
                    alert(r.data)
                    setotp(0)
                    // setvalue("login")
                    navigate(`/Forgotpassword/${EmployeeID}/`)

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
        <div style={{ width: '100%', minHeight: '100vh', backgroundColor: 'rgb(249,230,223)', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
            {/* <AnimatedCursor
                innerSize={7}
                outerSize={25}
                color='193, 11, 111'
                outerAlpha={0.2}
                innerScale={1}
                outerScale={2}
                clickables={[
                    'a',
                    'input[type="text"]',
                    'input[type="email"]',
                    'input[type="number"]',
                    'input[type="submit"]',
                    'input[type="image"]',
                    'input[type="password"]',
                    'label[for]',
                    'select',
                    'textarea',
                    'button',
                    '.link',
                    'h1'
                ]}
            /> */}


            <div className="container p-4 ">
                <div className="row m-0">

                    <div className="col-md-6 col-lg-6 p-4  ">

                        <div className=' mt-lg-5'>


                            <p style={{ color: 'rgb(147,147,191)' }} className='welcome text-md-start text-center  d-md-flex'> <span style={{ fontSize: '30px' }} class='d-none d-md-block '>_____</span> <span style={{ color: '#F5558D', fontSize: '17px' }} className='mt-3 ms-1 text-md-start text-center' > Welcome To,</span></p>
                            <h1 className='head1 text-md-start text-center ' style={{}}>Merida Tech </h1>
                            <h1 className='styled-text  text-md-start text-center minds' style={{}}>Minds </h1>
                            <div className='visit_site w-100 mt-4'>
                                <button className=' visit head '> <a href="https://meridatechminds.com/" style={{ textDecoration: 'none', color: 'black' }}>Visit Our Site</a> </button>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-6 col-lg-6 p-4  ">

                        <div style={{ display: 'flex', justifyContent: 'center' }}>
                            <div class="p-4" style={{ width: '350px', height: '400px', backgroundColor: 'white', borderRadius: '25px' }}>
                                <h4 className='text-center' style={{ color: '#F5558D' }} >Login</h4>

                                <div style={{ width: '100%', display: 'flex', justifyContent: 'center' }}>
                                    <div class="inputGroup">
                                        <input type="text" placeholder='Employee ID' value={employeeId1} onChange={(e) => setEmployeeId1(e.target.value)} />

                                    </div>
                                </div>

                                <div style={{ width: '100%', display: 'flex', justifyContent: 'center' }}>
                                    <div class="inputGroup">
                                        <input type={showPassword ? "text" : "password"} autocomplete="off" placeholder='Password' value={password1} onChange={(e) => setPassword1(e.target.value)} />
                                        <span icon={showPassword ? true : false} onClick={togglePasswordVisibility}><i class="fa-regular fa-eye text-body-tertiary" style={{ position: 'relative', bottom: '36px', left: '250px' }}></i></span>

                                    </div>
                                </div>

                                <div className='mt-3 ms-3' style={{ display: 'flex' }}>
                                    <button className='Login' style={{ fontSize: '10px' }}>
                                        <p style={{ fontSize: '18px' }} onClick={handleSubmit1}>Login Now</p>
                                        <svg
                                            xmlns="http://www.w3.org/2000/svg"
                                            class="h-6 w-6"
                                            fill="none"
                                            viewBox="0 0 24 24"
                                            stroke="currentColor"
                                            stroke-width="4"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                d="M14 5l7 7m0 0l-7 7m7-7H3"
                                            ></path>
                                        </svg>
                                    </button>
                                    <span className='ms-4 ' style={{ cursor: 'pointer', fontSize: '13px', position: 'relative', top: '4px', left: '25px' }} data-bs-toggle="modal" data-bs-target="#exampleModal">Forgot Password ?</span>
                                    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Forgot Password</h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">


                                                    <div className='d-flex justify-content-center'>

                                                        <div class="inputGroup w-75">

                                                            <input type="text" placeholder='Enter Your Employee ID' value={EmployeeID} onChange={(e) => setEmployeeID(e.target.value)} />

                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="modal-footer">

                                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#otpModal" onClick={HandleForgotsendMail}>Send</button>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal fade" id="otpModal" tabindex="-1" aria-labelledby="otpModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5 text-center" id="exampleModalLabel">OTP Verification</h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div className='px-3 d-flex justify-content-center'>
                                                        <div class="inputGroup">
                                                            <input type="number" placeholder='Enter Your OTP' value={OTP} onChange={(e) => setotp(e.target.value)} />

                                                            {/* <input type="number" className='form-control shadow-none' value={OTP} onChange={(e) => setotp(e.target.value)} name="" id="" /> */}
                                                        </div>
                                                    </div>


                                                    <div class="modal-footer">
                                                        <div className='w-100 d-flex justify-content-end'>

                                                            <button className='w-25 btn btn-primary text-white fw-medium mt-4' data-bs-dismiss="modal" onClick={sendotp}>VERIFY</button>
                                                        </div>
                                                    </div>

                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div className='mt-4 d-flex'>
                                    <span className='mt-1  ms-5' style={{ fontSize: '13px' }}>Don't have an account?</span>
                                    <Link to="/Signup_" className='nav-link '>
                                        <span className='mt-4  ms-3 ' style={{ fontSize: '13px', color: '#F5558D' }}>Sign Up</span>
                                    </Link>

                                </div>


                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    )
}

export default Login_