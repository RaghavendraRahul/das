import axios from 'axios'
import React, { useContext, useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import { Helmet } from 'react-helmet'
// OLD: import { usePDF } from 'react-to-pdf' - No longer needed, using html2canvas + jsPDF in DownloadButton
import DownloadButton from '../Employee/DownloadButton'
import HeaderLetterPad from '../LetterPad/HeaderLetterPad'
import LetterPadFooter from '../LetterPad/LetterPadFooter'
import { HrmStore } from '../../Context/HrmContext'

const InvoiceModal = ({ inid, show, setshow, }) => {
    let [invoiceDetails, setInvoiceDetails] = useState()
    let { changeDateYear } = useContext(HrmStore)
    // OLD: const { toPDF, targetRef } = usePDF({ Offer_Letter: 'page.pdf' });
    // NEW: Using simple useRef for the target element
    const targetRef = React.useRef();

    let getInvoiceDetails = () => {
        axios.get(`${port}/root/cms/client-requirement-invoice-generate?interview_id=${inid}`).then((response) => {
            console.log(response.data, 'invoice');
            setInvoiceDetails(response.data)
        }).catch((error) => {
            console.log(error, 'invoice');
        })
    }
    useEffect(() => {
        if (inid)
            getInvoiceDetails()
    }, [inid])
    return (
        <div>
            <Helmet >
                <meta name="viewport" content="width=1200" />
            </Helmet>
            <Modal centered fullscreen show={show} onHide={() => setshow(false)}>
                <Modal.Header closeButton >
                </Modal.Header>
                <Modal.Body>
                    <main ref={targetRef} className="w-[1200px] poppins text-gray-900 mx-auto ">
                        {/* Page 1 */}
                        <section className='rounded h-[1680px] text-slate-700 flex flex-col justify-between shadow-lg ' >
                            <HeaderLetterPad />
                            <article className='mb-auto p-5 py-3 ' >
                                <h5 className=' uppercase text-7xl fw-bold  ' >Invoice </h5>
                                <hr className='w-[140px] opacity-100 my-3 border-2 ' />
                                {/* issued date */}
                                <section className='flex justify-between my-3 ' >
                                    <div className=' '>
                                        <h6 className=' text-xl fw-semibold ' >ISSUED TO </h6>
                                        <p className='text-2xl fw-bold ' >{invoiceDetails && invoiceDetails.client_company_name} </p>
                                        <p>GST NO : {invoiceDetails && invoiceDetails.client_gst_number} </p>
                                    </div>
                                    <div className='text-end ' >
                                        <h6 className=' text-2xl fw-semibold text-end ' > INVOICE ID </h6>
                                        <p className='' > {invoiceDetails && invoiceDetails.invoice_number} </p>
                                        <h6 className=' text-2xl fw-semibold text-end ' > DATE ISSUED </h6>
                                        <p className='' > {invoiceDetails && invoiceDetails.date_issued && changeDateYear(invoiceDetails.date_issued.slice(0, 10))} </p>

                                    </div>
                                </section>
                                <hr className='border-2 opacity-100 ' />
                            </article>
                            <LetterPadFooter />
                        </section>
                    </main>
                    <div className='flex ms-auto w-fit ' >
                        {/* OLD: <DownloadButton toPDF={toPDF} name={'OfferLetter'} divref={targetRef} /> */}
                        <DownloadButton name={'Invoice'} divref={targetRef} />

                    </div>
                </Modal.Body>

            </Modal>

        </div>
    )
}

export default InvoiceModal