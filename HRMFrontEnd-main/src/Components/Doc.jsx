import React, { useState } from 'react';
import axios from 'axios';
import { Link, useParams } from 'react-router-dom';

const Doc = () => {
    const { id } = useParams();
    const [formData, setFormData] = useState({
        CandidateID: "",
        Name: "",
        Provious_Company: "",
        Provious_Designation: "",
        experience: "",
        from_date: "",
        to_date: "",
        Current_CTC: "",
        Reporting_Manager_name: "",
        Reporting_Manager_email: "",
        ReportingManager_phone: "",
        HR_email: "",
        HR_phone: "",
        Salary_Drawn_Payslips: null,
        Document: [{ documentName: '', documentFile: {} }],
    });

    const handleInputChange = (index, event) => {
        const { name, value, files } = event.target;
        const newDocuments = [...formData.Document];
        newDocuments[index][name] = name === 'documentFile' ? files[0] : value;
        setFormData({ ...formData, Document: newDocuments });
    };

    const handleAddFields = () => {
        // Check if there are any existing document fields
        if (formData.Document.length > 0) {
            // Add a new document field
            setFormData({
                ...formData,
                Document: [...formData.Document, { documentName: '', documentFile: null }],
            });
        } else {
            // Add the default document field
            setFormData({
                ...formData,
                Document: [{ documentName: '', documentFile: null }],
            });
        }
    };


    const handleSubmit = (e) => {
        e.preventDefault();
        const formdata = new FormData();
        
        // Append other form fields
        for (const key in formData) {
            if (key === 'Document') {
                formData.Document.forEach((docu, index) => {
                    formdata.append(`documents[${index}][documentName]`, docu.documentName);
                    // Check if files exist before accessing
                    if (docu.documentFile) {
                        formdata.append(`documents[${index}][documentFile]`, docu.documentFile);
                    }
                });
            } else {
                formdata.append(key, formData[key]);
            }
        }
        
        // Append the Salary Drawn Payslips file
        formdata.append('SalaryDrawnPayslips', formData.SalaryDrawnPayslips);
        
        // Logging form data
        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        
        axios.post(`http://192.168.0.110:9000/root/Documents_Upload_Data/${id}/`, formdata)
            .then((r) => {
                console.log("Candidate_reg_res", r.data);
                alert("Document Verification Successful");
            })
            .catch((err) => {
                console.log("Candidate _reg_Error", err);
            });
    };
    
    

    let logindata = JSON.parse(sessionStorage.getItem('user'))

    return (
        <div className='bg-info'>
            <div className='animate_animated animate_slideInUp bg-light'>
                <div className='container-fluid row m-0 pb-4 pt-3'>
                    <div className='mb-2 d-flex'>
                        <Link className='text-dark' to={`/dashboard/${logindata.Disgnation}`} >
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" className="bi bi-arrow-left" viewBox="0 0 16 16">
                                <path fillRule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                            </svg>
                        </Link>
                        <h3 className='text-primary mx-auto'>Document Verification</h3>
                    </div>
                    <div className="col-12 bg-white py-3 shadow">
                        <form onSubmit={handleSubmit}>
                            <div className="row m-0 border-bottom pb-2 mt-5">
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="candidateID" className="form-label">Candidate ID</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="candidateID" name="CandidateID" value={formData.CandidateID} onChange={(e) => setFormData({ ...formData, CandidateID: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="lastName" className="form-label">Name</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="lastName" name="Name" value={formData.Name} onChange={(e) => setFormData({ ...formData, Name: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="email" className="form-label">Previous Company</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="email" name="PreviousCompany" value={formData.Provious_Company} onChange={(e) => setFormData({ ...formData, Provious_Company: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="primaryContact" className="form-label">Previous Designation</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="primaryContact" name="PreviousDesignation" value={formData.Provious_Designation} onChange={(e) => setFormData({ ...formData, Provious_Designation: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Experience</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="secondaryContact" name="experience" value={formData.experience} onChange={(e) => setFormData({ ...formData, experience: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="fromDate" className="form-label">From Date</label>
                                    <input type="date" className="form-control shadow-none bg-light" id="fromDate" name="fromdate" value={formData.from_date} onChange={(e) => setFormData({ ...formData, from_date: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="toDate" className="form-label">To Date</label>
                                    <input type="date" className="form-control shadow-none bg-light" id="toDate" name="Todate" value={formData.to_date} onChange={(e) => setFormData({ ...formData, to_date: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="currentCTC" className="form-label">Current CTC</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="currentCTC" name="CurrentCTC" value={formData.Current_CTC} onChange={(e) => setFormData({ ...formData, Current_CTC: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="managerName" className="form-label">Reporting Manager Name</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="managerName" name="ReportingManagername" value={formData.Reporting_Manager_name} onChange={(e) => setFormData({ ...formData, Reporting_Manager_name: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="managerEmail" className="form-label">Reporting Manager Email</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="managerEmail" name="ReportingManageremail" value={formData.Reporting_Manager_email} onChange={(e) => setFormData({ ...formData, Reporting_Manager_email: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="managerPhone" className="form-label">Reporting Manager Phone</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="managerPhone" name="ReportingManagerphone" value={formData.ReportingManager_phone} onChange={(e) => setFormData({ ...formData, ReportingManager_phone: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="hrEmail" className="form-label">HR Email</label>
                                    <input type="email" className="form-control shadow-none bg-light" id="hrEmail" name="HRemail" value={formData.HR_email} onChange={(e) => setFormData({ ...formData, HR_email: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="hrPhone" className="form-label">HR Phone</label>
                                    <input type="text" className="form-control shadow-none bg-light" id="hrPhone" name="HRphone" value={formData.HR_phone} onChange={(e) => setFormData({ ...formData, HR_phone: e.target.value })} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    {formData.Document.map((doc, index) => (
                                        <div key={index}>
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor={`documentName_${index}`} className="form-label">Document name</label>
                                                <input
                                                    className="form-control shadow-none bg-light"
                                                    type="text"
                                                    placeholder=""
                                                    name="documentName"
                                                    value={doc.documentName}
                                                    onChange={(event) => handleInputChange(index, event)}
                                                />
                                            </div>
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor={`documentFile_${index}`} className="form-label">Document file</label>
                                                <input
                                                    className="form-control shadow-none bg-light"
                                                    type="file"
                                                    placeholder=""
                                                    name="documentFile"
                                                    onChange={(event) => handleInputChange(index, event)}
                                                />
                                            </div>
                                        </div>
                                    ))}
                                    <small onClick={handleAddFields} style={{ cursor: 'pointer' }}>Add More</small>
                                </div>
                                {/* Existing form fields */}
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="hrPhone" className="form-label">Salary Drawn Payslips</label>
                                    <input type="file" className="form-control shadow-none bg-light" id="hrPhone" name="SalaryDrawnPayslips" onChange={(e) => setFormData({ ...formData, SalaryDrawnPayslips: e.target.files[0] })} />
                                </div>
                                {/* Remaining form fields */}
                            </div>
                            <div className="col-12 text-end mt-3">
                                <button type="submit" className="btn btn-primary text-white fw-medium px-2 px-lg-5">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Doc;
