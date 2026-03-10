// Vima Advanced Audio - Media Player Interface

let audioContext = null;
let isPlaying = false;
let currentVolume = 0.5;

const playBtn = document.getElementById('playBtn');
const pauseBtn = document.getElementById('pauseBtn');
const stopBtn = document.getElementById('stopBtn');
const volumeSlider = document.getElementById('volumeSlider');
const currentTier = document.getElementById('currentTier');
const batteryLevel = document.getElementById('batteryLevel');
const status = document.getElementById('status');

function initAudioPlayer() {
    playBtn.addEventListener('click', () => playAudio());
    pauseBtn.addEventListener('click', () => pauseAudio());
    stopBtn.addEventListener('click', () => stopAudio());
    
    volumeSlider.addEventListener('input', (e) => {
        currentVolume = e.target.value / 100;
        updateVolume(currentVolume);
    });
    
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.type) {
            case 'updateTier':
                updateTier(data.tier);
                break;
            case 'updateBattery':
                updateBattery(data.level);
                break;
            case 'updateStatus':
                updateStatus(data.status);
                break;
        }
    });
    
    window.postMessage({type: 'requestInitialData'}, '*');
}

function playAudio() {
    if (!audioContext) {
        audioContext = new (window.AudioContext || window.webkitAudioContext)();
    }
    
    isPlaying = true;
    status.textContent = 'Playing';
    
    console.log('Audio playback started');
}

function pauseAudio() {
    isPlaying = false;
    status.textContent = 'Paused';
    console.log('Audio playback paused');
}

function stopAudio() {
    isPlaying = false;
    status.textContent = 'Stopped';
    console.log('Audio playback stopped');
}

function updateVolume(volume) {
    console.log(`Volume set to ${volume}`);
}

function updateTier(tier) {
    currentTier.textContent = tier;
}

function updateBattery(level) {
    batteryLevel.textContent = `${level}%`;
    
    if (level < 20) {
        batteryLevel.style.color = 'red';
    } else {
        batteryLevel.style.color = 'white';
    }
}

function updateStatus(newStatus) {
    status.textContent = newStatus;
}

document.addEventListener('DOMContentLoaded', function() {
    initAudioPlayer();
});

window.addEventListener('focus', () => {
    if (audioContext && audioContext.state === 'suspended') {
        audioContext.resume();
    }
});

window.addEventListener('blur', () => {
    if (audioContext) {
        audioContext.suspend();
    }
});
