import React, { useState } from 'react'
import CheckIcon from '../Icons/CheckIcon'
import CopyIcon from '../Icons/CopyIcon'

const CopyToClipboard = ({ text }) => {
    let [coiped, setCopied] = useState(false)
    let copytheText = async () => {
        try {
            await navigator.clipboard.writeText(text);
            setCopied(true)
            setTimeout(()=>{
                setCopied(false)
            },2000)
        } catch (error) {
            console.log(error);

        }
    }
    return (
        <div>
            <div className='flex gap-2 p-2 items-center justify-between rounded bg-blue-50 border-2 border-blue-50 ' >
                {text}
                <button onClick={copytheText} className={` ${coiped?' text-green-500 ':''} p-[6px] rounded bg-slate-100 `} >
                    {coiped ? <CheckIcon /> : <CopyIcon />}
                </button>
            </div>
        </div>
    )
}

export default CopyToClipboard