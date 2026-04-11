import axios from 'axios';
import React, { useEffect, useState } from 'react'
import { Bar, Doughnut, Pie } from 'react-chartjs-2';
import { port } from '../../App';

const EmployeeDiversity = ({ type }) => {
    let [diversityData, setDiversityData] = useState({
        Male: null,
        Female: null,
        Transgender: null,
        Other: null
    })
    let [candidateDiversity, setCandidateDiversity] = useState({

    })
    const options = {
        responsive: true,
        // maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false, // Hide legend
            },
        },
        scales: {
            x: {
                stacked: false, // Enable stacking on the x-axis
                grid: {
                    display: false, // Remove grid lines for x-axis
                },
                ticks: {
                    font: {
                        size: 12,
                    },

                    padding: 10
                },
            },
            y: {
                stacked: false, // Enable stacking on the y-axis
                beginAtZero: true,
                grid: {
                    display: false, // Remove grid lines for x-axis
                    // color:'#f0f0f0f'
                },
                ticks: {
                    font: {
                        size: 12,

                    },
                    crossAlign: 'center'
                },
            },
        },
    };
    const data = {
        labels: [
            'Men',
            'Female',
            'Transgender',
            'Others'
        ],
        datasets: [{
            label: 'EmployeeDiversity',
            data: [diversityData.Male, diversityData.Female, diversityData.Transgender, diversityData.Other],
            backgroundColor: [
                'rgb(38,99,235)',
                'rgb(192,133,252)',
                'rgb(148,252,132)',
                'rgb(0, 0,0)'
            ],
            hoverOffset: 4,
            borderWidth: 2,
            borderRadius: 5,
            borderSkipped: false,
        },
        ]
    };
    let [departmentData, setDepartmentData] = useState({
        labels: [],
        datasets: [{
            label: '',
            data: [],
            backgroundColor: [],
        }]
    })
    let [jobPortalData, setJobPortalData] = useState({
        labels: [],
        datasets: [{
            label: '',
            data: [],
            backgroundColor: [],
        }]
    })
    let getdiversity = () => {
        axios.get(`${port}/root/employee-diversity/`).then((response) => {
            console.log(response.data, 'diversity');
            setDiversityData(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getJobPortData = () => {
        axios.get(`${port}/root/job-portal-source-count/`).then((response) => {
            console.log(response.data, 'diversity-job');
            setJobPortalData((prev) => ({
                ...prev,
                labels: response.data.map((obj) => obj.JobPortalSource),
                datasets: [{
                    label: "",
                    backgroundColor: ['rgb(153, 102, 255)'],
                    data: response.data.map((obj) => obj.count),
                    borderWidth: 2,
                    borderRadius: 5,
                    borderSkipped: false,
                }],
            }))

        }).catch((error) => {
            console.log(error);
        })
    }
    let getDepratment = () => {
        axios.get(`${port}/root/department-ratio/`).then((response) => {
            console.log(response.data, 'diversity-dep');
            setDepartmentData((prev) => ({
                ...prev,
                labels: [...Object.keys(response.data)].map((label) => label.split(' ').join('\n')),
                datasets: [
                    {
                        backgroundColor: ['#4470E2'],
                        data: Object.values(response.data),
                        borderRadius: 5,
                        borderSkipped: false,
                        borderWidth: 2,
                    }],
            }))
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getdiversity()
        getDepratment()
        getJobPortData()
    }, [])
    let options2 = {
        plugins: {
            legend: {
                display: false, // Hide legend
            },
        },
    }
    return (
        <>
            {
                type == 'gender' ?
                    <div className='bgclr rounded p-3 poppins ' >
                        <h5 className=' poppins fw-semibold text-blue-900  ' >Employee Gender Diversity </h5>
                        <section className='sm:w-[20rem] h-[40vh] mx-auto ' >
                            {diversityData && <Doughnut data={data} options={options2} />}
                        </section>
                        {/* Ratio section */}
                        {/* men */}
                        <div className='flex justify-between my-2 items-center ' >
                            <p className='flex items-center mb-0 gap-2 text-xl ' > <span style={{ backgroundColor: 'rgb(38,99,235)' }}
                                className='w-5 h-5 rounded-full  ' ></span> Male </p>
                            <p className='mb-0 ' >{diversityData?.Male && diversityData.Male + '%'}</p>
                        </div>
                         {/* Female */}
                         <div className='flex justify-between my-2 items-center ' >
                            <p className='flex items-center mb-0 gap-2 text-xl ' > <span style={{ backgroundColor: 'rgb(192,133,252)' }}
                                className='w-5 h-5 rounded-full  ' ></span> Female </p>
                            <p className='mb-0 ' >{diversityData?.Female && diversityData.Female + '%'}</p>
                        </div>
                         {/* Transgender */}
                         <div className='flex justify-between my-2 items-center ' >
                            <p className='flex items-center mb-0 gap-2 text-xl ' > <span style={{ backgroundColor: 'rgb(148,252,132)' }}
                                className='w-5 h-5 rounded-full  ' ></span> Transgender </p>
                            <p className='mb-0 ' >{diversityData?.Transgender && diversityData.Transgender + '%'}</p>
                        </div>
                         {/* Others */}
                         <div className='flex justify-between my-2 items-center ' >
                            <p className='flex items-center mb-0 gap-2 text-xl ' > <span style={{ backgroundColor: 'rgb(0, 0,0)' }}
                                className='w-5 h-5 rounded-full  ' ></span> Other </p>
                            <p className='mb-0 ' >{diversityData?.Other && diversityData.Other + '%'}</p>
                        </div>
                    </div> : type == 'portal' ?
                        <div className='bgclr rounded p-3 ' >
                            <h5 className=' poppins fw-semibold text-blue-900  ' >Job Portal  Ratio </h5>
                            <section className=' mx-auto h-[40vh] overflow-x-scroll ' >

                                {jobPortalData && <Bar data={jobPortalData} options={options} />}
                            </section>
                        </div> :

                        <div className='bgclr rounded p-3 ' >
                            <h5 className=' poppins fw-semibold text-blue-900  ' >Department Ratio </h5>
                            <section className=' mx-auto h-[40vh] overflow-x-scroll ' >

                                {departmentData && <Bar data={departmentData} options={options} />}
                            </section>
                        </div>
            }
        </>
    )
}

export default EmployeeDiversity