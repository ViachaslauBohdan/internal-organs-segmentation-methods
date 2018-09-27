
var ajax = {
    sendGetRequest: function sendGetRequest(suffix, params) {
        const url = this.generateURL(suffix)
        return $.ajax({
            url: url,
            type: "GET",
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
        })
    },

    sendPostRequest: function sendPostRequest(suffix, payload) {
        const url = this.generateURL(suffix)

        return $.ajax({
            url: url,
            type: "POST",
            data: JSON.stringify({ payload }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
        })

    },

    generateURL: function generateURL(suffix) {
        return location.protocol + '//' + location.host + suffix
    }

}

export { ajax }


