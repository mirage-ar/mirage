//
//  SearchBar.swift
//  Mirage
//
//  Created by Saad on 21/11/2023.
//

import SwiftUI


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onTextChanged: (String) -> Void
    var onStateChanged: (Bool) -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        var onTextChanged: (String) -> Void
        var onStateChanged: (Bool) -> Void
        let foregroundColor: Color
        let backgroundColor: Color
        @Binding var text: String
        
        init(text: Binding<String>, foregroundColor: Color = Colors.white.swiftUIColor, backgroundColor: Color = Colors.g1DarkGrey.swiftUIColor, onTextChanged: @escaping (String) -> Void, onStateChanged:  @escaping (Bool) -> Void) {
            _text = text
            self.onTextChanged = onTextChanged
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.onStateChanged = onStateChanged
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChanged(text)
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            onStateChanged(true)
            searchBar.setShowsCancelButton(true, animated: true)
        }
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            onStateChanged(false)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, onTextChanged: onTextChanged, onStateChanged: onStateChanged)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.textColor = UIColor(context.coordinator.foregroundColor)
        searchBar.backgroundColor = UIColor(context.coordinator.backgroundColor)
        searchBar.setImage(Images.search16.image, for: .search, state: .normal)
        searchBar.setImage(Images.cross24.image, for: .clear, state: .normal)

        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
