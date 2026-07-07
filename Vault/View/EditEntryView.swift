//
//  EditEntryView.swift
//  Vault
//
//  Created by Siddharth Mulupuru on 7/7/26.
//

import SwiftUI

struct EditEntryView: View {
    @State var vaultEntry: VaultEntry
    @State var isPasswordRevealed: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.47, green: 0.07, blue: 1.02)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Edit Entry")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        fieldRow(label: "Name", text: Binding(
                            get: { vaultEntry.name ?? "" },
                            set: { vaultEntry.name = $0 }
                        ))
                        
                        fieldRow(label: "Website", text: Binding(
                            get: { vaultEntry.website ?? "" },
                            set: { vaultEntry.website = $0 }
                        ))
                        
                        fieldRow(label: "Username", text: Binding(
                            get: { vaultEntry.username ?? "" },
                            set: { vaultEntry.username = $0 }
                        ))
                        
                        fieldRow(label: "Email", text: Binding(
                            get: { vaultEntry.email ?? "" },
                            set: { vaultEntry.email = $0 }
                        ))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                            HStack {
                                if isPasswordRevealed {
                                    TextField("Password", text: Binding(
                                        get: { vaultEntry.password ?? "" },
                                        set: { vaultEntry.password = $0 }
                                    ))
                                    .foregroundStyle(.white)
                                } else {
                                    SecureField("Password", text: Binding(
                                        get: { vaultEntry.password ?? "" },
                                        set: { vaultEntry.password = $0 }
                                    ))
                                    .foregroundStyle(.white)
                                }
                                
                                Button {
                                    UIPasteboard.general.string = vaultEntry.password ?? ""
                                } label: {
                                    Image(systemName: "document.on.document")
                                        .foregroundStyle(.white)
                                }
                                
                                Button {
                                    isPasswordRevealed.toggle()
                                } label: {
                                    Image(systemName: isPasswordRevealed ? "eye.slash" : "eye")
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Description")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                            HStack(alignment: .top) {
                                TextEditor(text: Binding(
                                    get: { vaultEntry.description ?? "" },
                                    set: { vaultEntry.description = $0 }
                                ))
                                .foregroundStyle(.white)
                                .scrollContentBackground(.hidden)
                                .frame(height: 80)
                                
                                Button {
                                    UIPasteboard.general.string = vaultEntry.description ?? ""
                                } label: {
                                    Image(systemName: "document.on.document")
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button {
                            // TODO: encrypt fields and call PUT /api/vault/{id}
                            // then call loadEntries() to refresh
                        } label: {
                            Text("Save")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .padding(.top, -4)
            }
        }
    }
    
    @ViewBuilder
    func fieldRow(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            HStack {
                TextField(label, text: text)
                    .foregroundStyle(.white)
                Button {
                    UIPasteboard.general.string = text.wrappedValue
                } label: {
                    Image(systemName: "document.on.document")
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .background(.white.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

#Preview {
    EditEntryView(vaultEntry: VaultEntry(
        id: "abc123",
        name: "Gmail",
        website: "https://gmail.com",
        username: "siddh",
        email: "siddh@gmail.com",
        password: "mypassword123",
        description: "Personal email account",
        createdAt: "2026-01-01",
        updatedAt: "2026-01-01"
    ))
}
