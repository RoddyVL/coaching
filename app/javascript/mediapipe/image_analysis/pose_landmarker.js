import { FilesetResolver, PoseLandmarker } from "https://cdn.skypack.dev/@mediapipe/tasks-vision@0.10.0";

export const createPoseLandmarker = async () => {
    const vision = await FilesetResolver.forVisionTasks(
        "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.0/wasm"
    );

    const poseLandmarker = await PoseLandmarker.createFromOptions(
        vision,
        {
        baseOptions: {
            modelAssetPath: "/models/pose_landmarker_lite.task"
        },
        runningMode: 'IMAGE'
    });

    return poseLandmarker;
}