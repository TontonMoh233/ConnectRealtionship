import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const notifyEntrepreneur = functions.firestore
  .document("investissements/{investmentId}")
  .onCreate(async (snap) => {
    const investmentData = snap.data();
    const entrepreneurId = investmentData?.entrepreneurId; // Utilisation de l'opérateur de coalescence

    if (!entrepreneurId) {
      console.error("Entrepreneur ID manquant dans les données d'investissement");
      return; // Sortir de la fonction si l'ID de l'entrepreneur est manquant
    }

    const entrepreneurDoc = await admin.firestore()
      .collection("utilisateurs")
      .doc(entrepreneurId)
      .get();

    // Vérifiez si le document existe
    if (!entrepreneurDoc.exists) {
      console.log("Document utilisateur non trouvé pour", entrepreneurId);
      return; // Sortir de la fonction si l'utilisateur n'est pas trouvé
    }

    const entrepreneurData = entrepreneurDoc.data();

    // Vérifiez si entrepreneurData est défini
    if (!entrepreneurData) {
      console.log("Aucune donnée utilisateur trouvée pour", entrepreneurId);
      return; // Sortir de la fonction si les données ne sont pas disponibles
    }

    const token = entrepreneurData.token; // Vérifiez ce champ

    if (token) {
      const message = {
        notification: {
          title: "Nouvel Investissement",
          body: "Félicitations ! Vous avez reçu un nouvel investissement.",
        },
        token: token,
      };

      try {
        await admin.messaging().send(message);
        console.log("Notification envoyée avec succès à", entrepreneurId);
      } catch (error) {
        console.error("Erreur lors de l'envoi de la notification:", error);
      }
    } else {
      console.log("Aucun token trouvé pour", entrepreneurId);
    }
  });
