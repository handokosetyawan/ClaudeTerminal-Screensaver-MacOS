import SwiftUI

struct ClaudeCLIView: View {
    @State private var statusIndex = 0
    @State private var pulseWidth: CGFloat = 0.4
    @State private var blink = false
    @State private var isSpinning = false
    
    let statuses = [
        ("Claude is caramelising your query...", "Slow-cooking the logic until golden brown and rich."),
        ("Claude is combobulating the context...", "Putting things back together in a much better order."),
        ("Claude is gently seasoning the output...", "Adding just the right amount of syntax sugar."),
        ("Claude is wrangling the syntax...", "Herding stray brackets back into formation.")
    ]
    
    let bgColor = Color(red: 15/255, green: 16/255, blue: 22/255)
    let windowBg = Color(red: 17/255, green: 17/255, blue: 27/255)
    let headerBg = Color(red: 24/255, green: 24/255, blue: 37/255)
    let borderColor = Color(red: 49/255, green: 50/255, blue: 68/255)
    
    var body: some View {
        ZStack {
            bgColor.edgesIgnoringSafeArea(.all)
            
            // Window
            VStack(spacing: 0) {
                // Header
                ZStack {
                    headerBg
                    HStack(spacing: 8) {
                        Circle().fill(Color(red: 255/255, green: 95/255, blue: 86/255)).frame(width: 12, height: 12)
                        Circle().fill(Color(red: 255/255, green: 189/255, blue: 46/255)).frame(width: 12, height: 12)
                        Circle().fill(Color(red: 39/255, green: 201/255, blue: 63/255)).frame(width: 12, height: 12)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    Text("claude-cli — zsh")
                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                        .foregroundColor(Color(red: 166/255, green: 173/255, blue: 200/255))
                }
                .frame(height: 38)
                .border(width: 1, edges: [.bottom], color: borderColor)
                
                // Body
                VStack(alignment: .leading, spacing: 20) {
                    // Command Line
                    VStack(alignment: .leading, spacing: 4) {
                        Text("~/projects/workspace (main)")
                            .foregroundColor(Color(red: 108/255, green: 112/255, blue: 134/255))
                        HStack(spacing: 6) {
                            Text("$").foregroundColor(Color(red: 137/255, green: 180/255, blue: 250/255)).bold()
                            Text("claude --status-mode caramelise")
                                .foregroundColor(Color(red: 205/255, green: 214/255, blue: 244/255))
                        }
                    }
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
                    
                    // Status Box
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 14) {
                            Circle()
                                .trim(from: 0.2, to: 1.0)
                                .stroke(Color(red: 245/255, green: 158/255, blue: 11/255), lineWidth: 3)
                                .frame(width: 20, height: 20)
                                .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isSpinning)
                            
                            Text(statuses[statusIndex].0)
                                .foregroundColor(Color(red: 250/255, green: 179/255, blue: 135/255))
                                .bold()
                        }
                        
                        Text(statuses[statusIndex].1)
                            .foregroundColor(Color(red: 108/255, green: 112/255, blue: 134/255))
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .padding(.leading, 34)
                        
                        // Progress track
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(borderColor)
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 217/255, green: 119/255, blue: 6/255), Color(red: 245/255, green: 158/255, blue: 11/255)]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * pulseWidth, height: 6)
                            }
                        }
                        .frame(height: 6)
                        .padding(.leading, 34)
                        .padding(.bottom, 6)
                        
                        Text("ℹ Press Esc to toggle verbosity or Ctrl+C to cancel.")
                            .foregroundColor(Color(red: 166/255, green: 173/255, blue: 200/255))
                            .font(.system(size: 11, weight: .regular, design: .monospaced))
                            .padding(.leading, 34)
                    }
                    .padding(20)
                    .background(headerBg)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
                    
                    // Interactive Prompt
                    HStack(spacing: 8) {
                        Text("❯").foregroundColor(Color(red: 245/255, green: 158/255, blue: 11/255))
                        Rectangle()
                            .fill(Color(red: 245/255, green: 158/255, blue: 11/255))
                            .frame(width: 8, height: 15)
                            .opacity(blink ? 1 : 0)
                    }
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
                    
                    Spacer()
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 640, height: 400)
            .background(windowBg)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.7), radius: 25, x: 0, y: 12)
        }
        .onAppear {
            isSpinning = true
            
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseWidth = 0.85
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                blink.toggle()
            }
            
            Timer.scheduledTimer(withTimeInterval: 4.5, repeats: true) { _ in
                statusIndex = (statusIndex + 1) % statuses.count
            }
        }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}
