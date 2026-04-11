import React, { useContext, useState } from 'react'
import "../assets/css/scroll.css"
import '../assets/css/media.css'
import { Link, useNavigate } from 'react-router-dom'
import { Navbar } from 'react-bootstrap'
import { HrmStore } from '../Context/HrmContext'
import NavbarButton from './HomeComponent/NavbarButton'
import { light } from '@mui/material/styles/createPalette'
import { das, port } from '../App'
import NewSideBar from './MiniComponent/NewSideBar'
import axios from 'axios'

const Sidebar = () => {
    let [opentab, setOpenTab] = useState(false)
    let logindata = JSON.parse(sessionStorage.getItem('user'))

    console.log("user", logindata.Disgnation);
    let { activePage, setActivePage, count, setIsInsideOffice, openNavbar, employeeDetails, setNavbar } = useContext(HrmStore)

    return (
        <div className={` ${openNavbar && ' w-[270px]'}  `}>
            {
                true ? <NewSideBar /> : <>
                    <main className='sticky top-0 flex'>
                        <section className={`h-[100vh] z-10 py-4 w-[80px] rounded-tr-[40px] bg-white `}>
                            {/* <img className='absolute z-0 top-0 ' src={require('../assets/Images/navbar.png')} alt="Navbar" /> */}
                            <button className='flex mx-auto'>
                                <img className='w-6 ' src={require('../assets/logo/favicon.ico')}
                                    alt="Merida icon " onClick={() => {
                                        setIsInsideOffice((prev) => !prev)
                                    }} />
                            </button>
                            <button onClick={() => setNavbar(!openNavbar)}
                                className={`hover:scale-[1.05] w-fit flex mt-3 mx-auto rounded  `}>
                                <img style={{ transform: openNavbar ? 'scaleX(1)' : 'scaleX(-1)' }}
                                    className={`w-7 me-auto duration-700 `}
                                    src={require('../assets/Images/Union.png')} alt="Union" />
                            </button>
                            <section className={` overflowbar mx-auto 
                                gap-4 flex justify-between flex-col my-4 ${openNavbar && 'w-[270px]'} `}>
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/dashboard/${logindata.Disgnation}`}
                                    label='Dashboard' active='dashboard'
                                    img='/assets/Images/dashboard.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/dash/client`}
                                    label='Client' active='client'
                                    img='/assets/Images/profile.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Applaylist`}
                                    label='Applyed List' active='applylist'
                                    img='/assets/Images/report.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar}
                                    onClick={async () => {
                                        const user = JSON.parse(sessionStorage.getItem('user'));
                                        if (!user?.Email) {
                                            console.error('User email not found');
                                            return;
                                        }
                                        try {
                                            const response = await axios.post(`${port}api/generate-das-code/`, {
                                                email: user.Email
                                            });
                                            if (response.data.redirect_url) {
                                                window.location.href = response.data.redirect_url;
                                            }
                                        } catch (error) {
                                            console.error('Error generating DAS code:', error);
                                            const errorMessage = error.response?.data?.error || error.message || 'Failed to connect to DAS';
                                            alert(errorMessage + '. Please try again.');
                                        }
                                    }}
                                    label='Das' active='das'
                                    img='/assets/Images/DasIcon.webp' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Reporting_team`}
                                    label='My team' active='Reporting_team'
                                    img='/assets/Images/profile.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Sample_acti`}
                                    label='Activities' active='activity'
                                    img='/assets/Images/Work.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} drop={[
                                    { name: 'Salary component', path: '/dash/salaryComponent' },
                                    { name: 'Salary template', path: '/dash/salary-templates' },
                                    { name: 'Assign Employee', path: '/dash/salary-assigning' },
                                    { name: 'Employees payslip', path: '/dash/employeesPayslip' },
                                ]}
                                    label='Payroll' active='payroll'
                                    img='/assets/Images/payroll.png'
                                />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} drop={[
                                    { name: 'Over View', path: '/Employee_Overview' },
                                    { name: 'All Employees', path: '/AllEmployees' },
                                    { name: 'Employee Seperation', path: '/Employee_Separation' },
                                    { name: 'Mass Communication', path: '/Mass_Mail' },
                                    { name: 'Offer Approval', path: '/dash/offerApproval', light: count && count.offeraproval },
                                    { name: 'Employee New Joining', path: '/New_Join_Employee' },
                                    { name: 'Resignation Request ', path: '/Employee_request_form' }
                                ]}
                                    label='Employee' active='Employee' light={count && count.employeePage}
                                    img='/assets/Images/Application.png' />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} drop={[
                                    { name: 'Appraisal', path: '/dash/appraisalform' }
                                ]}
                                    label='Perfomance' active='perform'
                                    img='/assets/Images/Graph.png'
                                />
                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar}
                                    label='Leave' active='leave' light={count && count.leavepage}
                                    img='/assets/Images/Paper.png'
                                    drop={[
                                        { name: 'Approval', path: '/dash/approvals', light: count && count.leaveApproval },
                                        { name: 'Attendence list', path: '/dash/attendence-list' },
                                        { name: 'Leave Setting', path: '/dash/leaveCreation' },
                                        { name: 'Shift Timing', path: '/dash/shift-timing' }
                                    ]} />

                                <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/settings`}
                                    label='Setting' active='setting'
                                    img='/assets/Images/setting.png' />


                                {/* Not used */}
                                {/* <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Employee_Profile`}
                            label='Graph' active='Graph'
                            img='/assets/Images/Graph.png' />
                        */}
                            </section>
                        </section>
                        <section className={`${openNavbar ? 'translate-x-0 ' : 'translate-x-[-280px] '} transition duration-700 sideinleft bg-violet-50
                 border-slate-50 border-e-2 absolute left-0 z-0  w-[270px] h-[100vh]`}>
                            <img src={require('../assets/Images/navbar.png')} alt="Navbar " />
                        </section>
                    </main>
                </>
            }
        </div>
    )
}

export default Sidebar