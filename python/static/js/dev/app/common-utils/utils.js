var commonUtils = {
    activateSpinner: function () {
        $('#spinner-modal').modal()
        if($('#dicomImgModal').is(':visible')) $('#dicomImgModal').modal('hide')

    },
    deactivateSpinner: function () {
        $('#spinner-modal').modal('hide')
    }
}

export { commonUtils }