import React, { useContext } from 'react'
import DashboardIcon from '../Icons/DashboardIcon'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'

const NewSideBarButton = ({ data, index }) => {
    let { activePage, setActivePage, } = useContext(HrmStore)
    let navigate = useNavigate()
    return (
        <div>
            {data && data.show &&
                <button onClick={() => {
                    if (data.onClick) {
                        data.onClick()
                    } else if (data.href) {
                        window.open(data.href, '_blank')
                    } else {
                        navigate(`${data.path}`)
                    }
                    // setActivePage(data.active)
                }
                } className={` mx-auto w-full  flex my-4 ${index == 0 && 'mt-0'} text-slate-50 text-center text-xs flex-col `} >
                    
                    <span className={` ${activePage == data.active ? 'bg-slate-50 text-blue-600 ' : 'bg-blue-900'} 
                     p-[11px] rounded mx-auto mb-1 `} >

                        {data.FillIcon && activePage == data.active ?
                            <data.FillIcon size={data.size ? data.size : ''} />
                            : <data.Icon size={data.size ? data.size : ''} />}

                    </span>
                    <span className={`${activePage == data.active ? ' fw-semibold ' : ''} mt-2 poppins text-slate-50 text-center mx-auto `} >
                        {data.label ? data.label : "DashBoard"}
                    </span>
                </button>
            }
        </div>
    )
}

export default NewSideBarButton