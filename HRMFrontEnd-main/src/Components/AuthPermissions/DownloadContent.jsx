import React, { useEffect } from 'react'
import * as XLSX from 'xlsx';

const DownloadContent = ({ data, name, type, trigger, settrigger }) => {
    const exportToExcel = () => {
        console.log(data);
        let exportData = data
        console.log(exportData);
        // Create a new workbook
        const workbook = XLSX.utils.book_new();
        let worksheet
        if (type == undefined || type != 'notes') {
            worksheet = XLSX.utils.json_to_sheet(exportData);
        }
        if (type == 'notes') {
            worksheet = XLSX.utils.json_to_sheet(data);
        }
        // Append the worksheet to the workbook
        XLSX.utils.book_append_sheet(workbook, worksheet, name);
        // Generate a buffer and download the file
        XLSX.writeFile(workbook, `${name}.xlsx`);
    };
    useEffect(() => {
        if (trigger) {
            exportToExcel()
            settrigger(false)
        }
    }, [])
    return (
        <div>

        </div>
    )
}

export default DownloadContent