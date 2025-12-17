//
//  Extensions.swift
//  Proyecto_Inventory
//
//  Created by DESIGN on 13/12/25.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Role-based access
    func isAdmin() -> Bool {
        return UserManager.shared.currentRole() == .admin
    }
    
    func isWorker() -> Bool {
        return UserManager.shared.currentRole() == .worker
    }
    
    func getCurrentRole() -> UserRole {
        return UserManager.shared.currentRole()
    }
    
    func requireAdmin() -> Bool {
        if !isAdmin() {
            showAlert("Esta accion solo puede ser realizada por administradores")
            return false
        }
        return true
    }
}

