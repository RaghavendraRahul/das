import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { port } from '../../App'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import { toast } from 'react-toastify'

const AssestModel = ({ show, setshow }) => {
    console.log(show);
    let [loading, setLoading] = useState(false)
    let [clearenObj, setClearenceObj] = useState({
        separation_information: show.id,
        desktop_laptop_status: '',
        accessories_tools_status: '',
        mobile_sim_uniform_status: '',
        name_plate_id_card_status: '',
        stationeries_status: ''
    })
    let handleClearanceObj = (e) => {
        let { name, value } = e.target
        setClearenceObj((prev) => ({
            ...prev,
            [name]: value
        }))
    }
    let getAssesTclreance = () => {
        console.log(show);

        axios.get(`${port}/root/ems/Clearence?exit_id=${show.id}`).then((response) => {
            console.log(response.data, 'clearence');
            setClearenceObj(response.data)
        }).catch((error) => {
            console.log(error);
        })
    }
    let saveClearence = () => {
        setLoading(true)
        axios.post(`${port}/root/ems/Clearence`, { ...clearenObj, separation_information: show.id }).then((response) => {
            console.log(response.data);
            setClearenceObj(response.data)
            setLoading(false)
            toast.success('Clearence data has been added')
        }).catch((error) => {
            console.log(error);
            setLoading(false)
            toast.error('Error occured')
        })
    }
    let updateClearence = () => {
        setLoading(true)
        axios.patch(`${port}/root/ems/Clearence`, clearenObj).then((response) => {
            console.log(response.data);
            setClearenceObj(response.data)
            setLoading(false)
            toast.success('Clearence data has been updated')
        }).catch((error) => {
            console.log(error);
            setLoading(false)
            toast.error('Error occured')
        })
    }
    let clearenceOptions = [
        {
            label: 'Cleared',
            value: 'Cleared'
        },
        {
            label: 'Pending',
            value: 'Pending'
        },
        {
            label: 'Damaged',
            value: 'Damaged'
        },
        {
            label: 'Lost',
            value: 'Lost'
        }
    ]
    useEffect(() => {
        if (show.id)
            getAssesTclreance()
    }, [show.id])
    return (
        <div>
            <Modal show={show} onHide={() => setshow(false)}
                centered className=' ' size='xl'  >
                <Modal.Header closeButton >
                    Assest  Clearance
                </Modal.Header>
                <Modal.Body>
                    <main className='row formbg p-3 rounded' >

                        <InputFieldform label="Office Property like desktop/Laptop " value={clearenObj.desktop_laptop_status} name='desktop_laptop_status'
                            handleChange={handleClearanceObj} optionObj={clearenceOptions} />
                        <InputFieldform label="Accessories, tools, instruments, file, documents,product. " value={clearenObj.accessories_tools_status} name='accessories_tools_status'
                            handleChange={handleClearanceObj} optionObj={clearenceOptions} />
                        <InputFieldform label="Mobile, SIM card, Uniform (no.),  Name Plate  " value={clearenObj.mobile_sim_uniform_status} name='mobile_sim_uniform_status'
                            handleChange={handleClearanceObj} optionObj={clearenceOptions} />
                        <InputFieldform label="Name Plate & ID Card   " value={clearenObj.name_plate_id_card_status} name='name_plate_id_card_status'
                            handleChange={handleClearanceObj} optionObj={clearenceOptions} />
                        <InputFieldform label="Stationeries (Stapler, staple pin, notepad, punch machine, scissors, board pin or any other)  "
                            value={clearenObj.stationeries_status} name='stationeries_status'
                            handleChange={handleClearanceObj} optionObj={clearenceOptions} />
                        <div>

                            {!clearenObj.id &&
                                <button onClick={saveClearence}
                                    className='p-2 px-3 flex ms-auto bg-green-500 text-white rounded w-fit ' >
                                    {loading ? 'Loading' : "Save"}
                                </button>}
                            {clearenObj.id &&
                                <button onClick={updateClearence}
                                    className='p-2 px-3 flex ms-auto bg-green-500 text-white rounded w-fit ' >
                                    {loading ? 'Loading' : "Update"}
                                </button>}
                        </div>
                    </main>




                </Modal.Body>
            </Modal>
        </div>
    )
}

export default AssestModel