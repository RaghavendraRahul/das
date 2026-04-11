import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import { useNavigate } from 'react-router-dom'

const ExitInterviewTable = ({ setActiveSection }) => {
    useEffect(() => {
        setActiveSection('interview')
    }, [])
    let [data, setData] = useState()
    let getAllExitInterviews = () => {
        axios.get(`${port}/root/ems/EmployeeExitInterview`).then((response) => {
            console.log(response.data, 'exitInterview');
            setData(response.data)
        }).catch((error) => {
            console.log(error, 'exitInterview');
        })
    }
    let navigate = useNavigate()
    useEffect(() => {
        getAllExitInterviews()
    }, [])
    return (
        <div>
            <section>
                <p className='fw-semibold text-xl ' > Exit Interviews </p>
            </section>
            <main className='tablebg table-responsive w-full h-[60vh] overflow-y-scroll rounded ' >
                <table className='w-full ' >
                    <tr>
                        <th> SI No </th>
                        <th>Employee Name </th>
                        <th>Employee Id </th>
                        <th> Designation </th>
                        <th> Reason for Resignation </th>
                        <th> Status  </th>
                        <th>Resignation Form  </th>
                    </tr>
                    {
                        data && data.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td> {obj.resignation && obj.resignation.name} </td>
                                <td> {obj.resignation && obj.resignation.employee_id} </td>
                                <td> {obj.resignation && obj.resignation.position} </td>
                                <td> {obj.resignation && obj.resignation.reason_for_leaving} </td>
                                <td>{obj.resignation && obj.resignation.resignation_verification} </td>
                                <td>  <button className='bg-blue-700 text-white rounded text-sm p-1 mx-2 '
                                    onClick={() => navigate(`/employees/Employee_request_form/interview/${obj.resignation && obj.resignation.id}`)} >
                                    View
                                </button>
                                </td>

                            </tr>
                        ))
                    }
                </table>
            </main>
        </div>
    )
}

export default ExitInterviewTable