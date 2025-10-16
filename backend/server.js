const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

let fakeMessages = [
  { id: '1', subject: 'Bienvenue à Poudlard', from: 'minerva@poudlard.edu', snippet: 'Félicitations ! Vous avez été accepté...' },
  { id: '2', subject: 'Horaires de cours', from: 'mcgonagall@poudlard.edu', snippet: 'Voici votre emploi du temps...' }
];

app.get('/api/profile', (req, res) => {
  res.json({ email: 'harry.potter@poudlard.edu', name: 'Harry Potter' });
});

app.get('/api/messages', (req, res) => {
  res.json({ messages: fakeMessages });
});

app.get('/api/messages/:id', (req, res) => {
  const msg = fakeMessages.find(m => m.id === req.params.id);
  if (!msg) return res.status(404).json({ error: 'Not found' });
  res.json({ ...msg, body: 'Ceci est le contenu complet du message simulé.' });
});

app.post('/api/send', (req, res) => {
  const { to, subject, body } = req.body;
  if (!to || !subject || !body) return res.status(400).json({ error: 'Missing fields' });
  const newMsg = { id: String(fakeMessages.length + 1), subject, from: 'harry.potter@poudlard.edu', snippet: body.slice(0, 50) };
  fakeMessages.push(newMsg);
  res.json({ success: true, message: newMsg });
});

if (require.main === module) {
  const port = process.env.PORT || 4000;
  app.listen(port, () => console.log(`Hedwige backend (mock) listening on ${port}`));
}

module.exports = app;