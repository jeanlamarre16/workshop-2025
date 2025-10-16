import React, { createContext, useContext, useState, useEffect } from 'react'
const AuthContext = createContext()
export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => JSON.parse(localStorage.getItem('hedwigeUser')||'null'))
  useEffect(() => { user ? localStorage.setItem('hedwigeUser', JSON.stringify(user)) : localStorage.removeItem('hedwigeUser') }, [user])
  return <AuthContext.Provider value={{ user, login: setUser, logout: ()=>setUser(null) }}>{children}</AuthContext.Provider>
}
export const useAuth = ()=>useContext(AuthContext)