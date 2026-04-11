import axios from 'axios';
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App';
import EmployeeTable from '../../Components/Tables/EmployeeTable';
import { HrmStore } from '../../Context/HrmContext';
import ActivityTargetModal from '../../Components/Modals/ActivityTargetModal';
import LoadingData from '../../Components/MiniComponent/LoadingData';

const MyTeamActivity = () => {
    let { setTopNav } = useContext(HrmStore)
    let [allEmployeeList, setAllEmployeeList] = useState()
    let [selectedEmp, setSelectedEmp] = useState([])
    let [filteredList, setFilteredList] = useState()
    let [loading, setLoading] = useState(false)
    const fetchdata = () => {
        let Empid = JSON.parse(sessionStorage.getItem('dasid'))
        setLoading(true)
        axios.get(`${port}/root/ems/ReportingTeam/${Empid}/`).then((res) => {
            console.log("ReportingTeam_res", res.data);
            setAllEmployeeList(res.data)
            setFilteredList(res.data)
            setLoading(false)
        }).catch((err) => {
            console.log("ReportingTeam_err", err.data);
            setLoading(false)
        })
    }
    useEffect(() => {
        fetchdata()
        setTopNav('myteam')
    }, [])
    return (
        <div>
            {/* Activity button */}
            <div className='my-2   '>
                <ActivityTargetModal data={allEmployeeList} />
            </div>
            {loading ? <LoadingData /> :
                <EmployeeTable css='h-[80vh]'
                    nav='/activity/myteam' data={filteredList} />}

        </div>
    )
}

export default MyTeamActivity