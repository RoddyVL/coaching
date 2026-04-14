import { DrawingUtils, PoseLandmarker } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

export const draw_landmarks = async (landmarks, ctx) => {
    const drawingUtils = new DrawingUtils(ctx);

    drawingUtils.drawLandmarks(landmarks, {
        color: "#FF0000",
        lineWidth: 2,
        radius: 4
    });

    drawingUtils.drawConnectors(landmarks, PoseLandmarker.POSE_CONNECTIONS,   {
        color: "#00FF00",
        lineWidth: 3
    });
}