import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { port } from '../App'



const Set_password = () => {

    const { id } = useParams()
    const [modalOpen, setModalOpen] = useState(false);
    const [NewPassword, setNewPassword] = useState("");
    const [ConfirmPassword, setConfirmPassword] = useState("");

    useEffect(() => {

        setModalOpen(true); // Open the modal when the component mounts
    }, []);


    const navigate = useNavigate()


    let handleforgotpassword = (e) => {
        e.preventDefault();

        if (NewPassword == ConfirmPassword) {

            const formData = new FormData();
            formData.append('NewPassword', NewPassword);
            formData.append('EmployeeId', id);

            axios.post(`${port}/root/setpassword`, formData).then((res) => {
                console.log("setpassword_res", res.data);
                alert(res.data.message)
            }).catch((err) => {
                console.log("setpassword_err", err.data);

            })

            alert("Password Changed...")

            navigate(`/`)

        } else {

            alert("Password is Not Matched")

        }

    }







    return (
        <div className='p-1 p-sm-4 bg-light set-password-container'>
            <div className='set_password'>
                <div className="modal-dialog">
                    <div className="modal-content">
                        <div className="modal-header border-bottom p-4" style={{ display: 'flex', justifyContent: 'space-between' }}>
                            <h1 className="modal-title fs-5" id="exampleModalLabel">Set Password</h1>
                            <Link to='/'>

                                <button type="button" className="btn-close" ></button>
                            </Link>
                        </div>
                        <div className="modal-body border-bottom p-2">
                            <div className='d-flex justify-content-center' style={{ flexDirection: 'column', alignItems: 'center' }}>
                                <div className="inputGroup w-75">
                                    <input type="password" placeholder='Enter Your New Password' value={NewPassword} onChange={(e) => setNewPassword(e.target.value)} />
                                </div>
                                <div className="inputGroup w-75 mt-3">
                                    <input type="password" placeholder='Enter Your Confirm Password' value={ConfirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} />
                                </div>
                            </div>
                        </div>
                        <div className="modal-footer p-3">
                            <button type="button" className="btn btn-primary" onClick={handleforgotpassword}>Send</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Set_password;
