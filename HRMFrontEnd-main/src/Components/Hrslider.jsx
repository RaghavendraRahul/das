import React from 'react'
import Slider from "react-slick";


const Hrslider = () => {


    var settings1 = {
        dots: false,
        infinite: true,
        speed: 900,
        slidesToShow: 4,
        autoplay: true,
        speed: 1000,
        responsive: [
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
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
        <div>
            {/* Sliders start */}
            
            <Slider {...settings1} className='container'>
                <div className='bg-danger'>
                    <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
                <div className='bg-warning'>
                <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
                <div className='bg-primary'>
                <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
                <div className='bg-success'>
                <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
                <div className='bg-info'>
                <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
                <div className='bg-primary'>
                <div className="box1 border rounded d-flex justify-content-around align-items-center ">
                        <div>
                            <img src={require('../assets/Icon/male-workers-svgrepo-com.png')} width={50} alt="" />
                        </div>

                        <div>
                            <h4 style={{ position: 'relative', top: '5px' }}>100</h4>
                            <p>No Employees Hired</p>
                        </div>

                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                                <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z" />
                            </svg>
                        </div>

                    </div>
                </div>
            </Slider>


            {/* Sliders end */}
        </div>
    )
}

export default Hrslider