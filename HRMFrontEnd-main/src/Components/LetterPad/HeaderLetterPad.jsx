import React from 'react'

const HeaderLetterPad = () => {
    return (
        <div className='w-full flex justify-between items-center pe-5 '>
            <img src={require('../../assets/Images/letterpadleftpattern.png')} alt='Letterpad left'
                className='' ></img>
                <img src={require('../../assets/Images/meridatechmindsbluelogo.png')}
                 className='h-fit ' width={200} alt="Merida_logo" />

        </div>
    )
}

export default HeaderLetterPad