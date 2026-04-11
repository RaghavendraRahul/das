import React from 'react'
import { useNavigate } from 'react-router-dom'
import DownArrow from '../../SVG/DownArrow'

const BackButton = ({ css }) => {
    let navigate = useNavigate()
    
    return (
        <div>
            <button onClick={() => navigate(-1)} className={` ${css ? css : 'bg-slate-950 text-slate-50 '} rotate-90 p-2 rounded `} >
                <DownArrow />
            </button>

        </div>
    )
}

export default BackButton