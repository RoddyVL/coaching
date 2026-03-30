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
  modelComplexity: 2,
  upperBodyOnly: false,
  smoothLandmarks: true,
  minDetectionConfidence: 0.5,
  minTrackingConfidence: 0.5
});

// 2. Gestion du résultat
pose.onResults(async (results) => {

  if (!results.poseLandmarks) {
    output.innerText = "Aucun humain détecté.";
    return;
  }

  // Ajuster le canvas
  canvasElement.width = imgElement.clientWidth;
  canvasElement.height = imgElement.clientHeight;

  canvasCtx.save();
  canvasCtx.clearRect(0, 0, canvasElement.width, canvasElement.height);

  drawConnectors(canvasCtx, results.poseLandmarks, POSE_CONNECTIONS, {
    color: '#00FF00',
    lineWidth: 4
  });

  drawLandmarks(canvasCtx, results.poseLandmarks, {
    color: '#FF0000',
    lineWidth: 2
  });

  canvasCtx.restore();

  try {
    const response = await fetch("/pose_landmarks", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ landmarks: results.poseLandmarks, stance: 'southpaw' })
    });

    const data = await response.json();

    output.textContent = data.feedback.join("\n");

  } catch (err) {
    console.error("Erreur fetch:", err);
    output.textContent = "Erreur lors de l'analyse.";
  }
});

// 3. Déclencheur au clic
btn.addEventListener('click', async () => {
  output.innerText = "Analyse en cours...";
  await pose.send({ image: imgElement });
});


const imgInp = document.getElementById("imgInp");

imgInp.addEventListener("change", (evt) => {
  const [file] = imgInp.files;
  if (file) {
    const imageUrl = URL.createObjectURL(file);
    input_image.src = imageUrl;
    console.log(imageUrl);
  }
});
