import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'


const Forgot_pass_otp_verification = ({ Set_Component_forgot, Component_forgot,backendotp,EmployeeID }) => {

    console.log("set_Component_forgot_Status", Set_Component_forgot);
    console.log("Component_forgot_Status", Component_forgot);
    console.log("backendotp", backendotp);
    console.log("EmployeeID", EmployeeID);


    const [OTP, setotp] = useState("")
 
    const navigate = useNavigate()


    const sendotp = () => {

        const formdata = new FormData()
        formdata.append('OTP', OTP)
        formdata.append('OriginalOTP', backendotp)
        formdata.append('EmployeeId', EmployeeID)

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        // formdata.append('sessionid', mess.sessionid)
        if (OTP === backendotp) {
            axios.post(`${port}/root/verify`, formdata)
                .then((r) => {
                    console.log("OTP sucessfully sent", r.data)
                    setotp(0)
                    alert(r.data.message)
                    navigate(`/Set_password/${EmployeeID}/`)

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
        <div style={{ position: 'fixed', left: '0px', top: '0px', width: '100%', zIndex: 5 }} className={`p-1 p-sm-4 bg-light otp-verification-container ${Component_forgot ? '' : ' d-none'}`}>
            <div className='otp_verification'>
                <div className="modal-dialog">
                    <div className="modal-content">
                        <div className="modal-header border-bottom p-4" style={{ display: 'flex', justifyContent: 'space-between' }}>
                            <h1 className="modal-title fs-5" id="exampleModalLabel">OTP Verification</h1>
                            <button type="button" className="btn-close" onClick={() => { Set_Component_forgot(false) }} ></button>
                        </div>
                        <div className="modal-body border-bottom p-2">
                            <div className='d-flex justify-content-center'>
                                <div className="inputGroup w-sm-75">
                                    <input type="text" placeholder='Enter Your OTP' value={OTP} onChange={(e) => setotp(e.target.value)}
                                    />
                                </div>
                            </div>
                        </div>
                        <div className="modal-footer p-3">
                            <button type="button" className="btn btn-primary" onClick={sendotp}>Send</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Forgot_pass_otp_verification;
