var errorMessage = 'THEOplayer PiP. Something went wrong while communicating with the native app. Error: ';
var baseButton = THEOplayer.videojs.getComponent('Button');
// Create a PiP button for the control bar
var pipButton = THEOplayer.videojs.extend(baseButton, {
    constructor: function () {
        baseButton.apply(this, arguments);
        this.controlText('Picture In Picture');
    },
    handleClick: function () {
        try {
            webkit.messageHandlers.THEOPiP.postMessage("pip");
        }
        catch (e) {
            console.log(errorMessage + e);
        }
    },
    buildCSSClass: function () {
        return 'vjs-icon-picture-in-picture-enter theo-controlbar-button vjs-control vjs-button';
    }
});
THEOplayer.videojs.registerComponent('pipButton', pipButton);
player.ui.getChild('controlBar').addChild('pipButton', {});
// Create the PiP close button
var pipCloseButton = THEOplayer.videojs.extend(baseButton, {
    constructor: function () {
        baseButton.apply(this, arguments);
    },
    handleClick: function () {
        try {
            webkit.messageHandlers.THEOPiP.postMessage("closePip");
            var theoplayerElement = document.querySelector('.theoplayer-skin');
            theoplayerElement.classList.remove('theo-pip-ios-sdk');
        }
        catch (e) {
            console.log(errorMessage + e);
        }
    },
    buildCSSClass: function () {
        return 'theo-close-button theo-pip-close';
    }
});
THEOplayer.videojs.registerComponent('pipCloseButton', pipCloseButton);
// Create a custom fullscreen button for PiP
var pipFullscreenButton = THEOplayer.videojs.extend(baseButton, {
    constructor: function () {
        baseButton.apply(this, arguments);
        this.controlText('Fullsreen');
    },
    handleClick: function () {
        try {
            webkit.messageHandlers.THEOPiP.postMessage("fullscreen");
            player.presentationMode = "fullscreen";
        }
        catch (e) {
            console.log(errorMessage + e);
        }
    },
    buildCSSClass: function () {
        return 'theo-ios-sdk-pip-fullscreen theo-controlbar-button vjs-fullscreen-control vjs-control vjs-button';
    }
});
THEOplayer.videojs.registerComponent('pipFullscreenButton', pipFullscreenButton);
player.ui.getChild('controlBar').addChild('pipFullscreenButton', {});
