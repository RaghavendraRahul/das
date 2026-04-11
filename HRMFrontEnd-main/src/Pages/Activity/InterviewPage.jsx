import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import { useParams } from 'react-router-dom'
import InterviewDataSection from '../../Components/ActivityComponents/InterviewDataSection'

const InterviewPage = ({ emyid }) => {
    let { setTopNav } = useContext(HrmStore)
    let { empid } = useParams()
    let [interviewData, setInterviewData] = useState()
    let getinterviewData = () => {
        axios.get(`${port}/root/display-interviewcalls-date?login_emp_id`).then((response) => {
            console.log(response.data);

        }).catch((error) => {
            console.log(error);
        })
    }

    useEffect(() => {
        getinterviewData()
        setTopNav('interview')
    }, [])
    return (
        <div>
            <InterviewDataSection/>

        </div>
    )
}

export default InterviewPage