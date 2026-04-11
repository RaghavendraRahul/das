
import Sidebar from './Sidebar';
import Topnav from './Topnav';






const All_request_data = () => {





  return (

    <div className=' d-flex' style={{ width: '100%', minHeight: '100%', backgroundColor: "rgb(249,251,253)" }}>

      <div className='side'>

        <Sidebar value={"dashboard"} ></Sidebar>
      </div>
      <div className=' m-0 m-sm-4 ps-1 ps-sm-2 ps-md-4 side-blog' style={{ borderRadius: '10px' }}>


        <Topnav ></Topnav>


        <div className='mt-3 inner_sections' >



          <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

            <li class="nav-item text-primary d-flex " role="presentation">
              <h6 class='mt-2 heading nav-link active' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">Resignation Request</h6>
            </li>

            <li class="nav-item text-primary d-flex " role="presentation">
              <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="false">Leave Request</h6>
            </li>

            <li class="nav-item text-primary d-flex " role="presentation">
              <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab" data-bs-toggle="pill" data-bs-target="#pills-contact" type="button" role="tab" aria-controls="pills-contact" aria-selected="false">In Time / Out Time Request</h6>
            </li>

            {/* <li class="nav-item text-primary d-flex " role="presentation">
              <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab1" data-bs-toggle="pill" data-bs-target="#pills-contact1" type="button" role="tab" aria-controls="pills-contact1" aria-selected="false">Offered</h6>
            </li>

            <li class="nav-item text-primary d-flex " role="presentation">
              <h6 class='mt-2 heading nav-link ' style={{ color: 'rgb(76,53,117)', backgroundColor: 'transparent', border: 'none' }} id="pills-contact-tab2" data-bs-toggle="pill" data-bs-target="#pills-contact2" type="button" role="tab" aria-controls="pills-contact2" aria-selected="false">Others</h6>
            </li> */}




          </ul>

          <div class="tab-content " id="pills-tabContent" style={{ position: 'relative', bottom: '20px' }}>
            <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">

              <h1>1</h1>
            </div>
            <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">

              <h1>2</h1>

            </div>
            <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">
              <h1>3</h1>

            </div>
            <div class="tab-pane fade" id="pills-contact1" role="tabpanel" aria-labelledby="pills-contact-tab1" tabindex="0">

              <h1>4</h1>

            </div>
            <div class="tab-pane fade" id="pills-contact2" role="tabpanel" aria-labelledby="pills-contact-tab2" tabindex="0">

              <h1>5</h1>

            </div>
          </div>

        </div>

      </div>



    </div>
  );
};

export default All_request_data;
