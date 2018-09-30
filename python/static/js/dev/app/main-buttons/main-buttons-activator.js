export default (function initMainButtons(){
    var mainButtons = {
        init: function () {
            this.buttons.forEach(button => {
                const thisSuper = this
                $(button.id).click(function () {
                    if (!button.cliked) {
                        thisSuper.activateButton(button.id, button.container)
    
                        const buttonToDeactivate = thisSuper.buttons.find((b) => {
                            return (b.cliked == true) && (b.id != button.id)
                        })
                        if (buttonToDeactivate) thisSuper.deactivateRest(buttonToDeactivate.id, buttonToDeactivate.container)
                    }
                    else thisSuper.deactivateRest(button.id, button.container)
                })
            })
        },
    
        buttons: [{
            id: '#seed-button',
            container: '#seed-inputs-wrapper',
            cliked: false,
        },
        {
            id: '#kmeans-button',
            container: '#kmeans-inputs-wrapper',
            cliked: false
        },
        {
            id: '#fuzzy-button',
            container: '#fuzzy-inputs-wrapper',
            cliked: false
        }],
    
        activateButton: function activateButton(buttonId, containerId) {
            $(buttonId).css({ 'background-color': '#21a522' })
            $(containerId).css({
                'display': 'inherit'
            })
            this.buttons.forEach(button => {
                if (button.id == buttonId) button.cliked = true
            })
        },
        deactivateRest: function deactivateRest(buttonId, containerId) {
            $(buttonId).css({ 'background-color': '#20a5d6' })
            $(containerId).css({
                'display': 'none'
            })
            this.buttons.forEach(button => {
                if (button.id == buttonId) button.cliked = false
            })
        }
    }

    mainButtons.init()
}())