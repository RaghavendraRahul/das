import React, { useContext } from 'react'
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
import Recsidebar from './Recsidebar';
import { toast } from 'react-toastify';
import { HrmStore } from '../Context/HrmContext';
import InfoButton from './SettingComponent/InfoButton';


const Rec_applyed_list = () => {

  let username = JSON.parse(sessionStorage.getItem('user')).UserName
  let permissions = JSON.parse(sessionStorage.getItem('user')).user_permissions
  let { setActivePage } = useContext(HrmStore)
  useEffect(() => {
    setActivePage('applylist')
  }, [])

  const [tab, setTab] = useState("newleads")
  let [interviewStatusAddCan, setinterviewStatusAddcan] = useState()
  let [experiennceAddCall, setExperienceAddCall] = useState(0)
  let [applylist, setApplylist] = useState([])
  let [showModal, setshowModal] = useState(false)
  let [filteredApplyList, setFilteredApplyList] = useState()
 let [filterApplicationObj, setFilterApplicationObj] = useState({
    from: '',
    to: '',
    word: ''
  })
  let handleFilterApplicationChange = (e) => {
    let { name, value } = e.target
    setFilterApplicationObj((prev) => ({
      ...prev,
      [name]: value
    }))
  }
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

    fetchdata3()

  }, [])


  let fetchdata3 = () => {

    axios.get(`${port}/root/FinalList/${Empid}/`).then((res) => {
      console.log("FinalData--- ", res.data);
      setFinalData(res.data)
    }).catch((error) => console.log(error))

  }

  const [Call_Candidates_Lists, set_Call_Candidates_List] = useState([])


  useEffect(() => {

    Call_Candidate_List()
  }, [])

  let Call_Candidate_List = () => {

    axios.get(`${port}/root/called_candidates/`)
      .then((r) => {
        set_Call_Candidates_List(r.data)
        console.log("called_candidates_res", r.data)
      })
      .catch((err) => {
        alert('Candidate add Failed..')
        console.log("called_candidates_err", err)
      })


  }



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
let [loading,setloading]=useState()
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

    if (filterApplicationObj.word || filterApplicationObj.from || filterApplicationObj.to) {
      setloading('applied')
      // alert('here')
      axios.post(`${port}/root/appliedcandidateslist`,
        {
          search_value: filterApplicationObj.word,
          from_date: filterApplicationObj.from,
          to_date: filterApplicationObj.to
        }).then((res) => {
          console.log("search_res", res.data);
          setApplylist(res.data)
          setloading(false)
          setFilteredApplyList(res.data)
        }).catch((err) => {
          setloading(false)

          console.log("search_res", err);
        })
    }
    else {
      fetchdata()
    }





  }

  const handle_filter_apply_value = (value) => {

    console.log('filter_value', value);

    if (value.length > 0) {
      axios.post(`${port}/root/appliedcandidateslist`, { duration: value }).then((res) => {
        console.log("search_res", res.data);
        setApplylist(res.data)
        setFilteredApplyList(res.data)
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

    setScreenValue(value)

    if (value.length > 0) {


      axios.get(`${port}/root/ScreeningScheduleSearch/${value}/`).then((res) => {
        console.log("ScreeningScheduleSearch_Res", res.data);
        setScreeninglist(res.data)
      }).catch((err) => {
        console.log("ScreeningScheduleSearch_Err", err.data);
      })

    }
    else {

      fetchdata1()
    }

  }

  // Interview Search

  const [searchInterviewValue, setInterviewValue] = useState();
  const [search_filter_Interview, setsearch_filter_Interview] = useState();
  console.log("searchValue", searchInterviewValue);

  const handleInterviewearchvalue = (value) => {

    setInterviewValue(value)



    if (value.length > 0) {

      axios.get(`${port}/root/InterviewScheduledSearch/${value}/`).then((res) => {
        console.log("InterviewScheduledSearch", res.data);
        setInterviewlist(res.data)
      }).catch((err) => {
        console.log("InterviewScheduledSearch", err.data);
      })

    }
    else {

      fetchdata2()
    }


  }

  // Final status Search

  const [searchFinalValue, setFinalValue] = useState();
  const [search_filter_Final, setsearch_filter_Final] = useState();
  console.log("searchValue", searchFinalValue);
  const handlesearchFinalValuesearchvalue = (value) => {

    setFinalValue(value)



    // if (value.length > 0) {

    // axios.get(`${port}/root/ScreeningScheduleSearch/${value}/`).then((res) => {
    //   console.log("ScreeningScheduleSearch_Res", res.data);
    //   setFinalData(res.data)
    // }).catch((err) => {
    //   console.log("ScreeningScheduleSearch_Err", err.data);
    // })

    // }
    // else {

    // fetchdata3()
    // }

  }





  useEffect(() => {
    fetchdata()
  }, [])
  const fetchdata = () => {

    axios.post(`${port}/root/appliedcandidateslist`, { 'search_value': searchValue }).then((res) => {
      console.log("Applicand_list", res.data);
      setApplylist(res.data)
      setFilteredApplyList([...res.data].filter((obj) => obj.ScreeningStatus == "Pending")

      )
    })
  }



  useEffect(() => {
    fetchdata1()
  }, [])


  let fetchdata1 = () => {
    axios.get(`${port}/root/Telephonic_Round_Status_List/${Empid}/`).then((res) => {
      console.log("Screening_list", res.data);
      setScreeninglist(res.data)
    })
  }


  useEffect(() => {
    fetchdata2()
  }, [])




  let fetchdata2 = () => {

    axios.get(`${port}/root/Interview_Schedule_List/${Empid}/`).then((res) => {
      console.log("Interview_list", res.data);
      setInterviewlist(res.data)
    })

  }









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
      }).catch(error => {
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
        // const response = await axios.post(`${port}api/ParticularEmployeeTasks/jeroldraja12@gmail.com/`, {
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

  const [_name, setname] = useState('');
  const [Phone, setPhone] = useState('');
  const [_location, set_location] = useState('');
  const [_designation, set_designation] = useState('');
  const [_curent_Status, setcurent_Status] = useState('');
  const [I_S_D, set_I_S_D] = useState('');
  const [remarks1, setremarks1] = useState('');
  const [called_by, setcalled_by] = useState('');

  let handleSubmi = (e) => {
    e.preventDefault();

    const formdata = new FormData()
    formdata.append('name', _name);
    formdata.append('phone', Phone);
    formdata.append('location', _location);
    formdata.append('designation', _designation);
    formdata.append('current_status', _curent_Status);
    formdata.append('interview_scheduled_date', I_S_D);
    formdata.append('remarks', remarks1);

    formdata.append('experience', experiennceAddCall);
    formdata.append('status', interviewStatusAddCan);



    // formdata.append('called_by',Empid);
    formdata.append('emp_id', Empid);


    for (let pair of formdata.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/called_candidates/`, formdata)
      .then((r) => {
        toast.success('Candidate Add Successfull..')

        console.log("called_canditates", r.data)
        Call_Candidate_List()
        // setFirstname("")
      })
      .catch((err) => {
        toast.error('Candidate add Failed..')
        console.log("applicationform_err", err)
      })
  }




  return (

    <div className=' d-flex' style={{ width: '100%', minHeight: '100%', }}>

      <div className='d-none d-lg-flex'>

        {/* <Sidebar value={"dashboard"} ></Sidebar> */}
        <Recsidebar value={"dashboard"} ></Recsidebar>

      </div>
      <div className=' m-0 m-sm-4  flex-1 container mx-auto' style={{ borderRadius: '10px' }}>
        <Topnav ></Topnav>

        <div className='d-flex justify-content-between mt-4' >

          <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
            <li class="nav-item text-primary d-flex " role="presentation">
              {/* <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
                id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab"
                aria-controls="pills-home" aria-selected="true"> Applyed Candidates List </h6>
              <small className='text-danger ms-2   rounded-circle' > {
                filteredApplyList != undefined && filteredApplyList.length} </small> */}
              {/*  */}
              <section class='mt-2 d-flex align-items-center gap-2 heading nav-link active'
                style={{
                  color: 'rgb(76,53,117)', backgroundColor: 'transparent',
                  border: 'none'
                }}
                id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab"
                aria-controls="pills-home" aria-selected="true">

                <img className='w-14 ' src={require('../assets/Images/circle4.png')} alt="circle" />
                <div className='text-sm'> Applyed Candidates List
                  <div className='flex my-2 text-xs justify-between gap-2 flex-wrap'>

                    <small className='bg-red-400 text-white px-3  block rounded'>{
                      filteredApplyList != undefined && filteredApplyList.length}  </small>
                  </div>
                </div>
              </section>
            </li>
            <li class="nav-item text-primary d-flex" role="presentation">
              {/* <h6 class='mt-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
                id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" role="tab" aria-controls="pills-contact"
                aria-selected="false" >Called Candidate List </h6>
              <small className='text-danger ms-2   rounded-circle'> {Call_Candidates_Lists != undefined && Call_Candidates_Lists.length} </small> */}
              {/* Second button */}
              <section class='mt-2 d-flex align-items-center gap-2 heading nav-link '
                style={{
                  color: 'rgb(76,53,117)', backgroundColor: 'transparent',
                  border: 'none'
                }}
                id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" role="tab" aria-controls="pills-contact"
                aria-selected="false">

                <img className='w-14 ' src={require('../assets/Images/circle1.png')} alt="circle" />
                <div className='text-sm'> Called Candidate List
                  <div className='flex my-2 text-xs justify-between gap-2 flex-wrap'>

                    <small className='bg-green-400 text-white px-3  block rounded'>{Call_Candidates_Lists != undefined && Call_Candidates_Lists.length}  </small>
                  </div>
                </div>
              </section>
            </li>


          </ul>

        </div>


        <div class="tab-content p-1" id="myTabContent">
          <div class="tab-pane fade show active mt-1" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
            <div class="">
              {/* Nav Tabs  start */}

              <div class="tab-content" id="pills-tabContent">
                {/* Tab 1 start */}
                <div class="tab-pane fade show active" id="pills-home" role="tabpanel"
                  aria-labelledby="pills-home-tab" tabindex="0">

                  <div className='Assign_Applaylist d-flex justify-content-end '>

                    <div class="dropup-center dropstart ">

                      {permissions.applied_list_access &&
                        <button class="btn-success btn btn-sm dropdown-toggle"
                          type="button" data-bs-toggle="dropdown" aria-expanded="false">
                          Assign
                        </button>}

                      <ul class="dropdown-menu  text-center" style={{ width: '150px' }}>
                        {recname.map((e) => {
                          return (

                            <li onClick={() => sendSelectedDataToApi(e.EmployeeId)} key={e.EmployeeId} className='dropdown-item p-1' >Rec Name :  {e.Name} </li>
                          )
                        })}
                      </ul>
                      {assignAlert && (
                        <Alert style={{ position: 'absolute', top: '50px', right: '100px', width: '300px', zIndex: '1000' }}
                          severity="success" onClose={() => { setSuccessAlert(false); window.location.reload(); }}>
                          {/* <AlertTitle>Success</AlertTitle> */}
                          Candidate assigned successfully..
                        </Alert>
                      )}
                    </div>
                  </div>


                  <div className='flex justify-between items-center   mb-4 '>
                  <div className='flex gap-2 items-center  '>
                      <div className=" p-2  relative">
                        <button className='absolute -top-2 right-2 '>
                          <InfoButton size={12} content="Search by Candidate name,Candidate id,Email, Applied designation , Source " />
                        </button>
                        <input type="text" value={filterApplicationObj.word} name='word' style={{ width: '200px', height: '30px', fontSize: '9px', outline: 'none' }}
                          onChange={handleFilterApplicationChange} placeholder='Search..' className=" bgclr p-2 rounded  " aria-label="Username" aria-describedby="basic-addon1" />
                      </div>
                      {/* From video */}
                      <div className='flex items-center gap-3 bg-white p-1 px-2 rounded  ' >
                        From : <input type="date" value={filterApplicationObj.from} name='from' onChange={handleFilterApplicationChange}
                          className=' outline-none p-1 bg-transparent ' />
                      </div>
                      <div className='flex items-center gap-3 bg-white p-1 px-2 rounded  ' >
                        To : <input type="date" value={filterApplicationObj.to} name='to' onChange={handleFilterApplicationChange}
                          className=' outline-none p-1 bg-transparent ' />
                      </div>
                      <button className=' bg-green-600 text-slate-50 p-2 px-3 rounded ' onClick={handlesearchvalue} >
                        Search
                      </button>
                    </div>
                    <div className='flex gap-3 flex-wrap '>
                      {/* <div className='flex items-center gap-2 text-xs'>
                        Time :
                        <select className="form-select shadow-none" id="ageGroup"
                          style={{ width: '100px', height: '30px', fontSize: '9px', outline: 'none' }}
                          value={search_filter_applylist} onChange={(e) => {
                            handle_filter_apply_value(e.target.value)
                          }}>
                          <option value="">Filter</option>
                          <option value="Today">Day</option>
                          <option value="Week">Week</option>
                          <option value="Month">Month</option>
                          <option value="Year">Year</option>
                        </select></div> */}
                      <div className='flex items-center gap-2 text-xs'>
                        Screening process :

                        <select onChange={(e) => {
                          if (e.target.value != '') {
                            setFilteredApplyList([...applylist].filter((obj) => obj.ScreeningStatus == e.target.value))
                          } else {
                            setFilteredApplyList(applylist)
                          }
                        }}
                          className='p-1 text-sm flex ms-auto outline-none border-1 rounded' name="" id="">
                          <option value="Pending">Yet to Assign </option>
                          <option value=""> Select All</option>
                          <option value="Assigned">Yet to Screen </option>
                          {/* <option value="Completed">Completed </option> */}
                        </select>
                      </div>
                    </div>
                  </div>

                  <div className='rounded table-responsive tablebg h-[50vh] overflow-scroll  mt-4 m-1'>
                    <table class="table caption-top  relative   table-hover">
                      <thead >
                        <tr className='sticky top-0' >
                          {/* <th scope="col"></th> */}
                          <th scope="col"><span className='fw-medium'></span>All</th>
                          <th scope="col"><span className='fw-medium'>Name</span></th>
                          <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                          <th scope="col"><span className='fw-medium'>Email</span></th>
                          <th scope="col"><span className='fw-medium'>Phone</span></th>
                          <th scope="col"><span className='fw-medium'>Applied on</span></th>

                          <th scope="col"><span className='fw-medium'>Applied Designation</span></th>
                          {/* <th scope="col"><span className='fw-medium'>View</span></th> */}
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


                      {filteredApplyList != undefined && filteredApplyList != undefined && filteredApplyList.map((e) => {
                        console.log("Applied_list", e);
                        return (

                          <tbody>
                            <tr key={e.id}>
                              <th scope="row"><input type="checkbox" value={e.CandidateId} onChange={handleCheckboxChange} /></th>
                              <td onClick={() => sentparticularData(e.CandidateId)} data-bs-toggle="modal" data-bs-target="#exampleModal23" style={{ cursor: 'pointer', color: 'blue' }}>{e.FirstName}</td>
                              <td > {e.CandidateId}</td>
                              <td >{e.Email}</td>
                              <td className=' text-nowrap ' >{e.PrimaryContact}</td>
                              <td >{e.AppliedDate}</td>
                              <td >{e.AppliedDesignation}</td>
                              {/* <td className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal17" >
                                Proceed
                              </button>
                              </td> */}
                            </tr>
                          </tbody>

                        )
                      })}


                      {/* open Particular Data Start */}


                      <div class="modal fade" id="exampleModal23" tabindex="-1" aria-labelledby="exampleModalLabel23" aria-hidden="false">
                        <div class="modal-dialog modal-xl">
                          <div class="modal-content">
                            <div class="modal-header">
                              <h3>Applicant Information</h3>

                              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                              <table class="table table-bordered">
                                <tbody>
                                  <tr>
                                    <th>Name</th>
                                    <td>{persondata.FirstName} {persondata.LastName}</td>
                                  </tr>
                                  <tr>
                                    <th>Email</th>
                                    <td>{persondata.Email}</td>
                                  </tr>
                                  <tr>
                                    <th>Gender</th>
                                    <td>{persondata.Gender}</td>
                                  </tr>
                                  <tr>
                                    <th>Primary Contact</th>
                                    <td>{persondata.PrimaryContact}</td>
                                  </tr>
                                  <tr>
                                    <th>Secondary Contact</th>
                                    <td>{persondata.SecondaryContact}</td>
                                  </tr>
                                  <tr>
                                    <th>Location</th>
                                    <td>{persondata.Location}</td>
                                  </tr>

                                  {/* Fresher start  */}

                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th> {persondata.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                    {/* <td >{persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>GeneralSkills</th>
                                    <td>{persondata.GeneralSkills}</td>
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>TechnicalSkills</th>
                                    <td>{persondata.TechnicalSkills}</td>
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>SoftSkills</th>
                                    <td>{persondata.SoftSkills}</td>
                                  </tr>

                                  {/*  Fresher end */}

                                  {/* Experience Start */}



                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th> {persondata.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                    {/* <th>Experience</th> */}
                                    {/* <td>{persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>GeneralSkills with Exp</th>
                                    <td>{persondata.GeneralSkills_with_Exp}</td>
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>TechnicalSkills with Exp</th>
                                    <td>{persondata.TechnicalSkills_with_Exp}</td>
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>SoftSkills with Exp</th>
                                    <td>{persondata.SoftSkills_with_Exp}</td>
                                  </tr>
                                  {/* Experience Start */}



                                  <tr>
                                    <th>Highest Qualification</th>
                                    <td>{persondata.HighestQualification}</td>
                                  </tr>
                                  <tr>
                                    <th>University</th>
                                    <td>{persondata.University}</td>
                                  </tr>
                                  <tr>
                                    <th>Specialization</th>
                                    <td>{persondata.Specialization}</td>
                                  </tr>
                                  <tr>
                                    <th>Percentage</th>
                                    <td>{persondata.Percentage}</td>
                                  </tr>
                                  <tr>
                                    <th>Year of Passout</th>
                                    <td>{persondata.YearOfPassout}</td>
                                  </tr>




                                  <tr>
                                    <th>Applied Designation</th>
                                    <td>{persondata.AppliedDesignation}</td>
                                  </tr>
                                  <tr>
                                    <th>Expected Salary</th>
                                    <td>{persondata.ExpectedSalary}</td>
                                  </tr>
                                  <tr>
                                    <th>Contacted By</th>
                                    <td>{persondata.ContactedBy}</td>
                                  </tr>
                                  <tr>
                                    <th>Job Portal Source</th>
                                    <td>{persondata.JobPortalSource}</td>
                                  </tr>
                                  <tr>
                                    <th>Applied Date</th>
                                    <td>{persondata.AppliedDate}</td>
                                  </tr>
                                </tbody>
                              </table>


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


                      {/* INTERVIEW FORM start */}

                      <div class="modal fade" id="exampleModal17" tabindex="-1" aria-labelledby="exampleModalLabel15" aria-hidden="false">
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
                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${persondata.CandidateId}`} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="Name" className="form-label">Name </label>
                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${persondata.FirstName}`} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="lastName" className="form-label">Position Applied For</label>
                                        <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={persondata.AppliedDesignation} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="email" className="form-label">Source By</label>
                                        <input type="text" className="form-control shadow-none" id="Email" name="Email" value={sourceBy} onChange={(e) => setSourceBy(e.target.value)} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="primaryContact" className="form-label"> Date</label>
                                        <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={persondata.AppliedDate} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                                        <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={location} onChange={(e) => setLocation(e.target.value)} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                                        <input type="text" className="form-control shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
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
                                      <input type="text" className="form-control" id="qualification" value={persondata.HighestQualification} />
                                    </div>
                                    <div className="mb-3">
                                      <label htmlFor="experience" className="form-label">Related Experience:</label>
                                      <input type="number" className="form-control" id="experience" value={persondata.Experience} />
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
                    </table>
                  </div>
                  <div className='d-flex justify-end   p-2'>
                    {/* <button onClick={loadmorefunc} className='btn btn-sm btn-success'>Load More</button> */}
                    <div className=''>
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

                <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">

                  <div className='Assign_Applaylist d-flex justify-content-end '
                    style={{ position: 'absolute', right: '30px', top: '145px' }}>
                    <button className='btn btn-sm  btn-success '
                      data-bs-toggle="modal" data-bs-target="#addcandidate">
                      Add Candidate
                    </button>
                  </div>
                  <div class="modal fade" id="addcandidate" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                      <div class="modal-content">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel">Add Candidate</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                          {/*  */}
                          <form onSubmit={handleSubmi}>
                            {/* ---------------------------------PERSONAL DETAILS--------------------------------------------------------- */}
                            <div className="row m-0  pb-2">
                              <div className='row m-0 mt-2'>

                                <div className="col-md-6 col-lg-6  mb-3">
                                  <label htmlFor="firstName" className="form-label">Name <span class='text-danger'>*</span> </label>
                                  <input type="text" className="form-control shadow-none bg-light" id="FirstName" name="FirstName" value={_name} onChange={(e) => setname(e.target.value)} required />
                                </div>
                                <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="lastName" className="form-label">Phone <span class='text-danger'>*</span> </label>
                                  <input type="tel" className="form-control shadow-none bg-light" id=" LastName" name=" LastName" value={Phone} onChange={(e) => setPhone(e.target.value)} required />
                                </div>

                                <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="email" className="form-label">Location <span class='text-danger'>*</span> </label>
                                  <input type="text" className="form-control shadow-none bg-light" id=" Email" name=" Email" value={_location} onChange={(e) => set_location(e.target.value)} required />
                                </div>
                                <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="primaryContact" className="form-label">designation <span class='text-danger'>*</span> </label>
                                  <input type="tel" className="form-control shadow-none bg-light" id="PrimaryContact" name="PrimaryContact" value={_designation} onChange={(e) => set_designation(e.target.value)} required />
                                </div>
                                <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="primaryContact" className="form-label">Current Status <span class='text-danger'>*</span> </label>

                                  <select className="form-select shadow-none" id="ageGroup"
                                    value={_curent_Status} onChange={(e) => {
                                      setcurent_Status(e.target.value)
                                    }} >
                                    <option value="">select</option>
                                    <option value="fresher">Fresher</option>
                                    <option value="experience">Experience</option>

                                  </select>

                                </div>
                                <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="primaryContact" className="form-label">Interview Status <span class='text-danger'>*</span> </label>
                                  <select className="form-select shadow-none" id="ageGroup"
                                    value={interviewStatusAddCan} onChange={(e) => {
                                      setinterviewStatusAddcan(e.target.value)
                                    }} >
                                    <option value="">select</option>
                                    <option value="interview_scheduled">Scheduled</option>
                                    <option value="rejected">Rejected</option>
                                    <option value="to_client">To client</option>


                                  </select>

                                </div>
                                {_curent_Status == 'experience' &&
                                  <div className="col-md-6 col-lg-6 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Experience  </label>
                                    <input type="number" className="form-control shadow-none bg-light" id="SecondaryContact"
                                      name="SecondaryContact" value={experiennceAddCall}
                                      onChange={(e) => {
                                        if (e.target.value <= 0) {
                                          setExperienceAddCall('')
                                        }
                                        else if (e.target.value > 40) {
                                          setExperienceAddCall(40)
                                        }
                                        else
                                          setExperienceAddCall(e.target.value)
                                      }} />
                                  </div>}
                                {interviewStatusAddCan == 'interview_scheduled' && <div className="col-md-6 col-lg-6 mb-3">
                                  <label htmlFor="secondaryContact" className="form-label">Interview Scheduled Date  </label>
                                  <input type="date" className="form-control shadow-none bg-light" id="SecondaryContact" name="SecondaryContact"
                                    value={I_S_D} onChange={(e) => set_I_S_D(e.target.value)} />
                                </div>}

                                <div className="col-md-6 col-lg-12 mb-3">
                                  <label htmlFor="secondaryContact" className="form-label">Remarks <span class='text-danger'>*</span> </label>
                                  <textarea type="text" className="form-control shadow-none bg-light p-2" id="State" name="remarks"
                                    value={remarks1} onChange={(e) => setremarks1(e.target.value)} required />
                                </div>
                                {/* <div className="col-md-6 col-lg-3 mb-3">
                                    <label htmlFor="secondaryContact" className="form-label">Called By <span class='text-danger'>*</span> </label>
                                    <input type="text" className="form-control shadow-none bg-light" id="State" name="State" value={called_by} onChange={(e) => setcalled_by(e.target.value)} required />
                                  </div> */}


                              </div>

                            </div>
                            <div className='w-100 ' style={{ display: 'flex', justifyContent: 'end' }}>

                              <button type='submit' className='p-2 bg-blue-600 rounded text-white ' data-bs-dismiss="modal">Submit</button>
                            </div>

                          </form>

                        </div>

                      </div>
                    </div>
                  </div>


                  <ul class="nav nav-pills  w-100" style={{ display: 'flex', justifyContent: 'space-between' }} id="pills-tab" role="tablist">

                    <div>

                      <div class="input-group mb-3 ">
                        <span class="input-group-text" id="basic-addon1"> <i class="fa-solid fa-magnifying-glass" ></i>  </span>
                        <input type="text" style={{ width: '200px', height: '30px', fontSize: '9px', outline: 'none' }}
                          class="form-control shadow-none" aria-label="Username" aria-describedby="basic-addon1" />
                      </div>
                    </div>


                    <div>
                      <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >


                        <select className="form-select shadow-none" id="ageGroup" style={{ width: '100px', height: '30px', fontSize: '9px', outline: 'none' }}
                        >
                          <option value="">Filter</option>
                          <option value="Today">Day</option>
                          <option value="Week">Week</option>
                          <option value="Month">Month</option>
                          <option value="Year">Year</option>
                        </select>
                      </li>
                    </div>
                  </ul>

                  <div className='rounded tablebg table-responsive mt-4 m-1'>
                    <table class="w-full">
                      <thead >
                        <tr >
                          {/* <th scope="col"></th> */}
                          <th scope="col"><span className='fw-medium'></span>All</th>
                          <th scope="col"><span className='fw-medium'>Name</span></th>
                          <th scope="col"><span className='fw-medium'>Phone</span></th>
                          <th scope="col"><span className='fw-medium'>Location</span></th>
                          <th scope="col"><span className='fw-medium'> Designation</span></th>
                          <th scope="col"><span className='fw-medium'> Current status</span></th>
                          <th scope="col"><span className='fw-medium'>Interview Scheduled Date</span></th>
                          {/* <th scope="col"><span className='fw-medium'>Called Date</span></th>
                          <th scope="col"><span className='fw-medium'>Called By</span></th>
                          <th scope="col"><span className='fw-medium'>Remarks</span></th> */}


                          {/* <th scope="col"><span className='fw-medium'>View</span></th> */}





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


                      {Call_Candidates_Lists != undefined && Call_Candidates_Lists != undefined && Call_Candidates_Lists.slice(0, load).map((e) => {
                        return (

                          <tbody>
                            <tr key={e.id}>
                              <td scope="row"><input type="checkbox" value={e.CandidateId} onChange={handleCheckboxChange} /></td>
                              <td >{e.name}</td>
                              <td > {e.phone}</td>
                              <td >{e.location}</td>
                              <td >{e.designation}</td>
                              <td >{e.current_status}</td>
                              <td >{e.interview_scheduled_date}</td>
                              {/* <td >{e.called_date}</td>
                              <td >{e.called_by}</td>
                              <td >{e.remarks}</td> */}

                            </tr>
                          </tbody>

                        )
                      })}


                      {/* open Particular Data Start */}


                      <div class="modal fade" id="exampleModal23" tabindex="-1" aria-labelledby="exampleModalLabel23" aria-hidden="false">
                        <div class="modal-dialog modal-xl">
                          <div class="modal-content">
                            <div class="modal-header">
                              <h3>Applicant Information</h3>

                              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                              <table class="table table-bordered">
                                <tbody>
                                  <tr>
                                    <th>Name</th>
                                    <td>{persondata.FirstName} {persondata.LastName}</td>
                                  </tr>
                                  <tr>
                                    <th>Email</th>
                                    <td>{persondata.Email}</td>
                                  </tr>
                                  <tr>
                                    <th>Gender</th>
                                    <td>{persondata.Gender}</td>
                                  </tr>
                                  <tr>
                                    <th>Primary Contact</th>
                                    <td>{persondata.PrimaryContact}</td>
                                  </tr>
                                  <tr>
                                    <th>Secondary Contact</th>
                                    <td>{persondata.SecondaryContact}</td>
                                  </tr>
                                  <tr>
                                    <th>Location</th>
                                    <td>{persondata.Location}</td>
                                  </tr>

                                  {/* Fresher start  */}

                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th> {persondata.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                    {/* <td >{persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>GeneralSkills</th>
                                    <td>{persondata.GeneralSkills}</td>
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>TechnicalSkills</th>
                                    <td>{persondata.TechnicalSkills}</td>
                                  </tr>
                                  <tr className={` ${persondata.Fresher ? ' ' : 'd-none'} `}>
                                    <th>SoftSkills</th>
                                    <td>{persondata.SoftSkills}</td>
                                  </tr>

                                  {/*  Fresher end */}

                                  {/* Experience Start */}



                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th> {persondata.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                    {/* <th>Experience</th> */}
                                    {/* <td>{persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>GeneralSkills with Exp</th>
                                    <td>{persondata.GeneralSkills_with_Exp}</td>
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>TechnicalSkills with Exp</th>
                                    <td>{persondata.TechnicalSkills_with_Exp}</td>
                                  </tr>
                                  <tr className={` ${persondata.Experience ? ' ' : 'd-none'} `}>
                                    <th>SoftSkills with Exp</th>
                                    <td>{persondata.SoftSkills_with_Exp}</td>
                                  </tr>
                                  {/* Experience Start */}



                                  <tr>
                                    <th>Highest Qualification</th>
                                    <td>{persondata.HighestQualification}</td>
                                  </tr>
                                  <tr>
                                    <th>University</th>
                                    <td>{persondata.University}</td>
                                  </tr>
                                  <tr>
                                    <th>Specialization</th>
                                    <td>{persondata.Specialization}</td>
                                  </tr>
                                  <tr>
                                    <th>Percentage</th>
                                    <td>{persondata.Percentage}</td>
                                  </tr>
                                  <tr>
                                    <th>Year of Passout</th>
                                    <td>{persondata.YearOfPassout}</td>
                                  </tr>




                                  <tr>
                                    <th>Applied Designation</th>
                                    <td>{persondata.AppliedDesignation}</td>
                                  </tr>
                                  <tr>
                                    <th>Expected Salary</th>
                                    <td>{persondata.ExpectedSalary}</td>
                                  </tr>
                                  <tr>
                                    <th>Contacted By</th>
                                    <td>{persondata.ContactedBy}</td>
                                  </tr>
                                  <tr>
                                    <th>Job Portal Source</th>
                                    <td>{persondata.JobPortalSource}</td>
                                  </tr>
                                  <tr>
                                    <th>Applied Date</th>
                                    <td>{persondata.AppliedDate}</td>
                                  </tr>
                                </tbody>
                              </table>


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


                      {/* INTERVIEW FORM start */}

                      <div class="modal fade" id="exampleModal17" tabindex="-1" aria-labelledby="exampleModalLabel15" aria-hidden="false">
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
                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${persondata.CandidateId}`} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="Name" className="form-label">Name </label>
                                        <input type="text" className="form-control shadow-none" id="Name" name="Name" value={`${persondata.FirstName}`} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="lastName" className="form-label">Position Applied For</label>
                                        <input type="text" className="form-control shadow-none" id="LastName" name="LastName" value={persondata.AppliedDesignation} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="email" className="form-label">Source By</label>
                                        <input type="text" className="form-control shadow-none" id="Email" name="Email" value={sourceBy} onChange={(e) => setSourceBy(e.target.value)} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="primaryContact" className="form-label"> Date</label>
                                        <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={persondata.AppliedDate} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                                        <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={location} onChange={(e) => setLocation(e.target.value)} />
                                      </div>
                                      <div className="col-md-6 col-lg-4 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                                        <input type="text" className="form-control shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
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
                                      <input type="text" className="form-control" id="qualification" value={persondata.HighestQualification} />
                                    </div>
                                    <div className="mb-3">
                                      <label htmlFor="experience" className="form-label">Related Experience:</label>
                                      <input type="number" className="form-control" id="experience" value={persondata.Experience} />
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

                {/* Tab 2 end */}



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
                              <input type="text" className="form-control shadow-none" id="remarks" name="remarks" value={remarks}
                                onChange={(e) => setRemarks(e.target.value)} required />
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

export default Rec_applyed_list