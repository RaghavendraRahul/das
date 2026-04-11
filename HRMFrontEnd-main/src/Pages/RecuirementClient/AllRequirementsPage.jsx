import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import ClientRequirmentTable from '../../Components/Tables/ClientRequirmentTable'
import Topnav from '../../Components/Topnav'
import LoadingData from '../../Components/MiniComponent/LoadingData'

const AllRequirementsPage = () => {
    let { setTopNav } = useContext(HrmStore)
    let [allRequirement, setAllRequirement] = useState()
    let [loading, setLoading] = useState(false)
    let getAllRequirement = () => {
        setLoading(true)
        axios.get(`${port}/root/cms/add-clients-requirements?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
            console.log(response.data, 'recui');
            setAllRequirement(response.data?.reverse())
            setLoading(false)
        }).catch((error) => {
            console.log(error, 'recui');
            setLoading(false)
        })
    }
    useEffect(() => {
        getAllRequirement()
        setTopNav('recuirter')
    }, [])
    return (
        <div>
            All requirements
            {loading ? <LoadingData /> :
                <ClientRequirmentTable data={allRequirement} />}
        </div>
    )
}

export default AllRequirementsPage