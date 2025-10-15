# Utilise une image Node officielle en version LTS
FROM node:18

# Crée un dossier de travail dans le conteneur
WORKDIR /app

# Copie les fichiers de dépendances
COPY package*.json ./

# Installe les dépendances
RUN npm install

# Copie le reste des fichiers du projet
COPY . .

# Expose le port sur lequel l'app tourne (à adapter)
EXPOSE 3000

# Commande pour lancer l'application
CMD ["npm", "start"]
