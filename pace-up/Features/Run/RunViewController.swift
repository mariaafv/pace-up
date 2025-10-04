import UIKit
import CoreLocation

class RunViewController: BaseViewController {
  private var baseView: RunView { self.view as! RunView }
  private var viewModel: RunViewModelProtocol?
  private var router: Router? { (self.view.window?.windowScene?.delegate as? SceneDelegate)?.router }
  
  init(viewModel: RunViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = RunView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Corrida"
    
    setupTargets()
    setupBindings()
    
    print("✅ DEBUG: ViewController está chamando a permissão...")
    viewModel?.requestLocationPermission()
  }
  
  private func setupTargets() {
    baseView.primaryActionButton.addTarget(self, action: #selector(primaryActionTapped), for: .touchUpInside)
    baseView.secondaryActionButton.addTarget(self, action: #selector(secondaryActionTapped), for: .touchUpInside)
  }
  
  private func setupBindings() {
    viewModel?.onRunStateChange = { [weak self] state in
      DispatchQueue.main.async {
        self?.baseView.updateUI(for: state)
      }
    }
    
    viewModel?.onMetricsUpdate = { [weak self] metrics in
      DispatchQueue.main.async {
        self?.baseView.updateMetrics(metrics: metrics)
      }
    }
    
    viewModel?.onLocationPermissionDenied = { [weak self] in
      DispatchQueue.main.async {
        self?.showLocationPermissionAlert()
      }
    }
  }
  
  @objc private func primaryActionTapped() {
    switch viewModel?.currentRunState {
    case .ready:
      viewModel?.startRun()
    case .running:
      viewModel?.pauseRun()
    case .paused:
      viewModel?.resumeRun()
    case .finished:
      break
    case .none:
      break
    }
  }
  
  @objc private func secondaryActionTapped() {
    if viewModel?.currentRunState == .running || viewModel?.currentRunState == .paused {
      Task {
        await viewModel?.finishRun()
      }
    }
  }
  
  private func showLocationPermissionAlert() {
    let alert = UIAlertController(title: "Permissão de Localização",
                                  message: "PaceUp precisa de acesso à sua localização para rastrear sua corrida. Por favor, vá em Configurações > Privacidade > Serviços de Localização e ative para o PaceUp.",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)
  }
}
