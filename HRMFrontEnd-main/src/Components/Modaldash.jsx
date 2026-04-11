import React from 'react'
import Sidebar from './Sidebar'
import Topnav from './Topnav'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Chart as ChartJS } from "chart.js/auto";
import '../assets/css/fonts.css'
import Slider from "react-slick";
import '../assets/css/media.css'
import Empsidebar from './Empsidebar';

const Modaldash = () => {

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
    const data1 = {
        labels: ['item1', 'item2', 'item3', 'item4', 'item5', 'item6', 'item7',],
        datasets: [
            {
                label: '',
                data: [25, 30, 20, 35, 30, 30, 20],
                fill: false,
                backgroundColor: ['rgb(51,153,255)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }
    const data2 = {
        labels: ['Label1', 'Label2', 'Label3', 'Label4', 'Label5'],
        datasets: [
            {
                label: 'item1',
                data: [20, 40, 90, 40, 80],
                fill: false,
                backgroundColor: 'rgb(245,85,141)',
                tension: 0.1,
                barThickness: 10,

            }


        ],
    }
    const data3 = {
        labels: ['item1', 'item2', 'item3'],
        datasets: [
            {
                label: '',
                data: [25, 35, 40, 30],
                fill: false,
                backgroundColor: ['rgb(51,153,200)', 'rgb(139,150,255)', 'rgb(240,85,141)'],
                tension: 0.1,
                barThickness: 10,

            }

        ],
    }
    return (
        <div className=' d-flex' style={{ width: '100%',minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Empsidebar></Empsidebar>
            </div>
            <div className=' m-0 m-sm-4 ps-4 side-blog' style={{ borderRadius: '10px' }}>
                <Topnav></Topnav>

                <div className="  d-flex mt-4" style={{width:'100%',position:'relative',left:'5px'}}>


                   {/* Sliders start */}

                   <Slider {...settings1} className='container ' >
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
                                </div>

                                <div>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                                    </svg>
                                </div>

                            </div>
                        </div>
                        <div className=''>
                            <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                                <div>
                                    <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                                </div>

                                <div>
                                    <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                                    <p>No Employees Hired</p>
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

                <div className="chart-section p-3 bg-inf mt-4" >

                    <div class="row m-0">
                        <div className="col col-sm-7">
                            <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>My Attendance</h6>


                            <div class="row border rounded p-4 bg-white mt-3">

                                <div className="col " style={{ lineHeight: '50px', position: 'relative', top: '30px', left: '20px' }}>

                                    <div className='d-flex'>
                                        <h5 className='text-success'>1,300 </h5>
                                        <p className='text-total1' style={{ position: 'relative', left: '16px', bottom: '13px' }}>On Time</p>
                                    </div>
                                    <div className='d-flex'>
                                        <h5 className='text-warning'>192 </h5>
                                        <p className='text-total1' style={{ position: 'relative', left: '32px', bottom: '13px' }}>Work From Home</p>
                                    </div>
                                    <div className='d-flex'>
                                        <h5 className='text-primary'>20</h5>
                                        <p className='text-total1' style={{ position: 'relative', left: '40px', bottom: '13px' }}>Late Attendance</p>
                                    </div>
                                    <div className='d-flex'>
                                        <h5 className='text-danger'>10 </h5>
                                        <p className='text-total1' style={{ position: 'relative', left: '43px', bottom: '13px' }}>Absent</p>
                                    </div>

                                </div>
                                <div className="col">
                                    {/* <Bar data={data}></Bar> */}
                                    <Doughnut data={data3}></Doughnut>

                                </div>
                            </div>
                        </div>
                        <div className="col col-sm-5">
                            <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>Statistis</h6>

                            <div class=" border rounded p-4 mt-3 bg-white" >

                                <div className='d-flex justify-content-between mt-0'>



                                    <div>

                                        <h5>Performance</h5>

                                    </div>
                                    <div style={{ height: '100px', position: 'relative', bottom: '30px' }}>

                                        <Line data={data1}></Line>


                                    </div>
                                </div>
                                <div className='d-flex justify-content-between mt-2'>



                                    <div>

                                        <h5>Success</h5>

                                    </div>
                                    <div style={{ height: '100px', position: 'relative', bottom: '30px' }}>

                                        <Line data={data1}></Line>


                                    </div>
                                </div>
                                <div className='d-flex justify-content-between mt-2'>



                                    <div>

                                        <h5>Innovations</h5>

                                    </div>
                                    <div style={{ height: '100px', position: 'relative', bottom: '30px' }}>

                                        <Line data={data1}></Line>


                                    </div>
                                </div>
                            </div>



                        </div>



                    </div>
                    <div class="row m-0">
                        <div className="col col-sm-7">
                            <h6 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>My Team</h6>
                            <table class="table mt-3 border">
                                <thead>
                                    <tr>
                                        <th scope="col">Profiles</th>
                                        <th scope="col">Contact</th>
                                        <th scope="col">Email Id</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th scope="row ">
                                            <div className='d-flex  '>


                                                <div>
                                                    <img class="pt-1 ms-2" src={require('../assets/Icon/profile.png')} width={40} alt="" />
                                                </div>
                                                <div class="ms-4">
                                                    <h6>Name</h6>
                                                    <small>React Devloper</small>
                                                </div>
                                            </div>
                                        </th>
                                        <td>+91 2314313241</td>
                                        <td>abc@gmail.com</td>

                                    </tr>
                                    <tr>
                                        <th scope="row ">
                                            <div className='d-flex  '>


                                                <div>
                                                    <img class="pt-1 ms-2" src={require('../assets/Icon/profile.png')} width={40} alt="" />
                                                </div>
                                                <div class="ms-4">
                                                    <h6>Name</h6>
                                                    <small>React Devloper</small>
                                                </div>
                                            </div>
                                        </th>
                                        <td>+91 2314313241</td>
                                        <td>abc@gmail.com</td>

                                    </tr>
                                    <tr>
                                        <th scope="row ">
                                            <div className='d-flex  '>


                                                <div>
                                                    <img class="pt-1 ms-2" src={require('../assets/Icon/profile.png')} width={40} alt="" />
                                                </div>
                                                <div class="ms-4">
                                                    <h6>Name</h6>
                                                    <small>React Devloper</small>
                                                </div>
                                            </div>
                                        </th>
                                        <td>+91 2314313241</td>
                                        <td>abc@gmail.com</td>

                                    </tr>
                                   
                                </tbody>
                            </table>

                        </div>
                        <div className="col col-sm-5">
                            <h6 className='mt-4 heading' style={{ color: 'rgb(76,53,117)' }}>Working History</h6>

                            <table class="table caption-top mt-4 border rounded">

                                <thead>
                                    <tr>
                                        <th scope="col">Date</th>
                                        <th scope="col">Arrival</th>
                                        <th scope="col">Deperture</th>
                                        <th scope="col">Effecure Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th scope="row">1/4/24</th>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">1/4/24</th>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">1/4/24</th>
                                        <td>Mark</td>
                                        <td>Otto</td>
                                        <td>@mdo</td>
                                    </tr>
                                </tbody>
                            </table>



                        </div>



                    </div>



                </div>

            </div>



        </div>
    )
}

export default Modaldash