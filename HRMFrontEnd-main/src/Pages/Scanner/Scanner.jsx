import React, { useEffect, useState } from 'react'
import BarcodeScannered from './BarScanner';
import { Html5QrcodeScanner } from 'html5-qrcode';
import axios from 'axios';
import { port } from '../../App';
import { toast } from 'react-toastify';
import { Modal } from 'react-bootstrap';

const Scanner = () => {
    let [result, setresult] = useState()
    let [show, setShow] = useState(false)
    let scanValue = () => {
        const scanner = new Html5QrcodeScanner(
            "scannreader", {
            fps: 20, qrbox: {
                width: 250,
                height: 250
            }
        },
        );
        function onScanSuccess(result) {
            console.log(result);
            setTimeout(() => {
                setresult(result)
                scanner.clear()
            }, 3000);

        }
        function onScanFailure(error) {
            console.log(error);
            // scanner.clear()
        }
        scanner.render(onScanSuccess, onScanFailure);

    }
    useEffect(() => {
        scanValue()
    }, []);
    let findEmployee = async () => {
        if (result) {
            axios.get(`${port}/root/ems/EmployeeProfile/${result}/`).then((response) => {
                toast.success('Employee Found')
                console.log(response.data);
                setShow(true)
                setTimeout(() => {
                    setShow(false)
                    scanValue()
                }, 3000);
            }).catch((error) => {
                console.log(error);
                scanValue()


            })
        }
    }
    useEffect(() => {
        if (result) {
            findEmployee()
        }
    }, [result])
    return (
        <div className='container mx-auto'>
            <div id='scannreader' className=' w-[400px]  mx-auto '  >
            </div>
            {show && <Modal className=' ' centered show={show} onHide={() => setShow(false)}>
                Welcome to Office
            </Modal>}
        </div>
    );
}

export default Scanner