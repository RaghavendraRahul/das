import React, { createContext, useEffect, useState } from 'react'
export const RouterStore = createContext()
const RouterContext = (props) => {
    let [loginstatus, setLoginStatus] = useState(false)
    let manager = JSON.parse(sessionStorage.getItem('user'))?.is_reporting_manager
    let permissions = JSON.parse(sessionStorage.getItem('user'))?.user_permissions
    const [payrollRoutersLinks, setpayrollRoutersLinks] = useState()
    const [settingRouterLinks, setSettingRouterLink] = useState()
    const [employeeRouterLink, setemployeeRouterLink] = useState()
    const [leaveRouterLinks, setLeaveRouterLinks] = useState()
    const [reportRouterLinks, setReportRouterLinks] = useState()
    const [activityRouterLinks, setActivityRouterLinks] = useState()
    const [clientRouterLinks, setClientRouterLinks] = useState()
    useEffect(() => {
        let status = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
        let empid = JSON.parse(sessionStorage.getItem('dasid'))
        setClientRouterLinks([

            {
                label: 'Client List',
                path: '/client/',
                show: true,
                active: 'client'
            },
            {
                label: 'Client Creation',
                path: '/client/addClient',
                show: true,
                active: 'addclient'
            },
            {
                label: 'Requirements',
                path: '/client/recuirment',
                show: true,
                active: 'recuirter'
            },
        ])
        setActivityRouterLinks([
            {
                label: 'Personal Activity',
                path: '/activity/',
                show: true,
                active: 'perosnal'
            },
            {
                label: 'My Team',
                path: '/activity/myteam',
                show: status == 'HR' || status == 'Admin',
                active: 'myteam'
            },
            {
                label: 'Interview Activity',
                path: '/activity/interview',
                show: true,
                active: 'interview'
            }
        ])
        setReportRouterLinks([
            {
                label: 'My Report',
                path: '/reports/',
                show: true,
                active: 'myreport'
            },
            {
                label: 'Analytics',
                path: '/reports/analytics',
                show: true,
                active: 'analytic'
            }
        ])
        setSettingRouterLink([
            {
                label: 'Holidays',
                path: '/settings/holidays',
                show: true,
                active: 'holidays'
            },
            {
                label: 'Change Password',
                path: '/settings/password',
                show: true,
                active: 'password'
            },

            {
                label: 'Attendence Report',
                path: '/settings/attendence',
                show: true,
                active: 'attendence'
            },
            {
                label: 'Job Posting',
                path: '/settings/jobposting',
                show: true,
                active: 'jobposting'
            },
        ])
        setemployeeRouterLink([
            {
                label: 'All Employees',
                path: `/employees/`,
                active: 'all',
                keyword: ['employee', 'active employee', 'inactive', 'people'],
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Department',
                path: `/employees/department`,
                active: 'department',
                keyword: ['employee', 'active employee', 'inactive', 'people'],
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Designation',
                path: `/employees/designation`,
                active: 'designation',
                keyword: ['employee', 'active employee', 'inactive', 'people'],
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Mass Mail',
                path: '/employees/Mass_Mail',
                active: 'mail',
                keyword: ['employee', 'communication', 'message', 'notice'],
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Employee Overview',
                path: '/employees/Employee_Overview',
                active: 'overview',
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Offer Aproval',
                path: '/employees/offerApproval',
                active: 'offer',
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Offboarding',
                path: '/employees/Employee_request_form',
                active: 'exit',
                show: true
            },
            {
                label: 'Pending Joining Forms',
                path: '/employees/pending-joining-forms',
                active: 'pending-forms',
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'New Join Employee',
                path: '/employees/New_Join_Employee',
                active: 'join-employee',
                show: status == 'HR' || status == 'Admin'
            }
        ])
        setpayrollRoutersLinks([
            {
                label: 'Salary Component',
                path: `/payroll/salaryComponent`,
                active: 'salarycom',
                keyword: ['salary', 'component', 'creation'],
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'Salary Template',
                path: `/payroll/salary-templates`,
                active: 'template',
                keyword: ['template',],
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'Salary Assigning',
                path: `/payroll/salary-assigning`,
                active: 'assiging',
                keyword: ['template', 'employee', 'people'],
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'Employee Payslips',
                path: `/payroll/employeesPayslip`,
                active: 'allpayslip',
                keyword: ['payslip', 'employee', 'people'],
                show: status == 'HR' || status == 'Admin'
            },
            {
                label: 'Attendance Approvals',
                path: `/payroll/correction-approvals`,
                active: 'approvals',
                keyword: ['approval', 'attendance', 'correction'],
                show: status == 'HR' || status == 'Admin'
            },
        ])
        setLeaveRouterLinks([
            {
                label: 'Leave Overview',
                path: `/leave/`,
                keyword: ['leave', 'request'],
                active: 'summary',
                show: true,
            },
            {
                label: 'Request Leave ',
                path: '/leave/apply',
                keywrod: ['leave', 'apply'],
                active: 'leave',
                show: true
            },
            {
                label: 'Leave Approval',
                path: `/leave/approvals`,
                keyword: ['leave', 'request'],
                active: 'approval',
                show: status == 'HR' || status == 'Admin' || manager,
            },
            {
                label: 'Attendance Records',
                path: `/leave/attendence-list`,
                active: 'list',
                keywrod: ['list', 'leave', 'attendance', 'report', 'employee'],
                show: status == 'HR' || status == 'Admin' || manager || permissions?.attendance_upload,
            },
            {
                label: 'Leave History',
                path: `/leave/history`,
                active: 'history',
                keyword: ['history', 'people'],
                show: status == 'HR' || status == 'Admin',
            },
            {
                label: 'Leave Details',
                path: `/leave/leaveCreation`,
                keyword: ['leave', 'leave type', 'create'],
                active: 'creation',
                show: status == 'HR' || status == 'Admin',
            },
        ])
    }, [loginstatus])
    let value = {
        settingRouterLinks, payrollRoutersLinks, leaveRouterLinks, employeeRouterLink, setLoginStatus, reportRouterLinks,
        activityRouterLinks, clientRouterLinks
    }
    return (
        <RouterStore.Provider value={value} >
            {props.children}
        </RouterStore.Provider>
    )
}

export default RouterContext