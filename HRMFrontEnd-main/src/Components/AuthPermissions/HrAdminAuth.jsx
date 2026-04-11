import React, { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'

const HrAdminAuth = ({ Child, subpage }) => {
    let empStatus = JSON.parse(sessionStorage.getItem('user')).Disgnation
    let navigate = useNavigate()
    let dashboardchange = () => {
        // alert('hellow')t
        navigate(`/dashboard/${empStatus}`)
    }
    useEffect(() => {
        if (empStatus != 'HR' && empStatus != 'Admin')
            dashboardchange()
    }, [empStatus])
    return (
        <div>
            {
                empStatus && (empStatus == 'HR' || empStatus == 'Admin') ? <Child subpage={subpage ? true : false} /> : dashboardchange()
            }
        </div>
    )
}

export default HrAdminAuth