import React, { useState } from 'react';

const Leaveapplyform = () => {
    const [Employee_Id, setEmployee_Id] = useState("");
    const [Name, setName] = useState("");
    const [phone, setphone] = useState("");
    const [email, setemail] = useState("");
    const [Reporting_manager, setReporting_manager] = useState("");
    const [Employee_type, setEmployee_type] = useState("");
    const [LeaveType, setLeaveType] = useState("");
    const [FromDate, setFromDate] = useState("");
    const [ToDate, setToDate] = useState("");
    const [Days, setDays] = useState("");
    const [Reason, setReason] = useState("");
    const [Any_proof, setAny_proof] = useState("");

    const handle_Leave_apply_form = (e) => {
        e.preventDefault();

        // Convert input date strings to Date objects
        const fromDateObj = new Date(FromDate);
        const toDateObj = new Date(ToDate);

        // Calculate the difference in milliseconds
        const differenceInTime = toDateObj.getTime() - fromDateObj.getTime();

        // Convert milliseconds to days
        const differenceInDays = differenceInTime / (1000 * 3600 * 24);

        // Set the calculated days
        setDays(differenceInDays);

        // Other form submission logic can follow
        alert("leave Form");

        const formData1 = new FormData();
        formData1.append('Employee_Id', Employee_Id);
        formData1.append('Name', Name);
        formData1.append('phone', phone);
        formData1.append('email', email);
        formData1.append('Reporting_manager', Reporting_manager);
        formData1.append('Employee_type', Employee_type);
        formData1.append('LeaveType', LeaveType);
        formData1.append('FromDate', FromDate);
        formData1.append('ToDate', ToDate);
        formData1.append('Days', differenceInDays); // Here we are sending the calculated difference
        formData1.append('Reason', Reason);
        formData1.append('Any_proof', Any_proof);

        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
    };

    return (
        <div>
            {/* LEAVE APPLY START */}
            <div>
                <form>
                    {/* Form start */}
                    <div className="row justify-content-center m-0">
                        <h3 className='mt-2 text-center p-3' style={{ color: 'rgb(76,53,117)' }}>Leave Apply form</h3>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg">
                            <div className="row m-0 pb-2" style={{ lineHeight: '30px' }}>
                                {/* Form fields */}
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Employee_Id* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Employee_Id} onChange={(e) => setEmployee_Id(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Name* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Name} onChange={(e) => setName(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="lastName" className="form-label">phone*</label>
                                    <input type="tel" className="form-control shadow-none" value={phone} onChange={(e) => setphone(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="email" className="form-label">email*</label>
                                    <input type="email" className="form-control shadow-none" value={email} onChange={(e) => setemail(e.target.value)} id="Email" name="Email" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label"> Reporting manager*</label>
                                    <input type="text" className="form-control shadow-none" value={Reporting_manager} onChange={(e) => setReporting_manager(e.target.value)} id="State" name="State" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="ageGroup" className="form-label"> Employee type*</label>
                                    <select className="form-select" id="ageGroup" value={Employee_type} onChange={(e) => setEmployee_type(e.target.value)}>
                                        <option value="">Select</option>
                                        <option value="yes">Yes</option>
                                        <option value="no">No</option>
                                    </select>
                                </div>


                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="ageGroup" className="form-label">  LeaveType*</label>
                                    <select className="form-select" id="ageGroup" value={LeaveType} onChange={(e) => setLeaveType(e.target.value)}>
                                        <option value="">Select</option>
                                        <option value="yes">Yes</option>
                                        <option value="no">No</option>
                                    </select>
                                </div>

                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">FromDate*</label>
                                    <input type="date" className="form-control shadow-none" value={FromDate} onChange={(e) => setFromDate(e.target.value)} id="State" name="State" />
                                </div>
                                <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">ToDate*</label>
                                    <input type="date" className="form-control shadow-none" value={ToDate} onChange={(e) => setToDate(e.target.value)} id="State" name="State" />
                                </div>
                                <div className="col-md-6 col-lg-2 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Days</label>
                                    <input type="number" className="form-control shadow-none" value={Days} id="State" name="State" readOnly />
                                </div>
                                {/* Additional form fields */}
                                {/* Add additional form fields here */}
                                <div className="col-md-6 col-lg-12 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Reason*</label>
                                    <textarea type="email" className="form-control shadow-none" style={{ height: '80px' }} value={Reason} onChange={(e) => setReason(e.target.value)} id="State" name="State" />
                                </div>
                                <div className="col-md-6 col-lg-6 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Any proof*</label>
                                    <input type="email" className="form-control shadow-none" value={Any_proof} onChange={(e) => setAny_proof(e.target.value)} id="State" name="State" />
                                </div>
                            </div>
                        </div>
                    </div>
                    {/* form end */}
                    {/* Button start */}
                    <div className="d-flex justify-content-end mt-2">
                        <div className='d-flex gap-2 p-3'>
                            <button type="submit" className="btn btn-success btn-sm" onClick={handle_Leave_apply_form}>Submit</button>
                        </div>
                    </div>
                    {/* Button end */}
                </form>
            </div>
            {/* LEAVE APPLY END */}
        </div>
    );
};

export default Leaveapplyform;
