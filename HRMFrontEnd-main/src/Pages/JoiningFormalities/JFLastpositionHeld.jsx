import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const JFLastpositionHeld = ({ id, page, data }) => {
    let navigate = useNavigate()
    let [formObj, setFormObj] = useState({
        EMP_Information: '',
        organisation: '',
        designation: '',
        doj: '',
        address: '',
        repoting_to_name: '',
        repoting_to_designation: '',
        repoting_to_email: '',
        repoting_to_phone: '',
        gross_salary_per_month: 0,

        basic: 0,
        DA: 0,
        HRA: 0,
        LTA: 0,
        medical: 0,
        conveyance: 0,
        others: 0,
        total: 0,
        provident_fund: 0,
        gratuity: 0,
        non_cash_others: 0,
        non_cash_total: 0
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    useEffect(() => {
        let total = Number(formObj.gratuity) + Number(formObj.non_cash_others) + Number(formObj.provident_fund)
        setFormObj((prev) => ({
            ...prev,
            non_cash_total: total
        }))

    }, [formObj.gratuity, formObj.non_cash_others, formObj.provident_fund])
    useEffect(() => {
        // alert('hellow')
        let total = Number(formObj.DA) + Number(formObj.HRA) + Number(formObj.LTA) + Number(formObj.basic) + Number(formObj.conveyance) + Number(formObj.medical) + Number(formObj.others)
        setFormObj((prev) => ({
            ...prev,
            total: total
        }))
    }, [formObj.DA, formObj.HRA, formObj.LTA, formObj.basic, formObj.conveyance, formObj.medical, formObj.others])


    let getData = () => {
        if (data.id) {
            axios.get(`${port}/root/ems/last-position-held/${data.id}/`).then((response) => {
                if (response.data.EMP_Information) { setFormObj(response.data) }
                console.log(response.data);
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let saveData = () => {
        if (formObj.id)
            updateData()
        else
            axios.post(`${port}/root/ems/last-position-held/${data.id}/`, formObj).then((response) => {
                getData()
                console.log(response.data);
            }).catch((error) => {
                console.log(error);
            })
    }
    let updateData = () => {
        axios.patch(`${port}/root/ems/update-last-position-held/${formObj.id}/`, formObj).then((response) => {
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
        <div className='inputbg min-h-[98vh] p-3 rounded '>
            <h5 className='mt-2 uppercase heading' style={{ color: 'rgb(76,53,117)' }}> Last Position held details </h5>
            <main className=' bg-white row rounded p-3'>
                <InputFieldform disabled={page} label="Organization" value={formObj.organisation} handleChange={handleChange}
                    name='organisation' placeholder='YWQ Pvt LTD' type='text' />
                <InputFieldform disabled={page} label="Designation" value={formObj.designation} handleChange={handleChange}
                    name='designation' placeholder='' type='text' />
                <InputFieldform disabled={page} label="Date of Join" value={formObj.doj} handleChange={handleChange}
                    name='doj' type='date' />

                <InputFieldform disabled={page} placeholder='Hari' label="Reporting Person Name" value={formObj.repoting_to_name} handleChange={handleChange}
                    name='repoting_to_name' type='text' />
                <InputFieldform disabled={page} placeholder='' label="Reporting Person Designation" value={formObj.repoting_to_designation} handleChange={handleChange}
                    name='repoting_to_designation' type='text' />
                <InputFieldform disabled={page} placeholder='' label="Reporting Person Email" value={formObj.repoting_to_email} handleChange={handleChange}
                    name='repoting_to_email' type='text' />
                <InputFieldform disabled={page} placeholder='' label="Reporting Person Phone" value={formObj.repoting_to_phone} handleChange={handleChange}
                    name='repoting_to_phone' type='text' />
                <InputFieldform disabled={page} limit={999999999} placeholder='' label="Annual CTC" value={formObj.gross_salary_per_month} handleChange={handleChange}
                    name='gross_salary_per_month' type='text' />
                <InputFieldform disabled={page} placeholder='' label="Address" value={formObj.address} handleChange={handleChange}
                    name='address' type='textarea' />
                {/* <h5 className='mt-2 heading col-12' style={{ color: 'rgb(76,53,117)' }}>Cash Benifits</h5>

                <InputFieldform disabled={page} placeholder='' label="Basic" value={formObj.basic} handleChange={handleChange}
                    name='basic' type='text' size='col-sm-3 col-lg-2' limit={999999999} />
                <InputFieldform disabled={page} placeholder='' label="DA" value={formObj.DA} handleChange={handleChange}
                    name='DA' size='col-sm-3 col-lg-2' limit={9999999} type='text' />

                <InputFieldform disabled={page} placeholder='' label="HRA" value={formObj.HRA} handleChange={handleChange}
                    name='HRA' size='col-sm-3 col-lg-2' limit={9999999} type='text' />

                <InputFieldform disabled={page} placeholder='' label="LTA" value={formObj.LTA} handleChange={handleChange}
                    name='LTA' type='text' size='col-sm-3 col-lg-2' limit={999999999} />

                <InputFieldform disabled={page} placeholder='' label="Medical" value={formObj.medical} handleChange={handleChange}
                    name='medical' size='col-sm-3 col-lg-2' limit={9999999} type='text' />

                <InputFieldform disabled={page} placeholder='' label="Canveyance" value={formObj.conveyance} handleChange={handleChange}
                    name='conveyance' size='col-sm-3 col-lg-2' limit={9999999} type='text' />

                <InputFieldform disabled={page} placeholder='' label="Others" value={formObj.others} handleChange={handleChange}
                    name='others' size='col-sm-3 col-lg-2' limit={9999999} type='text' />

                <div className={` col-md-3 col-lg-2  mb-3`}>
                    <label htmlFor="lastName" className="form-label">Total</label>
                    <input type='text' className="p-2 block rounded bgclr w-full outline-none shadow-none"
                        value={formObj.total}
                        disabled id="LastName" name='total' />
                </div>
                <h5 className='mt-2 heading col-12' style={{ color: 'rgb(76,53,117)' }}>Non Cash Benifits</h5>
                <InputFieldform disabled={page} placeholder='' label="Provident Fund" value={formObj.provident_fund} handleChange={handleChange}
                    name='provident_fund' size='col-sm-3 col-lg-2' limit={9999999} type='text' />
                <InputFieldform disabled={page} placeholder='' label="Gratuity" value={formObj.gratuity} handleChange={handleChange}
                    name='gratuity' size='col-sm-3 col-lg-2' limit={9999999} type='text' />
                <InputFieldform disabled={page} placeholder='' label="Others" value={formObj.non_cash_others} handleChange={handleChange}
                    name='non_cash_others' size='col-sm-3 col-lg-2' limit={9999999} type='text' />
                <InputFieldform placeholder='' label="Total" value={formObj.non_cash_total} disabled={true}
                    name='non_cash_total' size='col-sm-3 col-lg-2' limit={9999999} type='text' /> */}


            </main>
            {!page && <section className='flex justify-between my-2'>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/exp_form`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Previous
                </button>
                <button onClick={() => { saveData(); navigate(`/Employeeallform/${id}/personal_info`) }} className='p-2 bg-slate-400 text-white rounded'>
                    Next
                </button>
            </section>}
        </div>
    )
}

export default JFLastpositionHeld