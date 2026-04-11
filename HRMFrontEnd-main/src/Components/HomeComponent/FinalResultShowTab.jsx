import React from 'react'

const FinalResultShowTab = ({ label, value, link, cmnt }) => {
    return (
        <div className={`my-2 text-sm flex gap-2 justify-between ${cmnt ? 'col-12' : 'col-sm-6'}`}>
            <label htmlFor="" className={` text-sm poppins w-[11rem] break-words  fw-medium text-slate-600 `}>{label}</label>
            {value != undefined && <input type="text" disabled value={value}
                className='inputbg outline-none w-full block rounded p-2  ' />}

            {link != undefined &&
                <a className='inputbg outline-none w-full block rounded p-2 text-center text-decoration-none' download
                    href={link}> <p className='mb-0 text-center w-full'>Download</p>
                </a>}

            {cmnt && <textarea name="" id="" rows={5} value={cmnt}
                    className='inputbg outline-none w-full block rounded p-2 text-decoration-none m-0' > </textarea>}
        </div>
    )
}

export default FinalResultShowTab