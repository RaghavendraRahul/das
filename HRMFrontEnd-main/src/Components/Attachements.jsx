import React, { useState } from 'react'


const Attachements = () => {

    
    // DOCUMENT UPLOAD START

    const [documentsupload, setdocumentsupload] = useState([]);
    const [file, setFile] = useState(null);

    const handleFileChange = (event) => {
        const selectedFile = event.target.files[0];
        setFile(selectedFile);
    };

    // const handleAddFile = () => {
    //     if (file) {
    //         const newDocument = {
    //             name: file.name,
    //             size: file.size,
    //             type: file.type,
    //             data: file,
    //         };
    //         setdocumentsupload([...documentsupload, newDocument]);
    //         setFile(null);
    //     } else {
    //         alert('Please select a file before adding!');
    //     }
    // };

    const handleAddFile = () => {
        if (file) {
            const reader = new FileReader();
            reader.onload = (event) => {
                const fileData = event.target.result;
                const newDocument = {
                    name: file.name,
                    size: file.size,
                    type: file.type,
                    data: fileData, // Store file data instead of the file object itself
                };
                setdocumentsupload([...documentsupload, newDocument]);
                setFile(null);
            };
            reader.readAsDataURL(file); // Read file data as base64 encoded string
        } else {
            alert('Please select a file before adding!');
        }
    };
    

    const handleRemoveFile = (e, index) => {
        e.preventDefault();

        const updatedDocuments = [...documentsupload];
        updatedDocuments.splice(index, 1);
        setdocumentsupload(updatedDocuments);
    };


    let handle_Attachments_Info = (e) => {
        e.preventDefault()

        alert("DOCUMENT UPLOAD")

        // console.log('Sending documents to API:', documentsupload);

        
        const formData = new FormData()

        formData.append('documents', documentsupload);

        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }


        

        setdocumentsupload([]);

    }

    // DOCUMENT UPLOAD END
    return (
        <div>
            {/* ATTACHMENTS START */}
            <div  >
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0 ">
                        <h3 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>ATTACHMENTS</h3>
                        <div className="col-lg-12 p-4 border rounded-lg ">
                            <div className="row m-0 pb-2">
                                <label htmlFor="Name" className="form-label fw-bold" style={{ color: 'rgb(76,53,115)' }}>Please attach : </label>

                                <div style={{ lineHeight: '40px' }}>
                                    <div>1. Photocopies of all relevant certificates / Degree mark sheets etc.</div>
                                    <div>2. Appointment / Offer letter form all your employes</div>
                                    <div>3. Relieving letter / Experience cerificate from all pervious employers</div>
                                    <div>4. Photocopy of address proof</div>
                                    <div>5. Photocopy of ID proof</div>
                                    <div>6. Passport size photograph</div>
                                </div>
                            </div>
                            {/* DOC UPLOAD START */}
                            <div className=" mt-4">
                                <div className="card rounded-0">
                                    <div className="card-body">
                                        <h3 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Select Your Files</h3>

                                        <div className="input-group mb-3">
                                            <input type="file" className="form-control shadow-none mt-3" onChange={handleFileChange} />
                                            <button className="btn btn-primary mt-3" style={{ height: '40px' }} type="button" onClick={handleAddFile}>Add File</button>
                                        </div>
                                        <div className='mt-3'>
                                            <h3 className='mt-4 heading' style={{ color: 'rgb(76,53,117)' }}>Documents :</h3>

                                            <ul className="list-group mt-3">
                                                {documentsupload.map((doc, index) => (
                                                    <li key={index} className="list-group-item">
                                                        {doc.name} - {doc.size} bytes - {doc.type}
                                                        <button className="btn btn-danger btn-sm ms-2" onClick={(e) => handleRemoveFile(index)}>Remove</button>


                                                    </li>
                                                ))}
                                            </ul>
                                        </div>
                                        {/* <button className="btn btn-success mt-3" onClick={handleSendToAPI}>Send to API</button> */}
                                    </div>
                                </div>
                            </div>
                            {/* DOC UPLOAD END */}

                        </div>
                    </div>

                    {/* form end */}
                    {/* Button start */}
                    <div class=" d-flex justify-content-end mt-2">

                        <div className='d-flex gap-2'>


                            <button type="submit" class="btn btn-success btn-sm" onClick={handle_Attachments_Info}  >Submit</button>

                            


                        </div>
                    </div>
                    {/* Button end */}

                </form>
            </div>
            {/* ATTACHMENTS END */}
        </div>
    )
}

export default Attachements