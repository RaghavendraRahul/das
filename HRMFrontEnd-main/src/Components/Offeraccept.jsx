import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { domain, port } from '../App'
import { toast } from 'react-toastify';


const Offeraccept = () => {
    const { id } = useParams();
    let [response, setresponseSubmited] = useState(false)
    let [seconds, setseconds] = useState(5)
    const [JoingDate, setJoingDate] = useState([])
    {
        JoingDate.map((e) => {
            console.log("map", e.Date_of_Joining);
        })
    }
    useEffect(() => {
        const currentDate = new Date().toISOString().slice(0, 10); // Get current date in "YYYY-MM-DD" format
        // console.log("currentDate", currentDate);
        // console.log(JoingDate);
        if (JoingDate) {
            JoingDate.map((e, index) => {
                // console.log(e.Date_of_Joining);
                if (e.Date_of_Joining == currentDate && !e.Mail_Status) {

                    const formData = new FormData();
                    formData.append('CandidateId', e.CandidateId);
                    formData.append('FormURL', `${domain}/Employeeallform/`);

                    axios.post(`${port}/root/JoiningAppointmentMail`, formData).then((res) => {
                        console.log(res);
                    })
                    console.log("Date matched! Calling API..." + index);
                } else {

                    console.log("Date does not match. No API call needed." + index);
                }
            });
        }
    }, [JoingDate])

    const checkDateAndCallAPI = () => {
        const currentDate = new Date().toISOString().slice(0, 10);

        JoingDate.map((e, index) => {

            if (e.Date_of_Joining == currentDate && !e.Mail_Status) {
                const formData = new FormData();
                formData.append('CandidateId', e.CandidateId);
                formData.append('FormURL', `${domain}/Employeeallform/`);

                axios.post(`${port}/root/JoiningAppointmentMail`, formData).then((res) => {
                    console.log(res);
                })
                console.log("Date matched! Calling API..." + index);
            } else {

                console.log("Date does not match. No API call needed." + index);
            }
        });
    };


    // console.log("JoingDate", JoingDate);

    const [modalOpen, setModalOpen] = useState(false);

    const [comments, setComments] = useState('');
    const [acceptance, setAcceptance] = useState(''); // null means no action taken yet

    useEffect(() => {
        checkDateAndCallAPI();
        setModalOpen(true); // Open the modal when the component mounts
    }, []); // Empty dependency array ensures this effect runs only once
    let getReportStatus = () => {
        axios.get(`${port}/root/OfferAcceptStatus/${id}/`).then((response) => {
            console.log(response.data.message);
            setresponseSubmited(response.data.message == 'Completed')
        }).catch((error) => {
            console.log(error);
        })
    }
    const handleAccept = (e) => {
        const formData = new FormData();
        formData.append('remarks', comments);
        formData.append('Status', e);
        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        axios.post(`${port}/root/OfferAcceptStatus/${id}/`, formData)
            .then((res) => {
                console.log("Offer_Accepted_res", res.data);
                setJoingDate(res.data)
                toast.success('Offer Accepted')
                getReportStatus()
            }).catch((err) => {
                console.log("Offer_Accepted_err", err.data);
            })

    };

    const handleNotAccept = (e) => {
        const formData = new FormData();
        formData.append('remarks', comments);
        formData.append('Status', e);
        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        axios.post(`${port}/root/OfferAcceptStatus/${id}/`, formData)
            .then((res) => {
                console.log("Offer_Accepted_res", res.data);
                toast.success('Offer Not Accepted')
                getReportStatus()
            }).catch((err) => {
                console.log("Offer_Accepted_err", err.data);
            })
    };

    useEffect(() => {
        getReportStatus()
    }, [])
    return (
        <div>
            {modalOpen && (
                <div className="modal fade show" tabIndex="-1" role="dialog" style={{ display: 'block' }}>
                    <div className="modal-dialog modal-dialog-centered  " role="document">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h4 className="text-center">Job Acceptance Letter</h4>
                                {/* <button type="button" className="btn-close"
                                    onClick={() => setModalOpen(false)} aria-label="Close"></button> */}
                            </div>
                            <div className="modal-body">
                                <div>
                                    {!response ? <div className='d-flex justify-content-center flex-column p-2'>
                                        <small>Your Comments</small>
                                        <div className='mt-3 p-2'>
                                            <textarea
                                                name=""
                                                id=""
                                                className='w-100 bgclr rounded outline-none p-2 '
                                                style={{ minHeight: '100px' }}
                                                value={comments}
                                                onChange={(e) => setComments(e.target.value)}
                                            >
                                            </textarea>
                                        </div>

                                    </div> :
                                        <section>
                                            <p className='text-center'>Response has been submitted !!! </p>
                                        </section>
                                    }
                                </div>
                            </div>
                            {!response && <div className="modal-footer">
                                <div className='d-flex justify-content-evenly'>
                                    <button disabled={!comments} className='btn btn-success me-2 ' onClick={() => handleAccept('Accept')} aria-label="Close">Accept</button>
                                    <button disabled={!comments} className='btn btn-danger' onClick={() => handleNotAccept('Reject')} aria-label="Close">Not Accept</button>
                                </div>
                            </div>}
                        </div>
                    </div>
                </div>
            )}
            {modalOpen && <div className="modal-backdrop fade show"></div>}
            {/* <div>
                <button  onClick={() => checkDateAndCallAPI()}>click</button>
            </div> */}
        </div>
    );
};

export default Offeraccept;
