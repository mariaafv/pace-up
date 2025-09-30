import UIKit

class ProfileView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Header Section
    
    private let profileHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.appGreen.withAlphaComponent(0.2) // Usando nossa cor customizada
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let personIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        personIcon.tintColor = .appGreen // Usando nossa cor customizada
        personIcon.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(personIcon)
        
        NSLayoutConstraint.activate([
            personIcon.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            personIcon.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            personIcon.widthAnchor.constraint(equalToConstant: 32),
            personIcon.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let levelBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        label.backgroundColor = .systemOrange.withAlphaComponent(0.15)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Conquistas Section
    
    private let conquestsCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        // ... (outras propriedades de sombra)
        return view
    }()
    
    private let conquestsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🏆 Suas Conquistas"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conquestsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceConquestCard, runsConquestCard])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let distanceConquestCard = ConquestCardView(
        backgroundColor: UIColor.appGreen.withAlphaComponent(0.15),
        value: "0.0",
        unit: "km percorridos"
    )
    
    private let runsConquestCard = ConquestCardView(
        backgroundColor: .systemOrange.withAlphaComponent(0.15),
        value: "0",
        unit: "corridas realizadas"
    )
    
    // MARK: - Profile Info Section
    
    private let profileInfoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        // ... (outras propriedades de sombra)
        return view
    }()
    
    private let profileInfoTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Informações do Perfil"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let weightInfoView = ProfileInfoRowView(label: "Peso:", value: "-- kg")
    private let heightInfoView = ProfileInfoRowView(label: "Altura:", value: "-- cm")
    private let levelInfoView = ProfileInfoRowView(label: "Nível:", value: "--")
    private let goalInfoView = ProfileInfoRowView(label: "Objetivo:", value: "--")
    private let daysPerWeekInfoView = ProfileInfoRowView(label: "Dias por semana:", value: "-- dias")
    
    // MARK: - Logout Button
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sair da Conta (Logout)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        button.configuration = config
        return button
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .systemGroupedBackground
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        // Header setup
        profileHeaderView.addSubview(avatarImageView)
        profileHeaderView.addSubview(nameLabel)
        profileHeaderView.addSubview(emailLabel)
        profileHeaderView.addSubview(levelBadge)
        
        // Conquests setup
        conquestsCardView.addSubview(conquestsTitleLabel)
        conquestsCardView.addSubview(conquestsStackView)
        
        // Profile info setup
        profileInfoTitleView.addSubview(profileInfoTitleLabel)
        profileInfoTitleView.addSubview(editButton)
        
        profileInfoCardView.addSubview(profileInfoTitleView)
        profileInfoCardView.addSubview(profileInfoStackView)
        
        profileInfoStackView.addArrangedSubview(weightInfoView)
        profileInfoStackView.addArrangedSubview(heightInfoView)
        profileInfoStackView.addArrangedSubview(levelInfoView)
        profileInfoStackView.addArrangedSubview(goalInfoView)
        profileInfoStackView.addArrangedSubview(daysPerWeekInfoView)
        
        // Main stack setup
        mainStackView.addArrangedSubview(profileHeaderView)
        mainStackView.addArrangedSubview(conquestsCardView)
        mainStackView.addArrangedSubview(profileInfoCardView)
        mainStackView.addArrangedSubview(logoutButton) // Adiciona o botão de logout
        
        mainStackView.setCustomSpacing(40, after: profileInfoCardView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // MainStackView constraints
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
            
            // Profile header constraints
            avatarImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor, constant: -16),
            
            levelBadge.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),
            levelBadge.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            levelBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            levelBadge.heightAnchor.constraint(equalToConstant: 24),
            levelBadge.bottomAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: -24),
            
            // Conquests constraints
            conquestsTitleLabel.topAnchor.constraint(equalTo: conquestsCardView.topAnchor, constant: 20),
            conquestsTitleLabel.leadingAnchor.constraint(equalTo: conquestsCardView.leadingAnchor, constant: 20),
            
            conquestsStackView.topAnchor.constraint(equalTo: conquestsTitleLabel.bottomAnchor, constant: 16),
            conquestsStackView.leadingAnchor.constraint(equalTo: conquestsCardView.leadingAnchor, constant: 20),
            conquestsStackView.trailingAnchor.constraint(equalTo: conquestsCardView.trailingAnchor, constant: -20),
            conquestsStackView.bottomAnchor.constraint(equalTo: conquestsCardView.bottomAnchor, constant: -20),
            
            // Profile info constraints
            profileInfoTitleView.topAnchor.constraint(equalTo: profileInfoCardView.topAnchor, constant: 20),
            profileInfoTitleView.leadingAnchor.constraint(equalTo: profileInfoCardView.leadingAnchor, constant: 20),
            profileInfoTitleView.trailingAnchor.constraint(equalTo: profileInfoCardView.trailingAnchor, constant: -20),
            
            profileInfoTitleLabel.leadingAnchor.constraint(equalTo: profileInfoTitleView.leadingAnchor),
            profileInfoTitleLabel.centerYAnchor.constraint(equalTo: profileInfoTitleView.centerYAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: profileInfoTitleView.trailingAnchor),
            editButton.centerYAnchor.constraint(equalTo: profileInfoTitleView.centerYAnchor),
            
            profileInfoStackView.topAnchor.constraint(equalTo: profileInfoTitleView.bottomAnchor, constant: 16),
            profileInfoStackView.leadingAnchor.constraint(equalTo: profileInfoCardView.leadingAnchor, constant: 20),
            profileInfoStackView.trailingAnchor.constraint(equalTo: profileInfoCardView.trailingAnchor, constant: -20),
            profileInfoStackView.bottomAnchor.constraint(equalTo: profileInfoCardView.bottomAnchor, constant: -20),
            
            // Logout Button Constraint
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    
    func updateProfile(name: String, email: String, level: String) {
        nameLabel.text = name
        emailLabel.text = email
        levelBadge.text = level
    }
    
    func updateConquests(distance: String, runs: String) {
        distanceConquestCard.updateValue(distance)
        runsConquestCard.updateValue(runs)
    }
    
  func updateProfileInfo(weight: String?, height: String?, goal: String?, daysPerWeek: String?) {
      weightInfoView.updateValue(weight ?? "-- kg")
      heightInfoView.updateValue(height ?? "-- cm")
      goalInfoView.updateValue(goal ?? "Completar 5K")
      daysPerWeekInfoView.updateValue(daysPerWeek ?? "-- dias")
  }
}


