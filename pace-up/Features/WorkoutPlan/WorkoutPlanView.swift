import UIKit

class WorkoutPlanView: UIView {

    // MARK: - UI Components
    
    // O ScrollView principal que conterá toda a tela
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    // A StackView principal que organiza os elementos verticalmente
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 24 // Espaçamento padrão entre as seções
        return stack
    }()
    
    // O Calendário que acabamos de projetar
    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 60)
        layout.minimumLineSpacing = 10
        // Adiciona um pouco de padding nas laterais do calendário
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // Placeholder para o card de "Próximo treino"
    // No futuro, esta será uma classe customizada (ex: NextWorkoutCardView)
    let nextWorkoutCard: UIView = {
        let view = UIView()
        // Estilo temporário para visualização
        view.backgroundColor = .appGreen.withAlphaComponent(0.2)
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        let label = UILabel(text: "Próximo treino (Placeholder)", font: .systemFont(ofSize: 16), textColor: .appGreen)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    // Placeholder para a lista de treinos da semana
    // No futuro, esta será uma UIStackView com vários WorkoutDayCardView
    let weeklyWorkoutList: UIView = {
        let view = UIView()
        // Estilo temporário para visualização
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        let label = UILabel(text: "Lista de Treinos (Placeholder)", font: .systemFont(ofSize: 16), textColor: .gray)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
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
        
        mainStackView.addArrangedSubview(calendarCollectionView)
        mainStackView.addArrangedSubview(nextWorkoutCard)
        mainStackView.addArrangedSubview(weeklyWorkoutList)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView ocupando a tela inteira (respeitando a safe area)
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            // StackView dentro do ScrollView
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            // Essencial para a rolagem vertical funcionar corretamente
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Constraints para os elementos dentro da StackView
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 70),
            
            // Adiciona padding horizontal para os cards
            nextWorkoutCard.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            nextWorkoutCard.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
            
            weeklyWorkoutList.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            weeklyWorkoutList.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
        ])
    }
}
