import React, { useContext, useEffect, useState } from 'react'
import SearchIcon from '../../SVG/SearchIcon'
import { useNavigate } from 'react-router-dom'
import { RouterStore } from '../../Context/RouterContext'

const TopSearchBar = ({ navbar }) => {
    let [searchResult, setSearchResult] = useState()
    let [searchWord, setSearchWord] = useState()
    let [showResult, setShowResult] = useState()
    let navigate = useNavigate()
    let status = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let { settingRouterLinks, payrollRoutersLinks, leaveRouterLinks, employeeRouterLink } = useContext(RouterStore)
    let [searchNavigations, setsearchNavigation] = useState()
    useEffect(() => {
        setsearchNavigation([
            {
                label: 'Home',
                path: `/dashboard/${status}`,
                keyword: ['home', 'dashboard'],
                show: true
            },
            {
                label: 'Change Password',
                path: `/settings/password`,
                keyword: ['password', 'forgot password'],
                show: true
            },
            {
                label: 'Holiday calendar',
                path: `/settings/holidays`,
                keyword: ['leave', 'attendence'],
                show: true
            },
            {
                label: 'Attendance',
                path: `/settings/attendence`,
                keyword: ['leave', 'list', 'absent'],
                show: true
            },
            {
                label: 'Applied list',
                path: `/Applaylist`,
                keyword: ['interviews', 'final result', 'candidate'],
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'Applicants',
                path: `/Applicants`,
                keyword: ['interviews',],
                show: status == 'Recruiter'
            },
            {
                label: 'Applicants',
                path: '/Employee_interview_applicants',
                keyword: ['interviews',],
                show: status == 'Employee'
            },
            {
                label: 'Activity',
                path: '/dash/employeeactivity',
                keyword: ['activity', 'calls', 'das', 'client adding'],
                show: true
            }
        ].concat(employeeRouterLink).concat(payrollRoutersLinks).concat(leaveRouterLinks))
    }, [employeeRouterLink, payrollRoutersLinks, leaveRouterLinks])
    let searchFilter = (val) => {
        let searchval = val ? val : searchWord
        let filteredValue = searchNavigations.filter((obj) =>
            ((obj.keyword && obj.keyword.some((val2) => val2.toLowerCase().indexOf(searchval.toLowerCase()) != -1)) ||
                obj.label.toLowerCase().indexOf(searchval.toLowerCase()) != -1)
            && obj.show)
        setSearchResult(filteredValue)
    }
    return (
        <div>
            <section onMouseEnter={() => setShowResult(true)} className='flex gap-2 relative' >
                <input type="text" value={searchWord} onChange={(e) => {
                    setSearchWord(e.target.value);
                    searchFilter(e.target.value)
                }}
                    className={` p-[12px] text-sm outline-none w-56 rounded ${navbar ? 'bg-slate-200 ' : "bg-white"}  `}
                    placeholder='Search any Event' />
                <button className='bg-blue-600 p-2 px-3 rounded text-slate-50 ' >
                    <SearchIcon />
                </button>
                {/* Search result */}
                {searchWord && showResult &&
                    <section onMouseLeave={() => setShowResult(false)} className='bg-white absolute h-[20vh] overflow-y-scroll scrollmade2 z-10 w-full rounded top-12' >
                        {
                            searchResult && searchResult.length > 0 ? searchResult.map((obj, index) => (
                                <button onClick={() => {
                                    navigate(obj.path);
                                    setSearchWord('')
                                }} className='block text-slate-500 text-sm hover:bg-slate-50 w-full p-1 text-start' >
                                    {obj.label}
                                </button>
                            )) :
                                <div className='w-full h-full flex items-center justify-center ' >
                                    No Page Found
                                </div>
                        }
                    </section>
                }
            </section>
        </div>
    )
}

export default TopSearchBar