import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../../Components/Topnav'
import { HrmStore } from '../../Context/HrmContext'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'
import LoadingData from '../../Components/MiniComponent/LoadingData'

const ClientCreation = ({ id, page, }) => {
    let [loading, setLoading] = useState()
    let { setTopNav } = useContext(HrmStore)
    let { setActiveSetting } = useContext(HrmStore)
    let [formObj, setFormObj] = useState({
        client_name: '',
        client_email: '',
        alternative_emails: '',
        client_phone: null,
        alternative_phone: null,
        gst_number: '',
        company_address: '',
        client_type: '',
        company_name: '',
        terms_and_conditions: false,
        document_proof: '',
        registered_on: '',
        verified_on: '',
        client_status: ''
    })
    let handleformObj = (e) => {
        let { name, value, files } = e.target
        if (name == 'document_proof')
            value = files[0]
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let { activePage, setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('client')
        setActiveSetting('client')
        if (page == 'req')
            setTopNav('recuirter')
        else if (id)
            setTopNav('client')
        else
            setTopNav('addclient')
    }, [page, id])
    let addClient = () => {
        let formData = new FormData()
        Object.keys(formObj).forEach(key => {
            formData.append(key, formObj[key])
        })
        setLoading(true)
        axios.post(`${port}/root/cms/clients`, formData).then((response) => {
            console.log(response.data);
            toast.success('Client added successfully')
            setFormObj({
                client_name: '',
                client_email: '',
                alternative_emails: '',
                client_phone: null,
                alternative_phone: null,
                gst_number: '',
                company_address: '',
                client_type: '',
                terms_and_conditions: false,
                document_proof: '',
                registered_on: '',
                company_name: '',
                verified_on: '',
                client_status: ''
            })
            setLoading(false)
        }).catch((error) => {
            console.log(error);
            setLoading(false)
            toast.error('Error occured')
        })
    }
    let navigate = useNavigate()
    let getParticularClientDetails = () => {
        setLoading('getting')
        axios.get(`${port}/root/cms/clients?id=${id}`).then((response) => {
            setLoading(false)
            setFormObj(response.data)
        }).catch((error) => {
            setLoading(false)
            console.log(error);
        })
    }
    let updateClientDetails = () => {
        setLoading(true)
        delete formObj.client_id
        axios.patch(`${port}/root/cms/clients?id=${id}`, formObj).then((response) => {
            console.log(response.data);
            toast.success('Update successfully')
            setLoading(false)
        }).catch((error) => {
            console.log(error, 'updateError');
            toast.error('Error occured')
            setLoading(false)

        })
    }
    useEffect(() => {
        if (id)
            getParticularClientDetails()
    }, [id])
    return (
        <div className='px-2 py-3' >
            {!page && <Topnav />}
            {!page && <button onClick={() => navigate(`/client`)} className='p-2 text-sm bg-black text-white rounded ' >
                Back  </button>}
            <h4 className='text-center poppins ' >Client {id ? "Details" : "Creation"} </h4>
            {loading == 'getting' ? <LoadingData /> :
                <main className='my-2 rounded bg-white row p-2  ' >
                    <InputFieldform label="Client Name" name='client_name' handleChange={handleformObj}
                        value={formObj.client_name} />
                    <InputFieldform label="Client Mail" name='client_email' handleChange={handleformObj}
                        value={formObj.client_email} />
                    <InputFieldform label="Alternative Mail" name='alternative_emails' handleChange={handleformObj}
                        value={formObj.alternative_emails} />
                    <InputFieldform label="Client Phone" name='client_phone' handleChange={handleformObj}
                        value={formObj.client_phone} />
                    <InputFieldform label="Alternative Phone" name='alternative_phone' handleChange={handleformObj}
                        value={formObj.alternative_phone} />
                    <InputFieldform label="Company Name" name='company_name' handleChange={handleformObj}
                        value={formObj.company_name} />
                    <InputFieldform label="GST Number" name='gst_number' handleChange={handleformObj}
                        value={formObj.gst_number} />
                    <InputFieldform label="Client Type" optionObj={[{ value: 'paid', label: "Paid" }, { value: 'unpaid', label: "Unpaid" }]} name='client_type' handleChange={handleformObj}
                        value={formObj.client_type} />
                    {/* File upload */}
                    {!id && <div className=' col-md-6 col-lg-4 ' >
                        <label htmlFor=""> Agreement Ducumentation</label>
                        <input type="file" name='document_proof' onChange={handleformObj} className='p-2 rounded bgclr w-full outline-none my-2  ' />
                    </div>}
                    <InputFieldform label='Company Address ' value={formObj.company_address} name='company_address'
                        handleChange={handleformObj} type='textarea' />

                    <div className='col-12 ' >
                        <div className='text-sm flex gap-2 items-center ' >
                            <input type="checkbox" onChange={() => setFormObj((prev) => ({
                                ...prev,
                                terms_and_conditions: !formObj.terms_and_conditions
                            }))} checked={formObj.terms_and_conditions} id='tac' className=' ' />
                            <label htmlFor="tac"> I hereby agree for the terms & conditions. </label>

                        </div>
                        {!id && <button onClick={addClient} disabled={loading} className=' flex ms-auto p-2 my-2 bg-blue-500 text-white text-sm rounded ' >
                            {loading ? "Loading... " : " Add client"}
                        </button>}
                        {id && <button onClick={updateClientDetails} disabled={loading} className=' flex ms-auto p-2 my-2 bg-blue-500 text-white text-sm rounded ' >
                            {loading ? "Loading... " : " Update client"}
                        </button>}

                    </div>
                </main>}

        </div>
    )
}

export default ClientCreation