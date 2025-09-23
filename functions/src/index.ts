import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { defineSecret } from "firebase-functions/params";
import { GoogleGenerativeAI } from "@google/generative-ai";

admin.initializeApp();
const firestore = admin.firestore();

// Segredo armazenado no Firebase
const GEMINI_API_KEY = defineSecret("GEMINI_KEY");

export const generateFullWorkoutPlan = onDocumentCreated(
  {
    document: "users/{userId}",
    region: "us-central1",
    timeoutSeconds: 120,
    memory: "512MiB",
    secrets: [GEMINI_API_KEY],
  },
  async (event) => {
    const snap = event.data;
    if (!snap) {
      console.log("Nenhum dado associado ao evento.");
      return;
    }

    const userId = event.params.userId;
    const userData = snap.data();

    if (
      !userData ||
      !userData.experience ||
      !userData.goal ||
      !Array.isArray(userData.runDays)
    ) {
      console.error("Dados do usuário incompletos para:", userId);
      return;
    }

    const prompt = `
      Você é um coach de corrida especialista em IA chamado PaceUp.
      Novo usuário:
      - Experiência: ${userData.experience}
      - Objetivo: ${userData.goal}
      - Peso: ${userData.weight || "não informado"} kg
      - Altura: ${userData.height || "não informado"} cm
      - Dias para correr: ${userData.runDays.join(", ")}

      Gere um plano da primeira semana em JSON:
      {
        "week1": [
          { "day": "Nome do Dia", "type": "Tipo de Treino", "duration_minutes": 0, "description": "Descrição" }
        ]
      }
    `;

    try {
      const apiKey = await GEMINI_API_KEY.value();
      const genAI = new GoogleGenerativeAI(apiKey);

      // Usando o modelo moderno
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-latest" });

      const result = await model.generateContent(prompt);
      const aiResponse = result.response.text();

      if (!aiResponse) {
        throw new Error("A IA não retornou conteúdo.");
      }

      let workoutPlanJson;
      try {
        const cleanedText = aiResponse.replace(/```json/g, "").replace(/```/g, "").trim();
        workoutPlanJson = JSON.parse(cleanedText);
      } catch (e) {
        console.error("Erro ao parsear JSON:", e);
        await firestore.collection("users").doc(userId).set(
          {
            planGenerationError: "Falha ao processar resposta da IA.",
            rawAIResponse: aiResponse,
          },
          { merge: true }
        );
        return;
      }

      await firestore.collection("users").doc(userId).set(
        {
          workoutPlan: workoutPlanJson,
          planGeneratedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );

      console.log(`✅ Plano de treino gerado para usuário ${userId}`);
    } catch (error) {
      console.error("❌ Erro ao chamar a IA ou salvar no Firestore:", error);
      await firestore.collection("users").doc(userId).set(
        { planGenerationError: "Falha na comunicação com a IA." },
        { merge: true }
      );
    }
  }
);
