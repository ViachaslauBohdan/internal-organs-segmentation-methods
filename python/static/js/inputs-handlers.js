var fileName
var buttons = [{
  id: '#seed-button',
  container: '#seed-inputs-wrapper',
  cliked: false,
},
{
  id: '#kmeans-button',
  container: '#kmeans-inputs-wrapper',
  cliked: false
}]

$(document).ready(function () {
  $("#processing-button").click(() => {
    const radioChecked = $("input[type=radio][name=seed]:checked").val()
    const neighboursNumber = $("input[type=radio][name='neighbours']:checked").val()
    const ratio = $("input[type=number]").val()
    const url = protocol + serverURL + '/seed'
    const params = { fileName, ratio, neighboursNumber, distance: radioChecked };

    $.ajax({
      url: url,
      type: "GET",
      data: params,
      contentType: "application/json; charset=utf-8",
      dataType: "json",
    })
      .done(function (jsonRes) {
        console.log(jsonRes)
        const res = JSON.parse(jsonRes)
        // console.log(res,res.result.split(" "))
      })
      .fail(function (err) {
        console.log(err)
      })
  })

  $('input[type="file"]').change(function (e) {
    fileName = e.target.files[0].name;
  })

  buttons.forEach(button => {
    $(button.id).click(function () {
      if (!button.cliked) {
        activateButton(button.id, button.container)

        const buttonToDeactivate = buttons.find((b) => {
          return (b.cliked == true) && (b.id != button.id)
        })
        if (buttonToDeactivate) deactivateRest(buttonToDeactivate.id, buttonToDeactivate.container)
      }
      else deactivateRest(button.id, button.container)
    })
  })

})

function activateButton(buttonId, containerId) {
  $(buttonId).css({ 'background': '#21a522' })
  $(containerId).css({
    'display': 'inherit'
  })
  buttons.forEach(button => {
    if (button.id == buttonId) button.cliked = true
  })
}

function deactivateRest(buttonId, containerId) {
  $(buttonId).css({ 'background': '#20a5d6' })
  $(containerId).css({
    'display': 'none'
  })
  buttons.forEach(button => {
    if (button.id == buttonId) button.cliked = false
  })
}