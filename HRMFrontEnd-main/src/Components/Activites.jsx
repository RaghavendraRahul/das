
import Sidebar from './Sidebar';
import Topnav from './Topnav';
import { port } from '../App'
import { useEffect, useState } from 'react';
import axios from 'axios';


const generateDates = () => {
    const dates = [];
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth(); // zero-indexed (0 for January, 1 for February, etc.)
    
    const date = new Date(year, month, 1);

    while (date.getMonth() === month) {
        // Manually format the date to dd/mm/yyyy
        const day = String(date.getDate()).padStart(2, '0');
        const monthFormatted = String(date.getMonth() + 1).padStart(2, '0');
        const yearFormatted = date.getFullYear();
        
        const formattedDate = `${day}/${monthFormatted}/${yearFormatted}`;
        dates.push(formattedDate);
        
        date.setDate(date.getDate() + 1);
    }
    return dates;
};


const YourComponent = () => {

    let Empid = JSON.parse(sessionStorage.getItem('user')).EmployeeId


    // Activities Start

  
    const currentDate = new Date();

    const formatDate = (date) => {
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0'); // month + 1 because months are zero-indexed
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
    };
    
    const formattedCurrentDate = formatDate(currentDate);



  



    const [activities, setActivities] = useState([
        { Employee: Empid, Activity_Name: '', targets: '', achieved: '', inputs: {} }
    ]);
    const [activitiesget, setgetActivities] = useState([]);
    const [id, setid] = useState("");

    const [month, setMonth] = useState(4); // May (0-indexed)
    const [year, setYear] = useState(2024);
    const dates = generateDates(month, year);

    const handleAddActivity = () => {
        setActivities([...activities, { Employee: Empid, Activity_Name: '', targets: '', achieved: '', inputs: {} }]);
    };

    const handleInputChange = (index, date, value,id) => {

        console.log( "eneter",id,index,date,value);

        const formData = new FormData();

        formData.append('Activity_instance', id);
        formData.append('index', index);
        formData.append('achieved_Date', date);
        formData.append('achieved', Number(value));

        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
          }

        axios.post(`${port}root/daily_achives`,formData).then((res) => {
            console.log("activity_date_res", res.data);
           
        }).catch((err) => {

            console.log("activity_date_err", err.data);

        })  
    };

    const handleChange = (index, field, value,id) => {

        console.log("activiti_name", index, field, value,id);

        setActivities((prev) => {
            let newarry = [...prev]
            newarry[index][field] = value
            return newarry
        })
    };

    const Activity_get_res = () => {

        axios.get(`${port}root/activity/${Empid}/`).then((res) => {
            console.log("activity_get_res", res.data);
            setgetActivities(res.data)

        }).catch((err) => {

            console.log("activity_get_err", err.data);

        })

    }

    useEffect(() => {

        Activity_get_res();

    }, [])

    const handleSubmit = (e) => {
        e.preventDefault()



        console.log(activities);

        axios.post(`${port}root/activity`, {
            "id": Empid,
            "Activity_Name": activities
        }).then((res) => {
            console.log("activity_res", res.data);
            alert("Activity Add Successfully..")
            
            setActivities([
                { Employee: Empid, Activity_Name: '', targets: '', achieved: '', inputs: {} }
            ])
            
            Activity_get_res();


        }).catch((err) => {

            console.log("activity_err", err.data);

        })

    };

    const calculateTotal = (field) => {
        return activities.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget = calculateTotal('target');
    const totalAchieved = calculateTotal('achieved');








    // Activities End


    // Interview Scheduled Start



    const [activities1, setActivities1] = useState([
        { name: 'Digital Marketing Manager', target: '', achieved: '', inputs: {} },
        { name: 'Business Dev Manger', target: '', achieved: '', inputs: {} },
        { name: 'Web Developer', target: '', achieved: '', inputs: {} }

    ]);

    const handleAddActivity1 = () => {
        setActivities1([...activities1, { name: '', target: '', achieved: '', inputs: {} }]);
    };

    const handleInputChange1 = (index, date, value) => {
        const updatedActivities = [...activities1];
        updatedActivities[index].inputs[date] = value;
        setActivities1(updatedActivities);
    };

    const handleChange1 = (index, field, value) => {
        const updatedActivities = [...activities1];
        updatedActivities[index][field] = value;
        setActivities1(updatedActivities);
    };

    const handleSubmit1 = () => {
        console.log(activities1);
        // Further processing here
    };

    const calculateTotal1 = (field) => {
        return activities1.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget1 = calculateTotal1('target');
    const totalAchieved1 = calculateTotal1('achieved');
    // Interview Scheduled End

    // Walkins Start

    const [activities2, setActivities2] = useState([

        { name: 'Web Developer', target: '', achieved: '', inputs: {} },
        { name: 'Counselor', target: '', achieved: '', inputs: {} },
        { name: 'Recruiter', target: '', achieved: '', inputs: {} },
        { name: 'Graphic Designer', target: '', achieved: '', inputs: {} }
    ]);

    const handleAddActivity2 = () => {
        setActivities2([...activities2, { name: '', target: '', achieved: '', inputs: {} }]);
    };

    const handleInputChange2 = (index, date, value) => {
        const updatedActivities = [...activities2];
        updatedActivities[index].inputs[date] = value;
        setActivities2(updatedActivities);
    };

    const handleChange2 = (index, field, value) => {
        const updatedActivities = [...activities2];
        updatedActivities[index][field] = value;
        setActivities2(updatedActivities);
    };

    const handleSubmit2 = () => {
        console.log(activities2);
        // Further processing here
    };

    const calculateTotal2 = (field) => {
        return activities2.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget2 = calculateTotal2('target');
    const totalAchieved2 = calculateTotal2('achieved');

    // Walkins End

    // Offered Start

    const [activities3, setActivities3] = useState([


        { name: 'Centre Head', target: '', achieved: '', inputs: {} },
        { name: 'Content Writer', target: '', achieved: '', inputs: {} }
    ]);

    const handleAddActivity3 = () => {
        setActivities3([...activities3, { name: '', target: '', achieved: '', inputs: {} }]);
    };

    const handleInputChange3 = (index, date, value) => {
        const updatedActivities = [...activities3];
        updatedActivities[index].inputs[date] = value;
        setActivities3(updatedActivities);
    };

    const handleChange3 = (index, field, value) => {
        const updatedActivities = [...activities3];
        updatedActivities[index][field] = value;
        setActivities3(updatedActivities);
    };

    const handleSubmit3 = () => {
        console.log(activities3);
        // Further processing here
    };

    const calculateTotal3 = (field) => {
        return activities3.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget3 = calculateTotal3('target');
    const totalAchieved3 = calculateTotal3('achieved');

    // Offered End

    // Othres Start
    const [activities4, setActivities4] = useState([


        { name: '', target: '', achieved: '', inputs: {} },
    ]);

    const handleAddActivity4 = () => {
        setActivities4([...activities4, { name: '', target: '', achieved: '', inputs: {} }]);
    };

    const handleInputChange4 = (index, date, value) => {
        const updatedActivities = [...activities4];
        updatedActivities[index].inputs[date] = value;
        setActivities4(updatedActivities);
    };

    const handleChange4 = (index, field, value) => {
        const updatedActivities = [...activities4];
        updatedActivities[index][field] = value;
        setActivities4(updatedActivities);
    };

    const handleSubmit4 = () => {
        console.log(activities4);
        // Further processing here
    };

    const calculateTotal4 = (field) => {
        return activities4.reduce((total, activity) => {
            return total + (parseFloat(activity[field]) || 0);
        }, 0);
    };

    const totalTarget4 = calculateTotal4('target');
    const totalAchieved4 = calculateTotal4('achieved');


    // Othres End



    return (

        <div className=' d-flex' style={{ width: '100%', minHeight : '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4 ps-1 ps-sm-2 ps-md-4 side-blog' style={{ borderRadius: '10px' }}>

                <div style={{ position: "relative", left: '20px' }}>
                    <Topnav ></Topnav>
                </div>

                <div className='mt-3 inner_sections' >

                    <div className='d-flex justify-content-between'>

                        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Activities</h6>
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

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab2" data-bs-toggle="pill" data-bs-target="#pills-contact2" type="button" role="tab" aria-controls="pills-contact2" aria-selected="false">Others</h6>
                            </li>




                        </ul>
                        <div className='mt-3'>
                            <input type="month" />
                        </div>

                    </div>



                    <div class="tab-content " id="pills-tabContent" style={{ position: 'relative', bottom: '20px' }}>
                        <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">

                            <div>

                                <div className=' mt-4 table-responsive'>
                                    <table className="table table-bordered ">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '650px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr >
                                                <th scope="col" className='ms-3'>Activity Name</th>
                                                <th scope="col " className='text-center'>Target</th>
                                                <th scope="col" className='text-center'>Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activitiesget.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}
                                                            onChange={(e) =>
                                                                handleChange(index, 'Activity_Name', e.target.value)}
                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}

                                                            onChange={(e) => handleChange(index, 'targets', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.achieved}

                                                            onChange={(e) => handleChange(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => {

                                                        return (
                                                            <td key={date}>
                                                                <input disabled={formattedCurrentDate != date} type="number"
                                                                    //  value={activity.targets[date] || ''} 
                                                                    onChange={(e) =>
                                                                        handleInputChange(index, date, e.target.value,activity.id)


                                                                    } className="form-control border-0 shadow-none" />
                                                            </td>
                                                        )
                                                    }
                                                    )}
                                                </tr>
                                            ))}


                                            {activities.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text"
                                                            value={activity.Activity_Name}
                                                            onChange={(e) =>
                                                                handleChange(index, 'Activity_Name', e.target.value)}
                                                            className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.targets}

                                                            onChange={(e) => handleChange(index, 'targets', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number"
                                                            value={activity.achieved}

                                                            onChange={(e) => handleChange(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => {

                                                        return (
                                                            <td key={date}>
                                                                <input disabled={currentDate.toLocaleDateString() != date} type="text"
                                                                    //  value={activity.inputs[date] || ''} 
                                                                    onChange={(e) =>
                                                                        handleInputChange(index, date, e.target.value)


                                                                    } className="form-control border-0 shadow-none" />
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
                                                {dates.map((date, idx) => (
                                                    <td key={idx}></td>
                                                ))}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className='mt-3 d-flex justify-content-end'>
                                    {/* <button onClick={handleAddActivity} className='btn btn-sm btn-warning'>Add Activity</button> */}
                                    <button onClick={handleSubmit} className='btn btn-sm btn-success ms-4'>Save</button>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">

                            <div>

                                <div className=' mt-4 table-responsive'>
                                    <table className="table table-bordered ">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '650px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr className='text-center'>
                                                <th scope="col">Interview Scheduled</th>
                                                <th scope="col">Target</th>
                                                <th scope="col">Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activities1.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text" value={activity.name} onChange={(e) => handleChange1(index, 'name', e.target.value)} className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.target} onChange={(e) => handleChange1(index, 'target', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.achieved} onChange={(e) => handleChange1(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => (
                                                        <td key={date}>
                                                            <input type="text" value={activity.inputs[date] || ''} onChange={(e) => handleInputChange1(index, date, e.target.value)} className="form-control border-0 shadow-none" />
                                                        </td>
                                                    ))}
                                                </tr>
                                            ))}
                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget1}</td>
                                                <td className='text-center'>{totalAchieved1}</td>
                                                {dates.map((date, idx) => (
                                                    <td key={idx}></td>
                                                ))}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className='mt-3 d-flex justify-content-between'>
                                    <button onClick={handleAddActivity1} className='btn btn-sm btn-warning'>Add Interview Scheduled</button>
                                    <button onClick={handleSubmit1} className='btn btn-sm btn-success ms-4'>Save</button>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">

                            <div>

                                <div className=' mt-4 table-responsive'>
                                    <table className="table table-bordered ">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '550px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr className='text-center'>
                                                <th scope="col">WalkIns</th>
                                                <th scope="col">Target</th>
                                                <th scope="col">Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activities2.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text" value={activity.name} onChange={(e) => handleChange2(index, 'name', e.target.value)} className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.target} onChange={(e) => handleChange2(index, 'target', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.achieved} onChange={(e) => handleChange2(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => (
                                                        <td key={date}>
                                                            <input type="text" value={activity.inputs[date] || ''} onChange={(e) => handleInputChange2(index, date, e.target.value)} className="form-control border-0 shadow-none" />
                                                        </td>
                                                    ))}
                                                </tr>
                                            ))}
                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget2}</td>
                                                <td className='text-center'>{totalAchieved2}</td>
                                                {dates.map((date, idx) => (
                                                    <td key={idx}></td>
                                                ))}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className='mt-3 d-flex justify-content-between'>
                                    <button onClick={handleAddActivity2} className='btn btn-sm btn-warning'>Add Walkins</button>
                                    <button onClick={handleSubmit2} className='btn btn-sm btn-success ms-4'>Save</button>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="pills-contact1" role="tabpanel" aria-labelledby="pills-contact-tab1" tabindex="0">

                            <div>

                                <div className=' mt-4 table-responsive'>
                                    <table className="table table-bordered ">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '550px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr className='text-center'>
                                                <th scope="col">Offerd</th>
                                                <th scope="col">Target</th>
                                                <th scope="col">Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activities3.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text" value={activity.name} onChange={(e) => handleChange3(index, 'name', e.target.value)} className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.target} onChange={(e) => handleChange3(index, 'target', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.achieved} onChange={(e) => handleChange3(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => (
                                                        <td key={date}>
                                                            <input type="text" value={activity.inputs[date] || ''} onChange={(e) => handleInputChange3(index, date, e.target.value)} className="form-control border-0 shadow-none" />
                                                        </td>
                                                    ))}
                                                </tr>
                                            ))}
                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget3}</td>
                                                <td className='text-center'>{totalAchieved3}</td>
                                                {dates.map((date, idx) => (
                                                    <td key={idx}></td>
                                                ))}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className='mt-3 d-flex justify-content-between'>
                                    <button onClick={handleAddActivity3} className='btn btn-sm btn-warning'>Add Offered</button>
                                    <button onClick={handleSubmit3} className='btn btn-sm btn-success ms-4'>Save</button>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="pills-contact2" role="tabpanel" aria-labelledby="pills-contact-tab2" tabindex="0">

                            <div>

                                <div className=' mt-4 table-responsive'>
                                    <table className="table table-bordered ">
                                        <thead>
                                            <tr>
                                                <th scope="col" colSpan={3} className='text-center' style={{ minWidth: '500px' }}>Date</th>
                                                {dates.map(date => (
                                                    <th key={date} rowSpan={2} className='text-center pb-4'>{date}</th>
                                                ))}
                                            </tr>
                                            <tr className='text-center'>
                                                <th scope="col">Othres</th>
                                                <th scope="col">Target</th>
                                                <th scope="col">Achieved</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {activities4.map((activity, index) => (
                                                <tr key={index}>
                                                    <td>
                                                        <input type="text" value={activity.name} onChange={(e) => handleChange4(index, 'name', e.target.value)} className="form-control border-0 shadow-none" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.target} onChange={(e) => handleChange4(index, 'target', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    <td>
                                                        <input type="number" value={activity.achieved} onChange={(e) => handleChange4(index, 'achieved', e.target.value)} className="form-control border-0 shadow-none text-center" />
                                                    </td>
                                                    {dates.map(date => (
                                                        <td key={date}>
                                                            <input type="text" value={activity.inputs[date] || ''} onChange={(e) => handleInputChange4(index, date, e.target.value)} className="form-control border-0 shadow-none" />
                                                        </td>
                                                    ))}
                                                </tr>
                                            ))}
                                            <tr>
                                                <td className='ps-3'>Total</td>
                                                <td className='text-center'>{totalTarget4}</td>
                                                <td className='text-center'>{totalAchieved4}</td>
                                                {dates.map((date, idx) => (
                                                    <td key={idx}></td>
                                                ))}
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div className='mt-3 d-flex justify-content-between'>
                                    <button onClick={handleAddActivity4} className='btn btn-sm btn-warning'>Add </button>
                                    <button onClick={handleSubmit4} className='btn btn-sm btn-success ms-4'>Save</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>



        </div>
    );
};

export default YourComponent;
