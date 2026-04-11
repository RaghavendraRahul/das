import axios from 'axios';
import React, { useState } from 'react'
import { Link } from 'react-router-dom';
import {port} from '../App' 



const Intassform = () => {
    const [states, setStates] = useState([]);
    const [districts, setDistricts] = useState([]);
    const [selectedState, setSelectedState] = useState('');

    // ALL Form Input Details

    const [firstname, setFirstname] = useState("");
    const [LastName, setLastName] = useState('');
    const [Email, setEmail] = useState('');
    const [PrimaryContact, setPrimaryContact] = useState('');
    const [SecondaryContact, setSecondaryContact] = useState('');
    const [State, setState] = useState('');
    const [District, setDistrict] = useState('');
    const [highestQualification, setHighestQualification] = useState('');
    const [university, setUniversity] = useState('');
    const [specialization, setSpecialization] = useState('');
    const [percentage, setPercentage] = useState('');
    const [selectedYear, setSelectedYear] = useState('');
    const [currentDesignation, setCurrentDesignation] = useState('');
    const [noOfExperience, setNoOfExperience] = useState('');
    const [noticePeriod, setNoticePeriod] = useState('');
    const [generalSkillsWithExp, setGeneralSkillsWithExp] = useState('');
    const [softSkillsWithExp, setSoftSkillsWithExp] = useState('');
    const [technicalSkillsWithExp, setTechnicalSkillsWithExp] = useState('');
    const [currentCTC, setCurrentCTC] = useState('');
    const [technicalSkills, settTechnicalSkills] = useState("");
    const [generalSkills, setGeneralSkills] = useState("");
    const [softSkills, setsoftSkills] = useState("");
    const [expectedSalary, setexpectedSalary] = useState("");
    const [Contacted_by, setContactedBy] = useState("");
    const [JobPortal, setJobportal] = useState("");
    const [gender, setGender] = useState("");
    const [selectedOption, setSelectedOption] = useState("fresher");



    let handleSubmit = (e) => {
        e.preventDefault();

        const formdata = new FormData()
        formdata.append('FirstName', firstname);
        formdata.append('LastName', LastName);
        formdata.append('Email', Email);
        formdata.append('PrimaryContact', PrimaryContact);
        formdata.append('SecondaryContact', SecondaryContact);
        formdata.append('State', State);
        formdata.append('District', District);
        formdata.append('HighestQualification', highestQualification);
        formdata.append('University', university);
        formdata.append('Specialization', specialization);
        formdata.append('Percentage', percentage);
        formdata.append('CurrentDesignation', currentDesignation);
        formdata.append('TotalExperience', noOfExperience);
        formdata.append('NoticePeriod', noticePeriod);
        formdata.append('GeneralSkills_With_Exp', generalSkillsWithExp);
        formdata.append('SoftSkills_With_Exp', softSkillsWithExp);
        formdata.append('TechnicalSkills_With_Exp', technicalSkillsWithExp);
        formdata.append('TechnicalSkills', technicalSkills);
        formdata.append('GeneralSkills', generalSkills);
        formdata.append('SoftSkills', softSkills);
        formdata.append('CurrentCTC', currentCTC);
        formdata.append('ExpectedSalary', expectedSalary);
        formdata.append('ContactedBy', Contacted_by);
        formdata.append('JobPortalSource', JobPortal);
        formdata.append('YearOfPassout', selectedYear);
        formdata.append('Gender', gender);
        formdata.append('Position', selectedOption);

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/applicationform/${'python'}/`, formdata)
            .then((r) => {
                console.log("Successfull", r.data)

            })
            .catch((err) => {
                console.log("Error", err)
            })
    }




   

    const handleStateChange = (event) => {
        setSelectedState(event.target.value);
        axios.get(`${port}/root/Districts/${event.target.value}`)
            .then((r) => {
                console.log(r.data)
                setDistricts(r.data)
            })
            .catch(error => {
                console.error('Error fetching districts data:', error);
            });
    };

    // Function to generate years from startYear to endYear
    const generateYears = (startYear, endYear) => {
        const years = [];
        for (let year = startYear; year <= endYear; year++) {
            years.push(year);
        }
        return years;
    };


    const handleYearChange = (e) => {
        setSelectedYear(e.target.value);
    };
  return (
    <div>
            <div className='animate_animated animate_slideInUp bg-light'>
                <div className='container-fluid row m-0 pb-4 pt-3'>
                    <div className='mb-2 d-flex'>
                        <Link className='text-dark' to='/Rec'><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                        </svg></Link>
                        <h3 className='text-primary mx-auto'>INTERVIEW ASSESSMENT FORM</h3>
                    </div>
                    <div className="col-12 bg-white py-3 shadow">
                        <form onSubmit={handleSubmit}>
                          

                            <div className="col-12 text-end mt-3">
                                <button type="submit" className="btn btn-primary text-white fw-medium px-2 px-lg-5">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
  )
}

export default Intassform