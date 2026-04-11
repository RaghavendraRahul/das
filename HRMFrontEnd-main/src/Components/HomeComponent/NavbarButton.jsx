import React, { useContext, useEffect, useState } from 'react'
import { HrmStore } from '../../Context/HrmContext'
import { useNavigate } from 'react-router-dom'
import { Dropdown, OverlayTrigger, Tooltip } from 'react-bootstrap'
import DownArrow from '../../SVG/DownArrow'

const NavbarButton = (props) => {
    const { openNavbar, setopen, path, drop, href, onClick, label, light, active, img } = props
    let { activePage, setActivePage } = useContext(HrmStore)
    let navigate = useNavigate()
    let [dropDown, setDropDown] = useState(false)

    const renderTooltip = (text) => (
        <Tooltip id="button-tooltip">{text}</Tooltip>
    );

    let handleclick = () => {
        setActivePage(active)
        if (onClick) {
            onClick()
        } else if (href) {
            window.open(href)
        } else if (!drop) {
            navigate(path)
        }
        if (drop) {
            setopen(true)
            setDropDown(!dropDown)
        }
    }
    useEffect(() => {
        if (!openNavbar) {
            setDropDown(false)
        }
    }, [openNavbar])
    return (
        <div>
            <div className={`relative  w-[80px]
            flex my-1 transition duration-500  
                 ${activePage == active && 'border-violet-900 border-s-4'} `}>
                {light && <p className='w-[7px] h-[7px] rounded-full bg-red-500 absolute -top-1 right-5 '> </p>}
                <OverlayTrigger className={` ${openNavbar && 'd-none'} `}
                    placement="right" delay={{ show: 150, hide: 200 }}
                    overlay={renderTooltip(label)}>
                    <button onClick={handleclick}
                        className={`hover:scale-[1.05] h-fit duration-300 hover:shadow w-fit mx-auto rounded p-2 
                        ${activePage == active && 'shadow'} 
                        ${dropDown && 'absolute left-4  '} `}  >
                        <img className={`w-6 h-6 `} src={`${process.env.PUBLIC_URL}${img}`} alt="DashBoard" />
                        {/* <span className='text-slate-100 ' >
                            {label}
                        </span> */}

                    </button>
                </OverlayTrigger>
                <button onClick={handleclick}
                    className={`text-base duration-700  z-0 fw-semibold text-violet-900 flex items-center justify-start text-start min-w-[100px] absolute left-28 
                        ${openNavbar ? 'translate-x-0 ' : 'translate-x-[-280px]'} 
                        ${dropDown ? " " : "top-[50%] -translate-y-1/2"} 
                     ${drop && "justify-between"}`} > {label}

                    {drop && <span onClick={() => setDropDown(!dropDown)}>
                        <DownArrow size={20} />
                    </span>} </button>


                {/* Drop Down */}
                {
                    dropDown &&
                    <section className='downtoupani transition duration-500  min-h-[50px] min-w-[100px] relative left-28 -bottom-10  '>
                        {drop.map((obj) => (
                            <button className={`text-start w-40 me-auto relative
                             hover:scale-[1.05]  hover:drop-shadow-sm duration-300 text-sm fw-medium my-1
                              ${obj.light ? "text-red-600 " : 'text-slate-500 '} `}
                                onClick={() => { navigate(obj.path); setDropDown(false); setopen(false) }} >
                                {obj.name}
                            </button>
                        ))}
                    </section>
                }
            </div>
        </div>
    )
}

export default NavbarButton