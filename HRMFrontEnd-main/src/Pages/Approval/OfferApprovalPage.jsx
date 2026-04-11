import React, { useContext, useEffect, useState } from 'react'
import Topnav from '../../Components/Topnav'
import axios from 'axios'
import { port } from '../../App'
import { useNavigate } from 'react-router-dom'
import { HrmStore } from '../../Context/HrmContext'

const OfferApprovalPage = ({ subpage }) => {
  let { setActivePage, setTopNav } = useContext(HrmStore)
  let [approvalPending, setApprovalPending] = useState()
  let { convertToReadableDateTime } = useContext(HrmStore)
  let navigate = useNavigate()
  let user = JSON.parse(sessionStorage.getItem('user'))
  let getApprovalRequest = () => {
    axios.get(`${port}/root/OfferLetterApprovalList/${user.EmployeeId}/`).then((response) => {
      console.log("hellow", response.data);
      setApprovalPending(response.data);
    }).catch((error) => {
      console.log("hellow", error);
    })
  }
  useEffect(() => {
    getApprovalRequest()
    setActivePage('Employee')
    setTopNav('offer')
  }, [])
  return (
    <div className=''>
      {!subpage && <Topnav name='Offer letter approval' />}
      {
        approvalPending && approvalPending.length > 0 ? <main>
          <div className='tablebg table-responsive h-[80vh] rounded '>
            <table className='w-full  '>
              <tr>
                <th>SI NO </th>
                <th>Candidate Name</th>
                <th>Candidate ID </th>
                <th>Prepared By </th>
                <th>Preparation Date </th>
                <th>Offered Package</th>
                <th>Verification assigned to </th>
                <th>Status </th>
                <th> Offer Letter</th>
              </tr>
              {
                approvalPending.map((obj, index) => (
                  <tr>
                    <td>{index + 1} </td>
                    <td>{obj.Name} </td>
                    <td>{obj.CandidateId} </td>
                    <td>{obj.letter_prepared_by_name} </td>
                    <td> {convertToReadableDateTime(obj.letter_prepared_date)} </td>

                    <td>{obj.CTC} </td>
                    <td>{obj.letter_verified_by_name} </td>
                    <td className='px-1'>{obj.verification_status} </td>
                    <td> <button onClick={() => navigate(`/candidateOfferLetter/${obj.CandidateId}`)} className='p-2 text-white   bg-blue-600 rounded '> View </button> </td>
                  </tr>
                ))
              }


            </table>
          </div>

        </main> :
          <main className='bgclr rounded h-[40vh] flex ' >
            <p className='m-auto'>No Offer approval is pending </p>

          </main>
      }

    </div>
  )
}

export default OfferApprovalPage