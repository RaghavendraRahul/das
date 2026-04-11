import React, { useState } from 'react';
import SweetAlert from 'react-bootstrap-sweetalert';
import '../assets/css/Sweet_.css';

const SweetAlertComponent = () => {
    const [showAlert, setShowAlert] = useState(false);
    const [alertType, setAlertType] = useState('success');

    const handleSuccessButtonClick = () => {
        setAlertType('success');
        setShowAlert(true);
    };

    const handleErrorButtonClick = () => {
        setAlertType('error');
        setShowAlert(true);
    };

    const handleConfirm = () => {
        setShowAlert(false);
    };

    return (
        <div>
            <button className="professional-button" onClick={handleSuccessButtonClick}>
                Show Success Alert
            </button>
            <button className="professional-button" onClick={handleErrorButtonClick}>
                Show Error Alert
            </button>

            {showAlert && alertType === 'success' && (
                <SweetAlert
                    success
                    title="Thank you for registering with us!"
                    onConfirm={handleConfirm}
                    showConfirm={false} // Hide the default confirm button
                    customClass="professional-alert" // Apply custom class to the alert
                >
                    <div className="professional-content">
                        <h4>Rakesh Babu</h4>
                        <small>Your journey with Merida Tech Minds begins now. We are excited to support you in reaching your career goals.</small>
                    </div>
                </SweetAlert>
            )}

            {showAlert && alertType === 'error' && (
                <SweetAlert
                    error
                    title="An error occurred!"
                    onConfirm={handleConfirm}
                    showConfirm={false} // Hide the default confirm button
                    customClass="professional-alert-error" // Apply custom class to the alert
                >
                    <div className="professional-content">
                        <h4>Oops!</h4>
                        <small>Something went wrong. Please try again later.</small>
                    </div>
                </SweetAlert>
            )}
        </div>
    );
};

export default SweetAlertComponent;
