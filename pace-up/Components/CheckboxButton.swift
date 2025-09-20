import UIKit

class CheckboxButton: UIButton {
  private let checkedImage = UIImage(systemName: "checkmark.square.fill")
  private let uncheckedImage = UIImage(systemName: "square")
  
  override var isSelected: Bool {
    didSet {
      updateAppearance()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupButton() {
    tintColor = .appGreen
    contentHorizontalAlignment = .left
    setTitleColor(.text, for: .normal)
    
    var config = UIButton.Configuration.plain()
    config.imagePadding = 8
    self.configuration = config
    
    updateAppearance()
  
    addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  private func updateAppearance() {
    let image = isSelected ? checkedImage : uncheckedImage
    let tint = isSelected ? UIColor.appGreen : UIColor.text
    
    setImage(image, for: .normal)
    self.tintColor = tint
  }
  
  @objc private func buttonTapped() {
    self.isSelected.toggle()
  }
}
