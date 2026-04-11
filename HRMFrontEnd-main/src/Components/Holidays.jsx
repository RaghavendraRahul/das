import React, { useState } from 'react';

const Holidays = () => {
    const [occation, setoccation] = useState("");
    const [date,setdate ] = useState("");
    const [day,setday ] = useState("");
    const [state, setstate] = useState("");

   

    const handle_Leave_apply_form = (e) => {
        e.preventDefault();

    
        alert("leave Form");

        const formData1 = new FormData();
        formData1.append('occation',occation );
        formData1.append('date', date);
        formData1.append('day',day );
        formData1.append('state',state );
      
      

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
                        <h3 className='mt-2 text-center p-3' style={{ color: 'rgb(76,53,117)' }}>Holidays form</h3>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg">
                            <div className="row m-0 pb-2" style={{ lineHeight: '30px' }}>
                                {/* Form fields */}
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">occation* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={occation} onChange={(e) => setoccation(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">date* </label>
                                    <input type="date" className="form-control shadow-none" id="Name" name="Name" value={date} onChange={(e) => setdate(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="lastName" className="form-label">day*</label>
                                    <input type="text" className="form-control shadow-none" value={day} onChange={(e) => setday(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="email" className="form-label">state*</label>
                                    <input type="text" className="form-control shadow-none" value={state} onChange={(e) => setstate(e.target.value)} id="Email" name="Email" />
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

export default Holidays;
