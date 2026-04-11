import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { useNavigate, useParams } from 'react-router-dom'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'

const OfferLetterFormPage = () => {
    let { id } = useParams()
    let [show, setshow] = useState(false)
    let navigate = useNavigate()
    let logindata = JSON.parse(sessionStorage.getItem('user'))
    let { designation, getDesignations } = useContext(HrmStore)
    let [formobj, setformobj] = useState({
        id: null,
        OfferId: null, //candidateid
        Name: null, //candidateName
        Email: null,
        Phone: null,
        DOB: null,
        position: null,
        Date_of_Joining: null,
        Designation: null,
        Employeement_Type: null,
        probation_Duration_From: null,
        probation_Duration_To: null,
        WorkLocation: null,
        CTC: null,
        internship_Duration_From: null,
        internship_Duration_To: null,
        probation_status: null,
        notice_period: null,
        offer_expire: null,
        contact_info: null
    })
    let handleFormobj = (e) => {
        let { name, value } = e.target
        if (name == 'Date_of_Joining' && formobj.Employeement_Type == 'intern') {
            setformobj((prev) => ({
                ...prev,
                internship_Duration_From: value,
                probation_Duration_From: null,
                probation_Duration_To: null
            }))
        }
        else if (name == 'Date_of_Joining' && formobj.probation_status == 'probationer') {
            setformobj((prev) => ({
                ...prev,
                probation_Duration_From: value,
                internship_Duration_From: null,
                internship_Duration_To: null
            }))
        }
        else if (name == 'probation_status' && value == 'probationer' &&
            formobj.Date_of_Joining) {
            setformobj((prev) => ({
                ...prev,
                probation_Duration_From: formobj.Date_of_Joining,
                internship_Duration_From: null,
                internship_Duration_To: null
            }))
        }
        else if (name == 'Employeement_Type' && value == 'intern' &&
            formobj.Date_of_Joining) {
            setformobj((prev) => ({
                ...prev,
                internship_Duration_From: formobj.Date_of_Joining,
                probation_Duration_From: null,
                probation_status: null,
                probation_Duration_To: null
            }))
        }
        setformobj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let submitForm = (e) => {
        e.preventDefault()
        axios.post(`${port}/root/Offerletter/${id}/`, {
            ...formobj,
            letter_prepared_by: logindata.EmployeeId,
            letter_prepared_date: new Date()
        }).then((response) => {
            console.log(response.data);
            getCandidate()
            toast.success('Offer template generated')

        }).catch((error) => {
            console.log(error);
            toast.error('Error acquired')
        })
    }
    let updateSubmit = (e) => {
        e.preventDefault()
        delete formobj.PDF_File
        delete formobj.CandidateId
        delete formobj.letter_verified_by
        delete formobj.letter_prepared_by
        console.log(formobj);   
        axios.patch(`${port}/root/OfferLetterDetails/${formobj.id}/`, formobj).then((response) => {
            console.log(response.data);
            getCandidate()
            toast.success('Update is successfull')
        }).catch((error) => {
            console.log(error);
            toast.error('Error acquired ')
        })
    }
    let getCandidate = () => {
        axios.get(`${port}/root/Offerletter/${id}/`).then((response) => {
            console.log(response.data);
            if (response.data.offer_instance) {
                setshow(true)
                console.log(response.data.offer_instance,'offer');
                setformobj(response.data.offer_instance)
                setformobj((prev) => ({
                    ...prev,
                    Designation: response.data.AppliedDesignation
                }))
            }
            else {
                setformobj((prev) => ({
                    ...prev,
                    Name: response.data.FirstName,
                    Email: response.data.Email,
                    Designation: response.data.AppliedDesignation,
                    DOB: response.data.DOB,
                }))
            }

        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getDesignations()
        if (id) {
            getCandidate()
        }
    }, [id])
    return (
        <div>
            <Modal show={true} fullscreen  >
                <Modal.Body>
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel11">Offer Letter</h1>
                        <button type="button" class="btn-close" onClick={() => navigate(`/dashboard/${logindata.Disgnation}`)} ></button>
                    </div>
                    <div class="modal-body">
                        <div className="col-12 formbg rounded py-3 shadow">
                            <form className=' '>
                                <div className="row poppins m-0 border-bottom pb-2 mt-2" style={{ lineHeight: '50px' }}>
                                    <div class=" col-md-6 col-lg-4 mb-3">
                                        <label for="Name">Full Name :</label>
                                        <input type="text" id="Name" name="Name"
                                            onChange={handleFormobj}  placeholder={`Enter the candidate's full name`}
                                            className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            required value={formobj.Name} />
                                    </div>
                                    <div class=" col-md-6 col-lg-4 mb-3">
                                        <label for="Email">Email ID:</label>
                                        <input type="email" id="Email" name="Email" onChange={handleFormobj} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.Email} />
                                    </div>
                                    {/* <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="Phone">Phone :</label>
                                                <input type="tel" id="Phone" name="Phone" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={offer_letter_Phone} />
                                            </div> 
                                    */}
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate">Position Applied For</label>
                                        <input type="text" id="Offerddate" name="position" onChange={handleFormobj} required
                                         className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.Designation} />
                                    </div>
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate">Assigned Position </label>
                                        <select type="text" id="Offerddate" name="position" onChange={handleFormobj} required
                                            className='bgclr     p-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.position} >
                                            <option value="">Select</option>
                                            {designation && designation.map((val) => (
                                                <option value={val.id}>{val.Name} </option>
                                            ))

                                            }


                                        </select>
                                    </div>
                                    <div class=" col-md-6 col-lg-4 mb-3">
                                        <label for="DOB">Date of Birth (DOB) :</label>
                                        <input type="date" id="DOB" name="DOB" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.DOB} onChange={handleFormobj} />
                                    </div>

                                    {/* <div class=" col-md-6 col-lg-3 mb-3">
                                            <label for="Designation">Designation :</label>
                                            <input type="text" id="Designation" name="Designation" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={designation} onChange={(e) => setDesignation(e.target.value)} />
                                        </div> */}
                                    <div class=" col-md-6 col-lg-4 mb-3">
                                        <label for="Ctc">Salary (CTC) :</label>
                                        <input type="number" id="Ctc" placeholder='CTC in LPA , stippend in month basis' name="CTC" required
                                            className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.CTC} onChange={handleFormobj} />
                                    </div>

                                    <div class=" col-md-6 col-lg-4 mb-3">
                                        <label for="Workloc">Work Location :</label>
                                        <input type="text" id="Workloc" name="WorkLocation" placeholder='4th Block , Jayanagar, Bengaluru' required
                                            className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.WorkLocation} onChange={handleFormobj} />
                                    </div>

                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate">Joining Date :</label>
                                        <input type="date" id="Offerddate" name="Date_of_Joining" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.Date_of_Joining} onChange={handleFormobj} />
                                    </div>
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate"> Offer Acceptance Deadline :</label>
                                        <input type="date" id="" name="offer_expire"
                                            required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.offer_expire} onChange={handleFormobj} />
                                    </div>
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate">HR Contact Information :</label>
                                        <input type="text" id="" name="contact_info" placeholder={`Add HR's phone or alternate email for queries `}
                                            required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.contact_info} onChange={handleFormobj} />
                                    </div>
                                    {/* <div class="col-md-6 col-lg-4 mb-3">
                                        <label for="Offerddate">Notice Period :</label>
                                        <input type="number" id="Offerddate" name="notice_period" required
                                            className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                            value={formobj.notice_period} onChange={handleFormobj} />
                                    </div> */}



                                    <div className="col-md-6 col-lg-4 ">
                                        <label htmlFor="Name" className="">Employment Type*</label>
                                        <select
                                            className="bgclr px-2 py-3 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none  "
                                            id="ageGroup"
                                            name='Employeement_Type'
                                            value={formobj.Employeement_Type}
                                            onChange={handleFormobj}
                                        >
                                            <option value="">Select</option>
                                            <option value="intern">Intern</option>
                                            <option value="permanent">Permanent</option>
                                        </select>
                                    </div>

                                    {formobj.Employeement_Type === "intern" && (
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Offerddate">Internship Duration:</label>
                                            <div className="d-flex justify-content-evenly me-5">
                                                <p>
                                                    From Date
                                                    <input
                                                        type="date"
                                                        id="Offerddate"
                                                        name="internship_Duration_From"
                                                        required
                                                        className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                        value={formobj.internship_Duration_From}
                                                        onChange={handleFormobj}
                                                    />
                                                </p>
                                                <p>
                                                    To Date
                                                    <input
                                                        type="date"
                                                        id="Offerddate"
                                                        name="internship_Duration_To"
                                                        required
                                                        className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                        value={formobj.internship_Duration_To}
                                                        onChange={handleFormobj}
                                                    />
                                                </p>
                                            </div>
                                        </div>
                                    )}

                                    {formobj.Employeement_Type === "permanent" && (
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Under Probation*</label>
                                            <select
                                                className="bgclr p-2 py-3 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                id="ageGroup"
                                                name='probation_status'
                                                value={formobj.probation_status}
                                                onChange={handleFormobj}>
                                                <option value="">Select</option>
                                                <option value="probationer">probationer</option>
                                                <option value="confirmed">Confirmed</option>
                                            </select>
                                        </div>
                                    )}

                                    {formobj.probation_status === "probationer" && (
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Offerddate">Probation Duration:</label>
                                            <div className="d-flex justify-content-evenly me-5">
                                                <p>
                                                    From Date
                                                    <input
                                                        type="date"
                                                        id="Offerddate"
                                                        name="probation_Duration_From"
                                                        required
                                                        className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                        value={formobj.probation_Duration_From}
                                                        onChange={handleFormobj}
                                                    />
                                                </p>
                                                <p>
                                                    To Date
                                                    <input
                                                        type="date"
                                                        id="Offerddate"
                                                        name="probation_Duration_To"
                                                        required
                                                        className="bgclr px-2  focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                        value={formobj.probation_Duration_To}
                                                        onChange={handleFormobj}
                                                    />
                                                </p>
                                            </div>
                                        </div>
                                    )}

                                </div>

                                <div class="col-md-6 col-lg-12 px-3 d-flex  justify-content-end ">

                                    {!show &&
                                        <button onClick={submitForm} type='button'
                                            className='savebtn px-3 text-white p-2 border-2 border-green-100 rounded '>
                                            Save
                                        </button>
                                    }
                                    {
                                        show && <button onClick={() => navigate(`/candidateOfferLetter/${id}`)}
                                            className='bg-slate-500 text-white rounded p-2 '>Show Template </button>
                                    }
                                    {show && <button onClick={updateSubmit} className='p-2 rounded bg-blue-600 text-white mx-2 '>
                                        update
                                    </button>}
                                </div>

                            </form>
                        </div>

                    </div>
                </Modal.Body>

            </Modal>
        </div >
    )
}

export default OfferLetterFormPage