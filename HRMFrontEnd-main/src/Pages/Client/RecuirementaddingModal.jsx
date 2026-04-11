import React, { useEffect, useState } from 'react'
import { Modal } from 'react-bootstrap'
import InputFieldform from '../../Components/SettingComponent/InputFieldform'
import axios from 'axios'
import { port } from '../../App'
import { toast } from 'react-toastify'
import RecuirementCrud from '../../Components/ClientComponents/RecuirementCrud'

const RecuirementaddingModal = ({ cid, getData, show, setshow }) => {

    return (
        <div>
            <Modal className=' ' centered size='xl'
                show={show} onHide={() => { setshow(false) }}>
                <Modal.Header closeButton >
                    Recuirement adding
                </Modal.Header>
                <Modal.Body className='inputbg' >
                    <RecuirementCrud setshow={setshow} cid={cid} getData={getData} />
                </Modal.Body>
            </Modal>

        </div>
    )
}

export default RecuirementaddingModal