import React from 'react'
import Login__ from '../Login__'

const LoginProtect = ({ Child }) => {
    let user = sessionStorage.getItem('user')
    return (
        <div>
            {user ? <Child /> : <Login__ />}
        </div>
    )
}

export default LoginProtect