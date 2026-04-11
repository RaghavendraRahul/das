import React, { useContext } from 'react'
import Topnav from '../Topnav'
import { useEffect, useState } from 'react'
import axios from 'axios'
import { Link, json, useNavigate, useSearchParams } from 'react-router-dom';
import { Alert, AlertTitle } from '@mui/material';
import Finalstatuscomment from '../Finalstatuscomment';
import { domain, port } from '../../App'
import Final_status_comment from '../Final_status_comment';
import { HrmStore } from '../../Context/HrmContext';
import Sidebar from '../Sidebar';
import ScreeningAssigned from './ScreeningAssigned';
import InterviewCompletedModal from '../Modals/InterviewCompletedModal';
import SchedulINterviewModalForm from './SchedulINterviewModalForm';
import { toast } from 'react-toastify';
import { Modal, OverlayTrigger } from 'react-bootstrap';
import FinalResultCompleted from '../Modals/FinalResultCompleted';
import InfoIcon from '../../SVG/InfoIcon';
import InfoButton from '../SettingComponent/InfoButton';
import FinalStatus from '../Modals/FinalStatus';
import LoadingData from '../MiniComponent/LoadingData';


const Applylist = () => {
  let username = JSON.parse(sessionStorage.getItem('user'))?.UserName ?? ''
  let user = JSON.parse(sessionStorage.getItem('user')) ?? {}
  let [finalStatus, setFinalStatus] = useState(false)
  let [finalStatusName, setFinalStatusName] = useState()
  let loginID = JSON.parse(sessionStorage.getItem('Login_Profile_Information'))?.employee_Id ?? null
  let { testing, convertToReadableDateTime, timeValidate, getCurrentDate, getProperDate } = useContext(HrmStore)
  let [interviewCompletedDetailsModal, setInterviewCompleteDetailsModal] = useState()
  let [finalResultObj, setFinalResultObj] = useState()
  let [interviewlistSorting, setInterviewListSorting] = useState()
  let [interviewModal, setInterviewModal] = useState(false)
  let [selectedFinalResultName, setselectedFinalResultName] = useState()
  let [selectedCandidate, setSelectedCandidate] = useState()
  let { convertTimeTo12HourFormat } = useContext(HrmStore)
  let [intervewAsssignedcompleted, setInterviewAssignedcompleted] = useState('Assigned')
  let [appliedDuration, setAppliedDuration] = useState('')
  let [appliedScreeningStatus, setAppliedScreeningStatus] = useState('')
  let [applylist, setApplylist] = useState([])
  let [filteredApplyList, setFilteredApplyList] = useState([])
  const [searchParams, setSearchParams] = useSearchParams()
  const [pagination, setPagination] = useState({
    count: 0,
    total_all: 0,
    next: null,
    previous: null,
    currentPage: parseInt(searchParams.get('page')) || 1
  });
  const [pagination3, setPagination3] = useState({
    count: 0,
    next: null,
    previous: null,
    currentPage: parseInt(searchParams.get('final_page')) || 1
  });
  const [pageInput, setPageInput] = useState(pagination.currentPage);
  const [pageInput3, setPageInput3] = useState(pagination3.currentPage);

  useEffect(() => {
    setPageInput(pagination.currentPage);
  }, [pagination.currentPage]);

  useEffect(() => {
    setPageInput3(pagination3.currentPage);
  }, [pagination3.currentPage]);

  const [finalSearchTerm, setFinalSearchTerm] = useState('');
  const [finalFromDate, setFinalFromDate] = useState('');
  const [finalToDate, setFinalToDate] = useState('');

  const pageSize = 10;
  let [screeninglist, setScreeninglist] = useState([])
  let [screeninglistCompleted, setScreeninglistCompleted] = useState([])
  const [codeans, setCodeAns] = useState()
  let [carrylaptop, setcarrylaptop] = useState(false)
  let [interviewformFillingModal, setinterviewFormFillingModal] = useState(false)
  let [interviewReviewmodalShowing, setinterviewreviewModalShowing] = useState(false)
  let [interviewlist, setInterviewlist] = useState([])
  let [interviewCompletedList, setInterviewCompletedList] = useState()
  let [filteredInterviewList, setFilteredInterviewList] = useState()
  let [interviewfilterWord, setInterviewFilterWord] = useState()
  let [completedlist, setCompletedlist] = useState([])
  let [FinalData, setFinalData] = useState([])
  let [filterFinalData, setFilterFinalData] = useState()
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
  const [Interviewstatus, setInterviewStatus] = useState('');

  let [interviewFilterObject, setInterviewFilterObject] = useState({
    from: '',
    to: '',
    name: ''
  })
  let handleInterviewFilterObject = (e) => {
    let { name, value } = e.target
    setInterviewFilterObject((prev) => ({
      ...prev,
      [name]: value
    }))

  }

  const [persondata, setPersondata] = useState({})

  const [interviewers, setInterviewers] = useState([]);

  const [selectedCandidates, setSelectedCandidates] = useState([]);
  const [selectedCandidates1, setSelectedCandidates1] = useState([]);
  const [selectedCandidates2, setSelectedCandidates2] = useState([]);
  const [selectedCandidates3, setSelectedCandidates3] = useState([]);
  let [filterApplicationObj, setFilterApplicationObj] = useState({
    from: '',
    to: '',
    word: ''
  })



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
    const page = parseInt(searchParams.get('final_page')) || 1
    fetchdata3(page)
  }, [searchParams.get('final_page')])

  useEffect(() => {
    const urlPage = parseInt(searchParams.get('page')) || 1
    fetchdata(urlPage)
  }, [searchParams, appliedDuration, appliedScreeningStatus])

  let handleFilterApplicationChange = (e) => {
    let { name, value } = e.target
    setFilterApplicationObj((prev) => ({
      ...prev,
      [name]: value
    }))
  }
  const filterRangeWiseApplication = () => {
    // if (filterApplicationObj.from && filterApplicationObj.to) {
    //     let filteredData = filteredApplyList.filter(
    //         (obj) =>
    //             new Date(obj.AppliedDate) >= new Date(filterApplicationObj.from) &&
    //             new Date(obj.AppliedDate) <= new Date(filterApplicationObj.to)
    //     );
    //     console.log(filteredData, 'filteredValue');
    //     setFilteredApplyList(filteredData);
    // } else if (filterApplicationObj.from) {
    //     let filteredData = filteredApplyList.filter(
    //         (obj) => new Date(obj.AppliedDate) >= new Date(filterApplicationObj.from)
    //     );
    //     console.log(filteredData, 'filteredValue');
    //     setFilteredApplyList(filteredData);
    // } else if (filterApplicationObj.to) {
    //     let filteredData = filteredApplyList.filter(
    //         (obj) => new Date(obj.AppliedDate) <= new Date(filterApplicationObj.to)
    //     );
    //     console.log(filteredData, 'filteredValue');
    //     setFilteredApplyList(filteredData);
    // }

  };

  let fetchdata3 = (page = 1, search = finalSearchTerm, from = finalFromDate, to = finalToDate) => {
    setloading('final')
    let queryParams = `?page=${page}`
    if (search) queryParams += `&search=${search}`
    if (from) queryParams += `&from_date=${from}`
    if (to) queryParams += `&to_date=${to}`

    axios.get(`${port}/root/FinalList/${Empid}/${queryParams}`).then((res) => {
      console.log("FinalData--- ", res.data);
      const results = res.data.results || res.data;
      setFinalData(results)
      if (res.data.results) {
        setPagination3({
          count: res.data.count,
          next: res.data.next,
          previous: res.data.previous,
          currentPage: page
        });
      }
      setloading(false)
    }).catch((error) => {
      console.log(error)
      setloading(false)
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

  useEffect(() => {
    if (FinalData)
      setFilterFinalData(FinalData)
  }, [FinalData])
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
  useEffect(() => {
    if (interviewlist && intervewAsssignedcompleted == 'Assigned')
      setFilteredInterviewList(interviewlist)
    if (interviewCompletedList && intervewAsssignedcompleted == 'Completed')
      setFilteredInterviewList(interviewCompletedList)
  }, [interviewlist, interviewCompletedList])

  console.log(selectedCandidates);

  let Empid = JSON.parse(sessionStorage.getItem('user'))?.EmployeeId ?? ''

  let Disgnation = JSON.parse(sessionStorage.getItem('user'))?.Disgnation ?? ''
  let Email = JSON.parse(sessionStorage.getItem('user'))?.Email ?? ''
  let PhoneNumber = JSON.parse(sessionStorage.getItem('user'))?.PhoneNumber ?? ''
  let UserName = JSON.parse(sessionStorage.getItem('user'))?.UserName ?? ''
  let [interviewRoundType, setInterviewRoundType] = useState('')

  console.log("login", Empid);



  const sendSelectedDataToApi = (id) => {
    console.log(selectedCandidates, id);
    axios.post(`${port}/root/ScreeningAssigning/`, { Candidates: selectedCandidates, Recruiterid: id, login_user: Empid })
      .then(response => {
        console.log('API response:', response.data);
        // alert(response.data)
        setcount(count + 1)
        setSuccessAlert(true);
        alert('Screening Round Assign Successfull')
        window.location.reload()
        setSelectedCandidates([])
      })
      .catch(error => {
        alert(error.response.data)
        console.error('Error sending data to API:', error);

      });
  };

  // APPLY REC NAME START
  const sentparticularData1 = (id, emp_id) => {


    setCandidate(id)
    setEmpid(emp_id)
    // Define the data to be sent in the request
    const dataToSend = {
      id: id // Assuming id is the parameter passed to the function
    };

    // Send a POST request using Axios
    if (id) {
      axios.get(`${port}/root/New-Candidate-Interview-Completed-Details/${id}/`, dataToSend)
        .then(response => {
          // Handle the response if needed
          console.log('Interview_Schedule_Data', response.data);
          setPersondata(response.data.candidate_data)
          setCandidate(response.data.CandidateId)
          // console.log("person data", response.data);
        })
        .catch(error => {
          // Handle errors if any
          console.error('Interview_Schedule_Data', error);
        });
    }
  };

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

    // sentparticularData()
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
    let { name, value } = e.target;
    if (name == 'InterviewDate' && timeValidate() > value) {
      // alert(timeValidate())
      value = timeValidate()
    }
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

  const handlesearchvalue = () => {
    const urlPage = parseInt(searchParams.get('page')) || 1
    if (urlPage === 1) {
      fetchdata(1)
    } else {
      handlePageUpdate(1)
    }
  }

  const handle_filter_apply_value = (value) => {
    setAppliedDuration(value)

    if (searchParams.get('page') !== '1') {
      handlePageUpdate(1)
    }
  }


  // screend Search
  const [searchscreenValue, setScreenValue] = useState();
  const [search_filter_screened, setsearch_filter_Screened] = useState();
  console.log("searchValue", searchscreenValue);

  const handlescreenedsearchvalue = (value, type) => {

    setScreenValue(value)

    if (value.length > 0) {
      axios.get(`${port}/root/ScreeningScheduleSearch/${value}/${type}/`).then((res) => {
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

  const handle_screened_filter_value = (value) => {

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

      axios.get(`${port}/root/InterviewScheduledSearch/${value}/${Empid}/`).then((res) => {
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

  const handle_Interviewe_filter_value = (value) => {

    setInterviewValue(value)



    if (value.length > 0) {

      axios.get(`${port}/root/Interview_filter/${value}/`).then((res) => {
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



    if (value.length > 0) {

      axios.get(`${port}/root/AppliedCandidateSearch/${value}/`).then((res) => {
        console.log("ScreeningScheduleSearch_Res", res.data);
        setFinalData(res.data)
        setPagination3({
          count: res.data.length,
          next: null,
          previous: null,
          currentPage: 1
        })
      }).catch((err) => {
        console.log("ScreeningScheduleSearch_Err", err.data);
      })

    }
    else {

      fetchdata3()
    }

  }






  const fetchdata = (page = 1, statusOverride, filters = filterApplicationObj) => {
    setloading('applied')
    const currentStatus = statusOverride !== undefined ? statusOverride : appliedScreeningStatus
    const body = {}
    if (currentStatus === 'Pending') {
      body.FinalResults = 'Pending' // Only filter by Pending results if we are in "Yet to assign" mode
    }
    if (filters.word) body.search_value = filters.word
    if (filters.from) body.FromDate = filters.from
    if (filters.to) body.ToDate = filters.to
    if (appliedDuration) body.duration = appliedDuration
    if (currentStatus) body.ScreeningStatus = currentStatus

    axios.post(`${port}/root/appliedcandidateslist?page=${page}`, body).then((res) => {
      console.log("Applicand_list", res.data);
      const results = res.data.results || res.data;
      setApplylist(results)
      // // Maintaining the pending filter for the main view result display if results is an array
      // if (Array.isArray(results)) {
      //   setFilteredApplyList(results.filter((obj) => (obj.ScreeningStatus == 'Pending' || obj.ScreeningStatus == null) && (obj.Final_Results == 'Pending' || obj.Final_Results == null)))
      // } else {
      //   setFilteredApplyList([])
      // }
      setFilteredApplyList(results) // Use pure results from backend since it's already filtered

      if (res.data.results) {
        setPagination({
          count: res.data.count,
          total_all: res.data.total_all,
          next: res.data.next,
          previous: res.data.previous,
          currentPage: page
        });
      }
      setloading(false)
    }).catch(err => {
      console.log(err)
      setloading(false)
    })
  }

  const handlePageUpdate = (newPage) => {
    setSearchParams(prev => {
      const next = new URLSearchParams(prev)
      next.set('page', newPage)
      return next
    })
  }

  const handlePageUpdate3 = (newPage) => {
    setSearchParams(prev => {
      const next = new URLSearchParams(prev)
      next.set('final_page', newPage)
      return next
    })
  }


  let fetchdata1 = async () => {
    try {
      const screeningAssigned1 = await axios.get(`${port}/root/New-Screening-assigned-list/${Empid}/Assigned/`);
      const screeningAssigned2 = await axios.get(`${port}/root/New-Candidate-Screening-list/${Empid}/Assigned/`);
      // const screeningCompleted1 = await axios.get(`${port}/root/New-Screening-assigned-list/${Empid}/Completed/`);
      const screeningCompleted2 = await axios.get(`${port}/root/New-Candidate-Screening-list/${Empid}/Completed/`);
      // Only update state if the component is still mounted
      setScreeninglist([...screeningAssigned1.data, ...screeningAssigned2.data]);
      setScreeninglistCompleted([...screeningCompleted2.data]);
      console.log("Screening_list", [...screeningAssigned1.data, ...screeningAssigned2.data]);

      console.log("Screening_list", screeningAssigned2.data);
    } catch (error) {
      console.log(error);
    }
    // axios.get(`${port}/root/New-Screening-assigned-list/${Empid}/Assigned/`).then((res) => {
    //   console.log("Screening_list", res.data);
    //   setScreeninglist(res.data)
    // }).catch((error) => {
    //   console.log(error);
    // })
  }
  let getScreeningCompleted = () => {
    axios.get(`${port}/root/New-Screening-assigned-list/${Empid}/Completed/`).then((res) => {
      console.log("Screening_list", res.data);
      setScreeninglistCompleted(res.data)
    }).catch((error) => {
      console.log(error);
    })
  }
  useEffect(() => {
    fetchdata1()
    getScreeningCompleted()
  }, [])










  let fetchdata2 = async () => {
    try {
      const [interviewAssigned, interviewAssigned2, interviewCompleted1, interviewCompleted2] = await Promise.all([
        axios.get(`${port}/root/New-Interview-assigned-list/${Empid}/Assigned/`),
        axios.get(`${port}/root/New-Candidate-Interview-list/${Empid}/Assigned/`),
        axios.get(`${port}/root/New-Interview-assigned-list/${Empid}/Completed/`),
        axios.get(`${port}/root/New-Candidate-Interview-list/${Empid}/Completed/`)
      ]);

      const combinedData = [...(interviewAssigned.data || []), ...(interviewAssigned2.data || [])];
      const uniqueCandidates = [];
      const combinedData2 = [...(interviewCompleted1.data || []), ...(interviewCompleted2.data || [])]
      const uniqueCandidatesCompleted = []

      combinedData.reverse().forEach((obj) => {
        if (!uniqueCandidates.find((candidate) => candidate.Candidate === obj.Candidate)) {
          uniqueCandidates.push(obj);
        }
      });
      combinedData2.reverse().forEach((obj) => {
        if (!uniqueCandidatesCompleted.find((candidate) => candidate.Candidate === obj.Candidate)) {
          uniqueCandidatesCompleted.push(obj);
        }
      });

      setInterviewlist([...uniqueCandidates]);
      setInterviewCompletedList([...uniqueCandidatesCompleted])
    } catch (error) {
      console.log("Interview_list", error);
    }
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


      })
      .catch(error => {
        // Handle errors if any
        console.error('Error sending data:', error);
      });
  };

  useEffect(() => {
    if (intervewAsssignedcompleted) {
      setInterviewListSorting('')
      setInterviewFilterObject({
        from: '',
        to: '',
        name: ''
      })
    }
  }, [intervewAsssignedcompleted])
  let handlefinlterinterviewFunction = (e) => {
    let { name: value, from, to } = interviewFilterObject;

    if (to && !from) {
      toast.warning('Enter the from date');
      return;
    }
    let list = intervewAsssignedcompleted == 'Assigned' ? [...interviewlist] : [...interviewCompletedList]
    let newarry = [...list].filter((obj) =>
      obj.Candidate_name.toLowerCase().indexOf(value.toLowerCase()) != -1 ||
      obj.interviewer_name.toLowerCase().indexOf(value.toLowerCase()) != -1 ||
      obj.ScheduledBy_name.toLowerCase().indexOf(value.toLowerCase()) != -1 ||
      obj.Applied_Designation.toLowerCase().indexOf(value.toLowerCase()) != -1)
    if (from && to) {
      newarry = newarry.filter((obj) => getProperDate(obj.ScheduledOn) >= from && getProperDate(obj.ScheduledOn) <= to)
    }
    else if (from) {
      newarry = newarry.filter((obj) => getProperDate(obj.ScheduledOn) >= from)
    }
    setFilteredInterviewList(newarry)
  }
  const [Screening_candidate_data, setScreening_candidate_data] = useState({})
  const [Screening_screening_data, setScreening_screening_data] = useState({})
  const [Screening_screening_review1, setScreening_screening_review1] = useState({})
  const screeninglist_All = (id, e) => {

    console.log("dsasd", id, e);

    setCandidate(id)
    // Define the data to be sent in the request
    const dataToSend = {
      id: id // Assuming id is the parameter passed to the function
    };

    // Send a POST request using Axios
    axios.get(`${port}/root/Screening_Schedule_Data/${id}/${e}/`, dataToSend)
      .then(response => {
        // Handle the response if needed
        console.log('Screening_Schedule_Data', response.data);
        // console.log('Screening_candidate_data', response.data.candidate_data);
        // console.log('Screening_screening_data', response.data.screening_data);
        setScreening_candidate_data(response.data.candidate_data)
        setScreening_screening_data(response.data.screening_data)
        setScreening_screening_review1(response.data.screening_data.review)
        console.log("Review_Data", response.data.screening_data.review);




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
      const response = await axios.post(`${port}root/download-excel/`, { 'Candidate_ids': lists }, {
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



  const [id, setEmpid] = useState("")


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

  let [interviewerName, setInterviewerName] = useState(username)

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



  let reset = () => {
    setComments('')
    setJobStability('')
    setReasonLeaving('')
    setCodeAns('')
    setAppearancePersonality('')
    setClarityThought('')
    setEnglishSkills('')
    setTechnicalAwareness('')
    setInterpersonalSkills('')
    setConfidenceLevel('')
    setAgeGroup('')
    setLogicalReasoning('')
    setCareerPlans('')
    setsixDaysWorking('')
    setTargetPressure('')
    setCustomerService('')
    setOverallRanking('')
    setRelocationToCenters('')
    setRelocationToCity('')
    setInterviewStatus('')
    setResearchCompany('')
    setLeadershipAbilities('')
    setAchievementOrientation('')

  }
  let [loading, setloading] = useState('')

  let handleproceedingform = (e) => {
    e.preventDefault();
    let formData1 = new FormData()
    formData1.append('login_user', Empid);
    formData1.append('id', id);
    formData1.append('CandidateId', persondata.id);
    formData1.append('Can_Id', persondata.CandidateId);
    formData1.append('Name', persondata.FirstName);
    formData1.append('PositionAppliedFor', persondata.AppliedDesignation);
    formData1.append('SourceBy', persondata.JobPortalSource);
    formData1.append('Date', persondata.AppliedDate);
    formData1.append('LocationAppliedFor', persondata.AppliedDesignation);
    formData1.append('SourceName', persondata.JobPortalSource);
    formData1.append('OwnLoptop', carrylaptop)
    formData1.append('Qualification', persondata.HighestQualification);
    formData1.append('RelatedExperience', experience);
    formData1.append('JobStabilityWithPreviousEmployers', jobStability);
    formData1.append('ReasionForLeavingImadiateEmployer', reasonLeaving);
    formData1.append('Coding_Questions_Score', codeans)
    formData1.append('Appearence_and_Personality', appearancePersonality);
    formData1.append('ClarityOfThought', clarityThought);
    formData1.append('EnglishLanguageSkills', englishSkills);
    formData1.append('AwarenessOnTechnicalDynamics', technicalAwareness);
    formData1.append('InterpersonalSkills', interpersonalSkills);
    formData1.append('ConfidenceLevel', confidenceLevel);
    formData1.append('AgeGroupSuitability', ageGroup);
    formData1.append('Analytical_and_logicalReasoningSkills', logicalReasoning);
    formData1.append('CareerPlans', careerPlans);
    formData1.append('AchivementOrientation', achievementOrientation);
    formData1.append('ProblemSolvingAbilites', driveProblemSolving);
    formData1.append('AbilityToTakeChallenges', takeUpChallenges);
    formData1.append('LeadershipAbilities', leadershipAbilities);
    formData1.append('IntrestWithCompany', companyInterest);
    formData1.append('ResearchedAboutCompany', researchCompany);
    formData1.append('HandelTargets_Pressure', targetPressure);
    formData1.append('CustomerService', customerService);
    formData1.append('OverallCandidateRanking', overallRanking);

    formData1.append('Six_Days_Working', sixDaysWorking);


    formData1.append('LastCTC', persondata.CurrentCTC);
    formData1.append('ExpectedCTC', persondata.ExpectedSalary);
    formData1.append('NoticePeriod', persondata.NoticePeriod);
    formData1.append('DOJ', DOJ);
    formData1.append('CertificateSubmittion', certificationSubmission);

    formData1.append('RelocateToOtherCity', relocationToCity);
    formData1.append('RelocateToOtherCenters', relocationToCenters);
    formData1.append('interview_Status', Interviewstatus);

    formData1.append('ReviewedBy', loginID);
    formData1.append('InterviewerName', interviewerName);
    formData1.append('Signature', signature);
    formData1.append('ReviewedDate', date1);
    formData1.append('Comments', comments);



    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }
    console.log(interviewerName);
    if (Interviewstatus != '') {
      setloading('interview')
      axios.post(`${port}/root/InterviewReviewData`, formData1)
        .then((r) => {
          toast.success("Proceding Form Data Successfull")
          console.log("Proceding Form Data Successfull", r.data)
          fetchdata2()
          fetchdata()
          fetchdata1()
          reset()
          setinterviewFormFillingModal(false)
        })
        .catch((err) => {
          toast.error('Proceding Form Data Failed')
          console.log("Interview Assessment Form Error", err)
        })
      setloading('')
    }
    else {
      toast.warning('Enter the required fields')
      document.getElementById('interviewstatuserror').innerHTML = "*Fill the field"
    }
  }

  let Bg_Verify_Form = () => {


  }
  useEffect(() => {
    fetchdata2()
  }, [])


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
  let [filterAppliedTask, setFilterAppliedTask] = useState('Pending')

  useEffect(() => {
    let count = 0
    if (Number(jobStability) > 0)
      count++
    if (Number(codeans) > 0)
      count++
    if (Number(appearancePersonality) > 0)
      count++
    if (Number(clarityThought) > 0)
      count++
    if (Number(englishSkills) > 0)
      count++
    if (Number(technicalAwareness) > 0)
      count++
    if (Number(interpersonalSkills) > 0)
      count++
    if (Number(confidenceLevel) > 0)
      count++
    if (Number(logicalReasoning) > 0)
      count++
    if (Number(driveProblemSolving) > 0)
      count++
    if (Number(takeUpChallenges) > 0)
      count++
    if (Number(leadershipAbilities) > 0)
      count++
    if (Number(targetPressure) > 0)
      count++
    if (Number(customerService) > 0)
      count++
    if (count > 1) {
      console.log(count);
      let avg = (((Number(jobStability) + Number(englishSkills) + Number(technicalAwareness) + Number(confidenceLevel)
        + Number(interpersonalSkills) + Number(logicalReasoning) + Number(driveProblemSolving) + Number(takeUpChallenges)
        + Number(leadershipAbilities) + Number(targetPressure) + Number(customerService) + Number(codeans ? codeans : 0)
        + Number(appearancePersonality) + Number(clarityThought)) / count)).toFixed(2)
      setOverallRanking(avg)
      console.log(avg);
    }
    console.log(count);
  }, [codeans, jobStability, customerService, targetPressure, leadershipAbilities,
    takeUpChallenges, driveProblemSolving,
    confidenceLevel, logicalReasoning, driveProblemSolving, appearancePersonality,
    clarityThought, englishSkills,
    technicalAwareness, interpersonalSkills])

  let { setActivePage } = useContext(HrmStore)
  useEffect(() => {
    setActivePage('applylist')
  }, [])


  return (

    <div className='flex flex-col lg:flex-row h-screen overflow-hidden' style={{ width: '100%' }}>
      <div className=''>
        <Sidebar value={"dashboard"} ></Sidebar>
      </div>
      <div className='flex-1 container-fluid overflow-y-auto ' style={{ borderRadius: '10px' }}>
        <Topnav ></Topnav>

        <div className='d-flex justify-content-between mt-1' >

          <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
            <li class="nav-item text-primary d-flex " role="presentation">
              <section className={`mt-2 heading d-flex align-items-center gap-2 nav-link active`}
                style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
                id="pills-home-tab" data-bs-toggle="pill"
                data-bs-target="#pills-home" role="tab" aria-controls="pills-home"
                aria-selected="true">
                <img className='w-14 ' src={require('../../assets/Images/circle1.png')} alt="" />
                <div className='text-sm'>
                  {/* Applyed Candidates List */}
                  Total Applications
                  <small className='bg-green-400 my-2 text-white px-3 ms-2 w-fit text-xs block rounded' >
                    {pagination.total_all} Candidates </small>
                </div>
              </section>
            </li>

            <li class="nav-item text-primary d-flex" role="presentation">
              <section class='mt-2 d-flex align-items-center gap-2 heading nav-link'
                style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
                id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" role="tab"
                aria-controls="pills-profile" aria-selected="false">
                <img className='w-14 ' src={require('../../assets/Images/circle4.png')} alt="" />
                <div className='text-sm'>  Screening Status
                  <div className='flex my-2 text-xs justify-between gap-2 flex-wrap'>

                    <small className='bg-red-400 text-white px-3  block rounded'> {screeninglist != undefined && screeninglist.length} Assigned </small>
                    <small className='bg-green-400 text-white px-3 block rounded'>{screeninglistCompleted != undefined && screeninglistCompleted.length} Completed </small>
                  </div></div>
              </section>
            </li>
            <li class="nav-item text-primary d-flex" role="presentation">
              <section class='mt-2 d-flex align-items-center gap-2 heading nav-link'
                style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
                id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" role="tab"
                aria-controls="pills-contact" aria-selected="false">
                <img className='w-14 ' src={require('../../assets/Images/circle2.png')} alt="" />
                <div className='text-sm'> Interview Status
                  <div className='flex my-2 text-xs justify-between gap-2 flex-wrap'>

                    <small className='bg-red-400 text-white px-3  block rounded'>{interviewlist != undefined && interviewlist.length} Assigned </small>
                    <small className='bg-green-400 text-white px-3 block rounded'>
                      {interviewCompletedList != undefined && interviewCompletedList.length} Completed
                    </small>
                  </div>
                </div>
              </section>
            </li>
            <li class="nav-item text-primary d-flex" role="presentation">
              <section class='mt-2 d-flex align-items-center gap-2 heading nav-link' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-completed-tab" data-bs-toggle="pill" data-bs-target="#pills-completed" role="tab"
                aria-controls="pills-completed" aria-selected="false">
                <img className='w-14 ' src={require('../../assets/Images/circle3.png')} alt="" />
                <div className='text-sm'>  Final Status

                  <small className='bg-green-400 my-2 text-white ms-2 block  rounded text-xs px-3'> {pagination3.count} resulted </small>
                </div>
              </section>

            </li>
          </ul>
        </div>


        <div class="tab-content p-1" id="myTabContent">
          <div class="tab-pane fade show active mt-1" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
            <div class=" ">
              {/* Nav Tabs  start */}

              <div class="tab-content" id="pills-tabContent">
                {/* Tab 1 start */}
                <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">

                  <div className=' d-flex justify-content-end '>

                    <div class="dropup-center dropstart ">

                      <button class="btn-success btn btn-sm dropdown-toggle" type="button"
                        data-bs-toggle="dropdown" aria-expanded="false">
                        Assign
                      </button>

                      <ul class="dropdown-menu  text-center" style={{ width: '150px' }}>
                        {recname.map((e) => {
                          return (
                            <li onClick={() => sendSelectedDataToApi(e.EmployeeId)} key={e.EmployeeId}
                              className='dropdown-item p-1 text-xs text-break '> Rec Name :
                              <span className='text-break break-words ' > {e.Name && e.Name.slice(0, 15)}{e.Name && e.Name.length > 15 && '...'}  </span></li>
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


                  <div className='flex justify-between items-center   mb-2 '>
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
                      <div className='d-flex gap-2'>
                        <button className=' bg-green-600 text-slate-50 p-2 px-3 rounded ' onClick={handlesearchvalue} >
                          Search
                        </button>
                        <button className=' bg-gray-600 text-slate-50 p-2 px-3 rounded ' onClick={() => {
                          const emptyFilters = { word: '', from: '', to: '' };
                          setFilterApplicationObj(emptyFilters);
                          fetchdata(1, undefined, emptyFilters);
                        }} >
                          Clear
                        </button>
                      </div>
                    </div>
                    <div className='flex gap-3 flex-wrap '>

                      <div className='flex items-center gap-2 text-xs'>
                        Screening process :

                        <select onChange={(e) => {
                          const newVal = e.target.value
                          setAppliedScreeningStatus(newVal)
                          const urlPage = parseInt(searchParams.get('page')) || 1
                          if (urlPage === 1) {
                            fetchdata(1, newVal)
                          } else {
                            handlePageUpdate(1)
                          }
                        }}
                          value={appliedScreeningStatus}
                          className='p-1 text-sm flex ms-auto outline-none border-1 rounded' name="" id="">
                          <option value="Pending">Yet to assign </option>
                          <option value="">All</option>

                          <option value="Assigned">Yet to screen </option>
                          {/* <option value="Completed">Completed </option> */}
                        </select>
                      </div>
                    </div>
                  </div>

                  <article className='flex items-center gap-3'>
                    <p className='mb-0 ' > Total Applications : {pagination.total_all} </p>
                    {pagination.count !== pagination.total_all && (
                      <p className='mb-0 text-muted' > | Filtered : {pagination.count} </p>
                    )}
                  </article>
                  {/* Applied List table */}
                  <div className='rounded  h-[45vh] overflow-y-scroll w-full tablebg table-responsive mt-4'>
                    <table className="w-full ">
                      <tr className='bgclr1 sticky top-0 ' >
                        {/* <th scope="col"></th> */}
                        <th scope="col"><span className='fw-medium'></span>All</th>
                        <th scope="col"><span className='fw-medium'>Full Name</span></th>
                        <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                        <th scope="col"><span className='fw-medium'>Email ID</span></th>
                        <th scope="col"><span className='fw-medium'>Contact Number</span></th>
                        <th scope="col"><span className='fw-medium'>Application Date</span></th>
                        <th scope="col"><span className='fw-medium'>Source of Application</span></th>
                        <th scope="col"><span className='fw-medium'>Position Applied For</span></th>
                        <th scope="col"><span className='fw-medium'>Details</span></th>
                      </tr>

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


                      {!loading && filteredApplyList != undefined && filteredApplyList != undefined && filteredApplyList.map((e) => {
                        // console.log(e, 'appliedjob');

                        return (
                          <tr key={e.id}>
                            <td scope="row"><input type="checkbox" value={e.CandidateId}
                              onChange={handleCheckboxChange} /></td>
                            <td >{e.FirstName}</td>
                            <td > {e.CandidateId}</td>
                            <td >{e.Email}</td>
                            <td >{e.PrimaryContact}</td>
                            <td >{e.AppliedDate} {convertTimeTo12HourFormat(e.AppliedTime)}</td>

                            <td>{e.JobPortalSource == 'others' ? e.Other_jps : e.JobPortalSource} </td>
                            <td >{e.AppliedDesignation}</td>
                            <td onClick={() => sentparticularData(e.CandidateId)} className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal23">
                              view
                            </button>
                            </td>
                          </tr>
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


                                  {/* gap */}




                                  {/*  */}




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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                                  onClick={() => {
                                    setFinalStatus(persondata.CandidateId)
                                    setFinalStatusName(persondata.FirstName + ' ' + persondata.LastName)
                                  }
                                  } className='mx-2 bg-slate-700 text-white rounded px-3 ' >
                                  Final Result
                                </button>
                                {/* <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5"
                                  data-bs-toggle="modal">Schedule Interview</button> */}
                                <button type="button" data-bs-target="#exampleModal23"
                                  data-bs-dismiss="modal" className='bg-blue-600 text-white rounded p-2 '
                                  onClick={() => {
                                    setInterviewModal(persondata);
                                    setSelectedCandidate(persondata.CandidateId)
                                  }}
                                >Schedule Interview</button>
                                {/* <button type="button" class="btn btn-info" data-bs-target="#exampleModalToggle7" data-bs-toggle="modal">Offer Letter</button> */}
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>


                      {/* open Particular Data End */}


                    </table>
                    {/* Loading applied table */}
                    {
                      loading == 'applied' && <LoadingData />
                    }
                  </div>
                  <div className='d-flex justify-content-between p-2'>
                    {/* Pagination Controls */}
                    {pagination && pagination.count > 0 && (
                      <div className="d-flex justify-content-between align-items-center bg-white p-3 rounded shadow-sm border w-100 me-3">

                        {/* Total Count */}
                        <div className="text-muted small">
                          Total: <strong>{pagination.count}</strong>
                        </div>

                        {/* Pagination Controls */}
                        <div className="d-flex align-items-center gap-4">
                          <button
                            type="button"
                            className="btn btn-primary btn-sm rounded px-2"
                            disabled={!pagination.previous}
                            onClick={() => handlePageUpdate(pagination.currentPage - 1)}
                            aria-label="Previous page"
                          >
                            Previous
                          </button>

                          <span className="small px-3 bg-primary text-white rounded">
                            {pagination.currentPage} of {Math.ceil(pagination.count / pageSize)}
                          </span>

                          <button
                            type="button"
                            className="btn btn-primary btn-sm rounded px-2"
                            disabled={!pagination.next}
                            onClick={() => handlePageUpdate(pagination.currentPage + 1)}
                            aria-label="Next page"
                          >
                            Next
                          </button>
                        </div>

                        {/* Page Jump */}
                        <div className="d-flex align-items-center gap-2">
                          <span className="text-muted small">Page</span>
                          <input
                            type="number"
                            className="form-control form-control-sm rounded text-center"
                            style={{ width: "70px" }}
                            min={1}
                            max={Math.ceil(pagination.count / pageSize)}
                            value={pageInput}
                            onChange={(e) => setPageInput(e.target.value)}
                            onKeyDown={(e) => {
                              if (e.key === "Enter") {
                                const page = Number(e.target.value);
                                const totalPages = Math.ceil(pagination.count / pageSize);

                                if (page >= 1 && page <= totalPages) {
                                  handlePageUpdate(page);
                                }
                              }
                            }}
                            aria-label="Go to page"
                          />
                        </div>

                      </div>

                    )}
                    <div className='d-flex gap-2' >
                      <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload}>
                        {downloading ? 'Downloading...' : 'Download'}
                      </button>
                      {/* <a href={down} download="data.xlsx">Down </a> */}

                      <button className=' btn btn-sm h-fit' data-bs-toggle="modal" data-bs-target="#exampleModal9" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button>
                    </div>
                  </div>

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
                {/* Tab 1 end */}

                {/* Tab 2 start */}
                <div class="tab-pane fade"
                  id="pills-profile" role="tabpanel"
                  aria-labelledby="pills-profile-tab" tabindex="0">

                  <ScreeningAssigned fetchdata={fetchdata} fetchdata1={fetchdata1} fetchdata2={fetchdata2} handle_screened_filter_value={handle_screened_filter_value}
                    search_filter_screened={search_filter_screened} screeninglist_All={screeninglist_All}
                    handlescreenedsearchvalue={handlescreenedsearchvalue} int_int_data={int_int_data} load1={load1}
                    searchscreenValue={searchscreenValue} handleCheckboxChange1={handleCheckboxChange1}
                    Screening_candidate_data={Screening_candidate_data} screeninglistCompleted={screeninglistCompleted} screeninglist={screeninglist} Screening_screening_data={Screening_screening_data} />


                  <div className='d-flex justify-content-between p-3'>
                    {/* <button onClick={loadmorefunc1} className='btn btn-sm btn-success'>Load More</button> */}
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

                  <div className='d-flex justify-between mb-2 ' >

                    <ul class="nav nav-pills mb-1 w-100 ms-4"
                      style={{ display: 'flex', justifyContent: 'space-between' }}
                      id="pills-tab" role="tablist">

                      <div className=''>

                        <div class="rounded relative shadow mb-2 border-2 text-sm bgclr p-1">
                          <button className='absolute -top-5 right-2 '>
                            <InfoButton size={12} content={"Search by Name, Interviewer Name, Scheduled By,Applied Designation"} />
                          </button>
                          <input type="text" value={interviewFilterObject.name} name='name'
                            onChange={handleInterviewFilterObject} onKeyDown={(e) => {
                              if (e.key == 'Enter')
                                handlefinlterinterviewFunction()
                            }} placeholder='Search...'
                            class="outline-none bg-transparent shadow-none p-1 " />
                        </div>
                      </div>
                      {/* Range filter */}
                      <section className='bgclr px-1 shadow flex items-center rounded text-sm'>
                        From :
                        <input value={interviewFilterObject.from} name='from' onChange={handleInterviewFilterObject}
                          type="date" className='outline-none bg-transparent mx-1 ' />
                      </section>
                      <section className='bgclr px-1 shadow flex items-center rounded text-sm'>
                        To :
                        <input value={interviewFilterObject.to} name='to' onChange={handleInterviewFilterObject}
                          type="date" className='outline-none bg-transparent mx-1 ' />
                      </section>
                      <button onClick={handlefinlterinterviewFunction} className='savebtn shadow text-white w-40 rounded border-green-100 '>
                        Search
                      </button>
                      <div className='flex rounded  px-1 bgclr shadow justify-end items-center text-sm '>
                        Sort By :
                        <select name="" value={interviewlistSorting}
                          onChange={(e) => {
                            let value = e.target.value
                            setInterviewListSorting(e.target.value)
                            if (value == 'AZ')
                              setFilteredInterviewList((prev) => [...prev].sort((a, b) => a.Candidate_name.localeCompare(b.Candidate_name)))
                            if (value == 'ZA')
                              setFilteredInterviewList((prev) => [...prev].sort((a, b) => b.Candidate_name.localeCompare(a.Candidate_name)))
                          }}
                          className='rounded bg-transparent outline-none mx-2 ' id="">
                          <option value="">Select</option>
                          <option value="AZ">A - Z </option>
                          <option value="ZA">Z - A </option>

                        </select>
                      </div>
                    </ul>
                  </div>
                  <select name="" value={intervewAsssignedcompleted}
                    onChange={(e) => {
                      setInterviewAssignedcompleted(e.target.value)
                      if (e.target.value == 'Assigned')
                        setFilteredInterviewList(interviewlist)
                      if (e.target.value == 'Completed')
                        setFilteredInterviewList(interviewCompletedList)
                    }}
                    className='btngrd border-2 flex ms-auto bg-opacity-70 outline-none rounded border-violet-100 text-white text-xs p-2 ' id="">
                    <option value="Assigned" className='text-black bg-slate-50'>Assigned</option>
                    <option value="Completed" className='text-black bg-slate-50'>Completed</option>
                  </select>
                  {/* <div className='rounded bg-slate-400 w-fit'>
                    <button onClick={() => { setInterviewAssignedcompleted('Assigned'); setFilteredInterviewList(interviewlist) }} className={`${intervewAsssignedcompleted == 'Assigned' ? "bg-blue-600" : 'bg-slate-400'}
                     text-white p-2 duration-500 transition rounded `}>Assigned </button>
                    <button onClick={() => { setInterviewAssignedcompleted('Completed'); setFilteredInterviewList(interviewCompletedList) }} className={`${intervewAsssignedcompleted == 'Completed' ? "bg-blue-600" : 'bg-slate-400'}
                     text-white p-2 duration-500 transition rounded `}>Completed </button>
                  </div> */}
                  {/*  */}
                  <div className='rounded tablebg h-[45vh] 
                  overflow-y-scroll mt-4 m-1 ms-4'>
                    <table class="w-full "  >
                      <thead >
                        <tr className='sticky top-0 bgclr1 '>
                          <th scope="col"><span className='fw-medium'>All</span></th>
                          <th scope="col"><span className='fw-medium'>Full Name</span></th>
                          <th scope="col"><span className='fw-medium'>Canditate ID</span></th>
                          <th scope="col"><span className='fw-medium'>Position Applied For</span></th>

                          {/* <th scope="col"><span className='fw-medium'>Interview Date</span></th> */}
                          <th scope="col"><span className='fw-medium'>Assigned To</span></th>
                          <th scope="col"><span className='fw-medium'>Date Assigned</span></th>


                          <th scope="col"><span className='fw-medium'>Assigned Status</span></th>
                          <th scope="col"><span className='fw-medium'>Interview Round Name</span></th>
                          {/* <th scope="col"><span className='fw-medium'>Interview Type</span></th> */}
                          {/* <th scope="col"><span className='fw-medium'>Interviewed Status</span></th>

                          <th scope="col"><span className='fw-medium'>Interviewed On</span></th> */}
                          {intervewAsssignedcompleted == 'Completed' &&

                            <th scope="col"><span className='fw-medium'>Interview Status </span></th>}

                          <th scope="col"><span className='fw-medium'>Scheduled By</span></th>
                          {intervewAsssignedcompleted == 'Completed' &&
                            <th scope="col"><span className='fw-medium'>
                              Schedule Interview </span></th>}
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
                      {<InterviewCompletedModal setinterviewReviewModal={setinterviewFormFillingModal}
                        rountstatus={intervewAsssignedcompleted}
                        getfunction={fetchdata2} show={interviewCompletedDetailsModal}
                        setshow={setInterviewCompleteDetailsModal} />}

                      {filteredInterviewList != undefined && filteredInterviewList != undefined &&
                        filteredInterviewList.map((e) => (
                          <tr key={e.id}>
                            {console.log("hi", e)}
                            <td scope="row">
                              <input type="checkbox" value={e.Candidate} onChange={handleCheckboxChange2} /></td>

                            {intervewAsssignedcompleted == "Assigned"
                              && <td
                                onClick={() => {
                                  sentparticularData1(e.Candidate, e.id);
                                  setInterviewRoundType(e.InterviewRoundName)
                                  // setinterviewreviewModalShowing(true)
                                  setInterviewCompleteDetailsModal(e.Candidate)
                                }}
                                style={{ cursor: 'pointer', color: 'blue' }}>

                                {e.Candidate_name}</td>}
                            {intervewAsssignedcompleted == "Completed"
                              && e.Assigned_Status == 'Completed' && <td onClick={() => {
                                // sentparticularData1(e.Candidate, e.id);
                                // setInterviewRoundType(e.InterviewRoundName)
                                setInterviewCompleteDetailsModal(e.Candidate)
                              }}
                                // data-bs-toggle="modal" data-bs-target="#exampleModal6"
                                style={{ color: 'green', cursor: 'pointer' }}>{e.Candidate_name}</td>}
                            <td>{e.Candidate}</td>
                            <td>{e.Applied_Designation}</td>

                            {/* <td>{e.InterviewDate}</td> */}
                            <td>
                              {/* {e.interviewer_name} */}
                              <select id="interviewer" disabled={intervewAsssignedcompleted == 'Completed'}
                                name="interviewer" value={e.interviewer}
                                onChange={(ev) => {
                                  let obj = {
                                    id: e.id,
                                    ScheduledBy: user.EmployeeId,
                                    interviewer: ev.target.value
                                  }
                                  console.log('hi', user.EmployeeId);
                                  console.log('hi', e.id);
                                  console.log('hi', obj);
                                  console.log('hi', ev.target.value);
                                  axios.patch(`${port}/root/interviewschedule`, obj).then((response) => {
                                    console.log('hi', response.data);
                                    fetchdata2()
                                    toast.success('Interview rescheduled successfully')
                                  }).catch((error) => {
                                    console.log("hi", error);
                                  })


                                }}

                                className="p-2 rounded outline-none bgclr1 text-blue-600 w-40 ">
                                {/* <option value="" selected>Select Name</option> */}
                                {interviewers.map(interviewer => (
                                  <option key={interviewer.EmployeeId}
                                    value={interviewer.EmployeeId}>
                                    {`${interviewer.Name},${interviewer.EmployeeId}`}
                                  </option>
                                ))}
                              </select>
                            </td>




                            <td>{convertToReadableDateTime(e.ScheduledOn)}</td>

                            <td>{e.Assigned_Status}</td>
                            <td>{e.InterviewRoundName}</td>

                            {/* <td>{e.InterviewType}</td> */}
                            {intervewAsssignedcompleted == 'Completed' &&
                              <td scope="col"><span className='fw-medium'>{e.Review && e.Review.interview_Status}  </span></td>}

                            {/* <td>{e.Review&&e.Review.interview_Status}</td>
                            <td>{e.Review&&e.Review.ReviewedOn}</td> */}
                            <td className='break-words '> {e.ScheduledBy_name} </td>
                            {intervewAsssignedcompleted == 'Completed' && <td >
                              <button onClick={() => {
                                setInterviewModal(e)
                                setSelectedCandidate(e.Candidate)
                                // sentparticularData2(e.Candidate, e.id);
                              }} className='p-1 text-xs rounded bg-blue-600 text-white'>Assign Interview </button>
                            </td>}
                            {/* <td>{e.ScheduledOn}</td> */}
                            {/* <td onClick={() => interviewalldata(e.Candidate,e.id)} className='text-center'>
                            <button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} className="btn btn-sm" >
                              Open
                            </button>
                          </td> */}
                          </tr>
                        ))}

                      {/* open Particular Data Start */}

                      <SchedulINterviewModalForm fetchdata={fetchdata} fetchdata1={fetchdata1} fetchdata2={fetchdata2}
                        candidateId={selectedCandidate} show={interviewModal}
                        setshow={setInterviewModal} />
                      <Modal show={interviewReviewmodalShowing} onHide={() => setinterviewreviewModalShowing(false)}
                        size='xl' >
                        <Modal.Body>
                          <div class="modal-content">
                            <div class="modal-header">
                              <h1 class="modal-title fs-5" id="exampleModalLabel6">Name : {persondata.FirstName}</h1>
                              <button type="button" class="btn-close" onClick={() => setinterviewreviewModalShowing(false)} ></button>
                            </div>
                            <div class="modal-body">
                              {persondata && console.log("hellow", persondata)}
                              <h1>Interview Candidate Information</h1>
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

                                  {/*  */}


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
                                    <td>{persondata.TotalExperience}</td>
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
                                  {persondata.CurrentDesignation &&
                                    <tr>
                                      <th>Current Designation</th>
                                      <td>{persondata.CurrentDesignation}</td>
                                    </tr>}
                                  <tr>
                                    <th>Applied Designation</th>
                                    <td>{persondata.AppliedDesignation}</td>
                                  </tr>
                                  <tr>
                                    <th>Current Salary</th>
                                    <td>{persondata.CurrentCTC}</td>
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
                                    <td>{convertToReadableDateTime(persondata.AppliedDate)}</td>
                                  </tr>
                                </tbody>
                              </table>








                            </div>
                            <div class="modal-footer d-flex justify-content-between">
                              <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                              <div className='d-flex gap-2'>

                                {/* <button type="button" class="btn btn-primary">Assign Task</button> */}

                                {/* <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button> */}



                                {/* <button type="button" class="btn btn-info">Offer Letter</button> */}
                                <button onClick={() => {
                                  setinterviewFormFillingModal(true);
                                  setinterviewreviewModalShowing(false)
                                }}
                                  className='btn btn-success btn-sm'>
                                  Proceed
                                </button>

                              </div>
                            </div>
                          </div>

                        </Modal.Body>
                      </Modal>
                      <div class="modal fade" id="exampleModal13" tabindex="-1" aria-labelledby="exampleModalLabel13" aria-hidden="false">
                        <div class="modal-dialog modal-fullscreen">
                          <div class="modal-content">
                            <div class="modal-header">
                              <h1>Interview Status</h1>
                              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                              <div class="modal-body container-fluid">
                                {/* Candidate Information start */}
                                <div className="row justify-content-center m-0">
                                  <h4 className='mt-4 text-primary'>Candidate Information</h4>
                                  <div className="col-lg-12   rounded-lg">
                                    <table className="table table-bordered">
                                      <tbody>
                                        <tr>
                                          <th>ID</th>
                                          <td>{int_candi_data.id}</td>
                                        </tr>
                                        <tr>
                                          <th>Candidate ID</th>
                                          <td>{int_candi_data.CandidateId}</td>
                                        </tr>
                                        <tr>
                                          <th>First Name</th>
                                          <td>{int_candi_data.FirstName}</td>
                                        </tr>
                                        <tr>
                                          <th>Last Name</th>
                                          <td>{int_candi_data.LastName}</td>
                                        </tr>
                                        <tr>
                                          <th>Email</th>
                                          <td>{int_candi_data.Email}</td>
                                        </tr>
                                        <tr>
                                          <th>Primary Contact</th>
                                          <td>{int_candi_data.PrimaryContact}</td>
                                        </tr>
                                        <tr>
                                          <th>Secondary Contact</th>
                                          <td>{int_candi_data.SecondaryContact}</td>
                                        </tr>
                                        <tr>
                                          <th>Location</th>
                                          <td>{int_candi_data.Location}</td>
                                        </tr>
                                        <tr>
                                          <th>Gender</th>
                                          <td>{int_candi_data.Gender}</td>
                                        </tr>

                                        {/*  */}

                                        {/*  */}
                                        {/* Fresher start  */}

                                        <tr className={` ${int_candi_data.Fresher ? ' ' : 'd-none'} `}>
                                          <th> {int_candi_data.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                          {/* <td >{persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${int_candi_data.Fresher ? ' ' : 'd-none'} `}>
                                          <th>GeneralSkills</th>
                                          <td>{int_candi_data.GeneralSkills}</td>
                                        </tr>
                                        <tr className={` ${int_candi_data.Fresher ? ' ' : 'd-none'} `}>
                                          <th>TechnicalSkills</th>
                                          <td>{int_candi_data.TechnicalSkills}</td>
                                        </tr>
                                        <tr className={` ${int_candi_data.Fresher ? ' ' : 'd-none'} `}>
                                          <th>SoftSkills</th>
                                          <td>{int_candi_data.SoftSkills}</td>
                                        </tr>

                                        {/*  Fresher end */}

                                        {/* Experience Start */}



                                        <tr className={` ${int_candi_data.Experience ? ' ' : 'd-none'} `}>
                                          <th> {int_candi_data.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                          {/* <th>Experience</th> */}
                                          {/* <td>{persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${int_candi_data.Experience ? ' ' : 'd-none'} `}>
                                          <th>GeneralSkills with Exp</th>
                                          <td>{int_candi_data.GeneralSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${int_candi_data.Experience ? ' ' : 'd-none'} `}>
                                          <th>TechnicalSkills with Exp</th>
                                          <td>{int_candi_data.TechnicalSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${int_candi_data.Experience ? ' ' : 'd-none'} `}>
                                          <th>SoftSkills with Exp</th>
                                          <td>{int_candi_data.SoftSkills_with_Exp}</td>
                                        </tr>
                                        {/* Experience Start */}



                                        {/*  */}


                                        <tr>
                                          <th>Highest Qualification</th>
                                          <td>{int_candi_data.HighestQualification}</td>
                                        </tr>
                                        <tr>
                                          <th>University</th>
                                          <td>{int_candi_data.University}</td>
                                        </tr>
                                        <tr>
                                          <th>Specialization</th>
                                          <td>{int_candi_data.Specialization}</td>
                                        </tr>
                                        <tr>
                                          <th>Percentage</th>
                                          <td>{int_candi_data.Percentage}</td>
                                        </tr>
                                        <tr>
                                          <th>Year of Passout</th>
                                          <td>{int_candi_data.YearOfPassout}</td>
                                        </tr>

                                        <tr>
                                          <th>Applied Designation</th>
                                          <td>{int_candi_data.AppliedDesignation}</td>
                                        </tr>
                                        <tr>
                                          <th>Notice Period</th>
                                          <td>{int_candi_data.NoticePeriod}</td>
                                        </tr>
                                        <tr>
                                          <th>Current Designation</th>
                                          <td>{int_candi_data.CurrentDesignation}</td>
                                        </tr>
                                        <tr>
                                          <th>Current CTC</th>
                                          <td>{int_candi_data.CurrentCTC}</td>
                                        </tr>
                                        <tr>
                                          <th>Total Experience</th>
                                          <td>{int_candi_data.TotalExperience}</td>
                                        </tr>
                                        <tr>
                                          <th>Expected Salary</th>
                                          <td>{int_candi_data.ExpectedSalary}</td>
                                        </tr>
                                        <tr>
                                          <th>Contacted By</th>
                                          <td>{int_candi_data.ContactedBy}</td>
                                        </tr>
                                        <tr>
                                          <th>Job Portal Source</th>
                                          <td>{int_candi_data.JobPortalSource}</td>
                                        </tr>
                                        <tr>
                                          <th>Applied Date</th>
                                          <td>{int_candi_data.AppliedDate}</td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                </div>
                                {/* Candidate Information end */}

                                {/* Interview Round start */}
                                <div className="row justify-content-center m-0">
                                  <h4 className='mt-4 text-primary'>Interviewer Data</h4>
                                  <div className="col-lg-12   rounded-lg">
                                    <table className="table table-bordered">
                                      <tbody>
                                        <tr>
                                          <th>Interview Round Name</th>
                                          <td>{int_int_data && int_int_data.InterviewRoundName}</td>
                                        </tr>
                                        <tr>
                                          <th>Task Assigned</th>
                                          <td>{int_int_data && int_int_data.TaskAssigned}</td>
                                        </tr>
                                        <tr>
                                          <th>Interviewer</th>
                                          <td>{int_int_data && int_int_data.interviewer}</td>
                                        </tr>
                                        <tr>
                                          <th>Interview Date</th>
                                          <td>{int_int_data && int_int_data.InterviewDate}</td>
                                        </tr>
                                        <tr>
                                          <th>Interview Type</th>
                                          <td>{int_int_data && int_int_data.InterviewType}</td>
                                        </tr>
                                        <tr>
                                          <th>Scheduled By</th>
                                          <td>{int_int_data && int_int_data.ScheduledBy}</td>
                                        </tr>
                                        <tr>
                                          <th>Scheduled On</th>
                                          <td>{int_int_data && int_int_data.ScheduledOn}</td>
                                        </tr>

                                      </tbody>
                                    </table>
                                  </div>

                                  <h4 className='mt-4 text-primary'>Interview Review</h4>
                                  <div className="col-lg-12   rounded-lg">
                                    <table className="table table-bordered">
                                      <tbody>

                                        <tr>
                                          <th>Candidate Id</th>
                                          <td>{int_int_data && int_int_data.CandidateId}</td>
                                        </tr>
                                        <tr>
                                          <th>Name</th>
                                          <td>{int_int_data && int_int_data.Name}</td>
                                        </tr>
                                        <tr>
                                          <th>Position Applied For</th>
                                          <td>{int_int_data && int_int_data.PositionAppliedFor}</td>
                                        </tr>
                                        <tr>
                                          <th>Source By</th>
                                          <td>{int_int_data && int_int_data.SourceBy}</td>
                                        </tr>
                                        <tr>
                                          <th>Source Name</th>
                                          <td>{int_int_data && int_int_data.SourceName}</td>
                                        </tr>
                                        <tr>
                                          <th>Date</th>
                                          <td>{int_int_data && int_int_data.Date}</td>
                                        </tr>
                                        <tr>
                                          <th>Location Applied For</th>
                                          <td>{int_int_data && int_int_data.LocationAppliedFor}</td>
                                        </tr>
                                        <tr>
                                          <th>Contact</th>
                                          <td>{int_int_data && int_int_data.Contact}</td>
                                        </tr>
                                        <tr>
                                          <th>Qualification</th>
                                          <td>{int_int_data && int_int_data.Qualification}</td>
                                        </tr>
                                        <tr>
                                          <th>Related Experience</th>
                                          <td>{int_int_data && int_int_data.RelatedExperience}</td>
                                        </tr>
                                        <tr>
                                          <th>Job Stability With Previous Employers</th>
                                          <td>{int_int_data && int_int_data.JobStabilityWithPreviousEmployers}</td>
                                        </tr>
                                        <tr>
                                          <th>Reason For Leaving Immediate Employer</th>
                                          <td>{int_int_data && int_int_data.ReasionForLeavingImadiateEmployeer}</td>
                                        </tr>
                                        <tr>
                                          <th>Appearance and Personality</th>
                                          <td>{int_int_data && int_int_data.Appearence_and_Personality}</td>
                                        </tr>
                                        <tr>
                                          <th>Clarity Of Thought</th>
                                          <td>{int_int_data && int_int_data.ClarityOfThought}</td>
                                        </tr>
                                        <tr>
                                          <th>English Language Skills</th>
                                          <td>{int_int_data && int_int_data.EnglishLanguageSkills}</td>
                                        </tr>
                                        <tr>
                                          <th>Awareness On Technical Dynamics</th>
                                          <td>{int_int_data && int_int_data.AwarenessOnTechnicalDynamics}</td>
                                        </tr>
                                        <tr>
                                          <th>Interpersonal Skills</th>
                                          <td>{int_int_data && int_int_data.InterpersonalSkills}</td>
                                        </tr>
                                        <tr>
                                          <th>IT Skills</th>
                                          <td>{int_int_data && int_int_data.ITSkills}</td>
                                        </tr>
                                        <tr>
                                          <th>Understanding Of Clients Requirements</th>
                                          <td>{int_int_data && int_int_data.UnderstandingOfClientsRequirements}</td>
                                        </tr>
                                        <tr>
                                          <th>Behavioral Skills</th>
                                          <td>{int_int_data && int_int_data.BehaviouralSkills}</td>
                                        </tr>
                                        <tr>
                                          <th>Overall Impression</th>
                                          <td>{int_int_data && int_int_data.OverallImpression}</td>
                                        </tr>
                                        <tr>
                                          <th>Decision Making</th>
                                          <td>{int_int_data && int_int_data.DecisionMaking}</td>
                                        </tr>
                                        <tr>
                                          <th>Comments</th>
                                          <td>{int_int_data && int_int_data.Comments}</td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                </div>
                                {/* Interview Round end */}
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>


                      {/* open Particular Data End */}


                    </table>
                  </div>
                  <div className='d-flex justify-content-between p-2'>
                    {/* <button onClick={loadmorefunc3} className='btn btn-sm btn-success'>Load More</button> */}
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
                  <div className="d-flex gap-2 align-items-center">
                    <div className='w-100 ' >
                      <div className="d-flex justify-content-between align-items-center w-100">

                        <div className="d-flex gap-2 align-items-center">
                          <div className='bgclr relative rounded p-1 '>
                            <button className='absolute right-0 -top-4 '><InfoButton content={"Search by Name , Candidate ID, Final Result , Applied designation , Mail, Contact"} size={12} /> </button>
                            <input type="text"
                              value={finalSearchTerm}
                              onChange={(e) => {
                                setFinalSearchTerm(e.target.value)
                              }}
                              className='outline-none text-sm bg-transparent' placeholder='Search...  ' />
                          </div>
                          {/* <div className='flex items-center gap-3 bg-white p-1 px-2 rounded  ' >
                        From : <input type="date" value={finalFromDate} onChange={(e) => setFinalFromDate(e.target.value)}
                          className=' outline-none p-1 bg-transparent ' />
                      </div>
                      <div className='flex items-center gap-3 bg-white p-1 px-2 rounded  ' >
                        To : <input type="date" value={finalToDate} onChange={(e) => setFinalToDate(e.target.value)}
                          className=' outline-none p-1 bg-transparent ' />
                      </div> */}
                          <div className='d-flex gap-2'>
                            <button className=' bg-green-600 text-slate-50 p-1 px-3 rounded ' onClick={() => fetchdata3(1, finalSearchTerm, finalFromDate, finalToDate)} >
                              Search
                            </button>
                            <button className=' bg-gray-600 text-slate-50 p-1 px-3 rounded ' onClick={() => {
                              setFinalSearchTerm('');
                              setFinalFromDate('');
                              setFinalToDate('');
                              fetchdata3(1, '', '', '');
                            }} >
                              Clear
                            </button>
                          </div>
                        </div>


                        <div className='d-flex align-items-center bgclr  rounded px-2 text-sm '>
                          Sort By :
                          <select name=""
                            onChange={(e) => {
                              let value = e.target.value
                              if (value == 'AZ')
                                setFilterFinalData((prev) => [...prev].sort((a, b) => a.FirstName.localeCompare(b.FirstName)))
                              if (value == 'ZA')
                                setFilterFinalData((prev) => [...prev].sort((a, b) => b.FirstName.localeCompare(a.FirstName)))
                            }}
                            className='outline-none bg-transparent ' id="">
                            <option value="">Select</option>
                            <option value="AZ">A - Z </option>
                            <option value="ZA">Z - A </option>

                          </select>
                        </div>
                      </div>
                    </div>



                    {/* <div>
                        <li class="nav-item text-primary d-flex me-4" style={{ fontSize: '18px' }} >

                          <select className="form-select shadow-none" id="ageGroup" style={{ width: '100px', height: '30px', fontSize: '9px', outline: 'none' }}
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
                      </div> */}


                    {/* </ul> */}
                    {/* </div> */}
                  </div>


                  <div className='rounded pt-0 h-[50vh] overflow-y-scroll table-responsive tablebg mt-4'>
                    <table class="w-full">
                      <thead >
                        <tr className='sticky top-0 bgclr1 '>

                          <th scope="col"><span className='fw-medium'>Select</span></th>
                          <th scope="col"><span className='fw-medium'>Full Name</span></th>
                          <th scope="col"><span className='fw-medium'>Canditate Id</span></th>
                          <th scope="col"><span className='fw-medium'>Email ID</span></th>
                          <th scope="col"><span className='fw-medium'>Contact Number</span></th>
                          <th scope="col"><span className='fw-medium'>Position Applied For</span></th>
                          <th scope="col"><span className='fw-medium'>Experience </span></th>

                          <th scope="col"><span className='fw-medium'>Status Update</span></th>
                        </tr>
                      </thead>
                      {filterFinalData != undefined && filterFinalData != undefined && filterFinalData.map((e) => {
                        // console.log('final', e);
                        return (
                          <tbody>
                            <tr key={e.id} className={` ${e.FinalResult == 'offered' && 'bg-blue-50'} ${e.FinalResult == 'Reject' && e.InterviewStatus != 'Completed' && 'bg-red-50'} `} >
                              <td scope="row"><input type="checkbox" value={e.CandidateId}
                                onChange={handleCheckboxChange3} /></td>
                              <td onClick={() => setFinalResultObj(e)}
                                style={{ cursor: 'pointer', color: 'blue' }}>{e.FirstName}</td>
                              <td > {e.CandidateId} </td>
                              <td >{e.Email}</td>
                              <td >{e.PrimaryContact}</td>
                              <td >{e.AppliedDesignation}</td>
                              {/* <td onClick={() => Callfinal_details_data(e.CandidateId)} className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal12">
                                details
                              </button>
                              </td> */}
                              <td> {e.current_position} </td>
                              <td>
                                <div>
                                  {/* <label htmlFor="ageGroup" className="form-label">Interview Status:</label> */}
                                  {e.FinalResult == 'offered' ? <p className=' '>
                                    Offered

                                  </p> : (e.FinalResult == 'Reject' && e.InterviewStatus != 'Completed') ? <p>
                                    Rejected in Screening
                                  </p> :
                                    <select className=" w-[200px] rounded p-2 outline-none "
                                      id="ageGroup"
                                      value={e.FinalResult} onChange={(d) => {
                                        setseleceted_candidateid(e.CandidateId)
                                        setfinal_status_value(d.target.value)
                                        setselectstatus(e)
                                        setselectedFinalResultName(e.FirstName)
                                      }}>
                                      <option value="">Select</option>
                                      {/* <option value="Pending">Pending</option> */}
                                      <option value="consider_to_client">Consider for Client</option>
                                      <option value="Internal_Hiring">Internal Hiring</option>
                                      <option value="Reject">Reject</option>
                                      <option value="On_Hold">On Hold</option>
                                      <option value="Rejected_by_Candidate">
                                        {/* Rejected by Candidate */} Candidate Withdrawal
                                      </option>

                                    </select>}
                                </div>

                              </td>

                            </tr>
                          </tbody>

                        )
                      })}
                      <FinalResultCompleted show={finalResultObj} setshow={setFinalResultObj} />


                      {/* open Particular Data Start */}


                      <div className="modal fade" id="exampleModal12" tabindex="-1" aria-labelledby="exampleModalLabel12" aria-hidden="false">
                        <div className="modal-dialog modal-fullscreen">
                          <div className="modal-content">
                            <div className="modal-header">
                              <h1>Candidate All Information</h1>
                              <button type="button" className="btn-close" onClick={() => { window.location.reload() }} data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div className="modal-body">
                              <div className="modal-body container-fluid ">

                                {/* Candidate Information start */}
                                <div className="row justify-content-center m-0">
                                  <h4 className='mt-4 text-primary'>Candidate Information</h4>
                                  <div className="col-lg-12   rounded-lg">
                                    <table class="table table-bordered">
                                      <tbody>
                                        <tr>
                                          <th>Name</th>
                                          <td>{Canditateinformation.FirstName} {Canditateinformation.LastName}</td>
                                        </tr>
                                        <tr>
                                          <th>Email</th>
                                          <td>{Canditateinformation.Email}</td>
                                        </tr>
                                        <tr>
                                          <th>Gender</th>
                                          <td>{Canditateinformation.Gender}</td>
                                        </tr>
                                        <tr>
                                          <th>Primary Contact</th>
                                          <td>{Canditateinformation.PrimaryContact}</td>
                                        </tr>
                                        <tr>
                                          <th>Secondary Contact</th>
                                          <td>{Canditateinformation.SecondaryContact}</td>
                                        </tr>
                                        <tr>
                                          <th>Location</th>
                                          <td>{Canditateinformation.Location}</td>
                                        </tr>
                                        {/* Fresher start  */}

                                        <tr className={` ${Canditateinformation.Fresher ? ' ' : 'd-none'} `}>
                                          <th> {Canditateinformation.Fresher === 'true' ? 'Experience' : 'Fresher'}</th>
                                          {/* <td >{persondata.Fresher === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${Canditateinformation.Fresher ? ' ' : 'd-none'} `}>
                                          <th>GeneralSkills</th>
                                          <td>{Canditateinformation.GeneralSkills}</td>
                                        </tr>
                                        <tr className={` ${Canditateinformation.Fresher ? ' ' : 'd-none'} `}>
                                          <th>TechnicalSkills</th>
                                          <td>{Canditateinformation.TechnicalSkills}</td>
                                        </tr>
                                        <tr className={` ${Canditateinformation.Fresher ? ' ' : 'd-none'} `}>
                                          <th>SoftSkills</th>
                                          <td>{Canditateinformation.SoftCanditateinformationSkills}</td>
                                        </tr>

                                        {/*  Fresher end */}

                                        {/* Experience Start */}



                                        <tr className={` ${Canditateinformation.Experience ? ' ' : 'd-none'} `}>
                                          <th> {Canditateinformation.Fresher === 'true' ? 'Fresher' : 'Experience'}</th>

                                          {/* <th>Experience</th> */}
                                          {/* <td>{persondata.Experience === 'true' ? 'False' : 'True'}</td> */}
                                        </tr>
                                        <tr className={` ${Canditateinformation.Experience ? ' ' : 'd-none'} `}>
                                          <th>GeneralSkills with Exp</th>
                                          <td>{Canditateinformation.GeneralSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${Canditateinformation.Experience ? ' ' : 'd-none'} `}>
                                          <th>TechnicalSkills with Exp</th>
                                          <td>{Canditateinformation.TechnicalSkills_with_Exp}</td>
                                        </tr>
                                        <tr className={` ${Canditateinformation.Experience ? ' ' : 'd-none'} `}>
                                          <th>SoftSkills with Exp</th>
                                          <td>{Canditateinformation.SoftSkills_with_Exp}</td>
                                        </tr>
                                        {/* Experience Start */}

                                        <tr>
                                          <th>Highest Qualification</th>
                                          <td>{Canditateinformation.HighestQualification}</td>
                                        </tr>
                                        <tr>
                                          <th>University</th>
                                          <td>{Canditateinformation.University}</td>
                                        </tr>
                                        <tr>
                                          <th>Specialization</th>
                                          <td>{Canditateinformation.Specialization}</td>
                                        </tr>
                                        <tr>
                                          <th>Percentage</th>
                                          <td>{Canditateinformation.Percentage}</td>
                                        </tr>
                                        <tr>
                                          <th>Year of Passout</th>
                                          <td>{Canditateinformation.YearOfPassout}</td>
                                        </tr>

                                        <tr>
                                          <th>Applied Designation</th>
                                          <td>{Canditateinformation.AppliedDesignation}</td>
                                        </tr>
                                        <tr>
                                          <th>Expected Salary</th>
                                          <td>{Canditateinformation.ExpectedSalary}</td>
                                        </tr>
                                        <tr>
                                          <th>Contacted By</th>
                                          <td>{Canditateinformation.ContactedBy}</td>
                                        </tr>
                                        <tr>
                                          <th>Job Portal Source</th>
                                          <td>{Canditateinformation.JobPortalSource}</td>
                                        </tr>
                                        <tr>
                                          <th>Applied Date</th>
                                          <td>{Canditateinformation.AppliedDate}</td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                </div>
                                {/* Candidate Information end */}

                                {/* Interview Round start */}
                                <div className="row justify-content-center m-0">
                                  {/* <h4 className='mt-4 text-primary'>Interview Round</h4> */}

                                  <div className="col-lg-12  rounded-lg">
                                    {Canditateinterviewdata.map((interview, index) => (
                                      <div key={index}>
                                        <h4 className='text-primary' ><strong>Interview Round {index + 1}</strong></h4>
                                        <table className="table table-bordered">
                                          <tbody>
                                            {Object.entries(interview).map(([key, value]) => (
                                              key === 'Intrview_review' ? (
                                                <React.Fragment key={key}>
                                                  <tr><td colSpan="2" className='fw-bold text-primary'>Interview Review</td></tr>
                                                  {Object.entries(value).map(([subKey, subValue]) => (
                                                    <tr key={subKey}>
                                                      <th>{subKey.replace(/_/g, ' ')}</th>
                                                      <td>{subValue}</td>
                                                    </tr>
                                                  ))}
                                                </React.Fragment>
                                              ) : (
                                                <tr key={key}>
                                                  <th>{key.replace(/_/g, ' ')}</th>
                                                  <td>{value}</td>
                                                </tr>
                                              )
                                            ))}
                                          </tbody>
                                        </table>
                                      </div>
                                    ))}
                                  </div>
                                </div>
                                {/* Interview Round end */}

                                {/* Screening Round start */}
                                <div className="row justify-content-center m-0">
                                  {/* <h4 className='mt-4 text-primary'>Screening Round</h4> */}
                                  <div className="col-lg-12  rounded-lg">
                                    {Canditatescreeningdata.map((screening, index) => (
                                      <div key={index}>
                                        <h4 className='text-primary'><strong>Screening {index + 1}</strong></h4>
                                        <table className="table table-bordered">
                                          <tbody>
                                            {Object.entries(screening).map(([key, value]) => (
                                              key === 'screening_review' ? (
                                                <React.Fragment key={key}>
                                                  <tr><td colSpan="2" className='fw-bold text-primary'>Screening Review</td></tr>
                                                  {Object.entries(value).map(([subKey, subValue]) => (
                                                    <tr key={subKey}>
                                                      <th>{subKey.replace(/_/g, ' ')}</th>
                                                      <td>{subValue}</td>
                                                    </tr>
                                                  ))}
                                                </React.Fragment>
                                              ) : (
                                                <tr key={key}>
                                                  <th>{key.replace(/_/g, ' ')}</th>
                                                  <td>{value}</td>
                                                </tr>
                                              )
                                            ))}
                                          </tbody>
                                        </table>
                                      </div>
                                    ))}
                                  </div>
                                </div>
                                {/* Screening Round end */}

                                {/* Uploaded Documents start */}
                                <div className="row justify-content-center m-0">
                                  <h4 className='mt-4 text-primary'>Uploaded Documents</h4>
                                  <div className="col-lg-12  rounded-lg">
                                    {CanditateUploadedDocuments.map((e, index) => (
                                      <div key={index}>
                                        <h6><strong>Document {index + 1}</strong></h6>
                                        <table className="table table-bordered">
                                          <tbody>
                                            {Object.entries(e).map(([key, value]) => (
                                              <tr key={key}>
                                                <th>{key.replace(/_/g, ' ')}</th>
                                                <td>
                                                  {key === 'Salary_Drawn_Payslips' || key === 'Document' ? (
                                                    <a href={value} target="_blank" rel="noopener noreferrer">Download</a>
                                                  ) : value}
                                                </td>
                                              </tr>
                                            ))}
                                          </tbody>
                                        </table>
                                        <div className='d-flex'>
                                          <button className='btn btn-warning btn-sm' onClick={() => handleSubmit123(e.id, e.CandidateID)} data-bs-dismiss="modal">Sent Mail</button>
                                          <button className='btn btn-success btn-sm ms-3' onClick={() => { setCandid_id(e.id) }} data-bs-target="#exampleModal24" data-bs-toggle="modal">Verify</button>
                                        </div>
                                      </div>
                                    ))}
                                  </div>
                                </div>
                                {/* Uploaded Documents end */}

                                <div className="row d-flex justify-content-between m-0 w-100 mt-4">
                                  <div className='w-50'>
                                    <button type="button" className="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
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
                      </div>





                      {/* open Particular Data End */}


                    </table>
                    {/* Loading final table */}
                    {loading === 'final' && <LoadingData />}
                  </div>
                  <div className='d-flex justify-content-between p-2'>
                    {/* Pagination Controls */}
                    {pagination3 && pagination3.count > 0 && (
                      <div className="d-flex justify-content-between align-items-center bg-white p-2 rounded shadow-sm border w-full me-3">
                        <div className="text-sm text-muted">
                          Total : <strong>{pagination3.count}</strong>
                        </div>

                        <div className="d-flex align-items-center gap-4">
                          <button
                            type="button"
                            className="btn btn-primary btn-sm rounded px-1"
                            disabled={!pagination3.previous}
                            onClick={() => handlePageUpdate3(pagination3.currentPage - 1)}
                            aria-label="Previous page"
                          >
                            Previous
                          </button>

                          <span className="small px-3 bg-primary text-white rounded">
                            {pagination3.currentPage} of {Math.ceil(pagination3.count / pageSize)}
                          </span>

                          <button
                            type="button"
                            className="btn btn-primary btn-sm rounded px-2"
                            disabled={!pagination3.next}
                            onClick={() => handlePageUpdate3(pagination3.currentPage + 1)}
                            aria-label="Next page"
                          >
                            Next
                          </button>
                        </div>


                        <div className="d-flex align-items-center gap-2">
                          <span className="text-sm">Page</span>
                          <input
                            type="number"
                            className="form-control form-control-sm border-slate-800 "
                            style={{ width: "60px" }}
                            min={1}
                            max={Math.ceil(pagination3.count / pageSize)}
                            value={pageInput3}
                            onChange={(e) => setPageInput3(e.target.value)}
                            onKeyDown={(e) => {
                              if (e.key === "Enter") {
                                const page = Number(e.target.value)
                                const totalPages = Math.ceil(pagination3.count / pageSize)
                                if (page >= 1 && page <= totalPages) {
                                  handlePageUpdate3(page)
                                }
                              }
                            }}
                          />
                        </div>
                      </div>
                    )}
                    {/* <button onClick={loadmorefunc3} className='btn btn-sm btn-success'>Load More</button> */}
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
                      <label for="candidateId">Candidate:</label>
                      <input type="text" id="CandidateId" value={persondata.CandidateId} class="form-control" />
                    </div>
                    <div class="form-group">
                      <label for="InterviewRoundName">Interview Round Name:</label>
                      <select id="InterviewRoundName" name="InterviewRoundName" value={formData.InterviewRoundName} onChange={handleInputChange} required class="form-control">
                        <option value="" selected>Select Round</option>
                        <option value="hr_round" >HR Round</option>
                        <option value="manager_round" >Manager Round</option>

                        <option value="technical_round" >Technical Round </option>
                      </select>
                    </div>

                    {/* <div class="form-group">
                      <label for="taskAssign">Task Assign:</label>
                      <input type="text" id="TaskAssigned" name="TaskAssigned" value={formData.TaskAssigned} onChange={handleInputChange} required class="form-control" />
                    </div> */}
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
                      <input type="date" id="InterviewDate" name="InterviewDate"
                        value={formData.InterviewDate}
                        onChange={handleInputChange} required class="form-control" />
                    </div>
                    <div class="form-group">
                      <label for="interviewTime">Interview Time:</label>
                      <input type="time" id="InterviewTime" name="InterviewDTime" onChange={handleTimeInputChange} required class="form-control" />
                    </div>

                    <div class="form-group">
                      <label for="InterviewType">Interview Type:</label>
                      <select id="InterviewType" name="InterviewType" value={formData.InterviewType} onChange={handleInputChange} required class="form-control">
                        <option value="" selected>Select Round</option>
                        <option value="online" >Online</option>
                        <option value="offline" >Offline</option>

                      </select>
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
        <Modal show={interviewformFillingModal} size='xl' onHide={() => setinterviewFormFillingModal(false)} >
          <Modal.Body className=''>


            <button type="button" style={{ backgroundColor: 'transparent !important' }}
              className='border-0 ' onClick={() => setinterviewFormFillingModal(false)} > <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
              </svg></button>

            <div className=' d-flex flex-col justify-content-center w-100'>
              <h3 className='text-primary text-center'>INTERVIEW FORM</h3>

              <div class="modal-body container-fluid ">
                <form>
                  {/* Top inputs  start */}

                  <div className="row justify-content-center m-0">
                    <div className="col-lg-12 p-4 border rounded-lg">
                      <div className="row m-0 pb-2">
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Name" className="form-label">Canditate Id </label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={`${persondata.CandidateId}`} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Name" className="form-label">Name </label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={`${persondata.FirstName}`} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="lastName" className="form-label">Position Applied For</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName" name="LastName" value={persondata.AppliedDesignation} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="email" className="form-label">Source By</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Email" name="Email" value={persondata.ContactedBy} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="primaryContact" className="form-label"> Date</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact" value={convertToReadableDateTime(persondata.AppliedDate)} />
                        </div>
                        {/* <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact" value={persondata.AppliedDesignation} />
                        </div> */}
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Mobile Number</label>
                          <input type="tel" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata.PrimaryContact} />
                        </div>
                      </div>
                    </div>
                  </div>
                  {/* Top inputs  end */}


                  {/* all inputs start */}
                  <div className="row justify-content-center m-0 mt-4">
                    <div className="col-lg-12 flex flex-wrap  p-4 border rounded-lg">
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="qualification" className="form-label">Education qualification:</label>
                        <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="qualification"
                          value={persondata.HighestQualification} />
                      </div>
                      {persondata && !persondata.Fresher && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="experience" className="form-label" >Related Experience:</label>
                        <input type="number" placeholder='1-30 years '
                          className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="experience"
                          value={persondata.TotalExperience} />
                      </div>}
                      {interviewRoundType == 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="" className="form-label">Coding questions score (1-5) :</label>
                        <input type="number" placeholder='1-5 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id=""
                          value={codeans} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setCodeAns("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setCodeAns(5)
                              return
                            }
                            else
                              setCodeAns(e.target.value)
                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' &&
                        <div className="col-md-6 col-lg-4 p-3 mb-3">
                          <label htmlFor="jobStability" className="form-label">Job Stability with Previous Employer (1-5) :</label>
                          <input type="number" placeholder='1-5 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="jobStability"
                            value={jobStability} onChange={(e) => {

                              if (Number(e.target.value) <= 0) {
                                setJobStability("")
                                return
                              }
                              if (Number(e.target.value) > 5) {
                                setJobStability(5)
                                return
                              }
                              else
                                setJobStability(e.target.value)
                            }} />
                        </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="reasonLeaving" className="form-label">Reason For Leaving previous employer:</label>
                        <input type="text" placeholder='Looking for the different oppertunity ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="reasonLeaving"
                          value={reasonLeaving} onChange={(e) => setReasonLeaving(e.target.value)} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="appearancePersonality" className="form-label">Appearance & Personality (1-5) :</label>
                        <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="appearancePersonality"
                          value={appearancePersonality}
                          placeholder='1-5'
                          onChange={(e) => {

                            if (Number(e.target.value) <= 0) {
                              setAppearancePersonality("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setAppearancePersonality(5)
                              return
                            }
                            else
                              setAppearancePersonality(e.target.value)

                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="clarityThought" className="form-label">Clarity of Thought (1-5) :</label>
                        <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                          id="clarityThought" value={clarityThought} placeholder='1-5'
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setClarityThought("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setClarityThought(5)
                              return
                            }
                            else
                              setClarityThought(e.target.value)

                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="englishSkills" className="form-label">English Language Skills (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="englishSkills" value={englishSkills}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setEnglishSkills("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setEnglishSkills(5)
                              return
                            }
                            else
                              setEnglishSkills(e.target.value)
                          }} />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="technicalAwareness" className="form-label">Awareness on Technical Dynamics (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="technicalAwareness" value={technicalAwareness}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTechnicalAwareness("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setTechnicalAwareness(5)
                              return
                            }
                            else
                              setTechnicalAwareness(e.target.value)
                          }} />
                      </div>
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="interpersonalSkills" className="form-label">Interpersonal Skills / Attitude (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="interpersonalSkills"
                          value={interpersonalSkills} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setInterpersonalSkills("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setInterpersonalSkills(5)
                              return
                            }
                            else
                              setInterpersonalSkills(e.target.value)
                          }
                          } />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="confidenceLevel" className="form-label">Confidence Level (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="confidenceLevel"
                          value={confidenceLevel} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setConfidenceLevel("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setConfidenceLevel(5)
                              return
                            }
                            else
                              setConfidenceLevel(e.target.value)
                          }} />
                      </div>
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="ageGroup" className="form-label">Age Group Suitability  :</label>
                        <select className="form-select" id="ageGroup" value={ageGroup} onChange={(e) => setAgeGroup(e.target.value)}>
                          <option value="">Select</option>
                          <option value="yes">Yes</option>
                          <option value="no">No</option>
                        </select>
                      </div>}

                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="logicalReasoning" className="form-label">Analytical & Logical Reasoning Skills (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="logicalReasoning" value={logicalReasoning}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setLogicalReasoning("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setLogicalReasoning(5)
                              return
                            }
                            else
                              setLogicalReasoning(e.target.value)
                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3                 ">
                        <label htmlFor="careerPlans" className="form-label">Career Plans:</label>
                        <input type="text" placeholder='Looking forward to the future' className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                          id="careerPlans" value={careerPlans} onChange={(e) => setCareerPlans(e.target.value)} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="achievementOrientation" className="form-label">Achievement Orientation  :</label>
                        <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                          placeholder='type here..' id="achievementOrientation" value={achievementOrientation} onChange={(e) => setAchievementOrientation(e.target.value)} />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="driveProblemSolving" className="form-label">Drive / Problem Solving Abilities (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="driveProblemSolving" value={driveProblemSolving}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setDriveProblemSolving("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setDriveProblemSolving(5)
                              return
                            }
                            else
                              setDriveProblemSolving(e.target.value)
                          }} />
                      </div>
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="takeUpChallenges" className="form-label">Ability to Take Up Challenges (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="takeUpChallenges" value={takeUpChallenges}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTakeUpChallenges("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setTakeUpChallenges(5)
                              return
                            }
                            else
                              setTakeUpChallenges(e.target.value)
                          }} />
                      </div>
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="leadershipAbilities" className="form-label">Leadership Abilities (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="leadershipAbilities" value={leadershipAbilities}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setLeadershipAbilities("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setLeadershipAbilities(5)
                              return
                            }
                            else
                              setLeadershipAbilities(e.target.value)
                          }} />
                      </div>
                      {/* {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="companyInterest" className="form-label">Interest With The Company:</label>
                        <select className="form-select" id="companyInterest" value={companyInterest} onChange={(e) => setCompanyInterest(e.target.value)}>
                          <option value="">Select</option>
                          <option value="yes">Yes</option>
                          <option value="no">No</option>
                        </select>
                      </div>} */}

                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="researchCompany" className="form-label">Researched About The Company:</label>
                        <select className="form-select" id="researchCompany" value={researchCompany} onChange={(e) => setResearchCompany(e.target.value)}>
                          <option value="">Select</option>
                          <option value="yes">Yes</option>
                          <option value="no">No</option>
                        </select>
                      </div>}

                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                        <label htmlFor="targetPressure" className="form-label">Ability to Handle Targets / Pressure (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="targetPressure" value={targetPressure}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTargetPressure("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setTargetPressure(5)
                              return
                            }
                            else
                              setTargetPressure(e.target.value)
                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                        <label htmlFor="customerService" className="form-label">Customer Service (1-5) :</label>
                        <input type="number" placeholder='1-5' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="customerService" value={customerService}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setCustomerService("")
                              return
                            }
                            if (Number(e.target.value) > 5) {
                              setCustomerService(5)
                              return
                            }
                            else
                              setCustomerService(e.target.value)
                          }} />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                        <label htmlFor="overallRanking" className="form-label">Overall Candidate Ranking (1 to 5):</label>
                        <input type="number" disabled={true} className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="overallRanking"
                          value={overallRanking}
                          onChange={(e) => setOverallRanking(e.target.value)} />
                      </div>
                    </div>
                  </div>                {/* all inputs End */}

                  {/* For HRD Use only start */}
                  {/* {interviewRoundType == 'hr_round' && <h6 className='mt-4 text-primary'>For HRD Use Only</h6>}
                  {interviewRoundType == 'hr_round' &&
                    <div className="row justify-content-center m-0 mt-4">
                      <div className="col-lg-12 p-4 border rounded-lg">
                        <div className="row m-0 pb-2">
                          {persondata.CurrentCTC && < div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="Name" className="form-label">Last CTC </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastCTC" name="LastCTC"
                              value={persondata.CurrentCTC} />
                          </div>}
                          <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="lastName" className="form-label">Expected CTC</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="ExpectedCTC" name="ExpectedCTC"
                              value={persondata.ExpectedSalary} />
                          </div>
                          {persondata.NoticePeriod && <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="email" className="form-label">Notice Period</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="NoticePeriod" name="NoticePeriod"
                              value={persondata.NoticePeriod} />
                          </div>}
                          <div className="col-md-6 col-lg-3 mb-3">
                            <label htmlFor="primaryContact" className="form-label">DOJ</label>
                            <input type="date" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="DOJ" name="DOJ" value={DOJ} onChange={(e) => setDOJ(e.target.value)} />
                          </div>
                        </div>

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

                        <div className="row m-0 pb-2 mt-4">



                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Certification Submission</label>
                            <select className="form-select " id="ageGroup" value={certificationSubmission} onChange={(e) => setCertificationSubmission(e.target.value)} >
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>

                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Relocation to other city:</label>
                            <select className="form-select " id="ageGroup" value={relocationToCity} onChange={(e) => setRelocationToCity(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                          <div className="mb-3  col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Able to carry the laptop:</label>
                            <select className="form-select " id="ageGroup" value={carrylaptop} onChange={(e) => setcarrylaptop(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>

                          <div className="mb-3 col-md-6 col-lg-6">
                            <label htmlFor="ageGroup" className="form-label">Relocation to other centers:</label>
                            <select className="form-select" id="ageGroup" value={relocationToCenters} onChange={(e) => setRelocationToCenters(e.target.value)}>
                              <option value="">Select</option>
                              <option value="yes">Yes</option>
                              <option value="no">No</option>
                            </select>
                          </div>
                        </div>
                      </div>
                    </div>
                  } */}

                  {/* For HRD Use only end */}


                  {/* Personal Details start */}

                  {/* <h6 className='mt-4 text-primary'>Personal Details</h6>
                    <div className="row justify-content-center m-0 mt-4">
                      <div className="col-lg-12 p-4 border rounded-lg">
                        <div className="row m-0 pb-2">
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Father Designation </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={Fatherdesignation} onChange={(e) => setFatherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="Name" className="form-label">Mother Designation </label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Name" name="Name" value={Motherdesignation} onChange={(e) => setMotherDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-4 mb-3">
                            <label htmlFor="lastName" className="form-label">Number Of Sibilings</label>
                            <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastName" name="LastName" value={Numberofsib} onChange={(e) => setNumberofsib(e.target.value)} />
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
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Languages Known</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={LanguagesKnown} onChange={(e) => setLanguagesKnown(e.target.value)} />
                          </div>


                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Current Location</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={CurrentLocation} onChange={(e) => setCurrentLocation(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">TravellBy</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={TravellBy} onChange={(e) => setTravellBy(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Stay With</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={StayWith} onChange={(e) => setStayWith(e.target.value)} />
                          </div>
                          <div className="col-md-6 col-lg-6 mb-3">
                            <label htmlFor="secondaryContact" className="form-label">Native</label>
                            <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={Native} onChange={(e) => setNative(e.target.value)} />
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
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="InterviewerName" name="InterviewerName"
                            value={interviewerName} />
                        </div>
                        {/* <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Signature" className="form-label">Signature</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Signature" name="Signature" value={signature} onChange={(e) => setSignature(e.target.value)} />
                        </div> */}
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Date" className="form-label">Interview Date</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Date"
                            name="Date" value={getCurrentDate()} onChange={(e) => setDate1(e.target.value)} />
                        </div>
                        <div className="mb-3 col-md-6 col-lg-4">
                          <label htmlFor="ageGroup" className="form-label">Interview Status: <span id='interviewstatuserror' className='text-red-500'>* </span> </label>
                          <select className="form-select" id="ageGroup" value={Interviewstatus} onChange={(e) => setInterviewStatus(e.target.value)}>
                            <option value="">Select</option>
                            <option value="consider_to_client">Consider to Client for Merida</option>
                            <option value="Internal_Hiring">Shortlisted to Next Round </option>
                            <option value="Reject">Reject</option>
                            <option value="On_Hold">On Hold</option>
                            {/* <option value="Offer_did_not_accept">Offerd Did't Accept</option> */}
                          </select>
                        </div>

                        <div className="col-md-12 col-lg-12 mb-3">
                          <label htmlFor="Comments" className="form-label">Comments</label>
                          <textarea className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="Comments" value={comments} onChange={(e) => setComments(e.target.value)}></textarea>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Comments end */}

                </form>

              </div>
              <div class="modal-footer d-flex justify-content-end">
                <div className='d-flex gap-2'>
                  <button type="submit" class="btn btn-success btn-sm"
                    // data-bs-dismiss="modal"
                    onClick={handleproceedingform}>
                    {loading == 'interview' ? 'Loading...' : "Submit"} </button>
                </div>
              </div>
            </div>

          </Modal.Body>
        </Modal>
        {/* INTERVIEW FORM End */}
      </div >
      {
        finalStatus &&
        <FinalStatus show={finalStatus} getfunction={fetchdata}
          name={finalStatusName}
          setshow={setFinalStatus} />
      }
      <Final_status_comment setselectstatus={setselectstatus} selectedName={selectedFinalResultName}
        final_status_value={final_status_value} fetchdata3={fetchdata3}
        selectstatus={selectstatus} candidateid={seleceted_candidateid} setfinalvalue={setfinal_status_value}></Final_status_comment>

    </div >
  )
}

export default Applylist