import axios from "axios";
import React, { useEffect, useState } from "react";
import { toast } from "react-toastify";
import { port } from "../../App";
import { useContext } from "react";
import { HrmStore } from "../../Context/HrmContext";

const GetGeoLocation = () => {
    let [move, setMove] = useState(false)
    let empId = JSON.parse(sessionStorage.getItem('dasid'))
    const [location, setLocation] = useState({ latitude: null, longitude: null });
    const [error, setError] = useState(null);
    const [distance, setDistance] = useState(null);
    const { isInsideOffice, setIsInsideOffice } = useContext(HrmStore);
    // 12.937286537079776, 77.58230830829295
    const officeLocation = { latitude: 12.937286537079776, longitude: 77.58230830829295 }; // Replace with your office location
    const radius = 50; // 50 meters radius

    const calculateDistance = (lat1, lon1, lat2, lon2) => {
        const R = 6371000; // Earth's radius in meters
        const toRadians = (degree) => (degree * Math.PI) / 180;

        const dLat = toRadians(lat2 - lat1);
        const dLon = toRadians(lon2 - lon1);

        const a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);

        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c; // Distance in meters
    };
    let getTracking = () => {
        let currentDate = new Date()
        currentDate = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1).toString()?.padStart(2, 0)}-${currentDate.getDate().toString()?.padStart(2, 0)}`
        console.log(currentDate, 'Tracking time');

        axios.get(`${port}/root/lms/UpdateEmployeeAttendanceManually/?emp_id=${JSON.parse(sessionStorage.getItem('dasid'))}&date=${currentDate}`).then((response) => {
            console.log(response.data?.current_punch, 'Tracking time');

            setMove(response.data.current_punch)
        }).catch((error) => {
            console.log(error, 'Tracking time');

            setMove(false)
        })
    }
    useEffect(() => {
        getTracking()
    }, [])
    const getLocation = () => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    console.log('Accuracy:', position.coords.accuracy, 'meters');
                    if (position.coords.accuracy > 100) {
                        setError("Location accuracy is too low. Please try again.");
                        return;
                    }
                    const userLatitude = position.coords.latitude;
                    const userLongitude = position.coords.longitude;

                    setLocation({
                        latitude: userLatitude,
                        longitude: userLongitude,
                    });
                    const calculatedDistance = calculateDistance(
                        userLatitude,
                        userLongitude,
                        officeLocation.latitude,
                        officeLocation.longitude
                    );
                    setDistance(calculatedDistance);
                    setIsInsideOffice(calculatedDistance <= radius);
                    setError(null);
                },
                (error) => {
                    // Handle errors...
                },
                { enableHighAccuracy: true }
            );
        } else {
            setError("Geolocation is not supported by this browser.");
        }
    };


    useEffect(() => {
        getLocation();
    }, []);
    let markTime = async () => {
        axios.post(`${port}/root/lms/AttendanceRecordCreate?emp_id=${empId}`).then((response) => {
            toast.success('Timing has been recorded')
            getTracking()
        }).catch((error) => {
            console.log(error);
        })
    }
    let trackTiming = (reject) => {
        if (isInsideOffice || reject) {
            let time = new Date()
            let hour = time.getHours()
            // if (reject && move && hour >= 13 && hour < 15) {
            //     setTimeout(() => {
            //         markTime()
            //     }, 1000 * 60 * 46);
            // }
            markTime()
        } else {
            toast.warning(`Your away from office location like ${distance && distance.toFixed(2)} 
            meters, try it once reached the office`)
        }
    }
    return (
        <div className="text-center " >
            {/* {error && <p style={{ color: "red" }}>{error}</p>} */}
            {/* <button onClick={trackTiming}
                className={` ${isInsideOffice ? 'bg-green-500 ' : ' bg-red-500 '} p-2 rounded text-slate-100 `} >
                In/Out
            </button> */}
            <span className={` text-xs text-center ${isInsideOffice ? 'text-green-700' : 'text-red-600'} poppins fw-semibold`} >
                {(isInsideOffice) ? "Enabled" : 'Disabled'} </span>
            <main className=" flex items-center gap-2 " >
                <span className={` ${!move ? 'fw-semibold ' : ''}  text-red-600 `} > Out </span>
                {<button onClick={() => trackTiming()} disabled={!isInsideOffice}
                    className={`w-[3rem] flex items-center h-[1.4rem] bg-slate-500 rounded-xl shadow-sm `} >
                    <div className={` h-[1.2rem] w-[1.2rem] rounded-full shadow-sm duration-500
                         bg-slate-50 ${move ? 'translate-x-[1.6rem] ' : "translate-x-1 "} `} >
                    </div>
                </button>
                }
                <span className={` ${move ? 'fw-semibold  ' : ''} text-teal-700 `} > IN </span>
            </main>
            {/* {!error && location.latitude && location.longitude && (
                <>

                    <p>Current Latitude: {location.latitude}</p>
                    <p>Current Longitude: {location.longitude}</p>
                    <p>Distance from Office: {distance ? `${distance.toFixed(2)} meters` : "Calculating..."}</p>
                    <p>
                        Status:{" "}
                        <strong style={{ color: isInsideOffice ? "green" : "red" }}>
                            {isInsideOffice ? "Inside Office" : "Outside Office"}
                        </strong>
                    </p>
                </>
            )} */}
        </div>
    );
};

export default GetGeoLocation;
