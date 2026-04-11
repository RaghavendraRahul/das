import React, { useEffect, useState } from 'react'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import DustbinIcon from '../../SVG/DustbinIcon'
import axios from 'axios'
import { port } from '../../App'
import { useNavigate } from 'react-router-dom'

const JFEducationForm = ({ data, page, id }) => {
    let [formobj, setFormObj] = useState([{ Qualification: '', University: '', year_of_passout: '', Persentage: '', Major_Subject: '' }])
    let handleInputChange = (index, e) => {
        let { name, value } = e.target
        let newarry = [...formobj]
        newarry[index][name] = value
        setFormObj(newarry)
    }
    let navigate = useNavigate()
    let addColumn = () => {
        setFormObj((prev) => [
            ...prev,
            { Qualification: '', University: '', year_of_passout: '', Persentage: '', Major_Subject: '' }
        ])
    }
    let saveForm = () => {
        formobj.forEach((obj) => {
            if (obj.id) {
                updateForm(obj)
            }
            else {
                axios.post(`${port}/root/ems/employee-education/${data.id}/`, [obj]).then((res) => {
                    console.log("EMPLOYEE_Edu_RES", res.data);
                    getDetails()
                }).catch((err) => {
                    console.log("EMPLOYEE_INFORMATION_ERR", err.data);
                })
            }
        })
    }
    let updateForm = (obj) => {
        axios.patch(`${port}/root/ems/update-employee-education/${obj.id}/`, obj).then((response) => {
            console.log(response.data);
            getDetails()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getDetails = () => {
        if (data) {
            axios.get(`${port}/root/ems/employee-education/${data.id}/`).then((response) => {
                console.log(response.data);
                if (response.data && response.data.length > 0) {
                    setFormObj(response.data)
                }
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let deleteMethod = (obj) => {
        axios.delete(`${port}/root/ems/update-employee-education/${obj.id}/`).then((response) => {
            console.log(response.data);
            getDetails()
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getDetails()
    }, [data])
    return (
        <div className='inputbg p-3 rounded '>
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>EDUCATION DETAILS</h5>
            <main className='bg-white p-3'>

                <section className='table-responsive rounded tablebg'>
                    <table class="w-full ">
                        <thead>
                            <tr>
                                <th>SI No</th>
                                <th>Qulification</th>
                                <th>University / Institute</th>
                                <th>Year Of Passout</th>
                                <th>Marks %</th>
                                <th>Major Subject</th>
                                {formobj.length > 1 && !page && <th>Action </th>}
                            </tr>
                        </thead>
                        <tbody>
                            {formobj && formobj.map((qualification, index) => (
                                <tr key={index}>
                                    <td>{index + 1}</td>
                                    <td><input disabled={page} type="text" placeholder='B.E' name="Qualification" value={qualification.Qualification} onChange={(e) => handleInputChange(index, e)}
                                        className="p-2 bg-transparent outline-none text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" placeholder='MGR University ' name="University" value={qualification.University} onChange={(e) => handleInputChange(index, e)}
                                        className="p-2 bg-transparent outline-none text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="date" name="year_of_passout" value={qualification.year_of_passout} onChange={(e) => handleInputChange(index, e)}
                                        className="p-2 bg-transparent outline-none text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" name="Persentage" value={qualification.Persentage} placeholder='80'
                                        onChange={(e) => { if (e.target.value >= 0 && e.target.value < 101) { handleInputChange(index, e) } }}
                                        className="p-2 bg-transparent outline-none text-center border-0 shadow-none" /></td>
                                    <td><input disabled={page} type="text" placeholder='Chemical ' name="Major_Subject" value={qualification.Major_Subject} onChange={(e) => handleInputChange(index, e)}
                                        className="p-2 bg-transparent outline-none text-center border-0 shadow-none" /></td>
                                    {formobj.length > 1 && !page &&
                                        <td>
                                            <button disabled={page} onClick={() => deleteMethod(qualification)}>
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
                <button onClick={() => { saveForm(); navigate(`/Employeeallform/${id}/`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveForm(); navigate(`/Employeeallform/${id}/fm-form`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFEducationForm