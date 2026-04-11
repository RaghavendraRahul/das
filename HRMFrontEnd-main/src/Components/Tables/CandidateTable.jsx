import React, { useEffect, useState } from 'react'
import LoadingData from '../MiniComponent/LoadingData'
import FinalResultCompleted from '../Modals/FinalResultCompleted'
import SchedulINterviewModalForm from '../ApplyList/SchedulINterviewModalForm'
import { useSearchParams, useNavigate } from 'react-router-dom'
import { Modal } from 'react-bootstrap'
import axios from 'axios'
import { port, domain } from '../../App'
import { toast } from 'react-toastify'

const CandidateTable = ({
    data,
    loading,
    css,
    rid,
    status,
    getData,
    pagination,
    onPageChange
}) => {

    const [filterLoading, setFilterLoading] = useState(false)
    const [filteredData, setFilterData] = useState([])
    const [interviewModal, setInterviewModal] = useState(null)
    const [finalResultObj, setFinalResultObj] = useState(null)
    const [selectedCandidate, setSelectedCandidate] = useState(null)
    const [searchParams, setSearchParams] = useSearchParams()
    const navigate = useNavigate()

    // BGV Upload States
    const [mailModal, setmailModal] = useState(false)
    const [canid, setCanId] = useState("")
    const [canemail, setEmail] = useState("")
    const [mailContent, setMailContent] = useState('')
    const [mailOject, setMailObj] = useState(null)
    const [loadingMailing, setLoadingMailing] = useState('')

    const user = JSON.parse(sessionStorage.getItem('user')) || {}
    const Empid = user.EmployeeId

    const [pageInput, setPageInput] = useState(pagination?.currentPage || parseInt(searchParams.get('page')) || 1)

    const sentid = (id, email) => {
        setCanId(id)
        setEmail(email)
    }

    useEffect(() => {
        if (mailOject) {
            setMailContent(`Dear ${mailOject.FirstName},
Congratulations!
We are pleased to inform you that you have been selected for the ${mailOject.AppliedDesignation} role at
Merida. As the next step in our hiring process, we require a background
verification to confirm your qualifications and ensure a smooth on-boarding experience.

Your prompt attention to this matter will help us expedite your on-boarding process. We look
forward to your successful background verification and to welcoming you aboard.

To complete the process click the following Link : ${domain}/Doc/${canid}/${Empid}

Thank you for your cooperation!
Best regards,
HR TEAM
MERIDA HR`)
        }
    }, [mailOject, canid, Empid])

    const handleSubmit = (e) => {
        e.preventDefault();
        const formdata = new FormData();
        formdata.append('CandidateID', canid);
        formdata.append('mail_sended_by', Empid);
        formdata.append('FormURL', `${domain}/Doc/${canid}/${Empid}`);
        formdata.append('mail_content', mailContent)
        setLoadingMailing('mail')
        axios.post(`${port}/root/DocumentsUploadForm`, formdata)
            .then((r) => {
                toast.success('BG Document Verification Form sent successfully...');
                setmailModal(false)
                setMailContent('')
                setLoadingMailing('')
            })
            .catch((err) => {
                console.log("DocumentsUploadForm_err", err);
                setLoadingMailing('')
                toast.error('Failed to send BGV form')
            });
    };

    const pageSize = 10

    useEffect(() => {
        setFilterData(data || [])
    }, [data])

    useEffect(() => {
        const urlPage = parseInt(searchParams.get('page'))
        if (urlPage && urlPage !== pagination?.currentPage) {
            onPageChange(urlPage)
        }
    }, [searchParams])

    useEffect(() => {
        if (pagination?.currentPage) {
            setPageInput(pagination.currentPage)
        }
    }, [pagination?.currentPage])

    const handlePageUpdate = (newPage) => {
        setSearchParams(prev => {
            const next = new URLSearchParams(prev)
            next.set('page', newPage)
            return next
        })
    }

    return (
        <div>
            <main
                className={`table-responsive tablebg h-[60vh] overflow-x-auto sm:h-[65vh] md:h-[70vh] lg:h-[70vh] xl:h-[70vh] ${css ? css : ''}`}
            >
                <table className="w-full table-fixed min-w-[1440px] ">
                    <thead>
                        <tr className="bg-gray-100 font-semibold text-slate-700 whitespace-nowrap">
                            <th className="px-2 py-3 w-[5%] text-left">SI No</th>
                            <th className="px-2 py-3 w-[12%] text-left">Candidate Name</th>
                            <th className="px-2 py-3 w-[9%] text-left">Candidate ID</th>
                            <th className="px-2 py-3 w-[16%] text-left">Email</th>
                            <th className="px-2 py-3 w-[9%] text-left">Contact</th>
                            <th className="px-2 py-3 w-[10%] text-left">Position</th>
                            <th className="px-2 py-3 w-[8%] text-left">Experience</th>
                            {(status === 'Internal_Hiring' || status === 'consider_to_client') &&
                                <th className="px-2 py-3 w-[10%] text-center">BGV Doc</th>}
                            {status !== 'ShartlistCanditates' && status !== 'Reject' && status !== 'All Applicants' &&
                                <th className="px-2 py-3 w-[10%] text-center">Offer Letter</th>}
                            <th className="px-2 py-3 w-[6%] text-center">Report</th>
                            {/* <th className="px-2 py-3 w-[7%] text-center">Interview</th> */}
                        </tr>
                    </thead>

                    <tbody>
                        {filteredData && !filterLoading && !loading && filteredData.map((obj, index) => (
                            <tr key={obj.CandidateId} className="border-b hover:bg-slate-100">
                                <td className="px-3 py-2">
                                    {index + 1 + ((pagination?.currentPage - 1) * pageSize || 0)}
                                </td>
                                <td className="px-2 py-2">{obj.FirstName}</td>
                                <td className="px-2 py-2">{obj.CandidateId}</td>
                                <td className="px-0 py-2 break-all">{obj.Email}</td>
                                <td className="px-3 py-2">{obj.PrimaryContact}</td>
                                <td className="px-2 py-2 border-r">{obj.AppliedDesignation}</td>
                                <td className="px-2 py-2 border-r">{obj.current_position}</td>
                                {(status === 'Internal_Hiring' || status === 'consider_to_client') &&
                                    <td className="px-2 py-2 text-center border-r whitespace-nowrap">
                                        <div className={obj.Final_Results === 'Internal Hiring' ? 'invisible' : 'visible'}>
                                            {obj.Experience ? (obj.Documents_Upload_Status === "Uploaded" ?
                                                (<button className='btn btn-success btn-sm w-full text-[10px]'
                                                    onClick={() => { navigate(`/dash/BackgroundVerification/${obj.CandidateId}`) }} >
                                                    BGV Uploaded
                                                </button>)
                                                :
                                                (<button className='btn btn-danger btn-sm w-full text-[10px]'
                                                    onClick={() => { sentid(obj.CandidateId, obj.Email); setmailModal(true); setMailObj(obj) }} >
                                                    Upload BGV
                                                </button>))
                                                : <span className='text-xs text-slate-500'>N/A</span>}
                                        </div>
                                    </td>
                                }
                                {status !== 'ShartlistCanditates' && status !== 'Reject' && status !== 'All Applicants' &&
                                    <td className="text-center px-3 py-2">
                                        {/* {((obj.Experience && obj.BG_Status === 'Verified') || obj.Fresher ||
                                            obj.verification_status === "Approved") ? */}
                                            <button
                                                className={`btn btn-info btn-sm ${obj.Final_Results === 'Reject' ? 'd-none' : 'd-block'}`}
                                                onClick={() => {
                                                    navigate(`/offerletter/${obj.CandidateId}`)
                                                }}
                                            >
                                                Offer Letter
                                            {/* </button> : <p className="mb-0 text-xs">BGV In Progress</p>} */}
                                            </button>
                                    </td>
                                }
                                <td className="px-3 py-2">
                                    <button
                                        onClick={() => setFinalResultObj(obj)}
                                        className="px-2 py-1 rounded bg-blue-600 text-white text-sm"
                                    >
                                        View
                                    </button>
                                </td>
                                {/* <td className="px-3 py-2">
                                    <button
                                        onClick={() => {
                                            setInterviewModal(obj)
                                            setSelectedCandidate(obj.CandidateId)
                                        }}
                                        className="px-1 py-1 rounded bg-blue-600 text-white text-xs"
                                    >
                                        Assign Interview
                                    </button>
                                </td> */}
                            </tr>
                        ))}
                    </tbody>
                </table>

                {(loading || filterLoading) && <LoadingData css="h-[30vh]" />}
            </main>

            {pagination && pagination.count > 0 && (
                <div className="d-flex justify-content-between align-items-center mt-1 bg-white p-2 rounded shadow-sm font-Poppins">

                    <div className="text-sm ">
                        Total : <strong>{pagination.count}</strong>
                    </div>

                    <div className="d-flex align-items-center gap-3">
                        <button className="btn btn-primary btn-sm rounded px-2" disabled={!pagination.previous} onClick={() => handlePageUpdate(pagination.currentPage - 1)}>
                            Previous
                        </button>

                        <div className="small px-3 bg-primary text-white rounded py-1 ">
                            {pagination.currentPage} of {Math.ceil(pagination.count / pageSize)}
                        </div>

                        <button className="btn btn-primary btn-sm" disabled={!pagination.next} onClick={() => handlePageUpdate(pagination.currentPage + 1)}>
                            Next
                        </button>
                    </div>

                    <div className="d-flex align-items-center gap-2 ">
                        <span className="text-sm">Page</span>
                        <input type="number" className="form-control form-control-sm " style={{ width: "50px" }} min={1} max={Math.ceil(pagination.count / pageSize)} value={pageInput}
                            onChange={(e) => setPageInput(e.target.value)}
                            onKeyDown={(e) => {
                                if (e.key === "Enter") {
                                    const page = Number(pageInput)
                                    const totalPages = Math.ceil(pagination.count / pageSize)

                                    if (page >= 1 && page <= totalPages) {
                                        handlePageUpdate(page)
                                    }
                                }
                            }}
                        />
                    </div>
                </div>
            )}

            <FinalResultCompleted show={finalResultObj} setshow={setFinalResultObj} />

            <SchedulINterviewModalForm
                fetchdata={getData}
                rid={rid}
                candidateId={selectedCandidate}
                show={interviewModal}
                setshow={setInterviewModal}
            />

            {mailModal &&
                <Modal show={mailModal} onHide={() => setmailModal(false)}>
                    <Modal.Header closeButton>
                        <h4 className="modal-title text-center">BG Document Verification Form</h4>
                    </Modal.Header>
                    <Modal.Body>
                        <form onSubmit={handleSubmit}>
                            <div className="row m-0 border-bottom pb-2 mt-5">
                                <div className="col-md-12 col-lg-12 mb-3">
                                    <label htmlFor="candidateID" className="form-label">Candidate ID</label>
                                    <input type="text" className="form-control shadow-none bg-light" value={canid} readOnly />
                                </div>
                                <div className="col-md-12 col-lg-12 mb-3">
                                    <label htmlFor="lastName" className="form-label">Email</label>
                                    <input type="text" className="form-control shadow-none bg-light" value={canemail} readOnly />
                                </div>
                                <div>
                                    Mail Content
                                    <textarea value={mailContent} onChange={(e) => setMailContent(e.target.value)}
                                        rows={5} className="form-control shadow-none bg-light"></textarea>
                                </div>
                            </div>
                            <div className="col-12 text-end mt-3">
                                <button type="submit" disabled={loadingMailing === 'mail'}
                                    className="btn btn-primary btn-sm text-white fw-medium px-2 px-lg-5">
                                    {loadingMailing === 'mail' ? "Loading" : "Send Mail"}</button>
                            </div>
                        </form>
                    </Modal.Body>
                </Modal>
            }
        </div>
    )
}

export default CandidateTable