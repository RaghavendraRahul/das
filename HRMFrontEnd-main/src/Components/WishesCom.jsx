import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { domain, port } from '../App'

const WishesCom = () => {
    let [show, setshow] = useState(false)
   
    let getWishes = () => {
        if (JSON.parse(sessionStorage.getItem('dasid'))) {
            axios.get(`${port}/root/GetEmployeeCelebrations/?EmployeeId=${JSON.parse(sessionStorage.getItem('dasid'))}`).then((response) => {
                setshow(response.data)
                console.log(response.data, "helw",
                    `${port}/root/GetEmployeeCelebrations/?EmployeeId=${JSON.parse(sessionStorage.getItem('dasid'))}`);
            }).catch((error) => {
                console.log(error, 'helw',
                    `${port}/root/GetEmployeeCelebrations/?EmployeeId=${JSON.parse(sessionStorage.getItem('dasid'))}`);
            })
        }
    }

    useEffect(() => {
        getWishes()
    }, [])
    return (
        <div>

            {show && show.filter((obj) => {
                const createdDate = new Date(obj.created_on).toISOString().split('T')[0];
                const todayDate = new Date().toISOString().split('T')[0];
                return createdDate === todayDate;
            }).map((obj, index) => (
                <Modal centered show={obj.id} onHide={() =>
                    setshow((prev) => prev.filter((e) => e.id != obj.id))} >
                    <Modal.Header closeButton >
                        {/* Wishes Happy Birthday */}
                    </Modal.Header>
                    <Modal.Body>
                        <img className='w-40 mx-auto flex '
                            src={require('../assets/Images/birthday-bday.gif')} alt="BirthDay wishes" />
                        {
                            obj.message
                        }
                    </Modal.Body>
                </Modal>
            ))}

        </div>
    )
}

export default WishesCom