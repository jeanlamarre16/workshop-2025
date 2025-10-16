import React from 'react'
import { GoogleLogin, GoogleOAuthProvider } from '@react-oauth/google'
import jwt_decode from 'jwt-decode'
import { useAuth } from '../context/AuthContext'
import './Login.css'
export default function Login(){
 const { login } = useAuth()
 const handleSuccess = (res)=> login(jwt_decode(res.credential))
 return (<div className='login-container'><h1>🪄 Bienvenue à la messagerie magique Hedwige</h1><p>Connecte-toi avec ton compte étudiant pour envoyer des hiboux 🦉</p><GoogleOAuthProvider clientId='VOTRE_CLIENT_ID_GOOGLE'><GoogleLogin onSuccess={handleSuccess} onError={()=>alert('Erreur OAuth2')} /></GoogleOAuthProvider></div>)
}