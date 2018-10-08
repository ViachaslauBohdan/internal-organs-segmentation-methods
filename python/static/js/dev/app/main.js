var fileName
var newListItem
var coordsArray = []

import { ajax } from './ajax-utils/ajax'
import initMainButtons from './main-buttons/main-buttons-activator'
import carousel from './carousel/carousel'
import loadFileFromPC from './files-loader/load-file-from-pc'
import { commonUtils } from './common-utils/utils'




$(document).ready(function () {
  loadFileFromPC.activateClickEventListener()

  $("#processing-button").click(() => {
    if ($('#seed-button').css('background-color') == 'rgb(33, 165, 34)') {
      console.log('START SEED PROCESSING')

      const radioChecked = $("input[type=radio][name=seed]:checked").val()
      const fileName = loadFileFromPC.getLoadedFileName()
      const neighboursNumber = $("input[type=radio][name='neighbours']:checked").val()
      const ratio = $("input[type=number][name='seed']").val()
      const suffix = '/seed' + `?fileName=${fileName}&ratio=${ratio}&neighboursNumber=${neighboursNumber}&distance=${radioChecked}`


      ajax.sendPostRequest(suffix, coordsArray)
        .done(function (res) {
          console.log('GOT RESPONSE')
          commonUtils.deactivateSpinner()
          const img = res.result[0]
          const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], img))
          cv.imshow('canvasOutput', m)

          let label
          let x
          let y
          const canvas = document.getElementById('canvasOutput')
          const ctx = canvas.getContext("2d")
          ctx.fillStyle = "#fb0"
          ctx.font = "bold 20px Arial"
          ctx.fontWeight
          ctx.textBaseline = "start"

          res.result[1].forEach(el => {
            label = el.name
            x = el.centroidX
            y = el.centroidY
            console.log(el, label)
            ctx.fillText(label, x, y)
          })

          coordsArray = []
          $('#seed-list').html('<div id="no-seeds">No seed points choosen</div>')


        })
        .fail(function (err) {
          console.log(err)
        })
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



