import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { Offcanvas } from 'react-bootstrap';
import { port } from '../App';
import '../assets/css/main.css'
import DropDownIcon from './Icons/DropDownIcon';
import { HrmStore } from '../Context/HrmContext';
import TopNavScrollBar from './MiniComponent/TopNavScrollBar';
import TopSearchBar from './MiniComponent/TopSearchBar';
import GetGeoLocation from './MiniComponent/GetGeoLocation';


const Topnav = ({ name, navbar }) => {
    const user = JSON.parse(sessionStorage.getItem('user'));
    const Empid = user?.EmployeeId;
    const navigate = useNavigate();

    const [notifications, setNotifications] = useState([]);
    const [unreadCount, setUnreadCount] = useState(0);
    const [showNotification, setShowNotification] = useState(false);

    const [isLoading, setIsLoading] = useState(false);

    let [profileDropdown, setProfileDropdown] = useState()


    const fetchNotifications = () => {
        if (!Empid) return;
        setIsLoading(true);
        axios.get(`${port}/root/notifications?login_emp_id=${Empid}`)
            .then((res) => {
                setNotifications(res.data.notifications);
                setUnreadCount(res.data.unread_count);
            })
            .catch((err) => console.error("Error fetching notifications:", err))
            .finally(() => {
                setIsLoading(false);
            });
    };

    const handleMarkAsRead = () => {
        setIsLoading(true);
        axios.post(`${port}/root/notifications/mark-as-read?login_emp_id=${Empid}`)
            .then(() => fetchNotifications())
            .catch((err) => {
                console.error("Error marking as read:", err);
                setIsLoading(false);
            });
    };

    const handleNotificationPanelClick = () => {
        setShowNotification(true);
        if (unreadCount > 0) {
            handleMarkAsRead();
        }
    };

    const removeNotification = (e, notificationId) => {
        e.stopPropagation();
        setIsLoading(true);
        axios.delete(`${port}/root/notifications/delete/${notificationId}?login_emp_id=${Empid}`)
            .then(() => fetchNotifications())
            .catch((err) => {
                console.error("Error deleting notification:", err);
                setIsLoading(false);
            });
    };

    const handleClearAll = () => {
        setIsLoading(true);
        axios.post(`${port}/root/notifications/clear-all?login_emp_id=${Empid}`)
            .then(() => {
                fetchNotifications();
            })
            .catch((err) => {
                console.error("Error clearing all notifications:", err);
                setIsLoading(false);
            });
    };

    useEffect(() => {
        if (Empid) {
            fetchNotifications();
            const intervalId = setInterval(fetchNotifications, 30000);
            return () => clearInterval(intervalId);
        }
    }, [Empid]);


    const handleNotificationItemClick = (notification) => {
        setShowNotification(false);
        const type = notification.notification_type;
        const id = notification.reference_id;
        if (!id) return;

        switch (type) {
            case 'task_assign': navigate('/activity'); break;
            case 'Leave_Apply': navigate(`/leave/approvals`); break;
            case 'Leave_Status': navigate('/leave'); break;
            case 'scr_assign': case 'int_assign': navigate(`/screening/candidate/${id}`); break;
            default: console.log("No navigation defined.");
        }
    }

    const handleDASClick = async () => {
        if (!user?.Email) {
            console.error('User email not found');
            alert('User email not found. Please login again.');
            return;
        }

        try {
            const response = await axios.post(`${port}root/api/generate-das-code/`, {
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
    };

    let [profile_info, setprofile_info] = useState({})
    useEffect(() => {
        if (Empid) {
            axios.get(`${port}/root/loginuser/${Empid}/`).then((res) => {
                setprofile_info(res.data)
            }).catch((err) => {
                console.log("login_err", err.data);
            })
        }
    }, [Empid])

    const logout = () => {
        // Store EmployeeId before clearing session
        const employeeId = user?.EmployeeId;
        
        // Clear session and navigate
        sessionStorage.removeItem('user')
        navigate("/")
        
        // Call logout API if employeeId exists
        if (employeeId) {
            axios.post(`${port}/root/logout/${employeeId}/`)
                .then((r) => {
                    console.log(" Logout Successfull", r.data)
                })
                .catch((err) => {
                    console.log("Logout Error", err)
                })
        }
    }


    return (
        <div className=' ' >
            <div className={`  ${navbar && "bg-white shadow-sm "}  py-2  mx-0 px-2`}>
                <nav className='d-flex  row flex-wrap justify-between w-full items-center ' >
                    <section className='flex  col-md-5 my-2 my-lg-0 order-2 order-sm-1 
                    felx-wrap gap-3 ' >
                        {
                            navbar ? <TopNavScrollBar navbar={navbar} /> :
                                <div className='w-full ' >
                                    {!name && <h5 className='poppins fw-semibold mb-3 ' >  Dashboard </h5>}
                                    {!name && <section className='poppins  '>
                                        <h5 className='text-2xl poppins fw-semibold ' >Hello  {user?.UserName}</h5>
                                        <p className='text-xs  '>Track Your Monthly Growth and Performance with<br />
                                            Ongoing Performance Management.
                                        </p>
                                    </section>}
                                    {name && <section className='poppins '>
                                        <h5 className='text-2xl poppins fw-semibold ' > {name}</h5>
                                    </section>}
                                </div>
                        }
                    </section>
                    <main className='flex col-md-7  my-2 my-lg-0 order-1 justify-end flex-wrap flex-lg-nowrap mb-3 my-sm-0 order-sm-2 gap-4 items-center ' >
                        <TopSearchBar navbar={navbar} />
                        <div>
                            <GetGeoLocation />
                        </div>
                        <div className="d-flex justify-content-evenly align-items-center" style={{ width: '22%' }}>
                            {/* DAS Button */}
                            <div 
                                onClick={handleDASClick} 
                                className='p-2 rounded bg-blue-100 hover:bg-blue-200 cursor-pointer transition-colors' 
                                title="Open Daily Activity Scheduler"
                            >
                                <span className='text-blue-700 font-semibold text-sm'>
                                    DAS
                                </span>
                            </div>

                            <div onClick={handleNotificationPanelClick} className='p-1 relative rounded bg-slate-200 w-7 h-7 cursor-pointer '>
                                <img className='w-5'
                                    src={require('../assets/Images/Notification.png')} alt="Notification" />
                                {unreadCount > 0 &&
                                    <p className='pulse-badge'>
                                        {unreadCount}
                                    </p>}
                            </div>

                            <Offcanvas show={showNotification} placement='end' onHide={() => setShowNotification(false)} >
                                <Offcanvas.Header closeButton>
                                    <div className="flex items-center w-full">
                                        <Offcanvas.Title>Notification</Offcanvas.Title>

                                        {notifications.length > 0 && !isLoading && (
                                            <button
                                                onClick={handleClearAll}
                                                className="ml-auto border border-red-400 text-red-500 px-2 py-1 rounded text-sm hover:bg-red-500 hover:text-white transition duration-200">
                                                Clear All
                                            </button>
                                        )}
                                    </div>
                                </Offcanvas.Header>

                                <Offcanvas.Body>
                                    {isLoading ? (
                                        <div className="d-flex justify-content-center align-items-center h-100">
                                            <div className="spinner-border" role="status">
                                                <span className="visually-hidden">Loading...</span>
                                            </div>
                                        </div>
                                    ) : (
                                        notifications.length > 0 ? notifications.map((e) => (
                                            <div
                                                key={e.id}
                                                className='d-flex border-bottom p-2 align-items-center'
                                                style={{ cursor: 'pointer', width: '100%' }}
                                                onClick={() => handleNotificationItemClick(e)}
                                            >
                                                <div className='d-flex align-items-center' style={{ width: '90%' }}>
                                                    <div style={{ width: '15%' }}>
                                                        <img width={40} className='mt-2' src={require('../assets/Icon/3135715.png')} alt="avatar" />
                                                    </div>
                                                    <div className='ms-3' style={{ width: '85%' }}>
                                                        <small className='font-bold'>{e.sender_name}</small>
                                                        <p className='m-0'><small style={{ fontSize: '12px' }}>{e.message}</small></p>
                                                        <small className='text-muted' style={{ fontSize: '11px' }}>{e.timesince}</small>
                                                    </div>
                                                </div>
                                                <div className='d-flex align-items-center justify-content-center' style={{ width: '10%' }}>
                                                    <i
                                                        className={`fa-regular fa-circle-xmark fa-lg text-muted ${isLoading ? 'disabled' : 'cursor-pointer'}`}
                                                        onClick={(event) => !isLoading && removeNotification(event, e.id)}
                                                    ></i>
                                                </div>
                                            </div>
                                        )) : <p>No new notifications.</p>
                                    )}
                                </Offcanvas.Body>
                            </Offcanvas>
                        </div>
                        <section onClick={() => setProfileDropdown(!profileDropdown)}
                            className='d-none d-lg-flex gap-3 relative items-center poppins ' >
                            {profile_info && (
                                <div className="w-14 h-14 rounded-full">
                                    {profile_info.profile_img ? (
                                        <img
                                            src={profile_info.profile_img}
                                            alt="ProfileImage"
                                            className="w-14 h-14 rounded-full object-cover"
                                        />
                                    ) : (
                                        <div className="w-14 h-14 rounded-full flex items-center justify-center
                                     bg-blue-600 text-slate-50 font-semibold text-xl">
                                            {profile_info.UserName?.charAt(0)}
                                        </div>
                                    )}
                                </div>
                            )}
                            <button className='flex gap-2 items-center ' >
                                <p className='mb-0 pb-0 text-wrap w-[130px] text-start ' >
                                    {profile_info.UserName}
                                </p>
                                <DropDownIcon />
                            </button>
                            {profileDropdown &&
                                <article onMouseLeave={() => setProfileDropdown(false)} className='absolute z-10 shadow p-2 bg-white rounded top-16 w-full ' >
                                    <button onClick={() => { navigate(`/dash/employee/${Empid}`); setProfileDropdown(false) }}
                                        className=' my-2  ' >
                                        My Profile
                                    </button>
                                    <button className=' block my-2 ' onClick={logout} >
                                        Log Out
                                    </button>
                                </article>}
                        </section>
                    </main>
                </nav>
            </div >
        </div >
    )
}

export default Topnav;