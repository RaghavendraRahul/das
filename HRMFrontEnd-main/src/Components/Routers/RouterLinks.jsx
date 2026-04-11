let status = JSON.parse(sessionStorage.getItem('user'))?.Disgnation
let empid = JSON.parse(sessionStorage.getItem('dasid'))
let permission = JSON.parse(sessionStorage.getItem('user'))?.user_permissions
export const payrollRoutersLinks = [
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
]

export const settingRouterLinks = [
    {
        label: 'Apply Leave',
        path: '/settings/leave',

        show: true,
        active: 'leave'
    },
    {
        label: 'Change Password',
        path: '/settings/password',
        show: true,
        active: 'password'
    },
    {
        label: 'Holidays',
        path: '/settings/holidays',

        show: true,
        active: 'holidays'
    },
    {
        label: 'Attendence',
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
]

export const employeeRouterLink = [
    {
        label: 'All Employees',
        path: `/employees/`,
        active: 'all',
        keyword: ['employee', 'active employee', 'inactive', 'people'],
        show: status == 'HR' || status == 'Admin' || permission?.all_employees_view,
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
        label: 'Exit Process',
        path: '/employees/Employee_request_form',
        active: 'exit',
        show: true
    }
]

export const leaveRouterLinks = [
    {
        label: 'Leave Approval',
        path: `/leave/`,
        keyword: ['leave', 'request'],
        active: 'approval',
        show: true,
    },
    {
        label: 'Attendance list',
        path: `/leave/attendence-list`,
        active: 'list',
        keywrod: ['list', 'leave', 'attendance', 'report', 'employee'],
        show: true,
    },
    {
        label: 'Leave Request History',
        path: `/leave/history`,
        active: 'history',
        keyword: ['history', 'people'],
        show: true,
    },
    {
        label: 'Leave Creation',
        path: `/leave/leaveCreation`,
        keyword: ['leave', 'leave type', 'create'],
        active: 'creation',
        show: true,
    },
]