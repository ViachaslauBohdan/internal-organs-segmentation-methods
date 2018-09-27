var fileName
var newListItem
var coordsArray = []
var reconstructionCoords = []
var kmeansClusteredImages
var choosenImageNumber

import { ajax } from './ajax'
import mainButtons from './main-buttons-activator'



$(document).ready(function () {
  mainButtons.init()

  $("#processing-button").click(() => {
    if ($('#seed-button').css('background-color') == 'rgb(33, 165, 34)') {
      const radioChecked = $("input[type=radio][name=seed]:checked").val()
      const neighboursNumber = $("input[type=radio][name='neighbours']:checked").val()
      const ratio = $("input[type=number][name='seed']").val()
      // const url = protocol + serverURL + '/seed' + `?fileName=${fileName}&ratio=${ratio}&neighboursNumber=${neighboursNumber}&distance=${radioChecked}`
      const suffix = '/seed' + `?fileName=${fileName}&ratio=${ratio}&neighboursNumber=${neighboursNumber}&distance=${radioChecked}`


      ajax.sendPostRequest(suffix, coordsArray)
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
      const params = { fileName, clustersNumber }

      ajax.sendGetRequest('/kmeans/step1', params)
        .done(function (res) {
          kmeansClusteredImages = res.arrayOfImgs

          res.arrayOfImgs.forEach((arrayImg, index) => {
            const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], arrayImg))
            let carouselElement
            let carouselItemIndicator

            if (index === 0) {
              carouselElement = `
              <div class='carousel-item active'" + ">
                      <div class="slide-name" style='color:white;font-size:20px'>Cluster number: ${index + 1}</div> 
                      <canvas id='canvas${index}'></canvas>
              </div>`
              carouselItemIndicator = `<li class='item${index + 1} active'" + "></li>`
            }
            else {
              carouselElement = `
              <div class='carousel-item'" + ">
                      <div class="slide-name" style='color:white;font-size:20px'>Cluster number: ${index + 1}</div>
                      <canvas id='canvas${index}'></canvas>
              </div>`
              carouselItemIndicator = `<li class='item${index + 1}'" + "></li>`
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

  $(".carousel-submit-button").click(() => {

    if ($('.carousel-input').attr('name') === 'step2') {
      const filterNumber = $(".filters-list").find("li").filter(function () {
        return $(this).css("background-color") === "rgb(208, 156, 0)";
      }).index()

      ajax.sendGetRequest('/kmeans/step2', { filterNumber: filterNumber + 1, imgNumber: choosenImageNumber - 1, reconstructionCoords })
        .done(function (res) {
          console.log(res)
        })
        .fail(function (err) {
          console.log(err)
        })
    }
    else {
      choosenImageNumber = $('.carousel-input').val()

      const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], kmeansClusteredImages[choosenImageNumber - 1]))
      let carouselElement
      let carouselItemIndicator

      $('.modal-title').text('Step 2: select further processing filter number')
      $('.processing-filters').css({ 'display': 'inherit', 'color': 'white' })
      $('.carousel-input').attr('name', 'step2') //step detector

      carouselElement = `
      <div class='carousel-item active'" + ">
              <div class="slide-name" style='color:white;font-size:20px'>Choosen image for further processing</div> 
              <canvas id='canvas1'></canvas>
      </div>`
      carouselItemIndicator = `<li class='item1 active'" + "></li>`

      $('.carousel-inner').html(carouselElement)
      $('.carousel-indicators').html(carouselItemIndicator)
      $(".carousel-item").css({ 'width': '100%', 'height': '600px' })

      cv.imshow(`canvas1`, m);
      activateCarousel(1)
      $('#dicomImgModal').modal()
    }



  })

  $('.filters-list li').click(function () {
    $(this).css({ 'background-color': '#d09c00' })
    for (let i = 0; i < 5; i++) {
      if (($(this).index() !== i) && ($(`.filters-list li:nth-child(${i + 1})`).css('background-color')) !== 'rgb(68, 66, 66)') {
        $(`.filters-list li:nth-child(${i + 1})`).css({ 'background-color': 'rgb(68, 66, 66)' })
      }
    }

    switch ($(this).index()) {
      case 0:
        $('.reconstruction-pts').removeClass('d-none')
        $('.reconstruction-pts').addClass('d-flex')
        $('#canvas1').css({ cursor: 'crosshair' })
        break
    }
  })

  $('.carousel-inner').delegate('#canvas1', 'click', function (event) {
    console.log('canvas1')
    $('.reconstruction-no-points').remove()
    reconstructionCoords.push({
      x: event.offsetX,
      y: event.offsetY
    })
    $('#reconstruction-points-container').append(`<li>x: ${event.offsetX} y: ${event.offsetY}</li>`)
  })

  $("#processing-button").click(() => {
    if ($('#fuzzy-button').css('background-color') == 'rgb(33, 165, 34)') {
      const clustersNumber = $("input[type=number][name='fuzzy']").val()
      const params = { fileName, clustersNumber }

      ajax.sendGetRequest('/fuzzy', params)
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

}

