import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { meridahrport, port } from '../../App'
import { useNavigate } from 'react-router-dom'
import LoadingData from '../../Components/MiniComponent/LoadingData'

const JobListing = () => {
    let { setTopNav, getProperDate } = useContext(HrmStore)
    let navigate = useNavigate()
    let [loading, setLoading] = useState()
    let [allJobs, setAllJobs] = useState()
    useEffect(() => {
        setTopNav('jobposting')
        getAllJobs()
    }, [])
    let getAllJobs = async () => {
        setLoading('page')
        await axios.get(`${port}/api/job_description/`).then((response) => {
            setAllJobs(response.data?.reverse())
        }).catch((error) => {
            console.log(error, 'jobs');
        })
        setLoading(false)
    }
    let handleToggle = (e, id, currentStatus) => {
        e.stopPropagation()
        axios.patch(`${port}/api/job_description/${id}/`, { is_active: !currentStatus }).then(() => {
            getAllJobs()
        }).catch((error) => {
            console.log(error);
        })
    }

    return (
        <div>
            {
                loading == 'page' ? <LoadingData /> :
                    <div>

                        <section className='flex items-center justify-between ' >
                            <h6> Current Jobs Listed on Our Website </h6>
                            <button onClick={() => navigate('/settings/jobpost')} className='bg-blue-600 text-white p-2 rounded ' >
                                Post Job
                            </button>
                        </section>
                        <main className='tablebg table-responsive max-h-[70vh] relative rounded my-3 ' >
                            <table className='w-full ' >
                                <tr className=' sticky top-0  ' >
                                    <th>SI No </th>
                                    <th>Job Title </th>
                                    <th>Qualification </th>
                                    <th>Department </th>
                                    <th> Experience </th>
                                    <th> Salary Range  </th>
                                    <th>Posted Date </th>
                                    <th> Location  </th>
                                    <th> Status </th>
                                </tr>
                                {
                                    allJobs && allJobs.map((obj, index) => (
                                        // <tr key={obj.id} onClick={() => navigate(`/settings/jobposting/${obj.id}`)} className={`hover:bg-slate-200 cursor-pointer  `} >
                                        <tr key={obj.id} onClick={() => navigate(`/settings/jobposting/${obj.slug || obj.id}`)} className={`hover:bg-slate-200 cursor-pointer  `} >
                                            <td>{index + 1} </td>
                                            <td>{obj.Title} </td>
                                            <td>{obj.Qualification} </td>
                                            <td> {obj.department_name} </td>
                                            <td>
                                                {obj.min_exp && (obj.min_exp) + "yrs"}
                                                {obj.min_exp && obj.Experience && " - "}
                                                {obj.Experience && (obj.Experience) + "yrs "} </td>
                                            <td>
                                                {obj.min_salary && (obj.min_salary) + obj.salary_type}
                                                {obj.min_salary && obj.max_salary && " - "}
                                                {obj.max_salary && (obj.max_salary) + obj.salary_type}
                                            </td>
                                            <td>{new Date(obj.posted_on || obj.created_at).toLocaleDateString('en-GB').replace(/\//g, '-')}</td>
                                            <td> {obj.job_location} </td>
                                            <td onClick={(e) => e.stopPropagation()} >
                                                <input type="checkbox" checked={obj.is_active} onChange={(e) => handleToggle(e, obj.id, obj.is_active)} />
                                                {/* <button className=' ' onClick={() => navigate(`/settings/jobposting/${obj.id}`)} >
                                                    Edit
                                                </button> */}
                                            </td>
                                        </tr>
                                    ))
                                }
                            </table>
                        </main>

                    </div>
            }
        </div>
    )
}

export default JobListing