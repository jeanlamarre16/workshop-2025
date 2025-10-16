import React, { useEffect, useState } from "react";
import "./App.css";
import { fetchProfile, fetchMessages, fetchMessage, sendMail } from "./api";
import { GoogleLogin } from "@react-oauth/google";
import { jwtDecode } from "jwt-decode";

export default function App() {
  const [profile, setProfile] = useState(null);
  const [messages, setMessages] = useState([]);
  const [selected, setSelected] = useState(null);
  const [compose, setCompose] = useState({ to: "", subject: "", body: "" });
  const [boxType, setBoxType] = useState("received");
  const [sending, setSending] = useState(false);
  const [feedback, setFeedback] = useState("");

  // Chargement du profil si connecté
  useEffect(() => {
    if (profile) loadMessages("received");
  }, [profile]);

  async function loadMessages(type) {
    setBoxType(type);
    const m = await fetchMessages(type);
    setMessages(m.messages || []);
    setSelected(null);
  }

  async function openMessage(id) {
    const m = await fetchMessage(id, boxType);
    setSelected(m);
  }

  async function handleSend(e) {
    e.preventDefault();

    // Validation de l’adresse e-mail
    if (!/\S+@\S+\.\S+/.test(compose.to)) {
      setFeedback("Adresse e-mail invalide 🧙‍♂️");
      return;
    }

    setSending(true);
    await sendMail(compose);
    setSending(false);
    setCompose({ to: "", subject: "", body: "" });
    await loadMessages("sent");
    setFeedback("✉️ Message envoyé avec succès !");
    setTimeout(() => setFeedback(""), 2500);
  }

  // Interface de connexion Google
// Interface de connexion Google
if (!profile) {
  return (
    <div className="login-container">
      <h1>🪶 Hedwige Mail</h1>
      <p>Connecte-toi avec ton compte Google pour continuer</p>

      <div className="google-login-button">
        <GoogleLogin
          onSuccess={(credentialResponse) => {
            const decoded = jwtDecode(credentialResponse.credential);
            setProfile({
              name: decoded.name,
              email: decoded.email,
              picture: decoded.picture,
            });
          }}
          onError={() => {
            console.log("Erreur de connexion Google");
          }}
        />
      </div>
    </div>
  );
}

  // Interface principale de la messagerie
  return (
    <div className="container">
      <h1>Hedwige — Boîte Magique 🦉</h1>

      <div className="profile">
        <img src={profile.picture} alt="profil" className="avatar" />
        {profile.name} ({profile.email})
        <button onClick={() => setProfile(null)}>Se déconnecter</button>
      </div>

      <div className="tabs">
        <button
          onClick={() => loadMessages("received")}
          className={boxType === "received" ? "active" : ""}
        >
          📥 Reçus
        </button>
        <button
          onClick={() => loadMessages("sent")}
          className={boxType === "sent" ? "active" : ""}
        >
          ✉️ Envoyés
        </button>
      </div>

      <div className="layout">
        <aside className="sidebar">
          <h3>{boxType === "received" ? "Messages reçus" : "Messages envoyés"}</h3>
          <ul>
            {messages.map((m) => (
              <li key={m.id} onClick={() => openMessage(m.id)} className="msg-item">
                <strong>{m.subject}</strong>
                <div className="snippet">{m.snippet}</div>
                <small>{m.date}</small>
              </li>
            ))}
          </ul>
        </aside>

        <main className="content">
          {selected ? (
            <div>
              <h2>{selected.subject}</h2>
              <p>
                <em>
                  {boxType === "sent" ? `À: ${selected.to}` : `De: ${selected.from}`}
                </em>
              </p>
              <div>{selected.body}</div>
            </div>
          ) : (
            <div>Sélectionne un message pour le lire.</div>
          )}

          <form onSubmit={handleSend} className="compose">
            <h3>Composer un message</h3>
            <input
              placeholder="À"
              value={compose.to}
              onChange={(e) => setCompose({ ...compose, to: e.target.value })}
            />
            <input
              placeholder="Objet"
              value={compose.subject}
              onChange={(e) => setCompose({ ...compose, subject: e.target.value })}
            />
            <textarea
              placeholder="Corps du message"
              value={compose.body}
              onChange={(e) => setCompose({ ...compose, body: e.target.value })}
            />
            <button type="submit" disabled={sending}>
              {sending ? "✍️ Hedwige écrit..." : "Envoyer"}
            </button>
            {feedback && <div className="feedback">{feedback}</div>}
          </form>
        </main>
      </div>
    </div>
  );
}
