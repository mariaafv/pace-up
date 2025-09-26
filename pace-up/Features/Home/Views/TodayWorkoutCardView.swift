import UIKit

class TodayWorkoutCardView: UIView {

    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textColor = .label // Adapta-se ao modo light/dark
        return lbl
    }()

    private let weekLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    private let typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    private let durationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    private let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    let startButton: UIButton = { // Deixamos público para o ViewController adicionar ações
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let restLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .systemOrange // Cor padrão para avisos
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.isHidden = true // Começa escondido
        return lbl
    }()
  
  private let infoStack: UIStackView = {
       let stack = UIStackView()
       stack.axis = .vertical
       stack.spacing = 4
       stack.alignment = .leading
       return stack
   }()
   
   private let metricsStack: UIStackView = {
       let stack = UIStackView()
       stack.axis = .horizontal
       stack.spacing = 16
       stack.alignment = .leading
       return stack
   }()
    
    private var onStart: (() -> Void)?

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [titleLabel, weekLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 2
        headerStack.alignment = .leading

      infoStack.addArrangedSubview(typeLabel)
          infoStack.addArrangedSubview(descriptionLabel)
          
          metricsStack.addArrangedSubview(durationLabel)
          metricsStack.addArrangedSubview(distanceLabel)

        let mainStack = UIStackView(arrangedSubviews: [headerStack, infoStack, metricsStack, restLabel, startButton])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            startButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }

    // MARK: - Configure
    
    func configure(with workout: TodayWorkout, onStart: @escaping () -> Void) {
        self.onStart = onStart
        
      titleLabel.text = workout.day ?? "Dia de treino"
        weekLabel.text = "Semana \(workout.weekNumber)"
        typeLabel.text = getWorkoutTypeTitle(workout.workoutType)
        descriptionLabel.text = workout.description
        durationLabel.text = "⏱ \(workout.durationMinutes) min"
        
        if let distance = workout.targetDistance {
            distanceLabel.text = "📍 \(distance) km"
            distanceLabel.isHidden = false
        } else {
            distanceLabel.isHidden = true
        }

        let isRestDay = workout.workoutType.lowercased().contains("descanso")
        restLabel.isHidden = !isRestDay
        infoStack.isHidden = isRestDay
        metricsStack.isHidden = isRestDay
        
        if isRestDay {
            restLabel.text = "🌅 Dia de recuperação - Seu corpo precisa descansar!"
            startButton.setTitle("Marcar como Concluído", for: .normal)
            startButton.backgroundColor = .systemOrange
            startButton.setTitleColor(.white, for: .normal)
        } else {
            startButton.setTitle("Começar Agora", for: .normal)
            startButton.backgroundColor = .appGreen
            startButton.setTitleColor(.white, for: .normal)
        }

        if workout.completed {
            backgroundColor = .systemGray5
            // Você pode adicionar um badge "Concluído" se quiser
        }
    }
    
    @objc private func didTapStartButton() {
        onStart?()
    }

    private func getWorkoutTypeTitle(_ type: String) -> String {
        return type.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
