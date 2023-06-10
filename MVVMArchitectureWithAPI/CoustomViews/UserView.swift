//
//  UserView.swift
//  MVVMArchitectureWithAPI
//
//  Created by satheesh kumar on 10/06/23.
//

import SwiftUI

struct UserView: View {
    let user:UserModel
    var body: some View {
        VStack(alignment: .leading){
            Text(user.username)
            Text(user.email)
            Divider()
            Text(user.company.name)
            Text(user.company.catchPhrase)
        }.padding().frame(maxWidth: .infinity,alignment: .leading).background(.gray.opacity(0.1)).padding(.horizontal,4).cornerRadius(10.0)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: .init(id: 0, username: "sd", email: "dsc@fd.com", company: .init(name: "des", catchPhrase: "wafd sf")))
    }
}
