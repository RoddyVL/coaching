export const imageFeedback = async (result) => {
  try {
    const response = await fetch("/pose_landmarks", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ landmarks: result, stance: 'southpaw' })
  });

  const data = await response.json();
  console.log(data)
  output.textContent = data.feedback.join("\n");

  } catch (err) {
    console.error("Erreur fetch:", err);
    output.textContent = "Erreur lors de l'analyse.";
  }
}