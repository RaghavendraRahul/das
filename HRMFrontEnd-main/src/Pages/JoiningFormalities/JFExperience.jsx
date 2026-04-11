import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DustbinIcon from '../../SVG/DustbinIcon'
import axios from 'axios'
import { port } from '../../App'

const JFExperience = ({ id, data, page }) => {
    let navigate = useNavigate()
    let [formObj, setFormobj] = useState([
        { person_name: '', at_the_time_of_joining: '', from_date: '', gross_salary_drawn: '', reason_for_leaving: '', last_possition_held: '', to_date: '', job_responsibility: '', immediate_superior_designation: '', relation: '', address: '', phone: '', city: '', country: '', email: '', state: '' }
    ])
    let handleChange = (index, e) => {
        let { name, value } = e.target
        let newarray = [...formObj]
        newarray[index][name] = value
        setFormobj(newarray)
    }
    let addColumn = () => {
        setFormobj((prev) => [
            ...prev,
            { person_name: '', at_the_time_of_joining: '', from_date: '', gross_salary_drawn: '', reason_for_leaving: '', last_possition_held: '', to_date: '', job_responsibility: '', relation: '', immediate_superior_designation: '', address: '', phone: '', city: '', country: '', email: '', state: '' }
        ])
    }

    let saveData = () => {
        formObj.forEach((obj) => {
            if (obj.id) {
                updateData(obj)
            }
            else {
                axios.post(`${port}/root/ems/experience/${data.id}/`, [obj]).then((response) => {
                    getData()
                    console.log("post successfull ", response.data);
                }).catch((error) => {
                    console.log(error);
                })
            }
        })
    }
    let deleteData = (obj) => {
        axios.delete(`${port}/root/ems/update-experience/${obj.id}/`).then((response) => {
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let updateData = (obj) => {
        axios.patch(`${port}/root/ems/update-experience/${obj.id}/`, obj).then((response) => {
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/experience/${data.id}/`).then((response) => {
                if (response.data && response.data.length > 0) { setFormobj(response.data) }
                console.log(response.data);
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    useEffect(() => {
        getData()
    }, [data])
    return (
        <div className='inputbg p-3 rounded ' >
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EXPERIENCE (CHRONOLOGICAL ORDER EXCLUDING LAST POSITION)</h5>
            <main className='bg-white p-3 rounded '>
                <section className='tablebg table-responsive rounded ' >
                    <table className='w-full '>
                        <thead>
                            <tr>
                                <th>SI NO </th>
                                <th rowSpan="2" className='text-center'>Organisation</th>
                                <th>From</th>
                                <th className='text-center'>To</th>
                                <th className='text-center'>Last Postion Held</th>
                                <th className='text-center'>At TheTime Of Joining</th>
                                <th rowSpan="2" className='text-center'>Job Responsibility</th>
                                <th rowSpan="2" className='text-center'>Designation Of Immediate Superior</th>
                                <th rowSpan="2" className='text-center'>Annual CTC </th>
                                <th rowSpan="2" className='text-center'>Reson For Leaving</th>
                                {formObj.length > 1 && !page && <th>Action  </th>}
                            </tr>


                        </thead>
                        <tbody>
                            {formObj && formObj.map((employment, index) => (
                                <tr key={index}>
                                    <td>{index + 1} </td>
                                    <td><input disabled={page} type="text" name="organisation"
                                        value={employment.organisation} onChange={(e) => handleChange(index, e)} placeholder='yzw company' className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="date" name="from_date"
                                        value={employment.from_date} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="date" name="to_date"
                                        value={employment.to_date} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="last_possition_held" placeholder='senior Developer'
                                        value={employment.last_possition_held} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="at_the_time_of_joining" placeholder='junior Developer'
                                        value={employment.at_the_time_of_joining} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="job_responsibility" placeholder='SRS plaining for the project , Creating the layout'
                                        value={employment.job_responsibility} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="immediate_superior_designation" placeholder='Manager'
                                        value={employment.immediate_superior_designation} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="gross_salary_drawn" placeholder='500000 '
                                        value={employment.gross_salary_drawn}
                                        onChange={(e) => {
                                            if (e.target.value >= 0) handleChange(index, e)
                                        }}
                                        className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    <td><input disabled={page} type="text" name="reason_for_leaving" placeholder='reason...'
                                        value={employment.reason_for_leaving} onChange={(e) => handleChange(index, e)} className="p-2 rounded bgclr outline-none shadow-none border-0" /></td>
                                    {formObj.length > 1 && !page && <td>
                                        <button className='' onClick={() => deleteData(employment)} >
                                            <DustbinIcon />
                                        </button>
                                    </td>}
                                </tr>
                            ))}

                        </tbody>
                    </table>
                </section>
                {!page && <button onClick={addColumn}
                    className='p-2 my-2 flex ms-auto rounded bg-blue-500 text-white ' >
                    Add
                </button>}
            </main>

            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/ref_form`) }}
                    className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/last_position_held`) }}
                    className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFExperience