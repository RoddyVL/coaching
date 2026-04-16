import { poseLandmarker } from './pose_landmarker'
import { drawLandmarker } from './draw_landmarks';
import { DrawingUtils } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

const videoDetector = await poseLandmarker();
const ctx = canvas.getContext('2d');
const video = document.getElementById('video_input')
let sequence = [];
let lastProcessedTime = 0;
const interval = 200;

export const videoAnalysis = async (video, canvas) => {
    canvas.width = video.videoWidth
    canvas.height = video.videoHeight
    
    video.play()

    const result = await processVideo();
    return result
}

const drawUtils = new DrawingUtils(ctx);

function processVideo() {
  return new Promise((resolve) => {

    function loop() {
      if (video.ended) {
        resolve(sequence);
        return;
      }

      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const timestamp = video.currentTime * 1000;
      const results = videoDetector.detectForVideo(video, timestamp);

      if (results.landmarks.length > 0) {
        const landmarks = results.landmarks[0];

        drawLandmarker(landmarks, drawUtils);

        if (timestamp - lastProcessedTime > interval) {
            lastProcessedTime = timestamp;

            sequence.push({
                timestamp,
                landmarks
            });
        }
      }

      requestAnimationFrame(loop);
    }

    loop();
  });
}