import SwiftUI

// MARK: — Welcome

struct WelcomeView: View {
    @Environment(AppState.self) var state
    @State private var logoOpacity  = 0.0
    @State private var buttonsOpacity = 0.0
    @State private var haloScale: CGFloat = 1.0
    @State private var haloOpacity: Double = 0.85

    var body: some View {
        ZStack {
            Halo.bg.ignoresSafeArea()

            // Ambient blobs
            Circle()
                .fill(Halo.rose.opacity(0.18))
                .frame(width: 340, height: 340)
                .blur(radius: 60)
                .offset(x: -80, y: -170)
            Circle()
                .fill(Halo.accent.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: 110, y: 190)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    // ── Floating halo ring ──
                    ZStack {
                        Ellipse()
                            .stroke(Color(hex: "#d4a090"), lineWidth: 2.2)
                            .frame(width: 130, height: 23)
                        Ellipse()
                            .stroke(Color(hex: "#d4a090").opacity(0.35), lineWidth: 1)
                            .frame(width: 88, height: 15)
                    }
                    .scaleEffect(haloScale)
                    .opacity(haloOpacity)
                    .shadow(color: Color(hex: "#d4a090").opacity(0.35), radius: 12)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.8)
                            .repeatForever(autoreverses: true)
                        ) {
                            haloScale  = 1.07
                            haloOpacity = 1.0
                        }
                    }
                    .padding(.bottom, 20)

                    Text("HALO")
                        .font(Halo.serif(46, weight: .light))
                        .tracking(11)
                        .foregroundColor(Halo.dark)
                        .padding(.trailing, -11)

                    Text("For the ones who can't tell you")
                        .font(.custom("Georgia", size: 8))
                        .tracking(2.0)
                        .foregroundColor(Color(hex: "#b0988a"))
                        .textCase(.uppercase)
                        .padding(.top, 4)
                }
                .opacity(logoOpacity)

                Rectangle()
                    .fill(Halo.border)
                    .frame(height: 1)
                    .padding(.horizontal, 32)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
                    .opacity(buttonsOpacity)

                VStack(spacing: 7) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            state.screen = .onboarding
                        }
                    } label: {
                        Text("BEGIN")
                            .font(Halo.sans(11, weight: .semibold))
                            .tracking(2.2)
                            .foregroundColor(Color(hex: "#faf7f2"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Halo.dark)
                            .cornerRadius(2)
                    }
                    .buttonStyle(.plain)

                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            state.screen = .dashboard
                        }
                    } label: {
                        Text("SIGN IN")
                            .font(Halo.sans(11, weight: .regular))
                            .tracking(1.8)
                            .foregroundColor(Halo.mid)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Halo.faint, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 32)
                .opacity(buttonsOpacity)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) { logoOpacity = 1 }
            withAnimation(.easeOut(duration: 0.9).delay(0.45)) { buttonsOpacity = 1 }
        }
    }
}

#Preview {
    WelcomeView().environment(AppState())
}
