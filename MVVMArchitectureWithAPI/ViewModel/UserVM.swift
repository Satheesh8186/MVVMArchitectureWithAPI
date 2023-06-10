//
//  UserVM.swift
//  MVVMArchitectureWithAPI
//
//  Created by satheesh kumar on 10/06/23.
//

import Foundation
class UserVm: ObservableObject{
    @Published  var userData = [UserModel]()
    @Published var isApiFailed = false
    @Published var error : UserError?
    @Published private(set) var isRefresh = false
    func fetchUser(){
        isApiFailed = false
        isRefresh = true
        if let url = URL(string: "https://jsonplaceholder.typicode.com/usersr"){
            URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
               // asyncAfter(deadline: .now() + 2.5 if api is fast to check progress
                DispatchQueue.main.async {
                    if let error = error{
                        self?.isApiFailed = true
                        self?.error = UserError.custom(error: error)
                    }else{
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        if let data = data,let user =  try? jsonDecoder.decode([UserModel].self, from: data){
                            self?.userData = user
                        }else{
                            self?.isApiFailed = true
                            self?.error = UserError.failedDecoder
                        }
                    }
                    self?.isRefresh = false
                }
               
            }.resume()
        }
    }
}
extension UserVm{
    enum UserError: LocalizedError {
        case custom(error: Error)
        case  failedDecoder
        var errorDescription: String?{
            switch self{
            case .custom(error: let error):
                return error.localizedDescription
            case .failedDecoder:
                return "failed to decode"
            }
        }
    }
}
