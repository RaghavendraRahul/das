import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import { useParams } from 'react-router-dom'
import { toast } from 'react-toastify'
import AssestModel from './AssestModel'
import HandOverModel from './HandOverModel'

const ExitInterviewForm = ({ setActiveSection }) => {
    let { id } = useParams()
    let [assestModel, setAssestModel] = useState(false)
    let [handoverModel, setHandOverModel] = useState(false)
    let [loading, setLoading] = useState(false)
    let [formObj, setFormObj] = useState({
        resignation: null,
        employment_start_date: '',
        employment_end_date: '',
        accepted_another_position: false,
        new_title: '',
        additional_benefits: '',
        career_goals_met: "",
        spoke_with_manager_or_hr: false,
        got_along_with_manager: false,
        manager_issue_explanation: '',
        supervisor_handling_complaints: '',
        improvements_for_more_rewarding_job: '',
        liked_best_about_job: '',
        disliked_about_job: '',
        good_place_to_work: '',
        poor_place_to_work: '',
        job_responsibilities_rating: '',
        achieving_goals_rating: '',
        work_environment_rating: '',
        manager_rating: '',
        pay_rating: '',
        benefits_rating: '',
        would_rejoin_merida: '',
        recommendations: "",
        would_have_stayed_if_satisfied: '',
        more_satisfactory_explanation: '',
        submission_date: '',
        handed_over_to: '',
        new_organization_details: '',
        handed_over_signature_date: '',
        Days_to_Serve_Notice: 0,
        notice_period_agrry: "",
        compensation: '',
        compensation_pay_agrry: '',
        Date_to_Leave: '',
        FitToBeRehired: false,
        AlternateEmail: '',
        AlternateMobile: '',
        mail_sent: '',
        NoticedServed: false,
        Retrenchment_Compensation: 0,
        leave_encashment: 0,
        salary_month: null,
        grand_total: null,
        Company_Loans: null,
        Other_Recoveries: '',
        acknowledgement_receipt: '',
        TotalSettlement: '',
        SettledOn: '',
        EmpLeftOrganization: '',
        Date_of_Left_Organization: '',
        Required_letters: ''
    })
    let booleanOptions = [
        {
            label: 'Yes',
            value: true
        },
        {
            label: 'No',
            value: false
        }
    ]
    let options = [
        {
            label: 'Outstanding',
            value: 'outstanding'
        },
        {
            label: 'Very Good',
            value: 'verygood'
        },
        {
            label: 'Satisfactory',
            value: 'satisfactory'
        },
        {
            label: 'Fair',
            value: 'fair'
        },
        {
            label: 'Unsatisfactory',
            value: 'unsatisfactory'
        },
    ]
    let handleFormObj = (e) => {
        let { name, value } = e.target
        if (value == 'true')
            value = true
        if (value == 'false')
            value = false
        setFormObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getInterviewForm = () => {
        axios.get(`${port}/root/ems/EmployeeExitInterview?sep_id=${id}`).then((response) => {
            console.log(response.data, "exitInterview");
            setFormObj(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }

    useEffect(() => {
        setActiveSection('interview')
        if (id)
            getInterviewForm()
    }, [id])
    let handleUpdate = () => {
        delete formObj.resignation
        setLoading(true)
        axios.patch(`${port}/root/ems/EmployeeExitInterview`, formObj).then((response) => {
            toast.success('Updated successfully ')
            setLoading(false)
        }).catch((error) => {
            toast.error('Error occured')
            setLoading(false)
            console.log(error, 'exitinterview');
        })
    }
    return (
        <div>

            <main className='inputbg rounded p-3  ' >
                <section>
                    <h5>Exit Interview </h5>
                    <article className='bg-white row container mx-auto rounded p-3 ' >
                        <InputFieldform label="Employee Name" disabled
                            value={formObj.resignation && formObj.resignation.name} />
                        <InputFieldform label=" Designation" disabled
                            value={formObj.resignation && formObj.resignation.position} />
                        <InputFieldform label=" Department" disabled
                            value={formObj.resignation && formObj.resignation.department} />
                        <InputFieldform label="Employment Start Date" value={formObj.employment_start_date} disabled />
                        <InputFieldform label="Employment End Date" type='date' value={formObj.employment_end_date}
                            name='employment_end_date' handleChange={handleFormObj} />
                        <InputFieldform label="Reason for resignation" disabled
                            value={formObj.resignation && formObj.resignation.reason_for_leaving} />
                        <div className='col-12 my-2 ' >
                            <p>Have you accepted another job offer ? </p>
                            <select name="accepted_another_position" onChange={handleFormObj}
                                className='p-2 block rounded inputbg w-full outline-none shadow-none'
                                value={formObj.accepted_another_position} id="">
                                <option value=""> Select </option>
                                <option value={true}> Yes </option>
                                <option value={false} > No </option>
                            </select>
                        </div>
                        {formObj.accepted_another_position && <InputFieldform label="Which Company" name='new_organization_details'
                            handleChange={handleFormObj} value={formObj.new_organization_details} />}
                        {formObj.accepted_another_position && <InputFieldform label="What's role" value={formObj.new_title} name='new_title'
                            handleChange={handleFormObj} />}
                        {formObj.accepted_another_position && <InputFieldform label="Additional Benefits " value={formObj.additional_benefits} name='additional_benefits'
                            handleChange={handleFormObj} />}
                    </article>
                </section>
            </main>
            <main className='inputbg rounded p-3 my-3' >
                <section className='bg-white row container mx-auto rounded p-3 ' >
                    <InputFieldform label='Do you feel your career goals were met during your time at Merida?' handleChange={handleFormObj}
                        value={formObj.career_goals_met} name='career_goals_met'
                        optionObj={[{ value: true, label: "Yes" }, { value: false, label: "No" }]} size='col-lg-6' />

                    <InputFieldform label="Have you discussed your career goals with your manager or HR? (Yes/No) " value={formObj.spoke_with_manager_or_hr} name='spoke_with_manager_or_hr' handleChange={handleFormObj}
                        optionObj={[{ value: true, label: "Yes" }, { value: false, label: "No" }]} size='col-lg-6' />

                    <InputFieldform label="How well did you get along with your manage?"
                        value={formObj.got_along_with_manager} name='got_along_with_manager'
                        optionObj={[{ value: true, label: "Yes" }, { value: false, label: "No" }]} handleChange={handleFormObj} />




                    {!formObj.got_along_with_manager &&
                        < InputFieldform label="If there were any challenges, please describe them :" value={formObj.manager_issue_explanation}
                            name='manager_issue_explanation' handleChange={handleFormObj} size='col-lg-8 ' />}
                    <p className='col-12 ' ></p>
                    <InputFieldform size=' col-lg-6 ' value={formObj.supervisor_handling_complaints} name='supervisor_handling_complaints'
                        label='How effectively did your manager address any complaints or concerns you had ? ' handleChange={handleFormObj} />
                    <InputFieldform size=' col-lg-6 ' value={formObj.improvements_for_more_rewarding_job} name='improvements_for_more_rewarding_job'
                        label=' What could have been done to make your job here more rewarding ?  ' handleChange={handleFormObj} />
                    <InputFieldform size=' col-lg-6 ' value={formObj.liked_best_about_job} name='liked_best_about_job'
                        label='What parts of your role have been most fulfilling ?  ' handleChange={handleFormObj} />
                    <InputFieldform size=' col-lg-6 ' label='What aspects of your role did you find challenging or unsatisfactory ?  ' value={formObj.disliked_about_job}
                        name='disliked_about_job' handleChange={handleFormObj} />
                    <InputFieldform size=' col-lg-6 ' value={formObj.good_place_to_work} name="good_place_to_work"
                        label='What makes Merida a great place to work ?  ' handleChange={handleFormObj} />
                    <InputFieldform size=' col-lg-6 ' value={formObj.poor_place_to_work} name='poor_place_to_work'
                        label='What areas do you think Merida could improve on to create a better working environment ?  ' handleChange={handleFormObj} />
                </section>
            </main>
            <main className='inputbg rounded p-3 my-3 ' >
                <p className='fw-semibold text-lg ' >How would you rate the following? </p>
                <section className=' bg-white row container mx-auto rounded p-3 ' >
                    <InputFieldform label="Job responsibilities" optionObj={options}
                        value={formObj.job_responsibilities_rating} name='job_responsibilities_rating' handleChange={handleFormObj} />
                    <InputFieldform label="Opportunity for growth" optionObj={options}
                        value={formObj.achieving_goals_rating} name='achieving_goals_rating' handleChange={handleFormObj} />
                    <InputFieldform label="Work environment" optionObj={options}
                        value={formObj.work_environment_rating} name='work_environment_rating' handleChange={handleFormObj} />
                    <InputFieldform label="Manager's leadership" optionObj={options}
                        value={formObj.manager_rating} name='manager_rating' handleChange={handleFormObj} />
                    <InputFieldform label="Pay" optionObj={options}
                        value={formObj.pay_rating} name='pay_rating' handleChange={handleFormObj} />
                    <InputFieldform label="Benefits" optionObj={options}
                        value={formObj.benefits_rating} name='benefits_rating' handleChange={handleFormObj} />
                </section>
            </main>
            <main className='inputbg rounded p-3 my-3 ' >
                <section className=' bg-white row container mx-auto rounded p-3 ' >
                    <InputFieldform label=" Given opportunity would you like to rejoin Merida ?"
                        value={formObj.would_rejoin_merida} name='would_rejoin_merida' handleChange={handleFormObj} optionObj={booleanOptions} />

                    <InputFieldform label="What recommendations would you have for improving the department or Merida overall?" value={formObj.recommendations} name='recommendations' handleChange={handleFormObj} />
                    <InputFieldform label="If a better compensation or arrangement had been offered, would you have stayed with Merida ?" name='would_have_stayed_if_satisfied'
                        optionObj={[{ value: true, label: "Yes" }, { value: false, label: "No" }]} value={formObj.would_have_stayed_if_satisfied} handleChange={handleFormObj} />
                    {formObj.would_have_stayed_if_satisfied && <InputFieldform label="If Yes Explain :" size='col-lg-8 ' handleChange={handleFormObj}
                        value={formObj.more_satisfactory_explanation} name='more_satisfactory_explanation' />}
                    <InputFieldform label="Day to serve notice" value={formObj.Days_to_Serve_Notice} name='Days_to_Serve_Notice'
                        handleChange={handleFormObj} />
                    <InputFieldform label='Agree to serve notice ?' value={formObj.notice_period_agrry} name='notice_period_agrry'
                        handleChange={handleFormObj} optionObj={booleanOptions} />
                    <InputFieldform label="Compensation amount " value={formObj.compensation} name='compensation'
                        handleChange={handleFormObj} />
                    <InputFieldform label='Are you willing to pay compensation? ' value={formObj.compensation_pay_agrry} name='compensation_pay_agrry'
                        handleChange={handleFormObj} optionObj={booleanOptions} />

                </section>
                <section className='flex justify-between ' >
                    <div className='  ' >
                        {formObj.resignation && formObj.resignation.HR_manager_name == JSON.parse(sessionStorage.getItem('dasid'))
                            && <button onClick={() => setAssestModel(formObj)} className='bg-slate-500 text-white p-2 my-3 rounded ' >
                                Assest Clearance
                            </button>}
                        {formObj.resignation && formObj.resignation.reporting_manager_name == JSON.parse(sessionStorage.getItem('dasid'))
                            && <button onClick={() => setHandOverModel(formObj)} className='bg-blue-500 mx-3 text-white p-2 my-3 rounded ' >
                                Work handover
                            </button>}
                    </div>
                    {formObj.resignation && formObj.resignation.HR_manager_name == JSON.parse(sessionStorage.getItem('dasid'))
                        && <button onClick={handleUpdate} disabled={loading}
                            className='p-2 rounded text-white bg-green-500 my-3 ' >
                            {loading ? 'Loading...' : "Submit"}
                        </button>
                    }
                </section>

            </main>
            <AssestModel show={assestModel} setshow={setAssestModel} />
            <HandOverModel show={handoverModel} setshow={setHandOverModel} />
        </div>
    )
}

export default ExitInterviewForm