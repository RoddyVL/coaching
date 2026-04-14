import { PoseLandmarker } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

export const drawLandmarker = (landmarks, drawUtils) => {
    drawUtils.drawLandmarks(landmarks);
    drawUtils.drawConnectors(landmarks, PoseLandmarker.POSE_CONNECTIONS)
}