
import React from 'react'
import Topnav from './Topnav'
import '../assets/css/fonts.css';
import '../assets/css/media.css'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Sidebar from './Sidebar';
import '../assets/css/modal.css'
import Recsidebar from './Recsidebar';


const Recteam = () => {
    
  const [tab, setTab] = useState("newleads")

  let [applylist, setApplylist] = useState([])

  const [persondata, setPersondata] = useState({})

  const [interviewers, setInterviewers] = useState([]);

  const [selectedCandidates, setSelectedCandidates] = useState([]);

  const [recname, setrecname] = useState([]);

  const [load, setLoad] = useState(6)
  const loadmore = 6

  const loadmorefunc = () => {
    setLoad(x => x + loadmore)
  }

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


    axios.post('http://192.168.0.137:9000/root/ScreeningAssigning/', { Candidates: selectedCandidates, Recruiterid: id })
      .then(response => {
        console.log('API response:', response.data);

      })
      .catch(error => {
        console.error('Error sending data to API:', error);

      });
  };

  // APPLY REC NAME START

  useEffect(() => {

    axios.get('http://192.168.0.137:9000/root/ScreeningAssigning/').then((e) => {

      console.log("rec names ", e.data);
      setrecname(e.data)
    })


  }, [])

  // APPLY REC NAME END


  useEffect(() => {

    axios.get('http://192.168.0.137:9000/root/interviewschedule').then((e) => {

      console.log(e.data);
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
    InterviewType: ''
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };
  const handleTimeInputChange = (e) => {
    setFormData({ ...formData, InterviewTime: e.target.value })
  }

  const handleSubmit = async (e) => {
    formData.Candidate = Candidateid
    e.preventDefault();
    try {
      // Make POST request to your API endpoint
      const response = await axios.post('http://192.168.0.137:9000/root/interviewschedule', formData);
      console.log('Response:', response.data);

      // Optionally, you can handle success and display a message to the user
    } catch (error) {
      console.error('Error:', error);
      // Handle error, maybe display an error message to the user
      console.log(formData);
    }
  };





  useEffect(() => {
    axios.get('http://192.168.0.137:9000/root/appliedcandidateslist').then((res) => {
      console.log(res.data);
      setApplylist(res.data)
    })
  }, [])

  const [Candidateid, setCandidate] = useState("")
  // Define the function sentparticularData
  const sentparticularData = (id) => {
    setCandidate(id)
    // Define the data to be sent in the request
    const dataToSend = {
      id: id // Assuming id is the parameter passed to the function
    };

    // Send a POST request using Axios
    axios.get(`http://192.168.0.137:9000/root/appliedcandidate/${id}/`, dataToSend)
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
      const response = await axios.post('http://192.168.0.137:9000/root/upload-excel/', excel_file, {
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

 
const  handleDownload = async () => {
    try {
      const response = await axios.get('http://192.168.0.137:9000/root/download-excel/', {
        responseType: 'blob' // Important to set the responseType to 'blob'
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      console.log(response.data);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', 'CanditateDatas.xlsx' );
      document.body.appendChild(link);
      link.click();
      link.parentNode.removeChild(link);
    } catch (error) {
      console.error('Error downloading file:', error);
    }
  };


 
  

  return (
    <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

      <div className='side'>

        {/* <Sidebar value={"dashboard"} ></Sidebar> */}
        <Recsidebar></Recsidebar>

      </div>
      <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
        <Topnav ></Topnav>



        <div class="tab-content p-1" id="myTabContent">
          <div class="tab-pane fade show active mt-4" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
            <div class="table-responsive mt-4">

              <div className='d-flex justify-content-between'>



                <div>
                  <div className='text-primary d-flex'>

                    <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Recruiter Team Members</h6>
                    {/* <h6 className='text-danger ms-2  p-1 rounded-circle' style={{ backgroundColor: 'rgb(240,179,74)' }}> {applylist != undefined && applylist != undefined && applylist.length} </h6> */}
                  </div>

                </div>




              </div>

              <div className='rounded'>

                <table class="table caption-top mt-4     table-hover">
                  <thead >
                    <tr >
                  
        
                     
                      <th scope="col"><span className='fw-medium'>Name</span></th>
                      <th scope="col"><span className='fw-medium'>Email</span></th>
                      <th scope="col"><span className='fw-medium'>Phone</span></th>
                      <th scope="col"><span className='fw-medium'>View</span></th>





                    </tr>
                  </thead>

                  {/* STATIC VALUE START */}

                  <tr>
                          
                          <td > Static Id</td>
                          <td >Static jerold</td>
                          <td > abc@gmail.com</td>
                          <td >3412341234</td>
                        </tr>


                  {/* {applylist != undefined && applylist != undefined && applylist.slice(0, load).map((e) => {
                    return (

                      <tbody>
                        <tr>
                          <th scope="row"><input type="checkbox" value={e.CandidateId} onChange={handleCheckboxChange} /></th>
                          <td key={e.id}> {e.CandidateId}</td>
                          <td key={e.id}>{e.FirstName}</td>
                          <td key={e.id}>{e.Email}</td>
                          <td key={e.id}>{e.PrimaryContact}</td>
                          <td key={e.id}>{e.AppliedDesignation}</td>
                          <td onClick={() => sentparticularData(e.CandidateId)} className='text-center'><button type="button" style={{ backgroundColor: 'rgb(160,217,180)' }} class="btn  btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal2">
                            open
                          </button>
                          </td>
                        </tr>
                      </tbody>

                    )
                  })} */}


                  {/* open Particular Data Start */}

                  <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="false">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel2">Name : {persondata.FirstName}</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">

                          <h1>Applicant Information</h1>
                          <ul>
                            <li><strong>Name:</strong> {persondata.FirstName} {persondata.LastName}</li>
                            <li><strong>Email:</strong> {persondata.Email}</li>
                            <li><strong>Gender:</strong> {persondata.Gender}</li>
                            <li><strong>Primary Contact:</strong> {persondata.PrimaryContact}</li>
                            <li><strong>Secondary Contact:</strong>{persondata.SecondaryContact}</li>
                            <li><strong>Location:</strong> {persondata.Location}</li>
                            <li className={`${persondata.Fresher ? '' : 'd-none'}`}><strong>Fresher:</strong>Yes</li>
                            <li className={`${persondata.Fresher ? 'd-none' : ''}`}><strong>Experience:</strong>Yes</li>
                            <li><strong>Highest Qualification:</strong> {persondata.HighestQualification}</li>
                            <li><strong>University:</strong> {persondata.University}</li>
                            <li><strong>Specialization:</strong> {persondata.Specialization}</li>
                            <li><strong>Percentage:</strong> {persondata.Percentage}</li>
                            <li><strong>Year of Passout:</strong> {persondata.YearOfPassout}</li>
                            <li><strong>Technical Skills:</strong> {persondata.TechnicalSkills}</li>
                            <li><strong>General Skills:</strong> {persondata.GeneralSkills}</li>
                            <li><strong>Soft Skills:</strong> {persondata.SoftSkills}</li>
                            <li><strong>Applied Designation:</strong> {persondata.AppliedDesignation}</li>
                            <li><strong>Expected Salary:</strong>{persondata.ExpectedSalary}</li>
                            <li><strong>Contacted By:</strong> {persondata.ContactedBy}</li>
                            <li><strong>Job Portal Source:</strong>{persondata.JobPortalSource}</li>
                            <li><strong>Applied Date:</strong> {persondata.AppliedDate}</li>
                          </ul>







                        </div>
                        <div class="modal-footer d-flex justify-content-between">
                          <button type="button" class="btn btn-secondary " data-bs-dismiss="modal">Close</button>

                          <div className='d-flex gap-2'>

                            <button type="button" class="btn btn-primary">Assign Task</button>

                            <button type="button" class="btn btn-success" data-bs-target="#exampleModalToggle5" data-bs-toggle="modal">Schudle Interview</button>



                            <button type="button" class="btn btn-info">Offer Letter</button>


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

                  <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal" style={{ backgroundColor: 'rgb(240,179,74)' }}>Bulk Data</button>

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
          </div>


          <div class="modal fade" id="exampleModalToggle5" aria-hidden="true" aria-labelledby="exampleModalToggleLabel5" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered ">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="exampleModalToggleLabel5">Interview Schedule</h1>
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
                            {interviewer.Name}
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



    </div>
  )
}

export default Recteam