import React, { useState } from 'react'
import '../assets/css/login.css'
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { port } from '../App'



const Login = () => {

    console.log(port);

    const [employeeId1, setEmployeeId1] = useState("");
    const [password1, setPassword1] = useState("");
    const [showPassword, setShowPassword] = useState(false);
    // const history = useHistory();

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
            alert('Check Your Mail')

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
        <div className='row m-0 p-0  p-sm-4 ' style={{ width: '100%', height: '100vh' }}>
            <div className="col col-sm-6 p-4">
                <div>
                    <div className="logo ms-4">
                        <img src={require('../assets/logo/meridawhitelogo.png')} width={100} alt="" />
                    </div>



                    <div className="input-con p-4 mt-5 ">
                        <div>
                            <h1 className='head'>Login</h1>
                            <p className='pt-1'>Welcome back! Please Enter email and Password </p>
                        </div>




                        <form action=""  >




                            <div className='mt-4'>
                                <div>
                                    <label htmlFor="tel" className='head text-secondary'>Employee Id</label> <br />
                                    <input type="tel" id="tel" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-2' value={employeeId1} onChange={(e) => setEmployeeId1(e.target.value)} required />

                                </div>
                                <div className='pt-2'>
                                    <label htmlFor="password" className='head text-secondary'>Password</label> <br />
                                    <div className="password-input d-flex">
                                        <input type={showPassword ? "text" : "password"} id="password" className='w-100 border border-bottom-1 border-top-0 border-end-0 border-start-0 input-bar pt-2' value={password1} onChange={(e) => setPassword1(e.target.value)} required />

                                        <span icon={showPassword ? true : false} onClick={togglePasswordVisibility}><i class="fa-regular fa-eye text-body-tertiary"></i></span>

                                    </div>
                                </div>
                                <div className='mt-3 text-end'>
                                    <small className='text-primary' style={{ cursor: 'pointer' }} data-bs-toggle="modal" data-bs-target="#exampleModal">Forgot Password?</small>

                                    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Forgot Password</h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div className="col-md-12 col-lg-12 mb-3 text-start">
                                                        <label htmlFor="Name" className="form-label text-start">Enter Your Employee ID </label>
                                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={EmployeeID} onChange={(e) => setEmployeeID(e.target.value)} />
                                                    </div>
                                                </div>
                                                <div class="modal-footer">

                                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#otpModal" onClick={HandleForgotsendMail}>Send</button>
                                                </div>

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
                                                <div className='px-3'>
                                                    <input type="number" className='form-control shadow-none' value={OTP} onChange={(e) => setotp(e.target.value)} name="" id="" />
                                                    <button className='w-100 btn btn-primary text-white fw-medium mt-4' data-bs-dismiss="modal" onClick={sendotp}>VERIFY</button>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>


                                <div className='mt-3'>
                                    <button className='btn bg-primary w-100 text-white head' type='submit' onClick={handleSubmit1}>LOGIN</button>

                                    {/* <div className='d-flex justify-content-around pt-1'>
                                        <Link to='/Canditatereg-form'>
                                            Reg Form
                                        </Link>
                                        <Link to='dashboard/HR'>
                                            Hr Dash
                                        </Link>
                                        <Link to='dashboard/Rec'>
                                            Rec Dash
                                        </Link>
                                        <Link to='dashboard/Emp'>
                                            Emp Dash
                                        </Link>

                                    </div> */}

                                </div>
                                <div className='text-center mt-4'>
                                    <p className='d-flex justify-content-center'>Don't have an account?

                                        <Link to="/Signup" className='nav-link ms-2'>

                                            <small className='text-primary'>Sign Up</small>
                                        </Link>


                                    </p>
                                </div>
                            </div>

                        </form>
                    </div>


                </div>
            </div>
            <div className="col col-sm-6 p-4 d-lg-block  d-none ">

                <div className='rounded ms-4' >

                    <img src={require('../assets/Images/20944201.jpg')} width={530} alt="" />

                </div>

            </div>

        </div>
    )
}

export default Login