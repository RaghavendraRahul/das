import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import axios from 'axios'
import { port } from '../App'



const Requestt = () => {

    let Profile_Info = JSON.parse(sessionStorage.getItem('Login_Profile_Information'))

    // EMPLOYEE RESIGNATION FORM  START

    const [Reason, setReason] = useState('');
    const [HRmanager, setHRmanager] = useState('');
    const [resigned_letter_file, setresigned_letter_file] = useState({});
    const [Confirm_resignation, setConfirm_resignation] = useState(false);

    const handle_employee_Resignation_info = (e) => {
        e.preventDefault()
        alert("EMPLOYEE RESIGNATION FORM ")

        // console.log(resigned_letter_file)
        const formData1 = new FormData()

        formData1.append('employee_id', Profile_Info.employee_Id);
        formData1.append('name', Profile_Info.full_name);
        formData1.append('position', Profile_Info.Position);
        formData1.append('reporting_manager_name', Profile_Info.RepotringTo_Id);
        formData1.append('HR_manager_name', HRmanager);
        formData1.append('reason', Reason);
        formData1.append('resigned_letter_file', resigned_letter_file);
        formData1.append('Confirm_resignation', Confirm_resignation);


        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}root/ems/ResignationRequest`, formData1).then((res) => {

            console.log("EMPLOYEE_RESIGNATION_FORM_RES", res.data);
            alert(res.data)


        }).catch((err) => {

            console.log("EMPLOYEE_RESIGNATION_FORM_ERR", err.data);

        })

    }
    //  EMPLOYEE RESIGNATION FORM  END

    // HR Manager Start

    const [interviewers,setinterviewers]=useState([])

    useEffect(() => {

        axios.get(`${port}/root/ems/HRList`).then((res) => {
            console.log("HrManager", res.data);
            setinterviewers(res.data)
        }).catch((error) => console.log(error))
    }, [])
    // HR Manager End


    return (
        <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav>

                <div>

                    {/* EMPLOYEE RESIGNATION FORM START */}
                    <div className='p-3' >
                        <form>
                            {/* Form start */}
                            <div className="row justify-content-center m-0 ">
                                <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EMPLOYEE RESIGNATION FORM </h5>
                                <div className="col-lg-12 p-4 mt-4 border rounded-lg ">
                                    <div className="row m-0 pb-2">
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="Name" className="form-label">Employee id* </label>
                                            <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Profile_Info.employee_Id} />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="Name" className="form-label">Name* </label>
                                            <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Profile_Info.full_name} />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="lastName" className="form-label">Position*</label>
                                            <input type="text" className="form-control shadow-none" value={Profile_Info.Position} id="LastName" name="LastName" />
                                        </div>
                                        <div className="col-md-6 col-lg-3 mb-3">
                                            <label htmlFor="email" className="form-label">Reporting manager*</label>
                                            <input type="text" className="form-control shadow-none" value={Profile_Info.RepotringTo_Name === null ? `${Profile_Info.full_name} , ${Profile_Info.RepotringTo_Id}` : `${Profile_Info.RepotringTo_Name} , ${Profile_Info.RepotringTo_Id}`} id="Email" name="Email" />
                                        </div>
                                       
                                        
                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <label for="interviewer">HR manager*</label>
                                            <select id="interviewer" name="interviewer" onChange={(e) => setHRmanager(e.target.value)}  required class="form-control">
                                                <option value="" selected>Select Name</option>
                                                {interviewers.map(interviewer => (
                                                    <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                    </option>
                                                ))}
                                            </select>
                                        </div>
                                        
                                        <div className="col-md-6 col-lg-8 mb-3">
                                            <label htmlFor="primaryContact" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Reason*</label>
                                            <input type="text" className="form-control shadow-none" value={Reason} onChange={(e) => setReason(e.target.value)} id="PrimaryContact" name="PrimaryContact" style={{ height: '60px' }} />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="secondaryContact" className="form-label">resigned_letter file*</label>
                                            <input type="file" className="form-control shadow-none" onChange={(e) => setresigned_letter_file(e.target.files[0])} id="SecondaryContact" name="SecondaryContact" />
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3 mt-4 pt-3">
                                            <input type="checkbox" className=" shadow-none" value={Confirm_resignation} onChange={(e) => {
                                                setConfirm_resignation(!Confirm_resignation)
                                            }} id="State" name="State" />
                                            <label htmlFor="secondaryContact" className="form-label ms-4">Confirm resignation</label>
                                        </div>


                                    </div>
                                </div>
                            </div>
                            {/* form end */}
                            {/* Button start */}
                            <div class=" d-flex justify-content-end mt-2">

                                <div className='d-flex gap-2'>


                                    <button type="submit" class="btn btn-success btn-sm" onClick={handle_employee_Resignation_info}  >Submit</button>



                                </div>
                            </div>
                            {/* Button end */}
                        </form>
                    </div>
                    {/* EMPLOYEE RESIGNATION FORM  END */}

                </div>






            </div>



        </div>
    )
}

export default Requestt