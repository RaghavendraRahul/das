import React, { useContext } from 'react'
import { HrmStore } from '../Context/HrmContext'
import ReactQuill from 'react-quill';
import { Helmet } from 'react-helmet';
import HeaderLetterPad from '../Components/LetterPad/HeaderLetterPad';
import LetterPadFooter from '../Components/LetterPad/LetterPadFooter';

const InternLetter = ({ data, pdfRef }) => {
    let { getCurrentDate, changeDateYear } = useContext(HrmStore)
    console.log(pdfRef, 'refer');

    return (
        <div  >
            <Helmet >
                <meta name="viewport" content="width=1200" />

            </Helmet>

            <main ref={pdfRef} className="w-[1200px] text-gray-900 mx-auto ">
                {/* Page 1 */}
                <section className='rounded h-[1680px] flex flex-col justify-between shadow-lg ' >

                    <HeaderLetterPad />

                    <div className='mb-auto p-5 py-3 ' >
                        {/* <p>Date : {getCurrentDate()}</p> */}
                        <p>Date : {new Date().toLocaleDateString("en-GB")}</p>

                        <p>
                            <strong>To,</strong> <br />
                            {data && data.Name},<br />
                            {/* S/O {fathersName},<br />
                    {address1},<br />
                    {address2},<br />
                    {city} - {pincode}. */}
                        </p>

                        <h2 className='text-center  w-fit mx-auto ' >Letter of Offer</h2>

                        <p className='my-2 fw-semibold text-black ' >Dear {data.Name},</p>

                        <p>
                            Further to the interviews you had with us and upon agreeing to the Terms and Conditions, Leave Policy,
                            Separation Policy, Working Policy, etc., we are pleased to welcome you as an
                            intern at <span className='fw-semibold text-black ' >
                                Merida Tech Minds</span> as “{data.position_name}”.
                            Your initial place of posting will be at our office in
                            <span className='fw-semibold text-black ' >
                                {data.WorkLocation}, </span>  till the Company intimates you otherwise.
                        </p>

                        <p>Your total stipend will be   <span className='fw-semibold text-black ' >
                            Rs.{data.CTC && Math.round(data.CTC)}/- per month.  </span> The same is subject to all statutory deductions.</p>

                        <p>
                            <span className='fw-semibold text-black ' >
                                Merida Tech Minds</span> is a professionally managed organization in Bangalore. We set forth our customers first and value our customers living by our Motto -
                            <span className='fw-semibold text-black ' >
                                Customer is God.</span>  The same is what has helped us grow to this level in a short span of 8 plus years.
                            At <span className='fw-semibold text-black ' > Merida Tech Minds</span> , we place strong emphasis on our customer, employee, and stakeholder satisfaction.
                        </p>

                        <p>
                            <span className='fw-semibold text-black ' >
                                Merida Tech Minds</span> can offer you the right blend of career growth, international exposure, extensive project exposure, a professional working environment, leadership opportunities, and financial gains over the long term.
                        </p>

                        <p>
                            You will also have the unique satisfaction of being part of growing this organization to the next level and growing along with the organization. We completely believe in a performance-based model and incentivizing our people to the fullest. We believe in equal employment opportunity and also in recognizing talent and potential at the right time. We respect and value our employees and completely believe in offering both personal and professional growth. We believe that your skills and knowledge are a valuable asset to our organization and will contribute immensely towards achieving our goals. We offer a win-win environment
                            where both the organization and you are immensely benefited and we see success together.
                        </p>

                        <h3 className='text-xl ' >Working Hours</h3>
                        <p>
                            Your shift timings and regular working hours will be as per the policy of the company depending on the department and the same can be chosen after discussing with your reporting managers. You will abide by the working hours, weekly offs, and paid holidays of the department, centers, office, or establishment where you are posted. In case of unforeseen events and/or workload, you may be required to work beyond the working hours or on weekly off days/holidays.
                        </p>

                        <h3 className='text-xl ' >Training & Development</h3>
                        <p>
                            You will go through an extensive training with the trainers both internally/externally, and Merida Tech Minds has strict policies and practices in terms of the training policy. You will abide by and will be governed by the Training Policy as long as you are in your training period.
                        </p>

                        <h3 className='text-xl ' >Code of Conduct</h3>
                        <p>
                            During your employment with Merida Tech Minds, you will exhibit professional behavior at all times be it with customers and/or your reporting managers and/or your peers or anybody you come in contact with. You will follow ethical practices in all your work and will remain honest and loyal towards your employer and your profession. Dishonesty and partiality at work or towards any of your team members or anyone else is strictly unacceptable. In the event of any such issues, the company would choose to make the decision based on the severity of the case.
                        </p>

                        <p>
                            Socializing in terms of dating and/or a relationship with another Merida Tech Minds employee who is currently working or an ex-employee of Merida Tech Minds against the Company policy and if any found will lead to termination of services for both the employees. You will follow the company's dress code during all working days and will be presentable at all times.
                        </p>

                    </div>
                    <LetterPadFooter />
                </section>
                {/* Page 2 */}
                <section className='rounded h-[1680px] flex flex-col justify-between shadow-lg my-3' >
                    <HeaderLetterPad />
                    <article className='mb-auto p-5 py-3 ' >
                        <h3 className='text-xl ' >Notice Period</h3>
                        <p>
                            Should you desire to leave the services of Merida Tech Minds, either during your training or immediately after your training or during your Probationary Period or after confirmation of your services, you are required to furnish/serve at
                            least <span className='fw-semibold text-black ' >
                                30 days’ notice period, failing to which 2 months gross compensation to be paid against notice period buyout </span>
                            in lieu thereof, before you can be relieved from the services of Merida Tech Minds. Based on the business necessity and the designation the company holds the right to revisit the notice period.
                        </p>

                        <p className='fw-semibold text-semibold ' >This letter of Offer is from {data.internship_Duration_From && changeDateYear(data.internship_Duration_From)} till {data.internship_Duration_To && changeDateYear(data.internship_Duration_To)}.</p>

                        <p>
                            We shall be obliged if you could kindly confirm your acceptance of the above by returning the duplicate of this letter duly signed by you, to the HR Department. We would be glad to assist you with any queries you may have about joining Merida Tech Minds as we embark on an exciting journey of growth together. We look forward to having you on board.
                        </p>

                        <p>For <span className=' fw-semibold text-semibold ' > Merida Tech Minds (OPC) Pvt. Ltd. </span> </p>
                        <p>Authorized Signatory</p>

                        <p>
                            I accept the offer and my Date of Joining will be on {data.internship_Duration_From && changeDateYear(data.internship_Duration_From)} .
                        </p>

                        <p>
                            Name: {data.Name} <br />
                        </p>
                    </article>
                    <LetterPadFooter />

                </section>

            </main>
        </div>
    )
}

export default InternLetter