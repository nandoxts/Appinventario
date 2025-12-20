import Foundation

class EmailService {
    static let shared = EmailService()
    
    private let sendGridApiKey: String
    private let sendGridURL = "https://api.sendgrid.com/v3/mail/send"
    
    private init() {
        // Obtén tu API key desde: https://app.sendgrid.com/settings/api_keys
        // Guárdala en Constants o en un archivo de configuración seguro
        self.sendGridApiKey = Constants.sendGridApiKey
    }
    
    // MARK: - Email Models
    struct EmailRequest: Codable {
        let personalizations: [Personalization]
        let from: From
        let subject: String
        let content: [Content]
        
        enum CodingKeys: String, CodingKey {
            case personalizations, from, subject, content
        }
    }
    
    struct Personalization: Codable {
        let to: [Recipient]
        
        enum CodingKeys: String, CodingKey {
            case to
        }
    }
    
    struct Recipient: Codable {
        let email: String
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case email, name
        }
    }
    
    struct From: Codable {
        let email: String
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case email, name
        }
    }
    
    struct Content: Codable {
        let type: String
        let value: String
        
        enum CodingKeys: String, CodingKey {
            case type, value
        }
    }
    
    // MARK: - Send Email Methods
    
    /// Envía un email simple
    func sendEmail(
        to recipient: String,
        recipientName: String = "",
        subject: String,
        htmlContent: String,
        completion: @escaping (Result<Bool, EmailError>) -> Void
    ) {
        let personalizations = Personalization(
            to: [Recipient(email: recipient, name: recipientName.isEmpty ? nil : recipientName)]
        )
        
        let from = From(
            email: Constants.sendGridFromEmail,
            name: Constants.sendGridFromName
        )
        
        let content = Content(type: "text/html", value: htmlContent)
        
        let emailRequest = EmailRequest(
            personalizations: [personalizations],
            from: from,
            subject: subject,
            content: [content]
        )
        
        sendRequest(emailRequest, completion: completion)
    }
    
    /// Envía un email a múltiples destinatarios
    func sendEmailToMultiple(
        to recipients: [(email: String, name: String)],
        subject: String,
        htmlContent: String,
        completion: @escaping (Result<Bool, EmailError>) -> Void
    ) {
        let personalizations = recipients.map { recipient in
            Personalization(
                to: [Recipient(email: recipient.email, name: recipient.name.isEmpty ? nil : recipient.name)]
            )
        }
        
        let from = From(
            email: Constants.sendGridFromEmail,
            name: Constants.sendGridFromName
        )
        
        let content = Content(type: "text/html", value: htmlContent)
        
        let emailRequest = EmailRequest(
            personalizations: personalizations,
            from: from,
            subject: subject,
            content: [content]
        )
        
        sendRequest(emailRequest, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func sendRequest(
        _ emailRequest: EmailRequest,
        completion: @escaping (Result<Bool, EmailError>) -> Void
    ) {
        guard let url = URL(string: sendGridURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(sendGridApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(emailRequest)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                if httpResponse.statusCode == 202 {
                    completion(.success(true))
                } else {
                    let errorMsg = "SendGrid error: \(httpResponse.statusCode)"
                    completion(.failure(.serverError(errorMsg)))
                }
            }
        }.resume()
    }
}

// MARK: - Error Types
enum EmailError: Error, LocalizedError {
    case invalidURL
    case encodingError(Error)
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .encodingError(let error):
            return "Error al codificar: \(error.localizedDescription)"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .serverError(let msg):
            return msg
        }
    }
}
