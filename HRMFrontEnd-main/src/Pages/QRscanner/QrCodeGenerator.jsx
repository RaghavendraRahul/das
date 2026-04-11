import React, { useState } from 'react'
import { QRCode } from 'react-qrcode-logo';
import QrIcon from '../../Components/Icons/QrIcon';
import { Modal } from 'react-bootstrap';
const QrCodeGenerator = ({ css }) => {
    let [text, setText] = useState('')
    let empid = JSON.parse(sessionStorage.getItem('dasid'))
    let [showQr, setShowQr] = useState(false)
    return (
        <div>
            <button onClick={() => setShowQr(true)} className={`${css ? css : 'mx-2 bg-slate-700 text-slate-50 rounded '}  p-3`} >
                <QrIcon />
            </button>
            <Modal className=' ' centered show={showQr} onHide={() => setShowQr(false)} >
                <div className='mx-auto mt-4 ' >
                    <QRCode value={empid} size={150} />
                </div>
                <h5 className='mx-auto text-center my-3 poppins ' >Employee ID : {empid} </h5>
            </Modal>


        </div>
    )
}

export default QrCodeGenerator