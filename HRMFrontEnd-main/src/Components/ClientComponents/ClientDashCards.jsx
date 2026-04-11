import axios from 'axios'
import React, { useEffect, useState } from 'react'
import { port } from '../../App'
import ShortcutCard from '../HomeComponent/ShortcutCard'
import Slider from 'react-slick'
import { useNavigate } from 'react-router-dom'

const ClientDashCards = ({ rid, cid }) => {
    let [allProcess, setAllProcess] = useState()
    let [loading, setLoading] = useState()
    let navigate = useNavigate()
    let getAllClientCalls = () => {
        setLoading(true)
        axios.get(`${port}/root/cms/client-finalstatus-count${rid ? `?req_id=${rid}` : ''}${cid ? `?client_id=${cid}` : ''}`).then((response) => {
            setAllProcess(response.data)
            console.log(response.data, 'All data');
            setLoading(false)
        }).catch((error) => {
            setLoading(false)
            console.log(error, 'all');
        })
    }
    useEffect(() => {
        getAllClientCalls()
    }, [cid, rid])
    var settings1 = {
        dots: true,
        arrows: false,
        infinite: true,
        speed: 900,
        slidesToShow: 4,
        autoplay: true,
        speed: 1000,
        responsive: [
            {
                breakpoint: 1220,
                settings: {
                    slidesToShow: 5,
                    slidesToScroll: 1,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 800,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 1,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 1,
                    initialSlide: 2
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    };

    return (
        <div className='my-3 ' >
            {allProcess &&
                <Slider {...settings1} className='py-3 ' >
                    <div className='' onClick={()=>navigate(`/client/category/client_kept_on_hold${rid ? `?req_id=${rid}` : ''}${cid ? `?client_id=${cid}` : ''}`)} >
                        <ShortcutCard img={'/assets/Images/circle1.png'}
                            count={allProcess.client_kept_on_hold} label='Client Kept On Hold' />
                    </div>
                    <div onClick={()=>navigate(`/client/category/client_offer_rejected${rid ? `?req_id=${rid}` : ''}${cid ? `?client_id=${cid}` : ''}`)} >
                        <ShortcutCard img={'/assets/Images/circle2.png'}
                            count={allProcess.client_offer_rejected} label='Candidate Rejected' />
                    </div>
                    <div onClick={()=>navigate(`/client/category/client_offered${rid ? `?req_id=${rid}` : ''}${cid ? `?client_id=${cid}` : ''}`)} >
                        <ShortcutCard img={'/assets/Images/circle3.png'}
                            count={allProcess.client_offered} label='Client Offered' />
                    </div>
                    <div onClick={()=>navigate(`/client/category/client_rejected${rid ? `?req_id=${rid}` : ''}${cid ? `?client_id=${cid}` : ''}`)} >
                        <ShortcutCard img={'/assets/Images/circle4.png'}
                            count={allProcess.client_rejected} label='Client Rejected' />
                    </div>

                </Slider>}



        </div>
    )
}

export default ClientDashCards