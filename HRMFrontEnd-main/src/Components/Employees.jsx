import React, { useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Chart as ChartJS } from "chart.js/auto";
import '../assets/css/fonts.css'
import Slider from "react-slick";
import '../assets/css/media.css'
import axios from 'axios';
import { port } from '../App'



const Employees = ({ port }) => {
  const [Employee_Id, setEmployee_Id] = useState("");
  const [Name, setName] = useState("");
  const [phone, setphone] = useState("");
  const [email, setemail] = useState("");
  const [Reporting_manager, setReporting_manager] = useState("");
  const [Employee_type, setEmployee_type] = useState("");
  const [LeaveType, setLeaveType] = useState("");
  const [FromDate, setFromDate] = useState("");
  const [ToDate, setToDate] = useState("");
  const [Days, setDays] = useState("");
  const [Reason, setReason] = useState("");
  const [Any_proof, setAny_proof] = useState("");






  const handle_Leave_apply_form = (e) => {
    e.preventDefault();



    const formData1 = new FormData();
    formData1.append('Employee_Id', Employee_Id);
    formData1.append('Name', Name);
    formData1.append('phone', phone);
    formData1.append('email', email);
    formData1.append('Reporting_manager', Reporting_manager);
    formData1.append('Employee_type', Employee_type);
    formData1.append('LeaveType', LeaveType);
    formData1.append('FromDate', FromDate);
    formData1.append('ToDate', ToDate);
    formData1.append('Reason', Reason);
    formData1.append('Any_proof', Any_proof);

    for (let pair of formData1.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }
  };

  const [Department, setDepartment] = useState("");
  const [Departments, setDepartments] = useState([]);
  const [Designation, setDesignation] = useState([]);
  const [_Designation, set_Designation] = useState("");

  const [Employeelist, setEmployeelist] = useState([]);

  const [selectedCandidates, setSelectedCandidates] = useState([]);
  const [Subject, setSubject] = useState("");
  const [Type, setType] = useState("");
  const [Date, setDate] = useState("");
  const [Message, setMessage] = useState("");
  const [search, setsearch] = useState("");

  console.log("sas", Employeelist);


  const getAllemp = () => {
    axios.get(`${port}/root/ems/MassMails`).then((res) => {
      console.log("Departments_res", res.data);
      setDepartments(res.data.Departments)
      setEmployeelist(res.data.EmployeeMails)
    }).catch((err) => {
      console.log("Departments_err", err.data);

    })
  }



  useEffect(() => {

    getAllemp()

  }, [])




  const handleDepartmentChange = (e) => {

    const selectedDepartment = e.target.value;
    setDepartment(selectedDepartment);


    if (e.target.value != '')
      axios.get(`${port}/root/ems/Department_Mail/${e.target.value}/`).then((res) => {
        console.log("Department_Employee_res :", e.target.value, res.data);
        setDesignation(res.data.Designations)
        setEmployeelist(res.data.EmployeeMails)
      }).catch((err) => {
        console.log("Department_err", err.data);

      })
    else
      getAllemp()


  };

  const handleDesignationChange = (e) => {

    const selectedDesignation = e.target.value;
    set_Designation(selectedDesignation);

    axios.get(`${port}/root/ems/Designation_Mail/${e.target.value}/`).then((res) => {
      console.log("Designation_Employee_res :", e.target.value, res.data);
      setEmployeelist(res.data.EmployeeMails)
    }).catch((err) => {
      console.log("Department_err", err.data);

    })

  };


  const handleCheckboxChange = (e) => {
    const candidateId = e.target.value;
    if (e.target.checked) {
      setSelectedCandidates([...selectedCandidates, candidateId]);
    } else {
      setSelectedCandidates(selectedCandidates.filter(id => id !== candidateId));
    }
  };


  const sendSelectedDataToApi = (e) => {
    e.preventDefault()



    const formData2 = new FormData();
    formData2.append('Department', Department);
    formData2.append('selectedCandidates', selectedCandidates);
    formData2.append('Subject', Subject);
    formData2.append('Date', Date);
    formData2.append('Message', Message);

    for (let pair of formData2.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }


    // axios.post(`${port}/root/ScreeningAssigning/`, { Candidates: selectedCandidates, Recruiterid: id, login_user: Empid })
    //     .then(response => {
    //         console.log('API response:', response.data);
    //         setcount(count + 1)
    //         setSuccessAlert(true);


    //     })
    //     .catch(error => {
    //         console.error('Error sending data to API:', error);

    //     });
  };

  const [employeeId, setEmployeeId] = useState('');

  const handleChange = (event) => {
    setEmployeeId(event.target.value);
  };

  const sendDataToAPI = () => {

    console.log(employeeId);

    axios.get(`${port}/root/ems/EmployeeId/Mail/${employeeId}/`).then((res) => {
      console.log("Search_Employee_res :", employeeId, res.data);
      setEmployeelist(res.data.EmployeeMails)
    }).catch((err) => {
      console.log("Department_err", err.data);

    })

  };


  return (
    <div className=' d-flex'>

      {!port && <div className='side'>

        <Sidebar value={"dashboard"} ></Sidebar>
      </div>}
      <div className=' m-0 m-sm-4  side-blog' style={{ borderRadius: '10px' }}>
        {!port && <Topnav></Topnav>}

        <div className="row m-0 pb-2 mt-3" style={{ lineHeight: '30px' }}>

          <div className=' ad-flex justify-content-end '>

            <div class="col-md-6 col-lg-4 mb-3">
              <label htmlFor="ageGroup" className="form-label" style={{ color: 'rgb(76,53,117)' }}>Search* </label>
              <div class="input-group ">
                <input type="text" value={employeeId} onChange={handleChange} class="form-control shadow-none" aria-label="Recipient's username" placeholder='Type Employee ID' aria-describedby="button-addon2" />
                <button class="btn btn-outline-secondary" onClick={sendDataToAPI} type="button" id="button-addon2">Button</button>
              </div>
            </div>

          </div>

          <div className="col-md-6 col-lg-12 mb-3">
            <div className='rounded border table-responsive  m-1'>
              <table class="table caption-top   table-hover">
                <thead >
                  <tr >
                    {/* <th scope="col"></th> */}
                    <th scope="col"><span className='fw-medium'></span>All</th>
                    <th scope="col" className='fw-medium'>Name</th>
                    <th scope="col" className='fw-medium'>Email</th>
                    <th scope="col" className='fw-medium'>Employee ID</th>
                    <th scope="col" className='fw-medium'>Phone</th>
                    <th scope="col" className='fw-medium'>Join Date</th>
                    <th scope="col" className='fw-medium'>Role</th>






                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td><input type="checkbox" /></td>
                    <td>Mathavn</td>
                    <td>mbalajimtech@gmail.com</td>
                    <td>MTM234</td>
                    <td>6391937348</td>
                    <td>1-9-2023</td>
                    <td>Ui Developer</td>

                  </tr>
                  <tr>
                    <td><input type="checkbox" /></td>
                    <td>Mathavn</td>
                    <td>mbalajimtech@gmail.com</td>
                    <td>MTM234</td>
                    <td>6391937348</td>
                    <td>1-9-2023</td>
                    <td>Ui Developer</td>

                  </tr>
                  <tr>
                    <td><input type="checkbox" /></td>
                    <td>Mathavn</td>
                    <td>mbalajimtech@gmail.com</td>
                    <td>MTM234</td>
                    <td>6391937348</td>
                    <td>1-9-2023</td>
                    <td>Ui Developer</td>

                  </tr>
                  <tr>
                    <td><input type="checkbox" /></td>
                    <td>Mathavn</td>
                    <td>mbalajimtech@gmail.com</td>
                    <td>MTM234</td>
                    <td>6391937348</td>
                    <td>1-9-2023</td>
                    <td>Ui Developer</td>

                  </tr>


                </tbody>






                {/* {Employeelist != undefined && Employeelist.map((e) => {
                  return (

                    <tbody>
                      <tr>
                        <th scope="row"><input type="checkbox" value={e} onChange={handleCheckboxChange} /></th>

                        <td >{e}</td>


                      </tr>
                    </tbody>

                  )
                })} */}




              </table>
            </div>
            <div className='d-flex justify-content-between p-2'>
              <button className='btn btn-sm btn-success'>Load More</button>
              <div>


                <button className=' btn btn-sm' data-bs-toggle="modal" data-bs-target="#exampleModal9" style={{ backgroundColor: 'rgb(240,179,74)' }}>Download</button>



              </div>

            </div>
          </div>

        </div>



      </div>



    </div>
  )
}

export default Employees