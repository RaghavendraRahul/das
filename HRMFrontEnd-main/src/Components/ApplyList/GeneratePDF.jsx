import React, { useState } from 'react';
import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';

const GeneratePDF = ({ divRef, filename = 'Payslip.pdf' }) => {
    const [loading, setLoading] = useState(false);

    const generatePdf = async () => {
        if (!divRef?.current) {
            console.error("divRef is not set properly.");
            setLoading(false);
            return;
        }

        setLoading(true);
        const divElement = divRef.current;

        // Temporarily force a fixed width to ensure html2canvas captures the full layout
        // regardless of the current window/viewport size.
        const originalStyle = divElement.getAttribute('style') || '';
        divElement.style.width = '1100px';
        divElement.style.minWidth = '1100px';
        divElement.style.maxWidth = 'none';

        try {
            const canvas = await html2canvas(divElement, {
                scale: 2,
                useCORS: true,
                logging: false,
                width: 1100, // Explicitly capture 1100px width
                windowWidth: 1100 // Ensure media queries don't shrink the content
            });

            // Restore original styles immediately after capture
            divElement.setAttribute('style', originalStyle);

            const imgData = canvas.toDataURL('image/png');

            // Standard A4 dimensions in jspdf are managed by 'mm' unit
            const pdf = new jsPDF('p', 'mm', 'a4');
            const pageWidth = pdf.internal.pageSize.getWidth();
            const pageHeight = pdf.internal.pageSize.getHeight();

            const imgProps = pdf.getImageProperties(imgData);
            const imgHeight = (imgProps.height * pageWidth) / imgProps.width;

            let heightLeft = imgHeight;
            let position = 0;

            // Add the first page
            pdf.addImage(imgData, 'PNG', 0, position, pageWidth, imgHeight);
            heightLeft -= pageHeight;

            // Add extra pages if the content is long
            while (heightLeft > 0) {
                position = heightLeft - imgHeight;
                pdf.addPage();
                pdf.addImage(imgData, 'PNG', 0, position, pageWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            pdf.save(filename);
        } catch (error) {
            console.error("Error generating PDF:", error);
            // Restore styles in case of error too
            if (divElement) divElement.setAttribute('style', originalStyle);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div>
            <button
                disabled={loading}
                onClick={generatePdf}
                className="bg-blue-600 text-white rounded p-2 px-3"
            >
                {loading ? "Loading..." : "Download PDF"}
            </button>
        </div>
    );
};

export default GeneratePDF;
