import Foundation
import Combine

/// DatabaseService: Handles connections to the Supabase Postgres database via MCP server
class DatabaseService: ObservableObject {
    // MARK: - Properties
    
    /// Shared instance for singleton access
    static let shared = DatabaseService()
    
    /// Base URL for the MCP server
    private let mcpServerBaseURL: String
    
    /// Authentication token for MCP server
    private var authToken: String?
    
    /// URL session for network requests
    private let session: URLSession
    
    /// Publisher for connection status
    @Published var connectionStatus: ConnectionStatus = .disconnected
    
    /// Error message if connection fails
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    
    private init() {
        // Initialize with MCP server URL - should be configured in a secure way
        self.mcpServerBaseURL = "https://your-mcp-server.example.com/api"
        
        // Configure URL session with timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Connection Status
    
    /// Represents the current status of the database connection
    enum ConnectionStatus {
        case connected
        case connecting
        case disconnected
        case error
    }
    
    // MARK: - Authentication
    
    /// Authenticate with the MCP server
    /// - Parameters:
    ///   - username: MCP server username
    ///   - password: MCP server password
    ///   - completion: Callback with result of authentication
    func authenticate(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        connectionStatus = .connecting
        
        // Create authentication request
        guard let url = URL(string: "\(mcpServerBaseURL)/auth") else {
            connectionStatus = .error
            errorMessage = "Invalid MCP server URL"
            completion(false, "Invalid MCP server URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create authentication payload
        let authPayload: [String: String] = [
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: authPayload)
        } catch {
            connectionStatus = .error
            errorMessage = "Failed to create authentication request: \(error.localizedDescription)"
            completion(false, errorMessage)
            return
        }
        
        // Send authentication request
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.connectionStatus = .error
                    self.errorMessage = "Authentication failed: \(error.localizedDescription)"
                    completion(false, self.errorMessage)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.connectionStatus = .error
                    self.errorMessage = "Invalid response from server"
                    completion(false, self.errorMessage)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    self.connectionStatus = .error
                    self.errorMessage = "Authentication failed with status code: \(httpResponse.statusCode)"
                    completion(false, self.errorMessage)
                    return
                }
                
                guard let data = data else {
                    self.connectionStatus = .error
                    self.errorMessage = "No data received from server"
                    completion(false, self.errorMessage)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = json["token"] as? String {
                        self.authToken = token
                        self.connectionStatus = .connected
                        
                        // In a real app, save token to Keychain
                        completion(true, nil)
                    } else {
                        self.connectionStatus = .error
                        self.errorMessage = "Invalid authentication response"
                        completion(false, self.errorMessage)
                    }
                } catch {
                    self.connectionStatus = .error
                    self.errorMessage = "Failed to parse authentication response: \(error.localizedDescription)"
                    completion(false, self.errorMessage)
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Database Operations
    
    /// Execute a query on the Supabase Postgres database
    /// - Parameters:
    ///   - query: SQL query to execute
    ///   - parameters: Query parameters
    ///   - completion: Callback with query results or error
    func executeQuery<T: Decodable>(
        query: String,
        parameters: [Any] = [],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard connectionStatus == .connected, let authToken = authToken else {
            completion(.failure(NSError(domain: "DatabaseService", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "Not authenticated with MCP server"
            ])))
            return
        }
        
        guard let url = URL(string: "\(mcpServerBaseURL)/query") else {
            completion(.failure(NSError(domain: "DatabaseService", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid MCP server URL"
            ])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        // Create query payload
        let queryPayload: [String: Any] = [
            "query": query,
            "parameters": parameters
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: queryPayload)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DatabaseService", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "Invalid response from server"
                    ])))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DatabaseService", code: httpResponse.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: "Query failed with status code: \(httpResponse.statusCode)"
                    ])))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DatabaseService", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "No data received from server"
                    ])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    /// Fetch all monthly bills from the database
    /// - Parameter completion: Callback with array of monthly bills or error
    func fetchMonthlyBills(completion: @escaping (Result<[MonthlyBill], Error>) -> Void) {
        let query = """
        SELECT 
            \(DatabaseConfig.MonthlyBillColumns.id), 
            \(DatabaseConfig.MonthlyBillColumns.name), 
            \(DatabaseConfig.MonthlyBillColumns.monthlyAmount), 
            \(DatabaseConfig.MonthlyBillColumns.pastDue), 
            \(DatabaseConfig.MonthlyBillColumns.dueDate), 
            \(DatabaseConfig.MonthlyBillColumns.status), 
            \(DatabaseConfig.MonthlyBillColumns.category), 
            \(DatabaseConfig.MonthlyBillColumns.daysPastDue)
        FROM \(DatabaseConfig.Tables.monthlyBills)
        ORDER BY \(DatabaseConfig.MonthlyBillColumns.dueDate) ASC
        """
        
        executeQuery(query: query) { (result: Result<QueryResponse<MonthlyBill>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Add a new monthly bill to the database
    /// - Parameters:
    ///   - bill: The bill to add
    ///   - completion: Callback with success or error
    func addMonthlyBill(_ bill: MonthlyBill, completion: @escaping (Result<Void, Error>) -> Void) {
        let query = """
        INSERT INTO \(DatabaseConfig.Tables.monthlyBills) (
            \(DatabaseConfig.MonthlyBillColumns.name), 
            \(DatabaseConfig.MonthlyBillColumns.monthlyAmount), 
            \(DatabaseConfig.MonthlyBillColumns.pastDue), 
            \(DatabaseConfig.MonthlyBillColumns.dueDate), 
            \(DatabaseConfig.MonthlyBillColumns.status), 
            \(DatabaseConfig.MonthlyBillColumns.category), 
            \(DatabaseConfig.MonthlyBillColumns.daysPastDue)
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        """
        
        let parameters: [Any] = [
            bill.name,
            bill.monthlyAmount,
            bill.pastDue,
            bill.dueDate,
            bill.status.rawValue,
            bill.category,
            bill.daysPastDue
        ]
        
        executeQuery(query: query, parameters: parameters) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Update an existing monthly bill in the database
    /// - Parameters:
    ///   - bill: The bill to update
    ///   - completion: Callback with success or error
    func updateMonthlyBill(_ bill: MonthlyBill, completion: @escaping (Result<Void, Error>) -> Void) {
        let query = """
        UPDATE \(DatabaseConfig.Tables.monthlyBills)
        SET 
            \(DatabaseConfig.MonthlyBillColumns.name) = $1, 
            \(DatabaseConfig.MonthlyBillColumns.monthlyAmount) = $2, 
            \(DatabaseConfig.MonthlyBillColumns.pastDue) = $3, 
            \(DatabaseConfig.MonthlyBillColumns.dueDate) = $4, 
            \(DatabaseConfig.MonthlyBillColumns.status) = $5, 
            \(DatabaseConfig.MonthlyBillColumns.category) = $6, 
            \(DatabaseConfig.MonthlyBillColumns.daysPastDue) = $7
        WHERE \(DatabaseConfig.MonthlyBillColumns.id) = $8
        """
        
        let parameters: [Any] = [
            bill.name,
            bill.monthlyAmount,
            bill.pastDue,
            bill.dueDate,
            bill.status.rawValue,
            bill.category,
            bill.daysPastDue,
            bill.id.uuidString
        ]
        
        executeQuery(query: query, parameters: parameters) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Delete a monthly bill from the database
    /// - Parameters:
    ///   - billId: The ID of the bill to delete
    ///   - completion: Callback with success or error
    func deleteMonthlyBill(billId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let query = """
        DELETE FROM \(DatabaseConfig.Tables.monthlyBills)
        WHERE \(DatabaseConfig.MonthlyBillColumns.id) = $1
        """
        
        let parameters: [Any] = [billId.uuidString]
        
        executeQuery(query: query, parameters: parameters) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Helper Structures

/// Generic response structure for database queries
struct QueryResponse<T: Decodable>: Decodable {
    let data: [T]
}

/// Empty response for operations that don't return data
struct EmptyResponse: Decodable {
    // Empty structure for operations that don't return data
} 