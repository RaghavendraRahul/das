import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../Components/Topnav'
import { HrmStore } from '../Context/HrmContext'
import SearchIcon from '../SVG/SearchIcon'
import ExportIcon from '../SVG/ExportIcon'
import ImportIcon from '../SVG/ImportIcon'
import AttendenceShowingadminTable from '../Components/Tables/AttendenceShowingadminTable'
import axios from 'axios'
import { port } from '../App'
import { toast } from 'react-toastify'
import SwipingDetails from '../Components/Modals/SwipingDetails'
import DownloadContent from '../Components/AuthPermissions/DownloadContent'
import LoadingData from '../Components/MiniComponent/LoadingData'

const AttendenceAdmin = ({ subpage }) => {
  let { activePage, setActivePage, setTopNav } = useContext(HrmStore)
  let { changeDateYear, formatISODate, getProperDate } = useContext(HrmStore)
  let [Department_List, set_Department_List] = useState()
  let [trigger, settrigger] = useState(false)
  let [filterObj, setFilterObj] = useState({
    fromtime: '',
    totime: ''
  })

  let handleChange = (e) => {
    let { name, value } = e.target
    setFilterObj((prev) => ({
      ...prev,
      [name]: value
    }))
  }
  function currentMonthDates() {
    const currentDate = new Date()
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    const startDate = getProperDate(new Date(year, month, 1));
    const endDate = getProperDate(new Date(year, month + 1, 0));
    setFilterObj({
      fromtime: startDate,
      totime: endDate
    })
    getAttendanceList(startDate, endDate)
    console.log(startDate, endDate);
  }
  function formatTime(inputTime) {
    // Split the input time to extract hours and minutes
    const [hours, minutes] = inputTime.split(":");
    let hrs = hours && hours > 0 ? `${hours} h` : ''
    let min = minutes && minutes > 0 ? `${minutes} m` : ''
    return `${hrs} ${min}`;
  }
  let dateNow = new Date()
  let year = []
  let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ]
  for (let i = 1900; i < 2200; i++) {
    year.push(i)
  }
  let [filterDetails, setfilterDetails] = useState({
    year: dateNow.getFullYear(),
    month: dateNow.getMonth() + 1,
    name: ''
  })
  let handleChangeFilterDetails = (e) => {
    let { name, value } = e.target
    setfilterDetails((prev) => ({
      ...prev,
      [name]: value
    }))
  }
  let getDepartment = () => {
    axios.get(`${port}root/ems/Departments/`)
      .then((r) => {
        set_Department_List(r.data)
        console.log("Departments_List_Res", r.data)
      })
      .catch((err) => {
        console.log("Departments_List_Res", err)
      })
  }
  let [attendanceList, setattendanceList] = useState()
  let [filteredAttendanceList, setFilteredAttendanceList] = useState()
  let getAttendanceList = (startDate, endDate) => {

    setLoading('list')
    axios.get(`${port}/root/lms/attendance/${startDate ? startDate : filterObj.fromtime}/${endDate ? endDate : filterObj.totime}/`).then((response) => {
      console.log(response.data, 'Attendance filter');
      setattendanceList(response.data)
      setLoading(false)
    }).catch((error) => {
      console.log(error, 'Attendance filter');
      setLoading(false)
    })

  }
  useEffect(() => {
    if (attendanceList)
      setFilteredAttendanceList(attendanceList)
  }, [attendanceList])
  let [loading, setLoading] = useState(false)
  let uploadAttendence = (e) => {
    setLoading(true)
    let formdata = new FormData()
    formdata.append('file_path', e.target.files[0])
    console.log(e.target.files[0]);
    axios.post(`${port}/root/lms/Bulk_Attendance_Data/`, formdata).then((response) => {
      toast.success('Excel file value uploaded successfully')
      getAttendanceList(filterObj.fromtime, filterObj.totime)
      console.log(response.data);
      setLoading(false)
    }).catch((error) => {
      console.log(error);
      toast.error('error acquired')
      setLoading(false)
    })
  }
  let filterlist = () => {
    let filterarry = attendanceList.filter((obj) => obj.Emp_Id &&
      obj.Emp_Id.Name.toLowerCase().indexOf(filterDetails.name.toLowerCase()) != -1)
    setFilteredAttendanceList(filterarry)
  }
  useEffect(() => {
    getDepartment()
    setActivePage('leave')
    setTopNav('list')
    currentMonthDates()
  }, [])
  return (
    <div className=''>
      {!subpage && <Topnav name='Attendence List' />}
      {trigger && <DownloadContent trigger={trigger} settrigger={settrigger}
        data={filteredAttendanceList?.map((obj) => ({
          Date: obj.date ? changeDateYear(obj.date) : '--',
          EmpId: obj.Emp_Id?.EmployeeId,
          Name: obj.Emp_Id?.Name,
          Designation: obj.Emp_Id?.Designation,
          Department: obj.Department_name,
          Postiton: obj.position_name,
          InTime: obj.InTime ? formatISODate(obj.InTime) : '-',
          OutTime: obj.OutTime ? formatISODate(obj.OutTime) : '-',
          'Break Time': obj.break_timings ? formatTime(obj.break_timings) : '-',
          'Total hours worked': obj.Hours_Worked ? formatTime(obj.Hours_Worked) : '-',
          'Late araival': obj.Late_Arrivals ? formatTime(obj.Late_Arrivals) : '-',
          'Early departure': obj.Early_Depature ? formatTime(obj.Early_Depature) : '-',
          'Status': obj.Status ? obj.Status : '--',
          'Remarks': obj.remarks ? obj.remarks : '--',
          'Punch INs': ` ${obj.attendance_records.map((obj) => obj.ScanTimings ? formatISODate(obj.ScanTimings) : '')} `
        }))}
        name={`Attendence${filterDetails.name && `_${filterDetails.name}`}_${filterDetails.year}_${months[filterDetails.month - 1]}`} />}
      <section className='flex gap-3 flex-wrap'>
        <div className='shadow  flex gap-1 items-center text-slate-500 text-sm bgclr w-48 p-1 rounded '>
          <div>
            <SearchIcon size={20} />
          </div>
          <input type="text" value={filterDetails.name}
            onKeyDown={(e) => {
                filterlist()
            }}
            name='name' onChange={handleChangeFilterDetails}
            className='outline-none p-1 bg-transparent ' placeholder='Search by Name..' />
        </div>
        {/* <div className='shadow bgclr w-48 p-1 py-0 rounded '>
          <label htmlFor="" className='text-xs fw-medium'> Department </label>
          <select className='block text-sm outline-none w-full bg-transparent ' name="" id="">
            <option value="">Select</option>
            {
              Department_List && Department_List.map((obj)=>(
                <option value="">{obj.Dep_Name} </option>
              ))
            }
          </select>
        </div> */}
        {/* Year */}

        <div className='bgclr w-fit rounded ps-3'>
          From :
          <input onChange={handleChange} name='fromtime' value={filterObj.fromtime}
            type="date" className='p-2 bg-transparent rounded outline-none' />
        </div>
        <div className='bgclr w-fit rounded ps-3'>
          To :
          <input onChange={handleChange} name='totime' value={filterObj.totime}
            type="date" className='p-2 bg-transparent rounded outline-none' />
        </div>

        {/* <div className='shadow bgclr w-48 p-1 py-0 rounded '>
          <label htmlFor="" className='text-xs fw-medium'> Year </label>
          <select value={filterDetails.year} onChange={handleChangeFilterDetails}
            className='block text-sm outline-none w-full bg-transparent fw-semibold' name="year" id="">
            <option value="">Select</option>
            {year.map((yr) => (
              <option value={yr}>{yr} </option>
            ))}
          </select>
        </div> */}
        {/* Month */}
        {/* <div className='shadow bgclr w-48 p-1 py-0 rounded '>
          <label htmlFor="" className='text-xs fw-medium'> Month </label>
          <select value={filterDetails.month} onChange={handleChangeFilterDetails}
            className='block text-sm outline-none w-full bg-transparent fw-semibold' name="month" id="">
            <option value="">Select</option>
            {months.map((month, index) => (
              <option value={index + 1}>{month} </option>
            ))}
          </select>
        </div> */}
        <button onClick={() => getAttendanceList(filterObj.fromtime, filterObj.totime)} className='savebtn shadow text-white w-48 rounded'>
          Search
        </button>


        <button disabled={loading} className=' bg-slate-50 ms-auto hover:bg-slate-100 rounded  shadow'>
          <a href={`../assets/Images/attendance_data.xlsx`}
            download className='items-center text-decoration-none text-slate-800 gap-2 text-sm p-1 px-2
          flex cursor-pointer w-full h-full'>
            {loading ? "Loading..." : "DownLoad Format"}
            <ExportIcon size={20} />
          </a>
        </button>
        <button disabled={loading} className=' bg-slate-50 ms-auto hover:bg-slate-100 rounded  shadow'>
          <label htmlFor="importattendence" className='items-center gap-2  p-1 px-2
          flex cursor-pointer w-full h-full'>
            {loading ? "Loading..." : "Import"}
            <ImportIcon size={20} />
          </label>
        </button>

        <input disabled={loading} onChange={uploadAttendence}
          id='importattendence' type="file" className='hidden' />
        <button onClick={() => {
          if (filteredAttendanceList.length > 0)
            settrigger(true)
          else
            toast.warning(`Empty File can't be downloaded.`)
        }} className='bg-slate-50 hover:bg-slate-100  items-center gap-2 flex rounded  p-2 px-2 shadow'>
          Export
          <ExportIcon size={20} />
        </button>
      </section>
      {loading ? <div className=' my-4 rounded ' >
        <LoadingData />
      </div> : filteredAttendanceList &&
      <AttendenceShowingadminTable getAttendanceList={getAttendanceList} data={filteredAttendanceList} />}



    </div>
  )
}

export default AttendenceAdmin