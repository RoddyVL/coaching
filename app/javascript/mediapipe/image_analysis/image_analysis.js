import { createPoseLandmarker } from "./pose_landmarker.js";
import { draw_landmarks } from "./draw_landmarks.js"

export const imageAnalysis = async (image, canvas) => {
    const ctx = canvas.getContext("2d");

    canvas.width = image.width
    canvas.height = image.height
    ctx.drawImage(image, 0, 0, canvas.width, canvas.height);

    const poseLandmarker = await createPoseLandmarker();
    const result = await poseLandmarker.detect(image);
    draw_landmarks(result.landmarks[0], ctx);
    
    return result.landmarks[0]
}