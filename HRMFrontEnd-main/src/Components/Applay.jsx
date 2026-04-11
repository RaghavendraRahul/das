import React from 'react'
import Topnav from './Topnav'
import '../assets/css/fonts.css';
import '../assets/css/media.css'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Sidebar from './Sidebar';
import '../assets/css/modal.css'
import { Link, useNavigate } from 'react-router-dom';
import { Alert, AlertTitle } from '@mui/material';
import Finalstatuscomment from './Finalstatuscomment';
import { domain, port } from '../App'


const Applay = () => {

    let username = JSON.parse(sessionStorage.getItem('user')).UserName

    const [tab, setTab] = useState("newleads")

    let [applylist, setApplylist] = useState([])

    let [screeninglist, setScreeninglist] = useState([])

    let [interviewlist, setInterviewlist] = useState([])

    let [completedlist, setCompletedlist] = useState([])

    let [FinalData, setFinalData] = useState([])

    const [assignAlert, setSuccessAlert] = useState(false);
    const [seleceted_candidateid, setseleceted_candidateid] = useState("");

    const [ScheduleinterviewAlert, setScheduleinterviewAlert] = useState(false);


    const [status, setsStatus] = useState('');

    let [Canditateinformation, setCanditateinformation] = useState({})

    let [Canditateinterviewdata, setCanditateinterviewdata] = useState([])

    let [Canditatescreeningdata, setCanditatescreeningdata] = useState([])

    let [CanditateBackGroungVerification, setCanditateBackGroungVerification] = useState([])

    let [CanditateUploadedDocuments, setCanditateUploadedDocuments] = useState([])

    let [interviewRound, setinterviewRound] = useState([])

    let [ScreeningRound, setScreeningRound] = useState([])

    let [Interviewstatus, setInterviewstatus] = useState('')


    const [persondata, setPersondata] = useState({})

    const [interviewers, setInterviewers] = useState([]);

    const [selectedCandidates, setSelectedCandidates] = useState([]);
    const [selectedCandidates1, setSelectedCandidates1] = useState([]);
    const [selectedCandidates2, setSelectedCandidates2] = useState([]);
    const [selectedCandidates3, setSelectedCandidates3] = useState([]);



    const [recname, setrecname] = useState([]);

    const [load, setLoad] = useState(5)
    const loadmore = 5

    const [load1, setLoad1] = useState(5)
    const loadmore1 = 5

    const [load2, setLoad2] = useState(5)
    const loadmore2 = 5

    const [load3, setLoad3] = useState(5)
    const loadmore3 = 5




    const loadmorefunc = () => {
        setLoad(x => x + loadmore)
    }
    const loadmorefunc1 = () => {
        setLoad1(x => x + loadmore1)
    }
    const loadmorefunc2 = () => {
        setLoad2(x => x + loadmore2)
    }

    const loadmorefunc3 = () => {
        setLoad3(x => x + loadmore3)
    }

    useEffect(() => {

        axios.get(`${port}/root/FinalList/${Empid}/`).then((res) => {
            console.log("FinalData--- ", res.data);
            setFinalData(res.data)
        }).catch((error) => console.log(error))
    }, [])

    // useEffect(() => {
    //   axios.get(`${port}/root/Interview_Review_Completed_List`).then((res) => {
    //     console.log("Interview_Status", res.data);
    //     setInterviewstatus(res.data)
    //   }).catch((error) => console.log(error))
    // }, [])


    const [canidd, setcanidd] = useState(" ")
    const [canInfo, setCanInfo] = useState(" ")

    console.log('xasdxaSDDA', canInfo);

    const Callfinal_details_data = (e, d) => {

        setcanidd(d)

        console.log("Callfinal_details_data", e);

        axios.get(`${port}/root/CompleteFinalStatus/${e}/${Empid}/`).then((res) => {

            console.log("Callfinal_details", res.data);
            console.log("Canditate_Information", res.data.candidate_data);
            console.log("Interview_Round", res.data.interview_data);
            console.log("Screening_Round", res.data.screening_data);
            console.log("BackGroungVerification", res.data.BackGroungVerification);
            console.log("UploadedDocuments", res.data.UploadedDocuments);

            setCanditateinformation(res.data.candidate_data)

            setCanInfo(res.data.candidate_data.CandidateId)

            setCanditateinterviewdata(res.data.interview_data)

            setCanditatescreeningdata(res.data.screening_data)

            setCanditateUploadedDocuments(res.data.UploadedDocuments)

            setCanditateBackGroungVerification(res.data.BackGroungVerification)


        })
            .catch((res) => {

                console.log("Callfinal_details", res);

            })



    };


    // REC checkbox selection
    const handleCheckboxChange = (e) => {
        const candidateId = e.target.value;
        if (e.target.checked) {
            setSelectedCandidates([...selectedCandidates, candidateId]);
        } else {
            setSelectedCandidates(selectedCandidates.filter(id => id !== candidateId));
        }
    };

    const handleCheckboxChange1 = (e) => {
        const candidateId = e.target.value;
        if (e.target.checked) {
            setSelectedCandidates1([...selectedCandidates1, candidateId]);
        } else {
            setSelectedCandidates1(selectedCandidates1.filter(id => id !== candidateId));
        }
    };

    const handleCheckboxChange2 = (e) => {
        const candidateId = e.target.value;
        if (e.target.checked) {
            setSelectedCandidates2([...selectedCandidates2, candidateId]);
        } else {
            setSelectedCandidates2(selectedCandidates2.filter(id => id !== candidateId));
        }
    };

    const handleCheckboxChange3 = (e) => {
        const candidateId = e.target.value;
        if (e.target.checked) {
            setSelectedCandidates3([...selectedCandidates3, candidateId]);
        } else {
            setSelectedCandidates3(selectedCandidates3.filter(id => id !== candidateId));
        }
    };

    console.log(selectedCandidates);

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId

    let Disgnation = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let Email = JSON.parse(sessionStorage.getItem('user')).Email
    let PhoneNumber = JSON.parse(sessionStorage.getItem('user')).PhoneNumber
    let UserName = JSON.parse(sessionStorage.getItem('user')).UserName

    console.log("login", Empid);



    const sendSelectedDataToApi = (id) => {

        console.log(selectedCandidates, id);

        axios.post(`${port}/root/ScreeningAssigning/`, { Candidates: selectedCandidates, Recruiterid: id, login_user: Empid })
            .then(response => {
                console.log('API response:', response.data);
                setcount(count + 1)
                setSuccessAlert(true);
                window.location.reload()


            })
            .catch(error => {
                console.error('Error sending data to API:', error);

            });
    };

    // APPLY REC NAME START

    useEffect(() => {

        axios.get(`${port}/root/ScreeningAssigning/`).then((e) => {

            console.log("rec names ", e.data);
            setrecname(e.data)
        })


    }, [])

    // APPLY REC NAME END


    useEffect(() => {

        axios.get(`${port}/root/interviewschedule`).then((e) => {

            console.log("Interviewer Data", e.data);
            setInterviewers(e.data)
        })

        sentparticularData()
    }, [])

    console.log(persondata);

    const [formData, setFormData] = useState({
        Candidate: "",
        InterviewRoundName: '',
        TaskAssigned: '',
        interviewer: '',
        InterviewDate: '',
        InterviewTime: '',
        InterviewType: '',
        login_user: ''
    });

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleTimeInputChange = (e) => {
        setFormData({ ...formData, InterviewTime: e.target.value })
    }



    const handleSubmit = async (e) => {

        e.preventDefault();

        formData.Candidate = Candidateid
        formData.login_user = Empid

        console.log("schedule_Interview",
            "formData", formData,
            "Login_user", Empid);


        axios.post(`${port}/root/interviewschedule`, formData).then((res) => {

            // alert("Interview schedule Successfully..")
            setScheduleinterviewAlert(true);
            console.log("schedule_Interview_Data_res", res.data);
        }).catch((err) => {

            console.log("schedule_Interview_Data_res_err", err.data);

        })

    };

    const handleBgdocument = async (e) => {

        e.preventDefault();

        formData.Candidate = Candidateid
        formData.login_user = Empid

        console.log("schedule_Interview",
            "formData", formData,
            "Login_user", Empid);


        axios.post(`${port}/root/interviewschedule`, formData).then((res) => {

            // alert("Interview schedule Successfully..")
            setScheduleinterviewAlert(true);
            console.log("schedule_Interview_Data_res", res.data);
        }).catch((err) => {

            console.log("schedule_Interview_Data_res_err", err.data);

        })

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

    const handleInputChange1 = (e) => {
        const { name, value } = e.target;
        setOfferletterdata({ ...offerletterData, [name]: value });
    };


    const handleOfferletter = async (e) => {
        e.preventDefault();
        console.log(offerletterData);
        // try {
        //   // Make POST request to your API endpoint
        //   const response = await axios.post('${port}/root/', formData);
        //   console.log('Response:', response.data);


        //   // Optionally, you can handle success and display a message to the user
        // } catch (error) {
        //   console.error('Error:', error);
        //   // Handle error, maybe display an error message to the user
        //   console.log(formData);
        // }
    };

    const [updocData, setUpdocdata] = useState({
        CandidateId: '',
        CandidateName: '',
        CandidateNameEmail: '',
        CandidatePhone: '',
        CandidateDesignation: '',

    });

    const handleInputChange2 = (e) => {
        const { name, value } = e.target;
        setUpdocdata({ ...updocData, [name]: value });
    };

    const handleUpladdoc = async (e) => {
        updocData.CandidateId = Candidateid
        e.preventDefault();
        console.log(updocData);
        // try {
        //   // Make POST request to your API endpoint
        //   const response = await axios.post('${port}/root/interviewschedule', formData);
        //   console.log('Response:', response.data);


        //   // Optionally, you can handle success and display a message to the user
        // } catch (error) {
        //   console.error('Error:', error);
        //   // Handle error, maybe display an error message to the user
        //   console.log(formData);
        // }
    };

    const [count, setcount] = useState(0)


    // Applyed search
    const [searchValue, setSearchValue] = useState("");
    const [search_filter_applylist, setsearch_filter_applylist] = useState();
    console.log("searchValue", searchValue);

    const handlesearchvalue = (value) => {

        console.log('search_value', value);
        setSearchValue(value)

        if (value.length > 0) {
            axios.post(`${port}/root/appliedcandidateslist`, { search_value: value }).then((res) => {
                console.log("search_res", res.data);
                setApplylist(res.data)
            }).catch((err) => {
                console.log("search_res", err.data);
            })

        }
        else {
            fetchdata()
        }





    }



    // screend Search
    const [searchscreenValue, setScreenValue] = useState();
    const [search_filter_screened, setsearch_filter_Screened] = useState();
    console.log("searchValue", searchscreenValue);
    const handlescreenedsearchvalue = (value) => {

        // axios.post('${port}/root/appliedcandidateslist', value).then((res) => {
        //   console.log("search_res", res.data);
        //   setApplylist(res.data)
        // }).catch((err) => {
        //   console.log("search_res", err.data);
        // })

    }

    // Interview Search

    const [searchInterviewValue, setInterviewValue] = useState();
    const [search_filter_Interview, setsearch_filter_Interview] = useState();
    console.log("searchValue", searchInterviewValue);
    const handleInterviewearchvalue = (value) => {

        // axios.post('${port}/root/appliedcandidateslist', value).then((res) => {
        //   console.log("search_res", res.data);
        //   setApplylist(res.data)
        // }).catch((err) => {
        //   console.log("search_res", err.data);
        // })

    }

    // Final status Search

    const [searchFinalValue, setFinalValue] = useState();
    const [search_filter_Final, setsearch_filter_Final] = useState();
    console.log("searchValue", searchFinalValue);
    const handlesearchFinalValuesearchvalue = (value) => {

        // axios.post('${port}/root/appliedcandidateslist', value).then((res) => {
        //   console.log("search_res", res.data);
        //   setApplylist(res.data)
        // }).catch((err) => {
        //   console.log("search_res", err.data);
        // })

    }


    useEffect(() => {

        fetchdata()

    }, [])

    const fetchdata = () => {
        axios.post(`${port}/root/appliedcandidateslist`, { 'search_value': searchValue }).then((res) => {
            console.log("Applicand_list", res.data);
            setApplylist(res.data)
        })
    }






    useEffect(() => {
        axios.get(`${port}/root/Telephonic_Round_Status_List/${Empid}/`).then((res) => {
            console.log("Screening_list", res.data);
            setScreeninglist(res.data)
        })
    }, [])

    useEffect(() => {
        axios.get(`${port}/root/Interview_Schedule_List/${Empid}/`).then((res) => {
            console.log("Interview_list", res.data);
            setInterviewlist(res.data)
        })
    }, [])








    const [Candidateid, setCandidate] = useState("")

    // Define the function 



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
                console.log('Data--:', response.data);
                setPersondata(response.data)
                setCandidate(response.data.CandidateId)
            })
            .catch(error => {
                // Handle errors if any
                console.error('Error sending data:', error);
            });
    };

    const [int_candi_data, setint_candi_data] = useState({})
    const [int_int_data, setint_inter_data] = useState([])
    const interviewalldata = (id, d) => {
        setCandidate(id)
        // Define the data to be sent in the request
        const dataToSend = {
            id: id // Assuming id is the parameter passed to the function
        };

        // Send a POST request using Axios
        axios.get(`${port}/root/Interview_Schedule_Data/${id}/${d}/`, dataToSend)
            .then(response => {
                // Handle the response if needed
                console.log('interviewalldata', response.data);
                console.log('interviewcandidatedata', response.data.candidate_data);
                console.log('interviewinterviewsdata', response.data.interview_data);
                setint_candi_data(response.data.candidate_data)
                setint_inter_data(response.data.interview_data)


            })
            .catch(error => {
                // Handle errors if any
                console.error('Error sending data:', error);
            });
    };





    // FILE

    const [selectedFile, setSelectedFile] = useState(null);

    // Function to handle file selection
    const handleFileChange = (event) => {
        setSelectedFile(event.target.files[0]);
    };

    // Function to handle file upload
    const uploadFile = async () => {
        try {
            const excel_file = new FormData();
            excel_file.append('excel_file', selectedFile);

            // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
            const response = await axios.post(`${port}/root/upload-excel/`, excel_file, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });

            alert('File uploaded successfully!');
            console.log('File uploaded successfully!', response);
        } catch (error) {
            console.error('Error uploading file:', error);
        }
    };

    // DOWNLOAD EXCEL

    const [downloading, setDownloading] = useState(false);


    const handleDownload = async () => {
        let lists = selectedCandidates;
        try {
            const response = await axios.post(`${port}/root/download-excel/`, { 'Candidate_ids': lists }, {
                responseType: 'blob' // Important to set the responseType to 'blob'
            });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            console.log(response.data);
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'CanditateDatas.xlsx');
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (error) {
            console.error('Error downloading file:', error);
        }
    };


    const [downloading1, setDownloading1] = useState(false);


    const handleDownload1 = async () => {


        console.log("ScreenedCanditatesList", selectedCandidates1);
        alert('ScreenedCanditatesList')

        // try {
        //   const response = await axios.post('${port}/root/download-excel/', { 'Candidate_ids': lists }, {
        //     responseType: 'blob' // Important to set the responseType to 'blob'
        //   });
        //   const url = window.URL.createObjectURL(new Blob([response.data]));
        //   console.log(response.data);
        //   const link = document.createElement('a');
        //   link.href = url;
        //   link.setAttribute('download', 'CanditateDatas.xlsx');
        //   document.body.appendChild(link);
        //   link.click();
        //   link.parentNode.removeChild(link);
        // } catch (error) {
        //   console.error('Error downloading file:', error);
        // }
    };

    const [downloading2, setDownloading2] = useState(false);


    const handleDownload2 = async () => {

        console.log("Interviewed_Canditates_List", selectedCandidates2);
        alert('Interviewed_Canditates_List')

        // try {
        //   const response = await axios.post('${port}/root/download-excel/', { 'Candidate_ids': lists }, {
        //     responseType: 'blob' // Important to set the responseType to 'blob'
        //   });
        //   const url = window.URL.createObjectURL(new Blob([response.data]));
        //   console.log(response.data);
        //   const link = document.createElement('a');
        //   link.href = url;
        //   link.setAttribute('download', 'CanditateDatas.xlsx');
        //   document.body.appendChild(link);
        //   link.click();
        //   link.parentNode.removeChild(link);
        // } catch (error) {
        //   console.error('Error downloading file:', error);
        // }
    };

    const [downloading3, setDownloading3] = useState(false);


    const handleDownload3 = async () => {


        console.log("Final_Status_List", selectedCandidates3);
        alert('Final_Status_List')

        // try {
        //   const response = await axios.post('${port}/root/download-excel/', { 'Candidate_ids': lists }, {
        //     responseType: 'blob' // Important to set the responseType to 'blob'
        //   });
        //   const url = window.URL.createObjectURL(new Blob([response.data]));
        //   console.log(response.data);
        //   const link = document.createElement('a');
        //   link.href = url;
        //   link.setAttribute('download', 'CanditateDatas.xlsx');
        //   document.body.appendChild(link);
        //   link.click();
        //   link.parentNode.removeChild(link);
        // } catch (error) {
        //   console.error('Error downloading file:', error);
        // }
    };





    const handle_all_info = async (id) => {



        try {
            const response = await axios.get(`${port}/root/CompleteDetailsDownload/${id}/`, {
                responseType: 'blob' // Important to set the responseType to 'blob'
            });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            console.log(response.data);
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'CanditateDatas.xlsx');
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (error) {
            console.error('Error downloading file:', error);
        }
    };



    // selectstatus




    const searchClick = (e) => {
        e.preventDefault();
        alert("hello")
        // axios.get('${port}/root/ApplayedCandiDateSearch//').then((res) => {
        //   console.log("search_res", res.data);

        // }).catch((err) => {
        //   console.log("search_err", res.data);
        // })

    }



    //  DOC verifcation
    const [candidateId, setCandidateId] = useState('');
    const [verifiersName, setVerifiersName] = useState('');
    const [verifiersDesignation, setVerifiersDesignation] = useState('');
    const [verifiersEmployer, setVerifiersEmployer] = useState('');
    const [verifiersPhoneNumber, setVerifiersPhoneNumber] = useState('');
    const [candidateKnows, setCandidateKnows] = useState('');
    const [candidateDesignation, setCandidateDesignation] = useState('');
    const [candidateWorksFrom, setCandidateWorksFrom] = useState('');
    const [candidateReportingTo, setCandidateReportingTo] = useState('');
    const [candidatePositives, setCandidatePositives] = useState('');
    const [candidateNegatives, setCandidateNegatives] = useState('');
    const [candidatePerformanceFeedback, setCandidatePerformanceFeedback] = useState('');
    const [candidatePerformanceLevel, setCandidatePerformanceLevel] = useState('');
    const [candidateAbility, setCandidateAbility] = useState('');
    const [candidateAchieveTargets, setCandidateAchieveTargets] = useState('');
    const [candidateBehaviorFeedback, setCandidateBehaviorFeedback] = useState('');
    const [candidateLeavingReason, setCandidateLeavingReason] = useState('');
    const [candidateRehire, setCandidateRehire] = useState('');
    const [commentsOnCandidate, setCommentsOnCandidate] = useState('');
    const [packageOffered, setPackageOffered] = useState('');
    const [everHandledTeam, setEverHandledTeam] = useState('');
    const [teamSize, setTeamSize] = useState('');
    const [finalVerifyStatus, setFinalVerifyStatus] = useState('');
    const [remarks, setRemarks] = useState('');

    let Documentverifyform = (e) => {
        e.preventDefault();

        const formData = new FormData();

        formData.append('doc_instance', _id);
        formData.append('candidate', canidd);
        formData.append('VerifiersName', UserName);
        formData.append('VerifiersDesignation', Disgnation);
        formData.append('VerifiersEmployer', verifiersEmployer);
        formData.append('VerifiersPhoneNumber', PhoneNumber);
        formData.append('CandidateKnows', candidateKnows);
        formData.append('CandidateDesignation', candidateDesignation);
        formData.append('CandidateWorksFrom', candidateWorksFrom);
        formData.append('CandidateReportingTo', candidateReportingTo);
        formData.append('CandidatePositives', candidatePositives);
        formData.append('CandidateNegatives', candidateNegatives);
        formData.append('CandidatesPerformanceFeedBack', candidatePerformanceFeedback);
        formData.append('CandidatePerformanceLevel', candidatePerformanceLevel);
        formData.append('Candidates_ability', candidateAbility);
        formData.append('Candidates_Achieve_Targets', candidateAchieveTargets);
        formData.append('Candidate_Behavior_Feedback', candidateBehaviorFeedback);
        formData.append('Candidate_Leaving_Reason', candidateLeavingReason);
        formData.append('Candidate_Rehire', candidateRehire);
        formData.append('Comments_On_Candidate', commentsOnCandidate);
        formData.append('PackageOffered', packageOffered);
        formData.append('Ever_Handled_Team', everHandledTeam);
        formData.append('TeamSize', teamSize);
        formData.append('FinalVerifyStatus', finalVerifyStatus);
        formData.append('Remarks', remarks);

        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/BG_Verification/`, formData)
            .then((response) => {
                console.log("Document_Verify_res", response.data);
                alert("Document Verification Successful");
            })
            .catch((error) => {
                console.error("Document_Verify_error", error);
            });


    }

    const [candidate_id, setCandidate_id] = useState("")
    const [final_status_value, setfinal_status_value] = useState("")



    const [selectstatus, setselectstatus] = useState(false)



    const [experience, setExperience] = useState('');
    const [jobStability, setJobStability] = useState('');
    const [reasonLeaving, setReasonLeaving] = useState('');
    const [appearancePersonality, setAppearancePersonality] = useState('');
    const [clarityThought, setClarityThought] = useState('');
    const [englishSkills, setEnglishSkills] = useState('');
    const [technicalAwareness, setTechnicalAwareness] = useState('');
    const [interpersonalSkills, setInterpersonalSkills] = useState('');
    const [confidenceLevel, setConfidenceLevel] = useState('');
    const [ageGroup, setAgeGroup] = useState('');
    const [logicalReasoning, setLogicalReasoning] = useState('');
    const [careerPlans, setCareerPlans] = useState('');
    const [achievementOrientation, setAchievementOrientation] = useState('');
    const [driveProblemSolving, setDriveProblemSolving] = useState('');
    const [takeUpChallenges, setTakeUpChallenges] = useState('');
    const [leadershipAbilities, setLeadershipAbilities] = useState('');
    const [companyInterest, setCompanyInterest] = useState('');
    const [researchCompany, setResearchCompany] = useState('');
    const [targetPressure, setTargetPressure] = useState('');
    const [customerService, setCustomerService] = useState('');
    const [overallRanking, setOverallRanking] = useState('');
    const [sourceBy, setSourceBy] = useState('');
    const [location, setLocation] = useState('');
    const [DOJ, setDOJ] = useState('');
    const [certificationSubmission, setCertificationSubmission] = useState('');
    const [relocationToCity, setRelocationToCity] = useState('');
    const [relocationToCenters, setRelocationToCenters] = useState('');
    const [signature, setSignature] = useState('');
    const [date1, setDate1] = useState('');
    const [comments, setComments] = useState('');
    const [Contactnumber, setContactNumber] = useState('');
    const [sixDaysWorking, setsixDaysWorking] = useState('');
    const [FlexibilityonWorkingTimings, setFlexibilityonWorkingTimings] = useState('');


    const [_id, seid_id] = useState('')






    let handleproceedingform = (e) => {
        e.preventDefault();

        const formData1 = new FormData()


        formData1.append('CandidateId', persondata.id);
        formData1.append('Can_Id', persondata.CandidateId);
        formData1.append('Name', persondata.FirstName);
        formData1.append('PositionAppliedFor', persondata.AppliedDesignation);
        formData1.append('SourceBy', sourceBy);
        formData1.append('Date', persondata.AppliedDate);
        formData1.append('LocationAppliedFor', location);
        formData1.append('SourceName', persondata.JobPortalSource);

        formData1.append('Qualification', persondata.HighestQualification);
        formData1.append('RelatedExperience', experience);
        formData1.append('JobStabilityWithPreviousEmployers', jobStability);
        formData1.append('ReasionForLeavingImadiateEmployers', reasonLeaving);
        formData1.append('Appearance_and_Personality', appearancePersonality);
        formData1.append('ClarityOfThought', clarityThought);
        formData1.append('EnglishLanguageSkills', englishSkills);
        formData1.append('AwarenessOnTechnicalDynamics', technicalAwareness);
        formData1.append('InterpersonalSkills', interpersonalSkills);
        formData1.append('ConfidenceLevel', confidenceLevel);
        formData1.append('AgeGroupSuitability', ageGroup);
        formData1.append('Analytical_and_LogicalReasoningSkills', logicalReasoning);
        formData1.append('CareerPlans', careerPlans);
        formData1.append('AchievementOrientation', achievementOrientation);
        formData1.append('ProblemSolvingAbilites', driveProblemSolving);
        formData1.append('AbilityToTakeChallenges', takeUpChallenges);
        formData1.append('LeadershipAbilities', leadershipAbilities);
        formData1.append('IntrestWithCompany', companyInterest);
        formData1.append('ResearchedAboutCompany', researchCompany);
        formData1.append('HandelTarget_Pressure', targetPressure);
        formData1.append('CustomerService', customerService);
        formData1.append('OverallCanditateRanking', overallRanking);


        formData1.append('LastCTC', persondata.CurrentCTC);
        formData1.append('ExpectedCTC', persondata.ExpectedSalary);
        formData1.append('NoticePeriod', persondata.NoticePeriod);
        formData1.append('DOJ', DOJ);
        formData1.append('CertificateSubmission', certificationSubmission);
        formData1.append('RelocateToOtherCity', relocationToCity);
        formData1.append('RelocateToOtherCenters', relocationToCenters);
        formData1.append('interview_Status', Interviewstatus);




        formData1.append('ReviewedBy', Empid);
        // formData1.append('InterviewerName', username);
        formData1.append('Signature', signature);
        formData1.append('ReviewedDate', date1);
        formData1.append('Comments', comments);



        for (let pair of formData1.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/InterviewReviewData`, formData1)
            .then((r) => {
                alert("Proceding Form Data Successfull")
                console.log("Proceding Form Data Successfull", r.data)

            })
            .catch((err) => {
                console.log("Interview Assessment Form Error", err)
            })
    }

    let Bg_Verify_Form = () => {


    }



    const setCandid_id = (e) => {

        console.log("candidate____ID", e);
        seid_id(e)

    }
    let sendername = JSON.parse(sessionStorage.getItem('user')).UserName
    let bgverification = { canInfo, UserName, Disgnation, PhoneNumber, sendername }





    const handleSubmit123 = (e, x) => {

        console.log('single_id', e);
        console.log('CandidateID', x);

        sessionStorage.setItem('BG_verification_Companydata', JSON.stringify(bgverification))


        const formdata = new FormData();
        formdata.append('DocumentInstance', e);
        formdata.append('CandidateID', x);
        formdata.append('FormURL', `${domain}/BgverificationForm/`);

        axios.post(`${port}/root/BG_VerificationMailSend`, formdata)
            .then((r) => {
                alert('BG Document Verification Form send successfull...');
                console.log("DocumentsUploadForm_res", r.data);

            })
            .catch((err) => {
                console.log("DocumentsUploadForm_err", err);
            });

    };


    const [Employees_Upload_Formate_Res, setEmployees_Upload_Formate_Res] = useState("");
    console.log("File", Employees_Upload_Formate_Res);

    useEffect(() => {
        try {
            axios.get(`${port}/root/Employees-Upload-Formate/EmployeesUploadFormate/`).then((res) => {
                console.log("Employees_Upload_Formate_Res", res.data);
                setEmployees_Upload_Formate_Res(res.data.TemplateFile)
            })

        } catch (err) {
            console.error('Error downloading file:', err);
        }
    }, [])




    return (

        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>

            </div>
            <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
                <Topnav ></Topnav>

                <div className='d-flex justify-content-between mt-4' >

                    <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                        <li class="nav-item text-primary d-flex " role="presentation">
                            <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Applyed Canditates List</h6>
                            <small className='text-danger ms-2   rounded-circle' > {applylist != undefined && applylist.length} </small>
                        </li>

                        <li class="nav-item text-primary d-flex" role="presentation">
                            <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false">Screened Canditates List</h6>
                            <small className='text-danger ms-2   rounded-circle'> {screeninglist != undefined && screeninglist.length} </small>
                        </li>
                        <li class="nav-item text-primary d-flex" role="presentation">
                            <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" role="tab" aria-controls="pills-contact" aria-selected="false">Interviewed Canditates List</h6>
                            <small className='text-danger ms-2   rounded-circle'> {interviewlist != undefined && interviewlist.length} </small>
                        </li>
                        <li class="nav-item text-primary d-flex" role="presentation">
                            <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-completed-tab" data-bs-toggle="pill" data-bs-target="#pills-completed" role="tab" aria-controls="pills-completed" aria-selected="false">Final Status List</h6>
                            <small className='text-danger ms-2   rounded-circle'> {FinalData != undefined && FinalData.length} </small>
                        </li>
                    </ul>

                </div>


                <div class="tab-content p-1" id="myTabContent">
                    <div class="tab-pane fade show active mt-1" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
                        <div class="table-responsive ">
                            {/* Nav Tabs  start */}

                            <div class="tab-content" id="pills-tabContent">
                                {/* Tab 1 start */}
                                <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">

                                    <div className='Assign_Applaylist d-flex justify-content-end ' style={{ position: 'absolute', right: '30px', top: '130px' }}>

                                        <div class="dropup-center dropstart ">

                                            <button class="btn-success btn btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                Assign
                                            </button>

                                            <ul class="dropdown-menu  text-center" style={{ width: '150px' }}>
                                                {recname.map((e) => {
                                                    return (

                                                        <li onClick={() => sendSelectedDataToApi(e.EmployeeId)} key={e.EmployeeId} className='dropdown-item p-1' >Rec Name :  {e.Name} </li>


                                                    )

                                                })}
                                            </ul>
                                            {assignAlert && (
                                                <Alert style={{ position: 'absolute', top: '50px', right: '100px', width: '300px', zIndex: '1000' }} severity="success" onClose={() => { setSuccessAlert(false); window.location.reload(); }}>
                                                    {/* <AlertTitle>Success</AlertTitle> */}
                                                    Candidate assigned successfully..
                                                </Alert>
                                            )}
                                        </div>
                                    </div>


                                    <div className='d-flex justify-content-between mb-4 ' style={{ position: 'absolute', top: '185px', width: '78%' }}>

                                        <ul class="nav nav-pills mb-1 w-100" style={{ display: 'flex', justifyContent: 'space-between' }} id="pills-tab" role="tablist">

                                            <div className='search_Applyed'>
                                                <li class="nav-item  d-flex " >
                                                    {/* <input type="text" className='applyedlistsearch' style={{ width: '200px', height: '26px', fontSize: '9px', borderRadius: '7px', border: '1px solid rgb(222,226,230)', paddingLeft: '25px', outline: 'none' }}
                                                        value={searchValue}
                                                        onChange={(e) => setSearchValue(e.target.value)}
                                                    /> */}

                                                    <input type="text" value={searchValue}
                                                        onChange={(e) => {
                                                            handlesearchvalue(e.target.value)
                                                        }} className='form-control me-2 w-50 shadow-none ' style={{ paddingLeft: '30px' }} />





                                                </li>
                                            </div>

                                            <div className='filter-Applyed'>
                                                <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >

                                                    <select className="form-select shadow-none" id="ageGroup" style={{ width: '80px', height: '26px', fontSize: '9px', outline: 'none' }}
                                                        value={search_filter_applylist} onChange={(e) => {
                                                            setsearch_filter_applylist(e.target.value)
                                                            handlesearchvalue({ 'duration': e.target.value })
                                                        }} >
                                                        <option value="">Filter</option>
                                                        <option value="Today">Day</option>
                                                        <option value="Week">Week</option>
                                                        <option value="Month">Month</option>
                                                        <option value="Year">Year</option>
                                                    </select>

                                                </li>
                                            </div>


                                        </ul>

                                    </div>

                                    <div className='rounded mt-4 m-1'>
                                        <table class="table caption-top     table-hover">
                                            <thead >
                                                <tr >
                                                    {/* <th scope="col"></th> */}
                                                    <th scope="col"><span className='fw-medium'></span>All</th>
                                                    <th scope="col"><span className='fw-medium'>Name</span></th>
                                                    <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                                                    <th scope="col"><span className='fw-medium'>Email</span></th>
                                                    <th scope="col"><span className='fw-medium'>Phone</span></th>
                                                    <th scope="col"><span className='fw-medium'>Applied Designation</span></th>
                                                    <th scope="col"><span className='fw-medium'>View</span></th>





                                                </tr>
                                            </thead>

                                            {/* STATIC VALUE START */}

                                            {/* <tr>
                        <th scope="row"><input type="checkbox" /></th>
                        <td > 123</td>
                        <td >jerold</td>
                        <td > abc@gmail.com</td>
                        <td >3412341234</td>
                        <td >Python</td>
                        <td className='text-center'><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal2">
                          open
                        </button>
                        </td>
                      </tr> */}


                                            {applylist != undefined && applylist != undefined && applylist.slice(0, load).map((e) => {
                                                return (

                                                    <tbody>
                                                        <tr key={e.id}>
                                                            <th scope="row"><input type="checkbox" value={e.CandidateId} onChange={handleCheckboxChange} /></th>
                                                            <td >{e.FirstName}</td>
                                                            <td > {e.CandidateId}</td>
                                                            <td >{e.Email}</td>
                                                            <td >{e.PrimaryContact}</td>
                                                            <td >{e.AppliedDesignation}</td>
                                                            <td onClick={() => sentparticularData(e.CandidateId)} className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal23">
                                                                open
                                                            </button>
                                                            </td>
                                                        </tr>
                                                    </tbody>

                                                )
                                            })}


                                            {/* open Particular Data Start */}


                                            <div class="modal fade" id="exampleModal23" tabindex="-1" aria-labelledby="exampleModalLabel23" aria-hidden="false">
                                                <div class="modal-dialog modal-xl">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h1 class="modal-title fs-5" id="exampleModalLabel2">Name: {persondata.FirstName}</h1>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <h3>Applicant Information</h3>
                                                            <ul class="list-group">
                                                                <li class="list-group-item"><strong>Name:</strong> {persondata.FirstName} {persondata.LastName}</li>
                                                                <li class="list-group-item"><strong>Email:</strong> {persondata.Email}</li>
                                                                <li class="list-group-item"><strong>Gender:</strong> {persondata.Gender}</li>
                                                                <li class="list-group-item"><strong>Primary Contact:</strong> {persondata.PrimaryContact}</li>
                                                                <li class="list-group-item"><strong>Secondary Contact:</strong> {persondata.SecondaryContact}</li>
                                                                <li class="list-group-item"><strong>Location:</strong> {persondata.Location}</li>
                                                                {/* <li class="list-group-item ${persondata.Fresher ? '' : 'd-none'}"><strong>Fresher:</strong> Yes</li>
                                <li class="list-group-item ${persondata.Fresher ? 'd-none' : ''}"><strong>Experience:</strong> Yes</li> */}
                                                                <li class="list-group-item"><strong>Highest Qualification:</strong> {persondata.HighestQualification}</li>
                                                                <li class="list-group-item"><strong>University:</strong> {persondata.University}</li>
                                                                <li class="list-group-item"><strong>Specialization:</strong> {persondata.Specialization}</li>
                                                                <li class="list-group-item"><strong>Percentage:</strong> {persondata.Percentage}</li>
                                                                <li class="list-group-item"><strong>Year of Passout:</strong> {persondata.YearOfPassout}</li>
                                                                <li class="list-group-item"><strong>Technical Skills:</strong> {persondata.TechnicalSkills}</li>
                                                                <li class="list-group-item"><strong>General Skills:</strong> {persondata.GeneralSkills}</li>
                                                                <li class="list-group-item"><strong>Soft Skills:</strong> {persondata.SoftSkills}</li>
                                                                <li class="list-group-item"><strong>Applied Designation:</strong> {persondata.AppliedDesignation}</li>
                                                                <li class="list-group-item"><strong>Expected Salary:</strong> {persondata.ExpectedSalary}</li>
                                                                <li class="list-group-item"><strong>Contacted By:</strong> {persondata.ContactedBy}</li>
                                                                <li class="list-group-item"><strong>Job Portal Source:</strong> {persondata.JobPortalSource}</li>
                                                                <li class="list-group-item"><strong>Applied Date:</strong> {persondata.AppliedDate}</li>
                                                            </ul>
                                                        </div>
                                                        <div class="modal-footer d-flex justify-content-between">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                            <div class="d-flex gap-2">
                                                                {/* <button type="button" class="btn btn-primary">Assign Task</button> */}
                                                                <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schedule Interview</button>
                                                                {/* <button type="button" class="btn btn-info" data-bs-target="#exampleModalToggle7" data-bs-toggle="modal">Offer Letter</button> */}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                            {/* open Particular Data End */}


                                        </table>
                                    </div>
                                    <div className='d-flex justify-content-between p-2'>
                                        <button onClick={loadmorefunc} className='btn btn-sm btn-success'>Load More</button>
                                        <div>
                                            <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload}>
                                                {downloading ? 'Downloading...' : 'Download'}
                                            </button>
                                            {/* <a href={down} download="data.xlsx">Down </a> */}

                                            <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal9" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button>

                                            {/* <div class="modal fade" id="exampleModal9" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                          <div class="modal-content">
                            <div class="modal-header">
                              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div className="modal-body">
                             
                              <input
                                type="file"
                                className="form-control-file"
                                onChange={handleFileChange}
                                accept=".csv, .xlsx, .txt" // Specify allowed file types if needed
                              />
                            </div>
                            <div className="modal-footer">

                              <button
                                type="button"
                                className="btn btn-primary"
                                onClick={uploadFile}
                                disabled={!selectedFile}
                              >
                                Upload
                              </button>
                            </div>

                          </div>
                        </div>
                      </div> */}
                                            <div class="modal fade" id="exampleModal9" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h6>Upload Excel File</h6>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div className="modal-body">
                                                            {/* File input */}
                                                            <input
                                                                type="file"
                                                                className="form-control-file form-control shadow-none"
                                                                onChange={handleFileChange}
                                                                accept=".csv, .xlsx, .txt" // Specify allowed file types if needed
                                                            />
                                                        </div>
                                                        <div className="modal-footer">

                                                            <a href={Employees_Upload_Formate_Res}  >

                                                                <button
                                                                    type="button"
                                                                    className="btn btn-warning  " data-bs-dismiss="modal">

                                                                    Download Excel Format
                                                                </button>
                                                            </a>




                                                            <button
                                                                type="button"
                                                                className="btn btn-primary  "
                                                                onClick={uploadFile}
                                                                disabled={!selectedFile}
                                                                data-bs-dismiss="modal"
                                                            >
                                                                Upload
                                                            </button>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                    </div>

                                </div>
                                {/* Tab 1 end */}

                                {/* Tab 2 start */}
                                <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">
                                    <div className='d-flex justify-content-between mb-4 ' style={{ position: 'absolute', top: '185px', width: '78%' }}>

                                        <ul class="nav nav-pills mb-1 w-100" style={{ display: 'flex', justifyContent: 'space-between' }} id="pills-tab" role="tablist">

                                            <div>
                                                <li class="nav-item  d-flex " >
                                                    <input type="text" className='applyedlistsearch' style={{ width: '200px', height: '26px', fontSize: '9px', borderRadius: '7px', border: '1px solid rgb(222,226,230)', paddingLeft: '25px', outline: 'none' }}
                                                        value={searchscreenValue}
                                                        onChange={(e) => setScreenValue(e.target.value)}
                                                    />
                                                    <i class="fa-solid fa-magnifying-glass " onClick={() => {
                                                        handlescreenedsearchvalue({ 'search_value': searchValue })
                                                    }} style={{ fontSize: '12px', position: 'relative', right: '20px', top: '8px' }}></i>


                                                </li>
                                            </div>

                                            <div>
                                                <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >

                                                    <select className="form-select shadow-none" id="ageGroup" style={{ width: '80px', height: '26px', fontSize: '9px', outline: 'none' }}
                                                        value={search_filter_screened} onChange={(e) => {
                                                            setsearch_filter_Screened(e.target.value)
                                                            handlescreenedsearchvalue({ 'duration': e.target.value })
                                                        }} >
                                                        <option value="">Filter</option>
                                                        <option value="Today">Day</option>
                                                        <option value="Week">Week</option>
                                                        <option value="Month">Month</option>
                                                        <option value="Year">Year</option>
                                                    </select>

                                                </li>
                                            </div>


                                        </ul>

                                    </div>


                                    <div className='rounded mt-4'>
                                        <table class="table caption-top     table-hover table-responsive" style={{ width: '130%' }}>
                                            <thead >
                                                <tr >
                                                    <th scope="col"><span className='fw-medium'>All</span></th>
                                                    <th scope="col"><span className='fw-medium'>Name</span></th>
                                                    <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                                                    <th scope="col"><span className='fw-medium'>Assigned To</span></th>
                                                    {/* <th scope="col"><span className='fw-medium'>Date Of Assigned</span></th> */}
                                                    <th scope="col"><span className='fw-medium'>AssignedBy</span></th>
                                                    <th scope="col"><span className='fw-medium'>Assigned_Status</span></th>
                                                    <th scope="col"><span className='fw-medium'>Screened Status</span></th>
                                                    {/* <th scope="col"><span className='fw-medium'>Screened On</span></th> */}
                                                    {/* <th scope="col"><span className='fw-medium'>View</span></th> */}

                                                </tr>
                                            </thead>

                                            {/* STATIC VALUE START */}

                                            {/* <tr>

                        <td > 123</td>
                        <td >jerold</td>
                        <td >Null</td>
                        <td >23-12-2001</td>
                        <td >Mathavan</td>
                        <td >Assigned</td>
                        <td >Assigned</td>
                        <td className='text-center'><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal5">
                          open
                        </button>
                        </td>
                      </tr> */}
                                            <tbody>

                                                {screeninglist != undefined && screeninglist != undefined && screeninglist.slice(0, load1).map((e) => {
                                                    console.log(e.candidate_details);
                                                    return (<tr key={e.id}>
                                                        <th scope="row"><input type="checkbox" value={e.Candidate} onChange={handleCheckboxChange1} /></th>
                                                        <td onClick={() => sentparticularData(e.Candidate)} data-bs-toggle="modal" data-bs-target="#exampleModal5" style={{ cursor: 'pointer', color: 'blue' }}>{e.Name}</td>
                                                        <td>{e.Candidate}</td>
                                                        <td>{e.Recruiter}</td>
                                                        {/* <td>{e.Date_of_assigned}</td> */}
                                                        <td>{e.AssignedBy}</td>
                                                        <td>{e.Assigned_Status}</td>
                                                        <td>{e.Review != null ? e.Review.Screening_Status : null}</td>
                                                        {/* <td>{e.Review != null ? e.Review.ReviewedOn : null}</td> */}
                                                        {/* <td onClick={() => sentparticularData(e.Candidate)} className='text-center'>
                              <button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} className="btn btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal5">
                                Open
                              </button>
                            </td> */}
                                                    </tr>)
                                                })}
                                            </tbody>
                                            {/* open Particular Data Start */}

                                            <div class="modal fade" id="exampleModal5" tabindex="-1" aria-labelledby="exampleModalLabel5" aria-hidden="false">
                                                <div class="modal-dialog modal-xl">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h1 class="modal-title fs-5" id="exampleModalLabel5">Name : {persondata.FirstName}</h1>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">

                                                            <h3>Canditate Information</h3>
                                                            <ul class="list-group">
                                                                <li class="list-group-item"><strong>Name:</strong> {persondata.FirstName} {persondata.LastName}</li>
                                                                <li class="list-group-item"> <strong>Email:</strong> {persondata.Email}</li>
                                                                <li class="list-group-item"><strong>Gender:</strong> {persondata.Gender}</li>
                                                                <li class="list-group-item"><strong>Primary Contact:</strong> {persondata.PrimaryContact}</li>
                                                                <li class="list-group-item"><strong>Secondary Contact:</strong>{persondata.SecondaryContact}</li>
                                                                <li class="list-group-item"><strong>Location:</strong> {persondata.Location}</li>
                                                                <li className={`${persondata.Fresher ? '' : 'd-none'}  list-group-item`}><strong>Fresher:</strong>Yes</li>
                                                                <li className={`${persondata.Fresher ? 'd-none' : ''} list-group-item`}><strong>Experience:</strong>Yes</li>
                                                                <li class="list-group-item"><strong>Highest Qualification:</strong> {persondata.HighestQualification}</li>
                                                                <li class="list-group-item"><strong>University:</strong> {persondata.University}</li>
                                                                <li class="list-group-item"><strong>Specialization:</strong> {persondata.Specialization}</li>
                                                                <li class="list-group-item"><strong>Percentage:</strong> {persondata.Percentage}</li>
                                                                <li class="list-group-item"><strong>Year of Passout:</strong> {persondata.YearOfPassout}</li>
                                                                <li class="list-group-item"><strong>Technical Skills:</strong> {persondata.TechnicalSkills}</li>
                                                                <li class="list-group-item"><strong>General Skills:</strong> {persondata.GeneralSkills}</li>
                                                                <li class="list-group-item"><strong>Soft Skills:</strong> {persondata.SoftSkills}</li>
                                                                <li class="list-group-item"><strong>Applied Designation:</strong> {persondata.AppliedDesignation}</li>
                                                                <li class="list-group-item"><strong>Expected Salary:</strong>{persondata.ExpectedSalary}</li>
                                                                <li class="list-group-item"><strong>Contacted By:</strong> {persondata.ContactedBy}</li>
                                                                <li class="list-group-item"><strong>Job Portal Source:</strong>{persondata.JobPortalSource}</li>
                                                                <li class="list-group-item"><strong>Applied Date:</strong> {persondata.AppliedDate}</li>
                                                            </ul>







                                                        </div>
                                                        <div class="modal-footer d-flex justify-content-between">
                                                            <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                                                            <div className='d-flex gap-2'>

                                                                {/* <button type="button" class="btn btn-primary">Assign Task</button> */}

                                                                <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button>



                                                                {/* <button type="button" class="btn btn-info">Offer Letter</button> */}


                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            {/* open Particular Data End */}


                                        </table>
                                    </div>
                                    <div className='d-flex justify-content-between p-3'>
                                        <button onClick={loadmorefunc1} className='btn btn-sm btn-success'>Load More</button>
                                        <div>
                                            <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload1}>
                                                {downloading ? 'Downloading...' : 'Download'}
                                            </button>


                                            {/* <a href={down} download="data.xlsx">Down </a> */}

                                            {/* <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button> */}

                                            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div className="modal-body">
                                                            {/* File input */}
                                                            <input
                                                                type="file"
                                                                className="form-control-file"
                                                                onChange={handleFileChange}
                                                                accept=".csv, .xlsx, .txt" // Specify allowed file types if needed
                                                            />
                                                        </div>
                                                        <div className="modal-footer">

                                                            <button
                                                                type="button"
                                                                className="btn btn-primary"
                                                                onClick={uploadFile}
                                                                disabled={!selectedFile}
                                                            >
                                                                Upload
                                                            </button>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </div>
                                {/* Tab 2 end */}

                                {/* Tab 3 start */}
                                <div class="tab-pane fade " id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">


                                    <div className='d-flex justify-content-between mb-4 ' style={{ position: 'absolute', top: '185px', width: '78%' }}>

                                        <ul class="nav nav-pills mb-1 w-100" style={{ display: 'flex', justifyContent: 'space-between' }} id="pills-tab" role="tablist">

                                            <div>
                                                <li class="nav-item  d-flex " >
                                                    <input type="text" className='applyedlistsearch' style={{ width: '200px', height: '26px', fontSize: '9px', borderRadius: '7px', border: '1px solid rgb(222,226,230)', paddingLeft: '25px', outline: 'none' }}
                                                        value={searchInterviewValue}
                                                        onChange={(e) => setInterviewValue(e.target.value)}
                                                    />
                                                    <i class="fa-solid fa-magnifying-glass " onClick={() => {
                                                        handleInterviewearchvalue({ 'search_value': searchValue })
                                                    }} style={{ fontSize: '12px', position: 'relative', right: '20px', top: '8px' }}></i>


                                                </li>
                                            </div>

                                            <div>
                                                <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >

                                                    <select className="form-select shadow-none" id="ageGroup" style={{ width: '80px', height: '26px', fontSize: '9px', outline: 'none' }}
                                                        value={search_filter_Interview} onChange={(e) => {
                                                            setsearch_filter_Interview(e.target.value)
                                                            handleInterviewearchvalue({ 'duration': e.target.value })
                                                        }} >
                                                        <option value="">Filter</option>
                                                        <option value="Today">Day</option>
                                                        <option value="Week">Week</option>
                                                        <option value="Month">Month</option>
                                                        <option value="Year">Year</option>
                                                    </select>

                                                </li>
                                            </div>


                                        </ul>

                                    </div>

                                    <div className='rounded mt-4 m-1'>
                                        <table class="table caption-top table-hover" style={{ width: '130%' }} >
                                            <thead >
                                                <tr >

                                                    <th scope="col"><span className='fw-medium'>All</span></th>
                                                    <th scope="col"><span className='fw-medium'>Name</span></th>
                                                    <th scope="col"><span className='fw-medium'>Canditate Id</span></th>

                                                    {/* <th scope="col"><span className='fw-medium'>Interview Date</span></th> */}
                                                    <th scope="col"><span className='fw-medium'>Assigned To</span></th>
                                                    <th scope="col"><span className='fw-medium'>Assigned Status</span></th>
                                                    <th scope="col"><span className='fw-medium'>Interview Round Name</span></th>

                                                    {/* <th scope="col"><span className='fw-medium'>Interview Type</span></th> */}
                                                    <th scope="col"><span className='fw-medium'>Interviewed Status</span></th>
                                                    <th scope="col"><span className='fw-medium'>Interviewed On</span></th>

                                                    <th scope="col"><span className='fw-medium'>Scheduled By</span></th>
                                                    {/* <th scope="col"><span className='fw-medium'>Scheduled On </span></th> */}
                                                    {/* <th scope="col"><span className='fw-medium'>---</span></th> */}
                                                </tr>
                                            </thead>

                                            {/* STATIC VALUE START */}

                                            {/* <tr>
                        <th scope="row"><input type="checkbox" /></th>
                        <td > 123</td>
                        <td >jerold</td>
                        <td > abc@gmail.com</td>
                        <td >3412341234</td>
                        <td >Python</td>
                        <td className='text-center'><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal2">
                          open
                        </button>
                        </td>
                      </tr> */}

                                            <tbody>
                                                {interviewlist != undefined && interviewlist != undefined && interviewlist.slice(0, load2).map((e) => (
                                                    <tr key={e.id}>
                                                        <th scope="row"><input type="checkbox" value={e.Candidate} onChange={handleCheckboxChange2} /></th>

                                                        <td onClick={() => interviewalldata(e.Candidate, e.id)} data-bs-toggle="modal" data-bs-target="#exampleModal13" style={{ cursor: 'pointer', color: 'blue' }}>{e.Name}</td>
                                                        <td>{e.Candidate}</td>
                                                        {/* <td>{e.InterviewDate}</td> */}
                                                        <td>{e.interviewer}</td>
                                                        <td>{e.Assigned_Status}</td>
                                                        <td>{e.InterviewRoundName}</td>

                                                        {/* <td>{e.InterviewType}</td> */}

                                                        <td>{e.interview_Status}</td>
                                                        <td>{e.ReviewedOn}</td>
                                                        <td>{e.ScheduledBy}</td>
                                                        {/* <td>{e.ScheduledOn}</td> */}
                                                        {/* <td onClick={() => interviewalldata(e.Candidate,e.id)} className='text-center'>
                            <button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} className="btn btn-sm" >
                              Open
                            </button>
                          </td> */}
                                                    </tr>
                                                ))}

                                            </tbody>
                                            {/* open Particular Data Start */}


                                            <div class="modal fade" id="exampleModal13" tabindex="-1" aria-labelledby="exampleModalLabel13" aria-hidden="false">
                                                <div class="modal-dialog modal-fullscreen">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h1>Interview</h1>
                                                            <button type="button" class="btn-close" onClick={() => { window.location.reload() }} data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="modal-body container-fluid ">

                                                                {/* Candidate Information start */}

                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Candidate Information</h5>

                                                                    <div className="col-lg-12 p-4 border rounded-lg">


                                                                        <p><strong>ID:</strong> {int_candi_data.id}</p>
                                                                        <p><strong>Candidate ID:</strong> {int_candi_data.CandidateId}</p>
                                                                        <p><strong>First Name:</strong> {int_candi_data.FirstName}</p>
                                                                        <p><strong>Last Name:</strong> {int_candi_data.LastName}</p>
                                                                        <p><strong>Email:</strong> {int_candi_data.Email}</p>
                                                                        <p><strong>Primary Contact:</strong> {int_candi_data.PrimaryContact}</p>
                                                                        <p><strong>Secondary Contact:</strong> {int_candi_data.SecondaryContact}</p>
                                                                        <p><strong>Location:</strong> {int_candi_data.Location}</p>
                                                                        <p><strong>Gender:</strong> {int_candi_data.Gender}</p>
                                                                        <p><strong>Experience:</strong> {int_candi_data.Experience ? "Yes" : "No"}</p>
                                                                        <p><strong>Highest Qualification:</strong> {int_candi_data.HighestQualification}</p>
                                                                        <p><strong>University:</strong> {int_candi_data.University}</p>
                                                                        <p><strong>Specialization:</strong> {int_candi_data.Specialization}</p>
                                                                        <p><strong>Percentage:</strong> {int_candi_data.Percentage}</p>
                                                                        <p><strong>Year of Passout:</strong> {int_candi_data.YearOfPassout}</p>
                                                                        <p><strong>Technical Skills with Experience:</strong> {int_candi_data.TechnicalSkills_with_Exp}</p>
                                                                        <p><strong>General Skills with Experience:</strong> {int_candi_data.GeneralSkills_with_Exp}</p>
                                                                        <p><strong>Soft Skills with Experience:</strong> {int_candi_data.SoftSkills_with_Exp}</p>
                                                                        <p><strong>Applied Designation:</strong> {int_candi_data.AppliedDesignation}</p>
                                                                        <p><strong>Notice Period:</strong> {int_candi_data.NoticePeriod}</p>
                                                                        <p><strong>Current Designation:</strong> {int_candi_data.CurrentDesignation}</p>
                                                                        <p><strong>Current CTC:</strong> {int_candi_data.CurrentCTC}</p>
                                                                        <p><strong>Total Experience:</strong> {int_candi_data.TotalExperience}</p>
                                                                        <p><strong>Expected Salary:</strong> {int_candi_data.ExpectedSalary}</p>
                                                                        <p><strong>Contacted By:</strong> {int_candi_data.ContactedBy}</p>
                                                                        <p><strong>Job Portal Source:</strong> {int_candi_data.JobPortalSource}</p>
                                                                        <p><strong>Applied Date:</strong> {int_candi_data.AppliedDate}</p>


                                                                    </div>
                                                                </div>
                                                                {/* Candidate Information end */}

                                                                {/* Interview Round start */}
                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Interview Round</h5>

                                                                    <div className="col-lg-12 p-4 border rounded-lg">


                                                                        <p><strong>Interview Round Name:</strong>{int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} </p>
                                                                        <p><strong>Task Assigned:</strong>  {int_int_data && int_int_data.TaskAssigned != undefined ? (<span>{int_int_data.TaskAssigned}</span>) : (<></>)}</p>
                                                                        <p><strong>Interviewer:</strong>  {int_int_data && int_int_data.interviewer != undefined ? (<span>{int_int_data.interviewer}</span>) : (<></>)} </p>
                                                                        <p><strong>Interview Date:</strong>  {int_int_data && int_int_data.InterviewDate != undefined ? (<span>{int_int_data.InterviewDate}</span>) : (<></>)}</p>
                                                                        <p><strong>Interview Type:</strong>   {int_int_data && int_int_data.InterviewType != undefined ? (<span>{int_int_data.InterviewType}</span>) : (<></>)}</p>
                                                                        <p><strong>Scheduled By:</strong>   {int_int_data && int_int_data.ScheduledBy != undefined ? (<span>{int_int_data.ScheduledBy}</span>) : (<></>)}</p>
                                                                        <p><strong>Scheduled On:</strong>   {int_int_data && int_int_data.ScheduledOn != undefined ? (<span>{int_int_data.ScheduledOn}</span>) : (<></>)}</p>
                                                                        <p><strong>Candidate Id:</strong>   {int_int_data && int_int_data.CandidateId != undefined ? (<span>{int_int_data.CandidateId}</span>) : (<></>)}</p>
                                                                        <p><strong>Name:</strong>  {int_int_data && int_int_data.Name != undefined ? (<span>{int_int_data.Name}</span>) : (<></>)}</p>
                                                                        <p><strong>Position Applied For:</strong>  {int_int_data && int_int_data.PositionAppliedFor != undefined ? (<span>{int_int_data.PositionAppliedFor}</span>) : (<></>)} </p>
                                                                        <p><strong>Source By:</strong>   {int_int_data && int_int_data.SourceBy != undefined ? (<span>{int_int_data.SourceBy}</span>) : (<></>)}</p>
                                                                        <p><strong>Source Name:</strong>   {int_int_data && int_int_data.SourceName != undefined ? (<span>{int_int_data.SourceName}</span>) : (<></>)}</p>
                                                                        <p><strong>Date:</strong>  {int_int_data && int_int_data.Date != undefined ? (<span>{int_int_data.Date}</span>) : (<></>)}</p>
                                                                        <p><strong>Location Applied For:</strong> {int_int_data && int_int_data.LocationAppliedFor != undefined ? (<span>{int_int_data.LocationAppliedFor}</span>) : (<></>)} </p>
                                                                        <p><strong>Contact:</strong> {int_int_data && int_int_data.Contact != undefined ? (<span>{int_int_data.Contact}</span>) : (<></>)} </p>
                                                                        <p><strong>Qualification:</strong>  {int_int_data && int_int_data.Qualification != undefined ? (<span>{int_int_data.Qualification}</span>) : (<></>)}</p>
                                                                        <p><strong>Related Experience:</strong>  {int_int_data && int_int_data.RelatedExperience != undefined ? (<span>{int_int_data.RelatedExperience}</span>) : (<></>)}</p>
                                                                        <p><strong>Job Stability With Previous Employers:</strong>  {int_int_data && int_int_data.JobStabilityWithPreviousEmployers != undefined ? (<span>{int_int_data.JobStabilityWithPreviousEmployers}</span>) : (<></>)}</p>
                                                                        <p><strong>Reason For Leaving Immediate Employer:</strong>  {int_int_data && int_int_data.ReasionForLeavingImadiateEmployeer != undefined ? (<span>{int_int_data.ReasionForLeavingImadiateEmployeer}</span>) : (<></>)}</p>
                                                                        <p><strong>Appearance and Personality:</strong>  {int_int_data && int_int_data.Appearence_and_Personality != undefined ? (<span>{int_int_data.Appearence_and_Personality}</span>) : (<></>)}</p>
                                                                        <p><strong>Clarity Of Thought:</strong>  {int_int_data && int_int_data.ClarityOfThought != undefined ? (<span>{int_int_data.ClarityOfThought}</span>) : (<></>)}</p>
                                                                        <p><strong>English Language Skills:</strong>  {int_int_data && int_int_data.EnglishLanguageSkills != undefined ? (<span>{int_int_data.EnglishLanguageSkills}</span>) : (<></>)}</p>
                                                                        <p><strong>Awareness On Technical Dynamics:</strong>  {int_int_data && int_int_data.AwarenessOnTechnicalDynamics != undefined ? (<span>{int_int_data.AwarenessOnTechnicalDynamics}</span>) : (<></>)}</p>
                                                                        <p><strong>Interpersonal Skills:</strong>  {int_int_data && int_int_data.InterpersonalSkills != undefined ? (<span>{int_int_data.InterpersonalSkills}</span>) : (<></>)}</p>
                                                                        <p><strong>Confidence Level:</strong>  {int_int_data && int_int_data.ConfidenceLevel != undefined ? (<span>{int_int_data.ConfidenceLevel}</span>) : (<></>)}</p>
                                                                        <p><strong>Age Group Suitability:</strong>  {int_int_data && int_int_data.AgeGroupSuitability != undefined ? (<span>{int_int_data.AgeGroupSuitability}</span>) : (<></>)}</p>
                                                                        <p><strong>Analytical and Logical Reasoning Skills:</strong>  {int_int_data && int_int_data.Analytical_and_logicalReasoningSkills != undefined ? (<span>{int_int_data.Analytical_and_logicalReasoningSkills}</span>) : (<></>)}</p>
                                                                        <p><strong>Career Plans:</strong>  {int_int_data && int_int_data.CareerPlans != undefined ? (<span>{int_int_data.CareerPlans}</span>) : (<></>)}</p>
                                                                        <p><strong>Achievement Orientation:</strong>  {int_int_data && int_int_data.AchivementOrientation != undefined ? (<span>{int_int_data.AchivementOrientation}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Problem Solving Abilities:</strong>  {int_int_data && int_int_data.ProblemSolvingAbilites != undefined ? (<span>{int_int_data.ProblemSolvingAbilites}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Ability To Take Challenges:</strong>  {int_int_data && int_int_data.AbilityToTakeChallenges != undefined ? (<span>{int_int_data.AbilityToTakeChallenges}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Leadership Abilities:</strong>  {int_int_data && int_int_data.LeadershipAbilities != undefined ? (<span>{int_int_data.LeadershipAbilities}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Interest With Company:</strong>  {int_int_data && int_int_data.IntrestWithCompany != undefined ? (<span>{int_int_data.IntrestWithCompany}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Researched About Company:</strong>  {int_int_data && int_int_data.ResearchedAboutCompany != undefined ? (<span>{int_int_data.ResearchedAboutCompany}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Handle Targets Pressure:</strong>  {int_int_data && int_int_data.HandelTargets_Pressure != undefined ? (<span>{int_int_data.HandelTargets_Pressure}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Customer Service:</strong>  {int_int_data && int_int_data.CustomerService != undefined ? (<span>{int_int_data.CustomerService}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Overall Candidate Ranking:</strong>  {int_int_data && int_int_data.OverallCandidateRanking != undefined ? (<span>{int_int_data.OverallCandidateRanking}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Last CTC:</strong>  {int_int_data && int_int_data.LastCTC != undefined ? (<span>{int_int_data.LastCTC}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Expected CTC:</strong>  {int_int_data && int_int_data.ExpectedCTC != undefined ? (<span>{int_int_data.ExpectedCTC}</span>) : (<></>)}</p>
                                                                        <p><strong>Notice Period:</strong>  {int_int_data && int_int_data.NoticePeriod != undefined ? (<span>{int_int_data.NoticePeriod}</span>) : (<></>)}</p>
                                                                        <p><strong>DOJ:</strong> {int_int_data && int_int_data.DOJ != undefined ? (<span>{int_int_data.DOJ}</span>) : (<></>)}</p>
                                                                        <p><strong>Six Days Working:</strong>  {int_int_data && int_int_data.Six_Days_Working != undefined ? (<span>{int_int_data.Six_Days_Working}</span>) : (<></>)}</p>
                                                                        <p><strong>Flexibility On Work Timings:</strong> {int_int_data && int_int_data.FlexibilityOnWorkTimings != undefined ? (<span>{int_int_data.FlexibilityOnWorkTimings}</span>) : (<></>)}</p>
                                                                        <p><strong>Certificate Submission:</strong>{int_int_data && int_int_data.CertificateSubmittion != undefined ? (<span>{int_int_data.CertificateSubmittion}</span>) : (<></>)}</p>
                                                                        <p><strong>Relocate To Other City:</strong>  {int_int_data && int_int_data.RelocateToOtherCity != undefined ? (<span>{int_int_data.RelocateToOtherCity}</span>) : (<></>)}</p>
                                                                        <p><strong>Relocate To Other Centers:</strong>  {int_int_data && int_int_data.RelocateToOtherCenters != undefined ? (<span>{int_int_data.RelocateToOtherCenters}</span>) : (<></>)}</p>
                                                                        <p><strong>Screening Feedback:</strong>  {int_int_data && int_int_data.ScreeningFeedback != undefined ? (<span>{int_int_data.ScreeningFeedback}</span>) : (<></>)}</p>
                                                                        <p><strong>Current Location:</strong>  {int_int_data && int_int_data.CurrentLocation != undefined ? (<span>{int_int_data.CurrentLocation}</span>) : (<></>)}</p>
                                                                        <p><strong>Travel By:</strong>  {int_int_data && int_int_data.TravellBy != undefined ? (<span>{int_int_data.TravellBy}</span>) : (<></>)}</p>
                                                                        <p><strong>Stays With:</strong>  {int_int_data && int_int_data.StaysWith != undefined ? (<span>{int_int_data.StaysWith}</span>) : (<></>)} {int_int_data && int_int_data.StaysWith != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        <p><strong>Native:</strong>  {int_int_data && int_int_data.Native != undefined ? (<span>{int_int_data.Native}</span>) : (<></>)} {int_int_data && int_int_data.Native != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                                                        {/* <p><strong>Father Designation:</strong>  {int_int_data && int_int_data.FatherDesignation != undefined ? (<span>{int_int_data.FatherDesignation}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Mother Designation:</strong>  {int_int_data && int_int_data.MotherDesignation != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Number of Siblings:</strong>  {int_int_data && int_int_data.no_of_sibilings != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Siblings Designation:</strong>  {int_int_data && int_int_data.sibilingsDesignation != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Marital Status:</strong>  {int_int_data && int_int_data.MeritalStatus != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Spouse Designation:</strong>  {int_int_data && int_int_data.SpouseDesignation != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Number of Kids:</strong>  {int_int_data && int_int_data.no_of_kids != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)} {int_int_data && int_int_data.InterviewRoundName != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p>
                                    <p><strong>Languages Known:</strong> {int_int_data && int_int_data.LanguagesKnown != undefined ? (<span>{int_int_data.InterviewRoundName}</span>) : (<></>)}</p> */}
                                                                        <p><strong>Interview Status:</strong>  {int_int_data && int_int_data.interview_Status != undefined ? (<span>{int_int_data.interview_Status}</span>) : (<></>)}</p>
                                                                        <p><strong>Reviewed By:</strong>  {int_int_data && int_int_data.ReviewedBy != undefined ? (<span>{int_int_data.ReviewedBy}</span>) : (<></>)}</p>
                                                                        <p><strong>Signature:</strong>  {int_int_data && int_int_data.Signature != undefined ? (<span>{int_int_data.Signature}</span>) : (<></>)}</p>
                                                                        <p><strong>Reviewed On:</strong>  {int_int_data && int_int_data.ReviewedOn != undefined ? (<span>{int_int_data.ReviewedOn}</span>) : (<></>)}</p>
                                                                        <p><strong>Comments:</strong>  {int_int_data && int_int_data.Comments != undefined ? (<span>{int_int_data.Comments}</span>) : (<></>)}</p>





                                                                    </div>
                                                                </div>
                                                                {/* Interview Round end */}


                                                            </div>


                                                        </div>
                                                        <div class="modal-footer d-flex justify-content-between">
                                                            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                            <div class="d-flex gap-2">


                                                                <div class={` gap-2 ${int_int_data != null ? 'd-none' : ''}`}>
                                                                    <button className='btn btn-sm btn-success' data-bs-toggle="modal" data-bs-target="#exampleModal15" >Proceed</button>
                                                                </div>

                                                                {/* <button type="button" class="btn btn-info btn-sm" data-bs-target="#exampleModalToggle7" data-bs-toggle="modal">Download</button> */}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                            {/* open Particular Data End */}


                                        </table>
                                    </div>
                                    <div className='d-flex justify-content-between p-2'>
                                        <button onClick={loadmorefunc3} className='btn btn-sm btn-success'>Load More</button>
                                        <div>
                                            <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload2}>
                                                {downloading ? 'Downloading...' : 'Download'}
                                            </button>
                                            {/* <a href={down} download="data.xlsx">Down </a> */}

                                            {/* <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal9" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button> */}

                                            <div class="modal fade" id="exampleModal9" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div className="modal-body">
                                                            {/* File input */}
                                                            <input
                                                                type="file"
                                                                className="form-control-file"
                                                                onChange={handleFileChange}
                                                                accept=".csv, .xlsx, .txt" // Specify allowed file types if needed
                                                            />
                                                        </div>
                                                        <div className="modal-footer">

                                                            <button
                                                                type="button"
                                                                className="btn btn-primary"
                                                                onClick={uploadFile}
                                                                disabled={!selectedFile}
                                                            >
                                                                Upload
                                                            </button>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                    </div>

                                </div>

                                {/* Tab 3 end */}

                                {/* Tab 4 start */}
                                <div class="tab-pane fade " id="pills-completed" role="tabpanel" aria-labelledby="pills-completed-tab" tabindex="0" >


                                    <div className='d-flex justify-content-between mb-4 ' style={{ position: 'absolute', top: '185px', width: '78%' }}>

                                        <ul class="nav nav-pills mb-1 w-100" style={{ display: 'flex', justifyContent: 'space-between' }} id="pills-tab" role="tablist">

                                            <div>
                                                <li class="nav-item  d-flex " >
                                                    <input type="text" className='applyedlistsearch' style={{ width: '200px', height: '26px', fontSize: '9px', borderRadius: '7px', border: '1px solid rgb(222,226,230)', paddingLeft: '25px', outline: 'none' }}
                                                        value={searchFinalValue}
                                                        onChange={(e) => setFinalValue(e.target.value)}
                                                    />
                                                    <i class="fa-solid fa-magnifying-glass " onClick={() => {
                                                        handlesearchFinalValuesearchvalue({ 'search_value': searchValue })
                                                    }} style={{ fontSize: '12px', position: 'relative', right: '20px', top: '8px' }}></i>


                                                </li>
                                            </div>

                                            <div>
                                                <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >

                                                    <select className="form-select shadow-none" id="ageGroup" style={{ width: '80px', height: '26px', fontSize: '9px', outline: 'none' }}
                                                        value={search_filter_Final} onChange={(e) => {
                                                            setsearch_filter_Final(e.target.value)
                                                            handlesearchFinalValuesearchvalue({ 'duration': e.target.value })
                                                        }} >
                                                        <option value="">Filter</option>
                                                        <option value="Today">Day</option>
                                                        <option value="Week">Week</option>
                                                        <option value="Month">Month</option>
                                                        <option value="Year">Year</option>
                                                    </select>

                                                </li>
                                            </div>


                                        </ul>

                                    </div>


                                    <div className='rounded mt-4'>
                                        <table class="table caption-top     table-hover">
                                            <thead >
                                                <tr >

                                                    <th scope="col"><span className='fw-medium'>All</span></th>
                                                    <th scope="col"><span className='fw-medium'>Name</span></th>
                                                    <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                                                    <th scope="col"><span className='fw-medium'>Email</span></th>
                                                    <th scope="col"><span className='fw-medium'>Phone</span></th>
                                                    <th scope="col"><span className='fw-medium'>Applied Designation</span></th>

                                                    <th scope="col"><span className='fw-medium'>Final Result</span></th>






                                                </tr>
                                            </thead>
                                            {FinalData != undefined && FinalData != undefined && FinalData.slice(0, load3).map((e) => {
                                                return (

                                                    <tbody>
                                                        <tr>
                                                            <th scope="row"><input type="checkbox" value={e.CandidateId} onChange={handleCheckboxChange3} /></th>

                                                            <td key={e.id}> {e.CandidateId}</td>
                                                            <td key={e.id} onClick={() => Callfinal_details_data(e.CandidateId, e.id)} data-bs-toggle="modal" data-bs-target="#exampleModal12" style={{ cursor: 'pointer', color: 'blue' }}>{e.FirstName}</td>
                                                            <td key={e.id}>{e.Email}</td>
                                                            <td key={e.id}>{e.PrimaryContact}</td>
                                                            <td key={e.id}>{e.AppliedDesignation}</td>
                                                            {/* <td onClick={() => Callfinal_details_data(e.CandidateId)} className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal12">
                                details
                              </button>
                              </td> */}
                                                            <td>
                                                                <div>
                                                                    {/* <label htmlFor="ageGroup" className="form-label">Interview Status:</label> */}
                                                                    <select className="form-select" id="ageGroup" value={e.FinalResult} onChange={(d) => {
                                                                        setseleceted_candidateid(e.CandidateId)
                                                                        setfinal_status_value(d.target.value)
                                                                        setselectstatus(true)
                                                                    }}>
                                                                        <option value="">Pending</option>
                                                                        <option value="consider to client">Consider to Client for Merida </option>
                                                                        <option value="Internal Hiring">Internal Hireing</option>
                                                                        <option value="Reject">Reject</option>
                                                                        <option value="On Hold">On Hold</option>

                                                                    </select>
                                                                </div>

                                                            </td>

                                                        </tr>
                                                    </tbody>

                                                )
                                            })}


                                            {/* open Particular Data Start */}


                                            <div class="modal fade" id="exampleModal12" tabindex="-1" aria-labelledby="exampleModalLabel12" aria-hidden="false">
                                                <div class="modal-dialog modal-fullscreen">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h1>Candidate All Information</h1>

                                                            <button type="button" class="btn-close" onClick={() => { window.location.reload() }} data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="modal-body container-fluid ">

                                                                {/* Candidate Information start */}

                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Candidate Information</h5>

                                                                    <div className="col-lg-12 p-4 border rounded-lg">


                                                                        <p><strong>ID:</strong> {Canditateinformation.id}</p>
                                                                        <p><strong>Candidate ID:</strong> {Canditateinformation.CandidateId}</p>
                                                                        <p><strong>First Name:</strong> {Canditateinformation.FirstName}</p>
                                                                        <p><strong>Last Name:</strong> {Canditateinformation.LastName}</p>
                                                                        <p><strong>Email:</strong> {Canditateinformation.Email}</p>
                                                                        <p><strong>Primary Contact:</strong> {Canditateinformation.PrimaryContact}</p>
                                                                        <p><strong>Secondary Contact:</strong> {Canditateinformation.SecondaryContact}</p>
                                                                        <p><strong>Location:</strong> {Canditateinformation.Location}</p>
                                                                        <p><strong>Gender:</strong> {Canditateinformation.Gender}</p>
                                                                        <p><strong>Fresher / Experience:</strong> {Canditateinformation.Experience ? "Experience" : "Fresher"}</p>
                                                                        <p><strong>Highest Qualification:</strong> {Canditateinformation.HighestQualification}</p>
                                                                        <p><strong>University:</strong> {Canditateinformation.University}</p>
                                                                        <p><strong>Specialization:</strong> {Canditateinformation.Specialization}</p>
                                                                        <p><strong>Percentage:</strong> {Canditateinformation.Percentage}</p>
                                                                        <p><strong>Year of Passout:</strong> {Canditateinformation.YearOfPassout}</p>

                                                                        <p><strong>Applied Designation:</strong> {Canditateinformation.AppliedDesignation}</p>
                                                                        <p><strong>Notice Period:</strong> {Canditateinformation.NoticePeriod}</p>
                                                                        <p><strong>Current Designation:</strong> {Canditateinformation.CurrentDesignation}</p>
                                                                        <p><strong>Current CTC:</strong> {Canditateinformation.CurrentCTC}</p>
                                                                        <p><strong>Total Experience:</strong> {Canditateinformation.TotalExperience}</p>
                                                                        <p><strong>Technical Skills with Experience:</strong> {Canditateinformation.TechnicalSkills_with_Exp}</p>
                                                                        <p><strong>General Skills with Experience:</strong> {Canditateinformation.GeneralSkills_with_Exp}</p>
                                                                        <p><strong>Soft Skills with Experience:</strong> {Canditateinformation.SoftSkills_with_Exp}</p>
                                                                        <p><strong>Expected Salary:</strong> {Canditateinformation.ExpectedSalary}</p>
                                                                        <p><strong>Contacted By:</strong> {Canditateinformation.ContactedBy}</p>
                                                                        <p><strong>Job Portal Source:</strong> {Canditateinformation.JobPortalSource}</p>
                                                                        <p><strong>Applied Date:</strong> {Canditateinformation.AppliedDate}</p>


                                                                    </div>
                                                                </div>
                                                                {/* Candidate Information end */}

                                                                {/* Interview Round start */}
                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Interview Round</h5>

                                                                    <div className="col-lg-12 p-4 border rounded-lg">



                                                                        {Canditateinterviewdata.map((interview, index) => (
                                                                            <div key={index}>

                                                                                <p><strong>Interview Round  : </strong> {index + 1}</p>
                                                                                <h5><strong>Interview Round Name : </strong> {interview.InterviewRoundName}</h5>
                                                                                <p><strong>Candidate:</strong> {interview.Candidate}</p>
                                                                                <p><strong>Interview Date:</strong> {interview.InterviewDate}</p>
                                                                                <p><strong>Interview Type:</strong> {interview.InterviewType}</p>
                                                                                <p><strong>Scheduled By:</strong> {interview.ScheduledBy}</p>
                                                                                <p><strong>Scheduled On:</strong> {interview.ScheduledOn}</p>
                                                                                <p><strong>Task Assigned:</strong> {interview.TaskAssigned}</p>
                                                                                <p><strong>Interviewer:</strong> {interview.interviewer}</p>
                                                                                <hr />
                                                                                <h5 className='fw-bold text-primary'>Interview Review</h5>
                                                                                <p><strong>Name :</strong> {interview.Intrview_review.Name}</p>
                                                                                <p><strong>CandidateId :</strong> {interview.Intrview_review.CandidateId} </p>
                                                                                <p><strong>PositionAppliedFor :</strong> {interview.Intrview_review.PositionAppliedFor}</p>
                                                                                <p><strong>SourceBy :</strong> {interview.Intrview_review.SourceBy} </p>
                                                                                <p><strong>SourceName :</strong> {interview.Intrview_review.SourceName}</p>
                                                                                <p><strong>Date :</strong>{interview.Intrview_review.Date} </p>
                                                                                <p><strong>LocationAppliedFor :</strong> {interview.Intrview_review.LocationAppliedFor} </p>
                                                                                <p><strong>Contact :</strong> {interview.Intrview_review.Contact}</p>
                                                                                <p><strong>Qualification :</strong> {interview.Intrview_review.Qualification} </p>
                                                                                <p><strong>RelatedExperience :</strong>  {interview.Intrview_review.RelatedExperience}</p>
                                                                                <p><strong>JobStabilityWithPreviousEmployers :</strong>  {interview.Intrview_review.JobStabilityWithPreviousEmployers}</p>
                                                                                <p><strong>ReasionForLeavingImadiateEmployeer :</strong> {interview.Intrview_review.ReasionForLeavingImadiateEmployeer} </p>
                                                                                <p><strong>Appearence_and_Personality :</strong> {interview.Intrview_review.Appearence_and_Personality} </p>
                                                                                <p><strong>ClarityOfThought :</strong>  {interview.Intrview_review.ClarityOfThought}</p>
                                                                                <p><strong>EnglishLanguageSkills :</strong> {interview.Intrview_review.EnglishLanguageSkills}</p>
                                                                                <p><strong>AwarenessOnTechnicalDynamics :</strong> {interview.Intrview_review.AwarenessOnTechnicalDynamics} </p>
                                                                                <p><strong>InterpersonalSkills :</strong> {interview.Intrview_review.InterpersonalSkills} </p>
                                                                                <p><strong>ConfidenceLevel :</strong> {interview.Intrview_review.ConfidenceLevel} </p>
                                                                                <p><strong>AgeGroupSuitability :</strong> {interview.Intrview_review.AgeGroupSuitability} </p>
                                                                                <p><strong>Analytical_and_logicalReasoningSkills :</strong> {interview.Intrview_review.Analytical_and_logicalReasoningSkills} </p>
                                                                                <p><strong>CareerPlans :</strong> {interview.Intrview_review.CareerPlans} </p>
                                                                                <p><strong>AchivementOrientation :</strong> {interview.Intrview_review.AchivementOrientation} </p>
                                                                                <p><strong>ProblemSolvingAbilites :</strong> {interview.Intrview_review.ProblemSolvingAbilites} </p>
                                                                                <p><strong>AbilityToTakeChallenges :</strong> {interview.Intrview_review.AbilityToTakeChallenges} </p>
                                                                                <p><strong>LeadershipAbilities :</strong> {interview.Intrview_review.LeadershipAbilities}  </p>
                                                                                <p><strong>IntrestWithCompany :</strong> {interview.Intrview_review.IntrestWithCompany} </p>
                                                                                <p><strong>ResearchedAboutCompany :</strong> {interview.Intrview_review.ResearchedAboutCompany} </p>
                                                                                <p><strong>HandelTargets_Pressure :</strong> {interview.Intrview_review.HandelTargets_Pressure} </p>
                                                                                <p><strong>CustomerService :</strong> {interview.Intrview_review.CustomerService} </p>
                                                                                <p><strong>OverallCandidateRanking :</strong> {interview.Intrview_review.OverallCandidateRanking} </p>
                                                                                <p><strong>LastCTC :</strong> {interview.Intrview_review.LastCTC}  </p>
                                                                                <p><strong>ExpectedCTC :</strong> {interview.Intrview_review.ExpectedCTC} </p>
                                                                                <p><strong>NoticePeriod :</strong> {interview.Intrview_review.NoticePeriod} </p>
                                                                                <p><strong>DOJ :</strong> {interview.Intrview_review.DOJ} </p>
                                                                                <p><strong>Six_Days_Working :</strong> {interview.Intrview_review.Six_Days_Working} </p>
                                                                                <p><strong>FlexibilityOnWorkTimings :</strong> {interview.Intrview_review.FlexibilityOnWorkTimings} </p>
                                                                                <p><strong>CertificateSubmittion :</strong> {interview.Intrview_review.CertificateSubmittion} </p>
                                                                                <p><strong>RelocateToOtherCity :</strong> {interview.Intrview_review.RelocateToOtherCity} </p>
                                                                                <p><strong>RelocateToOtherCenters :</strong> {interview.Intrview_review.RelocateToOtherCenters}  </p>
                                                                                <p><strong>ScreeningFeedback :</strong> {interview.Intrview_review.ScreeningFeedback}</p>


                                                                            </div>
                                                                        ))}


                                                                    </div>
                                                                </div>
                                                                {/* Interview Round end */}

                                                                {/*  Screening Round  start */}
                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Screening Round</h5>

                                                                    <div className="col-lg-12 p-4 border rounded-lg">

                                                                        {Canditatescreeningdata.map((screening, index) => (
                                                                            <div key={index}>

                                                                                <p><strong>AssignedBy :</strong> {screening.AssignedBy}</p>
                                                                                <p><strong>Candidate :</strong> {screening.Candidate}</p>
                                                                                <p><strong>Date_of_assigned :</strong> {screening.Date_of_assigned}</p>
                                                                                <p><strong>Recruiter :</strong> {screening.Recruiter}</p>
                                                                                <p><strong>Id :</strong> {screening.id}</p>

                                                                                <hr />
                                                                                <h5 className='fw-bold text-primary'>Screening Review</h5>
                                                                                <p><strong>CandidateId : </strong> {screening.screening_review.CandidateId} </p>
                                                                                <p><strong>Comments : </strong> {screening.screening_review.Comments} </p>
                                                                                <p><strong>ExpectedCTC : </strong> {screening.screening_review.ExpectedCTC} </p>
                                                                                <p><strong>InterviewScheduleDate : </strong> {screening.screening_review.InterviewScheduleDate} </p>
                                                                                <p><strong>LastCTC : </strong> {screening.screening_review.LastCTC} </p>
                                                                                <p><strong>Name : </strong> {screening.screening_review.Name} </p>
                                                                                <p><strong>PositionAppliedFor : </strong> {screening.screening_review.PositionAppliedFor} </p>
                                                                                <p><strong>ReviewedBy : </strong> {screening.screening_review.ReviewedBy} </p>
                                                                                <p><strong>ReviewedOn : </strong> {screening.screening_review.ReviewedOn} </p>
                                                                                <p><strong>Screening_Status : </strong> {screening.screening_review.Screening_Status} </p>
                                                                                <p><strong>Signature : </strong> {screening.screening_review.Signature} </p>
                                                                                <p><strong>SourceBy : </strong> {screening.screening_review.SourceBy} </p>
                                                                                <p><strong>SourceName : </strong> {screening.screening_review.SourceName} </p>
                                                                                <p><strong>TotalYearOfExp : </strong> {screening.screening_review.TotalYearOfExp} </p>



                                                                            </div>

                                                                        ))}


                                                                    </div>
                                                                </div>
                                                                {/*  Screening Round end */}

                                                                {/*  Uploaded Documents  start */}
                                                                <div className="row justify-content-center m-0">
                                                                    <h5 className='mt-4 text-primary'>Uploaded Documents</h5>


                                                                    <div className="col-lg-12 p-4 border rounded-lg">

                                                                        {CanditateUploadedDocuments.map((e, index) => (
                                                                            <div key={index}>



                                                                                <p><strong>ID: </strong> {e.id}</p>
                                                                                <p><strong>Name: </strong> {e.Name}</p>
                                                                                <p><strong>Previous Company: </strong> {e.Provious_Company}</p>
                                                                                <p><strong>Previous Designation: </strong> {e.Provious_Designation}</p>
                                                                                <p><strong>Experience: </strong> {e.experience} years</p>
                                                                                <p><strong>From Date: </strong> {e.from_date}</p>
                                                                                <p><strong>To Date: </strong> {e.To_date}</p>
                                                                                <p><strong>Current CTC: </strong> {e.Current_CTC}</p>
                                                                                <p><strong>Reporting Manager Name: </strong> {e.Reporting_Manager_name}</p>
                                                                                <p><strong>Reporting Manager Email: </strong> {e.Reporting_Manager_email}</p>
                                                                                <p><strong>Reporting Manager Phone: </strong> {e.ReportingManager_phone}</p>
                                                                                <p><strong>HR Name: </strong> {e.HR_name}</p>
                                                                                <p><strong>HR Email: </strong> {e.HR_email}</p>
                                                                                <p><strong>HR Phone: </strong> {e.HR_phone}</p>
                                                                                <p><strong>Salary Drawn Payslips: </strong> <a href={e.Salary_Drawn_Payslips} target="_blank" rel="noopener noreferrer">Download</a></p>
                                                                                <p><strong>Document: </strong> <a href={e.Document} target="_blank" rel="noopener noreferrer">Download</a></p>
                                                                                <p><strong>Candidate ID: </strong> {e.CandidateID}</p>
                                                                                <p><strong>Mail Sent By: </strong> {e.mail_sended_by}</p>
                                                                                <div className='d-flex'>



                                                                                    <button className='btn btn-warning btn-sm' onClick={() => handleSubmit123(e.id, e.CandidateID)} data-bs-dismiss="modal" >Sent Mail</button>




                                                                                    <button className='btn btn-success btn-sm ms-3' onClick={() => { setCandid_id(e.id) }} data-bs-target="#exampleModal24" data-bs-toggle="modal">Verify</button>




                                                                                </div>


                                                                            </div>
                                                                        ))}


                                                                    </div>

                                                                </div>
                                                            </div>
                                                            {/*  Uploaded Documents end */}

                                                            {/*  BackGroungVerification  start */}
                                                            {/* <div className="row justify-content-center m-0">
                                <h5 className='mt-4 text-primary'> BackGround Verification</h5>

                                <div className="col-lg-12 p-4 border rounded-lg">
                                  <p><strong>Applied Date:</strong> {CanditateBackGroungVerification.CandidatePerformanceLevel}</p>
                                  <p><strong>Verifiers Name:</strong> {CanditateBackGroungVerification.VerifiersName}</p>
                                  <p><strong>Verifiers Designation:</strong> {CanditateBackGroungVerification.VerifiersDesignation}</p>
                                  <p><strong>Verifiers Employer:</strong> {CanditateBackGroungVerification.VerifiersEmployer}</p>
                                  <p><strong>Verifiers Phone Number:</strong> {CanditateBackGroungVerification.VerifiersPhoneNumber}</p>
                                  <p><strong>Candidate Knows:</strong> {CanditateBackGroungVerification.CandidateKnows}</p>
                                  <p><strong>Candidate Designation:</strong> {CanditateBackGroungVerification.CandidateDesignation}</p>
                                  <p><strong>Candidate Works From:</strong> {CanditateBackGroungVerification.CandidateWorksFrom}</p>
                                  <p><strong>Candidate Reporting To:</strong> {CanditateBackGroungVerification.CandidateReportingTo}</p>
                                  <p><strong>Candidate Positives:</strong> {CanditateBackGroungVerification.CandidatePositives}</p>
                                  <p><strong>Candidate Negatives:</strong> {CanditateBackGroungVerification.CandidateNegatives}</p>
                                  <p><strong>Candidate's Performance Feedback:</strong> {CanditateBackGroungVerification.CandidatesPerformanceFeedBack}</p>
                                  <p><strong>Candidate Performance Level:</strong> {CanditateBackGroungVerification.CandidatePerformanceLevel}</p>
                                  <p><strong>Candidate's Ability:</strong> {CanditateBackGroungVerification.Candidates_ability}</p>
                                  <p><strong>Candidate Achieve Targets:</strong> {CanditateBackGroungVerification.Candidates_Achieve_Targets}</p>
                                  <p><strong>Candidate Behavior Feedback:</strong> {CanditateBackGroungVerification.Candidate_Behavior_Feedback}</p>
                                  <p><strong>Candidate Leaving Reason:</strong> {CanditateBackGroungVerification.Candidate_Leaving_Reason}</p>
                                  <p><strong>Candidate Rehire:</strong> {CanditateBackGroungVerification.Candidate_Rehire}</p>
                                  <p><strong>Comments On Candidate:</strong> {CanditateBackGroungVerification.Comments_On_Candidate}</p>
                                  <p><strong>Package Offered:</strong> {CanditateBackGroungVerification.PackageOffered}</p>
                                  <p><strong>Ever Handled Team:</strong> {CanditateBackGroungVerification.Ever_Handled_Team}</p>
                                  <p><strong>Team Size:</strong> {CanditateBackGroungVerification.TeamSize}</p>
                                  <p><strong>Final Verify Status:</strong> {CanditateBackGroungVerification.FinalVerifyStatus}</p>
                                  <p><strong>Remarks:</strong> {CanditateBackGroungVerification.Remarks}</p>
                                  <p><strong>Candidate:</strong> {CanditateBackGroungVerification.candidate}</p>
                                  <p><strong>Documents:</strong> {CanditateBackGroungVerification.Documents}</p>


                                </div>
                              </div> */}
                                                            {/*   BackGroungVerification end */}
                                                            <div className="row d-flex justify-content-between m-0 w-100 mt-4">

                                                                <div className='w-50'>
                                                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                                </div>


                                                                <div className='w-50 d-flex justify-content-end'>

                                                                    <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={() => handle_all_info(Canditateinformation.CandidateId)}>
                                                                        {downloading ? 'Downloading...' : 'Download'}
                                                                    </button>
                                                                </div>

                                                            </div>

                                                        </div>


                                                    </div>

                                                </div>
                                            </div>



                                            {/* open Particular Data End */}


                                        </table>
                                    </div>
                                    <div className='d-flex justify-content-between p-2'>
                                        <button onClick={loadmorefunc3} className='btn btn-sm btn-success'>Load More</button>
                                        <div>
                                            <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload3}>
                                                {downloading ? 'Downloading...' : 'Download'}
                                            </button>
                                            {/* <a href={down} download="data.xlsx">Down </a> */}

                                            {/* <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button> */}

                                            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div className="modal-body">
                                                            {/* File input */}
                                                            <input
                                                                type="file"
                                                                className="form-control-file"
                                                                onChange={handleFileChange}
                                                                accept=".csv, .xlsx, .txt" // Specify allowed file types if needed
                                                            />
                                                        </div>
                                                        <div className="modal-footer">

                                                            <button
                                                                type="button"
                                                                className="btn btn-primary"
                                                                onClick={uploadFile}
                                                                disabled={!selectedFile}
                                                            >
                                                                Upload
                                                            </button>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                    </div>


                                </div>
                                {/* Tab 4 end */}

                            </div>

                            {/* Nav Tabs end  */}




                        </div>
                    </div>

                    {/* Interview sehudle */}

                    <div class="modal fade" id="exampleModalToggle5" aria-hidden="true" aria-labelledby="exampleModalToggleLabel5" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered ">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="exampleModalToggleLabel5">Schedule Interview </h1>
                                    {/* <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> */}
                                    {ScheduleinterviewAlert && (
                                        <Alert style={{ position: 'absolute', bottom: '5px', left: '540px', width: '350px', zIndex: '1000' }} severity="success" onClose={() => { setScheduleinterviewAlert(false); window.location.reload(); }}>
                                            <AlertTitle>Success</AlertTitle>
                                            Interview Schedule successfully ..
                                        </Alert>
                                    )}
                                </div>
                                <div class="modal-body">
                                    <form id="interviewForm" onSubmit={handleSubmit} class="styled-form">
                                        <div class="form-group">
                                            <label for="candidateId">Candidate ID:</label>
                                            <input type="text" id="CandidateId" value={persondata.CandidateId} class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="interviewRound">Interview Round Name:</label>
                                            <input type="text" id="InterviewRoundName" value={formData.InterviewRoundName} onChange={handleInputChange} name="InterviewRoundName" required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="taskAssign">Task Assign:</label>
                                            <input type="text" id="TaskAssigned" name="TaskAssigned" value={formData.TaskAssigned} onChange={handleInputChange} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="interviewer">Interviewer:</label>
                                            <select id="interviewer" name="interviewer" value={formData.interviewer} onChange={handleInputChange} required class="form-control">
                                                <option value="" selected>Select Name</option>
                                                {interviewers.map(interviewer => (
                                                    <option key={interviewer.EmployeeId} value={interviewer.EmployeeId}>
                                                        {`${interviewer.EmployeeId},${interviewer.Name}`}
                                                    </option>
                                                ))}
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="interviewDate">Interview Date:</label>
                                            <input type="date" id="InterviewDate" name="InterviewDate" value={formData.InterviewDate} onChange={handleInputChange} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="interviewTime">Interview Time:</label>
                                            <input type="time" id="InterviewTime" name="InterviewDTime" onChange={handleTimeInputChange} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="interviewType">Interview Type:</label>
                                            <input type="text" id="InterviewType" name="InterviewType" value={formData.InterviewType} onChange={handleInputChange} required class="form-control" />
                                        </div>
                                        <div class="form-group d-flex justify-content-between">
                                            <button class="btn btn-primary">Send Email</button>
                                            <button type="submit" class="btn btn-success">Schedule Interview</button>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>

                    {/* BG document verification Form */}

                    <div class="modal fade" id="exampleModal24" tabindex="-1" aria-labelledby="exampleModalLabel24" aria-hidden="false">
                        <div class="modal-dialog modal-fullscreen">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" style={{ backgroundColor: 'transparent !important' }} className='border-0 ' data-bs-dismiss="modal" aria-label="Close" > <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                                        <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                                    </svg></button>

                                    <div className=' d-flex justify-content-center w-100'>
                                        <h3 className='text-primary text-center'>BG Document Verification Form</h3>

                                    </div>

                                </div>
                                <div class="modal-body container-fluid ">
                                    <form >
                                        <div className="row justify-content-center m-0">
                                            <div className="col-lg-12 p-4 border rounded-lg">

                                                <div className="row m-0 pb-2">
                                                    <div className="col-md-6 col-lg-3 mb-3">
                                                        <label htmlFor="Name" className="form-label">Candidate Id</label>
                                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Canditateinformation.CandidateId} required />
                                                    </div>
                                                </div>

                                                <div className="row m-0 pb-2">
                                                    <div className="col-md-6 col-lg-3 mb-3">
                                                        <label htmlFor="lastName" className="form-label">Verifiers Name</label>
                                                        <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={UserName} required />
                                                    </div>
                                                    <div className="col-md-6 col-lg-3 mb-3">
                                                        <label htmlFor="email" className="form-label">Verifiers Designation</label>
                                                        <input type="text" className="form-control shadow-none" id="Email" name="Email" value={Disgnation} required />
                                                    </div>
                                                    <div className="col-md-6 col-lg-3 mb-3">
                                                        <label htmlFor="primaryContact" className="form-label">Verifiers Employer</label>
                                                        <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={verifiersEmployer} onChange={(e) => setVerifiersEmployer(e.target.value)} required />
                                                    </div>
                                                    <div className="col-md-6 col-lg-3 mb-3">
                                                        <label htmlFor="secondaryContact" className="form-label">Verifiers Phone Number</label>
                                                        <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={PhoneNumber} required />
                                                    </div>

                                                    {/*  */}

                                                    <div className="row mt-4 pb-2">
                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="candidateKnows" className="form-label">Do you know the candidate ?</label>
                                                            <select className="form-select " id="candidateKnows" value={candidateKnows} onChange={(e) => setCandidateKnows(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="yes">Yes</option>
                                                                <option value="no">No</option>
                                                            </select>
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateDesignation" className="form-label">Candidates designation when worked with you ?</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateDesignation" name="candidateDesignation" value={candidateDesignation} onChange={(e) => setCandidateDesignation(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateWorksFrom" className="form-label">For how long did the candidate work with you?</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateWorksFrom" name="candidateWorksFrom" value={candidateWorksFrom} onChange={(e) => setCandidateWorksFrom(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateReportingTo" className="form-label">Was the candidate directly reporting to you?</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateReportingTo" name="candidateReportingTo" value={candidateReportingTo} onChange={(e) => setCandidateReportingTo(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidatePositives" className="form-label">Candidates Positives</label>
                                                            <input type="text" className="form-control shadow-none" id="candidatePositives" name="candidatePositives" value={candidatePositives} onChange={(e) => setCandidatePositives(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateNegatives" className="form-label">Candidates Areas of Improvement (negatives)</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateNegatives" name="candidateNegatives" value={candidateNegatives} onChange={(e) => setCandidateNegatives(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidatePerformanceFeedback" className="form-label">Your feedback on the candidates performance (Ask to rate as</label>
                                                            <input type="number" className="form-control shadow-none" id="candidatePerformanceFeedback" name="candidatePerformanceFeedback" value={candidatePerformanceFeedback} onChange={(e) => setCandidatePerformanceFeedback(e.target.value)} required />
                                                        </div>
                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="candidatePerformanceLevel" className="form-label text-success">Excellent Good Average</label>
                                                            <select className="form-select " id="candidatePerformanceLevel" value={candidatePerformanceLevel} onChange={(e) => setCandidatePerformanceLevel(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="Excellent">Excellent</option>
                                                                <option value="Good">Good</option>
                                                                <option value="Average">Average</option>
                                                            </select>
                                                        </div>

                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="candidatePerformanceLevel" className="form-label text-success">Candidate’s ability to work under Target & handle Target Pressure?</label>
                                                            <select className="form-select " id="candidatePerformanceLevel" value={candidateAbility} onChange={(e) => setCandidateAbility(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="Excellent">Excellent</option>
                                                                <option value="Good">Good</option>
                                                                <option value="Average">Average</option>
                                                            </select>
                                                        </div>

                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateAchieveTargets" className="form-label">Candidate’s ability to achieve Targets? On an average what would be the Target Vs Achieved %?</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateAchieveTargets" name="candidateAchieveTargets" value={candidateAchieveTargets} onChange={(e) => setCandidateAchieveTargets(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateBehaviorFeedback" className="form-label">Your feedback on Candidates behavior, integrity & work ethics</label>
                                                            <input type="number" className="form-control shadow-none" id="candidateBehaviorFeedback" name="candidateBehaviorFeedback" value={candidateBehaviorFeedback} onChange={(e) => setCandidateBehaviorFeedback(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="candidateLeavingReason" className="form-label">Candidates reason for leaving</label>
                                                            <input type="text" className="form-control shadow-none" id="candidateLeavingReason" name="candidateLeavingReason" value={candidateLeavingReason} onChange={(e) => setCandidateLeavingReason(e.target.value)} required />
                                                        </div>
                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="candidateRehire" className="form-label text-success">Is the candidate eligible for rehire?</label>
                                                            <select className="form-select " id="candidateRehire" value={candidateRehire} onChange={(e) => setCandidateRehire(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="yes">Yes</option>
                                                                <option value="no">No</option>
                                                            </select>
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="commentsOnCandidate" className="form-label">Your Comments on the Candidate?</label>
                                                            <input type="text" className="form-control shadow-none" id="commentsOnCandidate" name="commentsOnCandidate" value={commentsOnCandidate} onChange={(e) => setCommentsOnCandidate(e.target.value)} required />
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="packageOffered" className="form-label">Package offered?</label>
                                                            <input type="text" className="form-control shadow-none" id="packageOffered" name="packageOffered" value={packageOffered} onChange={(e) => setPackageOffered(e.target.value)} required />
                                                        </div>
                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="everHandledTeam" className="form-label text-success">Ever Handled Team</label>
                                                            <select className="form-select " id="everHandledTeam" value={everHandledTeam} onChange={(e) => setEverHandledTeam(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="yes">Yes</option>
                                                                <option value="no">No</option>
                                                            </select>
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="teamSize" className="form-label">Team Size</label>
                                                            <input type="number" className="form-control shadow-none" id="teamSize" name="teamSize" value={teamSize} onChange={(e) => setTeamSize(e.target.value)} required />
                                                        </div>
                                                        <div className="mb-3  col-md-6 col-lg-12">
                                                            <label htmlFor="finalVerifyStatus" className="form-label text-success">Final Verify Status</label>
                                                            <select className="form-select " id="finalVerifyStatus" value={finalVerifyStatus} onChange={(e) => setFinalVerifyStatus(e.target.value)} required>
                                                                <option value="">Select</option>
                                                                <option value="True">Yes</option>
                                                                <option value="False">No</option>
                                                            </select>
                                                        </div>
                                                        <div className="col-md-6 col-lg-12 mb-3">
                                                            <label htmlFor="remarks" className="form-label">Remarks</label>
                                                            <input type="text" className="form-control shadow-none" id="remarks" name="remarks" value={remarks} onChange={(e) => setRemarks(e.target.value)} required />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </form>

                                </div>
                                <div class="modal-footer d-flex justify-content-end">

                                    <div className='d-flex gap-2'>

                                        <button type="button" class="btn btn-primary btn-sm">Preview</button>

                                        <button type="submit" class="btn btn-success btn-sm" onClick={Documentverifyform} >Submit</button>


                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* upload Doc */}

                    <div class="modal fade" id="exampleModalToggle6" aria-hidden="true" aria-labelledby="exampleModalToggleLabel6" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered ">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="exampleModalToggleLabel6">Upload Document</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="interviewForm" onSubmit={handleUpladdoc} class="styled-form">
                                        <div class="form-group">
                                            <label for="candidateId">Candidate ID :</label>
                                            <input type="text" id="CandidateId" value={persondata.CandidateId} name="InterviewRoundName" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateName">Name :</label>
                                            <input type="text" id="CandidateName" value={updocData.CandidateName} onChange={handleInputChange2} name="CandidateName" required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateNameEmail">Email :</label>
                                            <input type="email" id="CandidateNameEmail" name="CandidateNameEmail" value={updocData.CandidateNameEmail} onChange={handleInputChange2} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidatePhone">Phone :</label>
                                            <input type="tel" id="CandidatePhone" name="CandidatePhone" value={updocData.CandidatePhone} onChange={handleInputChange2} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="CandidateDesignation">Applied Designation :</label>
                                            <input type="text" id="CandidateDesignation" name="CandidateDesignation" value={updocData.CandidateDesignation} onChange={handleInputChange2} required class="form-control" />
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

                    <div class="modal fade" id="exampleModalToggle7" aria-hidden="true" aria-labelledby="exampleModalToggleLabel7" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered ">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="exampleModalToggleLabel7">Offer Letter</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="interviewForm" onSubmit={handleOfferletter} class="styled-form">
                                        <div class="form-group">
                                            <label for="OfferName">Name : </label>
                                            <input type="text" id="OfferName" value={offerletterData.OfferName} onChange={handleInputChange1} name="OfferName" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="Email">Email :</label>
                                            <input type="email" id="Email" value={offerletterData.Email} onChange={handleInputChange1} name="Email" required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Designation">Designation :</label>
                                            <input type="text" id="Designation" name="Designation" value={offerletterData.Designation} onChange={handleInputChange1} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Ctc">CTC :</label>
                                            <input type="number" id="Ctc" name="Ctc" value={offerletterData.Ctc} onChange={handleInputChange1} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Workloc">Work Location :</label>
                                            <input type="text" id="Workloc" name="Workloc" value={offerletterData.Workloc} onChange={handleInputChange1} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Offerddate">Offered Date :</label>
                                            <input type="date" id="Offerddate" name="Offerddate" value={offerletterData.Offerddate} onChange={handleInputChange1} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Acceptstatus">Accept Status :</label>
                                            <input type="text" id="Acceptstatus" name="Acceptstatus" value={offerletterData.Acceptstatus} onChange={handleInputChange1} required class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="Lettersendedby">Letter Sended By :</label>
                                            <input type="text" id="Lettersendedby" name="Lettersendedby" value={offerletterData.Lettersendedby} onChange={handleInputChange1} required class="form-control" />
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



                    <div class="tab-pane fade mt-4" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
                        <div class="table-responsive">
                            <h6 className='text-primary'>Followup Leads</h6>
                            <table class="table caption-top">

                                <tbody>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>

                                    </tr>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>

                                    </tr>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>

                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade mt-4" id="contact-tab-pane" role="tabpanel" aria-labelledby="contact-tab" tabindex="0">
                        <div class="table-responsive">
                            <h6 className='text-primary'>Prospects Leads</h6>
                            <table class="table caption-top">
                                <thead>
                                    <tr>
                                        <th scope="col"></th>
                                        <th scope="col"><span className='fw-medium'>Lead Id</span></th>
                                        <th scope="col"><span className='fw-medium'>Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Mobile No</span></th>
                                        <th scope="col"><span className='fw-medium'>Company Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Preffered Course</span></th>
                                        <th scope="col"><span className='fw-medium'>Level of Lead</span></th>
                                        <th scope="col"><span className='fw-medium'>Expected Reg Date</span></th>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td><button className='btn btn-sm text-white' style={{ backgroundColor: '#48C1FF' }}>Register</button></td>
                                        <td><button className='btn btn-sm text-white' style={{ backgroundColor: '#ADAD85' }} data-bs-toggle="modal" data-bs-target="#closedform">Closed</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade mt-4" id="disabled-tab-pane" role="tabpanel" aria-labelledby="disabled-tab" tabindex="0">
                        <div class="table-responsive">
                            <h6 className='text-primary'>Registered Leads</h6>
                            <table class="table caption-top">
                                <thead>
                                    <tr>
                                        <th scope="col"></th>
                                        <th scope="col"><span className='fw-medium'>Lead Id</span></th>
                                        <th scope="col"><span className='fw-medium'>Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Mobile No</span></th>
                                        <th scope="col"><span className='fw-medium'>Company Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Course Enquired</span></th>
                                        <th scope="col"><span className='fw-medium'>Level of Lead</span></th>
                                        <th scope="col"><span className='fw-medium'>Course</span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Otto</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade mt-4" id="closed-tab-pane" role="tabpanel" aria-labelledby="closed-tab" tabindex="0">
                        <div class="table-responsive">
                            <h6 className='text-primary'>Closed Leads</h6>
                            <table class="table caption-top">
                                <thead>
                                    <tr>
                                        <th scope="col"></th>
                                        <th scope="col"><span className='fw-medium'>Lead Id</span></th>
                                        <th scope="col"><span className='fw-medium'>Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Mobile No</span></th>
                                        <th scope="col"><span className='fw-medium'>Company Name</span></th>
                                        <th scope="col"><span className='fw-medium'>Course Enquired</span></th>
                                        <th scope="col"><span className='fw-medium'>Level of Lead</span></th>
                                        <th scope="col"><span className='fw-medium'>Stage of Closure</span></th>
                                        <th scope="col"><span className='fw-medium'>Reason of Closure</span></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td scope="row"><input type="checkbox" /></td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                        <td>@mdo</td>
                                        <td>@mdo</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>


                {/* INTERVIEW FORM start */}
                <div class="modal fade" id="exampleModal15" tabindex="-1" aria-labelledby="exampleModalLabel15" aria-hidden="false">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" style={{ backgroundColor: 'transparent !important' }} className='border-0 ' data-bs-dismiss="modal" aria-label="Close" > <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                                </svg></button>

                                <div className=' d-flex justify-content-center w-100'>
                                    <h3 className='text-primary text-center'>INTERVIEW FORM</h3>

                                </div>

                            </div>
                            <div class="modal-body container-fluid ">
                                <form>
                                    {/* Top inputs  start */}

                                    <div className="row justify-content-center m-0">
                                        <div className="col-lg-12 p-4 border rounded-lg">
                                            <div className="row m-0 pb-2">
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Name" className="form-label">Canditate Id </label>
                                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${int_candi_data.CandidateId}`} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Name" className="form-label">Name </label>
                                                    <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${int_candi_data.FirstName}`} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="lastName" className="form-label">Position Applied For</label>
                                                    <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={int_candi_data.AppliedDesignation} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="email" className="form-label">Source By</label>
                                                    <input type="text" className="form-control shadow-none" id="Email" name="Email" value={sourceBy} onChange={(e) => setSourceBy(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="primaryContact" className="form-label"> Date</label>
                                                    <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={int_candi_data.AppliedDate} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                                                    <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={location} onChange={(e) => setLocation(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                                                    <input type="text" className="form-control shadow-none" id="State" name="State" value={int_candi_data.JobPortalSource} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="secondaryContact" className="form-label">Contact Number</label>
                                                    <input type="tel" className="form-control shadow-none" id="State" name="State" value={Contactnumber} onChange={(e) => setContactNumber(e.target.value)} />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Top inputs  end */}


                                    {/* all inputs start */}
                                    <div className="row justify-content-center m-0 mt-4">
                                        <div className="col-lg-12 p-4 border rounded-lg">
                                            <div className="mb-3">
                                                <label htmlFor="qualification" className="form-label">Qualification:</label>
                                                <input type="text" className="form-control" id="qualification" value={int_candi_data.HighestQualification} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="experience" className="form-label">Related Experience:</label>
                                                <input type="number" className="form-control" id="experience" value={int_candi_data.Experience} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="jobStability" className="form-label">Job Stability with Previous Employer:</label>
                                                <input type="number" className="form-control" id="jobStability" value={jobStability} onChange={(e) => setJobStability(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="reasonLeaving" className="form-label">Reason For Leaving The Immediate Employer:</label>
                                                <input type="text" className="form-control" id="reasonLeaving" value={reasonLeaving} onChange={(e) => setReasonLeaving(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="appearancePersonality" className="form-label">Appearance & Personality:</label>
                                                <input type="number" className="form-control" id="appearancePersonality" value={appearancePersonality} onChange={(e) => setAppearancePersonality(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="clarityThought" className="form-label">Clarity of Thought:</label>
                                                <input type="number" className="form-control" id="clarityThought" value={clarityThought} onChange={(e) => setClarityThought(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="englishSkills" className="form-label">English Language Skills:</label>
                                                <input type="number" className="form-control" id="englishSkills" value={englishSkills} onChange={(e) => setEnglishSkills(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="technicalAwareness" className="form-label">Awareness on Technical Dynamics:</label>
                                                <input type="number" className="form-control" id="technicalAwareness" value={technicalAwareness} onChange={(e) => setTechnicalAwareness(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="interpersonalSkills" className="form-label">Interpersonal Skills / Attitude:</label>
                                                <input type="number" className="form-control" id="interpersonalSkills" value={interpersonalSkills} onChange={(e) => setInterpersonalSkills(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="confidenceLevel" className="form-label">Confidence Level:</label>
                                                <input type="number" className="form-control" id="confidenceLevel" value={confidenceLevel} onChange={(e) => setConfidenceLevel(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="ageGroup" className="form-label">Age Group Suitability:</label>
                                                <select className="form-select" id="ageGroup" value={ageGroup} onChange={(e) => setAgeGroup(e.target.value)}>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>

                                            <div className="mb-3">
                                                <label htmlFor="logicalReasoning" className="form-label">Analytical & Logical Reasoning Skills:</label>
                                                <input type="number" className="form-control" id="logicalReasoning" value={logicalReasoning} onChange={(e) => setLogicalReasoning(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="careerPlans" className="form-label">Career Plans:</label>
                                                <input type="text" className="form-control" id="careerPlans" value={careerPlans} onChange={(e) => setCareerPlans(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="achievementOrientation" className="form-label">Achievement Orientation:</label>
                                                <input type="text" className="form-control" id="achievementOrientation" value={achievementOrientation} onChange={(e) => setAchievementOrientation(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="driveProblemSolving" className="form-label">Drive / Problem Solving Abilities:</label>
                                                <input type="number" className="form-control" id="driveProblemSolving" value={driveProblemSolving} onChange={(e) => setDriveProblemSolving(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="takeUpChallenges" className="form-label">Ability to Take Up Challenges:</label>
                                                <input type="number" className="form-control" id="takeUpChallenges" value={takeUpChallenges} onChange={(e) => setTakeUpChallenges(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="leadershipAbilities" className="form-label">Leadership Abilities:</label>
                                                <input type="number" className="form-control" id="leadershipAbilities" value={leadershipAbilities} onChange={(e) => setLeadershipAbilities(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="companyInterest" className="form-label">Interest With The Company:</label>
                                                <select className="form-select" id="companyInterest" value={companyInterest} onChange={(e) => setCompanyInterest(e.target.value)}>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>

                                            <div className="mb-3">
                                                <label htmlFor="researchCompany" className="form-label">Researched About The Company:</label>
                                                <select className="form-select" id="researchCompany" value={researchCompany} onChange={(e) => setResearchCompany(e.target.value)}>
                                                    <option value="">Select</option>
                                                    <option value="yes">Yes</option>
                                                    <option value="no">No</option>
                                                </select>
                                            </div>

                                            <div className="mb-3">
                                                <label htmlFor="targetPressure" className="form-label">Ability to Handle Targets / Pressure:</label>
                                                <input type="number" className="form-control" id="targetPressure" value={targetPressure} onChange={(e) => setTargetPressure(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="customerService" className="form-label">Customer Service:</label>
                                                <input type="number" className="form-control" id="customerService" value={customerService} onChange={(e) => setCustomerService(e.target.value)} />
                                            </div>
                                            <div className="mb-3">
                                                <label htmlFor="overallRanking" className="form-label">Overall Candidate Ranking (1 to 5):</label>
                                                <input type="number" className="form-control" id="overallRanking" value={overallRanking} onChange={(e) => setOverallRanking(e.target.value)} />
                                            </div>
                                        </div>
                                    </div>
                                    {/* all inputs End */}

                                    {/* For HRD Use only start */}
                                    <h6 className='mt-4 text-primary'>For HRD Use Only</h6>
                                    <div className="row justify-content-center m-0 mt-4">
                                        <div className="col-lg-12 p-4 border rounded-lg">
                                            <div className="row m-0 pb-2">
                                                <div className="col-md-6 col-lg-3 mb-3">
                                                    <label htmlFor="Name" className="form-label">Last CTC </label>
                                                    <input type="text" className="form-control shadow-none" id="LastCTC" name="LastCTC" value={persondata.CurrentCTC} />
                                                </div>
                                                <div className="col-md-6 col-lg-3 mb-3">
                                                    <label htmlFor="lastName" className="form-label">Expected CTC</label>
                                                    <input type="text" className="form-control shadow-none" id="ExpectedCTC" name="ExpectedCTC" value={persondata.ExpectedSalary} />
                                                </div>
                                                <div className="col-md-6 col-lg-3 mb-3">
                                                    <label htmlFor="email" className="form-label">Notice Period</label>
                                                    <input type="text" className="form-control shadow-none" id="NoticePeriod" name="NoticePeriod" value={persondata.NoticePeriod} />
                                                </div>
                                                <div className="col-md-6 col-lg-3 mb-3">
                                                    <label htmlFor="primaryContact" className="form-label">DOJ</label>
                                                    <input type="date" className="form-control shadow-none" id="DOJ" name="DOJ" value={DOJ} onChange={(e) => setDOJ(e.target.value)} />
                                                </div>
                                            </div>

                                            {/*  */}

                                            <div className="row m-0 pb-2 mt-4">

                                                <div className="mb-3  col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label text-success">6 Days Working:</label>
                                                    <select className="form-select " id="ageGroup" value={sixDaysWorking} onChange={(e) => setsixDaysWorking(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="yes">Yes</option>
                                                        <option value="no">No</option>
                                                    </select>
                                                </div>
                                                <div className="mb-3  col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label text-success">Flexibility on Working Timings:</label>
                                                    <select className="form-select " id="ageGroup" value={FlexibilityonWorkingTimings} onChange={(e) => setFlexibilityonWorkingTimings(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="yes">Yes</option>
                                                        <option value="no">No</option>
                                                    </select>
                                                </div>
                                            </div>
                                            {/*  */}

                                            <div className="row m-0 pb-2 mt-4">



                                                <div className="mb-3  col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label">Certification Submission</label>
                                                    <select className="form-select " id="ageGroup" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} >
                                                        <option value="">Select</option>
                                                        <option value="yes">Yes</option>
                                                        <option value="no">No</option>
                                                    </select>
                                                </div>

                                                {/*  */}

                                                <div className="mb-3  col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label">Relocation to other city:</label>
                                                    <select className="form-select " id="ageGroup" value={relocationToCity} onChange={(e) => setRelocationToCity(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="yes">Yes</option>
                                                        <option value="no">No</option>
                                                    </select>
                                                </div>
                                                {/*  */}

                                                {/*  */}

                                                <div className="mb-3 col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label">Relocation to other centers:</label>
                                                    <select className="form-select" id="ageGroup" value={relocationToCenters} onChange={(e) => setRelocationToCenters(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="yes">Yes</option>
                                                        <option value="no">No</option>
                                                    </select>
                                                </div>

                                                {/*  */}

                                                {/*  */}

                                                <div className="mb-3 col-md-6 col-lg-6">
                                                    <label htmlFor="ageGroup" className="form-label">Interview Status:</label>
                                                    <select className="form-select" id="ageGroup" value={Interviewstatus} onChange={(e) => setInterviewstatus(e.target.value)}>
                                                        <option value="">Select</option>
                                                        <option value="Consider to Client">Consider to Client for Merida</option>
                                                        <option value="Internal Hiring">Internal Hiring</option>
                                                        <option value="Reject">Reject</option>
                                                        <option value="On-Hold">On Hold</option>
                                                        <option value="Offerd Did't Accept">Offerd Did't Accept</option>
                                                    </select>
                                                </div>

                                                {/*  */}



                                            </div>
                                        </div>
                                    </div>

                                    {/* For HRD Use only end */}


                                    {/* Personal Details start */}

                                    {/* <h6 className='mt-4 text-primary'>Personal Details</h6>
                    <div className="row justify-content-center m-0 mt-4">
                      <div className="col-lg-12 p-4 border rounded-lg">
                        <div className="row m-0 pb-2">
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Father Designation </label>
                            <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Fatherdesignation} onChange={(e) => setFatherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Mother Designation </label>
                            <input type="text" className="form-control shadow-none" id="Name" name="Name" value={Motherdesignation} onChange={(e) => setMotherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="lastName" className="form-label">Number Of Sibilings</label>
                            <input type="number" className="form-control shadow-none" id="LastName" name="LastName" value={Numberofsib} onChange={(e) => setNumberofsib(e.target.value)} />
                          </div>

                          <div className="mb-3 col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Merital Status</label>
                            <select className="form-select" id="ageGroup" value={Meritalstatus} onChange={(e) => setMeritalStatus(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Single</option>
                              <option value="no">Marrid</option>
                              <option value="no">Widowed</option>
                              <option value="no">Divorced</option>
                            </select>
                          </div>

                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="primaryContact" className="form-label">Spouse Designation</label>
                            <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                            <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Languages Known</label>
                            <input type="text" className="form-control shadow-none" id="State" name="State" value={LanguagesKnown} onChange={(e) => setLanguagesKnown(e.target.value)} />
                          </div>


                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Current Location</label>
                            <input type="text" className="form-control shadow-none" id="State" name="State" value={CurrentLocation} onChange={(e) => setCurrentLocation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">TravellBy</label>
                            <input type="text" className="form-control shadow-none" id="State" name="State" value={TravellBy} onChange={(e) => setTravellBy(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Stay With</label>
                            <input type="text" className="form-control shadow-none" id="State" name="State" value={StayWith} onChange={(e) => setStayWith(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Native</label>
                            <input type="text" className="form-control shadow-none" id="State" name="State" value={Native} onChange={(e) => setNative(e.target.value)} />
                          </div>

                        </div>
                      </div>
                    </div> */}


                                    {/* Personal Details end */}

                                    {/* Comments Start  */}
                                    <h6 className='mt-4 text-primary'>Comments</h6>
                                    <div className="row justify-content-center m-0 mt-4">
                                        <div className="col-lg-12 p-4 border rounded-lg">
                                            <div className="row m-0 pb-2">
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="InterviewerName" className="form-label">Interviewer Name </label>
                                                    <input type="text" className="form-control shadow-none" id="InterviewerName" name="InterviewerName" value={username} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Signature" className="form-label">Signature</label>
                                                    <input type="text" className="form-control shadow-none" id="Signature" name="Signature" value={signature} onChange={(e) => setSignature(e.target.value)} />
                                                </div>
                                                <div className="col-md-6 col-lg-4 mb-3">
                                                    <label htmlFor="Date" className="form-label">Interview Date</label>
                                                    <input type="date" className="form-control shadow-none" id="Date" name="Date" value={date1} onChange={(e) => setDate1(e.target.value)} />
                                                </div>
                                                <div className="col-md-12 col-lg-12 mb-3">
                                                    <label htmlFor="Comments" className="form-label">Comments</label>
                                                    <textarea className="form-control" id="Comments" value={comments} onChange={(e) => setComments(e.target.value)}></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Comments end */}

                                </form>

                            </div>
                            <div class="modal-footer d-flex justify-content-end">

                                <div className='d-flex gap-2'>

                                    <button type="button" class="btn btn-primary btn-sm">Preview</button>

                                    <button type="submit" class="btn btn-success btn-sm" onClick={handleproceedingform} >Submit</button>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* INTERVIEW FORM End */}


            </div >

            <Finalstatuscomment setselectstatus={setselectstatus} final_status_value={final_status_value} selectstatus={selectstatus} candidateid={seleceted_candidateid}></Finalstatuscomment>

        </div >
    )
}

export default Applay