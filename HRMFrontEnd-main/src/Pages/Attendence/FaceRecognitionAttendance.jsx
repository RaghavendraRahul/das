import React, { useRef, useEffect, useState } from 'react';
import * as faceapi from 'face-api.js';

const FaceRecognitionAttendance = () => {
    const videoRef = useRef(null);
    const [attendance, setAttendance] = useState([]);

    useEffect(() => {
        // Load face-api models
        const loadModels = async () => {
            const MODEL_URL = '/public/models';
            await Promise.all([
                faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
                faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
                faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL),
            ]);
            startVideo();
        };

        const startVideo = () => {
            navigator.mediaDevices
                .getUserMedia({ video: true })
                .then((stream) => {
                    if (videoRef.current) videoRef.current.srcObject = stream;
                })
                .catch((err) => console.error('Error accessing webcam: ', err));
        };

        loadModels();
    }, []);

    const handleVideoPlay = async () => {
        const labeledDescriptors = await loadLabeledDescriptors(); // Pre-registered face data
        const faceMatcher = new faceapi.FaceMatcher(labeledDescriptors, 0.6);

        setInterval(async () => {
            if (videoRef.current) {
                const detections = await faceapi
                    .detectAllFaces(videoRef.current, new faceapi.TinyFaceDetectorOptions())
                    .withFaceLandmarks()
                    .withFaceDescriptors();

                if (detections.length > 0) {
                    const results = detections.map((d) => faceMatcher.findBestMatch(d.descriptor));
                    const presentUsers = results
                        .filter((r) => r.label !== 'unknown')
                        .map((r) => r.label);

                    setAttendance((prev) => [...new Set([...prev, ...presentUsers])]);
                }
            }
        }, 1000); // Check every second
    };

    const loadLabeledDescriptors = async () => {
        const labels = ['John Doe', 'Jane Smith']; // Example user labels
        return Promise.all(
            labels.map(async (label) => {
                const img = await faceapi.fetchImage(`/images/${label}.jpg`); // Pre-registered images
                const detections = await faceapi.detectSingleFace(img).withFaceLandmarks().withFaceDescriptor();
                return new faceapi.LabeledFaceDescriptors(label, [detections.descriptor]);
            })
        );
    };

    return (
        <div>
            <video
                ref={videoRef}
                autoPlay
                muted
                onPlay={handleVideoPlay}
                style={{ width: '720px', height: '560px' }}
            />
            <div>
                <h2>Attendance</h2>
                <ul>
                    {attendance.map((user, index) => (
                        <li key={index}>{user}</li>
                    ))}
                </ul>
            </div>
        </div>
    );
};

export default FaceRecognitionAttendance;
