//
//  ViewModifiers.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct CircularButton: View {
    let image: Image
    let buttonAction: () -> Void
    let isEnabled: Bool
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            image
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(isEnabled ? .black : Color(hex: 0x7D7B76))
                .padding(5)
                .background(isEnabled ? .white : Color(hex: 0xFAF5E9)) // TODO: add color profile
                .clipShape(Circle())
        }
    }
}

struct UISliderView: UIViewRepresentable {
    @Binding var value: Double
    
    var minValue = 1.0
    var maxValue = 100.0
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor = .white
    var maxTrackColor: UIColor = .white
    
    class Coordinator: NSObject {
        var value: Binding<Double>
        
        init(value: Binding<Double>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
        }
    }
    
    func makeCoordinator() -> UISliderView.Coordinator {
        Coordinator(value: $value)
    }
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}

struct SubTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("ABCDiatypeMonoUnlicensedTrial-Regular", fixedSize: 16.0))
    }
}

struct FontBody: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("ABCDiatypeMonoUnlicensedTrial-Regular", fixedSize: 14.0))
    }
}

extension View {
    
    func subTitle() -> some View {
        self.modifier(SubTitle())
    }
    
    func fontBody() -> some View {
        self.modifier(FontBody())
    }
}
