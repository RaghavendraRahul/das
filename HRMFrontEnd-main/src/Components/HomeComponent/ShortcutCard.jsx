import React from 'react'

const ShortcutCard = (props) => {
   let {img,count,label}=props
    return (
            <div className='border-2 bg-white min-h-[7.5rem] h-full cursor-pointer justify-around px-2
                         border-white rounded items-center d-flex shadow-sm   '>
                <img src={`${process.env.PUBLIC_URL}${img}`} alt="Circle 1" className='w-16' />
                <div className='ms-3 text-center poppins '>
                    <p className='text-2xl mb-1 fw-semibold '>{count} </p>
                    <p className='text-slate-500 fw-medium text-sm'> {label} </p>
                </div>
            </div>
    )
}

export default ShortcutCard