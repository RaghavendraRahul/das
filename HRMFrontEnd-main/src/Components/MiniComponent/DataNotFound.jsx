import React from 'react'

const DataNotFound = ({ css }) => {
    return (
        <main className={` ${css ? css : "h-[30vh]"} flex items-center justify-between `} >
            <div className='w-fit mx-auto ' >
                <img src={require('../../assets/Images/nodatafound.png')} alt="NotFoundData" className=' w-[10rem] my-2' />
                <p className='mb-0 w-fit mx-auto text-center ' >No data Found </p>
            </div>
        </main>
    )
}

export default DataNotFound