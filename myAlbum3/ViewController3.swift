//
//  ViewController3.swift
//  myAlbum3
//
//  Created by 정수현 on 2020/09/09.
//  Copyright © 2020 정수현. All rights reserved.
//

import UIKit
import Photos

class ViewController3: UIViewController, UIScrollViewDelegate, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartButton: UIBarButtonItem!
    
    var assets: PHAsset!
    var fetchOptions: PHFetchOptions!
    let imageManger: PHCachingImageManager = PHCachingImageManager()
    let formatter = DateFormatter()
    var title1: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        //ScrollView의 하위View로 ImageView를 등록
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        // image
        imageManger.requestImage(for: assets,
                                 targetSize: CGSize(width: 300, height: 300),
                                 contentMode: .aspectFill, options: nil,
                                 resultHandler: {image, _ in self.imageView?.image = image
        })
        
        let heartTitle = self.assets.isFavorite
        heartButton.title = heartTitle ?  "❤️" : "🤍"
        
        tapImageGestureRecognizer()
        timeTitle1()
        timeTitle2()
        // 변할때마다 delegate 메소드 실행
        PHPhotoLibrary.shared().register(self)
 
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func timeTitle1() {
        formatter.dateFormat = "a h:mm"
        self.navigationItem.title = "\(String(describing: formatter.string(for: title1)!))"
    }
    
    func timeTitle2() {
        formatter.dateFormat = "yyyy년 M월 dd일"
        self.navigationItem.prompt = "\(String(describing: formatter.string(for: title1)!))"
    }
    
    // 이미지 확대 -> 네비게이션바/탭바 숨기기
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        scrollView.backgroundColor = .black
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        return self.imageView
    }
    
    // 이미지 클릭시 탭gesturerecognizer
    func tapImageGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
    }
    
    // 이미지 클릭 -> 네비게이션바/탭바 생성
    @objc func tapImage(_ gesture: UITapGestureRecognizer) {
        scrollView.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    @IBAction func uploadButton(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @IBAction func heartTapButton(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.assets)
            request.isFavorite = !self.assets.isFavorite
            self.heartButton.title = !self.assets.isFavorite ? "❤️" : "🤍"
        }, completionHandler: nil)
    }
    
    @IBAction func removeTapButton(_ sender: UIButton) {
        // asset delete
        PHPhotoLibrary.shared().performChanges({
            // 배열에 담아서 NSArray로 바꿔줘야 합니다. 정확히는 NSFastEnumerator를 상속받은 클래스면 됩니다.
            PHAssetChangeRequest.deleteAssets([self.assets!] as NSArray)
        }, completionHandler: nil)
        
        // completionHandler: ((Bool, Error?) -> Void)? = nil) == 클로저의 첫 인자은 성공,실패 여부를 나타내는 Bool 값이며, 두번째 인자는 실패시에만 받을 수 있는 error값입니다.
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: assets!) else { return }

        // 이미지가 삭제된 후 나타나지는 화면 표시
        if changes.objectWasDeleted {
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
                //self.imageView.image = UIImage(named: "x")
//                self.navigationItem.title = nil
//                self.navigationItem.prompt = nil
            }
        }
        self.assets = changes.objectAfterChanges
        OperationQueue.main.addOperation {
        
        }
        print(changes, "3")
        return
    }
    
    
}
