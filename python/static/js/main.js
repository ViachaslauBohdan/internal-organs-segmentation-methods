var fileName
var newListItem
var coordsArray = []
var buttons = [{
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
}]

$(document).ready(function () {
  $("#processing-button").click(() => {
    if ($('#seed-button').css('background-color') == 'rgb(33, 165, 34)') {
      const radioChecked = $("input[type=radio][name=seed]:checked").val()
      const neighboursNumber = $("input[type=radio][name='neighbours']:checked").val()
      const ratio = $("input[type=number][name='seed']").val()
      const url = protocol + serverURL + '/seed' + `?fileName=${fileName}&ratio=${ratio}&neighboursNumber=${neighboursNumber}&distance=${radioChecked}`

      $.ajax({
        url: url,
        type: "POST",
        data: JSON.stringify({ coordsArray }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
      })
        .done(function (res) {
          $('#spinner').html('<p>processing finished</p>')
          const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], res.result))
          cv.imshow('canvasOutput', m);
        })
        .fail(function (err) {
          console.log(err)
        })
    }
  })

  $("#processing-button").click(() => {
    if ($('#kmeans-button').css('background-color') == 'rgb(33, 165, 34)') {
      const clustersNumber = $("input[type=number][name='kmeans']").val()
      const url = protocol + serverURL + '/kmeans'
      const params = { fileName, clustersNumber }

      $.ajax({
        url: url,
        type: "GET",
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
      })
        .done(function (res) {
          res.arrayOfImgs.forEach((arrayImg, index) => {
            const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], arrayImg))
            let carouselElement
            let carouselItemIndicator

            if (index === 0) {
              carouselElement = `<div class='carousel-item active'" + "><canvas id='canvas${index}'></canvas></div>`
              carouselItemIndicator = `<li class='item${index+1} active'" + "></li>`
            }
            else {
              carouselElement = `<div class='carousel-item'" + "><canvas id='canvas${index}'></canvas></div>`
              carouselItemIndicator = `<li class='item${index+1}'" + "></li>`
            }

            $('.carousel-inner').append(carouselElement)
            $('.carousel-indicators').append(carouselItemIndicator)
            $(".carousel-item").css({ 'width': '100%', 'height': '600px' })

            cv.imshow(`canvas${index}`, m);

          })
          activateCarousel(clustersNumber)
          $('#dicomImgModal').modal()
        })
        .fail(function (err) {
          console.log(err)
        })
    }
  })

  $("#processing-button").click(() => {
    if ($('#fuzzy-button').css('background-color') == 'rgb(33, 165, 34)') {
      console.log('get')

      const clustersNumber = $("input[type=number][name='fuzzy']").val()
      const url = protocol + serverURL + '/fuzzy'
      const params = { fileName, clustersNumber }

      $.ajax({
        url: url,
        type: "GET",
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
      })
        .done(function (res) {
          $('#spinner').html('<p>processing finished</p>')
          console.log(res.result)
          let m = cv.matFromArray(1, 8, cv.CV_8UC1, res.result);
          console.log(m.data)

          cv.imshow('canvasOutput', m);
          // const res = JSON.parse(jsonRes)
          // console.log(res)
        })
        .fail(function (err) {
          console.log(err)
        })
    }
  })

  $('input[type="file"]').change(function (e) {
    fileName = e.target.files[0].name;
    if ($('input[type="file"]')) {
      $('#buttons-wrapper').css('visibility', 'visible')
    }
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

  $('.cornerstone-canvas').click(function (e) {
    if (!$('#seed-list-item').length) $('#no-seeds').remove()
    coordsArray.push({
      x: e.offsetX,
      y: e.offsetY
    })

    newListItem = $(`<li id="seed-list-item">X: ${e.offsetX} Y: ${e.offsetY}</li>`)
    $('#seed-list').append(newListItem)

  })

})

function activateButton(buttonId, containerId) {
  $(buttonId).css({ 'background-color': '#21a522' })
  $(containerId).css({
    'display': 'inherit'
  })
  buttons.forEach(button => {
    if (button.id == buttonId) button.cliked = true
  })
}

function deactivateRest(buttonId, containerId) {
  $(buttonId).css({ 'background-color': '#20a5d6' })
  $(containerId).css({
    'display': 'none'
  })
  buttons.forEach(button => {
    if (button.id == buttonId) button.cliked = false
  })
}

function activateCarousel(clustersNumber) {
  $("#dicom-images-carousel").carousel()

  // Enable Carousel Indicators
  for (let i = 1; i <= clustersNumber; i++) {
    $(`.item${i}`).click(function () {
      $("#dicom-images-carousel").carousel(i - 1)
    })
  }

  // Enable Carousel Controls
  $(".carousel-control-prev").click(function () {
    $("#dicom-images-carousel").carousel("prev")
  })
  $(".carousel-control-next").click(function () {
    $("#dicom-images-carousel").carousel("next")
  })

  $('.carousel').carousel('pause');
}