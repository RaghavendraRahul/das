import React, { useEffect, useState } from 'react'
import InputFieldform from '../../Components/SettingComponent/InputFieldform';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { port } from '../../App';
import DustbinIcon from '../../SVG/DustbinIcon';
import { toast } from 'react-toastify';

const JFReference = ({ id, data, page }) => {
    let navigate = useNavigate()
    const [references, setReferences] = useState([
        { person_name: '', relation: '',  phone: '', email: '', }
    ]);
    let handleChange = (e, index) => {
        let { name, value } = e.target
        let newarry = [...references]
        newarry[index][name] = value
        setReferences(newarry)
    }
    let addColumn = () => {
        setReferences((prev) => [
            ...prev,
            { person_name: '', relation: '',  phone: '', email: '', }
        ])
    }
    let saveData = () => {

        references.forEach((obj) => {
            if (obj.id) {
                update(obj)
            }
            else {
                axios.post(`${port}/root/ems/candidate-reference/${data.id}/`, [obj]).then((response) => {
                    console.log(response.data);
                }).catch((error) => {
                    console.log(error);
                })
            }
        })
    }
    let update = (obj) => {
        axios.patch(`${port}/root/ems/update-candidate-reference/${obj.id}/`, obj).then((response) => {
            getData()
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let getData = () => {
        if (data) {
            axios.get(`${port}/root/ems/candidate-reference/${data.id}/`).then((response) => {
                console.log(response.data);
                if (response.data && response.data.length) {
                    setReferences(response.data)
                }
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let deleteData = (obj) => {
        axios.delete(`${port}/root/ems/update-candidate-reference/${obj.id}/`).then((response) => {
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
        <div className='inputbg p-3 rounded '>
            <h5 className='mt-2 heading' style={{ color: 'rgb(76,53,117)' }}>REFERENCE : NAME & ADDRESS OF AT LEAST TWO REFERENCES NOT RELATED TO YOU</h5>
            {
                references && references.map((obj, index) => (
                    <main className='p-3 my-2 row bg-white rounded '>
                        <InputFieldform disabled={page} label="Name" placeholder={'Name'} type='text' value={obj.person_name}
                            handleChange={handleChange} index={index} name='person_name' />
                        <InputFieldform disabled={page} label="Mobile" placeholder={'Mobile'} type='text' value={obj.phone}
                            handleChange={handleChange} index={index} limit={9999999999} name='phone' />
                        <InputFieldform disabled={page} label="Email Id" type='email' placeholder='Email' value={obj.email}
                            handleChange={handleChange} index={index} name='email' />
                        <InputFieldform disabled={page} label="Designation" placeholder='Relation' type='text' value={obj.relation}
                            handleChange={handleChange} index={index} name='relation' />
                        {/* <InputFieldform disabled={page} label="Address Line 1" type='text' placeholder='23/4 Sri Venkateswara,' value={obj.address}
                            handleChange={handleChange} index={index} name='address' /> */}
                        {/* <InputFieldform disabled={page} label="City" placeholder='City' type='text' value={obj.city}
                            handleChange={handleChange} index={index} name='city' /> */}
                        {/* <InputFieldform disabled={page} label="State" placeholder='State' type='text' value={obj.state}
                            handleChange={handleChange} index={index} name='state' /> */}
                        {/* <InputFieldform disabled={page} label="Country" placeholder='Country' type='text' value={obj.country}
                            handleChange={handleChange} index={index} name='country' /> */}
                        {/* <InputFieldform disabled={page} label="Pincode" placeholder='627006' type='text' value={obj.pincode}
                            handleChange={handleChange} index={index} limit={999999} name='pincode' /> */}
                        <section className='col-12 flex '>
                            {references && references.length > 1 && !page &&
                                <button onClick={() => deleteData(obj)} className='ms-auto '>
                                    <DustbinIcon />
                                </button>}
                        </section>
                    </main>
                ))
            }
            {!page && <button onClick={addColumn}
                className='p-2 flex ms-auto rounded bg-blue-500 text-white ' >
                Add
            </button>}
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => {
                    saveData();
                    navigate(`/Employeeallform/${id}/emergency_form`)
                }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => {
                    if (references.length >= 2) {
                        saveData();
                    } else {
                        toast.warning('Least have to add 2 Reference')
                        return
                    }
                    navigate(`/Employeeallform/${id}/exp_form`)
                }}
                    className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFReference