import React, { useEffect, useRef, useState } from 'react';
import Quagga from 'quagga';
import { BarcodeScanner,NotFoundException,ZXing, BrowserMultiFormatReader } from '@zxing/library';
const BarcodeScannered = ({ onDetected }) => {
    const videoRef = useRef(null);
    const [result, setResult] = useState('');
    const [error, setError] = useState('');
  
    useEffect(() => {
      const codeReader = new BrowserMultiFormatReader();
      let active = true;
  
      const startScan = async () => {
        try {
          const devices = await navigator.mediaDevices.enumerateDevices();
          const videoInputDevices = devices.filter(device => device.kind === 'videoinput');
  
          if (videoInputDevices.length === 0) {
            throw new Error('No video input devices found');
          }
  
          // Use the rear camera if available
          const constraints = {
            video: {
              facingMode: 'environment',
            },
          };
  
          await codeReader.decodeFromVideoDevice(null, videoRef.current, (result, err) => {
            if (result && active) {
              setResult(result.text);
              codeReader.reset();
            }
            if (err) {
              if (err.name !== 'NotFoundException') {
                setError(err.message);
              }
            }
          }, constraints);
        } catch (e) {
          setError(e.message);
        }
      };
  
      startScan();
  
      return () => {
        active = false;
        codeReader.reset();
      };
    }, []);
  
    return (
      <div>
        <h1>Barcode Scanner</h1>
        <video ref={videoRef} style={{ width: '100%' }} autoPlay playsInline />
        {result && <p>Result: {result}</p>}
        {error && <p>Error: {error}</p>}
      </div>
    );
};

export default BarcodeScannered;