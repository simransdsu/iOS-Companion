//
//  CompanionRowItem.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import SwiftUI

struct CompanionRowView: View {
    
    var companion: Companion
    
    var body: some View {
        HStack {
                Image("")
                .frame(width: 100, height: 100)
                .background([Color.red,Color.pink,Color.green,Color.purple,Color.indigo].randomElement().opacity(0.5))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(companion.name)
                    .font(.title3.weight(.semibold))
                HStack {
                    Text("\(companion.age) \(companion.type)")
                }.foregroundColor(.secondary)
            }
        }
    }
}

struct CompanionRowItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
        CompanionRowView(companion: Companion(id: 129, type: "Dog", species: "German Shephered", age: "Baby", photos: [], name: "Jonny", description: "This is the Best Dog"))
        }.previewLayout(.fixed(width: 420.0, height: 180.0))
            
    }
}
