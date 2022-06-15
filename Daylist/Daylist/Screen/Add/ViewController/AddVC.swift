//
//  AddVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import UIKit
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import Photos
import UITextView_Placeholder

class AddVC: BaseViewController {
    private var player = CDPlayerView()
    private var emotionCV = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var searchView = UIView()
    private var searchTextField = UITextField()
        .then {
            $0.font = .KyoboHandwriting(size: 15)
            $0.placeholder = "URL"
            $0.isEnabled = false
        }
    
    private var searchIcon = UIImageView()
        .then {
            $0.image = UIImage(systemName: "link")
            $0.tintColor = .black
        }
    
    private var separator = UIView()
        .then {
            $0.backgroundColor = .gray
        }
    
    private var postTitle = UITextField()
        .then {
            $0.font = .KyoboHandwriting(size: 20)
            $0.placeholder = "제목"
        }
    
    private var postContent = UITextView()
        .then {
            $0.font = .KyoboHandwriting(size: 15)
            $0.textContainer.lineFragmentPadding = 0
            $0.placeholder = "오늘은 어떤 영상을 보셨나요?"
        }
    
    private var bag = DisposeBag()
    private var viewModel = AddVM()
    private let naviBar = NavigationBar()
    private var imagePicker: UIImagePickerController!
    private var myMedia: AddModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configurePlayer()
        configureCollectionView()
        configureSearchView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindUI()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindOnError()
        bindDataSource()
    }
    
}

// MARK: - Configure

extension AddVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "게시글 작성")
        naviBar.configureBackBtn(targetVC: self, action: #selector(dismissVC), naviType: .present)
        naviBar.configureRightBarBtn(targetVC: self, action: #selector(dismissVC), title: "저장")
    }
    
    private func configurePlayer() {
        player.configurePlayerBtn(playerType: .add, target: self, action: #selector(showGallery))
    }
    
    private func configureCollectionView() {
        let cellWidth = (screenWidth - 50 - 80) / 5
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: cellWidth , height: cellWidth / 50 * 76)
        emotionCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(emotionCV)
        emotionCV.register(EmotionCVC.self, forCellWithReuseIdentifier: EmotionCVC.className)
    }
    
    private func configureSearchView() {
        view.addSubview(searchView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchIcon)
        searchView.addSubview(separator)
    }
    
    private func configureContentView() {
        view.addSubview(postTitle)
        view.addSubview(postContent)
    }
}

// MARK: - Layout

extension AddVC {
    private func configureLayout() {
        view.addSubview(player)
        player.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(57)
            $0.trailing.equalToSuperview().offset(-57)
            $0.height.equalTo(player.snp.width).multipliedBy(287.0/260.0)
        }
        player.configureLayout(with: .add)
        
        emotionCV.snp.makeConstraints {
            $0.top.equalTo(player.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(((screenWidth - 50 - 80) / 5) / 50 * 76)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(emotionCV.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(60)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        searchIcon.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(searchTextField.snp.trailing).offset(4)
            $0.width.height.equalTo(24)
        }
        
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        postTitle.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(20)
        }
        
        postContent.snp.makeConstraints {
            $0.top.equalTo(postTitle.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Custom Methods

extension AddVC {
    @objc func showGallery(){
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // 갤러리 권한 존재, 갤러리로 전환
            openGallery()
        case .notDetermined:
            // 갤러리 권한 요청
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in }
        default:
            // 갤러리 권한 없음, 설정 화면으로 이동
            let accessConfirmVC = UIAlertController(title: "권한 필요", message: "갤러리 접근 권한이 없습니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
            let goSettings = UIAlertAction(title: "설정으로 이동", style: .default) { (action) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            accessConfirmVC.addAction(goSettings)
            accessConfirmVC.addAction(cancel)
            self.present(accessConfirmVC, animated: true, completion: nil)
        }
    }
    
    // Gallery Open
    private func openGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Input

extension AddVC {
    private func bindUI() {
        let searchVC = YoutubeSearchVC()

        searchView.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.pushViewController(searchVC, animated: true)
            })
            .disposed(by: bag)
    
        searchVC.viewModel.media.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] media in
                guard let self = self else { return }
                self.myMedia = media
                let thumbnailImage = try? Data(contentsOf: URL(string: media.thumbnailURL)!)
                self.player.setThumbnailImage(with: UIImage(data: thumbnailImage!)!)
                self.postTitle.text = media.title
                self.searchTextField.text = media.mediaLink
            })
            .disposed(by: self.bag)
        
        naviBar.rightBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let media = AddModel(userId: 1,
                                     title: self.postTitle.text ?? "",
                                     description: self.postContent.text ?? "",
                                     thumbnailURL: self.myMedia!.thumbnailURL,
                                     mediaLink: self.myMedia!.mediaLink,
                                     emotion: self.emotionCV.indexPathsForSelectedItems?.first?.row)
                self.viewModel.postMediaData(with: media)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension AddVC {
    private func bindOnError() {
        viewModel.output.onError
            .asDriver(onErrorJustReturn: .unknown)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.description)
            })
            .disposed(by: bag)
    }
    
    private func bindDataSource() {
        let dataSource = dataSource()
        
        viewModel.output.dataSource
            .bind(to: emotionCV.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension AddVC {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<DataSourceEmotion> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DataSourceEmotion> { _, collectionView, indexPath, emotionType in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCVC.className, for: indexPath) as? EmotionCVC else { return UICollectionViewCell() }
            cell.configureCell(with: emotionType)
            return cell
        }
        return dataSource
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImg: UIImage? = nil
                
        if let possibleImage = info[.editedImage] as? UIImage {
            selectedImg = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            selectedImg = possibleImage
        }
        
        player.setThumbnailImage(with: selectedImg ?? UIImage())
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
