import Foundation
import Supabase

class SupabaseManager {
  
  static let shared = SupabaseManager()
  
  let client: SupabaseClient
  
  private init() {
    let supabaseURL = URL(string: "https://lycdhqxqwhergrpyvftv.supabase.co")!
    let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5Y2RocXhxd2hlcmdycHl2ZnR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2NjQ0NTIsImV4cCI6MjA3NDI0MDQ1Mn0.dqjYShCS7raZZdL9f1GE0cy0dxpUVCGyfA2rhgBc0E8"
    
    self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
  }
}

