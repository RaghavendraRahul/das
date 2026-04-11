import React, { useContext } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'

const ClientRequirmentTable = ({ data }) => {
    let { changeDateYear,convertToReadableDateTime } = useContext(HrmStore)
    let navigate = useNavigate()
    return (
        <div>
            <main className='tablebg my-3 rounded table-responsive h-[50vh] overflow-y-scroll ' >
                <table className='w-full  ' >
                    <tr className='sticky top-0 ' >
                        <th>SI no  </th>
                        <th>Client Oranization </th>
                        <th>Added By </th>
                        <th> Job Name  </th>
                        <th> Openings </th>
                        <th> Job Location </th>
                        <th> Package </th>
                        <th> Expericence </th>
                        <th>Qualification  </th>
                        <th>Skills </th>
                        <th>Interview Dates</th>
                        <th>Application Date </th>
                    </tr>
                    {
                        data && data.map((obj, index) => (
                            <tr className={` hover:bg-slate-50 cursor-pointer `}
                                onClick={() => navigate(`/client/recuirment/${obj.id}`)} >
                                {console.log(obj, 'obj')}
                                <td>{index + 1} </td>
                                <td> {obj.client_details && obj.client_details.company_name} </td>
                                <td>{obj.added_by} </td>
                                <td>{obj.job_title} </td>
                                <td>{obj.open_positions} </td>
                                <td>{obj.job_location} </td>
                                <td> {obj.package_min && Math.round(obj.package_min)}
                                    {obj.package_max && obj.package_min && ' - '}
                                    {obj.package_max && Math.round(obj.package_max)} </td>
                                <td> {obj.experience_min && Math.round(obj.experience_min)}
                                    {obj.experience_max && obj.experience_min && ' - '}
                                    {obj.experience_max && Math.round(obj.experience_max)}  </td>
                                <td>{obj.qualification}</td>
                                <td className=' ' > {obj.required_skills} </td>
                                <td> {obj.hiring_start_date && changeDateYear(obj.hiring_start_date)}
                                    {obj.hiring_end_date && obj.hiring_start_date && ' - '}
                                    {obj.hiring_end_date && changeDateYear(obj.hiring_end_date)}  </td>
                                <td>
                                    {obj.added_on && convertToReadableDateTime(obj.added_on) }
                                </td>
                            </tr>
                        ))
                    }
                </table>
            </main>

        </div >
    )
}

export default ClientRequirmentTable