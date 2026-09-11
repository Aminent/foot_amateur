import React, { useEffect, useState } from 'react';
import Lottie from 'lottie-react';
import animationData from '../assets/socccerfield.json';

export default function CoachIntroAnimation({ showOn = true, duration = 3000, size = 400 }) {
    const [visible, setVisible] = useState(false);

    useEffect(() => {
        if (showOn) {
            setVisible(true);
            const t = setTimeout(() => setVisible(false), duration);
            return () => clearTimeout(t);
        }
    }, [showOn, duration]);

    if (!visible) return null;

    const overlay = {
        position: 'fixed',
        inset: 0,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'rgba(0,0,0,0.6)',
        zIndex: 9999,
    };

    return (
        <div style={overlay} aria-hidden="true">
            <div style={{ width: size, height: size }}>
                <Lottie animationData={animationData} loop={false} />
            </div>
        </div>
    );
}