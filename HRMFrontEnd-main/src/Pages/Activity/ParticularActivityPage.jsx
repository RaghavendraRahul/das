import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react'
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { port } from '../../App';
import ActivityTable from '../../Components/Tables/ActivityTable';
import LoadingData from '../../Components/MiniComponent/LoadingData';
import { HrmStore } from '../../Context/HrmContext';
import ActivityUploadModal from '../../Components/Modals/ActivityUploadModal';
import BackButton from '../../Components/MiniComponent/BackButton';
import EmpNameCom from '../../Components/MiniComponent/EmpNameCom';

const ParticularActivityPage = () => {
    let { empid } = useParams()
    let location = useLocation();
    let queryParams = new URLSearchParams(location.search)
    let [aid, setAid] = useState(queryParams.get('aid'))
    let [activityName, setActivityName] = useState(queryParams.get('activity_name'))
    let [date, setDate] = useState(queryParams.get('date'))
    let [todate, setToDate] = useState()
    let [month, setMonth] = useState(queryParams.get('month'))
    let [year, setYear] = useState(queryParams.get('year'))

    let [activityStatus, setActivityStatus] = useState(queryParams.get('type'))


    let { selectValueToNormal, setTopNav } = useContext(HrmStore)
    let [showModal, setshowModal] = useState(false)
    console.log(empid, aid, date);
    let [loading, setloading] = useState(false)
    let [activityData, setActivityData] = useState()
    let [tableData, setTableData] = useState()
    let [activity, setActivity] = useState()
    let [selectedAid, setSelectedAid] = useState()
    let getData = () => {
        let queryString = `?${aid ? `activity_list_id=${aid}`
            : ''}${activityName ? `&activity_name=${activityName}`
                : ''}${date && !todate ? `&date=${date}`
                    : ''}${empid ? `&login_emp_id=${empid}`
                        : ''}${activityStatus ? `&activity_status=${activityStatus}`
                            : ''}${month ? `&current_month=${Number(month) + 1}`
                                : ''}${year ? `&current_year=${year}`
                                    : ''}${todate && date ? `&start_date=${date}&end_date=${todate}`
                                        : ''}${year && month && !date && activityStatus ? `&requirement=full_month` : ''}`;

        let api = month && year && !date && activityStatus ?
            `/root/DisplayEmployeeActivitys/${empid}` : activityStatus ?
                `/root/CreateInterviewAchievedActivitys` : `/root/create-daily-achieved-activity`
        console.log(`${port}${api}${queryString}`, aid, 'partdata');
        setloading(true)
        axios.get(`${port}${api}${queryString}`).then((response) => {
            console.log(response.data, 'partdata');
            console.log((response.data.map((obj) => obj.per_day_achievements)?.flat()), 'partdata1');
            setActivityData(response.data)
            setTableData(response.data?.map((obj) => obj.per_day_achievements)?.flat())
            setloading(false)
        }).catch((error) => {
            console.log(error, 'partdata');
            setActivityData([])
            setTableData([])
            setloading(false)
        })
    }
    useEffect(() => {

        setTopNav('perosnal')
        getData()
        if (empid) {
            getActivity()
        }
        if (empid != JSON.parse(sessionStorage.getItem('dasid')))
            setTopNav('myteam')
    }, [empid, aid, activityStatus, date, todate, activityName])
    let getActivity = () => {
        axios.get(`${port}/root/activity-list/assigned/${empid}`).then((response) => {
            console.log(response.data, 'yyyy');
            setActivity(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }

    let navigate = useNavigate()
    return (
        <div className='poppins ' >
            {/* Activity filter options */}

            <BackButton />
            {empid && <EmpNameCom empid={empid} />}

            <main className=' my-3 flex flex-wrap gap-3 justify-between outline-none ' >
                <select name="" className='p-2 rounded my-2 ' value={aid} onChange={(e) => { setAid(e.target.value); setActivityStatus(null) }} id="">
                    <option value="">Select</option>
                    {
                        activity && activity.map((obj) => (
                            <option value={obj.id}>{obj.activity_name && selectValueToNormal(obj.activity_name)} </option>
                        ))
                    }
                </select>
                <div className='flex flex-wrap gap-2 items-center my-2' >
                    <div className='p-2 bg-white flex items-center gap-2 w-fit rounded  text-sm' >
                        From :
                        <input type="date" value={date} onChange={(e) => {
                            const selectedDate = e.target.value;
                            if (!todate || selectedDate < todate) {
                                setDate(selectedDate);
                            } else {
                                setDate(todate)
                            }
                        }}

                            className=' outline-none' />
                    </div>
                    <div className='p-2 bg-white flex items-center gap-2 w-fit rounded  text-sm' >
                        To :
                        <input type="date" value={todate} onChange={(e) => {
                            const selectedToDate = e.target.value;
                            if (!date || selectedToDate > date) {
                                setToDate(selectedToDate);
                            } else {
                                setToDate(date)
                            }
                        }}
                            className=' outline-none' />
                    </div>

                    {empid == JSON.parse(sessionStorage.getItem('dasid')) &&
                        <button className='p-2 bluebtn rounded mx-2'
                            onClick={() => setshowModal(true)} >
                            Add Activity
                        </button>
                    }
                    <ActivityUploadModal getData={getData} setAid={setSelectedAid} aid={selectedAid}
                        empid={empid} show={showModal} setshow={setshowModal} />
                </div>
            </main>

            {loading ? <LoadingData /> :
                <ActivityTable type={activityStatus} setSelectedAid={setSelectedAid} data={tableData} />}

        </div>
    )
}

export default ParticularActivityPage