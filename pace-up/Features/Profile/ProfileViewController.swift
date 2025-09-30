//
//  ProfileViewController.swift
//  pace-up
//
//  Created by Maria Aida Vitoria on 26/09/25.
//


import UIKit

class ProfileViewController: BaseViewController {
    
    private var baseView: ProfileView!
    private var viewModel: ProfileViewModelProtocol?
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        baseView = ProfileView()
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBindings()
        setupTargets()
        
        viewModel?.fetchProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Atualizar perfil quando a tela aparecer (útil se voltar da tela de edição)
        viewModel?.refreshProfile()
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        title = "Perfil"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Adicionar botão de configurações se necessário
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupBindings() {
        viewModel?.onProfileStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateProfileView(for: state)
            }
        }
    }
    
    private func setupTargets() {
        baseView.editButton.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
      baseView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

    }
  
  @objc private func logoutTapped() {
      // Mostra um alerta de confirmação antes de sair
      let alert = UIAlertController(title: "Sair da Conta", message: "Tem certeza que deseja sair?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Sair", style: .destructive, handler: { _ in
        self.viewModel?.performLogout()
      }))
      present(alert, animated: true)
  }
    
    // MARK: - Actions
    
    @objc private func didTapEditProfile() {
        viewModel?.didTapEditProfile()
    }
    
    @objc private func didTapSettings() {
        // Implementar navegação para configurações se necessário
        showSettingsActionSheet()
    }
    
    // MARK: - Private Methods
    
    private func updateProfileView(for state: ProfileState) {
        switch state {
        case .loading:
            showLoadingState()
            
        case .loaded(let profile):
            hideLoadingState()
            populateProfileView(with: profile)
            
        case .error(let error):
            hideLoadingState()
            showErrorAlert(error: error)
        }
    }
    
    private func populateProfileView(with profile: UserProfile) {
        baseView.updateProfile(
            name: profile.name,
            email: profile.email,
            level: profile.level
        )
        
        baseView.updateConquests(
            distance: profile.totalDistance,
            runs: profile.totalRuns
        )
        
        baseView.updateProfileInfo(
            weight: profile.weight,
            height: profile.height,
            goal: profile.goal,
            daysPerWeek: profile.daysPerWeek
        )
    }
    
    private func showLoadingState() {
        // Implementar estado de loading
        // Por exemplo, mostrar um spinner ou skeleton view
        print("Carregando perfil...")
    }
    
    private func hideLoadingState() {
        // Esconder loading
        print("Perfil carregado!")
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Erro",
            message: "Não foi possível carregar o perfil: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        
        let tryAgainAction = UIAlertAction(title: "Tentar Novamente", style: .default) { [weak self] _ in
            self?.viewModel?.fetchProfile()
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(tryAgainAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showSettingsActionSheet() {
        let actionSheet = UIAlertController(
            title: "Configurações",
            message: "Escolha uma opção",
            preferredStyle: .actionSheet
        )
        
        let editProfileAction = UIAlertAction(title: "Editar Perfil", style: .default) { [weak self] _ in
            self?.didTapEditProfile()
        }
        
        let logoutAction = UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
            self?.showLogoutConfirmation()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        actionSheet.addAction(editProfileAction)
        actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)
        
        // Para iPad
        if let popover = actionSheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(actionSheet, animated: true)
    }
    
    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Sair",
            message: "Tem certeza que deseja sair da sua conta?",
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
            self?.performLogout()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
      viewModel?.performLogout()
            print("Logout realizado com sucesso")
        }
    }
