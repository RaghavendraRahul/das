import React, { useEffect, useState } from 'react'
import InputFieldform from '../SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'

const AppraisalOffer = ({ sid, setshowtab, id, obj }) => {
    let [loading, setLoading] = useState(false)
    let [document, setDocument] = useState({
        assigned_salary: '',
        applicable_date: null,
        emp_info_id: id
    })
    let handleChange = (e) => {
        let { name, value } = e.target
        setDocument((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getData = () => {
        if (sid) {
            axios.get(`${port}/root/lms/EmployeementHistoryManagement?self_app_id=${sid}`).then((response) => {
                console.log("get", response.data);
                if (response.data)
                    setDocument(response.data)
            }).catch((error) => {
                console.error("get", error);
            })
        }
    }
    let saveDocument = () => {
        setLoading(true)
        if (document.id)
            UpdateDocument()
        else
            axios.post(`${port}/root/lms/EmployeementHistoryManagement`, {
                ...document,
                emp_info_id: id,
                self_app_id: sid
            }).then((response) => {
                console.log("post", response.data);
                setLoading(false)
            }).catch((error) => {
                setLoading(false)
                console.error("post", error);
            })
    }
    let UpdateDocument = () => {
        axios.patch(`${port}/root/lms/EmployeementHistoryManagement`, document).then((response) => {
            console.log("post", response.data);
            setLoading(false)

        }).catch((error) => {
            console.error("post", error);
            setLoading(false)

        })
    }
    useEffect(() => {
        getData()
    }, [sid])

    return (
        <div className='container mx-auto'>
            <h5 className=''> Document generation </h5>

            <main className='formbg rounded p-3 row my-3 container mx-auto ' >

                <InputFieldform label={'Increment Salary'} value={document.assigned_salary} name='assigned_salary'
                    placeholder='New CTC' limit={9999999} handleChange={handleChange} />

                <InputFieldform type={'date'} value={document.applicable_date} name='applicable_date'
                    label={'Effective Date'} handleChange={handleChange} />

                <InputFieldform label={'role'} disabled={true}
                    value={obj && obj.Position} />
            </main>
            <section className='flex items-center justify-center '  >
                <button onClick={() => setshowtab('EU')} className=' border-2 p-2 px-3 rounded border-violet-800 h-fit ' >
                    Previous
                </button>
                <button onClick={saveDocument} className='btngrd text-sm p-2 rounded text-white flex ms-auto ' >
                    Save
                </button>
            </section>
        </div>
    )
}

export default AppraisalOffer