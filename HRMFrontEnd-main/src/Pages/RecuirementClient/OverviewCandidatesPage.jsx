import React, { useEffect, useState } from 'react'
import BackButton from '../../Components/MiniComponent/BackButton'
import axios from 'axios'
import { port } from '../../App'
import CandidateTable from '../../Components/Tables/CandidateTable'
import { useParams, useSearchParams } from 'react-router-dom'
import InfoButton from '../../Components/SettingComponent/InfoButton'

const OverviewCandidatesPage = () => {
    let { status } = useParams()
    const [searchParams] = useSearchParams()
    const [searchTerm, setSearchTerm] = useState('')
    const [fromDate, setFromDate] = useState('')
    const [toDate, setToDate] = useState('')

    const [allCandidate, setAllCandidate] = useState([])
    const [loading, setLoading] = useState(false)
    const [pagination, setPagination] = useState({
        count: 0,
        next: null,
        previous: null,
        currentPage: 1
    });

    const pageSize = 10;

    let getAllCandidate = async (page = 1, search = searchTerm, from = fromDate, to = toDate) => {
        setLoading(true)
        let queryParams = `?page=${page}`
        if (search) queryParams += `&search=${search}`
        if (from) queryParams += `&from_date=${from}`
        if (to) queryParams += `&to_date=${to}`

        axios.get(`${port}/root/FinalCandidatesList/${status}/${queryParams}`).then((response) => {
            console.log(response.data, 'overviewdata');
            setAllCandidate(response.data.results || response.data)
            if (response.data.results) {
                setPagination({
                    count: response.data.count,
                    next: response.data.next,
                    previous: response.data.previous,
                    currentPage: page
                });
            } else {
                setPagination({
                    count: response.data.length || 0,
                    next: null,
                    previous: null,
                    currentPage: 1
                });
            }
            setLoading(false)
        }).catch((error) => {
            setLoading(false)
            console.log(error);
        })
    }

    useEffect(() => {
        if (status) {
            const urlPage = parseInt(searchParams.get('page')) || 1
            getAllCandidate(urlPage)
        }
    }, [status])

    const handleClearFilters = () => {
        setSearchTerm('')
        setFromDate('')
        setToDate('')
        getAllCandidate(1, '', '', '')
    }

    return (
        <div className='p-3'>
            <div className='flex flex-col gap-4 mb-4 bg-white p-3 rounded shadow-sm'>
                <div className='flex items-center justify-between'>
                    <h2 className='text-xl font-semibold capitalize m-0'>
                        {status.replace(/_/g, ' ')} Candidates
                    </h2>
                    <BackButton />
                </div>
                <div className='flex flex-wrap items-end gap-3'>
                    <div className="w-full sm:w-auto relative">
                        {/* <label className="block text-xs font-medium text-gray-700 mb-1">Search</label> */}
                        <button className='absolute right-2 -top-4'>
                            <InfoButton size={12} content="Search by Candidate name,Candidate id,Email, Applied designation. " />
                        </button>
                        <input
                            type="text"
                            className="form-control form-control-sm w-full placeholder:text-xs "
                            placeholder="Search..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                    {/* <div className="w-full sm:w-auto">
                        <label className="block text-xs font-medium text-gray-700 mb-1">From Date</label>
                        <input
                            type="date"
                            className="form-control form-control-sm"
                            value={fromDate}
                            onChange={(e) => setFromDate(e.target.value)}
                        />
                    </div>
                    <div className="w-full sm:w-auto">
                        <label className="block text-xs font-medium text-gray-700 mb-1">To Date</label>
                        <input
                            type="date"
                            className="form-control form-control-sm"
                            value={toDate}
                            onChange={(e) => setToDate(e.target.value)}
                        />
                    </div> */}
                    <div className="flex gap-2">
                        <button
                            className="btn btn-primary btn-sm d-flex items-center gap-1"
                            onClick={() => getAllCandidate(1)}
                        >
                            <i className="bi bi-funnel-fill"></i>Search
                        </button>
                        <button
                            className="btn btn-secondary btn-sm"
                            onClick={handleClearFilters}
                        >
                            Clear
                        </button>
                    </div>
                </div>
            </div>

            <div className='bg-white rounded-lg shadow-sm p-4'>
                <CandidateTable
                    getData={(page) => getAllCandidate(page)}
                    data={allCandidate}
                    loading={loading}
                    status={status}
                    pagination={pagination}
                    onPageChange={(page) => getAllCandidate(page)}
                />
            </div>
        </div>
    )
}

export default OverviewCandidatesPage
