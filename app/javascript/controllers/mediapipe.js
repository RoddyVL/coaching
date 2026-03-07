const imgElement = document.getElementById('input_image');
const canvasElement = document.getElementById('output_canvas');
const canvasCtx = canvasElement.getContext('2d');
const btn = document.getElementById('analyse_btn');
const output = document.getElementById('data_output');

// 1. Initialisation de MediaPipe Pose
const pose = new Pose({
    locateFile: (file) => `https://cdn.jsdelivr.net/npm/@mediapipe/pose/${file}`
});

pose.setOptions({
    modelComplexity: 2, // Plus précis pour les images fixes
    upperBodyOnly: false,
    smoothLandmarks: true,
    minDetectionConfidence: 0.5,
    minTrackingConfidence: 0.5
});

let stanceInput = null

// 2. Gestion du résultat
pose.onResults((results) => {
    if (!results.poseLandmarks) {
      console.log(results)

        output.innerText = "Aucun humain détecté.";
        return;
    }

  // Ajuster le canvas à la taille de l'image
  canvasElement.width = imgElement.clientWidth;
  canvasElement.height = imgElement.clientHeight;

  // Dessiner les repères
  canvasCtx.save();
  canvasCtx.clearRect(0, 0, canvasElement.width, canvasElement.height);

  // On dessine uniquement les points et connexions
  drawConnectors(canvasCtx, results.poseLandmarks, POSE_CONNECTIONS, {color: '#00FF00', lineWidth: 4});
  drawLandmarks(canvasCtx, results.poseLandmarks, {color: '#FF0000', lineWidth: 2});

  canvasCtx.restore();

  console.log(results)
    // Envoyer au backend
  fetch("/pose_landmarks", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
    },
    body: JSON.stringify({ landmarks: results.poseLandmarks })
  })
  .then(res => res.json())
  .then(data => console.log("Rails response:", data))
  .catch(err => console.error("Erreur fetch:", err));
});

// 3. Déclencheur au clic
btn.addEventListener('click', async () => {
    output.innerText = "Analyse en cours...";
    await pose.send({image: imgElement});
});
