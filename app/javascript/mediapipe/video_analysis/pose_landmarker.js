import { FilesetResolver, PoseLandmarker } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

export const poseLandmarker = async () => {
    const vision = await FilesetResolver.forVisionTasks(
        "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@latest/wasm"
    );
    const poseLandmarker = await PoseLandmarker.createFromOptions(
        vision,
        {
        baseOptions: {
            modelAssetPath: "/models/pose_landmarker_lite.task"
        },
        runningMode: 'VIDEO'
        });

    return poseLandmarker
}