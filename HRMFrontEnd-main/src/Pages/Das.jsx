import axios from 'axios'
import React, { useEffect } from 'react'
import { Spinner } from 'react-bootstrap'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { port } from '../App'

const Das = () => {
    let navigate = useNavigate()
    let [searchValue] = useSearchParams()
    let uservalue = searchValue.get('user')
    let passwordValue = searchValue.get('password') &&
        encodeURIComponent(searchValue.get('password'))

    const handleSubmit1 = async (e) => {
        // e.preventDefault();
        // Check if employeeId1 and password1 are not empty
        const formdata = new FormData()
        console.log(uservalue, (passwordValue));

        formdata.append('EmployeeId', uservalue ? uservalue : '')
        formdata.append('Password', passwordValue != null ? passwordValue : '')
        // axios.post('http://192.168.0.107:9000/root/login', formdata)
        axios.post(`${port}/root/login`, formdata)
            .then((r) => {
                console.log("Login", r.data)
                sessionStorage.setItem('user', JSON.stringify(r.data))
                sessionStorage.setItem('daspk', JSON.stringify(r.data.pk))
                sessionStorage.setItem('dasid', JSON.stringify(r.data.employee_id))
                sessionStorage.setItem('email', JSON.stringify(r.data.email))
                sessionStorage.setItem('status', JSON.stringify(r.data.Dash_Status))
                navigate(`/dashboard/${r.data.Disgnation}`)

            })
            .catch((err) => {
                alert(err.response.data)
                console.log("Login Error", err.response.data)
            })
    };


    useEffect(() => {
        if (uservalue && passwordValue)
            handleSubmit1()

    }, [uservalue, passwordValue])
    return (
        <div className='h-[100vh] flex ' >
            <Spinner className='m-auto' />

        </div>
    )
}

export default Das