
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


const Actisam = () => {

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
        formData.append('achieved', value);

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




    return (

        <div className=' d-flex' style={{ width: '100%', minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

            <div className='side'>

                <Sidebar value={"dashboard"} ></Sidebar>
            </div>
            <div className=' m-0 m-sm-4 ps-1 ps-sm-2 ps-md-4  side-blog' style={{ borderRadius: '10px' }}>

                <div style={{ position: "relative", left: '20px' }}>
                    <Topnav ></Topnav>
                </div>

                <div className='mt-3 inner_sections' >

                    <div className='d-flex justify-content-between'>

                        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

                            <li class="nav-item text-primary d-flex " role="presentation">
                                <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Activities</h6>
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
                                                                <input disabled={formattedCurrentDate != date} type="text"
                                                                    //  value={activity.inputs[date] || ''} 
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
                   
                    </div>

                </div>

            </div>



        </div>
    );
};

export default Actisam;
