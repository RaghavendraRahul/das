import Sidebar from './Sidebar';
import Topnav from './Topnav';
import { port } from '../App';
import { useContext, useEffect, useState } from 'react';
import axios from 'axios';
import { HrmStore } from '../Context/HrmContext';
import NewSideBar from './MiniComponent/NewSideBar';

const generateDates = (month, year) => {
    const dates = [];
    const date = new Date(year, month, 1);

    while (date.getMonth() === month) {
        const day = String(date.getDate()).padStart(2, '0');
        const monthFormatted = String(date.getMonth() + 1).padStart(2, '0');
        const yearFormatted = date.getFullYear();

        // const formattedDate = `${day}-${monthFormatted}-${yearFormatted}`;
        const formattedDate = `${yearFormatted}-${monthFormatted}-${day}`;
        dates.push(formattedDate);

        date.setDate(date.getDate() + 1);
    }
    return dates;
};

const formatDate = (date) => {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${year}-${month}-${day}`;
};

const Sample_acti = () => {
    const Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId;

    let { setActivePage } = useContext(HrmStore)
    useEffect(() => {
        setActivePage('activity')
    }, [])
    const [activitiesget, setgetActivities] = useState([]);
    const [activitiesgetdaily_achives, setgetActivities_daily_achives] = useState([]);

    const [Interview_Scheduledget, setInterview_Scheduledget] = useState([]);
    const [Interview_Scheduled_achives, setInterview_Scheduled_achives] = useState([]);

    const [Walkinsget, setWalkinsget] = useState([]);
    const [Walkins_achives, setWalkins_achives] = useState([]);

    const [Offeredget, setOfferedget] = useState([]);
    const [Offered_achives, setOffered_achives] = useState([]);

    // const [Interview_Scheduled, setInterview_Scheduled] = useState([]);
    // const [Walkins, setWalkins] = useState([]);
    // const [Offered, setOffered] = useState([]);


    const [id, setid] = useState("");
    console.log("Daily1", activitiesgetdaily_achives);
    console.log("Daily2", Interview_Scheduled_achives);
    console.log("Daily3", Walkins_achives);
    console.log("Daily4", Offered_achives);

    const [month, setMonth] = useState(4); // 
    const [year, setYear] = useState(2024);
    const dates = generateDates(month, year);



    const currentDate = new Date();
    const formattedCurrentDate = formatDate(currentDate);


    // Activity Res Start

    const Activity_get_res = () => {
        axios.get(`${port}root/activity/${Empid}/`).then((res) => {
            setgetActivities(res.data);
            setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));
            console.log(res.data.map((x) => x.daily_achives));
            console.log("activity_get_res", res.data);
        }).catch((err) => {
            console.log("activity_get_err", err.data);
        });
    };

    useEffect(() => {
        Activity_get_res();
    }, []);

    // Activity res End

    // Interview Scheduled Start
    const Interview_Scheduled_res = () => {
        axios.get(`${port}root/activity/${Empid}/`).then((res) => {
            setInterview_Scheduledget(res.data);
            setInterview_Scheduled_achives(res.data.map((x) => x.daily_achives));
            console.log(res.data.map((x) => x.daily_achives));
            console.log("activity_get_res", res.data);
        }).catch((err) => {
            console.log("activity_get_err", err.data);
        });
    };

    useEffect(() => {
        Interview_Scheduled_res();
    }, []);
    // Interview Scheduled End

    // Walkins Start 
    const Walkins_res = () => {
        axios.get(`${port}root/activity/${Empid}/`).then((res) => {
            setWalkinsget(res.data);
            setWalkins_achives(res.data.map((x) => x.daily_achives));
            console.log(res.data.map((x) => x.daily_achives));
            console.log("activity_get_res", res.data);
        }).catch((err) => {
            console.log("activity_get_err", err.data);
        });
    };

    useEffect(() => {
        Walkins_res();
    }, []);
    // Walkins End

    // Offered Start

    const Offers_res = () => {
        axios.get(`${port}root/activity/${Empid}/`).then((res) => {
            setOfferedget(res.data);
            setOffered_achives(res.data.map((x) => x.daily_achives));
            console.log(res.data.map((x) => x.daily_achives));
            console.log("activity_get_res", res.data);
        }).catch((err) => {
            console.log("activity_get_err", err.data);
        });
    };

    useEffect(() => {
        Offers_res();
    }, []);

    // Offered End



    const calculateTotal = (field) => {
        return activitiesget.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget = calculateTotal('targets');
    const totalAchieved = calculateTotal('achieved');

    const findAchievedValue = (achieves, date) => {
        if (!achieves) {
            return ''; // Return an empty string if achieves is undefined
        }
        const achieve = achieves.find(a => a.achieved_Date === date);
        return achieve ? achieve.achieved : '';
    };

    const handleInputChange = (Date, achieved, id, value) => {

        console.log("enter", Date, achieved, id, value);



        axios.patch(`${port}root/daily_achives/${id}/`, {
            achieved: value
        }).then((res) => {
            console.log("activity_date_res", res.data);
            Activity_get_res()
        }).catch((err) => {

            console.log("activity_date_err", err);

        })
    };

    // Month Chnage Start

    let handle_Month_Change = (e) => {

        console.log("Year_select", e);
        console.log("Year_select", e.slice(0, 4));
        console.log("Year_select", e.slice(5, 7));




        axios.get(`${port}root/ActivityList/Display/${e}/`).then((res) => {
            console.log("activity_date_res", res.data);
            setgetActivities(res.data);
            setgetActivities_daily_achives(res.data.map((x) => x.daily_achives));

        }).catch((err) => {

            console.log("activity_date_err", err);

        })

    }


    return (
        <div className='d-flex' style={{ width: '100%', minHeight: '100%', }}>
            <div className=''>
                {/* <Sidebar value={"dashboard"}></Sidebar> */}
                <NewSideBar />
            </div>
            <div className='m-0 p-sm-2 flex-1 container-fluid overflow-hidden ' style={{ borderRadius: '10px' }}>
                <div className='Sample_acti_Topnav' >
                    <Topnav></Topnav>
                </div>
                <div className='mt-3 Activity_sheets_btn' >
                    <div className='me-3 d-flex justify-content-between'>
                        <ul className="nav nav-pills mb-3" id="pills-tab" role="tablist">
                            <li className="nav-item text-primary d-flex" role="presentation">
                                <h6 className='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Activities</h6>
                            </li>
                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="false">Interview Scheduled</h6>
                            </li>

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" type="button" role="tab" aria-controls="pills-contact" aria-selected="false">Walkins</h6>
                            </li>

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab1" data-bs-toggle="pill" data-bs-target="#pills-contact1" type="button" role="tab" aria-controls="pills-contact1" aria-selected="false">Offered</h6>
                            </li>

                        </ul>
                        <div className='mt-3'>
                            <input type="month" onChange={(e) => handle_Month_Change(e.target.value)} />
                        </div>
                    </div>
                    <div className="tab-content" id="pills-tabContent" style={{ position: 'relative', bottom: '20px' }}>
                        {/*  Activities */}
                        <div className="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabIndex="0">
                            <div>
                                <div className='mt-4 table-responsive'>
                                    <table className="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '500px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr>
                                                <th scope="col" className='ms-3' style={{ minWidth: '200px' }}>Activity Name</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Target</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activitiesget.map((activity, mainindex) => (
                                                <tr key={mainindex}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}

                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.Total_Achived}
                                                            className={`form-control border-0 shadow-none text-center ${activity.status === 'Green' ? 'bg-success' : 'bg-danger'}`} />
                                                    </td>
                                                    {dates.map((date) => {
                                                        let obj = activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date)
                                                        console.log("sxdasdad", obj);
                                                        // console.log(formattedCurrentDate);
                                                        console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                        return (
                                                            <td key={date}>

                                                                <input type="number" disabled={formattedCurrentDate != date}
                                                                    value={obj && obj.achieved}
                                                                    onChange={(e) => {

                                                                        if (obj) {
                                                                            handleInputChange(obj.Date, obj.achieved, obj.id, Number(e.target.value))
                                                                        }
                                                                    }
                                                                    } className="form-control border-0 shadow-none text-center " />



                                                            </td>
                                                        )
                                                    }
                                                    )}
                                                </tr>
                                            ))}

                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget}</td>
                                                <td className='text-center'>{totalAchieved}</td>
                                                {/* {dates.map((date, idx) => (
                                                    <td key={date}>
                                                        <input type="text" className="form-control border-0 shadow-none" disabled />
                                                    </td>
                                                ))} */}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className="d-flex justify-content-end">
                                    {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                    {/* <button type="submit" onClick={handleSubmit} className="btn btn-primary btn-sm">Save</button> */}
                                </div>
                            </div>
                        </div>
                        {/*  Interview Scheduled */}
                        <div className="tab-pane fade show " id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabIndex="0">
                            <div>
                                <div className='mt-4 table-responsive'>
                                    <table className="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '500px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr>
                                                <th scope="col" className='ms-3' style={{ minWidth: '200px' }}>Interview Scheduled</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Target</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {Interview_Scheduledget.map((activity, mainindex) => (
                                                <tr key={mainindex}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}

                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.Total_Achived}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map((date) => {
                                                        let obj = activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date)
                                                        console.log("sxdasdad", obj);
                                                        // console.log(formattedCurrentDate);
                                                        console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                        return (
                                                            <td key={date}>

                                                                <input type="number" disabled={formattedCurrentDate != date}
                                                                    value={obj && obj.achieved}
                                                                    onChange={(e) => {

                                                                        if (obj) {
                                                                            handleInputChange(obj.Date, obj.achieved, obj.id, Number(e.target.value))
                                                                        }
                                                                    }
                                                                    } className="form-control border-0 shadow-none text-center " />



                                                            </td>
                                                        )
                                                    }
                                                    )}
                                                </tr>
                                            ))}

                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget}</td>
                                                <td className='text-center'>{totalAchieved}</td>
                                                {/* {dates.map((date, idx) => (
                                                    <td key={date}>
                                                        <input type="text" className="form-control border-0 shadow-none" disabled />
                                                    </td>
                                                ))} */}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className="d-flex justify-content-end">
                                    {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                    {/* <button type="submit" onClick={handleSubmit} className="btn btn-primary btn-sm">Save</button> */}
                                </div>
                            </div>
                        </div>
                        {/*  Walkins */}
                        <div className="tab-pane fade show " id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabIndex="0">
                            <div>
                                <div className='mt-4 table-responsive'>
                                    <table className="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '500px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr>
                                                <th scope="col" className='ms-3' style={{ minWidth: '200px' }}>Walkins</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Target</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {Walkinsget.map((activity, mainindex) => (
                                                <tr key={mainindex}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}

                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.Total_Achived}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map((date) => {
                                                        let obj = activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date)
                                                        console.log("sxdasdad", obj);
                                                        // console.log(formattedCurrentDate);
                                                        console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                        return (
                                                            <td key={date}>

                                                                <input type="number" disabled={formattedCurrentDate != date}
                                                                    value={obj && obj.achieved}
                                                                    onChange={(e) => {

                                                                        if (obj) {
                                                                            handleInputChange(obj.Date, obj.achieved, obj.id, Number(e.target.value))
                                                                        }
                                                                    }
                                                                    } className="form-control border-0 shadow-none text-center " />



                                                            </td>
                                                        )
                                                    }
                                                    )}
                                                </tr>
                                            ))}

                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget}</td>
                                                <td className='text-center'>{totalAchieved}</td>
                                                {/* {dates.map((date, idx) => (
                                                    <td key={date}>
                                                        <input type="text" className="form-control border-0 shadow-none" disabled />
                                                    </td>
                                                ))} */}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className="d-flex justify-content-end">
                                    {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                    {/* <button type="submit" onClick={handleSubmit} className="btn btn-primary btn-sm">Save</button> */}
                                </div>
                            </div>
                        </div>
                        {/*  Offered */}
                        <div className="tab-pane fade show " id="pills-contact1" role="tabpanel" aria-labelledby="pills-contact-tab1" tabIndex="0">
                            <div>
                                <div className='mt-4 table-responsive'>
                                    <table className="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '500px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr>
                                                <th scope="col" className='ms-3' style={{ minWidth: '200px' }}>Offered</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Target</th>
                                                <th scope="col" className='text-center' style={{ minWidth: '60px' }}>Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {Offeredget.map((activity, mainindex) => (
                                                <tr key={mainindex}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}

                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.Total_Achived}
                                                            className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map((date) => {
                                                        let obj = activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date)
                                                        console.log("sxdasdad", obj);
                                                        // console.log(formattedCurrentDate);
                                                        console.log("----", activitiesgetdaily_achives[mainindex].find((obj) => obj.Date == date));
                                                        return (
                                                            <td key={date}>

                                                                <input type="number" disabled={formattedCurrentDate != date}
                                                                    value={obj && obj.achieved}
                                                                    onChange={(e) => {

                                                                        if (obj) {
                                                                            handleInputChange(obj.Date, obj.achieved, obj.id, Number(e.target.value))
                                                                        }
                                                                    }
                                                                    } className="form-control border-0 shadow-none text-center " />



                                                            </td>
                                                        )
                                                    }
                                                    )}
                                                </tr>
                                            ))}

                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget}</td>
                                                <td className='text-center'>{totalAchieved}</td>
                                                {/* {dates.map((date, idx) => (
                                                    <td key={date}>
                                                        <input type="text" className="form-control border-0 shadow-none" disabled />
                                                    </td>
                                                ))} */}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className="d-flex justify-content-end">
                                    {/* <button type="button" onClick={handleAddActivity} className="btn btn-primary">Add Activity</button> */}
                                    {/* <button type="submit" onClick={handleSubmit} className="btn btn-primary btn-sm">Save</button> */}
                                </div>
                            </div>
                        </div>



                    </div>
                </div>
            </div>
        </div>
    );
};

export default Sample_acti;
