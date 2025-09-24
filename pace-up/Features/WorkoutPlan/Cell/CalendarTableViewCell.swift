import UIKit

class CalendarDayCell: UICollectionViewCell {
  static let reuseIdentifier = "CalendarDayCell"
  
  private let dayOfWeekLabel = UILabel(font: .systemFont(ofSize: 12, weight: .bold), textColor: .gray, textAlignment: .center)
  private let dayNumberLabel = UILabel(font: .systemFont(ofSize: 17, weight: .bold), textColor: .text, textAlignment: .center)
  
  override var isSelected: Bool {
    didSet {
      updateAppearance()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(dayNumber: String, dayOfWeek: String) {
    dayNumberLabel.text = dayNumber
    dayOfWeekLabel.text = dayOfWeek
  }
  
  private func setupUI() {
    contentView.addSubview(dayOfWeekLabel)
    contentView.addSubview(dayNumberLabel)
    
    dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
    dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    
    layer.cornerRadius = 12
    
    NSLayoutConstraint.activate([
      dayOfWeekLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      dayOfWeekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      dayOfWeekLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      
      dayNumberLabel.topAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor, constant: 4),
      dayNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      dayNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      dayNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  private func updateAppearance() {
    if isSelected {
      backgroundColor = .appGreen
      dayOfWeekLabel.textColor = .white
      dayNumberLabel.textColor = .white
    } else {
      backgroundColor = .clear
      dayOfWeekLabel.textColor = .gray
      dayNumberLabel.textColor = .text
    }
  }
}

extension UILabel {
  convenience init(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = .left) {
    self.init()
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
  }
}
