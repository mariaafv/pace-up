import Foundation

protocol RunWorkerProtocol: AnyObject {
  func save(run: Run) async throws
}

class RunWorker: RunWorkerProtocol {
  func save(run: Run) async throws {
    do {
      try await SupabaseManager.shared.client
        .from("runs")
        .insert(run)
        .execute()
      
      print("✅ Corrida salva com sucesso no Supabase!")
    } catch {
      print("❌ Erro ao salvar corrida no Supabase: \(error)")
      throw error
    }
  }
}
