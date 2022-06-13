//
//  AddVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Photos

class AddVC: BaseViewController {
    private var player = CDPlayerView()
    let naviBar = NavigationBar()
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
        configureNaviBar()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension AddVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "게시글 작성")
        naviBar.configureBackBtn(targetVC: self, action: #selector(dismissVC), naviType: .present)
        naviBar.configureRightBarBtn(targetVC: self, action: #selector(asdf), title: "저장")
    }
    
    private func configurePlayer() {
        player.configurePlayerBtn(playerType: .add, target: self, action: #selector(showGallery))
    }
    
    // TODO: - 임시 화면 연결
    @objc func asdf() {
        let searchVC = YoutubeSearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
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
    
}

// MARK: - Output

extension AddVC {
    
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
