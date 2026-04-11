import React, { useEffect, useState } from 'react'
import { port } from '../../App';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { Modal } from 'react-bootstrap';
import { toast } from 'react-toastify';
import InputFieldform from '../../Components/SettingComponent/InputFieldform';

const ResignationIndex = ({ setActiveSection }) => {
    // HR Manager End
    let navigate = useNavigate()
    let [loading, setLoading] = useState(false)
    let [verificationObj, setVerificationObj] = useState({
        verifiedBy: null,
        review: '',
        hr_rm: "",
        result: '',
        interviewer: null,
        interviewDate: null
    })
    let handleVerificationObj = (e) => {
        let { name, value } = e.target
        setVerificationObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    const [interviewers, setInterviewers] = useState([]);
    useEffect(() => {
        axios.get(`${port}/root/interviewschedule`).then((e) => {
            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        }).catch((error) => {
            console.log(error);
        })
        // sentparticularData()
    }, [])
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let [request, setRequest] = useState([])
    useEffect(() => {
        getResignApplication()
        setActiveSection('request')
    }, [])
    let getResignApplication = async () => {
        await axios.get(`${port}/root/ems/ResignationRequest?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, 'resignation');
            setRequest(response.data)
        }).catch((error) => {
            console.log(error);
        })
        await axios.get(`${port}/root/ems/RM_ResignationVerification?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, "empResignation");
            if (response.data)
                setRequest((prev) => {
                    const newData = response.data.filter(newItem =>
                        !prev.some(prevItem => prevItem.id === newItem.id)
                    );
                    return [...prev, ...newData];
                })
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateData = () => {
        let obj

        if (verificationObj.hr_rm == 'hr')
            obj = {
                is_hr_verified: true,
                hr_verified_On: new Date().toLocaleDateString(),
                rm_verified_On: null,
                resignation_verification: verificationObj.result,
                hr_remarks: verificationObj.review,
                Interviewer: verificationObj.interviewer,
                Date_Of_Interview: verificationObj.interviewDate
            }
        else
            obj = {
                is_rm_verified: true,
                rm_remarks: verificationObj.review,
                hr_verified_On: null,
                rm_verified_On: new Date().toLocaleDateString()
            }
        console.log(obj);
        // return
        setLoading(true)
        axios.patch(`${port}/root/ems/RM_ResignationVerification?sep_id=${verificationObj.verifiedBy}`, obj).then((response) => {
            setVerificationObj({
                verifiedBy: null,
                review: '',
                hr_rm: ""
            })
            console.log(response.data);
            getResignApplication()
            setLoading(false)
            toast.success('Updated successFully')
        }).catch((error) => {
            console.log(error);
            setLoading(false)
            toast.error('Error occured')
        })
    }
    return (
        <div>
            <section className='flex justify-between items-center ' >
                <h5>Resignation applications</h5>
                <button onClick={() => navigate('/employees/Employee_request_form/apply')} className='p-2 rounded bg-blue-800 text-white ' >
                    Apply Regisnation
                </button>
            </section>
            {/* tables */}
            <main className='tablebg table-responsive rounded my-3 h-[60vh]  ' >
                <table className='w-full ' >
                    <tr>
                        <th> SI No </th>
                        <th>Employee Name </th>
                        <th>Employee Id </th>
                        <th> Designation </th>
                        <th> Reason for Resignation </th>
                        <th> Detailed reason </th>
                        <th>Resignation Letter </th>
                        <th>Manager Approval </th>
                        <th>Hr Approval  </th>
                        <th>Request status </th>
                        <th>Action  </th>
                    </tr>
                    {
                        request && request.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td>{obj.name} </td>
                                <td>{obj.employee_id} </td>
                                <td>{obj.position} </td>
                                <td className=' ' >
                                    {obj.reason_for_leaving}
                                </td>
                                <td className=' ' > 
                                   <textarea name="" className='w-[300px]  ' rows={3} value={obj.reason} id="">
                                    </textarea>   </td>
                                <td> <a href={obj.resigned_letter_file} target='_blank' > click here </a> </td>
                                <td> {obj.is_rm_verified ? <span>Verified </span> :
                                    obj.reporting_manager_name == empid ?
                                        <span> <button onClick={() => setVerificationObj((prev) => ({
                                            verifiedBy: obj.id,
                                            hr_rm: 'rm',
                                            review: ''
                                        }))} className='bg-blue-700 text-white text-sm p-1 rounded ' > Verify </button>
                                        </span> : 'Not Verified'} </td>
                                <td> {obj.is_hr_verified ? <span>Verified </span> :
                                    obj.HR_manager_name == empid ?
                                        <span>
                                            <button onClick={() => setVerificationObj((prev) => ({
                                                verifiedBy: obj.id,
                                                hr_rm: 'hr',
                                                review: ''
                                            }))} className='bg-blue-700 text-white text-sm p-1 rounded ' > Verify </button>
                                        </span> : 'Not Verified'} </td>
                                <td>{obj.resignation_verification} </td>
                                <td><button onClick={() => navigate(`/employees/Employee_request_form/request/${obj.id}`)}
                                    className='bg-blue-700 text-white rounded text-sm p-1 ' >View </button>
                                    <button className='bg-slate-700 text-white rounded text-sm p-1 mx-2 ' onClick={() => navigate(`/employees/Employee_request_form/interview/${obj.id}`)} >
                                        Exit Interview
                                    </button>
                                </td>
                            </tr>
                        ))
                    }

                </table>
            </main>
            {/* Modal */}
            {verificationObj.verifiedBy &&
                <Modal className=' ' onHide={() => {
                    setVerificationObj({
                        verifiedBy: null,
                        review: '',
                        hr_rm: "",
                        interviewer: null,
                        interviewDate: null
                    })
                }}
                    show={verificationObj.verifiedBy} centered  >
                    <Modal.Header closeButton >
                        Verification by the {verificationObj.hr_rm != 'hr' ? "Reporting Manager" : "Hr Manager"}
                    </Modal.Header>
                    <Modal.Body>
                        <div>
                            <label htmlFor="">Review :  </label>
                            <textarea name="review" id="" value={verificationObj.review} onChange={handleVerificationObj} className='block w-full border-2 rounded p-2  my-2 outline-none ' rows={3} > </textarea>
                        </div>
                        {verificationObj.hr_rm == 'hr' && <div>
                            <label htmlFor="">Result : </label>
                            <select name="result" onChange={handleVerificationObj} value={verificationObj.result} id=""
                                className='border-2 my-2 p-2 rounded outline-none w-full '  >
                                <option value="">Select</option>
                                <option value="approved">Approved</option>
                                <option value="declined">Declined</option>
                            </select>
                        </div>}
                        {verificationObj.hr_rm == 'hr' && verificationObj.result == 'approved' && <div>
                            <label htmlFor=""> Interviewer :  </label>
                            <select name="interviewer" onChange={handleVerificationObj}
                                id="" value={verificationObj.interviewer}
                                className='border-2 my-2 p-2 rounded outline-none w-full ' >
                                <option value="">Select </option>
                                {interviewers && interviewers.map(interviewer => (
                                    <option key={interviewer.EmployeeId} value={interviewer.id}>
                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                    </option>
                                ))}
                            </select>
                        </div>}
                        {verificationObj.hr_rm == 'hr' && verificationObj.result == 'approved' &&
                            <InputFieldform label="Interview Date" value={verificationObj.interviewDate} name='interviewDate'
                                handleChange={handleVerificationObj} type="date" size="col-12" />}


                        <button onClick={updateData} disabled={loading}
                            className=' my-2 rounded p-2 bg-blue-800 text-white flex ms-auto ' >
                            {loading ? 'Loading..' : "Submit"}
                        </button>
                    </Modal.Body>

                </Modal>}

        </div>
    )
}

export default ResignationIndex