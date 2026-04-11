import React, { useState } from 'react';

const Performance_metrics = () => {
    const [Employee_Id, setEmployee_Id] = useState("");
    const [Metric_Name, setMetric_Name] = useState("");
    const [Descriptiont, setDescriptiont] = useState("");
    const [Target_Goal, setTarget_Goal] = useState("");
    const [Performance_Achived_Status, setPerformance_Achived_Status] = useState("");
    const [Performance_Rating, setPerformance_Rating] = useState("");
    const [Achived_Date, setAchived_Date] = useState("");
    const [Goals_for_Next_Period, setGoals_for_Next_Period] = useState("");
    const [Comments_Feedback, setComments_Feedback] = useState("");


    const handle_Performance_metrics_form = (e) => {
        e.preventDefault();



        const formData1 = new FormData();
        formData1.append('Employee_Id', Employee_Id);
        formData1.append('Metric_Name', Metric_Name);
        formData1.append('Descriptiont', Descriptiont);
        formData1.append('Target_Goal', Target_Goal);
        formData1.append('Performance_Achived_Status', Performance_Achived_Status);
        formData1.append('Performance_Rating', Performance_Rating);
        formData1.append('Achived_Date', Achived_Date);
        formData1.append('Goals_for_Next_Period', Goals_for_Next_Period); 
        formData1.append('Comments_Feedback', Comments_Feedback); 


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
                        <h3 className='mt-2 text-center p-3' style={{ color: 'rgb(76,53,117)' }}>Performance Metrics Form</h3>
                        <div className="col-lg-12 p-4 mt-2 border rounded-lg">
                            <div className="row m-0 pb-2" style={{ lineHeight: '30px' }}>
                                {/* Form fields */}
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Employee_Id* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Employee_Id} onChange={(e) => setEmployee_Id(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="Name" className="form-label">Metric_Name* </label>
                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Metric_Name} onChange={(e) => setMetric_Name(e.target.value)} />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="lastName" className="form-label">Descriptiont*</label>
                                    <input type="text" className="form-control shadow-none" value={Descriptiont} onChange={(e) => setDescriptiont(e.target.value)} id="LastName" name="LastName" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="email" className="form-label">Target_Goal*</label>
                                    <input type="text" className="form-control shadow-none" value={Target_Goal} onChange={(e) => setTarget_Goal(e.target.value)} id="Email" name="Email" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Performance_Achived Status*</label>
                                    <input type="text" className="form-control shadow-none" value={Performance_Achived_Status} onChange={(e) => setPerformance_Achived_Status(e.target.value)} id="State" name="State" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Performance_Rating*</label>
                                    <input type="text" className="form-control shadow-none" value={Performance_Rating} onChange={(e) => setPerformance_Rating(e.target.value)} id="State" name="State" />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Achived_Date*</label>
                                    <input type="date" className="form-control shadow-none" value={Achived_Date} onChange={(e) => setAchived_Date(e.target.value)} id="State" name="State" />
                                </div>

                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Goals for Next Period</label>
                                    <input type="text" className="form-control shadow-none" value={Goals_for_Next_Period} onChange={(e) => setGoals_for_Next_Period(e.target.value)} id="State" name="State"  />
                                </div>
                                <div className="col-md-6 col-lg-4 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Comments_Feedback</label>
                                    <input type="text" className="form-control shadow-none" value={Comments_Feedback} onChange={(e) => setComments_Feedback(e.target.value)} id="State" name="State"  />
                                </div>

                            </div>
                        </div>
                    </div>
                    {/* form end */}
                    {/* Button start */}
                    <div className="d-flex justify-content-end mt-2">
                        <div className='d-flex gap-2 p-3'>
                            <button type="submit" className="btn btn-success btn-sm" onClick={handle_Performance_metrics_form}>Submit</button>
                        </div>
                    </div>
                    {/* Button end */}
                </form>
            </div>
            {/* LEAVE APPLY END */}
        </div>
    );
};

export default Performance_metrics;
