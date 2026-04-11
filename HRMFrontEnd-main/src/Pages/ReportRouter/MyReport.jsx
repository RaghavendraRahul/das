import React, { useContext, useEffect } from 'react'
import { HrmStore } from '../../Context/HrmContext'

const MyReport = () => {
    let { setTopNav } = useContext(HrmStore)
    useEffect(() => {
        setTopNav('myreport')
    }, [])
    return (
        <div>MyReport</div>
    )
}

export default MyReport