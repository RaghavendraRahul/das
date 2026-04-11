import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { port } from '../../App'

const STtable = () => {
    let navigate = useNavigate()
    let [templates, setTemplates] = useState()
    let getTemplate = () => {
        axios.get(`${port}/root/pms/SalaryTemplates`).then((response) => {
            setTemplates(response.data)
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getTemplate()
    }, [])
    return (
        <div>
            <button onClick={() => navigate('/payroll/salary-templates/template')}
             className='bluebtn w-36 text-center justify-center text-white p-2 rounded text-sm ms-auto flex my-3 '>
                Create New
            </button>
            <main className='table-responsive tablebg rounded ' >
                <table className='w-full ' >
                    <tr>
                        <th>
                            Template name
                        </th>
                        <th>Description </th>
                        {/* <th>Status </th> */}
                    </tr>
                    {
                        templates && templates.map((obj) => (
                            <tr>
                                <td onClick={() => navigate(`/payroll/salary-templates/template/${obj.id}`)}
                                    className='text-blue-600 cursor-pointer' > {obj.template_name} </td>
                                <td> {obj.description} </td>
                                {/* <td className={` text-green-600 `}> Active </td> */}
                            </tr>
                        ))
                    }
                </table>
            </main>

        </div>
    )
}

export default STtable