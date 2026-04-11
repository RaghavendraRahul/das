import React, { useEffect, useState } from 'react'
import BackButton from '../../Components/MiniComponent/BackButton'
import axios from 'axios'
import { port } from '../../App'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import CandidateTable from '../../Components/Tables/CandidateTable'
import { useParams, useSearchParams } from 'react-router-dom'

const CandidatePageFinalStatus = () => {
    let { rid } = useParams()
    const [searchParams, setSearchParams] = useSearchParams()
    let [allCandidate, setAllCandidate] = useState()
    let [finalStatus, setFinalStatus] = useState('consider_to_client')
    let [loading, setLoading] = useState(false)
    const [pagination, setPagination] = useState({
        count: 0,
        next: null,
        previous: null,
        currentPage: 1
    });

    const pageSize = 10;

    let getAllCandidate = async (page = 1) => {
        setLoading(true)
        axios.get(`${port}/root/FinalCandidatesList/${finalStatus}/?req_id=${rid}&page=${page}`).then((response) => {
            console.log(response.data, 'finaldata');
            setAllCandidate(response.data.results || response.data)
            if (response.data.results) {
                setPagination({
                    count: response.data.count,
                    next: response.data.next,
                    previous: response.data.previous,
                    currentPage: page
                });
            }
            setLoading(false)
        }).catch((error) => {
            setLoading(false)
            console.log(error);
        })
    }

    /*
    let getAllCandidate = async () => {
        setLoading(true)
        // alert('ullen ayya')
        axios.get(`${port}/root/FinalCandidatesList/${finalStatus}/?req_id=${rid}`).then((response) => {
            console.log(response.data, 'finaldata');
            setAllCandidate(response.data.results || response.data)
            setLoading(false)
        }).catch((error) => {
            setLoading(false)
            console.log(error);
        })
    }
    */
    useEffect(() => {
        setSearchParams(prev => {
            const next = new URLSearchParams(prev)
            next.set('page', 1)
            return next
        })
        getAllCandidate(1)
    }, [finalStatus])
    return (
        <div>
            <BackButton />
            <div className='bg-white rounded p-2 my-2 w-fit  ' >
                Final Status :
                <select className='outline-none  ' value={finalStatus} onChange={(e) => setFinalStatus(e.target.value)}
                    name="" id="">
                    <option value="Reject">Rejected</option>
                    <option value="consider_to_client">Consider to client </option>
                    <option value="Internal_Hiring">Internal Hiring</option>
                </select>
            </div>
            {/* Table */}
            {<CandidateTable
                getData={getAllCandidate}
                data={allCandidate}
                loading={loading}
                rid={rid}
                pagination={pagination}
                onPageChange={(page) => getAllCandidate(page)}
            />}

        </div>
    )
}

export default CandidatePageFinalStatus