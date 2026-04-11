import React from 'react';
import { Modal } from 'react-bootstrap';
import QRCode from 'react-qr-code';

const QRCodeModal = ({ show, onHide, empid }) => {
    const qrUrl = `${window.location.origin}/activity/candidate-form?ref=${empid}`;

    const handleDownload = () => {
        const svg = document.getElementById('qr-code-svg');
        const svgData = new XMLSerializer().serializeToString(svg);
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const img = new Image();

        img.onload = () => {
            canvas.width = img.width;
            canvas.height = img.height;
            ctx.drawImage(img, 0, 0);
            const pngFile = canvas.toDataURL('image/png');

            const downloadLink = document.createElement('a');
            downloadLink.download = `candidate-form-qr-${empid}.png`;
            downloadLink.href = pngFile;
            downloadLink.click();
        };

        img.src = 'data:image/svg+xml;base64,' + btoa(svgData);
    };

    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>Candidate Form QR Code</Modal.Title>
            </Modal.Header>
            <Modal.Body className="text-center p-4">
                <div className="mb-3 flex justify-center items-center">
                    <QRCode
                        id="qr-code-svg"
                        value={qrUrl}
                        size={256}
                        level="H"
                    />
                </div>
                <p className="text-muted small mb-2">Scan this QR code to access the candidate form</p>
                <p className="text-break small"><strong>URL:</strong> {qrUrl}</p>
            </Modal.Body>
            <Modal.Footer>
                <button className="btn btn-secondary" onClick={onHide}>
                    Close
                </button>
                <button className="btn btn-primary" onClick={handleDownload}>
                    Download QR
                </button>
            </Modal.Footer>
        </Modal>
    );
};

export default QRCodeModal;
