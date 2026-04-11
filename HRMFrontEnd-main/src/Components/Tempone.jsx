import axios from 'axios';
import React, { useContext, useState } from 'react'
import { usePDF } from 'react-to-pdf';
import { domain, port } from '../App'
import HrmContext, { HrmStore } from '../Context/HrmContext';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import { useParams } from 'react-router-dom';
import { Helmet } from 'react-helmet';
import HeaderLetterPad from './LetterPad/HeaderLetterPad';
import LetterPadFooter from './LetterPad/LetterPadFooter';



const Tempone = ({ data, targetRef }) => {
    let { changeDateYear } = useContext(HrmStore)
    let offer_letter_data = JSON.parse(sessionStorage.getItem('offer_letter_form'))
    let Login = JSON.parse(sessionStorage.getItem('user'))

    let [loading, setloading] = useState(false)
    const convertDivToPDFAndSend = async () => {
        const input = document.getElementById('contentpdf');
        if (!input) {
            console.error("Div not found");
            return;
        }
        setloading(true)
        try {
            const canvas = await html2canvas(input);

            // Create a new jsPDF instance
            const pdf = new jsPDF('p', 'px', [canvas.width, canvas.height + 10]);
            const imgData = canvas.toDataURL('image/png');

            // Add image data to PDF
            pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height);

            pdf.save('orignal.pdf')
            // Generate the PDF as a Blob
            const pdfBlob = pdf.output('blob');
            return

            // Create a File object from the Blob
            const pdfFile = new File([pdfBlob], 'divContent.pdf', { type: 'application/pdf' });

            console.log(pdfFile);
            // return
            // Create FormData and append the PDF Blob
            const formData = new FormData();
            formData.append('PDF_File', pdfFile,);

            // Send the PDF to the backend
            const response = await axios.post(`${port}/root/Offerletter/${offer_letter_data.offer_letter_ID}/`, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });
            setloading(false)
            console.log('PDF sent successfully', response.data);
        } catch (error) {
            setloading(false)
            console.error('Error converting div to PDF and sending:', error);
        }
    };
    console.log("jellow", data);
    const currentDate = new Date();
    const formattedDate = `${currentDate.getDate()}-${currentDate.getMonth() + 1}-${currentDate.getFullYear()}`;

    return (
        <>
            <Helmet >
                <meta name="viewport" content="width=1200" />

            </Helmet>

            <div id='contentpdf' className=' p-4 ' >

                <main ref={targetRef} className="w-[1200px] text-gray-900 mx-auto ">
                    {/* Page 1 */}
                    <section className='rounded h-[1680px] flex flex-col justify-between shadow-lg ' >

                        <HeaderLetterPad />

                        {/* content */}
                        <article className='p-5 mb-auto' >



                            {/* Letter Heading */}
                            <p className="text-right mb-8">
                                <span className="font-semibold">Date: </span>
                                <span className="underline"> {formattedDate} </span>
                            </p>

                            {/* Recipient Details */}
                            <div className="mb-8">
                                <p><span className="font-semibold">To, </span><span>{data.Name}</span></p>
                                {/* <p>S/O {fathersName},</p>
                        <p>{address1},</p>
                        <p>{address2},</p>
                        <p>{city} - {pincode}</p> */}
                            </div>

                            {/* Letter Title */}
                            <h2 className="text-center font-bold text-xl underline mb-4">Letter of Appointment</h2>

                            {/* Introduction Paragraph */}
                            <p className="mb-6 leading-relaxed">
                                Further to the subsequent meetings and interviews, we are pleased to appoint you as
                                “<span className="font-semibold">{data.position_name}</span>” effective {data && data.Date_of_Joining && changeDateYear(data.Date_of_Joining)}.
                                As per the requirement of our company, your appointment will be on the terms and conditions mentioned below: -
                            </p>

                            {/* Content Sections */}
                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Commencement Date</h6>
                                <p>
                                    Your appointment will be effective {data && data.Date_of_Joining && changeDateYear(data.Date_of_Joining)}.
                                    This offer of appointment is valid only till the date of joining you have accepted and committed as per the offer letter,
                                    and it will automatically cease in the event of you not joining us by the said date.
                                </p>
                            </section>

                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Place of Work</h6>
                                <ol className='list-outside list-decimal ' >
                                    <li>
                                        Your place of posting will be at our office in <span className='fw-semibold ' >
                                            {data.WorkLocation}  </span>  , till the Company intimates you otherwise.
                                    </li>
                                    <li>
                                        You are liable to be transferred from one job to another job, or from one Department to another Department,
                                        any Centers/Branches or associate company of <span className='text-slate-900 fw-semibold ' >
                                            “Merida Tech Minds (OPC) Pvt. Ltd” </span>, as existing or may be set up in future within or outside India. In such cases,
                                        you will automatically be governed by the terms and conditions of employment applicable to you in the transferee company.
                                    </li>
                                </ol>
                            </section>

                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Salary and Benefits</h6>
                                <p className='fw-semibold ' >Fixed Pay:</p>
                                <ol className='list-decimal ' >
                                    <li>
                                        Your Fixed compensation will be Rs. <span className='fw-semibold ' >
                                            {data.CTC}/- per annum.  </span> The same is subject to
                                        all statutory deductions.
                                    </li>
                                    <li> Fixed Pay will be paid on a Monthly basis. </li>
                                </ol>

                                <p className='fw-semibold ' >Compensation will be paid based on your performance and the company policy.</p>
                                <ol className='list-decimal ' >
                                    <li className="">Your Salary paid, as agreed in this appointment letter or as agreed in your salary revision letter if there any, has been offered and agreed to be paid by the employer towards the delivery of your Key Result Area - KRA as agreed in your KRA Documentation.
                                    </li>
                                    <li className="">Your individual salary package and payments is purely a matter of utmost confidentiality between you and company and has been arrived at on the basis of job, skills and professional merit. We expect you to maintain this information and any changes
                                        pertaining to your remuneration made from time to time as personal and confidential.</li>
                                </ol>
                            </section>
                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Working Hours</h6>
                                <ol className=' list-decimal ' >
                                    <li>Your shift timing and regular working hours will be as per the policy of the company depending on the department and the same can be chosen after discussing with your
                                        reporting managers.</li>
                                    <li>You will be abide by the working hours, weekly offs and paid holidays of the department, Centers, office or establishment where you are posted. In case of unforeseen events and/or workload you may be required to work beyond the working hours or
                                        on weekly off days /holidays.</li>
                                </ol>

                            </section>

                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Training & Development</h6>
                                <ol className=' list-decimal ' >
                                    <li>You will go through an extensive training with the trainers both internally / externally and have strict policies and practices in terms of the training policy. You will abide by and will be governed by the Training Policy as long as you are in your
                                        training period.</li>
                                    <li>If the performance during your training period / results are not as expected, then the company holds the right to extend your training period and/or
                                        change your role based on where it seems fit and/or on your continuity of the employment / services. And the company holds the
                                        right to do so without any prior notice or notice in lieu.
                                    </li>
                                </ol>
                            </section>
                            <section>
                                <h6 className="font-semibold text-decoration-underline "> Job Assignment and Reporting </h6>
                                <p>
                                    In your assignment, you will be responsible for the duties based on the role assigned to you, as more particularly laid out in the job description for this position. You will report directly to the supervisor nominated by the Management. The Key Responsibilities
                                    Areas would be given to you on joining the duty.
                                </p>
                            </section>
                        </article>
                        <LetterPadFooter />
                    </section>
                    {/* Page 2 */}
                    <section className='shadow my-3 h-[1680px] flex flex-col justify-between bg-white rounded ' >
                        <HeaderLetterPad />
                        <article className='mb-auto p-5 ' >



                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Probation and Confirmation of Services</h6>
                                <ol className='list-decimal ' >
                                    <li>You will be on a Probation Period of six (6) months from the date of acceptance of this offer. Your employment will be confirmed by a letter of confirmation subject to satisfactory work, conduct attendance and continue to serve the company on the terms hereinafter contained or as the same may from time to time be modified by
                                        mutual consent.</li>
                                    <li> The management reserves the right to extend the period of probation, if your capability and conduct during the period is
                                        not satisfactory and the company has the right to initiate
                                        closure based on the case. </li>
                                    <li>
                                        During the probation period or the extended period of probation, an Employee is bound to provide the company with
                                        the needed notice period or as per policy under Separation / Termination of Services clause as per this appointment letter.
                                    </li>
                                    <li>
                                        By signing this letter, you consent hereby, that if you leave the company within 6 months of joining, the company reserves the right to
                                        recover any cost incurred during your recruitment and training and/or any other cost that may be deemed to be considered by the company during your exit and it is at the discretion of the company to initiate the same.
                                    </li>
                                </ol>
                            </section>
                            {/* Leave */}
                            <section>
                                <h6 className="font-semibold text-decoration-underline ">Leaves and Permissions </h6>
                                <ol className='list-decimal ' >
                                    <li>Your leaves and permissions will be available as per the leave policy of the company and the same is subject to be revised every year or as deemed fit.
                                    </li>
                                    <li>All leaves and Permissions need prior approval from your immediate reporting manager over an email. In case of any emergency leaves or permissions is needed you are expected to inform your immediate
                                        reporting manager in person or over the phone and NO SMS or passing on information through your peers or colleagues or at the front office will be accepted. Unless the leaves or permissions are approved by your manager,
                                        the same will be considered only as unapproved and will be processed as per the same.</li>
                                    <li>
                                        In case if you are absent from work for more than <span className='fw-semibold text-decoration-underline ' >  three(3) consecutive days,
                                        </span> without informing your Reporting Manager/ HR Department, the management reserves the right to terminate your services with immediate effect on the grounds of no call /
                                        no show to work and unapproved leaves and the Company reserves the right to recover the damages, by issuing a Notice. </li>
                                </ol>
                            </section>
                            {/* Code of contact */}
                            <section>
                                <h6 className="font-semibold text-decoration-underline "> Code of Conduct </h6>
                                <ol className='list-decimal  ' >
                                    <li>During your employment with Merida Tech Minds, you will exhibit professional behavior at all times be it with customers and/or your reporting managers and/or your peers or
                                        anybody you come in contact with.</li>
                                    <li>You will follow ethical practices in all your work and will remain honest and loyal towards your employer and your profession. Dishonesty and partiality at work or towards any of your team members or anyone else is strictly unacceptable. In the event of any such issues,
                                        the company would choose to make the decision based on the severity of the case.</li>
                                    <li>Socializing in terms of dating and/or a relationship with another Merida Tech Minds, employee who is currently working or an ex-employee of Merida Tech Minds against the Company policy and if any found will lead to
                                        termination of services for both the employees.</li>
                                    <li>Blood relations / Husband and wife will not be offered and cannot be employed with Merida Tech Minds at the same time. If any information pertaining to the same is hidden or misguided by any employee then the employer
                                        will initiate for closure of employment.</li>
                                    <li>You will follow the company's dress code during all working days and will be presentable at all times.  </li>
                                    <li>You shall not form any union of the Employee of the Company or join any union and/or instigate or persuade any employees of the Company to join a Union of Employees or Workers. If found and proven otherwise the company not only holds the right to initiate separation of employment but also to claim any loss incurred by the company due to
                                        such an act either across the table or through legal proceedings.</li>
                                    <li>Merida Tech Minds uses the National Skills Registry for verification of employment purposes. Your profile will be created (if one is not available already) and all your details will be updated in NSR
                                        (National Skills Registry) including your mode of exit from the company.</li>
                                </ol>
                            </section>
                            <p>
                                You will be governed by the company's Policies and Procedures and be guided by the employee handbook.
                            </p>


                        </article >
                        <LetterPadFooter />


                    </section>
                    {/* Page 3 */}
                    <section className='shadow my-[15px] h-[1680px] flex flex-col justify-between bg-white rounded ' >
                        <HeaderLetterPad />
                        <article className='mb-0  p-5' >
                            {/* Seperation and leave */}
                            <section>
                                <h6 className="font-semibold text-decoration-underline "> Separation / Termination of Employment </h6>
                                <ol className='list-decimal  ' >
                                    <li>Should you desire to leave the services of Merida Tech Minds, either during your training or immediately after your training or during your Probationary Period or after confirmation of your services, you are required to furnish/serve at least
                                        <span className=' text-decoration-underline fw-semibold ' >
                                            45 days’ notice period, failing to which Rs.50,000/- compensation to be paid against notice period buyout    </span>
                                        in lieu thereof, before you can be relieved from the services of Merida Tech Minds. Based on the business necessity and the designation the
                                        company holds the right to revisit the notice period.   <br /> <br />
                                        The 45 days salary compensation option is applicable and available only for employees who have successfully completed their probationary period and who informs on their resignation and who separate from the Company on a mutual note (where company has   agreed upon relieving without notice period but in compensation in lieu paid in full)
                                        without serving the notice period. <br /> <br />
                                        Either during the course of Probationary period or after completion of the probationary, <span className='fw-semibold ' >
                                            if the separation is without any information and not turning up to work resulting in absconding from one's work then you will be liable to pay Rs.50,000/- or 45 Days compensation whichever is higher towards your compensation.</span>
                                        In lieu of not abiding by the same,
                                        the company shall proceed in Termination and will proceed legally to claim/recover what is agreed in this letter.
                                    </li>
                                    <li>During your probation period, based on not clearing the training, failing to clear the background verification, medical or Criminal verification and/or failure to provide sufficient documentary evidence and /or non-performance and /or any ethical and / or behavioral issues and/or any other concerns that is against the policy and practice of Merida Tech Minds, your employment with the “Merida Tech Minds”,
                                        can be terminated without any notice or salary in lieu.</li>

                                    <li>Any breach of the terms and conditions of your employment or are guilty of misconduct
                                        (including drunkenness, dishonesty, absence without notice, infringement of the company’s regulations and disobedience to lawful orders or instructions) or conduct yourself in a manner calculated to bring to the company or its employees into disrepute or if you borrow money from any of the clients of the company or from anyone associated with the company, you will be discharged immediately from the company without any notice or salary in lieu of notice and in such case you will
                                        have no claim from the company whatsoever.</li>

                                    <li>The company believes in performance and in giving equal opportunity to all employees to come forth with their performance. However the company holds the right to end your employment on the grounds of non-performance / lack of performance and the process will be governed as per the Performance Improvement Plan (PIP) followed by the Company. The grounds of non-performance / lack of performance will be as explained and detailed in the Performance Improvement Plan (PIP).
                                        The Plan is subject to change based on the current industry and company standards.</li>

                                    <li>Your Date of Birth as confirmed by you is <span className='fw-semibold ' >
                                        {data.DOB}  </span> and you will retire from the services of the company on the day you complete 58 years of age.
                                        The company, however, reserves the right to modify and amend the retirement policy and age. </li>

                                    <li>You must be physically and mentally fit to be able to handle the role given and the same must be certified by an authorized medical practitioner (acceptable and suggested by the company only). If found otherwise either before your employment or while your employment with Merida Tech Minds, the company holds all rights to make the needed decision based on the severity of the case. You will be signing a medical declaration form,
                                        and the further proceedings will be as per the same.</li>

                                </ol>
                            </section>
                            <p>
                                Please confirm your acceptance of this appointment by returning the enclosed copy of this letter and the declaration of Secrecy Agreement of Non-Disclosure /Confidentiality duly signed. We welcome you to “Merida Tech Minds(OPC) Pvt Ltd” and very much hope that your period of service with us will be long, pleasant and you will work towards fulfilling your career aspirations.
                                Looking forward to your contribution in achieving our success plans.
                            </p>
                            <p>
                                We wish you all the very Best!
                            </p>
                            <p>
                                Yours Sincerely <br />
                                For <span className='fw-semibold ' >
                                    Merida Tech Minds (OPC) Pvt. Ltd. </span>

                            </p>
                            {/* Add additional sections similarly */}


                            {/* Declaration Section */}
                            <div className="mt-8 pt-4 border-t">
                                <h6 className="font-semibold underline mb-2">Declaration</h6>
                                <p className="mb-4">
                                    I abide by the conditions stipulated in the Letter of Appointment dated {data && data.Date_of_Joining && changeDateYear(data.Date_of_Joining)} and as desired.
                                </p>
                                <p>I will join the services on {data && data.Date_of_Joining && changeDateYear(data.Date_of_Joining)}</p>

                                {/* Signature Section */}
                                <div className="mt-4">
                                    <p>Name: <span className="underline">{data.Name} </span></p>

                                </div>
                            </div>
                        </article>
                        <LetterPadFooter />
                    </section>
                </main >


            </div >


        </>


    )
}

export default Tempone