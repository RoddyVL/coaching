// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { imageAnalysis } from './mediapipe/image_analysis/image_analysis.js'
import { videoAnalysis } from './mediapipe/video_analysis/video_analysis.js'

const image = document.getElementById('image_input')
const video = document.getElementById('video_input')

const canvas = document.getElementById("canvas");
const fileUploader = document.querySelector('.file-uploader')

const button = document.getElementById('btn-analysis')
let fileType = null;

fileUploader.addEventListener('change', function () {
  console.log('file uploaded')
  const file = this.files[0];
  if (!file) return

  button.style.display = '' 
  fileUploader.style.display = 'none'

  const url = URL.createObjectURL(file)

  if (file.type.startsWith('image/')) {
    fileType = 'image'
    image.src = url
    image.style.display = 'block'
  }
    else if (file.type.startsWith('video/')) {
    fileType = 'video'
    video.src = url
    video.style.display = 'block'
  }
})

button.addEventListener("click", ()=> {
  if (fileType === 'image') {
    imageAnalysis(image, canvas)
  } 
  else if (fileType === 'video') {
    videoAnalysis(video, canvas)
  }
});