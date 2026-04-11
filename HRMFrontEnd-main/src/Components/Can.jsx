import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { port } from '../App'
import '../assets/css/fonts.css'

const Can = () => {
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
    const [selectedOption, setSelectedOption] = useState("");




    let handleSubmit = (e) => {
        e.preventDefault();

        console.log( "General_Skills_with_Experience",General_Skills_with_Experience);
        console.log( "Soft_Skills_with_Experience",Soft_Skills_with_Experience);
        console.log( "Technical_Skills_with_Experience",Technical_Skills_with_Experience);

        console.log( "General_Skills",General_Skills);
        console.log( "Soft_Skills",Soft_Skills);
        console.log( "Technical_Skills",Technical_Skills);

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
        formdata.append('GeneralSkills_With_Exp', General_Skills_with_Experience);
        formdata.append('SoftSkills_With_Exp', Soft_Skills_with_Experience);
        formdata.append('TechnicalSkills_With_Exp', Technical_Skills_with_Experience);
        formdata.append('TechnicalSkills',Technical_Skills );
        formdata.append('GeneralSkills', General_Skills);
        formdata.append('SoftSkills',Soft_Skills );
        formdata.append('CurrentCTC', currentCTC);
        formdata.append('ExpectedSalary', expectedSalary);
        formdata.append('ContactedBy', Contacted_by);
        formdata.append('JobPortalSource', JobPortal);
        formdata.append('YearOfPassout', selectedYear);
        formdata.append('Gender', gender);
        formdata.append('Position', selectedOption);

        ;

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }

        axios.post(`${port}/root/applicationform/${'python'}/`,formdata)
            // ,GeneralSkills :General_Skills,
            // SoftSkills:Soft_Skills,
            // TechnicalSkills:Technical_Skills,
            // GeneralSkills_With_Exp:General_Skills_with_Experience,
            // SoftSkills_With_Exp:Soft_Skills_with_Experience,
            // TechnicalSkills_With_Exp:Technical_Skills_with_Experience
         
            .then((r) => {
                console.log("Canditate reg form Successfull", r.data)
                alert('Canditate reg form Successfull')

                // setFirstname("")
                // setFirstname("")
                // setLastName('')
                // setEmail('')
                // setPrimaryContact('')
                // setSecondaryContact('')
                // setState('')
                // setDistrict('')
                // setHighestQualification('')
                // setUniversity('')
                // setSpecialization('')
                // setPercentage('')
                // setSelectedYear('')
                // setCurrentDesignation('')
                // setNoOfExperience('')
                // setNoticePeriod('')
                // setGeneralSkillsWithExp('')
                // setSoftSkillsWithExp('')
                // setTechnicalSkillsWithExp('')
                // setCurrentCTC('')
                // settTechnicalSkills("")
                // setGeneralSkills("")
                // setsoftSkills("")
                // setexpectedSalary("")
                // setContactedBy("")
                // setJobportal("")
                // setGender("")
                // setSelectedOption("")

            })
            .catch((err) => {
                console.log("Canditate reg form Error", err)
            })
    }



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


    const [is, setIs] = useState(false);


    const [isFresher, setIsFresher] = useState(false);
    const [isExperience, setIsExperience] = useState(false);

    const handleFresherChange = (type) => {
        // alert(type);
        setSelectedOption(type)

        if (type === 'Fresher') {
            setIsFresher(true);
            setIsExperience(false);
        } else if (type === 'Experience') {
            setIsFresher(false);
            setIsExperience(true);
        }
    };

    // Genarl Skill with_Experience


    const [General_Skills_with_Experience, setQualifications] = useState([

        { General_skills: '', Gen_Experience: '' }
    ]);

    const handleAddRow = (e) => {
        e.preventDefault();

        setQualifications([...General_Skills_with_Experience, { General_skills: '', Gen_Experience: '' }]);
    };

    const handleInputChange = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...General_Skills_with_Experience];
        updatedQualifications[index][name] = value;
        setQualifications(updatedQualifications);
    };

    // soft Skill with_Experience

    const [Soft_Skills_with_Experience, setQualifications1] = useState([

        { Soft_Skills: '', Soft_Experience: '' }
    ]);

    const handleAddRow1 = (e) => {
        e.preventDefault();

        setQualifications1([...Soft_Skills_with_Experience, { Soft_Skills: '', Soft_Experience: '' }]);
    };

    const handleInputChange1 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Soft_Skills_with_Experience];
        updatedQualifications[index][name] = value;
        setQualifications1(updatedQualifications);
    };

    // technical Skill with_Experience 

    const [Technical_Skills_with_Experience, setQualifications2] = useState([

        { Technical_Skills: '', Technical_Experience: '' }
    ]);

    const handleAddRow2 = (e) => {
        e.preventDefault();

        setQualifications2([...Technical_Skills_with_Experience, { Technical_Skills: '', Technical_Experience: '' }]);
    };

    const handleInputChange2 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Technical_Skills_with_Experience];
        updatedQualifications[index][name] = value;
        setQualifications2(updatedQualifications);
    };


    //////////////////////////////////////////////////////////

    // Genarl Skill with_Experience


    const [General_Skills, setQualifications3] = useState([

        { General_skill: '' }
    ]);

    const handleAddRow3 = (e) => {
        e.preventDefault();

        setQualifications3([...General_Skills, { General_skill: '' }]);
    };

    const handleInputChange3 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...General_Skills];
        updatedQualifications[index][name] = value;
        setQualifications3(updatedQualifications);
    };

    // soft Skill with_Experience

    const [Soft_Skills, setQualifications4] = useState([

        { Soft_Skill: '' }
    ]);

    const handleAddRow4 = (e) => {
        e.preventDefault();

        setQualifications4([...Soft_Skills, { Soft_Skill: ''}]);
    };

    const handleInputChange4 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Soft_Skills];
        updatedQualifications[index][name] = value;
        setQualifications4(updatedQualifications);
    };

    // technical Skill with_Experience 

    const [Technical_Skills, setQualifications5] = useState([

        { Technical_Skill: '' }
    ]);

    const handleAddRow5 = (e) => {
        e.preventDefault();

        setQualifications5([...Technical_Skills, { Technical_Skill: '' }]);
    };

    const handleInputChange5 = (index, event) => {
        const { name, value } = event.target;
        const updatedQualifications = [...Technical_Skills];
        updatedQualifications[index][name] = value;
        setQualifications5(updatedQualifications);
    };


    return (
        <div>
            <div className='animate_animated animate_slideInUp bg-light'>
                <div className='container-fluid row m-0 pb-4 pt-3'>

                    <div className='mb-2 p-3 d-flex'>
                        <h3 className='text-primary Candidate_reg mx-auto'>CANDIDATE REGISTRATION FORM</h3>
                    </div>
                    <div className="col-12 bg-white py-3 shadow">
                        <form onSubmit={handleSubmit}>
                            {/* ---------------------------------PERSONAL DETAILS--------------------------------------------------------- */}
                            <div className="row m-0  pb-2">
                                <h5 className='text-primary pb-3 mt-2'>Personal Details</h5>
                                <div className='row m-0 mt-2'>

                                    <div className="col-md-6 col-lg-3  mb-3">
                                        <label htmlFor="firstName" className="form-label">First Name <span class='text-danger'>*</span> </label>
                                        <input type="text" className="form-control shadow-none bg-light" id="FirstName" name="FirstName" value={firstname} onChange={(e) => setFirstname(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="lastName" className="form-label">Last Name <span class='text-danger'>*</span> </label>
                                        <input type="text" className="form-control shadow-none bg-light" id=" LastName" name=" LastName" value={LastName} onChange={(e) => setLastName(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="gender" className="form-label">Gender <span class='text-danger'>*</span> </label>
                                        <select
                                            className="form-control shadow-none bg-light"
                                            id="gender"
                                            name="gender"
                                            value={gender} // Set the value of the select input to gender
                                            onChange={(e) => setGender(e.target.value)} // Update gender state when the select input changes
                                            required>
                                            <option value="">Select Gender <span class='text-danger'>*</span> </option> {/* Empty value for the default option */}
                                            <option value="male">Male</option>
                                            <option value="female">Female</option>
                                            <option value="others">Others</option>
                                        </select>
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="email" className="form-label">Email <span class='text-danger'>*</span> </label>
                                        <input type="email" className="form-control shadow-none bg-light" id=" Email" name=" Email" value={Email} onChange={(e) => setEmail(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="primaryContact" className="form-label">Primary Contact <span class='text-danger'>*</span> </label>
                                        <input type="tel" className="form-control shadow-none bg-light" id="PrimaryContact" name="PrimaryContact" value={PrimaryContact} onChange={(e) => setPrimaryContact(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">Secondary Contact  </label>
                                        <input type="tel" className="form-control shadow-none bg-light" id="SecondaryContact" name="SecondaryContact" value={SecondaryContact} onChange={(e) => setSecondaryContact(e.target.value)} />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">State <span class='text-danger'>*</span> </label>
                                        <input type="text" className="form-control shadow-none bg-light" id="State" name="State" value={State} onChange={(e) => setState(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="form-label">District <span class='text-danger'>*</span> </label>
                                        <input type="text" className="form-control shadow-none bg-light" id=" District" name=" District" value={District} onChange={(e) => setDistrict(e.target.value)} required />
                                    </div>
                                </div>

                            </div>

                            {/* ----------------------------------EDUCATIONAL DETAILS----------------------------------------------------------- */}
                            <div className="row m-0  py-3">
                                <div className="col-md-12 col-lg-12 mb-3 mt-2">


                                    <div className='d-flex'>

                                        <div className="nav-item d-flex">
                                            <input
                                                type="checkbox"
                                                checked={isFresher}
                                                onChange={() => handleFresherChange('Fresher')}

                                            />
                                            {/* <label htmlFor="home-tab" className="nav-link">Fresher</label> */}
                                            <h5 className='text-primary pb-3 ms-3 mt-4'>Fresher <span class='text-danger'>*</span> </h5>

                                        </div>
                                        <div className="nav-item ms-5 d-flex">
                                            <input
                                                type="checkbox"
                                                checked={isExperience}
                                                onChange={() => handleFresherChange('Experience')}
                                            />
                                            <h5 className='text-primary pb-3 ms-3 mt-4'>Experience <span class='text-danger'>*</span> </h5>

                                            {/* <label htmlFor="profile-tab" className="nav-link">Experience</label> */}
                                        </div>
                                    </div>


                                    {isFresher && (
                                        <div className="mt-4  row m-0">
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="highestQualification" className="form-label">Highest Qualification <span class='text-danger'>*</span> </label>
                                                <input type="text" className="form-control shadow-none bg-light" id="HighestQualification" name="HighestQualification" value={highestQualification} onChange={(e) => setHighestQualification(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="university" className="form-label">University <span class='text-danger'>*</span> </label>
                                                <input type="text" className="form-control shadow-none bg-light" id="University" name="University" value={university} onChange={(e) => setUniversity(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="specialization" className="form-label">Specialization <span class='text-danger'>*</span> </label>
                                                <input type="text" className="form-control shadow-none bg-light" id="Specialization" name="Specialization" value={specialization} onChange={(e) => setSpecialization(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mt-3 mb-3">
                                                <label htmlFor="percentage" className="form-label">Percentage <span class='text-danger'>*</span> </label>
                                                <input type="text" className="form-control shadow-none bg-light" id=" Percentage" name=" Percentage" value={percentage} onChange={(e) => setPercentage(e.target.value)} />
                                            </div>

                                            <div className="col-md-6 col-lg-4 mt-3">
                                                <label htmlFor="yearOfPassOut" className="form-label">Year of Pass Out <span class='text-danger'>*</span> </label>
                                                <select
                                                    className="form-control shadow-none bg-light"
                                                    id="yearOfPassOut"
                                                    name="yearOfPassOut"
                                                    value={selectedYear} // Set the value of the select input to selectedYear
                                                    onChange={(e) => setSelectedYear(e.target.value)} // Update selectedYear state when the select input changes
                                                >
                                                    <option value="">Select Year</option> {/* Empty value for the default option */}
                                                    {generateYears(1900, 2100).map((year) => (
                                                        <option key={year} value={year}>
                                                            {year}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>

                                            <h5 className='text-primary  mt-4 '>Key Skills  </h5>

                                            <div>
                                                {General_Skills.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-12 col-md-12 col-lg-12 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . General_skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="General_skill" value={qualification.General_skill} onChange={(e) => handleInputChange3(index, e)} className="form-control border-1 shadow-none  bg-light" />

                                                            </div>
                                                           

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>

                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow3} className='btn  btn-success mt-2 '>add</button>
                                            </div>


                                            <div>
                                                {Soft_Skills.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-12 col-md-12 col-lg-12 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . Soft Skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="Soft_Skill" value={qualification.Soft_Skill} onChange={(e) => handleInputChange4(index, e)} className="form-control border-1 shadow-none bg-light" />

                                                            </div>
                                                        

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>
                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow4} className='btn  btn-success mt-2 '>add</button>
                                            </div>

                                            <div>
                                                {Technical_Skills.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-12 col-md-12 col-lg-12 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . Technical Skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="Technical_Skill" value={qualification.Technical_Skill} onChange={(e) => handleInputChange5(index, e)} className="form-control border-1 shadow-none bg-light" />

                                                            </div>
                                                           

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>

                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow5} className='btn  btn-success mt-2 '>add</button>
                                            </div>



                                        </div>
                                    )}

                                    {isExperience && (
                                        <div className="mt-4 row m-0">
                                            {/* Experience Fields */}
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="highestQualification" className="form-label">Highest Qualification<span class='text-danger'>*</span></label>
                                                <input type="text" className="form-control shadow-none bg-light" id="HighestQualification" name="HighestQualification" value={highestQualification} onChange={(e) => setHighestQualification(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="university" className="form-label">University <span class='text-danger'>*</span></label>
                                                <input type="text" className="form-control shadow-none bg-light" id="University" name="University" value={university} onChange={(e) => setUniversity(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="specialization" className="form-label">Specialization <span class='text-danger'>*</span></label>
                                                <input type="text" className="form-control shadow-none bg-light" id="Specialization" name="Specialization" value={specialization} onChange={(e) => setSpecialization(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="percentage" className="form-label">Percentage <span class='text-danger'>*</span> </label>
                                                <input type="text" className="form-control shadow-none bg-light" id=" Percentage" name=" Percentage" value={percentage} onChange={(e) => setPercentage(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="yearOfPassOut" className="form-label">Year of Pass Out <span class='text-danger'>*</span></label>
                                                <select
                                                    className="form-control shadow-none bg-light"
                                                    id="yearOfPassOut"
                                                    name="yearOfPassOut"

                                                >
                                                    <option value={selectedYear} onChange={(e) => setSelectedYear(e.target.value)}>Select Year</option>
                                                    {generateYears(1900, 2100).map((year) => (
                                                        <option key={year} value={year}>
                                                            {year}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="generalSkills" className="form-label">Current_Designation <span class='text-danger'>*</span></label>
                                                <input type="text" className="form-control shadow-none bg-light" id="Current_Designation" name="Current_Designation" value={currentDesignation} onChange={(e) => setCurrentDesignation(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="softSkills" className="form-label">Total  Experience <span class='text-danger'>*</span></label>
                                                <input type="number" className="form-control shadow-none bg-light" id="noOfExperience" name="noOfExperience" value={noOfExperience} onChange={(e) => setNoOfExperience(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="technicalSkills" className="form-label">Notice_period <span class='text-danger'>*</span></label>
                                                <input type="number" className="form-control shadow-none bg-light" id="noticePeriod" name="noticePeriod" value={noticePeriod} onChange={(e) => setNoticePeriod(e.target.value)} />
                                            </div>

                                            {/*  */}



                                            <div className='mt-4'>
                                                {General_Skills_with_Experience.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-8 col-md-6 col-lg-8 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . General_skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="General_skills" value={qualification.General_skills} onChange={(e) => handleInputChange(index, e)} className="form-control border-1 shadow-none  bg-light" />

                                                            </div>
                                                            <div className='col-4 col-md-6 col-lg-4 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">Experience <span class='text-danger'>*</span> </label>

                                                                <input type="number" name="Gen_Experience" value={qualification.Gen_Experience} onChange={(e) => handleInputChange(index, e)} className="form-control border-1 shadow-none bg-light" />
                                                            </div>

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>

                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow} className='btn  btn-success mt-2 '>add</button>
                                            </div>


                                            <div>
                                                {Soft_Skills_with_Experience.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-8 col-md-6 col-lg-8 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . Soft Skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="Soft_Skills" value={qualification.Soft_Skills} onChange={(e) => handleInputChange1(index, e)} className="form-control border-1 shadow-none bg-light" />

                                                            </div>
                                                            <div className='col-4 col-md-6 col-lg-4 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">Experience <span class='text-danger'>*</span> </label>

                                                                <input type="number" name="Soft_Experience" value={qualification.Soft_Experience} onChange={(e) => handleInputChange1(index, e)} className="form-control border-1 shadow-none bg-light" />
                                                            </div>

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>
                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow1} className='btn  btn-success mt-2 '>add</button>
                                            </div>

                                            <div>
                                                {Technical_Skills_with_Experience.map((qualification, index) => (
                                                    <div key={index}>
                                                        <div className='row ' style={{ display: 'flex' }}>


                                                            <div className='col-8 col-md-6 col-lg-8 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">{index + 1} . Technical Skills <span class='text-danger'>*</span> </label>

                                                                <input type="text" name="Technical_Skills" value={qualification.Technical_Skills} onChange={(e) => handleInputChange2(index, e)} className="form-control border-1 shadow-none bg-light" />

                                                            </div>
                                                            <div className='col-4 col-md-6 col-lg-4 mt-3'>
                                                                <label htmlFor="percentage" className="form-label">Experience <span class='text-danger'>*</span> </label>

                                                                <input type="number" name="Technical_Experience" value={qualification.Technical_Experience} onChange={(e) => handleInputChange2(index, e)} className="form-control border-1 shadow-none bg-light" />
                                                            </div>

                                                        </div>

                                                    </div>
                                                ))}
                                            </div>

                                            <div className='col-md-12 col-lg-12   ' style={{ display: 'flex', justifyContent: 'end' }}>
                                                <button onClick={handleAddRow2} className='btn  btn-success mt-2 '>add</button>
                                            </div>



                                            {/*  */}
                                            <div className="col-md-6 col-lg-3 mt-2">
                                                <label htmlFor="technicalSkills" className="form-label">Current CTC <span class='text-danger'>*</span></label>
                                                <input type="number" className="form-control shadow-none bg-light" id="currentCTC" name="currentCTC" value={currentCTC} onChange={(e) => setCurrentCTC(e.target.value)} />
                                            </div>


                                        </div>
                                    )}


                                </div>
                            </div>

                            {/* -----------------------------------OTHER DETAILS------------------------------------------------------------- */}
                            <div className="row m-0  py-3">
                                {/* <h6 className='text-primary pb-3'>Other Details</h6> */}
                                <h5 className='text-primary  mt-2'>Other Details  </h5>

                                <div className="row m-0  py-3">
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="form-label">Expected Salary <span class='text-danger'>*</span></label>
                                        <input type="number" className="form-control shadow-none bg-light" id="expectedSalary" name="expectedSalary" value={expectedSalary} onChange={(e) => setexpectedSalary(e.target.value)} required />
                                    </div> <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="form-label">Contacted By <span class='text-danger'>*</span></label>
                                        <input type="text" className="form-control shadow-none bg-light" id="expectedSalary" name="expectedSalary" value={Contacted_by} onChange={(e) => setContactedBy(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="form-label">Job Portal Source <span class='text-danger'>*</span></label>
                                        <input type="text" className="form-control shadow-none bg-light" id="expectedSalary" name="expectedSalary" value={JobPortal} onChange={(e) => setJobportal(e.target.value)} required />
                                    </div>



                                </div>
                            </div>

                            <div className="col-12 text-end mt-3">
                                <button type="submit" className="btn btn-primary text-white fw-medium px-2 px-lg-5">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Can;
