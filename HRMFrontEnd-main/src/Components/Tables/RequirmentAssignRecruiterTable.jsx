import React, { useEffect } from 'react'
import LoadingData from '../MiniComponent/LoadingData';

const RequirmentAssignRecruiterTable = ({ data, loading, css }) => {
    useEffect(() => {
        console.log(data, 'requirement');

    }, [])
    return (
        <div>
            <main className={` table-responsive tablebg ${css ? css : 'h-[50vh]'} `} >
                <table className='w-full ' >
                    <tr>
                        <th>SI NO </th>
                        <th>Recruiter Name  </th>
                        <th>Position Allocated </th>
                        <th>Candidate Assigned </th>
                        <th>Position Closed </th>
                    </tr>
                    {
                        !loading && data && data.map((obj, index) => (
                            <tr>
                                <td>{index + 1} </td>
                                <td>{obj?.recruiter?.Name} </td>
                                <td>{obj.position_count} </td>
                                <td> {obj.candidate_assigned} </td>
                                <td>{obj.closed_pos_count} </td>
                            </tr>
                        ))
                    }
                </table>
                {
                    loading && <LoadingData />
                }
            </main>
        </div>
    )
}

export default RequirmentAssignRecruiterTable