import { poseLandmarker } from './pose_landmarker'
import { drawLandmarker } from './draw_landmarks';
import { DrawingUtils } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

const videoDetector = await poseLandmarker();
const ctx = canvas.getContext('2d');
const video = document.getElementById('video_input')

export const videoAnalysis = async (video, canvas) => {
    canvas.width = video.videoWidth
    canvas.height = video.videoHeight
  
    video.addEventListener("play", () => {
        processVideo();
    });
}

const drawUtils = new DrawingUtils(ctx);

async function processVideo() {
  if (video.paused || video.ended) return;
     ctx.clearRect(0, 0, canvas.width, canvas.height);
    const nowInMs = performance.now();

    const results = videoDetector.detectForVideo(video, nowInMs);

    if (results.landmarks.length > 0) {
        drawLandmarker(results.landmarks[0], drawUtils)
    } 

  requestAnimationFrame(processVideo);
}