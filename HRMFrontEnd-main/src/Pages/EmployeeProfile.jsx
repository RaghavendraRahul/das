import axios from 'axios'
import React, { useContext, useEffect, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { port } from '../App'
import Topnav from '../Components/Topnav'
import HrmContext, { HrmStore } from '../Context/HrmContext'
import EditPen from '../SVG/EditPen'
import ValueShowingCom from '../Components/ValueShowingCom'
import AutoTable from '../Components/Tables/AutoTable'
import EmployeeWeekOff from '../Components/Employee/EmployeeWeekOff'
import { Modal, Spinner } from 'react-bootstrap'
import CloseIcon from '../Components/Icons/CloseIcon'
import CloseIcon2 from '../SVG/CloseIcon2'
import ThreeDot from '../SVG/ThreeDot'
import QrCodeGenerator from './QRscanner/QrCodeGenerator'

const EmployeeProfile = ({ subpage }) => {
    let { id } = useParams()
    let [loading, setloading] = useState(true)
    let [showInfoButton, setInfoButton] = useState(false)
    let infoRef = useRef()
    let { setActivePage, changeDateYear } = useContext(HrmStore)
    let { formatDate } = useContext(HrmStore)
    let [employeeDetails, setEmployeeDetails] = useState()
    let getEmployee = () => {
        setloading(true)
        axios.get(`${port}/root/ems/EmployeeProfile/${id ? id : JSON.parse(sessionStorage.getItem('dasid'))}/`).then((response) => {
            console.log(response.data, 'emp');
            setEmployeeDetails(response.data);
            setloading(false)
        }).catch((error) => {
            console.log(error);
            setloading(false)
        })
    }
    useEffect(() => {
        getEmployee()
        setActivePage('Employee')
        window.scrollTo(0, 0)
    }, [id])
    useEffect(() => {
        let clickOutSide = (event) => {

            if (infoRef.current && !infoRef.current.contains(event.target)) {
                setInfoButton(false)
            }
        }
        window.addEventListener('mousedown', clickOutSide)
        return () => {
            window.addEventListener('mousedown', clickOutSide)
        }
    }, [])
    let navigate = useNavigate()
    return (
        <div style={{ backgroundColor: 'rgb(241,242,246)' }} className='p-0 poppins ' >
            <Modal className='' show={true} fullscreen >
                <Modal.Body className=' p-0 ' >

                    {loading ? <main className='min-h-[90vh] bg-white flex ' >
                        <Spinner className=' m-auto ' />
                    </main> :
                        <main style={{ backgroundColor: 'rgb(241,242,246)' }} className='row m-0 p-0 container-fluid poppins '>
                            {/* Top */}
                            {employeeDetails && employeeDetails.EmployeeInformation &&
                                < section className='flex justify-between gap-3 items-center p-2 px-3 bg-white  ' >
                                    {/* Profile data  */}
                                    <div className='flex flex-wrap gap-3 items-center ' >
                                        <div>

                                            <img src={employeeDetails.EmployeeInformation.EmployeeProfile
                                                ? employeeDetails.EmployeeInformation.EmployeeProfile : require('../assets/Images/profile_Image.webp')}
                                                alt="Profile Image" className='w-14 h-14 rounded object-cover ' />
                                        </div>
                                        <div>
                                            <h6 className='m-0 ' >{employeeDetails.EmployeeInformation.full_name} </h6>
                                            <p className='mb-0 pb-0 text-slate-600 ' >
                                                ({employeeDetails.EmployeeInformation.employee_Id})
                                            </p>
                                        </div>
                                        <QrCodeGenerator css='mx-0 ' />


                                    </div>
                                    <div className='flex gap-3 ' >
                                        <section className='w-fit relative  ' >
                                            <button onClick={() => setInfoButton(!showInfoButton)}
                                                className='rotate-90 p-2 mx-3' >
                                                <ThreeDot size={5} />
                                            </button>
                                            {showInfoButton &&
                                                <div id='infoProfile' ref={infoRef} className=' absolute p-2 bg-slate-100 shadow right-0 rounded w-40 bottom-0 text-sm translate-y-[100%] text-end ' >
                                                    <button onClick={() =>
                                                        navigate(`/Employeeallform/${employeeDetails.EmployeeInformation.employee_Id}`)}
                                                        className='my-2 ' > Info </button>
                                                    <button className=' my-2  ' onClick={() => navigate('/settings/password')} >
                                                        Change password
                                                    </button>
                                                </div>}
                                        </section>
                                        <button onClick={() => navigate('/employees')}
                                            className=' bg-slate-300 bg-opacity-80 text-slate-700 rounded p-2 ' >
                                            <CloseIcon2 />
                                        </button>
                                    </div>
                                </section>
                            }
                            {/* Basic information */}
                            {employeeDetails && employeeDetails.EmployeeInformation &&
                                <section className=' container-fluid p-3  mx-auto ' >
                                    <article className='bg-white row mx-auto shadow-sm w-full h-full rounded p-3 ' >
                                        <h5 className='my-3 ' >Basic Information </h5>

                                        <ValueShowingCom name="Employee ID" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.employee_Id} />
                                        <ValueShowingCom name="Phone Number" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.mobile} />
                                        <ValueShowingCom name="Name" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.full_name} />
                                        <ValueShowingCom name="Email ID" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.email} />
                                        <ValueShowingCom name="Address" css='col-lg-12' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.present_address + " ," +
                                                employeeDetails.EmployeeInformation.present_City + ", " +
                                                employeeDetails.EmployeeInformation.present_state + ", " +
                                                employeeDetails.EmployeeInformation.present_pincode + " "

                                            } />
                                    </article>

                                </section>}

                            {/* Work information */}
                            {employeeDetails && employeeDetails.EmployeeInformation &&
                                <section className=' container-fluid p-3 py-2 mx-auto ' >
                                    <article className='bg-white row mx-auto shadow-sm w-full h-full rounded p-3 ' >
                                        <h5 className='my-3 ' >Work Information </h5>

                                        <ValueShowingCom name="Department" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.Department} />
                                        <ValueShowingCom name="Employeement Type" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.Employeement_Type} />

                                        <ValueShowingCom name="Designation" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.Position} />
                                        <ValueShowingCom name="Employeement Status" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.Designation} />

                                        <ValueShowingCom name="Sourse of Hire" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.source_of_hire} />
                                        <ValueShowingCom name="Official Email ID" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.email} />
                                        <ValueShowingCom name="Secondary Email ID" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.secondary_email} />
                                        <ValueShowingCom name="Date of Joining" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.hired_date && changeDateYear(employeeDetails.EmployeeInformation.hired_date)} />
                                        <ValueShowingCom name="Reporting To" css='col-lg-6' hcss='w-[10rem] '
                                            value={employeeDetails.EmployeeInformation.Reporting_To} />
                                    </article>

                                </section>}

                            {/* EMployee WeekOff */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 ' >
                                <EmployeeWeekOff page='inner' id={id} />
                            </section>
                            {/* Employement History */}

                            {/* Bank Details */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Bank Details </h5>
                                    {
                                        employeeDetails && employeeDetails.BankAccountDetails && employeeDetails.BankAccountDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Account Holder Name " value={obj.Holder_Name} />
                                                <ValueShowingCom name="Account Number " value={obj.account_no} />
                                                <ValueShowingCom name="IFSC Number " value={obj.ifsc} />
                                                <ValueShowingCom name="Bank Name " value={obj.bank_name} />
                                                <ValueShowingCom name="Branch " value={obj.branch} />
                                                <ValueShowingCom name="Branch Address " value={obj.branch_address} />
                                                <ValueShowingCom name="Proof " proof={obj.account_proof} />

                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Document submitted Details */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Document Submitted Details </h5>
                                    {
                                        employeeDetails && employeeDetails.Attachments
                                        && employeeDetails.Attachments.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Degree Mark Sheet " proof={obj.Degree_mark_sheets} />
                                                <ValueShowingCom name="Offer letter " proof={obj.Offer_letter_copy} />
                                                <ValueShowingCom name="Address Proof" proof={obj.permanent_address_proof} />
                                                <ValueShowingCom name="Passport size Photo " proof={obj.upload_photo} />
                                                <ValueShowingCom name="Present address proof " proof={obj.present_address_proof} />

                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>

                            {/* Personal INformation */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Personal Information </h5>
                                    {
                                        employeeDetails && employeeDetails.PersonalInformation && employeeDetails.PersonalInformation.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Place of Birth " value={obj.place_of_birth} />
                                                <ValueShowingCom name="Residential " value={obj.residential_status} />

                                                <ValueShowingCom name="Physically challenged " value={obj.physically_challenged} />

                                                <ValueShowingCom name="Material Status " value={obj.marital_status} />
                                                <ValueShowingCom name="Spouse Name  " value={obj.spouse_name} />
                                                <ValueShowingCom name="Marriage Date" value={obj.marriage_date} />
                                                <ValueShowingCom name="Country of origin " value={obj.country_of_origin} />
                                                <ValueShowingCom name="Nationality " value={obj.nationality} />


                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Reference data */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Candidate Reference Detail </h5>
                                    {
                                        employeeDetails && employeeDetails.CandidateReferenceDetails && employeeDetails.CandidateReferenceDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Name " value={obj.person_name} />
                                                <ValueShowingCom name="Email " value={obj.email} />
                                                <ValueShowingCom name="Phone Number " value={obj.phone} />
                                                <ValueShowingCom name="Relationship " value={obj.relation} />
                                                {/* <ValueShowingCom name=" " value={obj.reason} /> */}
                                                {/* <ValueShowingCom name="Branch Address " value={obj.branch_address} /> */}
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Reference data */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Educational Details </h5>
                                    {
                                        employeeDetails && employeeDetails.EducationDetails && employeeDetails.EducationDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Qualification " value={obj.Qualification} />
                                                <ValueShowingCom name="Major Subject " value={obj.Major_Subject} />
                                                <ValueShowingCom name="Percentage " value={obj.Persentage} />
                                                <ValueShowingCom name="Institute/School " value={obj.University} />
                                                {/* <ValueShowingCom name=" " value={obj.reason} /> */}
                                                <ValueShowingCom name="YOP" value={obj.year_of_passout} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* emergency Contact data */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Emergency Contact Details </h5>
                                    {
                                        employeeDetails && employeeDetails.EmergencyContactDetails && employeeDetails.EmergencyContactDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Name " value={obj.person_name} />
                                                <ValueShowingCom name="Email " value={obj.email} />
                                                <ValueShowingCom name="Phone Number " value={obj.phone} />
                                                <ValueShowingCom name="Landline " value={obj.landline} />
                                                <ValueShowingCom name="Relation " value={obj.relation} />
                                                <ValueShowingCom name="Address " value={obj.address} />
                                                <ValueShowingCom name="City " value={obj.city} />
                                                <ValueShowingCom name="State " value={obj.state} />
                                                <ValueShowingCom name="Pincode " value={obj.pincode} />
                                                <ValueShowingCom name="Country " value={obj.country} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Medical data */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Medical Details </h5>
                                    {
                                        employeeDetails && employeeDetails.EmergencyDetails && employeeDetails.EmergencyDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Blood Group " value={obj.blood_group} />
                                                <ValueShowingCom name="Blood Pressure " value={obj.blood_pessure} />
                                                <ValueShowingCom name="Diabetics " value={obj.Diabetics} />
                                                <ValueShowingCom name="Allergic to " value={obj.allergic_to} />
                                                <ValueShowingCom name="Other Illness " value={obj.other_illness} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* EmployeeIdentity Identity Govrt */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Government Identity Details </h5>
                                    {
                                        employeeDetails && employeeDetails.EmployeeIdentity
                                        && employeeDetails.EmployeeIdentity.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="AadharCard Number" value={obj.aadhar_no} />
                                                <ValueShowingCom name="Addhar Proof " proof={obj.aadher_proof} />
                                                <ValueShowingCom name="Name in Aadhar " value={obj.name_as_per_aadhar} />
                                                <ValueShowingCom name="Pan Number " value={obj.pan_no} />
                                                <ValueShowingCom name="Pan Proof" proof={obj.pan_proof} />
                                                <ValueShowingCom name="Passport Number" value={obj.passport_num} />
                                                <ValueShowingCom name="Passport Exp Date" value={obj.validate} />
                                                <ValueShowingCom name="Passport Proof" proof={obj.passport_proof} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Last Position Held */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Last Position Held </h5>
                                    {
                                        employeeDetails && employeeDetails.LastPositionHeldDetails
                                        && employeeDetails.LastPositionHeldDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Organisation" value={obj.organisation} />
                                                <ValueShowingCom name="Designation " value={obj.designation} />
                                                <ValueShowingCom name="Gross Salary   " value={obj.gross_salary_per_month} />
                                                <ValueShowingCom name="Reporting Person Name" value={obj.repoting_to_name} />
                                                <ValueShowingCom name="Reporting Person Designation " value={obj.repoting_to_designation} />
                                                <ValueShowingCom name="Reporting Person Phone" value={obj.repoting_to_phone} />
                                                <ValueShowingCom name="Reporting Person Mail" value={obj.repoting_to_email} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                            {/* Experience details */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Experience Details </h5>
                                    {
                                        employeeDetails && employeeDetails.ExperienceDetails && <main className='table-responsive tablebg  ' >
                                            <table className='w-full p-0' >
                                                <tr className='sticky top-0 bgclr1 ' >
                                                    <th>SI NO </th>
                                                    <th> Organisation </th>
                                                    <th>Joined Date </th>
                                                    <th>Last Date </th>
                                                    <th>Last position held </th>
                                                    <th>Job Responsibility </th>
                                                    <th>Role at Joining </th>
                                                    <th>Gross Salary </th>
                                                    <th>Immediate Superior </th>
                                                    <th>Reason For Leaving </th>
                                                </tr>
                                                {
                                                    employeeDetails.ExperienceDetails.map((obj, index) => (
                                                        <tr>
                                                            <td>{index + 1} </td>
                                                            <td>{obj.organisation} </td>
                                                            <td> {obj.from_date} </td>
                                                            <td>{obj.to_date} </td>
                                                            <td>{obj.last_possition_held} </td>
                                                            <td>{obj.job_responsibility} </td>
                                                            <td>{obj.at_the_time_of_joining} </td>
                                                            <td>{obj.gross_salary_drawn} </td>
                                                            <td>{obj.immediate_superior_designation} </td>
                                                            <td>{obj.reason_for_leaving} </td>
                                                        </tr>
                                                    ))
                                                }
                                            </table>

                                        </main>
                                    }
                                </article>
                            </section>
                            {/* Family Members */}
                            <section className='col-lg-6 p-3 h-[40vh] my-2 mb-3 '>
                                <article className='rounded-lg bgclr p-3 pt-0 h-[40vh] overflow-y-scroll table-responsive w-full '>
                                    <h5 className='sticky top-0 bgclr1 pt-3 pb-2' > Family Members </h5>
                                    {
                                        employeeDetails && employeeDetails.FamilyDetails
                                        && employeeDetails.FamilyDetails.map((obj, index) => (
                                            <section>
                                                <ValueShowingCom name="Name" value={obj.name} />
                                                <ValueShowingCom name="Relation " value={obj.relation} />
                                                <ValueShowingCom name="Age   " value={obj.age} />
                                                <ValueShowingCom name="Profession " value={obj.profession} />
                                                <ValueShowingCom name="DOB" value={obj.dob} />
                                                <ValueShowingCom name="Blood Group" value={obj.blood_group} />
                                                <ValueShowingCom name="Gender" value={obj.gender} />
                                                <hr />
                                            </section>
                                        ))
                                    }
                                </article>
                            </section>
                        </main>}
                </Modal.Body>
            </Modal>

        </div >
    )
}

export default EmployeeProfile