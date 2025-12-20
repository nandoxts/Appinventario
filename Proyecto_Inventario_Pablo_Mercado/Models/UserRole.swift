//
//  UserRole.swift
//  
//
//  Created by Invitado on 16/12/25.
//

import Foundation

enum UserError: Error, LocalizedError {
    case invalidName
    case invalidEmail
    case passwordTooShort
    case emailAlreadyExists
    case invalidCredentials
    case unknown(String)
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Nombre invalido"
        case .invalidEmail:
            return "Correo invalido"
        case .passwordTooShort:
            return "Contrasena muy corta"
        case .emailAlreadyExists:
            return "El correo ya existe"
        case .invalidCredentials:
            return "Credenciales incorrectas"
        case .unknown(let msg):
            return msg
        case .userNotFound:
            return "Usuario no encontrado"
        }
    }
}

enum UserRole: String, Codable, CaseIterable {
    case admin
    case worker
    
    var displayName: String {
        self == .admin ? "Administrador" : "Trabajador"
    }
}
