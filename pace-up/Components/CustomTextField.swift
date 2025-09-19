import UIKit

class CustomTextField: UITextField {
  
  init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
    super.init(frame: .zero)
    
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.isSecureTextEntry = isSecure
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .backgroundDarker
    layer.cornerRadius = 12
    font = .systemFont(ofSize: 16)
    textColor = .text
    autocorrectionType = .no
    autocapitalizationType = .none

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
    leftView = paddingView
    leftViewMode = .always
    rightView = paddingView
    rightViewMode = .always
  }
}
