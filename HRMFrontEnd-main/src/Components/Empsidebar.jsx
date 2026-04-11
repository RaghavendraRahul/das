import React, { useContext } from 'react'
import "../assets/css/scroll.css"
import '../assets/css/media.css'
import { Link } from 'react-router-dom'
import NavbarButton from './HomeComponent/NavbarButton'
import { HrmStore } from '../Context/HrmContext'
import { das, port } from '../App'
import NewSideBar from './MiniComponent/NewSideBar'
import axios from 'axios'


const Empsidebar = () => {
    let logindata = JSON.parse(sessionStorage.getItem('user'))

    console.log("user", logindata.Disgnation);
    let { activePage, setActivePage, openNavbar, setNavbar } = useContext(HrmStore)
    return (
        <div className={` ${openNavbar && 'w-[260px] '} `}>
            {
                true ? <NewSideBar />
                    : <>

                        <main className='sticky top-0 flex  ' >
                            <section className={`h-[100vh] z-10 py-4 w-[80px] rounded-tr-[40px] bg-white `}>
                                {/* <img className='absolute z-0 top-0 ' src={require('../assets/Images/navbar.png')} alt="Navbar" /> */}
                                <button className='flex mx-auto'>
                                    <img className='w-7 ' src={require('../assets/Images/favicon.ico')} alt="Merida icon " />
                                </button>
                                <section className='w-fit mx-auto min-h-[60vh] gap-4 flex justify-between flex-col my-4 '>
                                    <button onClick={() => setNavbar(!openNavbar)} className={`hover:scale-[1.05] w-fit mx-auto rounded p-2 `}>
                                        <img style={{ transform: openNavbar ? 'scaleX(1)' : 'scaleX(-1)' }}
                                            className={`w-7 duration-700 `} src={require('../assets/Images/Union.png')} alt="Union" />
                                    </button>
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/dashboard/${logindata.Disgnation}`}
                                        label='Dashboard' active='dashboard'
                                        img='/assets/Images/dashboard.png' />
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Employee_request_form`}
                                        label='Request' active='request'
                                        img='/assets/Images/report.png' />
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Recruiter_Activity`}
                                        label='Activity' active='activity'
                                        img='/assets/Images/Work.png' />
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
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Employee_interview_applicants`}
                                        label='Applicants' active='Applicants'
                                        img='/assets/Images/Paper.png' />
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/dash/payslip/${logindata.EmployeeId}`}
                                        label='Payslip' active='payroll'
                                        img='/assets/Images/payroll.png' />
                                    {/* <NavbarButton openNavbar={openNavbar} setopen={setNavbar}
                            path={`/Report_Manager_Reporting_team`}
                            label=' Reporting Team' active='team'
                            img='/assets/Images/profile.png' /> */}
                                    <NavbarButton openNavbar={openNavbar} setopen={setNavbar} drop={[
                                        { name: 'Reporting Team', path: '/Report_Manager_Reporting_team' },
                                        logindata.is_reporting_manager && { name: 'Leave Approval', path: '/dash/approvals' },
                                        // logindata.is_reporting_manager && { name: 'Appraisal', path: '/dash/appraisalform' },

                                    ]}
                                        label='Employee' active='Employee'
                                        img='/assets/Images/profile.png' />
                                    {/* <NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/Emp_activity_sheet`}
                            label='Activity' active='activity'
                            img='/assets/Images/Work.png' /> */}

                                    < NavbarButton openNavbar={openNavbar} setopen={setNavbar} path={`/settings/`}
                                        label='Setting' active='setting'
                                        img='/assets/Images/setting.png' />
                                </section>
                            </section>
                            <section className={`${openNavbar ? 'translate-x-0 ' : 'translate-x-[-280px] '} transition duration-700 sideinleft bg-violet-50
               border-slate-50 border-e-2 absolute left-0 z-0  w-[260px] h-[100vh]`}>
                                <img src={require('../assets/Images/navbar.png')} alt="Navbar " />
                            </section>
                        </main>

                        <main className='side-bar'
                            style={{ width: "20%", height: "100vh", position: 'fixed', backgroundColor: "rgb(249,249,249)" }}>
                            <div className='m-3' style={{
                                height: "95%", borderRadius: '20px', overflow: 'hidden',
                                backgroundColor: 'rgb(76,53,117)'
                            }}>
                                <div className="logo p-4 d-flex justify-content-center mt-2 bg-succes " style={{ position: 'sticky', top: '0', zIndex: 1, height: '15%' }}>
                                    <img src={require('../assets/logo/merida website logo white.9f5c7931c8ddf828808e.png')} width={130} height={48} alt="" />
                                </div>

                                <div className='bg-warnin overflow mt-2' style={{ height: '77%', overflow: 'scroll' }}>



                                    <ul className="nav flex-column mx-auto p-4 text-white" style={{ lineHeight: '48px' }} >

                                        <Link to={`/dashboard/${logindata.Disgnation}`} className='text-white side-nav '  >

                                            <li className='ms-2'><i class="fa-solid fa-house me-3"></i> EMP Dashboard  </li>
                                        </Link>
                                        <Link to='/Employee_request_form' className='text-white side-nav' >
                                            <li className='ms-2'><i class="fa-solid fa-flag me-3"></i> Request</li>
                                        </Link>
                                        <Link to='/Report_Manager_Reporting_team' className={`${logindata.reporting_emp_list ? 'd-block' : 'd-none'} text-white side-nav`}>
                                            <li className='ms-2'><i class="fa-solid fa-flag me-3"></i> Reporting Team</li>
                                        </Link>

                                        <Link to='/Emp_activity_sheet' className='text-white side-nav' >
                                            <li className='ms-2'><i class="fa-solid fa-door-open me-3"></i> Activites</li>
                                        </Link>
                                        <Link to="/Employee_interview_applicants" className='text-white side-nav'  >
                                            <li className='ms-2'> <i class="fa-solid fa-list-check me-3"></i> Applicants</li>
                                        </Link>

                                    </ul>
                                </div>
                            </div>

                        </main >
                    </>
            }
        </div>
    )
}

export default Empsidebar