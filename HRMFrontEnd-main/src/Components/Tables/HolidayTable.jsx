import React, { useContext } from 'react'
import { HrmStore } from '../../Context/HrmContext'

const HolidayTable = ({ data, css }) => {
    let { changeDateYear,selectValueToNormal } = useContext(HrmStore)
    return (
        <div>
            {data && data.length > 0 ? <main className={` tablebg  ${css ? css : "h-[30vh]"} rounded table-responsive`} >
                {console.log(data, 'modal')
                }
                <table className='w-full ' >
                    <tr className='sticky bg-white top-0 ' >
                        <th>SI No </th>
                        <th>Occasion Name</th>
                        <th> Leave Type </th>
                        <th> Date </th>
                        <th> Day </th>
                    </tr>

                    {
                        data && data.map((obj, index) => (
                            <tr>
                                {console.log(obj, 'leave check')
                                }
                                <td>{index + 1} </td>
                                <td> {obj.OccasionName} </td>
                                <td> {obj.leave_type && selectValueToNormal(obj.leave_type) } </td>
                                <td> {obj.Date && changeDateYear(obj.Date)} </td>
                                <td> {obj.Day} </td>
                            </tr>
                        ))
                    }
                </table>
            </main> :
                <main className={` ${css ? css : "h-[30vh]"} flex items-center justify-between `} >
                    <div className='w-fit mx-auto ' >

                        <img src={require('../../assets/Images/nodatafound.png')} alt="NotFoundData" className=' w-[10rem] my-2' />
                        <p className='mb-0 w-fit mx-auto text-center ' >No data Found </p>
                    </div>
                </main>
            }

        </div>
    )
}

export default HolidayTable