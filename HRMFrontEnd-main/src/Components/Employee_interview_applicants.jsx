import React, { useContext } from 'react'
import Topnav from './Topnav'
import '../assets/css/fonts.css';
import '../assets/css/media.css'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Sidebar from './Sidebar';
import { Alert, AlertTitle } from '@mui/material';

import '../assets/css/modal.css'
import Recsidebar from './Recsidebar';
import { Link } from 'react-router-dom';
import { port } from '../App'
import Empsidebar from './Empsidebar';
import { HrmStore } from '../Context/HrmContext';
import { toast } from 'react-toastify';


const Employee_interview_applicants = () => {
  let { formatISODate, convertToReadableTime, getCurrentDate, setActivePage, convertToReadableDateTime } = useContext(HrmStore)

  let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
  let username = JSON.parse(sessionStorage.getItem('user')).UserName
  useEffect(() => {
    setActivePage('Applicants')
  }, [])

  const [tab, setTab] = useState("newleads")

  let [applylist, setApplylist] = useState([])

  let [FinalData, setFinalData] = useState([])

  let [FinalDetails, setFinalDetails] = useState([])

  let [screeninglist, setScreeninglist] = useState([])
  let [interviewCompletedDetailsModal, setInterviewCompleteDetailsModal] = useState()

  let [interviewlist, setInterviewlist] = useState([])
  let [interviewCompletedList, setInterviewCompletedList] = useState()
  let [filteredInterviewList, setFilteredInterviewList] = useState()

  let [completedlist, setCompletedlist] = useState([])

  let [screenstatus, setScreenstatus] = useState([])
  const [codeans, setCodeAns] = useState()
  let [carrylaptop, setcarrylaptop] = useState(false)
  let [interviewRoundType, setInterviewRoundType] = useState('')

  const [persondata, setPersondata] = useState({})

  const [interviewers, setInterviewers] = useState([]);

  const [selectedCandidates, setSelectedCandidates] = useState([]);

  const [recname, setrecname] = useState([]);

  const [load, setLoad] = useState(6)
  const loadmore = 6


  const loadmorefunc = () => {
    setLoad(x => x + loadmore)

  }


  const handleStatusChange = (e, value) => {

    console.log(value, e);

    const formData2 = new FormData()

    formData2.append('CandidateId', e);
    formData2.append('FinalStatus', value);

    for (let pair of formData2.entries()) {
      console.log(" Final status & Id ", pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/FinalStatusUpdate`, formData2)
      .then(response => {

        console.log(" ", response);
      })
      .catch(error => {
        console.error('Error:', error);

      });


  };


  const Callfinal_details_data = (e) => {

    console.log("Callfinal_details_data", e);


    axios.post(`${port}/root/FinalStatusView`, { "CandidateId": e }).then((res) => {

      console.log("Callfinal_details", res.data);

      setFinalDetails(res.data)
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

  console.log(selectedCandidates);

  const sendSelectedDataToApi = (id) => {

    console.log(selectedCandidates, id);


    axios.post(`${port}/root/ScreeningAssigning/`, { Candidates: selectedCandidates, Recruiterid: id })
      .then(response => {
        console.log('API response:', response.data);

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
    }).catch((error) => console.log(error))


  }, [])

  // APPLY REC NAME END


  useEffect(() => {

    axios.get(`${port}/root/interviewschedule`).then((e) => {

      console.log(e.data);
      setInterviewers(e.data)
    }).catch((error) => console.log(error))


  }, [])

  console.log(persondata);

  const [formData1, setFormData] = useState({
    Candidate: "",
    InterviewRoundName: '',
    TaskAssigned: '',
    interviewer: '',
    InterviewDate: '',
    InterviewTime: '',
    InterviewType: ''
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData1, [name]: value });
  };

  const handleTimeInputChange = (e) => {
    setFormData({ ...formData1, InterviewTime: e.target.value })
  }



  const handleSubmit = async (e) => {
    formData1.Candidate = Candidateid
    e.preventDefault();
    try {
      // Make POST request to your API endpoint
      const response = await axios.post(`${port}/root/interviewschedule`, formData1);
      console.log('Response:', response.data);



      // Optionally, you can handle success and display a message to the user
    } catch (error) {
      console.error('Error:', error);
      // Handle error, maybe display an error message to the user
      console.log(formData1);
    }
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
    //   const response = await axios.post('${port}/root/', formData1);
    //   console.log('Response:', response.data);


    //   // Optionally, you can handle success and display a message to the user
    // } catch (error) {
    //   console.error('Error:', error);
    //   // Handle error, maybe display an error message to the user
    //   console.log(formData1);
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
    //   const response = await axios.post('${port}/root/interviewschedule', formData1);
    //   console.log('Response:', response.data);


    //   // Optionally, you can handle success and display a message to the user
    // } catch (error) {
    //   console.error('Error:', error);
    //   // Handle error, maybe display an error message to the user
    //   console.log(formData1);
    // }
  };
  useEffect(() => {
    axios.get(`${port}/root/appliedcandidateslist`).then((res) => {
      console.log("Applicand_list ", res.data);
      setApplylist(res.data)
    }).catch((error) => console.log(error))
  }, [])

  useEffect(() => {
    axios.get(`${port}/root/FinalList`).then((res) => {
      console.log("FinalData--- ", res.data);
      setFinalData(res.data)
    }).catch((error) => console.log(error))
  }, [])

  // useEffect(() => {
  //   axios.post(`${port}/root/FinalStatusView`).then((res) => {

  //     console.log("FinalDetails--- ", res.data);
  //     // setFinalDetails(res.data)
  //   }).catch((error)=>console.log(error))
  // }, [])


  useEffect(() => {
    axios.get(`${port}/root/TRS_List_Separation/${Empid}/`).then((res) => {
      console.log("Screening_list", res.data);
      setScreeninglist(res.data)
    }).catch((error) => console.log(error))
  }, [])


  let [intervewAsssignedcompleted, setInterViewAssignedCompleted] = useState('Assigned')


  let getInterviewList = async () => {
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
      setFilteredInterviewList([...uniqueCandidates])
      setInterviewCompletedList([...uniqueCandidatesCompleted])
    } catch (error) {
      console.log("Interview_list", error);
    }
  }

  useEffect(() => {
    if (intervewAsssignedcompleted) {
      getInterviewList()
    }
  }, [])



  useEffect(() => {
    axios.get(`${port}/root/Review_Completed_List`).then((res) => {
      console.log("Screening_Status", res.data);
      setScreenstatus(res.data)
    }).catch((error) => console.log(error))
  }, [])





  const [Candidateid, setCandidate] = useState("")
  const [id, setEmpid] = useState("")

  // Define the function sentparticularData
  const sentparticularData1 = (id, emp_id) => {


    setCandidate(id)
    setEmpid(emp_id)

    // Define the data to be sent in the request
    const dataToSend = {
      id: id // Assuming id is the parameter passed to the function
    };

    // Send a POST request using Axios
    if (id) {
      axios.get(`${port}/root/appliedcandidate/${id}/`, dataToSend)
        .then(response => {
          // Handle the response if needed
          console.log('paticular data:', response.data);
          setPersondata(response.data)
          setCandidate(response.data.CandidateId)
          console.log("person data", response.data);
        })
        .catch(error => {
          // Handle errors if any
          console.error('Error sending data:', error);
        });
    }
  };

  const [Candidateid1, setCandidate1] = useState("")
  const [id1, setEmpid1] = useState("")

  const sentparticularData2 = (id, emp_id) => {

    console.log("send_", id);
    setCandidate1(id)
    setEmpid1(emp_id)

    // Define the data to be sent in the request
    const dataToSend = {
      id: id // Assuming id is the parameter passed to the function
    };

    // Send a POST request using Axios
    if (id) {
      axios.get(`${port}/root/appliedcandidate/${id}/`, dataToSend)
        .then(response => {
          // Handle the response if needed
          console.log('paticular data:', response.data);
          setPersondata(response.data)
          setCandidate(response.data.CandidateId)
          console.log("person data", response.data);
        })
        .catch(error => {
          // Handle errors if any
          console.error('Error sending data:', error);
        });
    }
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

      console.log('File uploaded successfully!', response);
    } catch (error) {
      console.error('Error uploading file:', error);
    }
  };

  // DOWNLOAD EXCEL

  const [downloading, setDownloading] = useState(false);


  const handleDownload = async () => {
    try {
      const response = await axios.get(`${port}/root/download-excel/`, {
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

  // const [commantable , setCommantable]=useState(true)
  const [Screentable, setScreentable] = useState(true)
  const [Interviewtable, setInterviewtable] = useState(false)

  const selectstatus = (e) => {

    if (e.target.value === "screening") {
      // setCommantable(false)
      setScreentable(true)
      setInterviewtable(false)
    }
    if (e.target.value === "interview") {
      // setCommantable(false)
      setScreentable(false)
      setInterviewtable(true)
    }

  }





  const [qualification, setQualification] = useState('');
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

  const [name, setName] = useState('');
  const [position, setPosition] = useState('');
  const [sourceBy, setSourceBy] = useState('');
  const [date, setDate] = useState('');
  const [location, setLocation] = useState('');
  const [sourceName, setSourceName] = useState('');

  const [lastCTC, setLastCTC] = useState('');
  const [expectedCTC, setExpectedCTC] = useState('');
  const [noticePeriod, setNoticePeriod] = useState('');
  const [DOJ, setDOJ] = useState('');
  const [certificationSubmission, setCertificationSubmission] = useState('');
  const [relocationToCity, setRelocationToCity] = useState('');
  const [relocationToCenters, setRelocationToCenters] = useState('');
  const [screeningFeedback, setScreeningFeedback] = useState('');

  const [interviewerName, setInterviewerName] = useState('');
  const [signature, setSignature] = useState('');
  const [date1, setDate1] = useState('');
  const [comments, setComments] = useState('');

  const [interviewtime, setinterviewtime] = useState('');
  const [Totalexperience, setTotalExperience] = useState('');
  const [InterviewScheduledate, setInterviewScheduledate] = useState('');
  const [screeningstatus, setScreeningscreeningstatus] = useState('');

  const [Contactnumber, setContactNumber] = useState('');

  const [Interviewstatus, setInterviewStatus] = useState('');

  const [sixDaysWorking, setsixDaysWorking] = useState('');
  const [FlexibilityonWorkingTimings, setFlexibilityonWorkingTimings] = useState('');


  const [Fatherdesignation, setFatherDesignation] = useState('');
  const [Motherdesignation, setMotherDesignation] = useState('');
  const [Numberofsib, setNumberofsib] = useState('');
  const [Meritalstatus, setMeritalStatus] = useState('');
  const [Spousedesignation, setSpouseDesignation] = useState('');
  const [Numberofkids, setNumberOfKids] = useState('');
  const [LanguagesKnown, setLanguagesKnown] = useState('');

  const [CurrentLocation, setCurrentLocation] = useState('');
  const [TravellBy, setTravellBy] = useState('');
  const [StayWith, setStayWith] = useState('');


  const [Native, setNative] = useState('');



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
        + Number(appearancePersonality) + Number(clarityThought)) / count) / 2).toFixed(2)
      setOverallRanking(avg)
      console.log(avg);
    }
    console.log(count);
  }, [codeans, jobStability, customerService, targetPressure, leadershipAbilities,
    takeUpChallenges, driveProblemSolving,
    confidenceLevel, logicalReasoning, driveProblemSolving, appearancePersonality,
    clarityThought, englishSkills,
    technicalAwareness, interpersonalSkills])




  let handleproceedingform = (e) => {
    e.preventDefault();

    const formData1 = new FormData()

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
    formData1.append('ReviewedBy', username);
    formData1.append('InterviewerName', username);
    formData1.append('Signature', signature);
    formData1.append('ReviewedDate', date1);
    formData1.append('Comments', comments);



    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/InterviewReviewData`, formData1)
      .then((r) => {
        toast.success("Proceding Form Data Successfull")
        console.log("Proceding Form Data Successfull", r.data)

      })
      .catch((err) => {
        toast.error('Proceding Form Data Failed')
        console.log("Interview Assessment Form Error", err)
      })
  }

  let handleScreeingform = (e) => {
    e.preventDefault();

    const formData1 = new FormData()

    formData1.append('id', id1);
    formData1.append('login_user', Empid);
    formData1.append('CandidateId', persondata.id);
    formData1.append('Can_Id', persondata.CandidateId);
    // formData1.append('CandidateId', persondata.CandidateId);
    formData1.append('Name', persondata.FirstName);
    formData1.append('PositionAppliedFor', persondata.AppliedDesignation);
    formData1.append('SourceBy', sourceBy);
    formData1.append('SourceName', persondata.JobPortalSource);
    formData1.append('ContactNumber', Contactnumber);
    formData1.append('Totalexperience', Totalexperience);
    formData1.append('LastCTC', persondata.CurrentCTC);
    formData1.append('ExpectedCTC', persondata.ExpectedSalary);
    formData1.append('InterviewScheduledate', InterviewScheduledate);
    formData1.append('Screening_Status', screeningstatus);

    formData1.append('FatherDesignation', Fatherdesignation);
    formData1.append('MotherDesignation', Motherdesignation);
    formData1.append('no_of_sibilings', Numberofsib);
    formData1.append('MeritalStatus', Meritalstatus);
    formData1.append('SpouseDesignation', Spousedesignation);
    formData1.append('no_of_kids', Numberofkids);
    formData1.append('LanguagesKnown', LanguagesKnown);

    formData1.append('CurrentLocation', CurrentLocation);
    formData1.append('TravellBy', TravellBy);
    formData1.append('StayWith', StayWith);
    formData1.append('Native', Native);

    formData1.append('InterviewerName', username);
    formData1.append('ReviewedBy', username);
    formData1.append('Signature', signature);
    formData1.append('Date1', date1);
    formData1.append('interviewtime', interviewtime);
    formData1.append('Comments', comments);


    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/ScreeningReviewData`, formData1)
      .then((r) => {
        alert("Proceding Form Data Successfull")
        console.log("screeningformres", r.data)

      })
      .catch((err) => {
        console.log("screening form Error", err)
      })
  }



  const [firstName, setFirstName] = useState('');
  const [email, setEmail] = useState('');
  const [appliedDestination, setAppliedDestination] = useState('');
  const [primaryContact, setPrimaryContact] = useState('');
  const [Location, setlocation] = useState('');
  const [fresher, setFresher] = useState(true);
  const [Experience, setexperience] = useState(false);

  const handleSubmit1 = (e) => {
    e.preventDefault();
    const formData = new FormData();

    formData.append('login_user', Empid);
    formData.append('FirstName', firstName);
    formData.append('Email', email);
    formData.append('AppliedDestination', appliedDestination);
    formData.append('PrimaryContact', primaryContact);
    formData.append('Fresher', fresher);
    formData.append('Experience', Experience);
    console.log("Form data submitted:", formData);

    for (let pair of formData.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }

    axios.post(`${port}/root/RecCandidateFillingApplication`, formData)
      .then((response) => {
        alert("Candidate Added Successfully");
        console.log("Candidate_Added_res", response.data);
      })
      .catch((error) => {
        console.error("Candidate_Added_error", error);
      });

  };

  // Applyed search
  const [searchValue, setSearchValue] = useState();
  const [search_filter_applylist, setsearch_filter_applylist] = useState();
  console.log("searchValue", searchValue);
  const handlesearchvalue = (value) => {

    axios.post(`${port}/root/appliedcandidateslist`, value).then((res) => {
      console.log("search_res", res.data);
      setApplylist(res.data)
    }).catch((err) => {
      console.log("search_res", err.data);
    })

  }


  const [formData, setFormData1] = useState({
    Candidate: "",
    InterviewRoundName: '',
    TaskAssigned: '',
    interviewer: '',
    InterviewDate: '',
    InterviewTime: '',
    InterviewType: '',
    login_user: ''
  });

  const handleInputChang = (e) => {
    const { name, value } = e.target;
    setFormData1({ ...formData, [name]: value });
  };

  const handleTimeInputChang = (e) => {
    setFormData1({ ...formData, InterviewTime: e.target.value })
  }

  const [Candidate_ID, setCandidate_ID] = useState('')

  let CanditateId = (e) => {

    console.log("condidate_ID", e);
    setCandidate_ID(e)


  }

  const [ScheduleinterviewAlert, setScheduleinterviewAlert] = useState(false);



  const handleSubmit13 = async (e) => {

    e.preventDefault();

    // formData.Candidate = Candidateid
    formData.Candidate = Candidate_ID
    formData.login_user = Empid

    console.log("schedule_Interview",
      "formData", formData,
      "Login_user", Empid);


    axios.post(`${port}/root/interviewschedule`, formData).then((res) => {
      setScheduleinterviewAlert(true);
      console.log("schedule_Interview_Data_res", res.data);
    }).catch((err) => {

      console.log("schedule_Interview_Data_res_err", err.data);

    })


  };


  return (
    <div className=' d-flex'
      style={{ width: '100%', minHeight: '100%', }}>

      <div className='d-none d-lg-flex'>

        {/* <Sidebar value={"dashboard"} ></Sidebar> */}
        {/* <Recsidebar></Recsidebar> */}
        <Empsidebar value={"dashboard"}></Empsidebar>

      </div>
      <div className='flex-1 container-fluid  mx-auto ' style={{ borderRadius: '10px' }}>
        <Topnav ></Topnav>

        <div className='d-flex nav nav-pills mb-3 container justify-content-between mt-4'>
          <li class="nav-item text-primary d-flex" role="presentation">
            <section class='mt-2 d-flex align-items-center gap-2 heading nav-link' id="pills-home-tab" data-bs-toggle="pill"
              data-bs-target="#pills-home" role="tab" aria-controls="pills-home"
              aria-selected="true"
              style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }}
            >
              <img className='w-14 ' src={require('../assets/Images/circle2.png')} alt="" />
              <div className='text-sm'> Interview process
                <div className='flex my-2 text-xs justify-between gap-2 flex-wrap'>

                  <small className='bg-red-400 text-white px-3  block rounded'>{interviewlist != undefined && interviewlist.length} Assigned </small>
                  <small className='bg-green-400 text-white px-3 block rounded'>{interviewCompletedList != undefined && interviewCompletedList.length} Completed </small>
                </div>
              </div>
            </section>
            {/* <h6 class='mt-2 bg-violet-900 text-white p-2 rounded'  >
              Interview  Applicants</h6>
            <small className='text-danger ms-2   rounded-circle'> {interviewlist != undefined && interviewlist.length} </small> */}
          </li>
        </div>





        {/* Tab 3 start */}
        <div className='' >
          <ul class="  w-100" style={{ display: 'flex', justifyContent: 'space-between' }}
            id="pills-tab" role="tablist">
            <div>
              <div class="input-group mb-3 ">
                <span class="input-group-text" id="basic-addon1"> <i class="fa-solid fa-magnifying-glass" ></i>  </span>
                <input type="text" style={{ width: '200px', height: '30px', fontSize: '9px', outline: 'none' }}
                  class="form-control shadow-none" aria-label="Username" aria-describedby="basic-addon1" />
              </div>
            </div>
            <div>
              <li class=" text-primary d-flex me-4" style={{ fontSize: '18px' }} >


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
          {/* <div className='rounded mx-3 bg-slate-400 w-fit'>
            <button onClick={() => { setInterViewAssignedCompleted('Assigned'); }}
              className={`${intervewAsssignedcompleted == 'Assigned' ? "bg-blue-600" : 'bg-slate-400'}
                     text-white p-2 duration-500 transition rounded `}>Assigned </button>
            <button onClick={() => { setInterViewAssignedCompleted('Completed'); }}
              className={`${intervewAsssignedcompleted == 'Completed' ? "bg-blue-600" : 'bg-slate-400'}
                     text-white p-2 duration-500 transition rounded `}>Completed </button>
          </div> */}
          <select name="" value={intervewAsssignedcompleted}
            onChange={(e) => {
              setInterViewAssignedCompleted(e.target.value)
              if (e.target.value == 'Assigned')
                setFilteredInterviewList(interviewlist)
              if (e.target.value == 'Completed')
                setFilteredInterviewList(interviewCompletedList)
            }}
            className='btngrd border-2 flex ms-auto bg-opacity-70 outline-none rounded border-violet-100 text-white text-xs p-2 ' id="">
            <option value="Assigned" className='text-black'>Assigned</option>
            <option value="Completed" className='text-black'>Completed</option>
          </select>
          <div className='mt-1 rounded-xl my-2 tablebg table-responsive p-2 ' style={{ width: '100%' }}>
            <table class="w-full ">
              <thead >
                <tr >
                  {/* <th scope="col"></th> */}
                  {/* <th scope="col"><span className='fw-medium'></span>All</th> */}
                  <th scope="col">#</th>
                  <th scope="col"><span className='fw-medium'>Name </span></th>
                  <th scope="col"><span className='fw-medium'>Assigned_Status</span></th>
                  <th scope="col"><span className='fw-medium'>Candidate </span></th>
                  <th scope="col"><span className='fw-medium'> InterviewDate </span></th>
                  <th scope="col"><span className='fw-medium'>InterviewRoundName </span></th>

                  <th scope="col"><span className='fw-medium'>InterviewType </span></th>
                  <th scope="col"><span className='fw-medium'>ScheduledBy </span></th>
                  <th scope="col"><span className='fw-medium'>ScheduledOn </span></th>
                  {/* <th scope="col"><span className='fw-medium'> TaskAssigned</span></th> */}
                  <th scope="col"><span className='fw-medium'> interviewer</span></th>



                </tr>
              </thead>

              {/* STATIC VALUE START */}

              {/* <tr>

                        <td > 123</td>
                        <td >Python</td>
                        <td > Jerold</td>
                        <td >23/12/2024</td>
                        <td >technical</td>
                        <td >Offline</td>
                        <td >Mathavn</td>
                        <td >Java</td>
                        <td>scheduled_on</td>
                        <td className='text-center'><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal6">
                          open
                        </button>
                        </td>
                      </tr> */}
              <tbody>
                {filteredInterviewList !== undefined && filteredInterviewList.map((e, index) => (
                  <tr key={e.id}>
                    <td> {index + 1}</td>


                    {e.Assigned_Status == 'Assigned' && <td onClick={() => {
                      sentparticularData1(e.Candidate, e.id);
                      setInterviewRoundType(e.InterviewRoundName)
                    }}
                      data-bs-toggle="modal" data-bs-target="#exampleModal6"
                      style={{ color: 'blue', cursor: 'pointer' }}>{e.Candidate_name}</td>}


                    {e.Assigned_Status == 'Completed' && <td onClick={() => {
                      // sentparticularData1(e.Candidate, e.id);
                      // setInterviewRoundType(e.InterviewRoundName)
                      setInterviewCompleteDetailsModal(e.Candidate)
                    }}
                      // data-bs-toggle="modal" data-bs-target="#exampleModal6"
                      style={{ color: 'green', cursor: 'pointer' }}>{e.Candidate_name}</td>}


                    <td>{e.Assigned_Status}</td>
                    <td>{e.Candidate}</td>
                    <td>{e.InterviewDate} {e.InterviewTime}</td>
                    <td>{e.InterviewRoundName}</td>
                    <td>{e.InterviewType}</td>
                    <td>{e.ScheduledBy}</td>
                    <td>{e.ScheduledOn}  {e.ScheduledTime} </td>
                    {/* <td>{e.TaskAssigned}</td> */}
                    <td>{e.interviewer}</td>

                    {/* <td onClick={() => sentparticularData1(e.Candidate, e.id)} className='text-center'>
                            <button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} className="btn btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal6">
                              Open
                            </button>
                          </td> */}
                  </tr>
                ))}
              </tbody>
              {/* open Particular Data Start */}

              <div class="modal fade" id="exampleModal6" tabindex="-1" aria-labelledby="exampleModalLabel6" aria-hidden="false">
                <div class="modal-dialog modal-xl">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h1 class="modal-title fs-5" id="exampleModalLabel6">Name : {persondata.FirstName}</h1>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                      <h1>Interview Canditate Information</h1>
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
                          <tr className={`${persondata.Fresher ? '' : 'd-none'}`}>
                            <th>Fresher</th>
                            <td>Yes</td>
                          </tr>
                          <tr className={`${persondata.Fresher ? 'd-none' : ''}`}>
                            <th>Experience</th>
                            <td>Yes</td>
                          </tr>
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
                            <th>Technical Skills</th>
                            <td>{persondata.TechnicalSkills}</td>
                          </tr>
                          <tr>
                            <th>General Skills</th>
                            <td>{persondata.GeneralSkills}</td>
                          </tr>
                          <tr>
                            <th>Soft Skills</th>
                            <td>{persondata.SoftSkills}</td>
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
                      <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                      <div className='d-flex gap-2'>

                        {/* <button type="button" class="btn btn-primary">Assign Task</button> */}

                        {/* <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button> */}



                        {/* <button type="button" class="btn btn-info">Offer Letter</button> */}
                        <button className='btn btn-success btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal15">
                          Proceed
                        </button>

                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* open Particular Data End */}


            </table>
          </div>
          <div className='d-flex justify-content-between p-3'>
            <button onClick={loadmorefunc} className='btn btn-sm btn-success'>Load More</button>
            <div>
              <button className='btn btn-sm me-3' style={{ backgroundColor: 'rgb(240,179,74)' }} onClick={handleDownload}>
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
              {/* Tab 3 end */}



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
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <form id="interviewForm" onSubmit={handleSubmit} class="styled-form">
                  <div class="form-group">
                    <label for="candidateId">Candidate ID:</label>
                    <input type="text" id="CandidateId" value={persondata.CandidateId} class="form-control" />
                  </div>
                  <div class="form-group">
                    <label for="interviewRound">Interview Round Name:</label>
                    <input type="text" id="InterviewRoundName" value={formData1.InterviewRoundName} onChange={handleInputChange} name="InterviewRoundName" required class="form-control" />
                  </div>
                  <div class="form-group">
                    <label for="taskAssign">Task Assign:</label>
                    <input type="text" id="TaskAssigned" name="TaskAssigned" value={formData1.TaskAssigned} onChange={handleInputChange} required class="form-control" />
                  </div>
                  <div class="form-group">
                    <label for="interviewer">Interviewer:</label>
                    <select id="interviewer" name="interviewer" value={formData1.interviewer} onChange={handleInputChange} required class="form-control">
                      <option value="" selected>Select Name</option>
                      {interviewers.map(interviewer => (
                        <option key={interviewer.EmployeeId} value={`${interviewer.Name, interviewer.EmployeeId}`}>
                          {`${interviewer.Name, interviewer.EmployeeId}`}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div class="form-group">
                    <label for="interviewDate">Interview Date:</label>
                    <input type="date" id="InterviewDate" name="InterviewDate" value={formData1.InterviewDate} onChange={handleInputChange} required class="form-control" />
                  </div>
                  <div class="form-group">
                    <label for="interviewTime">Interview Time:</label>
                    <input type="time" id="InterviewTime" name="InterviewDTime" onChange={handleTimeInputChange} required class="form-control" />
                  </div>
                  <div class="form-group">
                    <label for="interviewType">Interview Type:</label>
                    <input type="text" id="InterviewType" name="InterviewType" value={formData1.InterviewType} onChange={handleInputChange} required class="form-control" />
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

        {/* Modal  */}

        {/* SCREENING FORM start */}

        <div class="modal fade" id="exampleModal13" tabindex="-1" aria-labelledby="exampleModalLabel13" aria-hidden="false">
          <div class="modal-dialog modal-xl">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" style={{ backgroundColor: 'transparent !important' }} className='border-0 ' data-bs-dismiss="modal" aria-label="Close" > <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                  <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                </svg></button>

                <div className=' d-flex justify-content-center w-100'>
                  <h3 className='text-primary text-center'>SCREENING  FORM</h3>

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
                          <input type="text" className="form-control shadow-none" id="Email" name="Email" value={persondata.ContactedBy} />
                        </div>


                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                          <input type="text" className="form-control shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Contact Number</label>
                          <input type="text" className="form-control shadow-none" id="State" name="State" value={persondata.PrimaryContact} />
                        </div>
                      </div>
                    </div>
                  </div>
                  {/* Top inputs  end */}


                  {/* Personal Details start */}

                  <h6 className='mt-4 text-primary'>Personal Details</h6>
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
                            <option value="single">Single</option>
                            <option value="marrid">Marrid</option>
                            <option value="widowed">Widowed</option>
                            <option value="divorced">Divorced</option>
                          </select>
                        </div>

                        {Meritalstatus === "marrid" && (
                          <>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="primaryContact" className="form-label">Spouse Designation</label>
                              <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                            </div>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                              <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                            </div>
                          </>
                        )}
                        {Meritalstatus === "widowed" && (
                          <>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="primaryContact" className="form-label">Spouse Designation</label>
                              <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                            </div>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                              <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                            </div>
                          </>
                        )}
                        {Meritalstatus === "divorced" && (
                          <>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="primaryContact" className="form-label">Spouse Designation</label>
                              <input type="text" className="form-control shadow-none" id="PrimaryContact" name="PrimaryContact" value={Spousedesignation} onChange={(e) => setSpouseDesignation(e.target.value)} />
                            </div>
                            <div className="col-md-6 col-lg-6 mb-3">
                              <label htmlFor="secondaryContact" className="form-label">No Of Kids</label>
                              <input type="text" className="form-control shadow-none" id="SecondaryContact" name="SecondaryContact" value={Numberofkids} onChange={(e) => setNumberOfKids(e.target.value)} />
                            </div>
                          </>
                        )}


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
                  </div>


                  {/* Personal Details end */}
                  {/* Comments Start  */}
                  <h6 className='mt-4 text-primary'>Comments</h6>
                  <div className="row justify-content-center m-0 mt-4">
                    <div className="col-lg-12 p-4 border rounded-lg">
                      <div className="row m-0 pb-2">
                        <div className="col-md-6 col-lg-6 mb-3">
                          <label htmlFor="InterviewerName" className="form-label">Interviewer Name </label>
                          <input type="text" className="form-control shadow-none" id="InterviewerName" name="InterviewerName" value={username} />
                        </div>


                        <div className="mb-3 col-md-6 col-lg-6">
                          <label htmlFor="researchCompany" className="form-label">Screening Status:</label>
                          <select className="form-select" id="researchCompany" value={screeningstatus} onChange={(e) => setScreeningscreeningstatus(e.target.value)}>
                            <option value="">Select</option>
                            <option value="scheduled">Scheduled</option>
                            <option value="didn't connect">Did't Connect</option>
                            <option value="not intrested">Not Intrested</option>
                            <option value="scheduled interview to client">Schedules Interview to Client</option>
                          </select>
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

                  {/* <button type="button" class="btn btn-primary btn-sm">Preview</button> */}

                  <button type="submit" class="btn btn-success btn-sm" onClick={handleScreeingform} >Submit</button>


                </div>
              </div>
            </div>
          </div>
        </div>
        {/* SCREENING  FORM end */}

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
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="PrimaryContact" name="PrimaryContact" value={persondata.AppliedDate} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Location Applied For</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="SecondaryContact" name="SecondaryContact" value={persondata.AppliedDesignation} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Source Name</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="State" name="State" value={persondata.JobPortalSource} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="secondaryContact" className="form-label">Contact Number</label>
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
                        <label htmlFor="qualification" className="form-label">Qualification:</label>
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
                        <label htmlFor="" className="form-label">Coding questions score (1-10) :</label>
                        <input type="number" placeholder='1-10 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id=""
                          value={codeans} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setCodeAns("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setCodeAns(10)
                              return
                            }
                            else
                              setCodeAns(e.target.value)
                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' &&
                        <div className="col-md-6 col-lg-4 p-3 mb-3">
                          <label htmlFor="jobStability" className="form-label">Job Stability with Previous Employer (1-10) :</label>
                          <input type="number" placeholder='1-10 ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="jobStability"
                            value={jobStability} onChange={(e) => {

                              if (Number(e.target.value) <= 0) {
                                setJobStability("")
                                return
                              }
                              if (Number(e.target.value) > 10) {
                                setJobStability(10)
                                return
                              }
                              else
                                setJobStability(e.target.value)
                            }} />
                        </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="reasonLeaving" className="form-label">Reason For Leaving The Immediate Employer:</label>
                        <input type="text" placeholder='Looking for the different oppertunity ' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="reasonLeaving"
                          value={reasonLeaving} onChange={(e) => setReasonLeaving(e.target.value)} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="appearancePersonality" className="form-label">Appearance & Personality (1-10) :</label>
                        <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="appearancePersonality"
                          value={appearancePersonality}
                          placeholder='1-10'
                          onChange={(e) => {

                            if (Number(e.target.value) <= 0) {
                              setAppearancePersonality("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setAppearancePersonality(10)
                              return
                            }
                            else
                              setAppearancePersonality(e.target.value)

                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="clarityThought" className="form-label">Clarity of Thought (1-10) :</label>
                        <input type="number" className="p-2 border-1 rounded border-slate-400 w-full block outline-none"
                          id="clarityThought" value={clarityThought} placeholder='1-10'
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setClarityThought("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setClarityThought(10)
                              return
                            }
                            else
                              setClarityThought(e.target.value)

                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="englishSkills" className="form-label">English Language Skills (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="englishSkills" value={englishSkills}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setEnglishSkills("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setEnglishSkills(10)
                              return
                            }
                            else
                              setEnglishSkills(e.target.value)
                          }} />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="technicalAwareness" className="form-label">Awareness on Technical Dynamics (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="technicalAwareness" value={technicalAwareness}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTechnicalAwareness("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setTechnicalAwareness(10)
                              return
                            }
                            else
                              setTechnicalAwareness(e.target.value)
                          }} />
                      </div>
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="interpersonalSkills" className="form-label">Interpersonal Skills / Attitude (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="interpersonalSkills"
                          value={interpersonalSkills} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setInterpersonalSkills("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setInterpersonalSkills(10)
                              return
                            }
                            else
                              setInterpersonalSkills(e.target.value)
                          }
                          } />
                      </div>}
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="confidenceLevel" className="form-label">Confidence Level (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="confidenceLevel"
                          value={confidenceLevel} onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setConfidenceLevel("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setConfidenceLevel(10)
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
                        <label htmlFor="logicalReasoning" className="form-label">Analytical & Logical Reasoning Skills (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="logicalReasoning" value={logicalReasoning}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setLogicalReasoning("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setLogicalReasoning(10)
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
                        <label htmlFor="driveProblemSolving" className="form-label">Drive / Problem Solving Abilities (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="driveProblemSolving" value={driveProblemSolving}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setDriveProblemSolving("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setDriveProblemSolving(10)
                              return
                            }
                            else
                              setDriveProblemSolving(e.target.value)
                          }} />
                      </div>
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="takeUpChallenges" className="form-label">Ability to Take Up Challenges (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="takeUpChallenges" value={takeUpChallenges}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTakeUpChallenges("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setTakeUpChallenges(10)
                              return
                            }
                            else
                              setTakeUpChallenges(e.target.value)
                          }} />
                      </div>
                      <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="leadershipAbilities" className="form-label">Leadership Abilities (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="leadershipAbilities" value={leadershipAbilities}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setLeadershipAbilities("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setLeadershipAbilities(10)
                              return
                            }
                            else
                              setLeadershipAbilities(e.target.value)
                          }} />
                      </div>
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="companyInterest" className="form-label">Interest With The Company:</label>
                        <select className="form-select" id="companyInterest" value={companyInterest} onChange={(e) => setCompanyInterest(e.target.value)}>
                          <option value="">Select</option>
                          <option value="yes">Yes</option>
                          <option value="no">No</option>
                        </select>
                      </div>}

                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3">
                        <label htmlFor="researchCompany" className="form-label">Researched About The Company:</label>
                        <select className="form-select" id="researchCompany" value={researchCompany} onChange={(e) => setResearchCompany(e.target.value)}>
                          <option value="">Select</option>
                          <option value="yes">Yes</option>
                          <option value="no">No</option>
                        </select>
                      </div>}

                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                        <label htmlFor="targetPressure" className="form-label">Ability to Handle Targets / Pressure (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="targetPressure" value={targetPressure}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setTargetPressure("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setTargetPressure(10)
                              return
                            }
                            else
                              setTargetPressure(e.target.value)
                          }} />
                      </div>}
                      {interviewRoundType != 'technical_round' && <div className="col-md-6 col-lg-4 p-3 mb-3 ">
                        <label htmlFor="customerService" className="form-label">Customer Service (1-10) :</label>
                        <input type="number" placeholder='1-10' className="p-2 border-1 rounded border-slate-400 w-full block outline-none" id="customerService" value={customerService}
                          onChange={(e) => {
                            if (Number(e.target.value) <= 0) {
                              setCustomerService("")
                              return
                            }
                            if (Number(e.target.value) > 10) {
                              setCustomerService(10)
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
                  {interviewRoundType == 'hr_round' && <h6 className='mt-4 text-primary'>For HRD Use Only</h6>}
                  {interviewRoundType == 'hr_round' && <div className="row justify-content-center m-0 mt-4">
                    <div className="col-lg-12 p-4 border rounded-lg">
                      <div className="row m-0 pb-2">
                        {persondata.CurrentCTC && < div className="col-md-6 col-lg-3 mb-3">
                          <label htmlFor="Name" className="form-label">Last CTC </label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="LastCTC" name="LastCTC"
                            value={persondata.CurrentCTC} />
                        </div>}
                        <div className="col-md-6 col-lg-3 mb-3">
                          <label htmlFor="lastName" className="form-label">Expected CTC</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="ExpectedCTC" name="ExpectedCTC" value={persondata.ExpectedSalary} />
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
                        <div className="mb-3  col-md-6 col-lg-6">
                          <label htmlFor="ageGroup" className="form-label">Able to carry the laptop:</label>
                          <select className="form-select " id="ageGroup" value={carrylaptop} onChange={(e) => setcarrylaptop(e.target.value)}>
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


                        {/*  */}



                      </div>
                    </div>
                  </div>}

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
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="InterviewerName" name="InterviewerName" value={username} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Signature" className="form-label">Signature</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Signature" name="Signature" value={signature} onChange={(e) => setSignature(e.target.value)} />
                        </div>
                        <div className="col-md-6 col-lg-4 mb-3">
                          <label htmlFor="Date" className="form-label">Interview Date</label>
                          <input type="text" className="p-2 border-1 rounded border-slate-400 w-full block outline-none shadow-none" id="Date"
                            name="Date" value={getCurrentDate()} onChange={(e) => setDate1(e.target.value)} />
                        </div>
                        <div className="mb-3 col-md-6 col-lg-4">
                          <label htmlFor="ageGroup" className="form-label">Interview Status:</label>
                          <select className="form-select" id="ageGroup" value={Interviewstatus} onChange={(e) => setInterviewStatus(e.target.value)}>
                            <option value="">Select</option>
                            <option value="consider_to_client">Consider to Client for Merida </option>
                            <option value="Internal_Hiring">Internal Hiring</option>
                            <option value="Reject">Rejects</option>
                            <option value="On_Hold">On Hold</option>
                            <option value="Offer_did_not_accept">Offerd Did't Accept</option>
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
                    data-bs-dismiss="modal"
                    onClick={handleproceedingform} >Submit</button>
                </div>
              </div>
            </div>
          </div>
        </div>
        {/* INTERVIEW FORM End */}


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


    </div>







  )
}

export default Employee_interview_applicants