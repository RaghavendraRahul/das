import React, { createContext, useEffect, useState } from 'react'
import { port } from '../App'
import axios from 'axios'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'




export const HrmStore = createContext()
const HrmContext = (props) => {
    let [trigger, setTrigger] = useState()
    let [openNavbar, setNavbar] = useState(false)
    let empid = JSON.parse(sessionStorage.getItem('user'))
    let [leaveRequestsReporting, setLeaveRequestReporting] = useState()
    let [pendingLeave, setPendingLeave] = useState()
    let [leaveData, setLeaveData] = useState()
    let [designation, setDesignation] = useState()
    let [religion, setReligion] = useState()
    let [preTaxDeduction, setPreTaxDeduction] = useState()
    let [postTaxDeduction, setPostDeduction] = useState()
    let [templates, setTemplates] = useState()
    let [allShiftTiming, setAllShiftTiming] = useState()
    let [activeEmployee, setActiveEmployees] = useState()
    let [employeeData, setEmployeeData] = useState()

    const [isInsideOffice, setIsInsideOffice] = useState(false);
    let [topnav, setTopNav] = useState()
    let getEmployeeData = () => {
        let id = JSON.parse(sessionStorage.getItem('dasid'))
        if (id) {
            axios.get(`${port}/root/ems/EmployeeProfile/${id}/`).then((response) => {
                console.log(response.data?.EmployeeInformation, 'emp personal');
                setEmployeeData(response.data?.EmployeeInformation);
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let getActiveEmployee = () => {
        let dasid = JSON.parse(sessionStorage.getItem('dasid'))
        if (dasid) {
            axios.get(`${port}/root/ems/AllEmployeesList/${dasid}/?emp_status=active`).then(res => {
                setActiveEmployees(res.data);
            }).catch(err => {
                console.log('AllEmployee_err', err);
            });
        }
    }
    let getAllShiftTiming = () => {
        axios.get(`${port}/root/lms/shifts/`).then((response) => {
            setAllShiftTiming(response.data)
            console.log(response.data, 'shift');
        }).catch((error) => {
            console.log(error);
        })
    }
    let getTemplate = () => {
        axios.get(`${port}/root/pms/SalaryTemplates`).then((response) => {
            setTemplates(response.data)
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }
    let getPreTaxDeduction = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating?type=Pre_Tax_Deduction`).then((response) => {
            console.log("earn", response.data);
            setPreTaxDeduction(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getPostTaxDeduction = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating?type=Post_Tax_Deduction`).then((response) => {
            console.log("earn", response.data);
            setPostDeduction(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getReligion = () => {
        axios.get(`${port}/root/ems/Religions/`).then((response) => {
            console.log(response.data);
            setReligion(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getLeaveData = () => {
        axios.get(`${port}/root/lms/LeaveTypes/`).then((response) => {
            setLeaveData(response.data)
            console.log(response.data);
        }).catch((error) => {
            console.log(error);
        })
    }

    let user = JSON.parse(sessionStorage.getItem('user'))
    let [count, setCount] = useState({
        employeePage: false,
        offeraproval: false,
        leavepage: false,
        leaveApproval: false
    })
    let getApprovalRequest = () => {
        if (user) {
            axios.get(`${port}/root/OfferLetterApprovalList/${user.EmployeeId}/`).then((response) => {
                console.log("hellow", response.data);
                if (response.data && response.data.length > 0) {
                    setCount((prev) => ({
                        ...prev,
                        employeePage: true,
                        offeraproval: true
                    }))
                }
            }).catch((error) => {
                console.log("hellow", error);
            })
        }
    }
    useEffect(() => {
        getReligion()
        getApprovalRequest()
        getPreTaxDeduction()
        getPostTaxDeduction()
        getActiveEmployee()
    }, [])
    function convertToReadableDateTime(isoDateTime) {
        const date = new Date(isoDateTime);
        // Extract the date components
        const day = date.getDate();
        const month = date.getMonth() + 1; // Months are zero-based
        const year = date.getFullYear() % 100;

        // Extract the time components
        let hours = date.getHours();
        const minutes = date.getMinutes();
        const ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12 || 12; // Convert to 12-hour format
        // Format the date and time
        const formattedDate = `${day}-${month}-${year}`;
        const formattedTime = `${hours}:${minutes.toString().padStart(2, '0')} ${ampm}`;
        return `${formattedDate} ${formattedTime}`;
    }
    function getCurrentDate() {
        let datenow = new Date()
        return `${datenow.getDate()}/${datenow.getMonth()}/${datenow.getFullYear()}`
    }
    function formatDate(dateString) {
        const months = [
            "January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"
        ];
        if (dateString == null)
            return false

        const dateParts = dateString.split("-");
        const year = dateParts[0];
        const month = months[parseInt(dateParts[1], 10) - 1];
        const day = dateParts[2];

        return `${day} ${month} ${year}`;
    }
    function getMonthYear(dateString) {
        const months = [
            "January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"
        ];

        const dateParts = dateString.split("-");
        const year = dateParts[0];
        const month = months[parseInt(dateParts[1], 10) - 1];

        return `${month} ${year}`;
    }
    function formatTime(timeStr) {
        const [hours, minutes] = timeStr.split(':').map(Number);
        let formattedTime = '';

        if (hours > 0) {
            formattedTime += `${hours} hr${hours > 1 ? 's' : ''} `;
        }
        if (minutes > 0 || hours === 0) { // Show minutes even if hours is 0
            formattedTime += `${minutes} min${minutes > 1 ? 's' : ''}`;
        }

        return formattedTime.trim();
    }
    function formatISODate(isoString) {
        const [time] = isoString.split('+');
        const [hours, minutes, seconds] = time.split(':');

        // Convert hours to number
        let hoursNumber = parseInt(hours, 10);

        // Determine AM/PM suffix
        const period = hoursNumber >= 12 ? 'PM' : 'AM';

        // Convert hours from 24-hour to 12-hour format
        hoursNumber = hoursNumber % 12 || 12;  // Adjust 0 to 12 for midnight case

        // Format hours and minutes
        const formattedHours = hoursNumber;
        const formattedMinutes = minutes;

        // Construct the 12-hour time format
        const formattedTime = `${formattedHours}:${formattedMinutes} ${period}`;

        return formattedTime;
    }

    // Example usage
    const isoString = "2024-06-17T14:06:20+05:30";
    const formattedDateTime = formatISODate(isoString);
    console.log(formattedDateTime);  // Outputs: "06/17/2024 2:06:20 PM"

    function convertTimeTo12HourFormat(time) {
        // Split the time into hours, minutes, and seconds
        const [hours, minutes, seconds] = time.split(':');

        // Convert hours from string to number
        let hoursNumber = parseInt(hours, 10);

        // Determine AM/PM suffix
        const period = hoursNumber >= 12 ? 'PM' : 'AM';

        // Convert hours from 24-hour to 12-hour format
        hoursNumber = hoursNumber % 12 || 12;  // Adjust 0 to 12 for midnight case

        // Format hours and minutes
        const formattedHours = hoursNumber;
        const formattedMinutes = minutes;

        // Construct the 12-hour time format
        const formattedTime = `${formattedHours}:${formattedMinutes} ${period}`;

        return formattedTime;
    }
    function timeValidate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    function timeLastMonthValidate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        return `${year}-${month - 1}-${day}`;
    }
    function getProperDate(date) {
        if (!date) return "";
        const now = new Date(date);
        if (isNaN(now.getTime())) return "";
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    function changeDateYear(date) {
        const [year, mnth, day] = date.split('-')
        return `${day}-${mnth}-${year}`
    }
    let testing = "hellow"
    function convertToNormalTime(timeString) {
        // Split the time string into hours, minutes, and seconds
        const [hours, minutes, seconds] = timeString.split(':').map(Number);
        // Determine AM or PM
        const ampm = hours >= 12 ? 'PM' : 'AM';
        // Convert hours from 24-hour to 12-hour format
        const normalHours = hours % 12 || 12; // Adjust hours, converting 0 to 12 for 12 AM
        // Format the time string
        const formattedTime = `${normalHours}:${minutes.toString().padStart(2, '0')} ${ampm}`;
        return formattedTime;
    }
    let getDesignations = () => {
        axios.get(`${port}/root/ems/Designations/`).then((response) => {
            console.log(response.data);
            setDesignation(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    function calculateAge(dob) {
        const dobDate = new Date(dob);

        // Get today's date
        const today = new Date();

        // Calculate the difference in years
        let age = today.getFullYear() - dobDate.getFullYear();

        // Adjust for the month and day
        const monthDiff = today.getMonth() - dobDate.getMonth();
        const dayDiff = today.getDate() - dobDate.getDate();

        // If the current month is before the birth month
        // or it's the birth month but the day hasn't passed yet, reduce the age by 1
        if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
            age--;
        }
        return age;
    }
    let [activePage, setActivePage] = useState('dashboard')
    let mailContent = {
        reject: `
Thank you for applying for the position at Merida Tech Minds and for your interest in joining our team. After a careful review of your application, we regret to inform you that we have decided to move forward with other candidates whose skills, experience, qualifications, and overall fitment more closely align with the position requirements.

We greatly appreciate the time and effort in the interview process. Please be assured that your information will remain in our system for future opportunities that match your skills and experience. We encourage you to regularly visit our Career Site and sign up for job alerts to stay informed about new openings that align with your career goals.

Thank you once again for considering Merida Tech Minds as a potential employer. We wish you the best of luck in your future job search and hope to have the opportunity to connect with you again in the future.

Best regards,
Talent Acquisition Team
Merida Tech Minds (OPC) Pvt. Ltd.`,
        selected: `
Congratulations!!

After carefully evaluating your skill set, experience, qualifications, and overall fit, we are pleased to inform you that you have been selected for the position of [Position] at Merida Tech Minds.

To move forward, please provide the necessary information and supporting documents to complete your background verification checks before offering. We are confident that you will make significant contributions to our organization.

Best regards,
Talent Acquisition Team
Merida Tech Minds (OPC) Pvt. Ltd.`,
        consider_to_client: `
Thank you for applying for the position at Merida Tech Minds. After carefully reviewing your application, we believe you would be a better fit for our client requirements, where your career goals, skills, and experience align well.

We greatly appreciate the time and effort in the interview process. Please be assured that your information will remain in our system for future opportunities that match our client requirements.

We wish you the best of luck in your job search and hope to have the opportunity to connect with you again in the future.

Best regards,
Talent Acquisition Team(HR)
Merida Tech Minds (OPC) Pvt. Ltd.`,
        on_hold: `Thank you for applying for the position at Merida Tech Minds. We are currently in the process of reviewing your application, and it is taking longer than our usual timeframe.

We will keep you informed once we have reached a conclusion regarding your candidature.

We greatly appreciate your time and effort in the interview process. Please be assured that your information will remain in our system for further processing.

Best regards,
Talent Acquisition Team (HR)
Merida Tech Minds (OPC) Pvt. Ltd.`
    }
    let [activeSetting, setActiveSetting] = useState('')

    let getPendingLeave = () => {
        axios.get(`${port}/root/lms/EmployeeLeavesPending/${empid.EmployeeId}/`).then((response) => {
            console.log(response.data);
            setPendingLeave(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let getLeaveRequestsReporting = () => {
        if (empid) {
            axios.get(`${port}/root/lms/Reporting/Employee/PendingLeaves/${empid.EmployeeId}/`).then((response) => {
                setLeaveRequestReporting(response.data)
                if (response.data && response.data.length > 0) {
                    setCount((prev) => ({
                        ...prev,
                        leavepage: true,
                        leaveApproval: true
                    }))
                }
                console.log("leave", response.data);
            }).catch((error) => {
                console.log(error);
            })
        }
    }
    let [data, setData] = useState()

    let getEarningData = () => {
        axios.get(`${port}/root/pms/AllowanceTemplateCreating?type=Earning`).then((response) => {
            console.log("earn", response.data);
            setData(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let deleteSalaryComponent = (id) => {
        axios.delete(`${port}/root/pms/AllowanceDelete/${id}/`).then((response) => {
            toast.success('Component deleted successfully')
            getPreTaxDeduction()
            getPostTaxDeduction()
            getEarningData()
        }).catch((error) => {
            toast.error('Error acquired')
            console.log(error);
        })
    }
    function numberToWords(num) {
        console.log(num);
        const ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
        const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

        if (num === 0) return 'Zero';

        function convertToWords(n) {
            if (n < 20) return ones[n];
            if (n < 100) return tens[Math.floor(n / 10)] + (n % 10 !== 0 ? ' ' + ones[n % 10] : '');
            if (n < 1000) return ones[Math.floor(n / 100)] + ' Hundred' + (n % 100 !== 0 ? ' ' + convertToWords(n % 100) : '');
            if (n < 100000) return convertToWords(Math.floor(n / 1000)) + ' Thousand' + (n % 1000 !== 0 ? ' ' + convertToWords(n % 1000) : '');
            if (n < 10000000) return convertToWords(Math.floor(n / 100000)) + ' Lakh' + (n % 100000 !== 0 ? ' ' + convertToWords(n % 100000) : '');
            return convertToWords(Math.floor(n / 10000000)) + ' Crore' + (n % 10000000 !== 0 ? ' ' + convertToWords(n % 10000000) : '');
        }

        return convertToWords(num);
    }
    function convertTo12Hour(time24) {
        let [hours, minutes] = time24.split(':');
        hours = parseInt(hours);

        const period = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12 || 12; // Converts '0' hour to '12' for AM, and '12' hour for PM

        return `${hours}:${minutes} ${period}`;
    }
    function selectValueToNormal(value) {
        return value.replace(/_/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase())
    }
    let valueShare = {
        getEmployeeData, employeeData, trigger, setTrigger, isInsideOffice, setIsInsideOffice,
        formatTime, timeLastMonthValidate, convertTo12Hour, allShiftTiming, getAllShiftTiming, setAllShiftTiming, getActiveEmployee,
        deleteSalaryComponent, getEarningData, data, getMonthYear, getTemplate, templates, numberToWords, activeEmployee, calculateAge,
        religion, getReligion, count, formatDate, preTaxDeduction, postTaxDeduction, getPreTaxDeduction, getPostTaxDeduction,
        getPendingLeave, pendingLeave, setPendingLeave, leaveRequestsReporting, setLeaveRequestReporting, getLeaveRequestsReporting,
        changeDateYear, activeSetting, setActiveSetting, mailContent, openNavbar, setNavbar, convertToNormalTime, activePage, setActivePage,
        leaveData, setLeaveData, getLeaveData, getDesignations, designation, setDesignation, topnav, setTopNav, selectValueToNormal,
        timeValidate, getProperDate, getCurrentDate, convertToReadableDateTime, testing, convertTimeTo12HourFormat, formatISODate
    }
    return (
        <HrmStore.Provider value={valueShare} >
            {props.children}
        </HrmStore.Provider>
    )
}

export default HrmContext