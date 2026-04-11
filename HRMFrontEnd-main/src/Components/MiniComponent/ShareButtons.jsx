import React from 'react'
import LinkedInIcon from '../Icons/LinkedInIcon'
import WhatsappIcon from '../Icons/WhatsappIcon'

const ShareButtons = ({ text }) => {
    return (
        <div className='my-3 flex gap-3 flex-wrap ' >
            <a target='_blank' href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(text)}`} >
                <LinkedInIcon size={24} />
            </a>
            <a href={`https://wa.me/?text=${text}`} target='_blank' className='text-green-500  '  >
                <WhatsappIcon size={24} />
            </a>
        </div>
    )
}

export default ShareButtons