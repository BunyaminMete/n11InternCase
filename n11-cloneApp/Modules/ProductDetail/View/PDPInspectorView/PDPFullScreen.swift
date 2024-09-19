import UIKit

// MARK: - Section Enum
extension FullScreenImageViewController {
    enum Section {
        case main
        case indicator
    }
}

class FullScreenImageViewController: UIViewController {

    var images: [UIImage] = []
    var initialIndexPath: IndexPath?
    
    private var dataSource: UICollectionViewDiffableDataSource<
        Section, UIImage
    >!
    private var collectionView: UICollectionView!

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupDataSource()
        applySnapshot()
        setupCloseButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let initialIndexPath = initialIndexPath {
            collectionView.scrollToItem(at: initialIndexPath,
                                        at: .centeredHorizontally,
                                        animated: false)
        }
    }
    
    private func setupCollectionView() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
                let layout = self?.createLayoutSection()
                return layout
            },
            configuration: configuration
        )
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<
            FullScreenImageCell, UIImage
        > { cell, indexPath, image in
            cell.imageView.image = image
            cell.backgroundColor = .white
        }
        dataSource = UICollectionViewDiffableDataSource<
            Section, UIImage
        >(collectionView: collectionView)
        { collectionView, indexPath, image in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: image)
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<
            Section, UIImage
        >()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
    
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
