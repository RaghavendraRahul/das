import React, { useState } from 'react'
import axios from 'axios';
import { useEffect } from 'react';
import { Link } from 'react-router-dom';



const Docupload = () => {

    const [CandidateID, setCandidateID] = useState("")
    const [Name, setName] = useState("")
    const [ProviousCompany, setProviousCompany] = useState("")
    const [ProviousDesignation, setProviousDesignation] = useState("")
    const [experience, setexperience] = useState("")
    const [fromdate, setfromdate] = useState("")
    const [Todate, setTodate] = useState("")
    const [CurrentCTC, setCurrentCTC] = useState("")
    const [ReportingManagername, setReportingManagername] = useState("")
    const [ReportingManageremail, setReportingManageremail] = useState("")
    const [ReportingManagerphone, setReportingManagerphone] = useState("")
    const [HRemail, setHRemail] = useState("")
    const [HRphone, setHRphone] = useState("")
    const [documentfile, setdocumentfile] = useState("")
    const [SalaryDrawnPayslips, setSalaryDrawnPayslips] = useState("")

    const [inputs, setInputs] = useState([{ field1: '', field2: null }]);

    const handleInputChange = (index, event) => {
        const { name, value, files } = event.target;
        const newInputs = [...inputs];
        if (name === 'field2') {
            newInputs[index][name] = files[0];
            console.log(files[0]) // Save the file object
        } else {
            newInputs[index][name] = value; // Save the value for other fields
        }
        setInputs(newInputs);
    };

    const handleAddFields1 = () => {
        setInputs([...inputs, { field1: '', field2: null }]);
    };


    let handleSubmit = (e) => {
        e.preventDefault();

        const formdata = new FormData()
        formdata.append('1', CandidateID);
        formdata.append('3', Name);
        formdata.append('4', ProviousCompany);
        formdata.append('5', ProviousDesignation);
        formdata.append('6', experience);
        formdata.append('7', Todate);
        formdata.append('8', CurrentCTC);
        formdata.append('9', ReportingManagername);
        formdata.append('10', ReportingManageremail);
        formdata.append('11', ReportingManagerphone);
        formdata.append('12', HRemail);
        formdata.append('13', HRphone);
        formdata.append('14', documentfile);
        formdata.append('15', SalaryDrawnPayslips);

        inputs.forEach((input, index) => {
            formdata.append(`DocumentName_${index}`, input.field1); // Assuming 'field1' is the name of the document
            formdata.append(`DocumentFile_${index}`, input.field2); // Assuming 'field2' is the file object of the document
        });

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        alert("Document Verification"); 
    }





    let logindata = JSON.parse(sessionStorage.getItem('user'))
    console.log(logindata);




    return (
        <div className='bg-info'>
            <div className='animate_animated animate_slideInUp bg-light'>
                <div className='container-fluid row m-0 pb-4 pt-3'>
                    <div className='mb-2 d-flex'>
                        <Link className='text-dark' to={`/dashboard/HR`} ><svg xmlns="http:www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                        </svg></Link>
                        <h3 className='text-primary mx-auto'>Document Verification</h3>
                    </div>
                    <div className="col-12 bg-white py-3 shadow">
                        <form onSubmit={handleSubmit}>
                            <div className="row m-0 border-bottom pb-2 mt-5">

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="firstName" className="form-label">Candidate ID</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="" name="" value={CandidateID} onChange={(e) => setCandidateID(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">Name</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" LastName" name=" LastName" value={Name} onChange={(e) => setName(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">Provious  Company</label>
                                    <input type="email" className="form-control shadow-none bg-light" id=" Email" name=" Email" value={ProviousCompany} onChange={(e) => setProviousCompany(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="primaryContact" className="form-label">Provious Designation</label>
                                    <input type="tel" className="form-control shadow-none bg-light" id="PrimaryContact" name="PrimaryContact" value={ProviousDesignation} onChange={(e) => setProviousDesignation(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">experience</label>
                                    <input type="tel" className="form-control shadow-none bg-light" id="SecondaryContact" name="SecondaryContact" value={experience} onChange={(e) => setexperience(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">from date</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="State" name="State" value={fromdate} onChange={(e) => setfromdate(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">To date</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={Todate} onChange={(e) => setTodate(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Current CTC</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={CurrentCTC} onChange={(e) => setCurrentCTC(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Reporting Manager name</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={ReportingManagername} onChange={(e) => setReportingManagername(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Reporting Manager email</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={ReportingManageremail} onChange={(e) => setReportingManageremail(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">ReportingManager phone</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={ReportingManagerphone} onChange={(e) => setReportingManagerphone(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">HR email</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={HRemail} onChange={(e) => setHRemail(e.target.value)} />
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">HR phone</label>
                                    <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={HRphone} onChange={(e) => setHRphone(e.target.value)} />
                                </div>


                                <div className="col-md-6 col-lg-3 mb-3">
                                    {inputs.map((input, index) => (
                                        <div key={index}>
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor={`documentName_${index}`} className="form-label">Document name</label>
                                                <input
                                                    className="form-control shadow-none bg-light"
                                                    type="text"
                                                    placeholder=""
                                                    name={`field1_${index}`}
                                                    // value={input.field1}
                                                    onChange={(event) => handleInputChange(index, event)}
                                                />
                                            </div>
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor={`documentFile_${index}`} className="form-label">Document file</label>
                                                <input
                                                    className="form-control shadow-none bg-light"
                                                    type="file"
                                                    placeholder=""
                                                    name={`field2_${index}`}
                                                    onChange={(event) => handleInputChange(index, event)}
                                                />
                                            </div>
                                        </div>
                                    ))}
                                    <small onClick={handleAddFields1} style={{ cursor: 'pointer' }}>Add More</small>
                                </div>
                              


                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Salary Drawn Payslips</label>
                                    <input type="file" className="form-control shadow-none bg-light" id=" District" name=" District" value={SalaryDrawnPayslips} onChange={(e) => setSalaryDrawnPayslips(e.target.value)} />
                                </div>

                            </div>

                            <div className="col-12 text-end mt-3">
                                <button type="submit" className="btn btn-primary text-white fw-medium px-2 px-lg-5">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>


        </div>
    )
}

export default Docupload