//
//  CommentViewController.swift
//  Instagram
//
//  Created by kazuki on 2021/02/14.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var handleCommentButton: UIButton!
    
    var postData : PostData!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentField.delegate = self
        commentField.text = ""
        handleCommentButton.isEnabled = false
        
        // Do any additional setup after loading the view.
        
    }
    
    func textField(_ commentField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            // テキストフィールドの文字が更新されたら変更する
            self.handleCommentButton.isEnabled = !(commentField.text?.isEmpty ?? true)
        }
        return true
    }
    
    
    @IBAction func handleCommentButton(_ sender: UIButton) {
        
        // HUDで処理中を表示
        SVProgressHUD.show()
            
        let comment = commentField.text
        let name = Auth.auth().currentUser?.displayName
        let commentName = "【\(name!)】\(comment!)"
        
        // 更新データを作成する
        var updateComment: FieldValue

        
        updateComment = FieldValue.arrayUnion([commentName])
        // commentに更新データを書き込む
                   let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                   postRef.updateData(["commentName": updateComment])
        
        SVProgressHUD.showSuccess(withStatus: "コメントしました")
        // 投稿処理が完了したので先頭画面に戻る
       UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func handleCommentCancelButton(_ sender: Any) {
    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
