//
//  ViewController2.swift
//  myAlbum3
//
//  Created by 정수현 on 2020/09/09.
//  Copyright © 2020 정수현. All rights reserved.
//

import UIKit
import Photos

class ViewController2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortItemButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var sutTitle: String = ""
    var fetchResults: PHAssetCollection!
    var fetchOptions = PHFetchOptions()
    let imageManger: PHCachingImageManager = PHCachingImageManager()
    var sort = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        // title
        self.navigationItem.title = "\(sutTitle)"
        self.navigationItem.largeTitleDisplayMode = .never
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: (collectionView.frame.size.width/3)-5, height: (collectionView.frame.size.height/5)-5)
        collectionView.collectionViewLayout = layout
        
        // nib
        collectionView.register(CollectionViewCell2.nib(), forCellWithReuseIdentifier: CollectionViewCell2.identifier)
        
        // choice button
        setupBarButtonItems()
        sortItemButton.title = "최신순"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    
    //MARK: 선택일때와 취소일때 화면
    enum Mode {
        case view
        case select
    }
    // 추가됨
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [ : ]
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                for (key, _) in dictionarySelectedIndexPath {
                    collectionView.deselectItem(at: key, animated: true)
                }
                selectBarButton.title = "선택"                  // 버튼 이름 생성
                self.navigationItem.hidesBackButton = false    // 이전 버튼 생성
                collectionView.allowsMultipleSelection = false // 다중 선택 못함
                self.navigationItem.title = "\(sutTitle)"      // 타이틀 제목
                self.navigationController?.setToolbarHidden(false, animated: true)
                
            case .select:
                selectBarButton.title = "취소"                  // 버튼 이름
                self.navigationItem.hidesBackButton = true     // 이전 버튼 숨김
                collectionView.allowsMultipleSelection = true  // 다중 선택 가능
                self.navigationItem.title = "항목선택"           // 타이틀 제목
                self.navigationController?.setToolbarHidden(true, animated: true)
                uploadButton.isEnabled = false                 // 업로드 버튼 비활성
                removeButton.isEnabled = false                 // 삭제 버튼 업로드
                selectedNumber = 0
            }
        }
    }
    
    
    // 선택 버튼
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mMode = mMode == .view ? .select : .view
    }
    
    // 총 선택한 이미지 수
    var selectedNumber: Int = 0
    // 선택한 이미지 수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            // 이미지 아이템 선택 해제
            collectionView.deselectItem(at: indexPath, animated: true)
            // 클릭 이미지 assets 전달
            let View3 = storyboard?.instantiateViewController(identifier: "vc3") as! ViewController3
            View3.assets = assets[indexPath.row]
            let date1 = assets[indexPath.row].creationDate!
            print(date1, "date1")
            View3.title1 = assets[indexPath.row].creationDate
            navigationController?.pushViewController(View3, animated: true)
        case .select:
            uploadButton.isEnabled = true        // 업로드 버튼 활성화
            removeButton.isEnabled = true        // 삭제 버튼 활성화
            dictionarySelectedIndexPath[indexPath] = true
            // 선택한 이미지 수
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.isSelected == true {
                selectedNumber += 1 //(indexPath.count -1)
            }
            self.navigationItem.title = "\(String(selectedNumber))" + "장 선택"
        }
    }
    
    // 해제한 이미지 수
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
            //dictionarySelectedIndexPath[indexPath] = false
        }
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.isSelected == false {
            selectedNumber += -1
            if selectedNumber == 0 {
                uploadButton.isEnabled = false
                removeButton.isEnabled = false
                self.navigationItem.title = "항목선택"
            } else {
                self.navigationItem.title = "\(String(selectedNumber))" + "장 선택"
            }
        }
    }
    
    @IBAction func sortTapButton(_ sender: Any) {
        var sortItem = collectionView.indexPathsForVisibleItems
        var reversedSortItem = sortItem.sorted() {$0 > $1}
        if sort {
            sortItemButton.title = "오래된순"
            print(sort, "오래된순")
            //sortItem.sort(by: {$01.item < $1.item})
            
            print(reversedSortItem, "오래된순")
            //self.sortDecide(true)
        } else {
            sortItemButton.title = "최신순"
            
            print(sort, "최신순")
            //sortItem.sort(by: {$01.item < $1.item})
            sortItem.sort(by: {$01.item > $1.item})
            //self.sortDecide(false)
        }
        sort = !sort
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResults!.estimatedAssetCount
    }
    
    var assets: [PHAsset] = []
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell2.identifier, for: indexPath) as! CollectionViewCell2
        
        let fetchResultData = PHAsset.fetchAssets(in: fetchResults!, options: fetchOptions)
        print(fetchResultData, "fetchResultData")
        
        let asset: PHAsset = fetchResultData.object(at: indexPath.row)
        assets.append(asset)
        print(asset, "asset")
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        imageManger.requestImage(for: asset,
                                 targetSize: CGSize(width: 350, height: 350),
                                 contentMode: .aspectFill,
                                 options: options,
                                 resultHandler: {image, _ in cell.imageView?.image = image
        })
        return cell
    }
    
    
    @IBAction func uploadTapButton(_ sender: Any) {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            let items = selectedItems.map{$0.item}.sorted().reversed()
            for item in items {
                assets.remove(at: item)
            }
            collectionView.deleteItems(at: selectedItems)
            collectionView.reloadData()
        }
    }
    
    
    @IBAction func removeTapButton(_ sender: Any) {
        let selectedItems = collectionView.indexPathsForSelectedItems
        let vc = UIActivityViewController(activityItems: [selectedItems as Any], applicationActivities: nil)
        present(vc, animated: true)
    }
}
