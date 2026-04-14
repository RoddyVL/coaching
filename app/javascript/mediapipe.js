import { imageAnalysis } from './mediapipe/image_analysis/image_analysis.js'
import { videoAnalysis } from './mediapipe/video_analysis/video_analysis.js'
 
const image = document.getElementById('image_input')
const video = document.getElementById('video_input')

const canvas = document.getElementById("canvas");
const fileUploader = document.querySelector('.file-uploader')

fileUploader.addEventListener('change', function () { 
  const file = this.files[0];
  if (!file) return

  const url = URL.createObjectURL(file)

  if (file.type.startsWith('image/')) {
    image.src = url
    image.style.display = 'block'
  }
    else if (file.type.startsWith('video/')) {
    video.src = url
    video.style.display = 'block'
  }
})

image.addEventListener('load', function() { imageAnalysis(image, canvas) })
video.addEventListener('loadedmetadata', function() { videoAnalysis(video, canvas) })