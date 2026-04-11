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
import { toast } from 'react-toastify';
import { Modal } from 'react-bootstrap';
import { HrmStore } from '../Context/HrmContext';
import ShortcutCard from './HomeComponent/ShortcutCard';
import LeaveApprovalBox from './HomeComponent/LeaveApprovalBox';
import BackgroundDocumentshow from './HomeComponent/BackgroundDocumentshow';
import FinalResultCompleted from './Modals/FinalResultCompleted';
import WishesCom from './WishesCom';
import MyAttendance from './Employee/MyAttendance';
import EmployeeDiversity from './HomeComponent/EmployeeDiversity';
import HROverviewReport from './HomeComponent/HROverviewReport';
import NewSideBar from './MiniComponent/NewSideBar';







const Hrdashpage = ({ subpage }) => {
    let [showBGV, setshowBGV] = useState()
    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let empStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let [finalResultObj, setFinalResultObj] = useState()
    let [mailModal, setmailModal] = useState(false)
    let { openNavbar, setNavbar } = useContext(HrmStore)
    const navigate = useNavigate()
    var settings1 = {
        dots: true,
        arrows: false,
        infinite: true,
        speed: 900,
        slidesToShow: 6,
        autoplay: true,
        speed: 1000,
        responsive: [
            {
                breakpoint: 1220,
                settings: {
                    slidesToShow: 5,
                    slidesToScroll: 1,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 800,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 1,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 1,
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

        axios.get(`${port}/root/FinalCanditatesList`).then((res) => {
            console.log("CanditatesList", res.data);

        }).catch((err) => {
            console.log(err.data);
        })

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
            // console.log("Int_counts_res", res.data.internal_hiring);
            setHiredcounts(res.data)
            console.log("count", res.data);

        }).catch((err) => {
            console.log("counts_err", err.data);
        })
    }, [])

    const [canditatedetails, setCandidateDetails] = useState([])
    const [status, setstatus] = useState(" ")
    const [pagination, setPagination] = useState({
        count: 0,
        next: null,
        previous: null,
        currentPage: 1
    });

    const pageSize = 10; 

    
    // const setHiredCanditates = (e) => {
    //     console.log("setHiredCanditates", e);
    //     setstatus(e)
    //     axios.get(`${port}/root/FinalCandidatesList/${e}/`)
    //         .then((res) => {
    //             console.log("setHiredCanditates_res", res.data);
    //             setCandidateDetails(res.data.results || res.data)
    //         }).catch((err) => {
    //             console.log("setHiredCanditates_err", err.data);
    //         })
    // }

    // let setConsiderToClient = (e) => {
    //     console.log("setConsiderToClient", e);
    //     setstatus(e)
    //     axios.get(`${port}/root/FinalCandidatesList/${e}/`)
    //         .then((res) => {
    //             console.log("setConsiderToClient_res", res.data);
    //             setCandidateDetails(res.data.results || res.data)
    //         }).catch((err) => {
    //             console.log("setConsiderToClient_err", err.data);
    //         })
    // }

    // let setShartlistCanditates = (e) => {
    //     setstatus(e)
    //     console.log("setShortlistCanditates", e);
    //     axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
    //         setCandidateDetails(res.data.results || res.data)
    //         console.log("setShortlistCanditates_res", res.data);
    //     }).catch((err) => {
    //         console.log("setShortlistCanditates_err", err.data);
    //     })
    // }

    // let setRejectedCandidates = (e) => {
    //     console.log("setRejectedCandidates", e);
    //     setstatus(e)
    //     axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
    //         setCandidateDetails(res.data.results || res.data)
    //         console.log("setRejectedCandidates_res", res.data);
    //     }).catch((err) => {
    //         console.log(err.data);
    //     })
    // }

    // let setOfferdCandidates = (e) => {
    //     console.log("setOfferdCandidates", e);
    //     setstatus(e)
    //     axios.get(`${port}/root/FinalCandidatesList/${e}/`).then((res) => {
    //         setCandidateDetails(res.data.results || res.data)
    //         console.log("CanditatesList", res.data);
    //     }).catch((err) => {
    //         console.log(err.data);
    //     })
    // }
    

    const fetchCandidates = (e, page = 1) => {
        console.log("fetchCandidates", e, page);
        setstatus(e);
        axios.get(`${port}/root/FinalCandidatesList/${e}/?page=${page}`)
            .then((res) => {
                console.log("fetchCandidates_res", res.data);
                // Handle paginated or direct array responses
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

    // const sentid = (e) => {

    //     console.log("sentid", e);

    //     axios.post(`${port}/root/Documents_Upload_Data/${e}/`)
    //         .then((r) => {
    //             console.log("Sentid", r.data)

    //         })
    //         .catch((err) => {
    //             console.log("sent id Error", err)
    //         });


    // }

    const [canid, setCanId] = useState("")
    let [mailOject, setMailObj] = useState()
    const [canemail, setEmail] = useState("")
    const [mailContent, setMailContent] = useState('')
    const sentid = (e, d) => {
        setCanId(e)
        setEmail(d)
        console.log("sentid", setCanId, setEmail);
    }

    const [offer_letter_name, setoffer_letter_name] = useState('')
    const [offer_letter_ID, setoffer_letter_ID] = useState('')
    const [offer_letter_email, setoffer_letter_email] = useState('')
    const [offer_letter_Phone, setoffer_letter_Phone] = useState('')
    const [offer_letter_designation, setoffer_letter_designation] = useState('')

    useEffect(() => {
        if (mailOject) {
            console.log("Mail obj", mailOject);
            setMailContent(`Dear ${mailOject.FirstName},
Congratulations!
We are pleased to inform you that you have been selected for the ${mailOject.AppliedDesignation} role at
Merida. As the next step in our hiring process, we require a background
verification to confirm your qualifications and ensure a smooth on-boarding experience.

Your prompt attention to this matter will help us expedite your on-boarding process. We look
forward to your successful background verification and to welcoming you aboard.

To complete the process click the following Link : ${domain}/Doc/${canid}/${Empid}

Thank you for your cooperation!
Best regards,
HR TEAM
MERIDA HR`)
        }

    }, [mailOject])
    const offer_letter = (i, p, m, n, d, dob) => {

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
        setDob(dob)

    }
    let [loadingMailing, setLoadingMailing] = useState('')
    const handleSubmit = (e) => {
        e.preventDefault();

        const formdata = new FormData();
        formdata.append('CandidateID', canid);
        formdata.append('mail_sended_by', Empid);
        formdata.append('FormURL', `${domain}/Doc/${canid}/${Empid}`);
        formdata.append('mail_content', mailContent)
        setLoadingMailing('mail')
        axios.post(`${port}/root/DocumentsUploadForm`, formdata)
            .then((r) => {
                toast.success('BG Document Verification Form send successfull...');
                console.log("DocumentsUploadForm_res", r.data);
                setmailModal(false)
                setMailContent('')
                setLoadingMailing('')
            })
            .catch((err) => {
                console.log("DocumentsUploadForm_err", err);
                setLoadingMailing('')
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
    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('dashboard')
    }, [])
    return (
        <div className=' '>
            <section className='w-full flex-grow-1 
            overflow-hidden pt-2 min-h-[100vh] px-2 m-0 container-fluid'>
                {/* Sliders */}
                <WishesCom />
                {/* ${openNavbar ? 'max-w-[650px] xl:max-w-[900px] ' : "lg:max-w-[900px]  xl:max-w-full "}  */}
                <div className={` mx-auto 
                   py-3 my-2 `}>
                    <h5 className='text-3xl my-3 '>Overview </h5>

                    <Slider {...settings1} className='py-3 ' >
                        {/* <div onClick={() => setHiredCanditates("Internal_Hiring")} */}
                        {/* data-bs-toggle="modal" data-bs-target="#exampleModal10" className='py-3 h-full   ' ></div> */}
                        <div onClick={() => navigate("/dash/overview-candidates/Internal_Hiring")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle1.png'}
                                count={Hiredcounts.internal_hiring} label='Internal Hiring' />
                        </div>

                        <div onClick={() => navigate("/dash/overview-candidates/offered")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle2.png'}
                                count={Hiredcounts.offered_candidates} label='Shortlisted Candidates' />
                        </div>
                        <div
                            onClick={() => navigate("/dash/overview-candidates/Reject")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle3.png'}
                                count={Hiredcounts.Reject} label='Rejected candidate' />
                        </div>
                        <div
                            onClick={() => navigate("/dash/overview-candidates/All Applicants")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle4.png'}
                                count={Hiredcounts.AppliedCandidates} label='All Applicants' />

                        </div>
                        <div onClick={() => navigate("/dash/overview-candidates/consider_to_client")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle5.png'}
                                count={Hiredcounts.consider_to_client} label='Consider to client' />
                        </div>
                        <div onClick={() => navigate("/dash/overview-candidates/On_Hold")}
                            className='py-3 h-full cursor-pointer' >
                            <ShortcutCard img={'../assets/Images/circle3.png'}
                                count={Hiredcounts.On_Hold} label='On Hold Candidates' />
                        </div>

                    </Slider>
                </div>
                <HROverviewReport />
                <main className='row '>
                    <section className='col-md-6 my-2 ' >
                        <LeaveApprovalBox />
                    </section>
                    <section className='col-md-6 my-2 ' >
                        <MyAttendance />
                    </section>
                    {/* <section className='col-md-6 my-2 ' >
                        <EmployeeDiversity type='candidate' />
                    </section>
                    <section className='col-md-6 my-2 ' >
                        <EmployeeDiversity />
                    </section>
                    <section className='col-md-6 my-2 ' >
                        <EmployeeDiversity type='portal' />
                    </section> */}

                </main>
            </section>




            <section className=''>
                {/* OLD */}
                <div className=' transition duration-700  
             m-0 p-sm-4 ps-1 ps-sm-2 ps-md-4 '
                    style={{ borderRadius: '10px' }}>

                    <div className="  d-flex mt-4 ">


                        {/* sliders Modal start */}

                        <div class="modal fade" id="exampleModal10" tabindex="-1" aria-labelledby="exampleModalLabel10"
                            aria-hidden="true">
                            <div class="modal-dialog modal-fullscreen modal-dialog-centered">
                                <div class="modal-content bgclr1">
                                    <div class="bgclr1 flex items-center justify-between  p-3 ">
                                        <h1 class=" fs-5" id="exampleModalLabel10"> {status == 'offered' ? 'Shortlisted Candidates (offered) ' :
                                            status == 'Reject' ? 'Rejected Candidates' : status == 'On_Hold' ? 'On Hold Candidates' : status}  </h1>
                                        <button type="button" onClick={() => {
                                            setstatus('')
                                        }} class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <FinalResultCompleted show={finalResultObj} setshow={setFinalResultObj} />
                                    <div class="modal-body bgclr1">


                                        <div className='tablebg max-h-[80vh] overflow-y-scroll rounded table-responsive'>
                                            <table class="w-full ">
                                                <thead >
                                                    <tr className='sticky top-0 bgclr1' >
                                                        <th scope="col"><span className='fw-medium'>Candidate ID</span></th>
                                                        <th scope="col"><span className='fw-medium'>Full Name</span></th>
                                                        <th scope="col"><span className='fw-medium'>Email ID</span></th>
                                                        {status != 'offered' && <th scope="col"><span className='fw-medium'>Contact Number</span></th>}
                                                        {status != 'offered' && <th scope="col"><span className='fw-medium'>Applied Position</span></th>}
                                                        {status != 'offered' && <th scope="col"><span className='fw-medium'>Application Status</span></th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Offer Status</span>
                                                            </th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Offer acceptance remarks </span>
                                                            </th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Designation Offered </span>
                                                            </th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Employment Type</span>
                                                            </th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Date of Offer Issuance</span>
                                                            </th>}
                                                        {status == 'offered' &&
                                                            <th scope="col"><span className='fw-medium'>Date of joining</span>
                                                            </th>}



                                                        {status != 'Reject' && <th scope="col"><span className='fw-medium'>Experience (Fresher/Experience) </span></th>}

                                                        {(status == 'Internal_Hiring' || status == 'consider_to_client') && <th scope="col">
                                                            <span className='fw-medium'>BGV Document</span></th>}
                                                        {status != 'ShartlistCanditates' && status != 'Reject' && status != 'All Applicants' &&
                                                            <th scope="col"><span className='fw-medium'>Offer Letter</span></th>}
                                                        <th scope="col"><span className='fw-medium'>Report</span></th>

                                                    </tr>
                                                </thead>

                                                {canditatedetails && canditatedetails.map((e) => {
                                                    /* OLD LOGIC: {canditatedetails && [...canditatedetails].reverse().map((e) => { */
                                                    console.log("hellow", e);
                                                    return (

                                                        <tbody>
                                                            <tr className={` ${e.Accept_status == 'Accept' ? 'bg-green-50' :
                                                                e.Accept_status == 'Reject' ? 'bg-red-50' : ''} `} key={e.id}>

                                                                <td > {e.CandidateId}</td>
                                                                {status != 'offered' && <td >{e.FirstName}</td>}
                                                                {status == 'offered' && <td> {e.Name} </td>}

                                                                <td >{e.Email}</td>
                                                                {status != 'offered' && <td >{e.PrimaryContact}</td>}
                                                                {status != 'offered' && <td >{e.AppliedDesignation}</td>}
                                                                {status != 'offered' && <td >{e.Final_Results == 'Reject' ? 'Rejected' : e.Final_Results}</td>}
                                                                {status == 'offered' && <td className={`  `} >
                                                                    {e.Accept_status == 'Accept' ? 'Accepted' :
                                                                        e.Accept_status == 'Reject' ? 'Declined' : 'Pending'} </td>}
                                                                {status == 'offered' && <td> {e.remarks} </td>}


                                                                {status == 'offered' && <td> {e.position_name} </td>}

                                                                {status == 'offered' && <td> {e.Employeement_Type == 'intern' ? 'Intern' : 'Full-Time'} </td>}
                                                                {status == 'offered' && <td> {e.OfferedDate && e.OfferedDate.slice(0, 10)} </td>}

                                                                {status == 'offered' && <td> {e.Date_of_Joining} </td>}
                                                                {status != 'Reject' && <td> {e.current_position} </td>}
                                                                {(status == 'Internal_Hiring' || status == 'consider_to_client') &&
                                                                    <td className={` ${e.Final_Results === 'Internal Hiring' ? 'd-none' : 'd-flex'}`}>
                                                                        {e.Experience ? e.Documents_Upload_Status === "Uploaded" ?
                                                                            (<button className='btn btn-success btn-sm' data-bs-dismiss="modal"
                                                                                onClick={() => { navigate(`/dash/BackgroundVerification/${e.CandidateId}`) }} >
                                                                                BGV File Uploaded
                                                                            </button>)
                                                                            :
                                                                            (<button className='btn btn-danger btn-sm' data-bs-dismiss="modal"
                                                                                onClick={() => { sentid(e.CandidateId, e.Email); setmailModal(true); setMailObj(e) }} >
                                                                                Upload BGV File
                                                                            </button>)
                                                                            : <p className='mb-0 text-center w-full '> Not Required </p>}
                                                                    </td>
                                                                }

                                                                {status != 'ShartlistCanditates' && status != 'Reject' && status != 'All Applicants' &&
                                                                    <td className={`text-center `}>
                                                                        {((e.Experience && e.BG_Status == 'Verified') || e.Fresher ||
                                                                            e.verification_status == "Approved") ?
                                                                            <button data-bs-dismiss="modal" className={`btn btn-info btn-sm   ${e.Final_Results === 'Reject' ? 'd-none' : 'd-block '} `}
                                                                                onClick={() => {
                                                                                    offer_letter(e.FirstName, e.CandidateId, e.Email, e.PrimaryContact, e.AppliedDesignation, e.DOB);
                                                                                    navigate(`/offerletter/${e.CandidateId}`)
                                                                                }}
                                                                            > Offer Letter
                                                                            </button> : <p> BGV In Progress </p>}
                                                                    </td>
                                                                }
                                                                <td>
                                                                    <button onClick={() =>
                                                                        setFinalResultObj(e)}
                                                                        className='p-2 rounded bg-blue-600 text-sm text-white '>
                                                                        view
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    )
                                                })}
                                            </table>
                                        </div>
                                        {/* Pagination Controls */}
                                        {pagination.count > 0 && (
                                            <div className='d-flex justify-content-between align-items-center mt-3 px-3 pb-3'>
                                                <div className='text-sm text-muted text-gray-500'>
                                                    Showing {canditatedetails ? canditatedetails.length : 0} of {pagination.count} candidates (Page {pagination.currentPage} of {Math.ceil(pagination.count / pageSize)})
                                                </div>
                                                <div className="btn-group shadow-sm">
                                                    <button
                                                        type="button"
                                                        className="btn btn-white btn-sm border"
                                                        disabled={!pagination.previous}
                                                        onClick={() => fetchCandidates(status, pagination.currentPage - 1)}
                                                    >
                                                        Previous
                                                    </button>
                                                    <button
                                                        type="button"
                                                        className="btn btn-white btn-sm border"
                                                        disabled={!pagination.next}
                                                        onClick={() => fetchCandidates(status, pagination.currentPage + 1)}
                                                    >
                                                        Next
                                                    </button>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* sliders Modal end */}


                    </div>
                    {mailModal &&
                        <Modal show={mailModal}
                            onHide={() => setmailModal(false)} >
                            <Modal.Header closeButton >
                                <h4 class="modal-title text-center" > BG Document Verification Form</h4>
                            </Modal.Header>
                            <Modal.Body>
                                <form onSubmit={handleSubmit}>
                                    <div className="row m-0 border-bottom pb-2 mt-5">
                                        <div className="col-md-12 col-lg-12 mb-3">
                                            <label htmlFor="candidateID" className="form-label">Candidate ID</label>
                                            <input type="text" className="form-control shadow-none bg-light" value={canid} />
                                        </div>
                                        <div className="col-md-12 col-lg-12 mb-3">
                                            <label htmlFor="lastName" className="form-label">Email</label>
                                            <input type="text" className="form-control shadow-none bg-light" value={canemail} />
                                        </div>
                                        <div>
                                            Mail Content
                                            <textarea value={mailContent} onChange={(e) => setMailContent(e.target.value)}
                                                rows={5} className="form-control shadow-none bg-light"> </textarea>
                                        </div>

                                    </div>
                                    <div className="col-12 text-end mt-3">
                                        <button type="submit" disabled={loadingMailing == 'mail'}
                                            className="btn btn-primary btn-sm text-white fw-medium px-2 px-lg-5">
                                            {loadingMailing == 'mail' ? "Loading" : "Send Mail"}</button>
                                    </div>
                                </form>
                            </Modal.Body>
                        </Modal>}

                    <div class="modal fade" id="exampleModalToggle2" aria-hidden="true" aria-labelledby="exampleModalToggleLabel2" tabindex="-1">
                        <div class="modal-dialog  modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <h4 class="modal-title text-center" id="exampleModalToggleLabel2"> BG Document Verification Form</h4>

                                    <form onSubmit={handleSubmit}>
                                        <div className="row m-0 border-bottom pb-2 mt-5">
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor="candidateID" className="form-label">Candidate ID</label>
                                                <input type="text" className="form-control shadow-none bg-light" value={canid} />
                                            </div>
                                            <div className="col-md-12 col-lg-12 mb-3">
                                                <label htmlFor="lastName" className="form-label">Email</label>
                                                <input type="text" className="form-control shadow-none bg-light" value={canemail} />
                                            </div>

                                        </div>
                                        <div className="col-12 text-end mt-3">
                                            <button type="submit" disabled={loadingMailing == 'mail'}
                                                className="btn btn-primary btn-sm text-white fw-medium px-2 px-lg-5">
                                                {loadingMailing == 'mail' ? "Loading" : "Send Mail"}</button>
                                        </div>
                                    </form>

                                </div>

                            </div>
                        </div>
                    </div>

                    <div className="chart-section d-none p-1 bg-inf mt-4">

                        <div class="row m-0">
                            <div className="col col-sm-8">
                                <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Number of Emp by Monthly Salary</h6>
                                <div class=" border rounded p-4 bg-white mt-3">

                                    <Bar data={data}></Bar>

                                </div>
                                <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Applications Receiving Source</h6>
                                <div class=" border rounded p-4 mt-3 bg-white">

                                    <Line data={data2}></Line>

                                </div>

                                <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Recuriment Funal</h6>


                                <div className="fanal p-4 bg-white border mt-3 d-flex" style={{ position: 'relative' }}>

                                    <img className='img-fluid' src={require('../assets/Images/fanul.jpg')} width={350} alt="" />

                                    {/* <div className='percentage' >
                                    <h6 className='text-danger'>80%</h6>
                                    <br />
                                    <h6 className='text-warning'>70%</h6>
                                    <br />
                                    <h6 className='text-primary'>50%</h6>
                                    <br />
                                    <h6 className='text-success'>30%</h6>

                                </div> */}

                                </div>

                            </div>
                            <div className="col col-sm-4">
                                <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Department Ratio</h6>

                                <div class=" border rounded p-4 mt-3 bg-white">


                                    <Doughnut data={data1}></Doughnut>


                                </div>
                                <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Canditate Diversity</h6>

                                <div class=" border rounded p-3 mt-3 bg-white">


                                    <div className="male-female-box d-flex justify-content-evenly align-items-center">
                                        <div className="male ">
                                            <h3 class="">70 %</h3>
                                            <h6 style={{ position: 'relative', top: '12px', color: 'rgb(251,61,128)' }} className='text-center'>Male</h6>

                                        </div>
                                        <div>
                                            |
                                        </div>
                                        <div className="female">

                                            <h3>30 %</h3>
                                            <h6 style={{ position: 'relative', top: '12px', color: 'rgb(251,61,128)' }} className='text-center'>FeMale</h6>

                                        </div>
                                        <div>
                                            |
                                        </div>
                                        <div className="othres">

                                            <h3>10 %</h3>
                                            <h6 style={{ position: 'relative', top: '12px', color: 'rgb(251,61,128)' }} className='text-center'>Others</h6>

                                        </div>
                                    </div>


                                </div>

                                <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Open Possition by Department</h6>

                                <div class=" border rounded p-4 mt-3 bg-white">
                                    <Doughnut data={data3}></Doughnut>
                                </div>
                                <h6 className='mt-4 heading' style={{ color: 'rgb(76,53,117)' }}>Analytics</h6>

                                <div class=" border rounded p-4 mt-3 bg-white">
                                    <Doughnut data={data3}></Doughnut>

                                    <div className='d-flex justify-content-around mt-4'>
                                        <li style={{ fontSize: '13px', listStyleType: 'none' }}>Full - Time</li>
                                        <li style={{ fontSize: '13px', listStyleType: 'none' }}>Part - Time</li>
                                        <li style={{ fontSize: '13px', listStyleType: 'none' }}>Internship</li>
                                    </div>

                                </div>



                            </div>



                        </div>



                    </div>

                </div>

                {/* upload Doc */}

                <div class="modal fade" id="exampleModalToggle10" aria-hidden="true" aria-labelledby="exampleModalToggleLabel10" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-lg ">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalToggleLabel10">Upload Document</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="interviewForm" onSubmit={HandleDocupload} class="styled-form">
                                    <div class="row m-0">


                                        <div class="form-group">
                                            <label for="candidateId">Candidate ID :</label>
                                            <input type="text" id="CandidateId" value={persondata.CandidateId} name="InterviewRoundName" className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateName">Name :</label>
                                            <input type="text" id="CandidateName" value={updocData.CandidateName} onChange={handleInputChange2} name="CandidateName" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateName">Provious  Company :</label>
                                            <input type="text" id="CandidateName" value={updocData.CandidateName} onChange={handleInputChange2} name="CandidateName" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateName">Provious Designation:</label>
                                            <input type="text" id="CandidateName" value={updocData.CandidateName} onChange={handleInputChange2} name="CandidateName" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateNameEmail">Experience :</label>
                                            <input type="email" id="CandidateNameEmail" name="CandidateNameEmail" value={updocData.CandidateNameEmail} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidatePhone">From date :</label>
                                            <input type="tel" id="CandidatePhone" name="CandidatePhone" value={updocData.CandidatePhone} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateDesignation">To date :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">Current CTC :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">Reporting Manager name :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">Reporting Manager email :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">ReportingManager phone :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">HR email :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">HR phone :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>

                                        <div class="form-group">
                                            <label for="CandidateDesignation">Upload Document</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                            <input type="file" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required class="form-control mt-3" />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateDesignation">Salary Drawn Payslips :</label>
                                            <input type="file" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' />
                                        </div>
                                    </div>

                                    <div class="form-group d-flex justify-content-between">
                                        <button class="btn btn-primary">Send Email</button>
                                        <button type="submit" class="btn btn-success">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                {/* offer letter */}

                <div class="modal fade" id="exampleModalToggle11" aria-hidden="true" aria-labelledby="exampleModalToggleLabel11" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalToggleLabel11">Offer Letter</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">

                                <div className="col-12 formbg rounded py-3 shadow">
                                    <form className=' '>
                                        <div className="row poppins m-0 border-bottom pb-2 mt-2" style={{ lineHeight: '50px' }}>
                                            <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="OfferName">Name :</label>
                                                <input type="text" id="OfferName" name="OfferName" className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    required value={offer_letter_name} />
                                            </div>
                                            <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="Email">Email :</label>
                                                <input type="email" id="Email" name="Email" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={offer_letter_email} />
                                            </div>
                                            {/* <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="Phone">Phone :</label>
                                                <input type="tel" id="Phone" name="Phone" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={offer_letter_Phone} />
                                            </div> */}
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <label for="Offerddate">Position Applaying For</label>
                                                <input type="text" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={offer_letter_designation} />
                                            </div>
                                            <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="DOB">DOB :</label>
                                                <input type="date" id="DOB" name="DOB" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={dob} onChange={(e) => setDob(e.target.value)} />
                                            </div>

                                            {/* <div class=" col-md-6 col-lg-3 mb-3">
                                            <label for="Designation">Designation :</label>
                                            <input type="text" id="Designation" name="Designation" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={designation} onChange={(e) => setDesignation(e.target.value)} />
                                        </div> */}
                                            <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="Ctc">CTC :</label>
                                                <input type="number" id="Ctc" placeholder='CTC in LPA , stippend in month basis' name="Ctc" required
                                                    className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={ctc} onChange={(e) => setCtc(e.target.value)} />
                                            </div>

                                            <div class=" col-md-6 col-lg-4 mb-3">
                                                <label for="Workloc">Work Location :</label>
                                                <input type="text" id="Workloc" name="Workloc" placeholder='4th Block , Jayanagar, Bengaluru' required
                                                    className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={workLocation} onChange={(e) => setWorkLocation(e.target.value)} />
                                            </div>

                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <label for="Offerddate">Date Of Joning :</label>
                                                <input type="date" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={Date_Of_Joning} onChange={(e) => setDate_Of_Joning(e.target.value)} />
                                            </div>
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <label for="Offerddate">Notice Period :</label>
                                                <input type="number" id="Offerddate" name="Offerddate" required
                                                    className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none '
                                                    value={notice_period} onChange={(e) => setnotice_period(e.target.value)} />
                                            </div>

                                            {/* <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Employee Current Role* </label>
                                            <select className="form-select" id="ageGroup" value={Employee_Current_Role} onChange={(e) => setEmployee_Current_Role(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="intern">Intern</option>
                                                <option value="generalemployee">General Employee</option>

                                            </select>
                                        </div>
                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <label for="Offerddate">Internship Duration :</label>
                                            <div class='d-flex justify-content-evenly me-5 '>


                                                <p>
                                                    From Date <input type="date" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={Intern_From_Date} onChange={(e) => setIntern_From_Date(e.target.value)} />

                                                </p>
                                                <p>
                                                    To Date <input type="date" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={Intern_To_Date} onChange={(e) => setIntern_To_Date(e.target.value)} />

                                                </p>
                                            </div>
                                        </div>
                                        <div className="col-md-6 col-lg-4 mb-3">
                                            <label htmlFor="Name" className="form-label">Under Probation* </label>
                                            <select className="form-select" id="ageGroup" value={Under_Probation} onChange={(e) => setUnder_Probation(e.target.value)}>
                                                <option value="">Select</option>
                                                <option value="True">Yes</option>
                                                <option value="False">No</option>

                                            </select>
                                        </div>

                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <label for="Offerddate">Probation Duration :</label>
                                            <div class='d-flex justify-content-evenly me-5'>


                                                <p>
                                                    From Date <input type="date" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={Probation_From_Date} onChange={(e) => setProbation_From_Date(e.target.value)} />

                                                </p>
                                                <p>
                                                    To Date <input type="date" id="Offerddate" name="Offerddate" required className='bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none ' value={Probation_To_Date} onChange={(e) => setProbation_To_Date(e.target.value)} />

                                                </p>
                                            </div>
                                        </div> */}


                                            <div className="col-md-6 col-lg-4 ">
                                                <label htmlFor="Name" className="">Employeement Type*</label>
                                                <select
                                                    className="bgclr px-2 py-3 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none  "
                                                    id="ageGroup"
                                                    value={Employee_Current_Role}
                                                    onChange={(e) => setEmployee_Current_Role(e.target.value)}
                                                >
                                                    <option value="">Select</option>
                                                    <option value="intern">Intern</option>
                                                    <option value="permanent">Permanent</option>
                                                </select>
                                            </div>

                                            {Employee_Current_Role === "intern" && (
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Offerddate">Internship Duration:</label>
                                                    <div className="d-flex justify-content-evenly me-5">
                                                        <p>
                                                            From Date
                                                            <input
                                                                type="date"
                                                                id="Offerddate"
                                                                name="Offerddate"
                                                                required
                                                                className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                                value={Intern_From_Date}
                                                                onChange={(e) => setIntern_From_Date(e.target.value)}
                                                            />
                                                        </p>
                                                        <p>
                                                            To Date
                                                            <input
                                                                type="date"
                                                                id="Offerddate"
                                                                name="Offerddate"
                                                                required
                                                                className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                                value={Intern_To_Date}
                                                                onChange={(e) => setIntern_To_Date(e.target.value)}
                                                            />
                                                        </p>
                                                    </div>
                                                </div>
                                            )}

                                            {Employee_Current_Role === "permanent" && (
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Name" className="form-label">Under Probation*</label>
                                                    <select
                                                        className="bgclr p-2 py-3 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                        id="ageGroup"
                                                        value={Under_Probation}
                                                        onChange={(e) => setUnder_Probation(e.target.value)}
                                                    >
                                                        <option value="">Select</option>
                                                        <option value="probationer">probationer</option>
                                                        <option value="confirmed">Confirmed</option>
                                                    </select>
                                                </div>
                                            )}

                                            {Under_Probation === "probationer" && (
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Offerddate">Probation Duration:</label>
                                                    <div className="d-flex justify-content-evenly me-5">
                                                        <p>
                                                            From Date
                                                            <input
                                                                type="date"
                                                                id="Offerddate"
                                                                name="Offerddate"
                                                                required
                                                                className="bgclr px-2 focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                                value={Probation_From_Date}
                                                                onChange={(e) => setProbation_From_Date(e.target.value)}
                                                            />
                                                        </p>
                                                        <p>
                                                            To Date
                                                            <input
                                                                type="date"
                                                                id="Offerddate"
                                                                name="Offerddate"
                                                                required
                                                                className="bgclr px-2  focus-within:shadow-sm duration-500 focus-within:shadow-violet-500 rounded block w-full outline-none "
                                                                value={Probation_To_Date}
                                                                onChange={(e) => setProbation_To_Date(e.target.value)}
                                                            />
                                                        </p>
                                                    </div>
                                                </div>
                                            )}
                                        </div>

                                        <div class="col-md-6 col-lg-12 px-3 d-flex  justify-content-end ">

                                            <button className='btn bg-success-subtle '
                                                data-bs-toggle="modal" data-bs-target="#exampleModal9" onClick={handleOfferletter}> Choose Templete</button>
                                        </div>

                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="exampleModal9" aria-hidden="true" aria-labelledby="exampleModalToggleLabel9" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalToggleLabel11">Choose Templete</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">

                                <div data-bs-dismiss="modal"
                                    onClick={() => { navigate(`/Temp`) }}
                                    className="col-12 bg-white py-3 shadow" id='template'>


                                    <button className='btn btn-sm' data-bs-dismiss="modal"
                                        onClick={() => { navigate(`/Temp`) }}> Employee Template </button>
                                </div>
                                <div data-bs-dismiss="modal"
                                    onClick={() => { navigate(`/Temp`) }}
                                    className="col-12 bg-white py-3 shadow" id='template'>


                                    <button className='btn btn-sm' data-bs-dismiss="modal"
                                        onClick={() => { navigate(`/Temp`) }}> Intern Template </button>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

            </section>

        </div >
    )
}

export default Hrdashpage