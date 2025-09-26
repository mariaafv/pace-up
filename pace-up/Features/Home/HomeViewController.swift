import UIKit

class HomeViewController: BaseViewController {
  private var baseView = HomeView()
  private let viewModel: HomeViewModelProtocol
  
  init(viewModel: HomeViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
    setupTargets()
    setupCollectionView()
    
    viewModel.fetchData()
  }
  
  private func setupCollectionView() {
      baseView.weeklyPlanCollectionView.delegate = self
      baseView.weeklyPlanCollectionView.dataSource = self
      baseView.weeklyPlanCollectionView.register(WeekPlanCell.self, forCellWithReuseIdentifier: WeekPlanCell.reuseIdentifier)
  }
  
  private func setupBindings() {
    viewModel.onGreetingUpdate = { [weak self] greeting in
      self?.baseView.setGreeting(text: greeting)
    }

    viewModel.onPlanStateChange = { [weak self] state in
      self?.updatePlanSection(state: state)
    }
  }
  
  private func setupTargets() {
    //baseView.planSectionView.createPlanButton.addTarget(self, action: #selector(didTapCreatePlan), for: .touchUpInside)
  }
  
  @objc private func didTapCreatePlan() {
    viewModel.didTapCreatePlan()
  }
  
  private func updatePlanSection(state: PlanState) {
    switch state {
    case .loading:
      print("Carregando plano...")
      // Mostrar um spinner
    case .empty:
      print("Nenhum plano encontrado.")
      baseView.showEmptyPlanState()
    case .loaded(let plan):
                print("Plano carregado!")
                baseView.showWorkoutPlanList()
                // MUDANÇA: Recarrega os dados e configura o page control
                baseView.weeklyPlanCollectionView.reloadData()
                baseView.pageControl.numberOfPages = viewModel.activeWorkoutsByWeek.count
    case .error(let error):
      print("Erro ao carregar plano: \(error.localizedDescription)")
      // Mostrar uma mensagem de erro
    }
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.activeWorkoutsByWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekPlanCell.reuseIdentifier, for: indexPath) as? WeekPlanCell else {
            return UICollectionViewCell()
        }
        let weeklyWorkouts = viewModel.activeWorkoutsByWeek[indexPath.item]
        cell.configure(with: weeklyWorkouts)
        return cell
    }
    
    // Define o tamanho de cada "página" para ocupar a tela inteira
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Remove o espaçamento entre as páginas
    }
    
    // Atualiza o page control quando o usuário desliza a tela
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == baseView.weeklyPlanCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            baseView.pageControl.currentPage = page
        }
    }
}
