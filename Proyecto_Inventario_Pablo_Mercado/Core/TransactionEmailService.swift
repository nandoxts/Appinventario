import Foundation

/// Servicio para enviar emails SOLO de transacciones importantes
class TransactionEmailService {
    
    static let shared = TransactionEmailService()
    
    // MARK: - Umbrales para transacciones importantes
    private let largeQuantityThreshold = 50  // Cantidad grande de salida
    private let criticalStockThreshold = 5   // Stock crítico para alerta
    
    private init() {}
    
    // MARK: - Métodos principales
    
    /// Procesa una transacción y envía email si es importante
    /// - Parameters:
    ///   - transaction: La transacción realizada
    ///   - product: El producto asociado
    ///   - adminEmail: Email del administrador
    func processTransaction(
        _ transaction: Transaction,
        product: Product,
        adminEmail: String
    ) {
        // Determinar si es una transacción importante
        switch transaction.type {
        case .salida:
            // Alerta si la salida es grande
            if transaction.quantity >= largeQuantityThreshold {
                sendLargeSaleAlert(transaction: transaction, product: product, adminEmail: adminEmail)
            }
            
            // Alerta si el stock quedó crítico
            let newStock = product.stock - transaction.quantity
            if newStock >= 0 && newStock <= criticalStockThreshold {
                sendCriticalStockAlert(
                    productName: product.name,
                    newStock: newStock,
                    adminEmail: adminEmail
                )
            }
            
        case .entrada:
            // Alerta si la entrada restaura stock crítico (compra importante)
            if transaction.quantity >= largeQuantityThreshold {
                sendLargeRestockAlert(transaction: transaction, product: product, adminEmail: adminEmail)
            }
        }
    }
    
    // MARK: - Emails específicos de transacciones
    
    private func sendLargeSaleAlert(
        transaction: Transaction,
        product: Product,
        adminEmail: String
    ) {
        let htmlContent = """
        <html>
            <body style="font-family: Arial, sans-serif; color: #333;">
                <h2 style="color: #FF3B30;">VENTA GRANDE REGISTRADA</h2>
                <p>Se ha registrado una salida importante en tu inventario:</p>
                
                <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Producto:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(transaction.productName)</td>
                    </tr>
                    <tr>
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Cantidad Salida:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd; color: #FF3B30;"><strong>\(transaction.quantity) unidades</strong></td>
                    </tr>
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Anterior:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(product.stock) unidades</td>
                    </tr>
                    <tr>
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Actual:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(product.stock - transaction.quantity) unidades</td>
                    </tr>
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Fecha:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(transaction.date.formatted(date: .abbreviated, time: .shortened))</td>
                    </tr>
                </table>
                
                <p style="margin-top: 20px; color: #666;">
                    Accede a tu aplicación para más detalles.
                </p>
            </body>
        </html>
        """
        
        EmailService.shared.sendEmail(
            to: adminEmail,
            subject: "Venta Grande: \(transaction.productName) - \(transaction.quantity) unidades",
            htmlContent: htmlContent
        ) { result in
            if case .success = result {
                print("[Email enviado] Alerta de venta grande enviada")
            }
        }
    }
    
    private func sendCriticalStockAlert(
        productName: String,
        newStock: Int,
        adminEmail: String
    ) {
        let htmlContent = """
        <html>
            <body style="font-family: Arial, sans-serif; color: #333;">
                <h2 style="color: #FF9500;">STOCK CRÍTICO</h2>
                <p>Un producto ha alcanzado niveles críticos de inventario:</p>
                
                <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Producto:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(productName)</td>
                    </tr>
                    <tr>
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Actual:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd; color: #FF9500;"><strong>\(newStock) unidades</strong></td>
                    </tr>
                </table>
                
                <p style="color: #FF3B30; font-weight: bold;">Es recomendable realizar un pedido urgente</p>
                
                <p style="margin-top: 20px; color: #666;">
                    Abre tu aplicación para realizar un nuevo pedido o ver más opciones.
                </p>
            </body>
        </html>
        """
        
        EmailService.shared.sendEmail(
            to: adminEmail,
            subject: "Stock Crítico: \(productName) - Solo \(newStock) unidades",
            htmlContent: htmlContent
        ) { result in
            if case .success = result {
                print("[Email enviado] Alerta de stock crítico enviada")
            }
        }
    }
    
    private func sendLargeRestockAlert(
        transaction: Transaction,
        product: Product,
        adminEmail: String
    ) {
        let htmlContent = """
        <html>
            <body style="font-family: Arial, sans-serif; color: #333;">
                <h2 style="color: #34C759;">REABASTECIMIENTO REGISTRADO</h2>
                <p>Se ha registrado una entrada importante de inventario:</p>
                
                <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Producto:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(transaction.productName)</td>
                    </tr>
                    <tr>
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Cantidad Entrada:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd; color: #34C759;"><strong>\(transaction.quantity) unidades</strong></td>
                    </tr>
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Anterior:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(product.stock) unidades</td>
                    </tr>
                    <tr>
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Stock Nuevo:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd; color: #34C759;"><strong>\(product.stock + transaction.quantity) unidades</strong></td>
                    </tr>
                    <tr style="background-color: #f5f5f5;">
                        <td style="padding: 10px; border: 1px solid #ddd;"><strong>Fecha:</strong></td>
                        <td style="padding: 10px; border: 1px solid #ddd;">\(transaction.date.formatted(date: .abbreviated, time: .shortened))</td>
                    </tr>
                </table>
                
                <p style="margin-top: 20px; color: #666;">
                    Accede a tu aplicación para ver el reporte completo.
                </p>
            </body>
        </html>
        """
        
        EmailService.shared.sendEmail(
            to: adminEmail,
            subject: "Reabastecimiento: \(transaction.productName) - \(transaction.quantity) unidades",
            htmlContent: htmlContent
        ) { result in
            if case .success = result {
                print("[Email enviado] Alerta de reabastecimiento enviada")
            }
        }
    }
}
