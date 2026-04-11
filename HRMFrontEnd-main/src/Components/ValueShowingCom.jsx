import React from 'react'

const ValueShowingCom = ({ name, value, proof, hcss, css }) => {
    return (
        <div className={`${css} flex items-start my-1 `} >
            <h6 className={`  fw-normal ${hcss ? hcss : "w-[40%]"} text-slate-400 `} > {name ? name : "Account Holder Name :"}  </h6>
            {proof ? <a href={proof} target='_blank' className='pb-1 flex-grow-1 mb-2 border-b-[1px] text-decoration-none ' download >
                Click here
            </a> : <p className='flex-grow-1 pb-1 mb-2 border-b-[1px] ' >
                {value == false ? ' No' : value == true ? ' Yes' :
                    value != null ? ` ${value}` : " --"}
            </p>}
        </div>
    )
}

export default ValueShowingCom