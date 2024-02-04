// scripts.js
// script.js
window.addEventListener("message", (event) => {
    if (event.data.action === "setBoxes") {
        updateBox('thirst', event.data.thirst);
        updateBox('health', event.data.health);
        updateBox('hunger', event.data.hunger);
    }
});

function updateBox(boxId, fillPercentage) {
    const fillElement = document.getElementById(`${boxId}-fill`);
    fillElement.style.height = fillPercentage + '%';
}

// Example usage: updateBoxes(50, 80, 30);

window.addEventListener("message", (event) => {
    const data = event.data;

    switch (data.action) {

        case "setBoxes":
            $("#ui-container").fadeIn(150);
            updateBoxes(data.thirst, data.health, data.hunger, data.armor);
            break;

        case "updateSpeedometer":
            $(".speedometer").fadeIn(100);
            $(".fuel-info").fadeIn(100);
            updateSpeedometer(data.speed, data.fuel);
            break;
        
            case "updateTalkingStatus":
                updateTalkingStatus(data.isTalking);
                break;
                case "hidespeed":
                    $(".speedometer").fadeOut(100);
                    $(".fuel-info").fadeOut(100);
                    break;        
                    case "updateArmor":
            updateArmor(data.armor);
            break;
    
    }
});

function toggleHUD(show) {
    document.getElementById('ui-container').style.display = show ? 'flex' : 'none';
}

function updateBoxes(thirst, health, hunger, armor) {

    updateBox('thirst', thirst);
    updateBox('health', health);
    updateBox('hunger', hunger);
    updateBox('armor', armor);
}

function updateBox(boxId, fillPercentage) {
    const fillElement = document.getElementById(`${boxId}-fill`);
    fillElement.style.height = fillPercentage + '%';
}

function updateSpeedometer(speed, fuel) {
    const speedometerText = document.querySelector('.speedometer-text');
    speedometerText.innerText = speed;

    const fuelValue = document.getElementById('fuelValue');
    fuelValue.innerText = Math.floor(fuel);
}

function updateTalkingStatus(isTalking) {
    const soundIcon = document.getElementById('isound');
    
    if (isTalking) {
        $(".sound-icon").fadeIn(150);
        soundIcon.className = 'fas fa-microphone';

    } else {
        $(".sound-icon").fadeOut(150);
    }
}
function updateArmor(armor) {
    if (armor > 0) {
        $(".box#armor-box").fadeIn(100);
        updateBox('armor', armor);
    } else {
        $(".box#armor-box").fadeOut(100);
    }
}