import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'

const JFDeclaration = ({ id, page, data }) => {
    let navigate = useNavigate()
    let { timeValidate } = useContext(HrmStore)
    let [image, setImage] = useState()
    let [formObj, setFormObj] = useState({
        EMP_Information: data.id,
        name: '',
        date: timeValidate(),
        place: '',
        signature: null
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        if (name == 'signature') {
            value = files[0]
            setImage(URL.createObjectURL(files[0]));
            console.log(files[0]);
        }
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let saveData = () => {
        // alert('method')
        if (!data || !data.id) {
            toast.error('Employee information not loaded yet. Please wait...');
            return;
        }
        if (formObj.id) {
            // formObj('hellow')
            UpdateData()
        }
        else {
            // alert('save')
            const formData = new FormData()
            // formData.append('signature', formObj.signature)
            formData.append('date', timeValidate())
            formData.append('name', formObj.name)
            formData.append('place', formObj.place)

            axios.post(`${port}/root/ems/declaration/${data.id || id }/`, formData).then((response) => {
                console.log(response.data);
                // toast.success('jerold')
                getData()
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let UpdateData = () => {
        const formData = new FormData()
        // formData.append('signature', formObj.signature)
        formData.append('date', timeValidate())
        formData.append('name', formObj.name)
        formData.append('place', formObj.place)
        axios.patch(`${port}/root/ems/update-declaration/${formObj.id}/`, formData).then((response) => {
            console.log(response.data);
            getData()
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/declaration/${data.id}/`).then((response) => {
                console.log("get", response.data);
                setFormObj(response.data)
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    useEffect(() => {
        getData()
    }, [data])
    return (
        <div className='bg-white rounded p-3 ' >
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}>DECLARATION</h5>
            <main className='border-1 border-slate-300 p-3 rounded'>
                <p className='text-lg '>I declare that the information given, herein above, is true & correct to the best of my knowledge & belief & no material information has been concealed. I understand that the above information in found false or incorrect, at any time during the course of my employment, my services will be terminated forthwith without any notice or compensation.
                </p>
                <section className=''>
                    <div className='my-3'>
                        Name :
                        <input disabled={page} type="text" value={formObj.name} name='name' onChange={handleChange} className='outline-none w-52 bg-transparent mx-2 border-bottom px-1 border-slate-500 ' />
                    </div>
                    <div className='my-3'>
                        Date :
                        <input disabled={page} type="date" value={formObj.date} name='date' className='outline-none w-52 bg-transparent mx-2 border-bottom px-1 border-slate-500 ' />
                    </div>
                    <div className='my-3'>
                        Place :
                        <input disabled={page} type="text" value={formObj.place} name='place' onChange={handleChange} className='outline-none w-52 bg-transparent mx-2 border-bottom px-1 border-slate-500 ' />
                    </div>
                    <div className='flex flex-col ms-auto items-center w-fit '>
                        {/* <label htmlFor="signature">
                            {typeof formObj.signature == 'string' ?
                                <img className='w-32 ' src={formObj.signature} alt="signature" />
                                : !image ? <span className=' text-center text-slate-400 text-sm '>
                                    upload a image of signature</span>
                                    : <img src={image} className='w-32 ' alt="image" />}

                        </label>
                        <input disabled={page} type="file" id='signature' name='signature' onChange={handleChange} accept="image/*"
                            placeholder='write a name' className='text-center 
                         outline-none hidden w-52 bg-transparent mx-2 border-bottom px-1 border-slate-500 ' /> */}
                        <p className='text-center mb-0 '>{formObj.name} </p>
                        <p className='p-2 text-xl fw-semibold '>Employee Signature </p>
                    </div>


                </section>

            </main>

            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => {
                    saveData();
                    navigate(`/Employeeallform/${id}/document`)
                }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                {
                    // typeof id == 'number' ? <button
                    !isNaN(id) ? <button
                        onClick={() => {
                            saveData();
                            navigate(`/preview/${id}/`)
                        }}
                        className='p-2 bg-red-600 text-white rounded'>
                        Preview
                    </button> :
                        <button className='p-2 bg-blue-600 text-white rounded' onClick={() => {
                            saveData();
                            navigate(`/dash/employee/${id}`)
                        }} >
                            Employee Page
                        </button>
                }
            </section>}

        </div>
    )
}

export default JFDeclaration