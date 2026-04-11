import React from 'react'

const AutoTable = ({ data }) => {
    let keys = Object.keys(data[0])
    return (
        <div>
           {data&& <main className='table-responsive tablebg  ' >
                <table className='w-full p-0' >
                    <tr className='sticky top-0 bgclr1 ' >
                        {
                            keys.map((val)=>(
                                <th>
                                    {val}
                                </th>
                            ))
                        }
                    </tr>

                </table>

            </main>}
        </div>
    )
}

export default AutoTable