import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DustbinIcon from '../../SVG/DustbinIcon'
import axios from 'axios'
import { port } from '../../App'

const JFFamilyDetails = ({ id, data, page }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState([{ name: '', dob: '', relation: '', age: '', profession: '', gender: '', blood_group: '' }])
    let handleInputChange = (index, e) => {
        let { name, value } = e.target
        let newarry = [...formObj]
        newarry[index][name] = value
        setFormObj(newarry)
    }
    let saveData = () => {
        formObj.forEach((obj) => {
            if (obj.id) {
                update(obj)
            }
            else {
                axios.post(`${port}/root/ems/family-details/${data.id}/`, [obj]).then((response) => {
                    console.log(response.data);
                }).catch((error) => {
                    console.log(error);
                })
            }
        })
    }
    let update = async (obj) => {
        console.log(obj);
        await axios.patch(`${port}/root/ems/update-family-details/${obj.id}/`, obj).then((response) => {
            getData()
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/family-details/${data.id}/`).then((response) => {
                console.log(response.data);
                if (response.data && response.data.length > 0) {
                    setFormObj(response.data)
                }
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let addColumn = () => {
        setFormObj((prev) => [
            ...prev,
            { name: '', dob: '', relation: '', age: '', profession: '', gender: '', blood_group: '' }
        ])
    }
    let deleteData = async (obj) => {
        await axios.delete(`${port}/root/ems/update-family-details/${obj.id}/`, obj).then((response) => {
            getData()
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getData()
    }, [data])
    return (
        <div className='inputbg p-3 rounded ' >
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>FAMILY DETAILS</h5>
            <main className='p-3 rounded '>

                <section className='table-responsive tablebg rounded '>
                    <table className='w-full '>
                        <thead>
                            <tr>
                                <th>SI no</th>

                                <th>Relation</th>
                                <th>Name</th>
                                <th>DOB</th>
                                <th>Age </th>
                                <th>Gender </th>
                                <th>Blood Group </th>
                                <th>Occupation</th>
                                {formObj.length > 1 && !page && <th>
                                    Action
                                </th>}

                            </tr>
                        </thead>
                        <tbody>
                            {formObj && formObj.map((family_details, index) => (
                                <tr key={index}>
                                    <td>{index + 1} </td>
                                    <td><input disabled={page} type="text" placeholder='Father' name="relation" value={family_details.relation} onChange={(e) => handleInputChange(index, e)} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>

                                    <td><input disabled={page} type="text" name="name" value={family_details.name} onChange={(e) => handleInputChange(index, e)}
                                        placeholder='Hari' className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="date" name="dob" value={family_details.dob} onChange={(e) => handleInputChange(index, e)} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="number" placeholder='43' name="age" value={family_details.age} onChange={(e) => { if (e.target.value >= 0) { handleInputChange(index, e) } }} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" placeholder='Male' name="gender" value={family_details.gender} onChange={(e) => handleInputChange(index, e)} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" placeholder='A+' name="blood_group" value={family_details.blood_group} onChange={(e) => handleInputChange(index, e)} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" placeholder='Manager' name="profession" value={family_details.profession} onChange={(e) => handleInputChange(index, e)} className="outline-none p-2 bg-transparent text-center border-0 shadow-none" /></td>
                                    {formObj.length > 1 && !page && <td>
                                        <button className='' onClick={() => deleteData(family_details)} >
                                            <DustbinIcon />
                                        </button>
                                    </td>}
                                </tr>
                            ))}


                        </tbody>
                    </table>

                </section>
                {!page && <button onClick={addColumn} className='p-2 my-2 flex ms-auto rounded bg-blue-600 text-white  '>
                    Add
                </button>}
            </main>

            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/ed-form`) }} className='p-2 bg-slate-400 rounded text-white '>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/med`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}

        </div>
    )
}

export default JFFamilyDetails