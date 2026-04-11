import React from 'react'

const PermissionCheckBox = ({ value, handlePermissionChanges, name, checked, label }) => {
    return (
        <div className="col-md-6 col-lg-4 mb-3 flex gap-2 items-center">
            <input type="checkbox" className="" checked={checked}
                id={name} value={value}
                onChange={() => handlePermissionChanges(name)}
            />
            <label htmlFor={name}>
                {label}
            </label>
        </div>
    )
}

export default PermissionCheckBox