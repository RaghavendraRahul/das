import React, { useContext } from 'react'
import { useNavigate } from 'react-router-dom';
import { HrmStore } from '../../Context/HrmContext';

const ScrollButton = ({ path, name, css, active ,activeSetting, setActiveSetting}) => {
    let navigate = useNavigate()

    return (
        <div>
            <button onClick={() => { setActiveSetting(active); navigate(`${path}`) }} 
            className={`p-[10px] rounded-full w-44 transition duration-500
        ${activeSetting == active ? 'btngrd border-slate-500 fw-medium text-white'
                    : 'bgclr border-slate-50'} `} >
                {name}
            </button>

        </div>
    )
}

export default ScrollButton