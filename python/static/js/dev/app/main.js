var fileName
var newListItem
var coordsArray = []

import { ajax } from './ajax-utils/ajax'
import initMainButtons from './main-buttons/main-buttons-activator'
import carousel from './carousel/carousel'
import loadFileFromPC from './files-loader/load-file-from-pc'
import {commonUtils} from './common-utils/utils'

 


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
          commonUtils.deactivateSpinner()
          const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], res.result))
          cv.imshow('canvasOutput', m)
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



