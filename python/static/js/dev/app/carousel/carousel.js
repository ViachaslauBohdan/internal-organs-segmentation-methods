import { ajax } from '../ajax-utils/ajax'
import loadFileFromPC from '../files-loader/load-file-from-pc'


var carousel = {
    activateClickEventListeners: function () {
        var superThis = this
        $(document).ready(function () {
            $(".carousel-submit-button").click(() => {
                superThis.carouselSubmit()
            })
            $('.carousel-inner').delegate('#canvas1', 'click', function (event) {
                $('.reconstruction-no-points').remove()
                superThis.reconstructionCoords.push({
                    x: event.offsetX,
                    y: event.offsetY
                })
                $('#reconstruction-points-container').append(`<li>x: ${event.offsetX} y: ${event.offsetY}</li>`)
            })
            $("#processing-button").click(() => {
                if ($('#kmeans-button').css('background-color') == 'rgb(33, 165, 34)') {
                    const clustersNumber = $("input[type=number][name='kmeans']").val()
                    let fileName = loadFileFromPC.getLoadedFileName()
                    const params = { fileName, clustersNumber }
                    carousel.generateEmptyCarousel(params, clustersNumber)
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
        })
    },
    generateEmptyCarousel: function (params, clustersNumber) {
        var superThis = this

        ajax.sendGetRequest('/kmeans/step1', params)
            .done(function (res) {
                superThis.kmeansClusteredImages = res.arrayOfImgs

                res.arrayOfImgs.forEach((arrayImg, index) => {
                    const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], arrayImg))
                    let carouselElement
                    let carouselItemIndicator

                    if (index === 0) {
                        carouselElement = superThis.activeSlideDOM.replace('#INDEX#', index).replace('#INDEX+1#', index + 1)
                        carouselItemIndicator = superThis.activeItemIndicator.replace('#INDEX+1#', index + 1)
                    }
                    else {
                        carouselElement = superThis.notActiveSlideDOM.replace('#INDEX#', index).replace('#INDEX+1#', index + 1)
                        carouselItemIndicator = superThis.notActiveItemIndicator.replace('#INDEX+1#', index + 1)
                    }

                    $('.carousel-inner').append(carouselElement)
                    $('.carousel-indicators').append(carouselItemIndicator)
                    $(".carousel-item").css({ 'width': '100%', 'height': '600px' })

                    cv.imshow(`canvas${index}`, m);

                })
                superThis.activateCarousel(clustersNumber)
                $('#dicomImgModal').modal()
            })
            .fail(function (err) {
                console.log(err)
            })  
    },
    carouselSubmit: function () {
        var superThis = this
        if ($('.carousel-input').attr('name') === 'step2') {
            console.log('KMEANS STEP3')
            const filterNumber = this.appendColours()

            ajax.sendPostRequest('/kmeans/step2', {
                filterNumber: filterNumber + 1, imgNumber: superThis.choosenImageNumber - 1, reconstructionCoords: superThis.reconstructionCoords
            })
                .done(function (res) {
                    console.log(res)
                })
                .fail(function (err) {
                    console.log(err)
                })
        }
        else if ($('.carousel-input').attr('name') === 'step1') {
            console.log('KMEANS STEP2')
            superThis.choosenImageNumber = $('.carousel-input').val()

            const m = cv.matFromArray(512, 512, cv.CV_8U, [].concat.apply([], superThis.kmeansClusteredImages[superThis.choosenImageNumber - 1]))
            let carouselElement
            let carouselItemIndicator

            $('.modal-title').text('Step 2: select further processing filter number')
            $('.processing-filters').css({ 'display': 'inherit', 'color': 'white' })
            $('.carousel-input').attr('name', 'step2') //step detector

            var superThis = this
            carouselElement = this.activeSlideDOM.replace('#INDEX#', 1).replace('#INDEX+1#', 1)
            carouselItemIndicator = this.activeItemIndicator.replace('#INDEX+1#', 1)
            console.log(carouselElement)
            $('.carousel-inner').html(carouselElement)
            $('.carousel-indicators').html(carouselItemIndicator)
            $(".carousel-item").css({ 'width': '100%', 'height': '600px' })

            cv.imshow(`canvas1`, m)
            this.activateCarousel(1)
            $('#dicomImgModal').modal()
        }
    },
    activateCarousel: function (clustersNumber) {
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

    },
    appendColours: function () {
        return $(".filters-list").find("li").filter(function () {
            return $(this).css("background-color") === "rgb(208, 156, 0)";
        }).index()
    },
    kmeansClusteredImages: null,
    reconstructionCoords: [],
    choosenImageNumber: null,
    activeSlideDOM: `
    <div class='carousel-item active'" + ">
    <div class="slide-name" style='color:white;font-size:20px'>Cluster number: #INDEX+1#</div> 
    <canvas id='canvas#INDEX#'></canvas>
    </div>`,
    notActiveSlideDOM: `
    <div class='carousel-item'" + ">
            <div class="slide-name" style='color:white;font-size:20px'>Cluster number: #INDEX+1#</div>
            <canvas id='canvas#INDEX#'></canvas>
    </div>`,
    activeItemIndicator: `<li class='item#INDEX+1# active'" + "></li>`,
    notActiveItemIndicator: `<li class='item#INDEX+1#'" + "></li>`,

}

export default (function () { carousel.activateClickEventListeners() }())
