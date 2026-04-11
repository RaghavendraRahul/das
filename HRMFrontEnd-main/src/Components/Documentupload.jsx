import React, { useState } from 'react';
import { useParams } from 'react-router-dom';

const Documentupload = () => {
    const { id, login } = useParams();

    const [DocumentUpload, setDocumentUpload] = useState(null);
    const [SalaryDrawnPayslips, setSalaryDrawnPayslips] = useState(null);
    const [uploadedFiles, setUploadedFiles] = useState([]);

    const handleSubmit = (e) => {
        e.preventDefault();
        const formdata = new FormData();

        formdata.append('Document', DocumentUpload);
        formdata.append('Salary_Drawn_Payslips', SalaryDrawnPayslips);

        // Logging form data
        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        // Update uploaded files state
        setUploadedFiles([...uploadedFiles, ...formdata.getAll('Document'), ...formdata.getAll('Salary_Drawn_Payslips')]);
    };

    let logindata = JSON.parse(sessionStorage.getItem('user'));

    return (
        <div className='bg-info'>
            <div className='animate_animated animate_slideInUp bg-light'>
                <div className='container-fluid row m-0 pb-4 pt-3'>
                    <div className='mb-2 d-flex'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" className="bi bi-arrow-left" viewBox="0 0 16 16">
                            <path fillRule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                        </svg>
                        <h3 className='text-primary mx-auto'>Document Verification</h3>
                    </div>
                    <div className="col-12 bg-white py-3 shadow">
                        <form onSubmit={handleSubmit}>
                            <div className="row m-0 border-bottom pb-2 mt-5" style={{ lineHeight: '40px' }}>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="documentUpload" className="form-label">Document Upload</label>
                                    <input type="file" className="form-control shadow-none bg-light" id="documentUpload" name="DocumentUpload" onChange={(e) => setDocumentUpload(e.target.files)} />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="salaryDrawnPayslips" className="form-label">Salary Drawn Payslips</label>
                                    <input type="file" className="form-control shadow-none bg-light" id="salaryDrawnPayslips" name="SalaryDrawnPayslips" onChange={(e) => setSalaryDrawnPayslips(e.target.files)} />
                                </div>
                            </div>
                            <div className="col-12 text-end mt-3">
                                <button type="submit" className="btn btn-primary text-white fw-medium px-2 px-lg-5">Submit</button>
                            </div>
                        </form>
                
                        {/* {uploadedFiles.length > 0 && (
                            <div className="mt-4">
                                <h5>Uploaded Files:</h5>
                                <ul>
                                    {uploadedFiles.map((file, index) => (
                                        <li key={index}>{file.name}</li>
                                    ))}
                                </ul>
                            </div>
                        )} */}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Documentupload;
