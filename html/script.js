const resourceName = GetParentResourceName ? GetParentResourceName() : 'vima_audio';

window.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('main-container');
    const visualizer = document.getElementById('visualizer');
    const statusText = document.getElementById('statusText');
    const batteryLevel = document.getElementById('batteryLevel');
    const batteryBar = document.getElementById('batteryBar');
    const currentTier = document.getElementById('currentTier');
    
    let isPlaying = false;

    // Helper function for FiveM NUI Callbacks
    async function postData(endpoint, data = {}) {
        try {
            await fetch(`https://${resourceName}/${endpoint}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify(data)
            });
        } catch (error) {
            console.log(`Failed to post to ${endpoint}:`, error);
        }
    }

    // Listen for messages from Client
    window.addEventListener('message', function(event) {
        const item = event.data;

        if (item.type === "ui") {
            if (item.display === true) {
                container.style.display = 'block';
                if (item.tier) {
                    currentTier.textContent = item.tier.toUpperCase();
                }
            } else {
                container.style.display = 'none';
            }
        }

        if (item.action === "batteryUpdate") {
            const level = Math.round(item.battery);
            batteryLevel.textContent = `${level}%`;
            batteryBar.style.width = `${level}%`;
            
            if (level < 20) {
                batteryBar.style.background = '#ff3366'; // Turn red if low
            } else {
                batteryBar.style.background = 'linear-gradient(90deg, #ff3366, #00ff88)';
            }
        }
    });

    // Control Buttons
    document.getElementById('playBtn').addEventListener('click', () => {
        postData('audioControl', { action: "start" });
        isPlaying = true;
        visualizer.classList.add('active');
        statusText.textContent = "PLAYING";
        statusText.style.color = "#00ff88";
    });

    document.getElementById('pauseBtn').addEventListener('click', () => {
        postData('audioControl', { action: "stop" }); // Assuming stop handles pausing for now
        isPlaying = false;
        visualizer.classList.remove('active');
        statusText.textContent = "PAUSED";
        statusText.style.color = "#f39c12";
    });

    document.getElementById('stopBtn').addEventListener('click', () => {
        postData('audioControl', { action: "stop" });
        isPlaying = false;
        visualizer.classList.remove('active');
        statusText.textContent = "STANDBY";
        statusText.style.color = "#aaa";
    });

    // Volume Slider
    const volumeSlider = document.getElementById('volumeSlider');
    if (volumeSlider) {
        volumeSlider.addEventListener('input', function() {
            postData('setVolume', { volume: this.value });
        });
    }

    // Close Button & ESC key
    const closeUI = () => {
        container.style.display = 'none';
        postData('exit'); // Make sure you have an NUI callback registered for 'exit' in client.lua to drop NuiFocus!
    };

    document.getElementById('closeBtn').addEventListener('click', closeUI);

    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape') {
            closeUI();
        }
    });
});