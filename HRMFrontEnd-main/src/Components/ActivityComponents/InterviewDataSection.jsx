import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import DataNotFound from '../MiniComponent/DataNotFound'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'
import LoadingData from '../MiniComponent/LoadingData'
import TableRow from '../MiniComponent/TableRow'



const InterviewDataSection = ({ empid, css, dates, getTrigger, month, year }) => {
    let [interviewData, setInterviewData] = useState()
    let [loading, setLoading] = useState(false)
    let { changeDateYear } = useContext(HrmStore)
    let navigate = useNavigate()
    // let getData = () => {
    //     setLoading(true)
    //     axios.get(`${port}/root/DisplayEmployeeActivitys/${empid}?current_month=${month + 1}&current_year=${year}`).then((response) => {
    //         console.log(response.data, 'dataact',`${port}/root/DisplayEmployeeActivitys/${empid}?current_month=${month + 1}&current_year=${year}`);
    //         setLoading(false)
    //         setInterviewData(response.data)
    //     }).catch((error) => {
    //         console.log(error, 'dataact');
    //         setLoading(false)
    //     })
    // }




    let getData = () => {
        // setLoading(true);
        // axios.get(`${port}/root/employee-interview-dashboard/${empid}?month=${month + 1}&year=${year}`)
        //     .then((response) => {
        //         console.log('Dashboard Counts:', response.data);
        //         setLoading(false);
        //         const counts = response.data;

        //         const transformedData = {
        //             interview_schedules: [{ activity_id: 1, date: '', interview_schedule_data: { length: counts.interview_schedule || 0 } }],
        //             walkins_schedules: [{ activity_id: 1, date: '', walkin_schedule_data: { length: counts.interview_attended || 0 } }],
        //             screening: [{ activity_id: 1, date: '', screening_conducted_data: { length: counts.screening || 0 } }],
        //             Internal_Hiring: [{ activity_id: 1, date: '', internal_hiring_data: { length: counts.Internal_Hiring || 0 } }],
        //             On_Hold: [{ activity_id: 1, date: '', On_Hold_data: { length: counts.On_Hold || 0 } }],
        //             Reject: [{ activity_id: 1, date: '', Rejections_data: { length: counts.Reject || 0 } }],
        //             Rejected_by_Candidate: [{ activity_id: 1, date: '', Rejected_by_Candidate_data: { length: counts.Rejected_by_Candidate || 0 } }],
        //             consider_to_client: [{ activity_id: 1, date: '', consider_to_client_data: { length: counts.consider_to_client || 0 } }],
        //             Offers: [{ activity_id: 1, date: '', offers_data: { length: counts.Offers || 0 } }],
        //             Offer_did_not_accept: [{ activity_id: 1, date: '', offers_tejects_data: { length: counts.Offer_did_not_accept || 0 } }],
        //             walkout: [{ activity_id: 1, date: '', walkouts_data: { length: counts.walkout || 0 } }]
        //         };

        //         setInterviewData(transformedData);

        setLoading(true)
        axios.get(`${port}/root/DisplayEmployeeActivitys/${empid}?current_month=${month + 1}&current_year=${year}`).then((response) => {
            console.log(response.data, 'dataact', `${port}/root/DisplayEmployeeActivitys/${empid}?current_month=${month + 1}&current_year=${year}`);
            setLoading(false)
            setInterviewData(response.data)
        }).catch((error) => {
            console.log(error, 'dataact');
            setLoading(false)
        })
    }

    useEffect(() => {
        getData()
    }, [empid, getTrigger, month, year])
    return (
        <div>
            <h5 className='my-4 ' >Interview Activity </h5>
            <main className={` tablebg table-responsive ${css ? css : "h-[45vh]"} `} >
                {
                    loading ? <LoadingData /> :
                        interviewData ?
                            <table className='w-full ' >
                                <tr className=' '>
                                    <th scope="col" colSpan={2} className='text-center break-words text-break sticky-left '
                                        style={{ minWidth: '300px' }}>Date</th>
                                    {dates.map(date => (
                                        <th key={date} rowSpan={2} className='text-center items-center pb-4'>
                                            {date && changeDateYear(date)}</th>
                                    ))}
                                </tr>
                                <tr className='sticky left-0 ' >
                                    <th style={{ width: '150px' }}
                                        scope="col" className='ms-3 break-words text-break sticky-left '>

                                        Interview Status
                                    </th>
                                    <th style={{ minWidth: '150px' }}
                                        scope="col" className='text-center break-words 
                                        text-break bg-white sticky left-[260px] '>
                                        Total Achieved
                                    </th>
                                </tr>
                                {
                                    interviewData && interviewData.interview_schedules &&
                                    <tr>
                                        <td onClick={() => {
                                            navigate(`/activity/particularActivity/${empid}/?aid=${interviewData.interview_schedules[0].activity_id}&type=interview_schedule&month=${month}&year=${year}`)
                                        }} style={{ minWidth: '250px' }} className='sticky-left cursor-pointer hover:bg-slate-50 ' >

                                            <p className='text-blue-600 mb-0 p-0 ' >
                                                Interview Schedules

                                            </p>
                                        </td>
                                        <td className='sticky left-[260px] bg-white'>
                                            {interviewData && interviewData.interview_schedules.reduce((acc, obj) => {
                                                let num = obj?.interview_schedule_data?.length || 0
                                                return acc + num
                                            }, 0)}
                                        </td>
                                        {
                                            dates && dates.map((date, index) => {
                                                let findVal = interviewData.interview_schedules.find((obj) => obj.date == date)
                                                console.log(findVal?.interview_schedule_data.length, 'inval');
                                                return (
                                                    <td onClick={() => {
                                                        if (findVal && findVal.interview_schedule_data.length > 0)
                                                            navigate(`/activity/particularActivity/${empid}?aid=${interviewData.interview_schedules[index].activity_id}&type=interview_schedule&date=${date}`)
                                                    }}
                                                        className={`  ${findVal && findVal.interview_schedule_data.length > 0 && 'cursor-pointer hover:bg-slate-50'}  `} >
                                                        <span className={`  ${findVal && findVal.interview_schedule_data.length > 0 && 'text-blue-600 '} `} >

                                                            {findVal ? findVal.interview_schedule_data.length : '--'}
                                                        </span>
                                                    </td>
                                                )
                                            })}
                                    </tr>}
                                {
                                    interviewData && interviewData.walkins_schedules &&
                                    <tr>
                                        <td onClick={() => {
                                            navigate(`/activity/particularActivity/${empid}/?aid=${interviewData.interview_schedules[0].activity_id}&type=walkins&month=${month}&year=${year}`)
                                        }} style={{ minWidth: '250px' }} className='sticky-left cursor-pointer hover:bg-slate-50 ' >
                                            <p className='text-blue-600 mb-0 p-0 ' >
                                                Interview attended

                                            </p>
                                        </td>
                                        <td className='sticky left-[260px] bg-white'>
                                            {interviewData && interviewData.walkins_schedules.reduce((acc, obj) => {
                                                let num = obj?.walkin_schedule_data?.length || 0
                                                return acc + num
                                            }, 0)}
                                        </td>
                                        {
                                            dates && dates.map((date, index) => {
                                                let findVal = interviewData.walkins_schedules.find((obj) => obj.date == date)
                                                console.log(findVal?.walkin_schedule_data?.length, 'inval');
                                                return (
                                                    <td onClick={() => {
                                                        if (findVal && findVal.walkin_schedule_data.length > 0)
                                                            navigate(`/activity/particularActivity/${empid}?aid=${interviewData.walkins_schedules[index].activity_id}&type=walkins&date=${date}`)
                                                    }} className={` ${findVal && findVal.walkin_schedule_data.length > 0 && 'cursor-pointer hover:bg-slate-50'} `} >
                                                        <span className={` ${findVal && findVal.walkin_schedule_data.length > 0 && 'text-blue-600 '} `} >
                                                            {findVal ? findVal.walkin_schedule_data.length : '--'}
                                                        </span>
                                                    </td>
                                                )
                                            })}
                                    </tr>}

                                {
                                    interviewData && interviewData.screening &&
                                    <TableRow interviewData={interviewData} objField='screening_conducted_data' activityType='screening'
                                        label="Screening" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }
                                {
                                    interviewData && interviewData.Internal_Hiring &&
                                    <TableRow interviewData={interviewData} objField='internal_hiring_data' activityType='Internal_Hiring'
                                        label="Internal Hiring" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }

                                {
                                    interviewData && interviewData.On_Hold &&
                                    <TableRow interviewData={interviewData} objField='On_Hold_data' activityType='On_Hold'
                                        label="On Hold" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }
                                {
                                    interviewData && interviewData.Reject &&
                                    <TableRow interviewData={interviewData} objField='Rejections_data' activityType='Reject'
                                        label="Reject" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }

                                {
                                    interviewData && interviewData.Rejected_by_Candidate &&
                                    <TableRow interviewData={interviewData} objField='Rejected_by_Candidate_data' activityType='Rejected_by_Candidate'
                                        label="Rejected by Candidates" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }
                                {
                                    interviewData && interviewData.consider_to_client &&
                                    <TableRow interviewData={interviewData} objField='consider_to_client_data' activityType='consider_to_client'
                                        label="Consider to client" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }

                                {
                                    interviewData && interviewData.Offers &&
                                    <TableRow interviewData={interviewData} objField='offers_data' activityType='Offers'
                                        label="Offers" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }

                                {
                                    interviewData && interviewData.Offer_did_not_accept &&
                                    <TableRow interviewData={interviewData} objField='offers_tejects_data' activityType='Offer_did_not_accept'
                                        label="Offer Rejected by Candidates" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }
                                {
                                    interviewData && interviewData.walkout &&
                                    <TableRow interviewData={interviewData} objField='walkouts_data' activityType='walkout'
                                        label="Walkout" dates={dates} month={month} year={year} empid={empid}
                                    />
                                }
                            </table>
                            :
                            <DataNotFound css='h-[38vh]' />
                }

            </main>


        </div>
    )
}

export default InterviewDataSection