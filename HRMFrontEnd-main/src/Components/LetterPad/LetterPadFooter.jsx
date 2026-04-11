import React from 'react'
import MessageIcon from '../Icons/MessageIcon'
import LocationIcon from '../Icons/LocationIcon'

const LetterPadFooter = () => {
    return (
        <div>
            <main className='flex justify-between fw-semibold px-4 my-3 poppins' >
                <div className='' >
                    GST : 29AAPCM6487M1ZB
                </div>
                <div className='' >
                    CIN : U72900KA2022OP159922
                </div>

            </main>
            <main style={{ backgroundColor: '#2E2F4B' }}
                className='flex justify-around p-[10px] py-[15px]  ' >
                <div className='text-slate-50 lowercase flex gap-2  p-0 ' style={{ alignItems: 'center' }} >
                    <MessageIcon />
                    <p>

                        INFO@MERIDATECHMINDS.COM
                    </p>
                </div>
                <div className='text-slate-50  lowercase flex gap-2  p-0 ' style={{ alignItems: 'center' }} >
                    <LocationIcon />
                    <p>

                        20-2, Keshava Krupa, 1st Fl, 30th Cross, 10th Main, 4th Block, Jayanagar, Bengaluru 560011
                    </p>
                </div>
            </main>
            <main className='flex justify-end px-4 ' >
                <div className='bg-orange-500 h-[25px] mx-1 w-[30px] ' >

                </div>
                <div className='bg-yellow-500 h-[25px] mx-1 w-[30px] ' >

                </div>
                <div className='bg-green-500 h-[25px] mx-1 w-[30px] ' >

                </div>

            </main>

        </div>
    )
}

export default LetterPadFooter