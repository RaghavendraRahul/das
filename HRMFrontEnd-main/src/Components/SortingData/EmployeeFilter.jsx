import React, { useState } from 'react'
import SearchIcon from '../../SVG/SearchIcon'
import { Modal } from 'react-bootstrap'
import axios from 'axios'
import { port } from '../../App'
import FilterIcon from '../../SVG/FilterIcon'
import { toast } from 'react-toastify'

const EmployeeFilter = ({ filterOptions, setloading, empActiveStatus, setemp }) => {
    let [selectedFilter, setSelectedFilter] = useState('')
    let [combinationFilter, setCombinationFilter] = useState([...filterOptions])
    let [loading, setLoading] = useState()
    let searchFunction = (e) => {
        console.log(`${port}/root/ems/EmployeesFilters?${selectedFilter}=${e.target.value}`);
        let searchString
        if (selectedFilter == 'custom')
            searchString = combinationFilter.filter((obj) => obj.value != null && obj.value != '' && obj.value != undefined).map((obj) => `${obj.tag_id}=${obj.value}`).join('&')
        else
            searchString = `${selectedFilter}=${e.target.value}`
        setloading('allemp')
        axios.get(`${port}/root/ems/EmployeesFilters?${searchString}`).then((response) => {
            console.log(response.data, 'filterData');
            setemp(response.data)
            setloading(false)
            if (selectedFilter == 'custom')
                setSelectedFilter('')
        }).catch((error) => {
            console.log(error);
            toast.error('Error occured')
            setloading(false)
        })
    }
    let handleChange = (index, value) => {
        let arry = [...combinationFilter]
        arry[index] = { ...arry[index], value: value }
        setCombinationFilter(arry)
    }
    return (
        <>
            <div className='flex items-center gap-3 mx-3 ' >
                <button onClick={() => { setSelectedFilter('custom'); setCombinationFilter([...filterOptions]) }} className='bg-white rounded p-2 ' >
                    <FilterIcon />
                </button>
                {/* <select name="" id="" value={selectedFilter}
                    onChange={(e) => setSelectedFilter(e.target.value)}
                    className='p-1 rounded px-2 outline-none ' >
                    <option value="">Filter </option>
                    {
                        filterOptions &&
                        filterOptions.map((obj, index) => (
                            <>
                                {obj.rm_sort != true && <option value={obj.tag_id}> {obj.name} </option>}
                            </>
                        ))
                    }
                    <option value="custom">Custom filteration</option>

                </select> */}
                {/* {selectedFilter != '' && selectedFilter != 'custom' &&
                    selectedFilter != 'hired_date' &&
                    <div className={` flex gap-2 bg-white rounded  p-1   border-2  items-center `} >
                        <SearchIcon />
                        <input type="text" onChange={searchFunction}
                            placeholder={`Search By `} className={` bg-transparent outline-none `} />
                    </div>}
                {selectedFilter == 'hired_date' && <input type="date" onChange={searchFunction}
                    placeholder={`Search By `} className={` bg-white p-1 rounded outline-none `} />} */}


            </div >
            <Modal centered size='xl' className=' '
                show={selectedFilter == 'custom'} onHide={() => setSelectedFilter('')} >
                <Modal.Header className=' ' closeButton >
                    Filteration
                </Modal.Header>
                <Modal.Body>
                    <>
                        {/*<main className='row  ' >
                             {
                                filterOptions && filterOptions.map((obj, index) => (
                                    <div className='col-md-4 my-2 ' >
                                        <button className='flex items-center gap-2 ' >
                                            <input onChange={() => {
                                                if (combinationFilter.find((fil) => fil.tag_id == obj.tag_id))
                                                    setCombinationFilter((prev) => prev.filter((fil) => fil.tag_id != obj.tag_id))
                                                else
                                                    setCombinationFilter((prev) =>
                                                        [...prev, { tag_id: obj.tag_id, value: '', name: obj.name, type: obj.type }]
                                                    )
                                            }}
                                                checked={combinationFilter.find((fil) => fil.tag_id == obj.tag_id)}
                                                id={obj.tag_id} type="checkbox" className=' ' />
                                            <label htmlFor={obj.tag_id} className='cursor-pointer ' >
                                                {obj.name}
                                            </label>
                                        </button>


                                    </div>
                                ))
                            }
                        </main> */}
                        <main className='h-[70vh] table-responsive p-3 row ' >
                            {
                                combinationFilter && combinationFilter.map((obj, index) => (

                                    <article className='col-sm-6 col-lg-4 px-3 flex my-2 ' >

                                        <div className='w-1/2 break-words text-wrap ' >
                                            {obj.name}
                                        </div>

                                        <input type={obj.type ? obj.type : 'text'}
                                            onChange={(e) => handleChange(index, e.target.value)}
                                            value={obj.value}
                                            className='p-2 outline-none h-fit  inputbg rounded w-full  ' />

                                    </article>
                                ))
                            }
                            <div className='flex justify-end gap-3 items-center ' >
                                <button className=' inputbg p-2 rounded ' onClick={() => setSelectedFilter('')} >
                                    Cancel
                                </button>

                                <button onClick={searchFunction} className='bg-blue-600 text-white rounded p-2 px-3 ' >
                                    Search
                                </button>
                            </div>
                        </main>
                    </>

                </Modal.Body>
            </Modal>
        </>
    )
}

export default EmployeeFilter