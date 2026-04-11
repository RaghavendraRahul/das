import React from 'react'
import InfoIcon from '../../SVG/InfoIcon'
import { OverlayTrigger, Tooltip } from 'react-bootstrap'

const InfoButton = ({ size, content }) => {
    const renderTooltip = (text) => (
        <Tooltip id="button-tooltip"
         className='m-0 p-0 custom-tooltip '  >
            <p className='text-xs m-0  '> {text} </p> </Tooltip>
    );
    return (
        <div>
            <OverlayTrigger className=''
                placement="top" delay={{ show: 150, hide: 200 }}
                overlay={renderTooltip(content)}>
                <div>
                    <InfoIcon size={size} />
                </div>
            </OverlayTrigger>
        </div>
    )
}

export default InfoButton