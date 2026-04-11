import React, { useContext, useRef } from 'react'
import { HrmStore } from '../../Context/HrmContext';
import { useNavigate } from 'react-router-dom';

const TopNavScrollBar = ({ navbar }) => {
    const scrollRef = useRef(null);
    let { topnav } = useContext(HrmStore)
    const scrollLeft = () => {
        if (scrollRef.current) {
            scrollRef.current.scrollBy({ left: -100, behavior: 'smooth' });
        }
    };

    const scrollRight = () => {
        if (scrollRef.current) {
            scrollRef.current.scrollBy({ left: 100, behavior: 'smooth' });
        }
    };
    let navigate = useNavigate()
    return (
        <div className="flex items-center w-[90%]   ">
            {navbar && navbar.length > 4 && <button
                className="bg-gray-300 text-slate-50 px-2 py-1 rounded"
                onClick={scrollLeft}
            >
                ◄
            </button>}
            <div
                className="topnavscroll flex overflow-x-auto items-center 
                 transition-all duration-800 mx-2 mt-1 space-x-2"
                ref={scrollRef}>
                {
                    navbar && navbar.filter((obj) => obj.show == true).map((obj, index) => (
                        <div onClick={() => navigate(obj.path)}
                            className={`relative my-0 py-0 ${obj.active == topnav && 'text-blue-600 fw-semibold '} 
                        text-sm poppins cursor-pointer text-nowrap px-2 duration-300 `} >
                            {obj.label}
                            <hr className={` w-1/2 ${obj.active == topnav ? 'border-4' : 'border-0'} 
                            duration-300 opacity-100 mx-auto my-2 rounded border-blue-600 mb-0 `} />
                        </div>
                    ))
                }

            </div>
            {navbar && navbar.length > 4 && <button
                className="bg-gray-300 text-slate-50 px-2 py-1 rounded"
                onClick={scrollRight}
            >
                ►
            </button>}
        </div>
    )
}

export default TopNavScrollBar