//
//  AppUser.swift
//  
//
//  Created by Invitado on 16/12/25.
//

import Foundation

struct AppUser: Codable {
    let id: UUID
    let name: String
    let email: String
    let password: String
    let role: UserRole
}
