// src/api.js
// Simulation d'un backend local avec stockage persistant

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

function initStorage() {
  if (!localStorage.getItem("receivedMessages")) {
    const initialReceived = [
      {
        id: 1,
        from: "hermione@poudlard.edu",
        subject: "Révision du sortilège",
        snippet: "N’oublie pas notre séance d’étude ce soir à la bibliothèque !",
        body: "N’oublie pas notre séance d’étude ce soir à la bibliothèque, Harry ! 📚✨",
        date: new Date().toLocaleString(),
      },
      {
        id: 2,
        from: "ron@poudlard.edu",
        subject: "Essaye ma nouvelle baguette",
        snippet: "Elle fait un drôle de bruit quand je l’agite...",
        body: "Elle fait un drôle de bruit quand je l’agite, tu devrais venir voir ça 😂",
        date: new Date().toLocaleString(),
      },
    ]
    localStorage.setItem("receivedMessages", JSON.stringify(initialReceived))
  }

  if (!localStorage.getItem("sentMessages")) {
    localStorage.setItem("sentMessages", JSON.stringify([]))
  }
}

export async function fetchProfile() {
  await delay(200)
  return { email: "harry.potter@poudlard.edu" }
}

export async function fetchMessages(type = "received") {
  await delay(200)
  initStorage()
  const key = type === "sent" ? "sentMessages" : "receivedMessages"
  const messages = JSON.parse(localStorage.getItem(key))
  return { messages }
}

export async function fetchMessage(id, type = "received") {
  await delay(150)
  const key = type === "sent" ? "sentMessages" : "receivedMessages"
  const messages = JSON.parse(localStorage.getItem(key))
  return messages.find((m) => m.id === id)
}

export async function sendMail(mail) {
  await delay(300)
  initStorage()

  const sentMessages = JSON.parse(localStorage.getItem("sentMessages"))
  const receivedMessages = JSON.parse(localStorage.getItem("receivedMessages"))

  const newMessage = {
    id: Date.now(),
    from: "harry.potter@poudlard.edu",
    to: mail.to || "inconnu@poudlard.edu",
    subject: mail.subject || "(Sans sujet)",
    snippet: mail.body.slice(0, 60),
    body: mail.body,
    date: new Date().toLocaleString(),
  }

  // ✅ Ajouter à la boîte "Envoyés"
  sentMessages.unshift(newMessage)
  localStorage.setItem("sentMessages", JSON.stringify(sentMessages))

  // ✅ Ajouter automatiquement une copie à la boîte "Reçus"
  const receivedCopy = {
    ...newMessage,
    id: Date.now() + 1, // id différent pour la boîte reçue
    from: newMessage.from,
    to: newMessage.to,
  }
  receivedMessages.unshift(receivedCopy)
  localStorage.setItem("receivedMessages", JSON.stringify(receivedMessages))

  return { success: true, message: newMessage }
}
