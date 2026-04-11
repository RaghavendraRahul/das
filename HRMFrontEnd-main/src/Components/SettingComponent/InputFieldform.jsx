import React from 'react'
import InfoButton from './InfoButton';
import ReactQuill from 'react-quill-new';

const InputFieldform = ({ size, name, accept, errormsg, optionObj, required, link, disabled, placeholder,
    label, options, value, index, info, handleChange, type, limit }) => {
    console.log(optionObj, 'yyyy');

    return (
        <div className={`${size && size != '' ? size : "col-md-6 col-lg-4"} flex flex-col mb-3`}>
            <label htmlFor="lastName" className="form-label flex items-center ">
                {label}
                {required && <span className='text-red-600 mx-1 text-xs '> {errormsg ? errormsg : "*"} </span>}
                {link && type == 'file' && typeof link == 'string' && <a href={link} target='_blank' >uploaded file </a>}
                {info && <InfoButton content={info} size={11} />}
            </label>



            {type == 'quill' ? <ReactQuill value={value} onChange={(value) => handleChange({ target: { name, value } })} /> : type != 'textarea' && !options && !optionObj &&
                <input placeholder={placeholder} accept={accept} type={type ? type : 'text'} disabled={disabled ? disabled : false}
                    className="p-2 block rounded inputbg w-full outline-none shadow-none" value={value}
                    onChange={(e) => {
                        if (limit) {
                            if (e.target.value >= 0 && e.target.value <= Number(limit)) {
                                // alert('helo')
                                index || index == 0 ? handleChange(e, index) : handleChange(e);
                            }
                        }
                        else {
                            index || index == 0 ? handleChange(e, index) : handleChange(e);
                        }
                    }} id="LastName" name={name} />}
            {type == 'textarea' && !options && !optionObj && <textarea placeholder={placeholder} disabled={disabled ? disabled : false} name={name} value={value} onChange={handleChange} rows={5}
                className='p-2 inputbg rounded block w-full outline-none ' id=""></textarea>}

            {(options || optionObj) &&
                <select value={value} onChange={(e) => index || index == 0 ? handleChange(e, index) : handleChange(e)} name={name} disabled={disabled}
                    className='p-2 block rounded inputbg w-full outline-none shadow-none'>
                    <option value="">Select  </option>
                    {options && options.map((val) => (
                        <option value={val}>{val} </option>
                    ))}
                    {optionObj &&
                        optionObj.map((obj) => (


                            <option value={obj.value} > {obj.label} </option>
                        ))
                    }
                </select>}
        </div>

    )
}

export default InputFieldform