import Foundation

/// Clase con ejemplos de cómo enviar diferentes tipos de emails
class EmailTemplates {
    
    // MARK: - Email de Bienvenida
    static func welcomeEmail(userName: String, userEmail: String) {
        let htmlContent = """
<html>
<body style="font-family: Arial, sans-serif; color: #333;">
<h2>¡Bienvenido a tu Aplicación de Inventario!</h2>
<p>Hola <strong>\(userName)</strong>,</p>
<p>Gracias por crear tu cuenta. Ya puedes comenzar a gestionar tu inventario.</p>
<p>
<a href="https://tuapp.com" style="background-color: #007AFF; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
Ir a la aplicación
</a>
</p>
<p>Si tienes preguntas, contáctanos en support@tuapp.com</p>
</body>
</html>
"""
        
        EmailService.shared.sendEmail(
            to: userEmail,
            recipientName: userName,
            subject: "¡Bienvenido!",
            htmlContent: htmlContent
        ) { result in
            switch result {
            case .success:
                print("Email de bienvenida enviado a \(userEmail)")
            case .failure(let error):
                print("Error al enviar email: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Email de Cambio de Contraseña
    static func passwordResetEmail(userName: String, userEmail: String, resetLink: String) {
        let htmlContent = """
<html>
<body style="font-family: Arial, sans-serif; color: #333;">
<h2>Recupera tu contraseña</h2>
<p>Hola <strong>\(userName)</strong>,</p>
<p>Recibimos una solicitud para recuperar tu contraseña. Haz clic en el enlace de abajo para establecer una nueva contraseña:</p>
<p>
<a href="\(resetLink)" style="background-color: #007AFF; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block;">
Recuperar contraseña
</a>
</p>
<p style="font-size: 12px; color: #666;">Este enlace expira en 24 horas.</p>
<p>Si no solicitaste esto, ignora este email.</p>
</body>
</html>
"""
        
        EmailService.shared.sendEmail(
            to: userEmail,
            recipientName: userName,
            subject: "Recuperar contraseña",
            htmlContent: htmlContent
        ) { result in
            switch result {
            case .success:
                print("Email de recuperación enviado")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Email de Reporte de Inventario Bajo
    static func lowStockAlert(productName: String, currentStock: Int, adminEmail: String) {
        let htmlContent = """
<html>
<body style="font-family: Arial, sans-serif; color: #333;">
<h2 style="color: #FF3B30;">Alerta: Stock bajo</h2>
<p>El siguiente producto tiene stock bajo:</p>
<table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
<tr style="background-color: #f5f5f5;">
<td style="padding: 10px; border: 1px solid #ddd;"><strong>Producto:</strong></td>
<td style="padding: 10px; border: 1px solid #ddd;">\(productName)</td>
</tr>
<tr>
<td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Actual:</strong></td>
<td style="padding: 10px; border: 1px solid #ddd;">\(currentStock) unidades</td>
</tr>
</table>
<p>Por favor, revisa tu inventario y realiza un pedido si es necesario.</p>
</body>
</html>
"""
        
        EmailService.shared.sendEmail(
            to: adminEmail,
            subject: "Alerta: Stock bajo en \(productName)",
            htmlContent: htmlContent
        ) { result in
            switch result {
            case .success:
                print("Alerta de stock bajo enviada")
            case .failure(let error):
                print("Error al enviar alerta: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Email de Reporte de Transacción
    static func transactionReportEmail(
        recipientEmail: String,
        recipientName: String,
        reportData: String,
        reportDate: String
    ) {
        let htmlContent = """
<html>
<body style="font-family: Arial, sans-serif; color: #333;">
<h2>Reporte de Transacciones</h2>
<p>Hola <strong>\(recipientName)</strong>,</p>
<p>Adjunto encontrarás tu reporte de transacciones generado el <strong>\(reportDate)</strong>.</p>
<h3>Resumen:</h3>
<pre style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto;">
\(reportData)
</pre>
<p>Si necesitas más detalles, puedes acceder a la aplicación para ver el reporte completo.</p>
</body>
</html>
"""
        
        EmailService.shared.sendEmail(
            to: recipientEmail,
            recipientName: recipientName,
            subject: "Reporte de Transacciones - \(reportDate)",
            htmlContent: htmlContent
        ) { result in
            switch result {
            case .success:
                print("Reporte de transacciones enviado")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
