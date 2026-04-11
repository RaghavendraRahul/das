import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { HrmStore } from '../../Context/HrmContext'
import DustbinIcon from '../../SVG/DustbinIcon'

const JFDocumentSubmitted = ({ id, page, data }) => {
    let navigate = useNavigate()
    let { timeValidate } = useContext(HrmStore)
    let [formobj, setFormObj] = useState([
        { Document: null, submitted: null, will_submit_date: null, }
    ])
    let addColumn = () => {
        setFormObj((prev) => [
            ...prev,
            { Document: null, submitted: null, will_submit_date: null }
        ])
    }
    let handleChange = (e, index) => {
        let { name, value } = e.target
        if (value == 'true')
            value = true
        if (value == 'false')
            value = false
        let newArry = [...formobj]
        newArry[index][name] = value
        setFormObj(newArry)
    }
    let saveData = () => {

        formobj.forEach((obj) => {
            if (obj.id) {
                update(obj)
            }
            else {
                axios.post(`${port}/root/ems/Documents/${data.id}/`, [obj]).then((response) => {
                    console.log(response.data);
                    getData()
                }).catch((error) => {
                    console.log(error);
                })
            }
        })
    }
    let update = (obj) => {
        axios.patch(`${port}/root/ems/update-Documents/${obj.id}/`, obj).then((response) => {
            getData()
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/Documents/${data.id}/`).then((response) => {
                console.log(response.data);
                if (response.data && response.data.length) {
                    setFormObj(response.data)
                }
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let deleteData = (obj) => {
        axios.delete(`${port}/root/ems/update-Documents/${obj.id}/`).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getData()
    }, [data])
    return (
        <div className='inputbg p-3 rounded ' >
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>Documents Submited  </h5>
            <main className='p-3 bg-white rounded'>
                <section className='tablebg rounded table-responsive '>
                    <table className='w-full ' >
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Documents</th>
                                {/* <th>Submitted</th> */}
                                <th> Submit Date</th>
                                {formobj.length > 5 && <th>Action  </th>}

                            </tr>
                        </thead>
                        <tbody>
                            {formobj && formobj.map((document, index) => (
                                <tr key={index}>
                                    <td>{index + 1}</td>
                                    <td><input disabled={page} type="text" placeholder='Document' name="Document" value={document.Document}
                                        onChange={(e) => handleChange(e, index)} className="p-2 bg-transparent outline-none border-0 shadow-none" />
                                    </td>
                                    {/* <td>
                                        <select disabled={page} className='p-2 block rounded bg-transparent w-full outline-none shadow-none'
                                            name="submitted" value={document.submitted} onChange={(e) => handleChange(e, index)}
                                            id="">
                                            <option value="">Select</option>
                                            <option value={true} > Yes </option>
                                            <option value={false} > No </option>

                                        </select>

                                    
                                    </td> */}
                                    <td className='w-[200px] '>
                                        {!document.submitted ?
                                            <input disabled={page} type="date" placeholder='Date' name="will_submit_date"
                                                value={document.will_submit_date}
                                                onChange={(e) => {
                                                    if (e.target.value >= timeValidate())
                                                        handleChange(e, index)
                                                }}
                                                className="p-2 w-[200px] bg-transparent outline-none border-0 shadow-none" />
                                            :
                                            <p className='mb-0 w-[200px] '> {document.submitted_date &&document.submitted_date.slice(0,10) } </p>
                                        }
                                    </td>
                                    {formobj.length > 5 && document.id && <td>
                                        <button disabled={page} className='' onClick={() => deleteData(document)} >
                                            <DustbinIcon />
                                        </button>
                                    </td>}
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </section>
                {/* <button onClick={addColumn} disabled={page} className='p-2 rounded bg-blue-600 text-white my-2 flex ms-auto'>
                    Add
                </button> */}
            </main>


            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => {
                    saveData();
                    navigate(`/Employeeallform/${id}/attachment`)
                }
                } className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => {
                    // if (formobj.length < 5) {
                    //     toast.warning('Enter the submission report for all 5 documents')
                    //     return
                    // }
                    saveData();
                    navigate(`/Employeeallform/${id}/declaration`)
                }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFDocumentSubmitted