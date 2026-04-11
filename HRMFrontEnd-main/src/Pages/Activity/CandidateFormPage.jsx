import React, { useState } from 'react';
import axios from 'axios';
import { port } from '../../App';
import { useSearchParams } from 'react-router-dom';
import { toast } from 'react-toastify';

const CandidateFormPage = () => {
    const [searchParams] = useSearchParams();
    const ref = searchParams.get('ref');

    const [formData, setFormData] = useState({
        ref: ref || '',
        candidate_name: '',
        candidate_phone: '',
        candidate_email: '',
        candidate_location: '',
        candidate_designation: '',
        candidate_current_status: '',
        candidate_experience: '',
        industries_worked: '',
        source: '',
        expected_ctc: '',
        current_ctc: '',
        DOJ: '',
        have_laptop: null,
        candidate_for: '',
        interview_status: '',
        message_to_candidates: '',
        interview_call_remarks: ''
    });

    const [loading, setLoading] = useState(false);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault(); 
        setLoading(true);

        try {
            const cleanedData = { ...formData }; 

            const numericFields = ['candidate_experience', 'expected_ctc', 'current_ctc']; 
            numericFields.forEach(field => {
                if (cleanedData[field] === '' || cleanedData[field] === null) {
                    delete cleanedData[field];
                }
            }); 

            const optionalFields = ['industries_worked', 'source', 'DOJ', 'candidate_for', 'interview_status', 'message_to_candidates', 'interview_call_remarks', 'candidate_location', 'candidate_designation'];
            optionalFields.forEach(field => {
                if (cleanedData[field] === '') {
                    delete cleanedData[field];
                }
            });

            if (cleanedData.have_laptop === '' || cleanedData.have_laptop === 'null') {
                cleanedData.have_laptop = null;
            } else if (cleanedData.have_laptop === 'true') {
                cleanedData.have_laptop = true;
            } else if (cleanedData.have_laptop === 'false') {
                cleanedData.have_laptop = false;
            }

            console.log(cleanedData);
            const response = await axios.post(`${port}/root/public/submit-candidate-form`, cleanedData); 
            toast.success(response.data.message || 'Form submitted successfully!');

            setFormData({
                ref: ref || '',
                candidate_name: '',
                candidate_phone: '',
                candidate_email: '',
                candidate_location: '',
                candidate_designation: '',
                candidate_current_status: '',
                candidate_experience: '',
                industries_worked: '',
                source: '',
                expected_ctc: '',
                current_ctc: '',
                DOJ: '',
                have_laptop: null,
                candidate_for: '',
                interview_status: '',
                message_to_candidates: '',
                interview_call_remarks: ''
            });
        } catch (error) {
            toast.error(error.response?.data?.error || 'Failed to submit form');
            console.error('Form submission error:', error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-gray-100">

            <div className="flex justify-center py-10 px-4">
                <div className="w-full max-w-3xl bg-white shadow-xl rounded-2xl overflow-hidden">

                    <div className="bg-gradient-to-r from-indigo-500 to-purple-600 py-8 text-center text-white">
                        <h3 className="text-2xl font-bold">Candidate Interview Application</h3>
                        <p className="opacity-90 text-sm">Please fill in your details below to apply</p>
                    </div>

                    <div className="p-8">
                        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-6">

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Full Name <span className="text-red-500">*</span></label>
                                <input
                                    type="text"
                                    name="candidate_name"
                                    value={formData.candidate_name}
                                    onChange={handleChange}
                                    required
                                    placeholder="Enter your full name"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Phone Number <span className="text-red-500">*</span></label>
                                <input
                                    type="tel"
                                    name="candidate_phone"
                                    value={formData.candidate_phone}
                                    onChange={handleChange}
                                    maxLength={10}
                                    required
                                    placeholder="10-digit mobile number"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Email <span className="text-red-500">*</span></label>
                                <input
                                    type="email"
                                    name="candidate_email"
                                    value={formData.candidate_email}
                                    onChange={handleChange}
                                    required
                                    placeholder="your.email@example.com"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Location</label>
                                <input
                                    type="text"
                                    name="candidate_location"
                                    value={formData.candidate_location}
                                    onChange={handleChange}
                                    placeholder="City, State"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Desired Designation</label>
                                <input
                                    type="text"
                                    name="candidate_designation"
                                    value={formData.candidate_designation}
                                    onChange={handleChange}
                                    placeholder="e.g., Software Developer"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Experience Level</label>
                                <select
                                    name="candidate_current_status"
                                    value={formData.candidate_current_status}
                                    onChange={handleChange}
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                >
                                    <option value="">Select</option>
                                    <option value="fresher">Fresher</option>
                                    <option value="experience">Experienced</option>
                                </select>
                            </div>

                            {formData.candidate_current_status === "experience" && (
                                <>
                                    <div>
                                        <label className="block font-semibold text-gray-700 mb-1">Experience (Years)</label>
                                        <input
                                            type="number"
                                            name="candidate_experience"
                                            value={formData.candidate_experience}
                                            onChange={handleChange}
                                            placeholder="Years of experience"
                                            className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                        />
                                    </div>

                                    <div>
                                        <label className="block font-semibold text-gray-700 mb-1">Industries Worked</label>
                                        <input
                                            type="text"
                                            name="industries_worked"
                                            value={formData.industries_worked}
                                            onChange={handleChange}
                                            placeholder="IT, Finance, etc."
                                            className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                        />
                                    </div>

                                    <div>
                                        <label className="block font-semibold text-gray-700 mb-1">Current CTC (Annual)</label>
                                        <input
                                            type="number"
                                            name="current_ctc"
                                            value={formData.current_ctc}
                                            onChange={handleChange}
                                            placeholder="In rupees"
                                            className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                        />
                                    </div>
                                </>
                            )}

                            {formData.candidate_current_status === "fresher" && (
                                <div>
                                    <label className="block font-semibold text-gray-700 mb-1">Applying For</label>
                                    <select
                                        name="candidate_for"
                                        value={formData.candidate_for}
                                        onChange={handleChange}
                                        className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                    >
                                        <option value="">Select</option>
                                        <option value="OJT">On-the-Job Training (OJT)</option>
                                        <option value="Internal_Hiring">Internal Hiring</option>
                                    </select>
                                </div>
                            )}

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Expected CTC (Annual)</label>
                                <input
                                    type="number"
                                    name="expected_ctc"
                                    value={formData.expected_ctc}
                                    onChange={handleChange}
                                    placeholder="In rupees"
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">How did you hear about us?</label>
                                <input
                                    type="text"
                                    name="source"
                                    value={formData.source}
                                    onChange={handleChange}
                                    placeholder="LinkedIn, Referral..."
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Available to Join From</label>
                                <input
                                    type="date"
                                    name="DOJ"
                                    value={formData.DOJ}
                                    onChange={handleChange}
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div>
                                <label className="block font-semibold text-gray-700 mb-1">Do you have a Laptop?</label>
                                <select
                                    name="have_laptop"
                                    value={formData.have_laptop}
                                    onChange={handleChange}
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                >
                                    <option value="">Select</option>
                                    <option value="true">Yes</option>
                                    <option value="false">No</option>
                                    <option value="null">Can Arrange</option>
                                </select>
                            </div>

                            <div className="md:col-span-2">
                                <label className="block font-semibold text-gray-700 mb-1">Additional Information</label>
                                <textarea
                                    name="interview_call_remarks"
                                    value={formData.interview_call_remarks}
                                    onChange={handleChange}
                                    rows="4"
                                    placeholder="Anything else we should know..."
                                    className="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-500 outline-none"
                                />
                            </div>

                            <div className="md:col-span-2">
                                <button
                                    type="submit"
                                    disabled={loading}
                                    className="w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-600 text-white font-semibold text-lg shadow hover:opacity-90 transition"
                                >
                                    {loading ? "Submitting..." : "Submit Application"}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            {/* <div className="flex justify-center mt-6 px-4">
                <div className="max-w-xl w-full bg-white shadow-md rounded-xl p-5 text-center">
                    <p className="text-gray-600 mb-2 flex items-center justify-center gap-2">
                        <i className="fa fa-lightbulb text-yellow-400"></i>
                        Want to enhance your skills?
                    </p>

                    <a
                        href="https://www.skilllearningacademy.com/"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="px-5 py-2 rounded-lg bg-indigo-600 text-white font-medium hover:bg-indigo-700 transition"
                    >
                        <i className="fa fa-graduation-cap mr-1"></i>
                        Explore Skill Learning Academy
                    </a>
                </div>
            </div> */}

            <div className="text-center text-gray-600 py-6">
                <p className="text-sm">© 2024 Career Portal. All rights reserved.</p>
            </div>

        </div>
    );

};

export default CandidateFormPage;
