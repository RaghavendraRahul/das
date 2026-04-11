import React from 'react'

const ThreeDots = ({ size }) => {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" width={size ? size : "16"} height={size ? size : "16"} fill="currentColor" class="bi bi-three-dots" viewBox="0 0 16 16">
            <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3" />
        </svg>
    )
}

export default ThreeDots