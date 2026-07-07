//
//  VaultEntryView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/5/26.
//

import SwiftUI

struct VaultEntryView: View {
    @State var vaultEntry: VaultEntry
    @State var isRevealed: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(red: 0.47, green: 0.07, blue: 1.02))
            
            VStack {
                HStack {
                    Text(vaultEntry.name ?? "")
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(1)
                }
                
                HStack {
                    Image(systemName: "person")
                    Text(vaultEntry.username ?? "")
                }
                .font(.title)
                .lineLimit(1)
                
                
                HStack {
                    Image(systemName: "envelope")
                    Text(vaultEntry.email ?? "")
                }
                .font(.title)
                .lineLimit(1)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.black, lineWidth: 1)
                        )
                    
                    HStack {
                        if (isRevealed) {
                            Text(vaultEntry.password ?? "")
                                .padding(.leading)
                        } else {
                            Text("•••••••••••••••")
                                .padding(.leading)
                        }
                        
                        Spacer()

                        // Copy button
                        Button {
                            UIPasteboard.general.string = vaultEntry.password ?? ""
                        } label: {
                            Image(systemName: "document.on.document")
                                .foregroundStyle(.black)
                        }
                        
                        // View button
                        Button {
                            isRevealed = !isRevealed
                        } label: {
                            if (isRevealed) {
                                Image(systemName: "eye.slash")
                            } else {
                                Image(systemName: "eye")
                            }
                            
                        }
                        .foregroundStyle(.black)
                    }
                }
                .font(.title)
                .lineLimit(1)
                .frame(width: 300, height: 50)
            }
            .padding()
        }
    }
}

#Preview {
    VaultEntryView(vaultEntry: VaultEntry(
        id: "abc123",
        name: "Gmail",
        website: "https://gmail.com",
        username: "siddh",
        email: "siddh@gmail.com",
        password: "mypasswasdfsad",
        description: "Personal email account",
        createdAt: "2026-01-01",
        updatedAt: "2026-01-01"
    ))
}
