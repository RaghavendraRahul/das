import React from 'react'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'
import InfoButton from '../SettingComponent/InfoButton';

const LeaveBalanceCard = ({ obj, index }) => {  
    return (
        <div className='w-full ' >

            <section className=' flex shadow-sm gap-2 poppins rounded justify-evenly items-center p-2 h-[10rem] w-full bgclr '>
                {console.log(obj, "leave")
                }
                <img src={require('../../assets/Images/leaveImage.png')} alt="LeaveImage"
                    className='w-[7rem] object-cover h-fit rounded ' />
                <div className=' w-[10rem] text-sm' >
                    <p className='break-words text-md mb-0'>{obj.LeaveType}</p>
                    {/* <p className='text-xs mb-0 fw-semibold ' >Granted : {obj.no_of_leaves}</p> */}

                    <p className='flex justify-between mb-0 my-2 text-slate-500'> Available <span className='text-green-600 ' >
                        {obj.Available_leaves ? obj.Available_leaves : 0} </span></p>
                    <p className=' flex justify-between my-1 break-words text-slate-500 text-sm m-0'>Booked <span>
                        {obj.utilised_leaves}  </span>  </p>
                    <span className='w-fit ms-auto flex ' >

                        <InfoButton content={obj.leave_discription} />
                    </span>
                    {/* <p className='mb-0 text-xs fw-semibold '  > {obj.utilised_leaves} of {obj.no_of_leaves} Consumed </p> */}
                </div>
            </section>
        </div>
    )
}

export default LeaveBalanceCard