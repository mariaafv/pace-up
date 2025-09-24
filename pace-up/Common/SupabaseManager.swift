import Foundation
import Supabase

class SupabaseManager {
  static let shared = SupabaseManager()
  let client: SupabaseClient
  
  private init() {
    guard let url = Bundle.main.url(forResource: "Supabase-Keys", withExtension: "plist") else {
      fatalError("ERRO: Arquivo Supabase-Keys.plist não encontrado. Verifique se ele foi adicionado ao projeto.")
    }
    
    guard let data = try? Data(contentsOf: url),
          let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
      fatalError("ERRO: Não foi possível ler o arquivo Supabase-Keys.plist.")
    }
    
    guard let supabaseURLString = dict["SUPABASE_URL"] as? String,
          let supabaseKey = dict["SUPABASE_KEY"] as? String else {
      fatalError("ERRO: SUPABASE_URL ou SUPABASE_KEY não encontradas no arquivo Supabase-Keys.plist.")
    }
    
    guard let supabaseURL = URL(string: supabaseURLString) else {
      fatalError("ERRO: A SUPABASE_URL no arquivo Supabase-Keys.plist é inválida.")
    }
    
    self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    
    print("✅ SupabaseManager inicializado com sucesso a partir do .plist!")
  }
}
