import React, { useContext, useEffect } from 'react'
import '../assets/css/Login_.css'
import { useState } from 'react'
import '../assets/css/login.css'
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import axios from 'axios';
import { port } from '../App'
import RouterContext, { RouterStore } from '../Context/RouterContext';

const Login__ = () => {
    let { setLoginStatus } = useContext(RouterStore)
    console.log(port);
    let [searchValue] = useSearchParams()
    let uservalue = searchValue.get('user')
    let passwordValue = searchValue.get('password') &&
        encodeURIComponent(searchValue.get('password'))
    console.log(uservalue, passwordValue);
    let [loading, setloading] = useState(false)

    const [employeeId1, setEmployeeId1] = useState("");
    const [password1, setPassword1] = useState("");
    const [showPassword, setShowPassword] = useState(false);


    const togglePasswordVisibility = () => {
        setShowPassword(!showPassword);
    };

    const navigate = useNavigate()


    // LOGIN START

    const handleSubmit1 = async (e) => {
        // e.preventDefault();
        // Check if employeeId1 and password1 are not empty
        setloading(true)
        if (!employeeId1.trim() && !uservalue) {
            alert("Please enter the Employee ID");
            return;
        }

        if (!password1.trim() && !passwordValue) {
            alert("Please enter the password");
            return;
        }
        const formdata = new FormData()
        console.log(employeeId1, password1)
        console.log(uservalue, (passwordValue));

        formdata.append('EmployeeId', uservalue ? uservalue : employeeId1)
        formdata.append('Password', passwordValue != null ? passwordValue : password1)
        // axios.post('http://192.168.0.107:9000/root/login', formdata)
        axios.post(`${port}/root/login`, formdata)
            .then((r) => {
                console.log("Login", r.data)
                sessionStorage.setItem('user', JSON.stringify(r.data))
                sessionStorage.setItem('daspk', JSON.stringify(r.data.pk))
                sessionStorage.setItem('dasid', JSON.stringify(r.data.employee_id))
                sessionStorage.setItem('email', JSON.stringify(r.data.email))
                sessionStorage.setItem('status', JSON.stringify(r.data.Dash_Status))
                navigate(`/dashboard/${r.data.Disgnation}`)
                setLoginStatus(true)
                window.location.reload()
            })
            .catch((err) => {
                const message = err.response ? err.response.data : "Network Error: Backend unreachable";
                alert(message)
                console.log("Login Error", message)
            })
    };


    useEffect(() => {
        if (uservalue && passwordValue)
            handleSubmit1()

    }, [uservalue, passwordValue])

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
        <div className='bg-white ' >
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


            <div className="container flex min-h-[100vh] ">
                <div className="row w-full justify-evenly poppins my-auto min-h-[70vh] m-0">

                    <div className="col-md-6 col-lg-5  p-4 d-none d-lg-flex  flex overflow-hidden relative bg-black rounded-xl ">
                        {/*  */}
                        <div>
                            <img src={require('../assets/Images/signinSoundWave.gif')} alt="SoundWave"
                                className=' absolute w-full -top-[10%] right-0  ' />
                            <img src={require('../assets/Images/signinSoundWave.gif')} alt="SoundWave"
                                className=' absolute -bottom-[10%] right-0  ' />
                        </div>
                        <img src={require('../assets/logo/meridawhitelogo.png')} alt="Merida_White_Logo"
                            className='relative w-[13rem] m-auto h-fit ' />
                    </div>
                    <section className="col-md-6 flex col-lg-4 pe-sm-4 ">

                        <article className='my-auto mx-auto flex flex-col pe-sm-3 justify-between h-full w-full ' >
                            <img src={require('../assets/Images/meridatechmindsbluelogo.png')} alt="Merida_White_Logo"
                                className='relative w-[13rem] m-auto h-fit d-lg-none my-3 ' />
                            <div>
                                <h5 className='text-3xl poppins fw-semibold ' >Welcome Back 👋</h5>
                                <p className='text-slate-500 text-lg my-3 ' >
                                    welcome back ! please login <br /> to your account
                                </p>
                            </div>
                            <section className='  ' >

                                <div className="my-3">
                                    <p className=' mb-1' >Email / Employee Id  </p>
                                    <input type="text" className='block bg-blue-50 text-sm rounded p-[13px]  border-2 outline-none w-full  '
                                        placeholder='Employee ID' value={employeeId1}
                                        onChange={(e) => setEmployeeId1(e.target.value)} />

                                </div>
                                <div className="my-3">
                                    <p className=' mb-1' >Password </p>
                                    <div className=' bg-blue-50 rounded p-[13px] text-sm border-2 flex gap-1  ' >

                                        <input onKeyDown={(e) => {
                                            if (e.key == 'Enter') {
                                                handleSubmit1()
                                            }
                                        }} type={showPassword ? "text" : "password"} autocomplete="off"
                                            className='bg-transparent outline-none w-full  '
                                            placeholder='Password' value={password1} onChange={(e) => setPassword1(e.target.value)} />
                                        <span icon={showPassword ? true : false} onClick={togglePasswordVisibility}>
                                            <i class="fa-regular fa-eye text-body-tertiary">

                                            </i>
                                        </span>
                                    </div>

                                </div>

                                <div className='mt-3 flex ms-3'>

                                    <Link to="/Forgot_password" className='nav-link ms-auto text-blue-600 '>
                                        <span className=' text-blue-600 '>
                                            Forgot Password ?</span>
                                    </Link>

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
                                <button onClick={handleSubmit1}
                                    className='my-5 w-full bg-slate-950 border-slate-950 rounded-2 p-3 hover:bg-blue-600
                             text-slate-50 duration-500 ' >
                                    Login Now
                                </button>
                            </section>
                            <p className='h-[30px] ' ></p>

                            <button className=' border-2 rounded mt-4 p-2 w-full text-blue-600 border-blue-600 text-lg hover:bg-blue-600 hover:text-slate-50 duration-500 ' >
                                Visit Our Site
                            </button>
                        </article>
                    </section>
                </div>
            </div>
        </div>
    )
}

export default Login__