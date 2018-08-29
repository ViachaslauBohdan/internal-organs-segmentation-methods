var fileName
$(document).ready(function () {
  $("#processing-button").click(() => {
    const radioChecked = $("input[type=radio][name=seed]:checked").val()
    const neighboursNumber = $("input[type=radio][name='neighbours']:checked").val()
    const ratio = $("input[type=number]").val()
    const url = protocol + serverURL + '/seed'
    const params = { fileName, ratio, neighboursNumber,distance: radioChecked };

    $.ajax({
      url: url,
      type: "GET",
      data: params,
      contentType: "application/json; charset=utf-8",
      dataType: "json",
    })
      .done(function (jsonRes) {
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

  $('#seed-button').click(function () {
    $(this).css({ 'background': '#21a522' })
    $('#seed-inputs-wrapper').css({
      'display': 'inherit'
    })
  })
})