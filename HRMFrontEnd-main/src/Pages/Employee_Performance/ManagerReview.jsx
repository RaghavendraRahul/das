import React, { useContext, useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import { HrmStore } from '../../Context/HrmContext'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
// OLD: import { usePDF } from 'react-to-pdf' - No longer needed, using html2canvas + jsPDF in DownloadButton
import DownloadButton from '../../Components/Employee/DownloadButton'

const ManagerReview = () => {
    let { id, eid } = useParams()
    let { getCurrentDate, convertToReadableDateTime } = useContext(HrmStore)
    let userLogin = JSON.parse(sessionStorage.getItem('user'))
    // OLD: const { toPDF, targetRef } = usePDF({ Offer_Letter: 'page.pdf' });
    // NEW: Using simple useRef for the target element
    const targetRef = React.useRef();

    let [user, setUser] = useState()
    let [formFilled, setFormFilled] = useState()
    let [managerReview, setmanagerReview] = useState({
        id: id,
        works_to_full_potential: '',
        quality_of_work: '',
        work_consistency: '',
        communication: '',
        independent_work: '',
        takes_initiative: '',
        group_work: '',
        productivity: '',
        creativity: '',
        honesty: '',
        integrity: '',
        coworker_relations: '',
        client_relations: '',
        technical_skills: '',
        dependability: '',
        punctuality: '',
        attendance: '',
        overall: '',
        Reviewer_Name: '',
        Reviewer_Title: '',
        DateOfCurrentReview: '',
        DateOfLastReview: '',
        Were_previously_set_goals_achieved: '',
        Goals_for_next_review_period: '',
        COMMENTS_AND_APPROVAL: '',
        submitted_Date: ''
    })
    let handleChange = (e) => {
        let { name, value, files } = e.target
        setmanagerReview((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getEmployee = async () => {
        try {
            if (id) {
                // let manager = await axios.get(`${port}/root/lms/GetReportingManagerAppraisal?rm_app_id=${id}`) // Old Code without slash
                let manager = await axios.get(`${port}/root/lms/GetReportingManagerAppraisal/?rm_app_id=${id}`)
                setUser(manager.data.AppraisalInvitation)
                setmanagerReview(manager.data.RMSelfApprailsal)
                setFormFilled(manager.data.AppraisalInvitation.is_rm_filled)
                console.log(manager.data);
            }
        }
        catch (error) {
            console.log(error);
        }
    }
    let sendData = () => {
        // axios.patch(`${port}/root/lms/GetReportingManagerAppraisal`, managerReview).then((response) => { // Old Code
        axios.patch(`${port}/root/lms/GetReportingManagerAppraisal/`, managerReview).then((response) => {
            console.log(response.data);
            toast.success('Form Submitted Successfully')
            getEmployee()
        }).catch((error) => {
            console.log(error);
        })
    }
    useEffect(() => {
        getEmployee()
    }, [id])
    useEffect(() => {
        let components = [managerReview.attendance, managerReview.works_to_full_potential, managerReview.quality_of_work,
        managerReview.work_consistency, managerReview.communication, managerReview.independent_work,
        managerReview.takes_initiative, managerReview.group_work, managerReview.productivity,
        managerReview.creativity, managerReview.honesty, managerReview.integrity, managerReview.coworker_relations,
        managerReview.client_relations, managerReview.technical_skills, managerReview.dependability,
        managerReview.punctuality
        ]
        let count = components.reduce((acc, val) => acc + (Number(val) > 0 ? 1 : 0), 0)
        if (count > 1) {
            let total = components.reduce((acc, val) => acc + (Number(val) || 0), 0)
            let avg = (total / count).toFixed(2)
            setmanagerReview((prev) => ({
                ...prev,
                overall: avg
            }))
        }

    }, [managerReview.attendance, managerReview.works_to_full_potential, managerReview.quality_of_work,
    managerReview.work_consistency, managerReview.communication, managerReview.independent_work,
    managerReview.takes_initiative, managerReview.group_work, managerReview.productivity,
    managerReview.creativity, managerReview.honesty, managerReview.integrity, managerReview.coworker_relations,
    managerReview.client_relations, managerReview.technical_skills, managerReview.dependability,
    managerReview.punctuality])
    return (
        <div className='p-3 poppins'>
            {!formFilled || (userLogin && (userLogin.Disgnation == 'Admin' || userLogin.Disgnation == 'HR')) ?
                <main ref={targetRef} className='bg-white p-3 container mx-auto'>

                    <h5 className='text-center '> PERFORMANCE REVIEW </h5>

                    <section className='my-3'>
                        <p className='text-sm fw-semibold '> EMPLOYEE INFORMATION </p>
                        <article className='formbg p-3 row  container mx-auto rounded '>
                            <InputFieldform label='Employee Name' value={user && user.employee_name}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            <InputFieldform label='Employee ID' value={user && user.EmployeeId}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            <InputFieldform label='Date of current review' value={getCurrentDate()}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            <InputFieldform label='Position held' value={user && user.Designation}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            <InputFieldform label='Department' value={user && user.Department}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            {/* <InputFieldform label='Date of last review'
                                name='works_to_full_potential' disabled={true} limit={10} type='text' /> */}

                            <InputFieldform label='Reviewer Name' value={user && user.ReportingEmployeeName}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            <InputFieldform label='Reviewer Title' value={user && user.ReportingEmployeeId}
                                name='works_to_full_potential' disabled={true} limit={10} type='text' />

                            {user && user.rm_filled_on &&
                                <InputFieldform label='Date Submitted' value={user && convertToReadableDateTime(user.rm_filled_on)}
                                    name='works_to_full_potential' disabled={true} limit={10} type='text' />}


                        </article>
                    </section>
                    <section className='my-3'>
                        <p className='text-sm fw-semibold '> CHARACTERISTICS  </p>
                        <article className='formbg p-3 row container mx-auto rounded '>
                            <InputFieldform label='Work to Full Potential' placeholder='1-10' disabled={formFilled} value={managerReview.works_to_full_potential}
                                name='works_to_full_potential' handleChange={handleChange} limit={10} type='text' />


                            <InputFieldform label='Quality of Work' placeholder='1-10' disabled={formFilled} value={managerReview.quality_of_work}
                                name='quality_of_work' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Work Consistency' placeholder='1-10' disabled={formFilled} value={managerReview.work_consistency}
                                name='work_consistency' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Communication' placeholder='1-10' disabled={formFilled} value={managerReview.communication}
                                name='communication' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Independent Work' placeholder='1-10' disabled={formFilled} value={managerReview.independent_work}
                                name='independent_work' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Takes Initiative' placeholder='1-10' disabled={formFilled} value={managerReview.takes_initiative}
                                name='takes_initiative' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Group Work' placeholder='1-10' disabled={formFilled} value={managerReview.group_work}
                                name='group_work' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Productivity' placeholder='1-10' disabled={formFilled} value={managerReview.productivity}
                                name='productivity' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Creativity' placeholder='1-10' disabled={formFilled} value={managerReview.creativity}
                                name='creativity' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Honesty' placeholder='1-10' disabled={formFilled} value={managerReview.honesty}
                                name='honesty' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Integrity' placeholder='1-10' disabled={formFilled} value={managerReview.integrity}
                                name='integrity' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Coworker Relations' placeholder='1-10' disabled={formFilled} value={managerReview.coworker_relations}
                                name='coworker_relations' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Client Relations' placeholder='1-10' disabled={formFilled} value={managerReview.client_relations}
                                name='client_relations' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Technical Skills' placeholder='1-10' disabled={formFilled} value={managerReview.technical_skills}
                                name='technical_skills' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Dependability' placeholder='1-10' disabled={formFilled} value={managerReview.dependability}
                                name='dependability' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Punctuality' placeholder='1-10' disabled={formFilled} value={managerReview.punctuality}
                                name='punctuality' handleChange={handleChange} limit={10} type='text' />

                            <InputFieldform label='Attendance' placeholder='1-10' disabled={formFilled} value={managerReview.attendance}
                                name='attendance' handleChange={handleChange} limit={10} type='text' />


                            <InputFieldform label='Overall (out of 10) ' placeholder='1-10' disabled={true} value={managerReview.overall}
                                name='overall' handleChange={handleChange} limit={10} type='text' />


                        </article>

                    </section>

                    {/* GOALS */}
                    <section className='my-3'>
                        <p className='text-sm fw-semibold '>  GOALS  </p>
                        <article className='formbg p-3 rounded '>
                            <InputFieldform label='Were previously set goals achieved?' placeholder='' disabled={formFilled} value={managerReview.Were_previously_set_goals_achieved}
                                name='Were_previously_set_goals_achieved' handleChange={handleChange} type='textarea' size='col-12' />

                            <InputFieldform label='Goals for next review period:' placeholder=''
                                disabled={formFilled} value={managerReview.Goals_for_next_review_period}
                                name='Goals_for_next_review_period' handleChange={handleChange} type='textarea' size='col-12' />
                        </article>
                    </section>
                    <section className='my-3'>
                        <p className='text-sm fw-semibold '>  Comment and Approval  </p>
                        <article className='formbg p-3 rounded '>
                            <InputFieldform label='Comments' placeholder='' disabled={formFilled} value={managerReview.COMMENTS_AND_APPROVAL}
                                name='COMMENTS_AND_APPROVAL' handleChange={handleChange} type='textarea' size='col-12' />

                        </article>
                    </section>


                    {!formFilled && <button onClick={sendData} className='flex ms-auto p-2 rounded btngrd text-white '>
                        Submit
                    </button>}
                </main>
                : <main className='h-[90vh] flex '>
                    <section className='bgclr sm:w-1/2 m-auto h-[30vh] rounded flex  ' >
                        <p className='text-center m-auto'>
                            Form Submitted !!!
                            <span className='m-auto block'   >
                                Thank You !!
                            </span>
                        </p>
                    </section>

                </main>
            }
            {formFilled && <div className='w-fit ms-auto my-3 me-5 flex '>
                {/* OLD: <DownloadButton toPDF={toPDF} /> */}
                <DownloadButton divref={targetRef} name={'ManagerReview'} />
            </div>}
        </div>
    )
}

export default ManagerReview