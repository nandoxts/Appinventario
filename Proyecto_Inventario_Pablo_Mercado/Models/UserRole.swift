//
//  UserRole.swift
//  
//
//  Created by Invitado on 16/12/25.
//

import Foundation

enum UserRole: String, Codable, CaseIterable {
    case admin
    case worker
    
    var displayName: String {
        self == .admin ? "Administrador" : "Trabajador"
    }
}
