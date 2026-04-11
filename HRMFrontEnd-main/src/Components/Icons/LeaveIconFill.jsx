import React from 'react';

const LeaveIconFill = ({ size }) => {
    return (
        <svg width={size ? size : 22} height={size ? size : 22} viewBox="0 0 300 360" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 105V285C0 326.355 33.645 360 75 360H225C266.355 360 300 326.355 300 285V105H0ZM150 270H90C81.72 270 75 263.295 75 255C75 246.705 81.72 240 90 240H150C158.28 240 165 246.705 165 255C165 263.295 158.28 270 150 270ZM210 195H90C81.72 195 75 188.295 75 180C75 171.705 81.72 165 90 165H210C218.28 165 225 171.705 225 180C225 188.295 218.28 195 210 195ZM300 75H0C0 33.645 33.645 0 75 0H225C266.355 0 300 33.645 300 75Z"
                fill="currentColor" />
        </svg>

    );
};

export default LeaveIconFill;
