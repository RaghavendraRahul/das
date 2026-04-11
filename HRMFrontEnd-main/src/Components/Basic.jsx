import React, { useContext, useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Chart as ChartJS } from "chart.js/auto";
import '../assets/css/fonts.css'
import Slider from "react-slick";
import '../assets/css/media.css'
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { domain, port } from '../App'
import '../assets/css/main.css'







const Basic = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId


    const navigate = useNavigate()
    var settings1 = {
        arrows: false,
        infinite: true,
        speed: 900,
        slidesToShow: 4,
        autoplay: true,
        speed: 1000,
        responsive: [
            {
                breakpoint: 1190,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 3,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 800,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 3,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                    initialSlide: 2
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    };

    const data = {
        labels: ['Label1', 'Label2', 'Label3'],
        datasets: [
            {
                label: '',
                data: [20, 50, 20, 10, 30],
                fill: false,
                backgroundColor: 'rgb(51,153,255)',
                tension: 0.1,
                barThickness: 10,

            },
            {
                label: '',
                data: [40, 20, 20, 10, 30],
                fill: false,
                backgroundColor: 'rgb(255,173,51)',
                tension: 0.1,
                barThickness: 10,
            },
            {
                label: '',
                data: [40, 30, 20, 10, 30],
                fill: false,
                backgroundColor: 'rgb(255,119,119)',
                tension: 0.1,
                barThickness: 10,
            }

        ],
    }
    const data1 = {
        labels: ['Market', 'It', 'Sales', 'Recruiment'],
        datasets: [
            {
                label: '',
                data: [25, 35, 40, 20],
                fill: false,
                backgroundColor: ['rgb(51,153,255)', 'rgb(139,207,255)', 'rgb(245,85,141)', 'rgb(241,152,40)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }
    const data2 = {
        labels: ['Label1', 'Label2', 'Label3', 'Label4', 'Label5'],
        datasets: [
            {
                label: 'item1',
                data: [20, 40, 90, 40, 80],
                fill: false,
                backgroundColor: 'rgb(245,85,141)',
                tension: 0.1,
                barThickness: 10,

            }


        ],
    }
    const data3 = {
        labels: ['item1', 'item2',],
        datasets: [
            {
                label: '',
                data: [25, 35, 40],
                fill: false,
                backgroundColor: ['rgb(51,153,200)', 'rgb(139,150,255)', 'rgb(240,85,141)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }

    // Logout


    // const [CanditateDetails, setCanditateDetails] = useEffect([]);

    useEffect(() => {
        // axios.get(`${port}/root/FinalCanditatesList`).then((res) => {
        //     console.log("CanditatesList", res.data);

        // }).catch((err) => {
        //     console.log(err.data);
        // })

        fetchCandidates("All Applicants", 1);

    }, [])

    const [persondata, setPersondata] = useState({})

    const [Candidateid, setCandidate] = useState("")

    const handleInputChange2 = (e) => {
        const { name, value } = e.target;
        setUpdocdata({ ...updocData, [name]: value });
    };

    const [updocData, setUpdocdata] = useState({
        CandidateId: '',
        CandidateName: '',
        CandidateNameEmail: '',
        CandidatePhone: '',
        CandidateDesignation: '',

    });


    const HandleDocupload = async (e) => {

        updocData.CandidateId = Candidateid
        e.preventDefault();
        console.log(updocData);

    };

    const [AllDesignations, setAllDesignations] = useState([]);

    useEffect(() => {

        axios.get(`${port}/root/AllDesignations`).then((res) => {

            console.log("AllDesignations", res.data);
            setAllDesignations(res.data)

        }).catch((err) => {
            console.log("AllDesignations", err.data);
        })

    }, [])

    const [offerName, setOfferName] = useState('');
    const [email, setemail] = useState('');
    const [phone, setPhone] = useState('');
    const [dob, setDob] = useState('');
    const [designation, setDesignation] = useState('');
    const [ctc, setCtc] = useState('');
    const [workLocation, setWorkLocation] = useState('');
    const [offeredDate, setOfferedDate] = useState('');
    const [Date_Of_Joning, setDate_Of_Joning] = useState('');
    const [notice_period, setnotice_period] = useState('');
    const [Employee_Current_Role, setEmployee_Current_Role] = useState('');
    const [Intern_From_Date, setIntern_From_Date] = useState('');
    const [Intern_To_Date, setIntern_To_Date] = useState('');
    const [Under_Probation, setUnder_Probation] = useState('');
    const [Probation_From_Date, setProbation_From_Date] = useState('');
    const [Probation_To_Date, setProbation_To_Date] = useState('');

    const [position, setpositioEmployee_Current_Rolen] = useState('');
    const [acceptStatus, setAcceptStatus] = useState('');
    const [letterSentBy, setLetterSentBy] = useState(Empid);

    const handleOfferletter = (e) => {
        e.preventDefault();

        const formData = new FormData();

        formData.append('OfferId', offer_letter_ID);
        formData.append('OfferName', offer_letter_name);
        formData.append('Email', offer_letter_email);
        formData.append('Phone', offer_letter_Phone);
        formData.append('Designation', offer_letter_designation);
        formData.append('DOB', dob);
        formData.append('Ctc', ctc);
        formData.append('Workloc', workLocation);
        formData.append('Offerddate', offeredDate);
        formData.append('Date_of_Joning', Date_Of_Joning);
        formData.append('Acceptstatus', acceptStatus);
        formData.append('Lettersendedby', letterSentBy);
        formData.append('notice_period', notice_period);

        formData.append('Employeement_Type', Employee_Current_Role);
        formData.append('Intern_From_Date', Intern_From_Date);
        formData.append('Intern_To_Date', Intern_To_Date);
        formData.append('probation_status', Under_Probation);
        formData.append('Probation_From_Date', Probation_From_Date);
        formData.append('Probation_To_Date', Probation_To_Date);

        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        let offer_letter_datas = {
            offer_letter_ID, offer_letter_name, offer_letter_email, offer_letter_Phone, offer_letter_designation,
            dob, designation, ctc, workLocation, offeredDate, Date_Of_Joning, acceptStatus, letterSentBy
            , Employee_Current_Role, Intern_From_Date, Intern_To_Date, Under_Probation, Probation_From_Date, Probation_To_Date, notice_period
        }

        sessionStorage.setItem('offer_letter_form', JSON.stringify(offer_letter_datas))

    };


    const handleInputChange1 = (e) => {
        const { name, value } = e.target;
        setOfferletterdata({ ...offerletterData, [name]: value });
    };

    const [offerletterData, setOfferletterdata] = useState({
        OfferName: '',
        Email: '',
        Designation: '',
        Ctc: '',
        Workloc: '',
        Offerddate: '',
        Acceptstatus: '',
        Lettersendedby: ''
    });

    const sentparticularData = (id) => {
        setCandidate(id)
        // Define the data to be sent in the request
        const dataToSend = {
            id: id // Assuming id is the parameter passed to the function
        };

        // Send a POST request using Axios
        axios.get(`${port}/root/appliedcandidate/${id}/`, dataToSend)
            .then(response => {
                // Handle the response if needed
                console.log('Data sent successfully:', response.data);
                setPersondata(response.data)
                setCandidate(response.data.CandidateId)
            })
            .catch(error => {
                // Handle errors if any
                console.error('Error sending data:', error);
            });
    };

    // Candidates Counts Details

    const [Hiredcounts, setHiredcounts] = useState({})

    useEffect(() => {
        axios.get(`${port}/root/FinalResultsCount`).then((res) => {
            console.log("counts_res", res.data);
            console.log("Int_counts_res", res.data.internal_hiring);
            setHiredcounts(res.data)

        }).catch((err) => {
            console.log("counts_err", err.data);
        })
    }, [])

    const [canditatedetails, setCandidateDetails] = useState([])

    const [status, setstatus] = useState("All Applicants")
    const [pagination, setPagination] = useState({
        count: 0,
        next: null,
        previous: null,
        currentPage: 1
    });

    const pageSize = 10; // As per backend settings

    const fetchCandidates = (e, page = 1) => {
        console.log("fetchCandidates", e, page);
        setstatus(e);
        axios.get(`${port}/root/FinalCandidatesList/${e}/?page=${page}`)
            .then((res) => {
                console.log("fetchCandidates_res", res.data);
                setCandidateDetails(res.data.results || res.data);
                if (res.data.results) {
                    setPagination({
                        count: res.data.count,
                        next: res.data.next,
                        previous: res.data.previous,
                        currentPage: page
                    });
                } else {
                    setPagination({
                        count: res.data.length || 0,
                        next: null,
                        previous: null,
                        currentPage: 1
                    });
                }
            }).catch((err) => {
                console.log("fetchCandidates_err", err);
            });
    }

    const setHiredCanditates = (e) => fetchCandidates(e, 1);
    const setConsiderToClient = (e) => fetchCandidates(e, 1);
    const setShartlistCanditates = (e) => fetchCandidates(e, 1);
    const setRejectedCandidates = (e) => fetchCandidates(e, 1);
    const setOfferdCandidates = (e) => fetchCandidates(e, 1);

    /*
    const setHiredCanditates = (e) => {
        console.log("setHiredCanditates", e);
        setstatus(e)
        axios.get(`${port}/root/FinalCandidatesList/${e}/`)
            .then((res) => {
                console.log("setHiredCanditates_res", res.data);
                setCandidateDetails(res.data.results || res.data)
            }).catch((err) => {
                console.log("setHiredCanditates_err", err.data);
            })
    }

    let setConsiderToClient = (e) => {
        console.log("setConsiderToClient", e);
        setstatus(e)
        axios.get(`${port}/root/FinalCandidatesList/${e}/`)
            .then((res) => {
                console.log("setConsiderToClient_res", res.data);
                setCandidateDetails(res.data.results || res.data)
            }).catch((err) => {
                console.log("setConsiderToClient_err", err.data);
            })
    }

    let setShartlistCanditates = (e) => {
        setstatus(e)
        console.log("setShortlistCanditates", e);
        axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
            setCandidateDetails(res.data.results || res.data)
            console.log("setShortlistCanditates_res", res.data);
        }).catch((err) => {
            console.log("setShortlistCanditates_err", err.data);
        })
    }

    let setRejectedCandidates = (e) => {
        console.log("setRejectedCandidates", e);
        setstatus(e)
        axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
            setCandidateDetails(res.data.results || res.data)
            console.log("CandidatesList", res.data);
        }).catch((err) => {
            console.log(err.data);
        })
    }

    let setOfferdCandidates = (e) => {
        console.log("setOfferdCandidates", e);
        setstatus(e)
        axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
            setCandidateDetails(res.data.results || res.data)
            console.log("CandidatesList", res.data);
        }).catch((err) => {
            console.log(err.data);
        })
    }
    */


    // }

    const [canid, setCanId] = useState(" ")
    const [canemail, setEmail] = useState(" ")




    const [offer_letter_name, setoffer_letter_name] = useState('')
    const [offer_letter_ID, setoffer_letter_ID] = useState('')
    const [offer_letter_email, setoffer_letter_email] = useState('')
    const [offer_letter_Phone, setoffer_letter_Phone] = useState('')
    const [offer_letter_designation, setoffer_letter_designation] = useState('')

    const offer_letter = (i, p, m, n, d) => {

        console.log("offer_letter", i, p, m, n);
        console.log("offer_letter_name", i);
        console.log("offer_letter_ID", p);
        console.log("offer_letter_email", m);
        console.log("offer_letter_Phone", n);
        console.log("offer_letter_designation", d);

        setoffer_letter_name(i)
        setoffer_letter_ID(p)
        setoffer_letter_email(m)
        setoffer_letter_Phone(n)
        setoffer_letter_designation(d)

    }

    const handleSubmit = (e) => {
        e.preventDefault();

        const formdata = new FormData();
        formdata.append('CandidateID', canid);
        formdata.append('mail_sended_by', Empid);
        formdata.append('FormURL', `${domain}/Doc/`);


        axios.post(`${port}/root/DocumentsUploadForm`, formdata)
            .then((r) => {
                alert('BG Document Verification Form send successfull...');
                console.log("DocumentsUploadForm_res", r.data);

            })
            .catch((err) => {
                console.log("DocumentsUploadForm_err", err);
            });

    };

    let [choose_temp, setchoose_temp] = useState(" ")

    console.log("hello", choose_temp);

    let chooseTemp = () => {

        axios.get(`${port}/root/read-file/`).then((res) => {
            setchoose_temp(res.data)
            console.log("Choosetemp", res.data);
            document.getElementById('template').innerHTML = res.data
        }).catch((err) => {
            console.log(err.data);
        })
    }

    return (
        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4 ps-4 side-blog' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav>

                <div className="  d-flex mt-4 inner_sections" >

                    {/* Sliders start */}
                    <Slider {...settings1} className='container ' >

                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    {/* <h4 style={{ position: 'relative', top: '5px' }}>{canditatedetails != undefined && canditatedetails.length}</h4> */}
                                    <h4 style={{ position: 'relative', top: '5px' }}>{Hiredcounts.internal_hiring}</h4>
                                    {/* <p data-bs-toggle="modal" data-bs-target="#exampleModal10" onClick={() => setHiredCanditates("InternalHiring")} >Internal Hiring</p> */}
                                    <p className='cursor-pointer' onClick={() => navigate("/dash/overview-candidates/InternalHiring")} >Internal Hiring</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/presenter-talking-about-people-on-a-screen-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>{Hiredcounts.consider_to_client}</h4>
                                    <p className='cursor-pointer' onClick={() => navigate("/dash/overview-candidates/consider_to_client")}>Consider To Client for Merida </p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/candidates-ranking-graphic-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p className='cursor-pointer' onClick={() => navigate("/dash/overview-candidates/ShartlistCanditates")}>Shortlist Canditates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/rejected-3-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>{Hiredcounts.Reject}</h4>
                                    <p className='cursor-pointer' value="" onClick={() => navigate("/dash/overview-candidates/Reject")}>Rejected Candidates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/hands-pray-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p className='cursor-pointer' value="" onClick={() => navigate("/dash/overview-candidates/offered")}>Offerd Candidates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>

                    </Slider>
                    {/*Sliders End  */}






                </div>
            </div>
        </div>




    )
}

export default Basic