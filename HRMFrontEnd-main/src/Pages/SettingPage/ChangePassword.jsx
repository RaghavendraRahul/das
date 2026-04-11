import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios';
import { port } from '../../App';
import { toast } from 'react-toastify';

const ChangePassword = () => {
    let { activeSetting, setTopNav } = useContext(HrmStore)
    let empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId
    let [loading, setloading] = useState(false)
    let [obj, setObj] = useState({
        OldPassword: '',
        NewPassword: '',
        confirmPassword: '',
        EmployeeId: empid
    })
    let handleChange = (e) => {
        let { value, name } = e.target
        setObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    const changepassword = (e) => {
        e.preventDefault();
        if (obj.NewPassword == '' || obj.OldPassword == '' || obj.confirmPassword == '') {
            toast.warning('Enter the fields')
            return
        }

        if (obj.confirmPassword == obj.NewPassword) {
            if (obj.OldPassword == obj.NewPassword) {
                toast.warning('Old password and New password should not be same.')
                return
            }
            setloading(true)
            axios.post(`${port}/root/changepassword`, obj).then((res) => {
                console.log("changepassword_res", res.data);
                toast.success(res.data)
                setloading(false)
                setObj({
                    OldPassword: '',
                    NewPassword: '',
                    confirmPassword: '',
                    EmployeeId: empid
                })
            }).catch((err) => {
                setloading(false)
                console.log("changepassword_res", err);
                if (err.response.data) {
                    toast.error(err.response.data)
                }
            })
        }
        else {
            toast.warning('Enter the correct confirm password')
        }
    };
    useEffect(() => {
        setTopNav('password')
    }, [])
    return (
        <div className='min-h-[80vh] poppins flex ' >
            <main className='bgclr w-5/12 mx-auto p-4 my-auto shadow rounded-xl'>
                <h4> Change Your Password </h4>
                <article className='w-4/5 mx-auto ' >

                    <section className='flex gap-3  flex-wrap my-3 items-center '>
                        <label htmlFor="" className='w-36 ' > Old Password</label>
                        <input type="text" value={obj.OldPassword} onChange={handleChange}
                            name='OldPassword' className=' inputbg w-full outline-none p-2  rounded ' />
                    </section>
                    <section className='flex gap-3  flex-wrap my-3 items-center '>

                        <label htmlFor="" className='w-36 ' > New Password</label>

                        <input type="text" value={obj.NewPassword} onChange={handleChange}
                            name='NewPassword' className=' inputbg w-full outline-none p-2  rounded ' />
                    </section>
                    <section className='flex gap-3  flex-wrap my-3 items-center '>
                        <label htmlFor="" className=' ' > Confirm Password</label>
                        <input type="password" value={obj.confirmPassword} onChange={handleChange}
                            name='confirmPassword' className=' inputbg w-full outline-none p-2  rounded ' />
                    </section>
                    <button onClick={changepassword} disabled={loading}
                        className='bluebtn ms-auto flex items-center justify-center 
                    p-2 px-3 w-36 rounded border-2 border-green-50 text-white'>
                        {loading ? 'Loading..' : "Save"}
                    </button>

                </article>
            </main>
        </div>
    )
}

export default ChangePassword