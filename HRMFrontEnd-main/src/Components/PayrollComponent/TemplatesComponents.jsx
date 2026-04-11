import React, { useEffect, useState } from 'react'
import DownArrow from '../../SVG/DownArrow'
import PlusIcon from '../../SVG/PlusIcon'

const TemplatesComponents = ({ data, selectedComponent, setSelectedComponent, setData }) => {
    let [openDrop, setOpenDrop] = useState()
    let handleconversition = (obj, objName) => {
        // let objArry = data[objName].filter((obj2, index) => obj2.id != obj.id)
        // setData((prev) => ({
        //     ...prev,
        //     [objName]: objArry
        // }))
        setSelectedComponent((prev) => [
            ...prev,
            obj
        ])
    }
    

    return (
        <section className='col-md-3 pb-3 ' >
            <main className='w-full h-full p-3 rounded bg-white' >
                <p className='fw-semibold mb-1 ' >Build your template </p>
                <p className='text-sm  '> Include active salary components </p>
                {/* Earning */}
                <section className='inputbg rounded p-2 text-sm '>
                    <button onClick={() => {
                        if (openDrop != 'earning')
                            setOpenDrop('earning')
                        else
                            setOpenDrop('')
                    }} className='flex p-1 justify-between w-full items-center ' >
                        Earnings
                        <span className={`${openDrop == 'earning' ? '' : " -rotate-90 "} duration-500 `} >
                            <DownArrow />
                        </span>
                    </button>
                    {openDrop == 'earning' && data && data.earnings.length > 0 &&
                        <article className='  border-t-2  border-slate-100 ' >
                            {
                                data.earnings.map((obj, index) => (
                                    <button onClick={() => handleconversition(obj, 'earnings')} className={`p-2 hover:bg-blue-100 hover:text-blue-600 my-1 items-center
                                        rounded w-full flex justify-between `}>
                                        {obj.name_in_payslip}
                                        <PlusIcon />
                                    </button>
                                ))
                            }
                        </article>}
                </section>
                {/* Pre tax */}
                <section className='inputbg my-2 rounded p-2 text-sm ' >
                    <button onClick={() => {
                        if (openDrop != 'pre')
                            setOpenDrop('pre')
                        else
                            setOpenDrop('')
                    }} className='flex p-1 justify-between w-full items-center ' >
                        Pre-Tax Deduction
                        <span className={`${openDrop == 'pre' ? '' : " -rotate-90 "} duration-500 `} >
                            <DownArrow />
                        </span>
                    </button>
                    {openDrop == 'pre' && data && data.pre_tax_deduction.length > 0 &&
                        <article className='  border-t-2  border-slate-100 '  >
                            {
                                data.pre_tax_deduction.map((obj, index) => (
                                    <button onClick={() => handleconversition(obj, 'pre_tax_deduction')} className={`p-2 hover:bg-blue-100 hover:text-blue-600 my-1 items-center
                                        rounded w-full flex justify-between `}>
                                        {obj.name_in_payslip}
                                        <PlusIcon />
                                    </button>
                                ))
                            }
                        </article>
                    }
                </section>

                {/* Post Tax */}
                <section className='inputbg my-2 rounded p-2 text-sm ' >
                    <button onClick={() => {
                        if (openDrop != 'post')
                            setOpenDrop('post')
                        else
                            setOpenDrop('')
                    }} className='flex p-1 justify-between w-full items-center ' >
                        Post-Tax Deduction
                        <span className={`${openDrop == 'post' ? '' : " -rotate-90 "} duration-500 `} >
                            <DownArrow />
                        </span>
                    </button>
                    {openDrop == 'post' && data && data.post_tax_deduction.length > 0 &&
                        <article className=' border-t-2  border-slate-100 '  >
                            {
                                data.post_tax_deduction.map((obj, index) => (
                                    <button onClick={() => handleconversition(obj, 'post_tax_deduction')} className={`p-2 hover:bg-blue-100 hover:text-blue-600 my-1 items-center
                                        rounded w-full flex justify-between `}>
                                        {obj.name_in_payslip}
                                        <PlusIcon />
                                    </button>
                                ))
                            }
                        </article>
                    }
                </section>
            </main>

        </section>
    )
}

export default TemplatesComponents