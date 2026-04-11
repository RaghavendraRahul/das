import React, { useContext, useEffect } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import EmployeeDiversity from '../../Components/HomeComponent/EmployeeDiversity'

const AnalyticPage = () => {
    let { setTopNav } = useContext(HrmStore)
    useEffect(() => {
        setTopNav('analytic')
    }, [])
    return (
        <div>
            {/* Analytic */}
            <main className='row  ' >

                <section className='col-md-6 my-2 ' >
                    <EmployeeDiversity />
                </section>
                <section className='col-md-6 my-2 ' >
                    <EmployeeDiversity type='portal' />
                </section>
                <section className='col-md-4 my-2 ' >
                    <EmployeeDiversity type='gender' />
                </section>
            </main>
        </div>
    )
}

export default AnalyticPage