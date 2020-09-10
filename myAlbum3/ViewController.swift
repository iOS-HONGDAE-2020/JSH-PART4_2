//
//  ViewController.swift
//  myAlbum3
//
//  Created by 정수현 on 2020/09/09.
//  Copyright © 2020 정수현. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchResults: [PHAssetCollection] = []
    let imageManger: PHCachingImageManager = PHCachingImageManager()
    var fetchOptions: PHFetchOptions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        // title
        self.navigationItem.title = "앨범"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (collectionView.frame.size.width/2)-8, height: (collectionView.frame.size.height/2.5))
        collectionView.collectionViewLayout = layout
        
        // nib
        collectionView.register(CollectionViewCell1.nib(), forCellWithReuseIdentifier: CollectionViewCell1.identifier)
    
        
        // 권한 설정
        photoAurthoriazation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    //MARK: 이미지 가져오기
    
    func requestCollection() {
        // recent
        let userAlbumResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        // favorites
        let favoriteResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        // albums
        let albumResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        // PHFetchResult<PHAssetCollection> -> PHAssetCollection
        // firstObject(The first object in the fetch result) : 첫번째 object가 아닌 다음 단계(차원?) 첫번째 배열?????
        guard let userAlbumCollection: PHAssetCollection = userAlbumResult.firstObject else {
            return
        }
        guard let favoriteCollection: PHAssetCollection = favoriteResult.firstObject else {
            return
        }
        //        guard let albumCollection: PHAssetCollection = albumResult.firstObject else {
        //            return
        //        }
        // fetchResults 리스트에 추가
        self.fetchResults.append(userAlbumCollection)
        self.fetchResults.append(favoriteCollection)
        
        // 앨범 1개만 나와서 수정
        for i in 0..<albumResult.count {
            let albumCollection = albumResult.object(at: i)
            self.fetchResults.append(albumCollection)
        }
        //print(fetchResults)
    }
    
    func photoAurthoriazation() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            switch status {
            case .authorized:
                print("사용자가 허용함")
                self.requestCollection()
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
            case .denied:
                print("사용자가 불허함")
            default: break
            }
        })
        //PHPhotoLibrary.shared().register(self)
    }
    
    //MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell1.identifier, for: indexPath) as! CollectionViewCell1
        
        //
        cell.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 15
        // 배열에서 빠져나옴
        let fetchResult = fetchResults[indexPath.item]
        //print(fetchResult)
        
        let fetchResultData = PHAsset.fetchAssets(in: fetchResult, options: fetchOptions)
        cell.nameLabel.text = fetchResult.localizedTitle
        cell.countLabel.text = String(fetchResultData.count)
        //print(fetchResultData)
        // 강력
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        if let asset: PHAsset = fetchResultData.firstObject {
            imageManger.requestImage(for: asset,
                                     targetSize: CGSize(width: 150, height: 150),
                                     contentMode: .aspectFill,
                                     options: options,
                                     resultHandler: {image, _ in cell.imageView?.image = image
            })
        }
        return cell
    }
    
    //    // UICollectionViewDelegateFlowLayout
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: (self.collectionView.frame.size.width-10)/2, height: (self.collectionView.frame.size.height)/2.7)
    //    }
    
    // cell 선택시 다음 화면
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let View2 = storyboard?.instantiateViewController(identifier: "vc2") as! ViewController2
        let fetchResult = fetchResults[indexPath.item]
        View2.sutTitle = fetchResult.localizedTitle! //title
        View2.fetchResults = fetchResults[indexPath.item]
        navigationController?.pushViewController(View2, animated: true)
    }
    
    
    
    
    
    
}

