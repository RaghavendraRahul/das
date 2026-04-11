import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Link, useParams } from 'react-router-dom';
import { port } from '../App'
import { toast } from 'react-toastify';
import { CloseButton } from 'react-bootstrap';


const Dummydoc = () => {
    const { id } = useParams();
    const { login } = useParams();
    let [status, setstatus] = useState(false)

    const [formData, setFormData] = useState([{
        CandidateID: id,
        Name: "",
        Provious_Company: "",
        Provious_Designation: "",
        experience: "",
        from_date: "",
        To_date: "",
        Current_CTC: "",
        Reporting_Manager_name: "",
        Reporting_Manager_email: "",
        ReportingManager_phone: "",
        HR_name: "",
        HR_email: "",
        HR_phone: "",
        Salary_Drawn_Payslips: null,
        Document: null,
    }]);

    const handleChange = (e, index) => {
        let { name, value, files } = e.target
        if (name == 'Document' || name == 'Salary_Drawn_Payslips') {
            value = files[0]
        }
        if (name == 'To_date' && formData[index].from_date && value < formData[index].from_date) {
            value = formData[index].from_date
        }
        if (name == 'from_date' && formData[index].To_date && value < formData[index].To_date) {
            value = formData[index].To_date
        }

        let obj = formData[index]
        obj[name] = value
        let updateArry = [...formData]
        updateArry[index] = obj
        setFormData(updateArry)
    }
    let [loading, setloading] = useState(false)
    let validate = () => {
        let count = 0
        formData.forEach((obj) => {
            for (const key in obj) {
                if (obj[key] == '')
                    count++
            }
        })
        return count > 0 ? false : true
    }
    let getStatus = () => {
        // alert("hellow")
        axios.get(`${port}/root/DocumentsUploadedList/${id}/`).then((response) => {
            console.log(response.data, "status");
            if (response.data && response.data.length > 0)
                setstatus(true)
        }).catch((error) => {
            console.log(error, 'status');
        })
    }
    useEffect(() => {
        getStatus()
    }, [])
    // const handleSubmit = (e) => {
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (validate()) {
            setloading(true)
            formData.map((x) => console.log(x))
            try {
                // formData.forEach((obj, index) => {
                const uploadPromises = formData.map((obj) => {
                    const formObj = new FormData();
                    for (const key in obj) {
                        if (obj[key])
                            formObj.append(key, obj[key]);
                    }
                    //     axios.post(`${port}/root/DocumentsUploadData/${id}/${login}`, formObj).catch((error) => {
                    //         console.log(error);
                    //     })
                    // })
                    return axios.post(`${port}/root/DocumentsUploadData/${id}/${login}`, formObj);
                });

                await Promise.all(uploadPromises);

                getStatus()
                setloading(false)
                toast.success(`Document Verification Successful`)

                // Allow toast to be seen briefly or just reload - user current flow is immediate reload
                window.location.reload()

                setFormData([{
                    CandidateID: id,
                    Name: "",
                    Provious_Company: "",
                    Provious_Designation: "",
                    experience: "",
                    from_date: "",
                    To_date: "",
                    Current_CTC: "",
                    Reporting_Manager_name: "",
                    Reporting_Manager_email: "",
                    ReportingManager_phone: "",
                    HR_name: "",
                    HR_email: "",
                    HR_phone: "",
                    Salary_Drawn_Payslips: null,
                    Document: null,
                }])
                // toast.success(`Document Verification Successful`)
            } catch (error) {
                console.log(error);
                toast.error('Error acquired')
                setloading(false)
            }
        }
        else
            toast.warning('Enter all the fields')
    };


    let logindata = JSON.parse(sessionStorage.getItem('user'))

    return (
        <div className='min-h-[100vh] flex '>
            {status ?
                <section className=' bg-white rounded w-fit p-20 flex m-auto   ' >
                    Form has been Submitted.
                </section> :
                <div className='animate_animated  animate_slideInUp'>
                    <div className='container-fluid row m-0 pb-4 pt-3'>
                        <div className='mb-2 bg-transparent d-flex'>

                            {/* <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" className="bi bi-arrow-left" viewBox="0 0 16 16">
                                <path fillRule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                            </svg> */}

                            <h3 className='text-primary mx-auto'>Document Verification</h3>

                        </div>
                        {
                            formData && formData.map((obj, index) => (


                                <div className="col-12 my-2 formbg py-3 rounded shadow">
                                    <form>
                                        <div className=' flex items-center justify-between px-3'>
                                            <h4> Company {index + 1} </h4>
                                            {
                                                index > 0 &&
                                                <button onClick={() => setFormData((prev) => prev.filter((o, i) => i != index))} type='button' className=''>
                                                    <CloseButton />
                                                </button>
                                            }
                                        </div>
                                        <div className="row m-0 border-bottom  pb-2 mt-2" style={{ lineHeight: '40px' }}>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="candidateID" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Candidate ID <span className='text-red-600'>* </span> </label>
                                                <input type="text" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="candidateID" name="CandidateID" value={id} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="lastName" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Name <span className='text-red-600'>* </span> </label>
                                                <input type="text" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='Ganesh' id="lastName" name="Name" value={obj.Name} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="email" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Previous Company <span className='text-red-600'>* </span> </label>
                                                <input type="text" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    id="email" placeholder='Merida Pvt.LTD'
                                                    name="Provious_Company" value={obj.Provious_Company} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="primaryContact" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Previous Designation <span className='text-red-600'>* </span> </label>
                                                <input type="text" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md  duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='Web Developer' id="primaryContact" name="Provious_Designation" value={obj.Provious_Designation}
                                                    onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="secondaryContact" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Experience <span className='text-red-600'>* </span> </label>
                                                <input type="number" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md  duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='Exp. in years' id="secondaryContact" name="experience" value={obj.experience}
                                                    onChange={(e) => { if (e.target.value >= 0) { handleChange(e, index) } }} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="fromDate" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">From Date <span className='text-red-600'>* </span> </label>
                                                <input type="date" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='Joining date ' id="fromDate" name="from_date" value={obj.from_date} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="toDate" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">To Date <span className='text-red-600'>* </span> </label>
                                                <input type="date" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    id="toDate" name="To_date" value={obj.To_date} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="currentCTC" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Current CTC <span className='text-red-600'>* </span> </label>
                                                <input type="number" placeholder='500000' className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="currentCTC" name="Current_CTC"
                                                    value={obj.Current_CTC} onChange={(e) => { if (e.target.value >= 0) { handleChange(e, index) } }} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="managerName" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Reporting Manager Name <span className='text-red-600'>* </span> </label>
                                                <input type="text" placeholder='Maadhavan' className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="managerName"
                                                    name="Reporting_Manager_name" value={obj.Reporting_Manager_name} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="managerEmail" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Reporting Manager Email <span className='text-red-600'>* </span> </label>
                                                <input type="text" placeholder='madhav@mail.com' className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="managerEmail"
                                                    name="Reporting_Manager_email" value={obj.Reporting_Manager_email} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="managerPhone" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Reporting Manager Phone <span className='text-red-600'>* </span> </label>
                                                <input type="text" placeholder='9878548***' className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="managerPhone"
                                                    name="ReportingManager_phone"
                                                    value={obj.ReportingManager_phone} onChange={(e) => { if (e.target.value >= 0) { handleChange(e, index) } }} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="hrName" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">HR Name <span className='text-red-600'>* </span> </label>
                                                <input type="text" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='Hari' id="hrName" name="HR_name" value={obj.HR_name} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="hrEmail" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">HR Email <span className='text-red-600'>* </span> </label>
                                                <input type="email" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md   duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='hrd@xxyy.com' id="hrEmail" name="HR_email" value={obj.HR_email} onChange={(e) => handleChange(e, index)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="hrPhone" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">HR Phone <span className='text-red-600'>* </span> </label>
                                                <input type="number" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr"
                                                    placeholder='987867****' id="hrPhone" name="HR_phone" value={obj.HR_phone}
                                                    onChange={(e) => { if (e.target.value >= 0) { handleChange(e, index) } }} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="hrPhone" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Document Upload <span className='text-red-600'>* </span> </label>
                                                <input type="file" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="hrPhone"
                                                    name="Document" onChange={(e) => handleChange(e, index)} />
                                            </div>

                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="hrPhone" className="form-label text-slate-500 fw-semibold poppins text-sm text-opacity-80 ">Salary Drawn Payslips <span className='text-red-600'>* </span> </label>
                                                <input type="file" className="block p-2 rounded-xl py-3 w-full focus-within:shadow-md    duration-500 focus-within:shadow-violet-300 text-sm outline-none bgclr" id="hrPhone"
                                                    name={"Salary_Drawn_Payslips"} onChange={(e) => handleChange(e, index)} />
                                            </div>

                                        </div>

                                    </form>

                                </div>
                            ))
                        }
                        <div className="col-12 text-end mt-3">
                            <button onClick={() =>
                                setFormData((prev) => [...prev, {
                                    CandidateID: id,
                                    Name: "",
                                    Provious_Company: "",
                                    Provious_Designation: "",
                                    experience: "",
                                    from_date: "",
                                    To_date: "",
                                    Current_CTC: "",
                                    Reporting_Manager_name: "",
                                    Reporting_Manager_email: "",
                                    ReportingManager_phone: "",
                                    HR_name: "",
                                    HR_email: "",
                                    HR_phone: "",
                                    Salary_Drawn_Payslips: null,
                                    Document: null,
                                }])} className='btn btn-secondary text-white fw-medium px-2 px-lg-5 mx-2'>
                                Add </button>
                            <button onClick={handleSubmit} disabled={loading}
                                className="btn btn-primary text-white fw-medium px-2 px-lg-5">{loading ? 'loading...' : "Submit"}</button>
                        </div>
                    </div>

                </div>}
        </div>
    );
};

export default Dummydoc;
