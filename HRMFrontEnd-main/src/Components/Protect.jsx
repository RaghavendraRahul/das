import React from 'react'
import Login from './Login'

const Protect = ({ Child, prop }) => {

    const user = JSON.parse(sessionStorage.getItem('user'))
    const verify = () => {
        if (user == null) {
            return false
        }
        else {
            return true
        }
    }
    return (
        <div>
            {verify() ? <Child subpage={prop ? true : false} /> : <Login />}
        </div>
    )
}

export default Protect