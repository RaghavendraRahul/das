import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import App, { port } from '../App'
import '../assets/css/fonts.css'
import '../assets/css/Sweet_.css'
import { toast } from 'react-toastify';
import { HrmStore } from '../Context/HrmContext';
import { Modal } from 'react-bootstrap';



const Canditatereg = () => {
    let { getDesignations, designation, } = useContext(HrmStore)
    let location = useLocation();
    let queryParams = new URLSearchParams(location.search)
    let source = queryParams.get('source')
    let desig = queryParams.get('desig')
    let hrWebId=queryParams.get('jobpk')
    console.log(source, desig, 'name');



    let [loading, setloading] = useState()
    const [states, setStates] = useState([]);
    const [districts, setDistricts] = useState([]);
    const [selectedState, setSelectedState] = useState('');
    // ALL Form Input Details

    const [firstname, setFirstname] = useState("");
    const [LastName, setLastName] = useState('');
    const [Email, setEmail] = useState('');
    const [dateOfBrith, setDateOfBrith] = useState()
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
    const [Applyed_Designation, setApplyed_Designation] = useState("");
    let [altApplyedDesignation, setAltApplyedDesignation] = useState('')
    const [showAlert, setShowAlert] = useState(false);
    const [alertType, setAlertType] = useState('success');
    let [appliedFor, setAppliedFor] = useState('')
    let [otherJob, setOtherjob] = useState()
    let [refferalEmp, setReffaralEmp] = useState('')

    useEffect(() => {
        if (desig && designation) {
            if (designation.find((obj, index) => obj.Name == desig)) {
                setApplyed_Designation(desig)
            }
            else {

                setApplyed_Designation('other')
                setAltApplyedDesignation(desig)
            }
        }
    }, [desig, designation])
    useEffect(() => {
        if (source) {
            setOtherjob(source)
            setJobportal('others')

        }
    }, [source])


    let handleSubmit = (e) => {
        e.preventDefault();
        if (JobPortal == 'referral' && refferalEmp == '')
            return toast.warning('Fill the Referred by field')
        const formdata = new FormData()
        formdata.append('FirstName', firstname);
        formdata.append('LastName', LastName);
        formdata.append('Email', Email);
        formdata.append('PrimaryContact', PrimaryContact);
        formdata.append('SecondaryContact', SecondaryContact);
        formdata.append('State', State);
        formdata.append('DOB', dateOfBrith);
        formdata.append('District', District);
        formdata.append('HighestQualification', highestQualification);
        formdata.append('University', university);
        formdata.append('Specialization', specialization);
        formdata.append('Percentage', percentage);
        formdata.append('CurrentDesignation', currentDesignation);
        formdata.append('TotalExperience', noOfExperience);
        formdata.append('NoticePeriod', noticePeriod);
        formdata.append('GeneralSkills_with_Exp', generalSkillsWithExp);
        formdata.append('SoftSkills_with_Exp', softSkillsWithExp);
        formdata.append('TechnicalSkills_with_Exp', technicalSkillsWithExp);
        formdata.append('TechnicalSkills', technicalSkills);
        formdata.append('GeneralSkills', generalSkills);
        formdata.append('SoftSkills', softSkills);
        formdata.append('CurrentCTC', currentCTC);
        formdata.append('ExpectedSalary', expectedSalary);
        formdata.append('ContactedBy', Contacted_by);
        formdata.append('YearOfPassout', selectedYear);
        formdata.append('Gender', gender);
        formdata.append('Position', selectedOption);
        formdata.append('Appling_for', appliedFor);
        if(hrWebId){
            formdata.append('JPS_Id',hrWebId)
        }
        if (refferalEmp && JobPortal=='referral' )
            formdata.append('Referred_by', refferalEmp);
        if (otherJob && JobPortal == 'others')
            formdata.append('JobPortalSource', otherJob);
        else
            formdata.append('JobPortalSource', JobPortal);

        formdata.append('AppliedDesignation', Applyed_Designation == 'other' ? altApplyedDesignation : Applyed_Designation);

        for (let pair of formdata.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        setloading(true)
        if (firstname != '' && gender != '' && Email != '' && PrimaryContact != '' &&
            State != '' && District != '' && highestQualification != '' && selectedOption != ''
            && JobPortal != '' && Applyed_Designation != ''
        ) {

            axios.post(`${port}/root/applicationform/${Applyed_Designation}/`, formdata)
                .then((r) => {
                    console.log("applicationform_res", r.data)
                    // alert('Candidate Registration Form Successfull..')
                    setAlertType('success');
                    setShowAlert(true);
                    setloading(false)

                    // setFirstname("")
                    // setFirstname("")
                    setLastName('')
                    setEmail('')
                    setPrimaryContact('')
                    setSecondaryContact('')
                    setState('')
                    setDistrict('')
                    setHighestQualification('')
                    setUniversity('')
                    setSpecialization('')
                    setPercentage('')
                    setSelectedYear('')
                    setCurrentDesignation('')
                    setNoOfExperience('')
                    setNoticePeriod('')
                    setGeneralSkillsWithExp('')
                    setSoftSkillsWithExp('')
                    setTechnicalSkillsWithExp('')
                    setCurrentCTC('')
                    settTechnicalSkills("")
                    setGeneralSkills("")
                    setsoftSkills("")
                    setexpectedSalary("")
                    setContactedBy("")
                    setJobportal("")
                    setGender("")
                    setDateOfBrith('')
                    setSelectedOption('')
                    setApplyed_Designation('')
                })
                .catch((err) => {
                    setAlertType('error');
                    // setShowAlert(true);
                    toast.error('Error Acquired')
                    setloading(false)
                    console.log("applicationform_err", err)
                })
        }
        else {
            toast.warning('Fill all the required fields')
        }
    }

    const handleConfirm = () => {
        setShowAlert(false);
    };
    useEffect(() => {
        getDesignations()
    }, [])



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




    return (
        <div>
            <div className='animate_animated poppins animate_slideInUp inputbg'>
                <div className='container-fluid row m-0 pb-4 pt-3'>

                    <div className='mb-2 p-3 d-flex'>
                        <h3 className='text-primary Candidate_reg fw-semibold mx-auto'>CANDIDATE REGISTRATION FORM</h3>
                    </div>
                    <div className="col-12 py-3 ">
                        <form onSubmit={handleSubmit}>
                            {/* ---------------------------------PERSONAL DETAILS--------------------------------------------------------- */}
                            <div className="row m-0 bg-white rounded pb-2">
                                <h5 className='text-primary pb-3 mt-2'>Personal Details</h5>
                                <div className='row m-0 mt-2'>

                                    <div className="col-md-6 col-lg-3  mb-3">
                                        <label htmlFor="firstName" className="fw-medium my-1 text-slate-600 poppins ">First Name <span class='text-danger'>*</span> </label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id="FirstName" name="FirstName" value={firstname} onChange={(e) => setFirstname(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="lastName" className="fw-medium my-1 text-slate-600 poppins ">Last Name</label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id=" LastName" name=" LastName" value={LastName} onChange={(e) => setLastName(e.target.value)} />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="gender" className="fw-medium my-1 text-slate-600 poppins ">Gender <span class='text-danger'>*</span> </label>
                                        <select
                                            className="inputbg p-2 w-full outline-none rounded "
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
                                        <label htmlFor="email" className="fw-medium my-1 text-slate-600 poppins ">Email Id<span class='text-danger'>*</span> </label>
                                        <input type="email" className="inputbg p-2 w-full outline-none rounded " id=" Email" name=" Email" value={Email} onChange={(e) => setEmail(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="primaryContact" className="fw-medium my-1 text-slate-600 poppins ">Primary Mobile Number <span class='text-danger'>*</span> </label>
                                        <input type="number" className="inputbg p-2 w-full outline-none rounded " id="PrimaryContact" name="PrimaryContact" value={PrimaryContact}
                                            onChange={(e) => { if (e.target.value >= 0 && e.target.value.length <= 10) { setPrimaryContact(e.target.value) } }} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="fw-medium my-1 text-slate-600 poppins ">Secondary Contact  </label>
                                        <input type="number" className="inputbg p-2 w-full outline-none rounded " id="SecondaryContact" name="SecondaryContact"
                                            value={SecondaryContact} onChange={(e) => { if (e.target.value >= 0 && e.target.value.length <= 10) { setSecondaryContact(e.target.value) } }} />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="fw-medium my-1 text-slate-600 poppins ">State <span class='text-danger'>*</span> </label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id="State" name="State" value={State} onChange={(e) => setState(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="fw-medium my-1 text-slate-600 poppins ">District <span class='text-danger'>*</span> </label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id=" District" name=" District" value={District} onChange={(e) => setDistrict(e.target.value)} required />
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="secondaryContact" className="fw-medium my-1 text-slate-600 poppins ">Date of Birth <span class='text-danger'>*</span> </label>
                                        <input type="date" className="inputbg p-2 w-full outline-none rounded " id=" District" name=" District" value={dateOfBrith} onChange={(e) => setDateOfBrith(e.target.value)} required />
                                    </div>
                                </div>

                            </div>

                            {/* ----------------------------------EDUCATIONAL DETAILS----------------------------------------------------------- */}
                            <div className="row m-0 bg-white rounded my-3">
                                <div className="col-md-12 col-lg-12 mb-3 mt-2">


                                    <div className='d-flex my-3 '>

                                        <div className="nav-item items-center gap-2 d-flex">
                                            <input
                                                type="checkbox"
                                                id='fresher'
                                                checked={selectedOption == 'Fresher'}
                                                onChange={() => setSelectedOption('Fresher')}

                                            />
                                            {/* <label htmlFor="home-tab" className="nav-link">Fresher</label> */}
                                            <label htmlFor='fresher' className='text-xl fw-semibold text-blue-600'>Fresher <span class='text-danger'>*</span> </label>

                                        </div>
                                        <div className="nav-item items-center gap-2  ms-5 d-flex">
                                            <input
                                                type="checkbox"
                                                id='exp'
                                                checked={selectedOption == 'Experience'}
                                                onChange={() => setSelectedOption('Experience')}
                                            />
                                            <label htmlFor='exp' className='text-xl fw-semibold text-blue-600'>Experience <span class='text-danger'>*</span> </label>

                                            {/* <label htmlFor="profile-tab" className="nav-link">Experience</label> */}
                                        </div>
                                        <div className="nav-item items-center gap-2 ms-5 d-flex">
                                            <input
                                                id='student'
                                                type="checkbox"
                                                checked={selectedOption == 'Student'}
                                                onChange={() => setSelectedOption('Student')}
                                            />
                                            <label htmlFor='student' className='text-xl fw-semibold text-blue-600'>Student  <span class='text-danger'>*</span> </label>
                                        </div>
                                        <div className="nav-item items-center gap-2 ms-5 d-flex">
                                            <input
                                                id='consi'
                                                type="checkbox"
                                                checked={selectedOption == 'Consultant'}
                                                onChange={() => setSelectedOption('Consultant')}
                                            />
                                            <label htmlFor='consi' className='text-xl fw-semibold text-blue-600'>Consultent  <span class='text-danger'>*</span> </label>
                                        </div>
                                    </div>


                                    {(selectedOption == 'Fresher' || selectedOption == 'Student') && (
                                        <div className="mt-4 bg-white rounded p-3 row m-0">
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="highestQualification" className="fw-medium my-1 text-slate-600 poppins ">Highest Qualification <span class='text-danger'>*</span> </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="HighestQualification" name="HighestQualification" value={highestQualification} onChange={(e) => setHighestQualification(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="university" className="fw-medium my-1 text-slate-600 poppins ">University  </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="University" name="University" value={university} onChange={(e) => setUniversity(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mb-3">
                                                <label htmlFor="specialization" className="fw-medium my-1 text-slate-600 poppins ">Specialization </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="Specialization" name="Specialization" value={specialization} onChange={(e) => setSpecialization(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-4 mt-3 mb-3">
                                                <label htmlFor="percentage" className="fw-medium my-1 text-slate-600 poppins ">Percentage <span class='text-danger'>*</span> </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id=" Percentage" name=" Percentage" value={percentage} onChange={(e) => setPercentage(e.target.value)} />
                                            </div>

                                            <div className="col-md-6 col-lg-4 mt-3">
                                                <label htmlFor="yearOfPassOut" className="fw-medium my-1 text-slate-600 poppins ">Year of Pass Out <span class='text-danger'>*</span> </label>
                                                <select
                                                    className="inputbg p-2 w-full outline-none rounded "
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

                                            <h5 className='text-primary  mt-4'>Key Skills  </h5>

                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="generalSkills" className="fw-medium my-1 text-slate-600 poppins ">General Skills </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="generalSkills" name="generalSkills" value={generalSkills} onChange={(e) => setGeneralSkills(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="softSkills" className="fw-medium my-1 text-slate-600 poppins ">Soft Skills </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="softSkills" name="softSkills" value={softSkills} onChange={(e) => setsoftSkills(e.target.value)} required />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">Technical Skills </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="technicalSkills" name="technicalSkills" value={technicalSkills} onChange={(e) => settTechnicalSkills(e.target.value)} required />
                                            </div>
                                        </div>
                                    )}

                                    {(selectedOption == 'Experience' || selectedOption == 'Consultant') && (
                                        <div className="mt-4 bg-white rounded p-3 row m-0">
                                            {/* Experience Fields */}
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="highestQualification" className="fw-medium my-1 text-slate-600 poppins ">Highest Qualification<span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="HighestQualification" name="HighestQualification" value={highestQualification} onChange={(e) => setHighestQualification(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="university" className="fw-medium my-1 text-slate-600 poppins ">University <span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="University" name="University" value={university} onChange={(e) => setUniversity(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="specialization" className="fw-medium my-1 text-slate-600 poppins ">Specialization <span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="Specialization" name="Specialization" value={specialization} onChange={(e) => setSpecialization(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mb-3">
                                                <label htmlFor="percentage" className="fw-medium my-1 text-slate-600 poppins ">Percentage <span class='text-danger'>*</span> </label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id=" Percentage" name=" Percentage" value={percentage} onChange={(e) => setPercentage(e.target.value)} />
                                            </div>

                                            <div className="col-md-6 col-lg-3 mb-3 mt-3">
                                                <label htmlFor="yearOfPassOut" className="fw-medium my-1 text-slate-600 poppins ">Year of Pass Out <span class='text-danger'>*</span> </label>
                                                <select
                                                    className="inputbg p-2 w-full outline-none rounded "
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
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="generalSkills" className="fw-medium my-1 text-slate-600 poppins ">Current_Designation <span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="Current_Designation" name="Current_Designation" value={currentDesignation} onChange={(e) => setCurrentDesignation(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="softSkills" className="fw-medium my-1 text-slate-600 poppins ">Total  Experience <span class='text-danger'>*</span></label>
                                                <input type="number" className="inputbg p-2 w-full outline-none rounded " id="noOfExperience" name="noOfExperience" value={noOfExperience} onChange={(e) => setNoOfExperience(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-3">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">Notice_period <span class='text-danger'>*</span></label>
                                                <input type="number" className="inputbg p-2 w-full outline-none rounded " id="noticePeriod" name="noticePeriod" value={noticePeriod} onChange={(e) => setNoticePeriod(e.target.value)} />
                                            </div>

                                            <div className="col-md-6 col-lg-3 mt-5">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">General Skills with experience <span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="generalSkillsWithExp" name="generalSkillsWithExp" value={generalSkillsWithExp} onChange={(e) => setGeneralSkillsWithExp(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-5">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">Soft Skills with experience<span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="softSkillsWithExp" name="softSkillsWithExp" value={softSkillsWithExp} onChange={(e) => setSoftSkillsWithExp(e.target.value)} />
                                            </div>

                                            <div className="col-md-6 col-lg-3 mt-5">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">Technical Skills with experience<span class='text-danger'>*</span></label>
                                                <input type="text" className="inputbg p-2 w-full outline-none rounded " id="technicalSkillsWithExp" name="technicalSkillsWithExp" value={technicalSkillsWithExp} onChange={(e) => setTechnicalSkillsWithExp(e.target.value)} />
                                            </div>
                                            <div className="col-md-6 col-lg-3 mt-5">
                                                <label htmlFor="technicalSkills" className="fw-medium my-1 text-slate-600 poppins ">Current CTC per Annum  <span class='text-danger'>*</span></label>
                                                <input type="number" className="inputbg p-2 w-full outline-none rounded " id="currentCTC" name="currentCTC" value={currentCTC} onChange={(e) => setCurrentCTC(e.target.value)} />
                                            </div>


                                        </div>
                                    )}


                                </div>
                            </div>

                            {/* -----------------------------------OTHER DETAILS------------------------------------------------------------- */}
                            <div className="row m-0 rounded bg-white py-3">
                                {/* <h6 className='text-primary pb-3'>Other Details</h6> */}
                                <h5 className='text-primary  mt-4'>Other Details  </h5>

                                <div className="row m-0  py-3">

                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins "> Applying for<span class='text-danger'>*</span></label>
                                        <select name="" value={Applyed_Designation} onChange={(e) => {
                                            setApplyed_Designation(e.target.value)
                                        }} className='outline-none p-2 inputbg w-full rounded ' id="">
                                            <option value="">Select</option>
                                            {
                                                designation && designation.map((x) => (

                                                    <option value={x.Name}>{x.Name}</option>
                                                ))
                                            }

                                            <option value="other">Other</option>
                                        </select>
                                        {designation && console.log(designation.find((obj) => obj.Name == Applyed_Designation) == undefined, Applyed_Designation, "hellow")}
                                        {Applyed_Designation == 'other' &&
                                            <input type="text" placeholder='Other Designation type here... ' className="inputbg my-2 p-2 w-full outline-none rounded " id="expectedSalary" name="expectedSalary"
                                                value={altApplyedDesignation} onChange={(e) => setAltApplyedDesignation(e.target.value)} required />
                                        }
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins "> Willing to work <span class='text-danger'>*</span></label>
                                        <select name="" value={appliedFor} onChange={(e) => {
                                            setAppliedFor(e.target.value)
                                        }} className='outline-none p-2 inputbg w-full rounded ' id="">
                                            <option value="">Select</option>
                                            <option value="Intern">Intern</option>
                                            <option value="Employeement">Employeement</option>
                                        </select>
                                    </div>
                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins ">Expected CTC per annum </label>
                                        <input type="number" className="inputbg p-2 w-full outline-none rounded " id="expectedSalary" name="expectedSalary" value={expectedSalary} onChange={(e) => { if (e.target.value >= 0) { setexpectedSalary(e.target.value) } }} required />
                                    </div>

                                    <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins ">Contacted By  </label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id="expectedSalary" name="expectedSalary" value={Contacted_by} onChange={(e) => setContactedBy(e.target.value)} required />
                                    </div>


                                    <div className="col-md-6 col-lg-3 mb-3 ">
                                        <label htmlFor="yearOfPassOut" className="fw-medium my-1 text-slate-600 poppins ">Job Portal Source  </label>
                                        <select
                                            className="inputbg p-2 w-full outline-none rounded "
                                            id="yearOfPassOut"
                                            name="yearOfPassOut"
                                            disabled={desig}
                                            value={JobPortal}
                                            onChange={(e) => setJobportal(e.target.value)}
                                        >
                                            <option value="">Select Job Portal Source</option>
                                            <option value="linkedin">Linked In</option>
                                            <option value="naukri">Naukri</option>
                                            <option value="foundit">Foundit</option>
                                            <option value="indeed">Indeed </option>
                                            <option value="direct">Direct </option>
                                            <option value="referral">Referral </option>

                                            <option value="others">Others</option>
                                        </select>
                                    </div>
                                    {JobPortal == 'referral' && <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins ">Referred By (Employee Id)  </label>
                                        <input type="text" className="inputbg p-2 w-full outline-none rounded " id="expectedSalary" name="expectedSalary"
                                            value={refferalEmp} onChange={(e) => setReffaralEmp(e.target.value)} required />
                                    </div>}
                                    {JobPortal == 'others' && <div className="col-md-6 col-lg-3 mb-3">
                                        <label htmlFor="expectedSalary" className="fw-medium my-1 text-slate-600 poppins ">Other Source <span class='text-danger'>*</span></label>
                                        <input type="text" disabled={desig} className="inputbg p-2 w-full outline-none rounded " id="expectedSalary"
                                            name="expectedSalary" value={otherJob} onChange={(e) => setOtherjob(e.target.value)} required />
                                    </div>}

                                </div>
                            </div>

                            <div className="col-12 text-end mt-3">
                                <button type="submit" disabled={loading} className="btn btn-primary text-white fw-medium px-2 px-lg-5">
                                    {loading ? "Loading..." : "Submit "}</button>
                            </div>
                        </form>

                        <Modal centered show={showAlert} onHide={() => setShowAlert(false)} >
                            <Modal.Body>
                                <img className='w-20 my-4 mx-auto flex ' src={require('../assets/Images/successTick.png')} alt="Successfully" />
                                <h4 className='text-center mb-3'>Thank you for registering with us !</h4>
                                <div className="text-center">
                                    <h4>{firstname} {LastName}</h4>
                                    <small>Your journey with Merida Tech Minds begins now. We are excited to support you in reaching your career goals.</small>
                                </div>
                            </Modal.Body>
                        </Modal>

                    </div>
                </div>
            </div>
        </div>
    );
};

export default Canditatereg;
