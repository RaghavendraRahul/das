import React, { useContext, useEffect, useState } from 'react'
import ThreeDot from '../../SVG/ThreeDot'
import { HrmStore } from '../../Context/HrmContext'
import DataNotFound from '../MiniComponent/DataNotFound'
import SearchIcon from '../../SVG/SearchIcon'
import SceeringCompletedCandiateModal from '../Modals/SceeringCompletedCandiateModal'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'

const ActivityTable = ({ data, css, setSelectedAid, type }) => {
    let { convertToReadableDateTime, selectValueToNormal } = useContext(HrmStore)
    let [tableData, setTableData] = useState(data)
    let [showOptions, setShowOptions] = useState()
    let [screeningCompletedCandidateDetailModal, setscreeningCompletedCandidateDetailModal] = useState(false)
    let [screeningCompletedApplicant, setScreeningCompletedApplicant] = useState()
    let [persondata, setPersondata] = useState()

    const handleCompletedApplicant = (id) => {
        axios.get(`${port}/root/New-Candidate-Screening-Completed-Details/${id}/`).then((response) => {
            setScreeningCompletedApplicant(response.data)
            setscreeningCompletedCandidateDetailModal(true)
            console.log("Screening_Completed_Candidate", response.data);
        }).catch((error) => {
            toast.error('Error occured')
            console.log(error, 'Screening_Completed_Candidate');
        })
    }
    const searchFilter = (val) => {
        const word = val;
        const filteredData = [...data].filter((obj) =>
            Object.values(obj).some(
                (field) => field && field.toString().includes(word)
            )
        );
        console.log(filteredData, 'filter');

        setTableData(filteredData);
    };
    useEffect(() => {
        console.log(data, 'count');
        setTableData(data)
    }, [data])
    return (
        <div>
            {data && data.length > 0 && <main className='flex flex-wrap bg-white rounded p-3 justify-between' >
                {
                    data &&
                    Object.entries(
                        data.reduce((acc, obj) => {
                            const { PositionAppliedFor, candidate_designation, AppliedDesignation, mail_sent, interview_status } = obj;
                            if (mail_sent)
                                acc[mail_sent] = (acc[mail_sent] || 0) + 1;
                            if (PositionAppliedFor)
                                acc[PositionAppliedFor] = (acc[PositionAppliedFor] || 0) + 1;
                            if (AppliedDesignation)
                                acc[AppliedDesignation] = (acc[AppliedDesignation] || 0) + 1;
                            if (candidate_designation)
                                acc[candidate_designation] = (acc[candidate_designation] || 0) + 1;
                            if (interview_status)
                                acc[interview_status] = (acc[interview_status] || 0) + 1
                            return acc;
                        }, {})
                    )?.sort((a, b) => b[1] - a[1]).map(([position, count]) => (
                        <div className=" sm:w-[50%] flex items-start justify-between capitalize md:w-[30%] my-2 cursor-pointer"
                            onClick={() => {
                                let filteredData = data.filter((obj) => obj.interview_status == position || obj.PositionAppliedFor == position || obj.mail_sent == position ||
                                    obj.candidate_designation == position || obj.AppliedDesignation == position)
                                setTableData(filteredData)
                                const element = document.getElementById('activitytable');
                                if (element) {
                                    element.scrollIntoView({ behavior: 'smooth' });
                                }
                            }} key={position}>
                            {position?.replace(/_/g, ' ')} <span className='fw-semibold text-blue-600 ' > : {count} </span>
                        </div>
                    ))

                }
            </main>}

            {tableData && <div className='flex gap-3 justify-between items-start my-2 ' >
                {/* <p>Total Count : <span className='fw-semibold  ' >{[...tableData].length} </span> </p> */}
                <div onClick={() => setTableData(data)} className=' flex items-start justify-between cursor-pointer gap-2 my-2  ' >
                    Total <span className='fw-semibold text-blue-600 ' > : {data && data.length} </span>
                </div>
                <div className='bg-white flex rounded items-center px-2 ' >
                    <input type="text" onChange={(e) => searchFilter(e.target.value)}
                        placeholder='Search' className='py-2 rounded outline-none w-40 ' />
                    <SearchIcon />
                </div>
            </div>}
            <main id='activitytable' className={`tablebg table-responsive ${css ? css : "h-[50vh]"} `} >
                {tableData && tableData.length > 0 ?
                    <table className='w-full '>
                        {/* heading */}
                        <tr className='sticky top-0 z-20 ' >
                            <th className=' ' >SI No</th>
                            {tableData[0]?.candidate_name && <th>Candidate Name </th>}
                            {tableData[0]?.position && <th>Position</th>}
                            {(tableData[0].Created_Date) && <th>Created Date / Time </th>}
                            {tableData[0]?.candidate_current_status && < th > Candidate Exp Status </th>}
                            {tableData[0]?.candidate_phone && <th>Candidate Phone </th>}
                            {tableData[0]?.candidate_email && <th>Candidate Email </th>}
                            {tableData[0]?.candidate_designation && <th>Candidate Designation </th>}
                            {tableData[0]?.candidate_experience && <th>Experience</th>}
                            {tableData[0]?.interview_call_remarks && <th>Remarks </th>}


                            {tableData[0]?.client_enquire_purpose && <th>Client Enquire Purpose</th>}
                            {tableData[0]?.client_name && <th>Client Name</th>}
                            {tableData[0]?.client_phone && <th>Client Phone</th>}
                            {tableData[0]?.client_spok && <th>Client Spok</th>}
                            {tableData[0]?.client_status && <th>Client Status</th>}
                            {tableData[0]?.interview_scheduled_date && <th>Interview Scheduled Date</th>}

                            {tableData[0]?.interview_walkin_date && <th>Interview Walk-in Date</th>}

                            {tableData[0]?.message_to_candidates && <th>Message to Candidates</th>}

                            {tableData[0]?.source && <th>Source</th>}
                            {tableData[0]?.url && <th>URL</th>}
                            {tableData[0]?.interview_status && <th>Interview Status</th>}
                            {/* Screening process */}
                            {(type == 'screening' || tableData[0].FirstName) && <th>Full Name </th>}
                            {(type == 'screening' || tableData[0].CandidateId) && <th>Candidate ID</th>}
                            {tableData[0].Email && <th>Email ID </th>}
                            {(type == 'screening') && <th>Assigned To </th>}
                            {(type == 'screening' || tableData[0].AppliedDesignation) && <th> Position Applied for </th>}
                            {tableData[0].AppliedDate && <th>Application Date </th>}
                            {(type == 'screening') && <th>Assigned By</th>}
                            {/* {(type == 'screening' ) && <th>Date Assigned </th>} */}
                            {(type == 'screening') && <th>Date Reviewed</th>}
                            {(type == 'screening') && <th>Screening Status </th>}
                            {(type == 'screening') && <th>Comments </th>}
                            {/* campaign */}
                            {tableData[0].mail_sent && <th>Mail Sent(reason) </th>}
                            {tableData[0].mail_count && <th>Number of mail sended </th>}
                            {tableData[0]?.college_visit && <th> College/Institution name</th>}
                            {tableData[0].visit_date && <th> Visited Date </th>}

                            {tableData[0]?.job_post_remarks && <th>Remarks</th>}
                            {tableData[0]?.client_call_remarks && <th> Remarks</th>}
                        </tr>

                        {
                            tableData && tableData.map((obj, index) => (
                                // [1, 2, 3].map((obj, index) => (
                                <tr>
                                    {console.log(obj, 'ket')
                                    }
                                    <td className='relative ' >
                                        {(type == 'interview_schedule' || type == 'walkins') ? <span>
                                            {index + 1}
                                        </span> : <span onClick={() => setShowOptions((prev) => prev == index ? -1 : index)}
                                            className='mx-auto flex w-fit px-3 py-1 cursor-pointer ' >
                                            <ThreeDot size={4} />
                                        </span>}
                                        {showOptions == index &&
                                            <div className='bg-white p-2 rounded w-40 z-10 shadow absolute ' >
                                                <button onClick={() => setSelectedAid(obj?.id)} className='text-start w-full ' >
                                                    Edit
                                                </button>
                                            </div>}
                                    </td>
                                    {tableData[0]?.candidate_name && <td>{obj?.candidate_name} </td>}
                                    {tableData[0]?.position && <td> {obj?.position} </td>}
                                    {(tableData[0].Created_Date) &&
                                        <td className=' ' >{obj?.Created_Date && convertToReadableDateTime(obj?.Created_Date)} </td>}
                                    {tableData[0]?.candidate_current_status && <td>
                                        {obj?.candidate_current_status && selectValueToNormal(obj?.candidate_current_status)}</td>}
                                    {tableData[0]?.candidate_phone && <td>{obj?.candidate_phone} </td>}
                                    {tableData[0]?.candidate_email && <td> {obj?.candidate_email} </td>}
                                    {tableData[0]?.candidate_designation && <td> {obj?.candidate_designation} </td>}
                                    {tableData[0]?.candidate_experience && <td>{obj?.candidate_experience ? obj?.candidate_experience : '--'} </td>}
                                    {tableData[0]?.interview_call_remarks && <td className=' text-wrap ' >{obj?.interview_call_remarks} </td>}



                                    {tableData[0]?.client_enquire_purpose && <td> {obj?.client_enquire_purpose} </td>}
                                    {tableData[0]?.client_name && <td>{obj?.client_name}</td>}
                                    {tableData[0]?.client_phone && <td>  {obj?.client_phone} </td>}
                                    {tableData[0]?.client_spok && <td> {obj?.client_spok} </td>}
                                    {tableData[0]?.client_status && <td> {obj?.client_status} </td>}
                                    {tableData[0]?.interview_scheduled_date && <td> {obj?.interview_scheduled_date && convertToReadableDateTime(obj?.interview_scheduled_date)} </td>}

                                    {tableData[0]?.interview_walkin_date && <td> {obj?.interview_walkin_date && convertToReadableDateTime(obj?.interview_walkin_date)} </td>}

                                    {tableData[0]?.message_to_candidates && <td>{obj?.message_to_candidates} </td>}

                                    {tableData[0]?.source && <td> {obj?.source} </td>}
                                    {tableData[0]?.url && <td> {obj?.url} </td>}
                                    {tableData[0]?.interview_status && <td>{obj?.interview_status && selectValueToNormal(obj?.interview_status)} </td>}
                                    {/* Screening */}
                                    {(type == 'screening' || obj.FirstName) && 
                                    <td className='cursor-pointer text-blue-600'
                                        onClick={() => { handleCompletedApplicant(obj?.CandidateId) }}>
                                        <span className='text-blue-600  ' >
                                            {obj?.Name} {obj?.FirstName || '--'}
                                         </span> </td>}
                                    {(type == 'screening' || tableData[0].CandidateId) && <td>{obj?.CandidateId} </td>}
                                    {tableData[0].Email && <td>{obj.Email} </td>}
                                    {(type == 'screening') && <td>{obj?.InterviewerName} </td>}
                                    {(type == 'screening' || tableData[0].AppliedDesignation) && <td> {obj?.PositionAppliedFor}{obj?.AppliedDesignation} </td>}
                                    {tableData[0].AppliedDate && <td>{obj.AppliedDate} </td>}
                                    {(type == 'screening') && <td>{obj.Assigned_by ? obj.Assigned_by : '--'} </td>}
                                    {/* {(type == 'screening' ) && <td>{obj?.InterviewScheduleDate && 
                                    convertToReadableDateTime(obj?.InterviewScheduleDate) } </td>} */}
                                    {(type == 'screening') && <td>{obj?.ReviewedOn && convertToReadableDateTime(obj?.ReviewedOn)} </td>}
                                    {(type == 'screening') && <td>{obj?.Screening_Status ? obj?.Screening_Status : '---'} </td>}
                                    {(type == 'screening') && <td className=' w-[200px] text-wrap ' > {obj?.Comments} </td>}
                                    {/* Campaign */}
                                    {tableData[0].mail_sent && <td>{obj.mail_sent} </td>}
                                    {tableData[0].mail_count && <td>{obj.mail_count} </td>}
                                    {tableData[0]?.college_visit && <td> {obj.college_visit} </td>}
                                    {tableData[0].visit_date && <td> {obj.visit_date} </td>}
                                    {tableData[0]?.job_post_remarks && <td>{obj?.job_post_remarks} </td>}
                                    {tableData[0]?.client_call_remarks && <td className=' text-wrap ' > {obj?.client_call_remarks} </td>}

                                </tr>
                            ))
                        }
                    </table> :
                    <div>
                        <DataNotFound />
                    </div>
                }
            </main>
            {<SceeringCompletedCandiateModal show={screeningCompletedCandidateDetailModal}
                persondata={persondata}
                setshow={setscreeningCompletedCandidateDetailModal} setPersondata={setPersondata}
                data={screeningCompletedApplicant} />}
        </div >
    )
}

export default ActivityTable