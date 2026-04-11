import React from 'react'
import { createContext, useState } from 'react'
export const Context = createContext()

const Context_Provider = (props) => {

  const [Name, setNamep] = useState('')
  const [Email, setEmailp] = useState('')
  const [Phone, setPhonep] = useState('')
  const [DOB, setDOBp] = useState('')
  const [Designation, setDesignationp] = useState('')
  const [CTC, setCTCp] = useState('')
  const [WorkLocation, setWorkLocationp] = useState('')
  const [OfferedDate, setOfferedDatep] = useState('')
  const [AcceptStatus, setAcceptStatusp] = useState('')
  const [LetterSendedBy, setLetterSendedByp] = useState('')

  const provider_value = { Name, setNamep, Email, setEmailp, Phone, setPhonep, DOB, setDOBp, Designation, setDesignationp, CTC, setCTCp, WorkLocation, setWorkLocationp, OfferedDate, setOfferedDatep, AcceptStatus, setAcceptStatusp, LetterSendedBy, setLetterSendedByp }


  return (
    <Context_Provider value={provider_value}>
      {props.children}

    </Context_Provider>
  )
}

export default Context_Provider