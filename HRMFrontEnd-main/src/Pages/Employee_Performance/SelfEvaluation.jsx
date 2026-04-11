// import React, { useContext, useEffect, useRef, useState } from 'react'
// import { Modal } from 'react-bootstrap'
// import { useParams } from 'react-router-dom'
// import InputFieldform from '../../Components/SettingComponent/InputFieldform'
// import axios from 'axios'
// import { port } from '../../App'
// import { HrmStore } from '../../Context/HrmContext'
// import { toast } from 'react-toastify'
// import DownloadButton from '../../Components/Employee/DownloadButton'
// import { usePDF } from 'react-to-pdf'

// const SelfEvaluation = () => {
//     let { id } = useParams()
//     let { getCurrentDate, convertToReadableDateTime } = useContext(HrmStore)
//     let [filledForm, setFilledForm] = useState(false)
//     const { toPDF, targetRef } = usePDF({ Offer_Letter: 'page.pdf' });

//     let user = JSON.parse(sessionStorage.getItem('user'))
//     let [loading, setLoading] = useState(false)
//     let [selfEvaluationData, setSelfEvaluation] = useState({
//         works_to_full_potential: '',
//         quality_of_work: '',
//         work_consistency: '',

//         communication: '',
//         independent_work: '',
//         takes_initiative: '',

//         group_work: '',
//         productivity: '',
//         creativity: '',

//         honesty: '',
//         integrity: '',
//         coworker_relations: '',

//         client_relations: '',
//         technical_skills: '',
//         dependability: '',

//         punctuality: '',
//         attendance: '',
//         overall: '',

//         DATE_OF_REVIEW: '',
//         key_responsibilities: '',
//         performance_assessment_responsibilities: '',
//         performance_and_work_objectives: '',
//         performance_assessment_objectives: '',
//         core_values_assessment: '',
//         employee_signature: ''
//     })
//     let [image, setImage] = useState()
//     let [employeeDetails, setEmployeeDetails] = useState()
//     let handleChange = (e) => {
//         let { name, value, files } = e.target
//         if (name == 'employee_signature') {
//             value = files[0]
//             setImage(URL.createObjectURL(files[0]))
//         }
//         setSelfEvaluation((prev) => ({
//             ...prev,
//             [name]: value
//         }))
//     }
//     let getEmployee = () => {
//         if (id) {
//             axios.get(`${port}/root/lms/GetSelfAppraisal?self_app_id=${id}`).then((response) => {
//                 console.log(response.data);
//                 setEmployeeDetails(response.data.AppraisalInvitation)
//                 setFilledForm(response.data.AppraisalInvitation.is_filled)
//                 setSelfEvaluation(response.data.SelfApprailsal)
//             }).catch((error) => {
//                 console.log(error);
//             })
//         }
//     }
//     useEffect(() => {
//         getEmployee()
//     }, [id])


//     let saveform = () => {
//         const formData = new FormData()
//         // if (!selfEvaluationData.employee_signature) {
//         //     toast.warning('Upload the signature Image')
//         //     return;
//         // }
//         setLoading(true)
//         formData.append('id', id)
//         // formData.append('DATE_OF_REVIEW', selfEvaluationData.DATE_OF_REVIEW)
//         formData.append('attendance', selfEvaluationData.attendance)
//         formData.append('client_relations', selfEvaluationData.client_relations)
//         formData.append('communication', selfEvaluationData.communication)
//         formData.append('core_values_assessment', selfEvaluationData.core_values_assessment)
//         formData.append('coworker_relations', selfEvaluationData.coworker_relations)
//         formData.append('creativity', selfEvaluationData.creativity)
//         formData.append('dependability', selfEvaluationData.dependability)
//         // formData.append('employee_signature', selfEvaluationData.employee_signature)
//         formData.append('group_work', selfEvaluationData.group_work)
//         formData.append('honesty', selfEvaluationData.honesty)
//         formData.append('independent_work', selfEvaluationData.independent_work)
//         formData.append('integrity', selfEvaluationData.integrity)
//         formData.append('key_responsibilities', selfEvaluationData.key_responsibilities)
//         formData.append('performance_and_work_objectives', selfEvaluationData.performance_and_work_objectives)
//         formData.append('performance_assessment_objectives', selfEvaluationData.performance_assessment_objectives)
//         formData.append('performance_assessment_responsibilities', selfEvaluationData.performance_assessment_responsibilities)
//         formData.append('productivity', selfEvaluationData.productivity)
//         formData.append('punctuality', selfEvaluationData.punctuality)
//         formData.append('quality_of_work', selfEvaluationData.quality_of_work)
//         formData.append('takes_initiative', selfEvaluationData.takes_initiative)
//         formData.append('technical_skills', selfEvaluationData.technical_skills)
//         formData.append('work_consistency', selfEvaluationData.work_consistency)
//         formData.append('works_to_full_potential', selfEvaluationData.works_to_full_potential)
//         formData.append('overall', selfEvaluationData.overall)

//         delete selfEvaluationData.employee_signature
//         axios.patch(`${port}/root/lms/GetSelfAppraisal`, selfEvaluationData).then((response) => {
//             toast.success('Form has been submitted')
//             getEmployee()
//             setLoading(false)
//         }).catch((error) => {
//             console.log(error);
//             toast.error('Error Acquired')
//             setLoading(false)
//         })
//     }
//     useEffect(() => {
//         let components = [selfEvaluationData.attendance, selfEvaluationData.works_to_full_potential, selfEvaluationData.quality_of_work,
//         selfEvaluationData.work_consistency, selfEvaluationData.communication, selfEvaluationData.independent_work,
//         selfEvaluationData.takes_initiative, selfEvaluationData.group_work, selfEvaluationData.productivity,
//         selfEvaluationData.creativity, selfEvaluationData.honesty, selfEvaluationData.integrity, selfEvaluationData.coworker_relations,
//         selfEvaluationData.client_relations, selfEvaluationData.technical_skills, selfEvaluationData.dependability,
//         selfEvaluationData.punctuality
//         ]
//         let count = components.reduce((acc, val) => acc + (Number(val) > 0 ? 1 : 0), 0)
//         if (count > 1) {
//             let total = components.reduce((acc, val) => acc + (Number(val) || 0), 0)
//             let avg = (total / count).toFixed(2)
//             setSelfEvaluation((prev) => ({
//                 ...prev,
//                 overall: avg
//             }))
//         }

//     }, [selfEvaluationData.attendance, selfEvaluationData.works_to_full_potential, selfEvaluationData.quality_of_work,
//     selfEvaluationData.work_consistency, selfEvaluationData.communication, selfEvaluationData.independent_work,
//     selfEvaluationData.takes_initiative, selfEvaluationData.group_work, selfEvaluationData.productivity,
//     selfEvaluationData.creativity, selfEvaluationData.honesty, selfEvaluationData.integrity, selfEvaluationData.coworker_relations,
//     selfEvaluationData.client_relations, selfEvaluationData.technical_skills, selfEvaluationData.dependability,
//     selfEvaluationData.punctuality])
//     return (
//         <div className='p-3 poppins'>
//             {
//                 !filledForm || (user && (user.Disgnation == 'Admin' || user.Disgnation == 'HR')) ?


//                     <main ref={targetRef} className='bg-white  rounded p-3 container mx-auto'>

//                         <h5 className='text-center '> PERFORMANCE REVIEW </h5>
//                         <section className='my-3'>
//                             <p className='text-sm fw-semibold '> EMPLOYEE SELF-EVALUATION </p>
//                             <article className='formbg p-3 row  container mx-auto rounded '>
//                                 <InputFieldform label='Employee Name' value={employeeDetails && employeeDetails.employee_name}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />

//                                 <InputFieldform label='Employee ID' value={employeeDetails && employeeDetails.EmployeeId}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />

//                                 <InputFieldform label='Date of current review' value={getCurrentDate()}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />

//                                 <InputFieldform label='Position held' value={employeeDetails && employeeDetails.Designation}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />

//                                 <InputFieldform label='Department' value={employeeDetails && employeeDetails.Department}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />

//                                 {employeeDetails && employeeDetails.filled_on && <InputFieldform label='Date Submitted'
//                                     value={employeeDetails && convertToReadableDateTime(employeeDetails.filled_on)}
//                                     name='works_to_full_potential' disabled={true} limit={10} type='text' />}
//                             </article>

//                         </section>
//                         <section className='my-3'>
//                             <p className='text-sm fw-semibold '> CHARACTERISTICS  </p>
//                             <article className='formbg p-3 row container mx-auto rounded '>
//                                 <InputFieldform label='Work to Full Potential' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.works_to_full_potential}
//                                     name='works_to_full_potential' handleChange={handleChange} limit={10} type='text' />


//                                 <InputFieldform label='Quality of Work' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.quality_of_work}
//                                     name='quality_of_work' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Work Consistency' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.work_consistency}
//                                     name='work_consistency' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Communication' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.communication}
//                                     name='communication' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Independent Work' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.independent_work}
//                                     name='independent_work' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Takes Initiative' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.takes_initiative}
//                                     name='takes_initiative' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Group Work' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.group_work}
//                                     name='group_work' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Productivity' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.productivity}
//                                     name='productivity' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Creativity' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.creativity}
//                                     name='creativity' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Honesty' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.honesty}
//                                     name='honesty' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Integrity' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.integrity}
//                                     name='integrity' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Coworker Relations' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.coworker_relations}
//                                     name='coworker_relations' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Client Relations' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.client_relations}
//                                     name='client_relations' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Technical Skills' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.technical_skills}
//                                     name='technical_skills' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Dependability' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.dependability}
//                                     name='dependability' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Punctuality' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.punctuality}
//                                     name='punctuality' handleChange={handleChange} limit={10} type='text' />

//                                 <InputFieldform label='Attendance' placeholder='1-10' disabled={filledForm} value={selfEvaluationData.attendance}
//                                     name='attendance' handleChange={handleChange} limit={10} type='text' />
//                                 <InputFieldform label='Overall (out of 10) ' placeholder='1-10' disabled={true} value={selfEvaluationData.overall}
//                                     name='overall' handleChange={handleChange} limit={10} type='text' />


//                             </article>

//                         </section>
//                         {/* CURRENT RESPONSIBILITIES */}
//                         <section className='my-3'>
//                             <p className='text-sm fw-semibold '>  CURRENT RESPONSIBILITIES  </p>
//                             <article className='formbg p-3 rounded '>
//                                 <InputFieldform label='List Key Responsibility' placeholder='' disabled={filledForm} value={selfEvaluationData.key_responsibilities}
//                                     name='key_responsibilities' handleChange={handleChange} type='textarea' size='col-12' />

//                                 <InputFieldform label='Assess your performance in relation to your Key Responsibility' placeholder=''
//                                     disabled={filledForm} value={selfEvaluationData.performance_assessment_responsibilities}
//                                     name='performance_assessment_responsibilities' handleChange={handleChange} type='textarea' size='col-12' />


//                             </article>

//                         </section>
//                         {/* PERFORMANCE GOALS */}
//                         <section className='my-3'>
//                             <p className='text-sm fw-semibold '>  PERFORMANCE GOALS  </p>
//                             <article className='formbg p-3 rounded '>
//                                 <InputFieldform label='List of Performance and Work Objectives' placeholder='' disabled={filledForm} value={selfEvaluationData.performance_and_work_objectives}
//                                     name='performance_and_work_objectives' handleChange={handleChange} type='textarea' size='col-12' />

//                                 <InputFieldform label='Assess your performance in regard to previously set performance and work objectives'
//                                     placeholder=''
//                                     disabled={filledForm} value={selfEvaluationData.performance_assessment_objectives}
//                                     name='performance_assessment_objectives' handleChange={handleChange} type='textarea' size='col-12' />
//                             </article>

//                         </section>


//                         {/* CORE VALUES */}
//                         <section className='my-3'>
//                             <p className='text-sm fw-semibold '>  CORE VALUES  </p>
//                             <article className='formbg p-3 rounded '>
//                                 <InputFieldform label='Assess your performance in relation to core values' placeholder=''
//                                     disabled={filledForm} value={selfEvaluationData.core_values_assessment}
//                                     name='core_values_assessment' handleChange={handleChange}
//                                     type='textarea' size='col-12' />

//                             </article>

//                         </section>
//                         {/* Signature */}
//                         {/* <div className='flex flex-col ms-auto items-center w-fit '>
//                             <label htmlFor="signature">
//                                 {typeof selfEvaluationData.employee_signature == 'string' && selfEvaluationData.employee_signature.length > 0 ?
//                                     <img className='w-32 ' src={selfEvaluationData.employee_signature} alt="signature" />
//                                     : !image ? <span className=' text-center text-slate-400 text-sm '>
//                                         upload a image of signature</span>
//                                         : <img src={image} className='w-32 ' alt="image" />}

//                             </label>
//                             <input type="file" id='signature' name='employee_signature' onChange={handleChange} accept="image/*"
//                                 placeholder='write a name' className='text-center 
//                          outline-none hidden w-52 bg-transparent mx-2 border-bottom px-1 border-slate-500 ' />
//                             <p className='p-2 text-xl fw-semibold '>Signature of Employee  </p>
//                         </div> */}
//                         {!filledForm && <button disabled={loading} onClick={saveform} className='btngrd px-3 text-white p-2 rounded  ms-auto flex '>
//                             {loading ? "Loading.." : "Submit"}
//                         </button>}



//                     </main> : <main className='h-[90vh] flex '>
//                         <section className='bgclr sm:w-1/2 m-auto h-[30vh] rounded flex  ' >
//                             <p className='text-center m-auto'>
//                                 Form Submitted !!!
//                                 <span className='m-auto block'   >
//                                     Thank You !!
//                                 </span>
//                             </p>
//                         </section>

//                     </main>
//             }
//             {/* {
//                 filledForm &&
//                 <div className='my-3 flex w-fit ms-auto '>
//                     <DownloadButton toPDF={toPDF} />
//                 </div>
//             } */}
//         </div>
//     )
// }

// export default SelfEvaluation









import React, { useContext, useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { HrmStore } from '../../Context/HrmContext'
import { toast } from 'react-toastify'
import { usePDF } from 'react-to-pdf'

const SelfEvaluation = () => {
    let { id } = useParams()
    let { getCurrentDate, convertToReadableDateTime } = useContext(HrmStore)
    let [filledForm, setFilledForm] = useState(false)
    const { toPDF, targetRef } = usePDF({ Offer_Letter: 'page.pdf' });

    let user = JSON.parse(sessionStorage.getItem('user'))
    let [loading, setLoading] = useState(false)
    let [selfEvaluationData, setSelfEvaluation] = useState({
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
        DATE_OF_REVIEW: '',
        key_responsibilities: '',
        performance_assessment_responsibilities: '',
        performance_and_work_objectives: '',
        performance_assessment_objectives: '',
        core_values_assessment: '',
        employee_signature: ''
    })
    let [image, setImage] = useState()
    let [employeeDetails, setEmployeeDetails] = useState()

    const handleChange = (e) => {
        let { name, value, files } = e.target
        if (name === 'employee_signature') {
            value = files[0]
            setImage(URL.createObjectURL(files[0]))
        }
        setSelfEvaluation((prev) => ({
            ...prev,
            [name]: value
        }))
    }

    const getEmployee = () => {
        if (id) {
            // axios.get(`${port}/root/lms/GetSelfAppraisal?self_app_id=${id}`)

            setLoading(true) 
            axios.get(`${port}/root/lms/GetSelfAppraisal/?self_app_id=${id}`)
                .then((response) => {
                    console.log('Employee data fetched:', response.data);
                    setEmployeeDetails(response.data.AppraisalInvitation)
                    setFilledForm(response.data.AppraisalInvitation.is_filled)

                    // Properly set all data including DATE_OF_REVIEW
                    const selfAppraisalData = response.data.SelfApprailsal || {};
                    setSelfEvaluation({
                        ...selfAppraisalData,
                        DATE_OF_REVIEW: selfAppraisalData.DATE_OF_REVIEW || getCurrentDate()
                    })
                    setLoading(false)
                })
                .catch((error) => {
                    console.error('Error fetching employee data:', error);

                    // Handle different error scenarios with detailed messages
                    if (error.response) {
                        const errorData = error.response.data;

                        // If backend sent structured error with details
                        if (errorData && typeof errorData === 'object') {
                            console.error('Detailed error:', errorData);

                            // Handle 500 errors (data integrity, serialization issues)
                            if (error.response.status === 500) {
                                let errorMsg = errorData.error || 'Internal Server Error';
                                let detailsMsg = errorData.details || '';
                                let helpMsg = errorData.help || '';

                                toast.error(
                                    `${errorMsg}\n\n${detailsMsg}\n\n${helpMsg}`,
                                    { autoClose: 3000 }
                                );

                                // Log the full error for debugging
                                console.error('500 Error Details:', {
                                    error: errorMsg,
                                    details: detailsMsg,
                                    type: errorData.type,
                                    help: helpMsg
                                });
                            }
                            // Show available IDs if provided (404 errors)
                            else if (errorData.available_ids && errorData.available_ids.length > 0) {
                                console.log('Available Self Evaluation IDs:', errorData.available_ids);
                                toast.error(
                                    `${errorData.error}: ${errorData.details}\n\n` +
                                    `Available IDs: ${errorData.available_ids.join(', ')}\n` +
                                    `Total records: ${errorData.total_records}`,
                                    { autoClose: 3000 }
                                );
                            } else if (errorData.total_records === 0) {
                                toast.error(
                                    'No self evaluation records found in the database.\n\n' +
                                    'Please create an appraisal invitation first.',
                                    { autoClose: 3000 }
                                );
                            } else {
                                toast.error(errorData.error || errorData.details || 'Failed to load form data');
                            }
                        } else {
                            // Simple string error
                            toast.error(errorData || 'Failed to load form data. Please try again.');
                        }
                    } else if (error.request) {
                        toast.error('No response from server. Please check if the backend is running.');
                    } else {
                        toast.error('Error setting up the request. Please try again.');
                    }

                    setLoading(false)
                })
        }
    }

    useEffect(() => {
        getEmployee()
    }, [id])

    const saveform = () => {
        // Validation: Check if required fields are filled
        if (!selfEvaluationData.works_to_full_potential || !selfEvaluationData.quality_of_work) {
            toast.warning('Please fill in all the required characteristic ratings');
            return;
        }

        setLoading(true)

        // Prepare data for submission
        const dataToSubmit = {
            id: id,
            ...selfEvaluationData
        }

        // Remove problematic fields that cause validation errors
        // DATE_OF_REVIEW - not being properly formatted, and it's not essential for submission
        delete dataToSubmit.DATE_OF_REVIEW;

        // employee_signature - field is required in model but we're not collecting it (commented out in form)
        delete dataToSubmit.employee_signature;

        console.log('Data to submit:', dataToSubmit);

        // axios.patch(`${port}/root/lms/GetSelfAppraisal`, {

        axios.patch(`${port}/root/lms/GetSelfAppraisal/`, dataToSubmit)
            .then((response) => {
                console.log('Form submitted successfully:', response.data);
                toast.success('Form has been submitted successfully!')
                getEmployee()
                setLoading(false)
            })
            .catch((error) => {
                console.error('Error submitting form:', error);

                // Better error messaging
                if (error.response) {
                    if (error.response.status === 404) {
                        toast.error('Submission endpoint not found. Please contact support.');
                    } else if (error.response.data && error.response.data.error) {
                        toast.error(`Error: ${error.response.data.error}`);
                    } else if (error.response.data) {
                        // Show validation errors if present
                        console.error('Validation errors:', error.response.data);
                        const errorMessages = Object.entries(error.response.data)
                            .map(([field, messages]) => `${field}: ${Array.isArray(messages) ? messages.join(', ') : messages}`)
                            .join('\n');
                        toast.error(`Validation errors:\n${errorMessages}`);
                    } else {
                        toast.error('Failed to submit form. Please try again.');
                    }
                } else {
                    toast.error('Network error. Please check your connection.');
                }
                setLoading(false)
            })
    }

    // Overall calculation
    useEffect(() => {
        let components = [
            selfEvaluationData.attendance,
            selfEvaluationData.works_to_full_potential,
            selfEvaluationData.quality_of_work,
            selfEvaluationData.work_consistency,
            selfEvaluationData.communication,
            selfEvaluationData.independent_work,
            selfEvaluationData.takes_initiative,
            selfEvaluationData.group_work,
            selfEvaluationData.productivity,
            selfEvaluationData.creativity,
            selfEvaluationData.honesty,
            selfEvaluationData.integrity,
            selfEvaluationData.coworker_relations,
            selfEvaluationData.client_relations,
            selfEvaluationData.technical_skills,
            selfEvaluationData.dependability,
            selfEvaluationData.punctuality
        ]

        let count = components.reduce((acc, val) => acc + (Number(val) > 0 ? 1 : 0), 0)
        if (count > 1) {
            let total = components.reduce((acc, val) => acc + (Number(val) || 0), 0)
            let avg = (total / count).toFixed(2)
            setSelfEvaluation((prev) => ({
                ...prev,
                overall: avg
            }))
        }

    }, [
        selfEvaluationData.attendance,
        selfEvaluationData.works_to_full_potential,
        selfEvaluationData.quality_of_work,
        selfEvaluationData.work_consistency,
        selfEvaluationData.communication,
        selfEvaluationData.independent_work,
        selfEvaluationData.takes_initiative,
        selfEvaluationData.group_work,
        selfEvaluationData.productivity,
        selfEvaluationData.creativity,
        selfEvaluationData.honesty,
        selfEvaluationData.integrity,
        selfEvaluationData.coworker_relations,
        selfEvaluationData.client_relations,
        selfEvaluationData.technical_skills,
        selfEvaluationData.dependability,
        selfEvaluationData.punctuality
    ])

    return (
        <div className='p-3 poppins'>
            {/* ADDED: Loading state indicator */}
            {loading && !employeeDetails ? (
                <div className='d-flex justify-content-center align-items-center' style={{ minHeight: '400px' }}>
                    <div className='text-center'>
                        <div className="spinner-border text-primary" role="status">
                            <span className="visually-hidden">Loading...</span>
                        </div>
                        <p className='mt-3'>Loading form data...</p>
                    </div>
                </div>
            ) : (
                <>
                    {
                        !filledForm || (user && (user.Disgnation === 'Admin' || user.Disgnation === 'HR')) ?
                            <main ref={targetRef} className='bg-white  rounded p-3 container mx-auto'>
                                <h5 className='text-center'>PERFORMANCE REVIEW</h5>

                                {/* Employee Info */}
                                <section className='my-3'>
                                    <p className='text-sm fw-semibold'>EMPLOYEE SELF-EVALUATION</p>
                                    <article className='formbg p-3 row container mx-auto rounded'>
                                        <InputFieldform label='Employee Name' value={employeeDetails?.employee_name || ''} name='employee_name' disabled={true} type='text' />
                                        <InputFieldform label='Employee ID' value={employeeDetails?.EmployeeId || ''} name='employee_id' disabled={true} type='text' />
                                        <InputFieldform label='Date of current review' value={getCurrentDate()} name='DATE_OF_REVIEW' disabled={true} type='text' />
                                        <InputFieldform label='Position held' value={employeeDetails?.Designation || ''} name='designation' disabled={true} type='text' />
                                        <InputFieldform label='Department' value={employeeDetails?.Department || ''} name='department' disabled={true} type='text' />
                                        {employeeDetails?.filled_on && <InputFieldform label='Date Submitted' value={convertToReadableDateTime(employeeDetails.filled_on)} name='date_submitted' disabled={true} type='text' />}
                                    </article>
                                </section>

                                {/* Characteristics */}
                                <section className='my-3'>
                                    <p className='text-sm fw-semibold'>CHARACTERISTICS</p>
                                    <article className='formbg p-3 row container mx-auto rounded'>
                                        {Object.keys(selfEvaluationData).map((key) => {
                                            if (['overall', 'employee_signature', 'DATE_OF_REVIEW', 'key_responsibilities', 'performance_assessment_responsibilities', 'performance_and_work_objectives', 'performance_assessment_objectives', 'core_values_assessment'].includes(key)) return null
                                            return (
                                                <InputFieldform
                                                    key={key}
                                                    label={key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}
                                                    placeholder='1-10'
                                                    disabled={filledForm}
                                                    value={selfEvaluationData[key]}
                                                    name={key}
                                                    handleChange={handleChange}
                                                    limit={10}
                                                    type='text'
                                                />
                                            )
                                        })}
                                        <InputFieldform label='Overall (out of 10)' placeholder='1-10' disabled={true} value={selfEvaluationData.overall} name='overall' type='text' />
                                    </article>
                                </section>

                                {/* Current Responsibilities */}
                                <section className='my-3'>
                                    <p className='text-sm fw-semibold'>CURRENT RESPONSIBILITIES</p>
                                    <article className='formbg p-3 rounded'>
                                        <InputFieldform label='List Key Responsibility' placeholder='' disabled={filledForm} value={selfEvaluationData.key_responsibilities} name='key_responsibilities' handleChange={handleChange} type='textarea' size='col-12' />
                                        <InputFieldform label='Assess your performance in relation to your Key Responsibility' placeholder='' disabled={filledForm} value={selfEvaluationData.performance_assessment_responsibilities} name='performance_assessment_responsibilities' handleChange={handleChange} type='textarea' size='col-12' />
                                    </article>
                                </section>

                                {/* Performance Goals */}
                                <section className='my-3'>
                                    <p className='text-sm fw-semibold'>PERFORMANCE GOALS</p>
                                    <article className='formbg p-3 rounded'>
                                        <InputFieldform label='List of Performance and Work Objectives' placeholder='' disabled={filledForm} value={selfEvaluationData.performance_and_work_objectives} name='performance_and_work_objectives' handleChange={handleChange} type='textarea' size='col-12' />
                                        <InputFieldform label='Assess your performance in regard to previously set performance and work objectives' placeholder='' disabled={filledForm} value={selfEvaluationData.performance_assessment_objectives} name='performance_assessment_objectives' handleChange={handleChange} type='textarea' size='col-12' />
                                    </article>
                                </section>

                                {/* Core Values */}
                                <section className='my-3'>
                                    <p className='text-sm fw-semibold'>CORE VALUES</p>
                                    <article className='formbg p-3 rounded'>
                                        <InputFieldform label='Assess your performance in relation to core values' placeholder='' disabled={filledForm} value={selfEvaluationData.core_values_assessment} name='core_values_assessment' handleChange={handleChange} type='textarea' size='col-12' />
                                    </article>
                                </section>

                                {/* Submit Button */}
                                {!filledForm &&
                                    <button disabled={loading} onClick={saveform} className='btngrd px-3 text-white p-2 rounded ms-auto flex'>
                                        {loading ? "Submitting..." : "Submit"}
                                    </button>
                                }

                            </main>
                            :
                            <main className='h-[90vh] flex'>
                                <section className='bgclr sm:w-1/2 m-auto h-[30vh] rounded flex'>
                                    <p className='text-center m-auto'>
                                        Form Submitted !!!
                                        <span className='m-auto block'>Thank You !!</span>
                                    </p>
                                </section>
                            </main>
                    }
                </>
            )}
        </div>
    )
}

export default SelfEvaluation