import React, { createContext, useState } from 'react'
import Hrdashpage from './Components/Hrdashpage'
import Recruiterdashpage from './Components/Recruiterdashpage'
import Empdashpage from './Components/Empdashpage'
import Signup from './Components/Signup'
import Login from './Components/Login'
import 'react-quill/dist/quill.snow.css';
import { BrowserRouter, Route, Router, Routes } from 'react-router-dom'
import Hrslider from './Components/Hrslider'
import Applylist from './Components/ApplyList/Applylist'
import Employees from './Components/Employees'
import Recteam from './Components/Recteam'
import Canditatereg from './Components/Canditatereg'
import Intassform from './Components/Intassform'
import Protect from './Components/Protect'
import Docupload from './Components/Docupload'
import Doc from './Components/Doc'
import Dummudoc from './Components/dummydoc'
import Tempone from './Components/Tempone'
import Activites from './Components/Activites'
import Employeeallform from './Components/Employeeallform'
import Offeraccept from './Components/Offeraccept'
import Employeeseparation from './Components/Employeeseparation'
import Bgverificationform from './Components/Bgverificationform'
import Forgotpass from './Components/Forgotpass'
import Empdesignation from './Components/Empdesignation'
import Allemp from './Components/Allemp'
import Empdepartment from './Components/Empdepartment'
import Empattendance from './Components/Empattendance'
import Leaveapplyform from './Components/Leaveapplyform'
import Emp_leave_grant_form from './Components/Emp_leave_grant_form'
import Emp_leave_request from './Components/Emp_leave_request'
import Mass_mail from './Components/Mass_mail'
import Testing from './Components/Testing'
import Attachements from './Components/Attachements'
import Documentupload from './Components/Documentupload'
import Acti from './Components/Acti'
import Requestt from './Components/Requestt'
import Holidays from './Components/Holidays'
import Performance_metrics from './Components/Performance_metrics'
import Sample_acti from './Components/Sample_acti'
import Actisam from './Components/Actisam'
import Reporting_team from './Components/Reporting_team'
import All_request_data from './Components/All_request_data'
import Employee_separation_request from './Components/Employee_separation_request'
import Repoting_team_report from './Components/Repoting_team_report'
import Employee_request_form from './Components/Employee_request_form'
import Applay from './Components/Applay'
import Employeees from './Components/Employeees'
import New_join_emp from './Components/New_join_emp'
import Reporting_team_recuter from './Components/Reporting_team_recuter'
import Sample_acti_rec from './Components/Sample_acti_rec'
import Login_ from './Components/Login_'
import Basic from './Components/Basic'
import Profile_page from './Components/Profile_page'
import Hr_reporting_team from './Components/Hr_reporting_team'
import Emp_activity from './Components/Emp_activity'
import Otp_verifivation from './Components/Otp_verifivation'
import Forgot_password from './Components/Forgot_password'
import Set_password from './Components/Set_password'
import Signup_ from './Components/Signup_'
import Login_forgot_pass from './Components/Login_forgot_pass'
import Login__ from './Components/Login__'
import Forgot_pass_otp_verification from './Components/Forgot_pass_otp_verification'
import Rec_applyed_list from './Components/Rec_applyed_list'
import Can from './Components/Can'
import Final_status_comment from './Components/Final_status_comment'
import Employee_interview_applicants from './Components/Employee_interview_applicants'
import Sweet_aleart from './Components/Sweet_aleart'
import Acti_ from './Components/Acti_'
import Interview_sche from './Components/Interview_sche'
import Letter_of__appointment from './Components/Letter_of__appointment'
import '../src/assets/css/modal.css'
import '../src/assets/css/fonts.css';
import '../src/assets/css/media.css';
import '../src/assets/css/Actiscroll.css';
import '../src/assets/css/Checkbox.css';
import '../src/assets/css/login.css';
import '../src/assets/css/Login_.css';
import '../src/assets/css/Pass.css';
import '../src/assets/css/Sweet_.css';
import 'react-toastify/dist/ReactToastify.css';
import '../src/App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { ToastContainer } from 'react-toastify'
import Applicants from './Components/Applicants'
import InterviewReviewModal from './Components/Modals/InterviewReviewModal'
import LeaveSetting from './Pages/LeaveCreation'
import DasRouter from './Pages/DasRouter'
import SettingRouter from './Pages/SettingPage/SettingRouter'
import ApprovalPage from './Pages/Approval/ApprovalPage'
import AttendenceAdmin from './Pages/AttendenceAdmin'
import InternLetter from './Pages/InternLetter'
import OfferLetterFormPage from './Components/Modals/OfferLetterFormPage'
import OfferTemplate from './Pages/OfferTemplate'
import OfferApprovalPage from './Pages/Approval/OfferApprovalPage'
import SelfEvaluation from './Pages/Employee_Performance/SelfEvaluation'
import JFPreview from './Pages/JoiningFormalities/JFPreview'
import ManagerReview from './Pages/Employee_Performance/ManagerReview'
import Scanner from './Pages/Scanner/Scanner'
import MeetingReview from './Pages/Employee_Performance/MeetingReview'
import Das from './Pages/Das'
import ExitProcessRouter from './Pages/ExitProcess/ExitProcessRouter'
import HrAdminAuth from './Components/AuthPermissions/HrAdminAuth'
import PayrollROuter from './Components/Routers/PayrollROuter'
import EmployeeRouter from './Components/Routers/EmployeeRouter'
import LeaveRouter from './Components/Routers/LeaveRouter'
import DashboardRouter from './Components/Routers/DashboardRouter'
import QrCodeGenerator from './Pages/QRscanner/QrCodeGenerator'
import ReportRouter from './Pages/ReportRouter/ReportRouter'
import ActivityRouter from './Pages/Activity/ActivityRouter'
import FaceRecognitionAttendance from './Pages/Attendence/FaceRecognitionAttendance'
import ClientRouter from './Pages/Client/ClientRouter'
import GetGeoLocation from './Components/MiniComponent/GetGeoLocation'
import LoginProtect from './Components/AuthPermissions/LoginProtect'
import CandidateFormPage from './Pages/Activity/CandidateFormPage'

// LOCALHOST URLS
export const port = 'https://hrmbackendapi.meridahr.com/'  // Production
// export const port = 'http://localhost:8001/'
export const meridahrsite = 'https://hrmbackendapi.meridahr.com/'  // Production
// export const meridahrsite = 'http://localhost:8001/'
export const domain = 'https://hrm.meridahr.com'
// export const domain = 'http://localhost:3000'
export const das = 'https://dasbackendapi.meridahr.com/'  // Production
// export const das = 'http://localhost:8000/'
export const meridahrport = 'https://hrmbackendapi.meridahr.com/'  // Production
// export const meridahrport = 'http://localhost:8001/'

//changes2
const App = () => {
  // const port = "http://192.168.0.106:9000"

  return (
    <div style={{ backgroundColor: 'rgb(241,242,246)' }} className=''>
      <BrowserRouter>
        <ToastContainer autoClose={1000} position='top-center' />
        {/* <GetGeoLocation /> */}
        <Routes>
          <Route path='/activity/candidate-form' element={<CandidateFormPage />} />
          <Route element={<LoginProtect Child={DashboardRouter} />} path='/*'></Route>
          <Route path='/qr' element={<QrCodeGenerator />} />
          <Route path='/reports/*' element={<ReportRouter />} />
          <Route path='/scanner' element={<Scanner />} />
          <Route path='/das' element={<Das />} />
          <Route element={<Signup></Signup>} path='/Signup'></Route>
          <Route path='/dash/*' element={<DasRouter />} />
          <Route path='/dashboard/*' element={<LoginProtect Child={DashboardRouter} />} />
          <Route element={<JFPreview />} path='/preview/:id' />
          <Route element={<JFPreview />} path='/employeeVerification/:id' />
          <Route path='/attendence-list' element={<AttendenceAdmin />} />
          <Route path='/candidateOfferLetter/:id' element={<OfferTemplate />} />
          <Route element={<Applylist></Applylist>} path='/Applaylist'></Route>
          <Route element={<Employees></Employees>} path='/Employeees'></Route>
          <Route element={<Applicants></Applicants>} path='/Applicants'></Route>
          <Route element={<Recteam></Recteam>} path='/Recteam'></Route>
          <Route element={<Canditatereg></Canditatereg>} path='/Canditate_Registration_Form'></Route>
          <Route element={<Intassform></Intassform>} path='/Interview-Assessment-form'></Route>
          <Route element={<Docupload></Docupload>} path='/DocmentUpload'></Route>
          <Route element={<Dummudoc></Dummudoc>} path='/Doc/:id/:login'></Route>
          <Route element={<OfferLetterFormPage />} path='/offerletter/:id' />
          <Route element={<Tempone></Tempone>} path='/Temp'></Route>
          <Route element={<InternLetter />} path='/intern' />
          <Route element={<Activites></Activites>} path='/Activites'></Route>
          <Route element={<Employeeallform></Employeeallform>} path='/Employeeallform/:id/*'></Route>
          <Route path='/settings/*' element={<SettingRouter />} />
          <Route element={<Offeraccept></Offeraccept>} path='/offeraccept/:id'></Route>
          <Route path='/selfEvaluation/:id' element={<SelfEvaluation />} />
          <Route path='/employePerformanceEvaluation/:id' element={<ManagerReview />} />
          <Route path='/meetingReview/:id' element={<MeetingReview />} />

          <Route element={<Employeeseparation></Employeeseparation>} path='/Employeeseparation'></Route>

          <Route element={<Bgverificationform></Bgverificationform>} path='/BgverificationForm/:id/:fid'></Route>

          <Route element={<Forgotpass></Forgotpass>} path='/Forgotpassword/:id/'></Route>

          <Route element={<Empdesignation></Empdesignation>} path='/EmployeeDesignations'></Route>
          <Route element={<HrAdminAuth Child={Allemp} />}
            path='/AllEmployees'></Route>
          {/* Routers */}
          <Route element={<EmployeeRouter />} path='/employees/*' />
          <Route element={<PayrollROuter />} path='/payroll/*' />
          <Route element={<LeaveRouter />} path='/leave/*' />

          <Route element={<ClientRouter />} path='/client/*' />


          <Route element={<Empdepartment></Empdepartment>} path='/EmployeeDepartment'></Route>

          <Route element={<Empattendance></Empattendance>} path='/Employeeattendance'></Route>

          <Route element={<Leaveapplyform></Leaveapplyform>} path='/Leaveapplyform'></Route>

          <Route element={<Emp_leave_grant_form></Emp_leave_grant_form>} path='/Emp_leave_grant_form'></Route>

          <Route element={<Emp_leave_request></Emp_leave_request>} path='/Emp_leave_request'></Route>

          <Route element={<Mass_mail></Mass_mail>} path='/Mass_Mail'></Route>

          <Route element={<Dummudoc></Dummudoc>} path='/Doc'></Route>

          <Route element={<Testing></Testing>} path='/Testing'></Route>

          {/* Testing  */}

          <Route element={<Attachements></Attachements>} path='/Attachements'></Route>

          <Route element={<Documentupload></Documentupload>} path='/DocumentUpload'></Route>

          <Route element={<Acti></Acti>} path='/Activites-'></Route>

          <Route element={<Requestt></Requestt>} path='/Request'></Route>

          <Route element={<Holidays></Holidays>} path='/Holidays'></Route>

          <Route element={<Performance_metrics></Performance_metrics>} path='/Performance_metrics'></Route>

          <Route element={<Acti_ />} path='/Sample_acti'></Route>

          <Route element={<Actisam></Actisam>} path='/Actisam'></Route>
          <Route element={<ActivityRouter />} path='/activity/*' />
          <Route element={<FaceRecognitionAttendance />} path='/facereg' />
          <Route element={<Reporting_team></Reporting_team>} path='/Reporting_team'></Route>
          <Route element={<Repoting_team_report></Repoting_team_report>} path='/Report_Manager_Reporting_team'></Route>
          <Route element={<Reporting_team_recuter></Reporting_team_recuter>} path='/Reporting_team_recuter'></Route>
          <Route element={<Hr_reporting_team></Hr_reporting_team>} path='/Hr_reporting_team'></Route>

          <Route element={<All_request_data></All_request_data>} path='/All_request_data'></Route>

          <Route element={<Employee_separation_request></Employee_separation_request>} path='/Employee_Separation'></Route>

          <Route element={<ExitProcessRouter />} path='/Employee_request_form/*'></Route>

          <Route element={<Applay></Applay>} path='/Applay_List'></Route>
          <Route element={<InterviewReviewModal />} path='/interviewreview/:id'> </Route>

          <Route element={<Employeees></Employeees>} path='/Employee_Overview'></Route>

          {/* <Route element={<New_join_emp></New_join_emp>} path='/New_Join_Employee'></Route> */}

          <Route element={<Sample_acti_rec></Sample_acti_rec>} path='/Activity_Rec'></Route>


          <Route element={<Basic></Basic>} path='/Basic'></Route>

          <Route element={<Profile_page></Profile_page>} path='/Employee_Profile'></Route>
          <Route element={<Emp_activity></Emp_activity>} path='/Emp_activity_sheet'></Route>

          <Route element={<Otp_verifivation></Otp_verifivation>} path='/Otp_verifivation'></Route>
          <Route element={<Forgot_password></Forgot_password>} path='/Forgot_password'></Route>
          <Route element={<Set_password></Set_password>} path='/Set_password/:id/'></Route>

          <Route element={<Signup_></Signup_>} path='/Signup_'></Route>

          {/* <Route element={<Login_forgot_pass></Login_forgot_pass>} path='/Login__'></Route> */}

          <Route element={<Forgot_pass_otp_verification></Forgot_pass_otp_verification>} path='/Forgot_Otp_Verification'></Route>

          <Route element={<Rec_applyed_list></Rec_applyed_list>} path='/Rec_applyed_list'></Route>


          <Route element={<Can></Can>} path='/Can'></Route>

          <Route element={<Final_status_comment></Final_status_comment>} path='/Final_status_comment'></Route>


          <Route element={<Employee_interview_applicants></Employee_interview_applicants>} path='/Employee_interview_applicants'></Route>

          <Route element={<Sweet_aleart></Sweet_aleart>} path='/Sweet_aleart'></Route>

          <Route element={<Acti_></Acti_>} path='/Recruiter_Activity'></Route>

          <Route element={<Interview_sche></Interview_sche>} path='/Interview_sche'></Route>

          <Route element={<SelfEvaluation />} path='/selfEvaluation/:id' />










        </Routes>
      </BrowserRouter>


    </div>
  )
}

export default App