//
//  AppUser.swift
//  
//
//  Created by Invitado on 16/12/25.
//

import Foundation

struct AppUser: Codable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var role: UserRole
}
