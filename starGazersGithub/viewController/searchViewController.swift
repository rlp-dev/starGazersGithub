//
//  searchViewController.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 10/06/22.
//

import UIKit
import ProgressHUD

class searchViewController: customViewController {

    @IBOutlet weak var btnSearch        : UIButton!
    @IBOutlet weak var btnDemo          : UIButton!
    @IBOutlet weak var txtOwner         : UITextField!
    @IBOutlet weak var txtRepo         : UITextField!
    
    @IBOutlet weak var lblUsername      : UILabel!
    @IBOutlet weak var lblRepoName      : UILabel!
    @IBOutlet weak var lblResults       : UILabel!

    @IBOutlet weak var tableUsers       : UITableView!
    
    private var nomeRepoToFind          : String = ""
    private var nomeUtenteToFind        : String = ""
    
    private var searchViewModel : SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting localizable string
        self.title = L("VIEW_RICERCA_TITLE")
        self.btnSearch.setTitle(L("VIEW_RICERCA_BTN_RICERCA_TITLE"), for: .normal)
        self.lblRepoName.text = L("VIEW_RICERCA_LBLNOMEREPO")
        self.lblUsername.text = L("VIEW_RICERCA_LBLNOMEUTENTE")
        self.lblResults.text = L("VIEW_RICERCA_LBLRISULTATI")

        self.txtOwner.placeholder = L("VIEW_RICERCA_PLACEHOLDER_NOMEUTENTE")
        self.txtRepo.placeholder = L("VIEW_RICERCA_PLACEHOLDER_NOMEREPO")
        
        //demo mode
        if !demoMode{
            self.btnDemo.isHidden = true
        }
    }
    
    @objc func showAlertError(titolo: String, messaggio: String){
        let alertController = UIAlertController(title: titolo, message: messaggio, preferredStyle: UIAlertController.Style.alert)
        let DestructiveAction = UIAlertAction(title: L("DISCARD"), style: UIAlertAction.Style.destructive) {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(DestructiveAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= scrollView.contentSize.height) && self.searchViewModel.canLoadMore {
            self.searchViewModel.loadMoreData(startLoader: {ProgressHUD.show("", interaction: false)}, stopLoader: {ProgressHUD.dismiss()}, nomeUtente: self.nomeUtenteToFind, nomeRepo: self.nomeRepoToFind) {
                [weak self] (completed) in
                if completed {
                    self?.tableUsers.reloadData()
                } else {
                    self?.showAlertError(titolo: L("ATTENTION_TITLE"), messaggio: L("API_ERROR"))
                }
            }
        }
    }
    
    @IBAction func demoAction(){
        self.nomeRepoToFind = "hello-world"
        self.nomeUtenteToFind = "octocat"
        self.txtOwner.text = "octocat"
        self.txtRepo.text = "hello-world"
        
        self.view.endEditing(true)
        
        self.searchViewModel.loadData(startLoader: {ProgressHUD.show("", interaction: false)}, stopLoader: {ProgressHUD.dismiss()}, nomeUtente: nomeUtenteToFind, nomeRepo: nomeRepoToFind){
            [weak self] (completed) in
            if completed {
                self?.tableUsers.reloadData()
            } else {
                self?.showAlertError(titolo: L("ATTENTION_TITLE"), messaggio: L("API_ERROR"))
            }
        }
    }
    
    @IBAction func ricerca(){
        //check mandatory fields to start a new search
        if let nomeRepo = self.txtRepo.text, nomeRepo.count > 0, let nomeUtente = self.txtOwner.text, nomeUtente.count > 0{
            
            self.resetPage()
    
            self.nomeRepoToFind = nomeRepo
            self.nomeUtenteToFind = nomeUtente
            
            self.view.endEditing(true)
            
            self.searchViewModel.loadData(startLoader: {ProgressHUD.show("", interaction: false)}, stopLoader: {ProgressHUD.dismiss()}, nomeUtente: nomeUtente, nomeRepo: nomeRepo){
                [weak self] (completed) in
                if completed {
                    self?.tableUsers.reloadData()
                } else {
                    self?.showAlertError(titolo: L("ATTENTION_TITLE"), messaggio: L("API_ERROR"))
                }
            }
        }else{
            //show error for mandatory fields
            self.showAlertError(titolo: L("ATTENTION_TITLE"), messaggio: L("ERROR_MANDATORY_FIELD"))
        }
    }
    
    @IBAction func resetPage(){
        self.txtOwner.text = ""
        self.txtRepo.text = ""
        self.searchViewModel.resetAllValues()
        self.tableUsers.reloadData()
    }
}

//MARK: textfield delegate
extension searchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        
        case self.txtRepo:
            self.txtOwner.becomeFirstResponder()
        case self.txtOwner:
            self.view.endEditing(true)
        default:
            break
        }
        return true
    }
}

//MARK: tableview methods and delegate
extension searchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchViewModel.starGazers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: repoUserTableViewCell.identifier, for: indexPath) as? repoUserTableViewCell {
            cell.selectionStyle = .none
            
            let item = self.searchViewModel.starGazers[indexPath.row]
            cell.bindData(item: item)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.searchViewModel.starGazers[indexPath.row]
        if let url = URL(string: item.html_url) {
            UIApplication.shared.open(url)
        }
    }
}
