var loadFileFromPC = {
    activateClickEventListener: function () {
        var superThis = this
        $(document).ready(function () {
            $('input[type="file"]').change(function (e) {
                superThis.fileName = e.target.files[0].name
                if ($('input[type="file"]')) {
                    $('#buttons-wrapper').css('visibility', 'visible')
                }
            })
        })
    },
    fileName: '',
    getLoadedFileName: function () { return this.fileName }
}
export default loadFileFromPC
