import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom';
import {port} from '../App' 



const Forgotpass = () => {

    const {id}=useParams()
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
                console.log("setpassword_res",res.data);
                alert(res.data)
            }).catch((err)=>{
                console.log("setpassword_err",err.data);

            })
         
            alert("Password Changed...")

            navigate(`/`)

        } else {

            alert("Password is Not Matched")
      
        }

    }






    return (
        <div style={{ width: '100%',minHeight: '100vh', background: 'bg-transparent', position: 'absolute' }}>


          

            {modalOpen && (
                <div className="modal fade show" tabIndex="-1" role="dialog" style={{ display: 'block' }}>
                    <div className="modal-dialog modal-dialog-centered  " role="document">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h4 className="text-center">Set  Password</h4>
                                <button type="button" className="btn-close" onClick={() => setModalOpen(false)} aria-label="Close"></button>
                            </div>
                            <div className="modal-body">
                                <div className="col-md-12 col-lg-12 mb-3 text-start">
                                    <label htmlFor="Name" className="form-label text-start">New Password </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={NewPassword} onChange={(e) => setNewPassword(e.target.value)} />
                                </div>
                                <div className="col-md-12 col-lg-12 mb-3 text-start">
                                    <label htmlFor="Name" className="form-label text-start">Confirm Password </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={ConfirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} />
                                </div>

                            </div>
                            <div className="modal-footer">

                                <button className='btn btn-success btn-sm' onClick={handleforgotpassword}> submit</button>

                            </div>
                        </div>
                    </div>
                </div>
            )}
            {modalOpen && <div className="modal-backdrop fade show"></div>}

        </div>
    )
}

export default Forgotpass