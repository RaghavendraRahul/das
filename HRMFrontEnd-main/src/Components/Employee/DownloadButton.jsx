// OLD CODE - (Issue: fetch fails, no download triggered, results in black PDFs)
// import { saveAs } from 'file-saver';
// import React from 'react'
// import { usePDF } from 'react-to-pdf';
// 
// const DownloadButton = ({ toPDF ,name}) => {
//     const downloadPDF = async () => {
//         toPDF();
//         // alert('Offer Letter sent successfully')
//         await new Promise(resolve => setTimeout(resolve, 2000));
//         const pdfBlob = await fetch('page.pdf').then((res) => res.blob());
//       
//     }
//     return (
//         <div className='my-4' >
//             <button className='bg-blue-600 text-white rounded p-2  ' onClick={downloadPDF}>
//                 Download
//             </button>
//         </div>
//     )
// }

// NEW CODE
import React, { useState } from 'react';
import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';

const DownloadButton = ({ divref, name }) => {
    const [isDownloading, setIsDownloading] = useState(false);

    const downloadPDF = async () => {
        const element = divref?.current;
        if (!element) {
            console.error('Reference to the element is not available');
            return;
        }

        setIsDownloading(true);

        try {
            // Scroll to top to ensure complete capture (common html2canvas fix)
            window.scrollTo(0, 0);

            // Wait a brief moment for any lazy loading or scroll events to settle
            await new Promise(resolve => setTimeout(resolve, 500));

            // Capture the element directly
            const canvas = await html2canvas(element, {
                scale: 1.5, // Reduced scale to render smaller image
                useCORS: true,
                logging: false,
                backgroundColor: '#ffffff',
                scrollY: 0, // Force capture from top
                scrollX: 0,
            });

            // Convert to JPEG with 0.7 quality (drastically reduces size vs PNG)
            const imgData = canvas.toDataURL('image/jpeg', 0.7);

            // Create PDF
            const pdf = new jsPDF('p', 'px', [canvas.width, canvas.height]);

            // Add image as JPEG (FAST is an alias for JPEG in some versions, but explicit format is safer)
            pdf.addImage(imgData, 'JPEG', 0, 0, canvas.width, canvas.height);

            // Save the PDF with the provided name or default to 'OfferLetter'
            pdf.save(`${name || 'OfferLetter'}.pdf`);

            console.log('PDF downloaded successfully');
        } catch (error) {
            console.error('Error generating PDF:', error);
            alert('Failed to download PDF. Please try again.');
        } finally {
            setIsDownloading(false);
        }
    };

    return (
        <div className='my-4'>
            <button
                className='bg-blue-600 text-white rounded p-2'
                onClick={downloadPDF}
                disabled={isDownloading}
            >
                {isDownloading ? 'Generating PDF...' : 'Download'}
            </button>
        </div>
    );
}

export default DownloadButton;