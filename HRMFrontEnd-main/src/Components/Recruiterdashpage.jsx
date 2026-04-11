import React, { useContext, useEffect, useState } from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Chart as ChartJS } from "chart.js/auto";
import '../assets/css/fonts.css'
import Slider from "react-slick";
import '../assets/css/media.css'
import Recsidebar from './Recsidebar';
import ReactSpeedometer from "react-d3-speedometer";
import HrmContext, { HrmStore } from '../Context/HrmContext';
import WishesCom from './WishesCom';
import NewSideBar from './MiniComponent/NewSideBar';


const Recruiterdashpage = ({ subpage }) => {

    const [value, setValue] = useState(50);

    const handleChange = (newValue) => {
        setValue(newValue);
    };


    var settings1 = {
        dots: false,
        arrows: false,
        infinite: true,
        speed: 900,
        slidesToShow: 4,
        autoplay: true,
        speed: 1000,
        responsive: [
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                    initialSlide: 2
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    };

    const data = {
        labels: ['Open-Position', 'Close-Position'],
        datasets: [
            {
                label: '',
                data: [20, 60],
                fill: false,
                backgroundColor: ['rgb(0,61,121)', 'rgb(247,160,0)'],
                tension: 0.1,
                barThickness: 50,

            }

        ],
    }
    const data1 = {
        labels: ['Market', 'It', 'Sales', 'Recruiment'],
        datasets: [
            {
                label: '',
                data: [25, 35, 40, 20],
                fill: false,
                backgroundColor: ['rgb(51,153,255)', 'rgb(139,207,255)', 'rgb(245,85,141)', 'rgb(241,152,40)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }
    const data2 = {
        labels: ['0', '0 to 3', '3 to 5', '5 to 8', '8 to 10'],
        datasets: [
            {
                label: '',
                data: [20, 40, 90, 40, 80],
                fill: false,
                backgroundColor: 'rgb(245,85,141)',
                tension: 0.1,
                barThickness: 10,

            }


        ],
    }
    const data3 = {
        labels: ['item1', 'item2',],
        datasets: [
            {
                label: '',
                data: [25, 35, 40],
                fill: false,
                backgroundColor: ['rgb(51,153,200)', 'rgb(139,150,255)', 'rgb(240,85,141)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }
    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('dashboard')
    }, [])

    return (
        <div>

          
            <div className=' m-0 p-sm-3 flex-1 container-fluid mx-auto ' style={{ borderRadius: '10px' }}>
              
                <WishesCom />
                <div className="  d-flex mt-4 inner_sections" >


                    {/* Sliders start */}

                    <Slider {...settings1} className='container ' >
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    {/* <h4 style={{ position: 'relative', top: '5px' }}>{canditatedetails != undefined && canditatedetails.length}</h4> */}
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p  >InternalHiring</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/presenter-talking-about-people-on-a-screen-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p >Consider To Client for Merida</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/candidates-ranking-graphic-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p >Shortlist Canditates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/rejected-3-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p >Rejected Candidates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="m-2 box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/hands-pray-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>0</h4>
                                    <p >Offerd Candidates</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>

                    </Slider>


                    {/* Sliders end */}

                </div>

                <div className="chart-section p-1 bg-inf mt-4">
                    <div class="row m-0">
                        <div className="col col-sm-7">
                            <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>No Of Open / Close Position</h6>
                            <div class=" border rounded p-4 bg-white mt-3">

                                <Bar data={data}></Bar>

                            </div>






                        </div>
                        <div className="col col-sm-5">


                            <div class=" border rounded p-3 mt-5 bg-white">


                                <div className=" d-flex justify-content-between align-items-center">
                                    <div className="male text-center">
                                        <p className='text-total' style={{ color: 'rgb(76,53,117)' }}>Total Offerd Accepted</p>
                                        <h4 class="text-center text-success">80 %</h4>


                                    </div>

                                    <div className="female text-center">
                                        <p className='text-total' style={{ color: 'rgb(76,53,117)' }}>Total Offerd Decline</p>
                                        <h4 class="text-center text-success">50 %</h4>

                                    </div>

                                    <div className="female text-center">
                                        <p className='text-total' style={{ color: 'rgb(76,53,117)' }}>Extended Offers</p>

                                        <h4 class="text-center text-success ">70 %</h4>

                                    </div>
                                </div>


                            </div>

                            <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Canditate Diversity</h6>

                            <div class=" border rounded p-3 mt-3 bg-white">


                                <div className="male-female-box d-flex justify-content-evenly align-items-center">
                                    <div className="male ">
                                        <h2 class="">70 %</h2>
                                        <h6 style={{ position: 'relative', top: '12px', color: 'rgb(244,158,0)' }} className='text-center '>Male</h6>

                                    </div>
                                    <div>
                                        |
                                    </div>
                                    <div className="female">

                                        <h2>30 %</h2>
                                        <h6 style={{ position: 'relative', top: '12px', color: 'rgb(244,158,0)' }} className='text-center'>FeMale</h6>

                                    </div>
                                    <div>
                                        |
                                    </div>
                                    <div className="othres">

                                        <h2>10 %</h2>
                                        <h6 style={{ position: 'relative', top: '12px', color: 'rgb(244,158,0)' }} className='text-center'>Others</h6>

                                    </div>
                                </div>


                            </div>






                        </div>
                    </div>

                    <div class="row m-0">
                        <div className="col col-sm-8">

                            <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Canditate Satisfacation</h6>
                            <div class=" border rounded p-4 mt-3 bg-white">

                                <Line data={data2}></Line>

                            </div>

                            <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Application Completion Rate</h6>
                            <div className="border rounded p-4 mt-3 bg-white speedometer-container">
                                <ReactSpeedometer
                                    maxValue={100}
                                    value={45}
                                    needleColor="red"
                                    segments={3}
                                    width={600}
                                    height={340}
                                    segmentColors={['rgb(51,153,255)', 'rgb(139,207,255)', 'rgb(245,85,141)']}
                                />

                            </div>




                        </div>
                        <div className="col col-sm-4">



                            <h6 className='mt-3 heading' style={{ color: 'rgb(76,53,117)' }}>Applicant Analytics By Department</h6>

                            <div class=" border rounded p-4 mt-3 bg-white">


                                <Doughnut data={data1}></Doughnut>


                            </div>





                        </div>
                    </div>



                </div>

            </div>



        </div>
    )
}

export default Recruiterdashpage