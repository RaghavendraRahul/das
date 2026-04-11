import React, { useContext, useEffect } from 'react'
import Topnav from './Topnav'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Chart as ChartJS } from "chart.js/auto";
import '../assets/css/fonts.css'
import Slider from "react-slick";
import '../assets/css/media.css'
import Empsidebar from './Empsidebar';
import { HrmStore } from '../Context/HrmContext';
import LeaveApprovalBox from './HomeComponent/LeaveApprovalBox';
import WishesCom from './WishesCom';
import MyAttendance from './Employee/MyAttendance';
import NewSideBar from './MiniComponent/NewSideBar';

const Empdashpage = ({ subpage }) => {

    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('dashboard')
    }, [])


    return (
        <div>
            <div className=' px-2 container-fluid mx-auto ' >

                <WishesCom />
                <main class="row justify-between m-0">
                    <div className="col my-3 col-sm-6">
                        <MyAttendance />
                    </div>
                    {<div className='my-3 col-sm-6' >
                        <LeaveApprovalBox />
                    </div>}
                </main>

            </div>
        </div>
    )
}

export default Empdashpage