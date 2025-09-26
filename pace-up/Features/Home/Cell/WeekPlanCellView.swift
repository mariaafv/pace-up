import UIKit

class WeekPlanCell: UICollectionViewCell {
    static let reuseIdentifier = "WeekPlanCell"
    
    private let workoutsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16 // Espaçamento entre os cards de treino
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with workouts: [WorkoutDay], weekNumber: Int) {
        workoutsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for workout in workouts {
            let card = TodayWorkoutCardView(frame: .zero)
            let todayWorkout = workout.toTodayWorkout(weekNumber: weekNumber)
            
            card.configure(with: todayWorkout) {
                print("Botão 'Começar Agora' tocado para o treino: \(todayWorkout.workoutType)")
                // Exemplo de como você chamaria o router no futuro
                // router?.navigateToLiveRun()
            }
            workoutsStackView.addArrangedSubview(card)
        }
    }
    
    private func setupUI() {
        // MUDANÇA: Adiciona um scrollView para o caso de a lista de treinos da semana ser muito grande
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        scrollView.addSubview(workoutsStackView)
        
        NSLayoutConstraint.activate([
            // ScrollView preenchendo toda a célula
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // StackView dentro do ScrollView
            workoutsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            workoutsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            workoutsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            workoutsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            workoutsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor) // Essencial
        ])
    }
}
