import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'

const EmpNameCom = ({ empid }) => {
    let { activeEmployee, getActiveEmployee } = useContext(HrmStore)
    let [employeeData, setEmployeeData] = useState()
    useEffect(() => {
        if (activeEmployee)
            setEmployeeData(activeEmployee?.find((obj) => obj.employee_Id == empid))
        console.log(activeEmployee?.find((obj) => obj.employee_Id == empid), 'datafound', empid, activeEmployee);

    }, [empid, activeEmployee])
    useEffect(() => {
        getActiveEmployee()
    }, [])
    return (
        <div>
            <section className='rounded bg-white p-3 w-fit my-2  '>
                Name : {employeeData?.full_name}
            </section>
        </div>
    )
}

export default EmpNameCom