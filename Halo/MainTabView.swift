import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    enum Tab { case home, meds, calendar, vitals, pack }

    var body: some View {
        ZStack(alignment: .bottom) {
            Halo.bg.ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:     DashboardView()
                case .meds:     MedicationsView()
                case .calendar: CalendarView()
                case .vitals:   VitalsView()
                case .pack:     CarersPackView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 62)

            // ── Nav bar ──
            VStack(spacing: 0) {
                // Subtle top separator + very soft rose glow when anything is active
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Halo.rose.opacity(0.08), Color.clear],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(height: 1)

                HStack(spacing: 0) {
                    NavItem(icon: "house",         fillIcon: "house.fill",         label: "Home",     tab: .home,     selected: $selectedTab)
                    NavItem(icon: "pill",           fillIcon: "pill.fill",          label: "Meds",     tab: .meds,     selected: $selectedTab)
                    NavItem(icon: "calendar",       fillIcon: "calendar",           label: "Calendar", tab: .calendar, selected: $selectedTab)
                    NavItem(icon: "heart.circle",   fillIcon: "heart.circle.fill",  label: "Vitals",   tab: .vitals,   selected: $selectedTab)
                    NavItem(icon: "bag",            fillIcon: "bag.fill",           label: "Pack",     tab: .pack,     selected: $selectedTab)
                }
                .padding(.top, 6)
                .padding(.bottom, 14)
                .background(
                    Halo.bg
                        .shadow(color: Halo.dark.opacity(0.06), radius: 10, y: -4)
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct NavItem: View {
    let icon: String
    let fillIcon: String
    let label: String
    let tab: MainTabView.Tab
    @Binding var selected: MainTabView.Tab

    @State private var pressed = false

    var isOn: Bool { selected == tab }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) { selected = tab }
        } label: {
            VStack(spacing: 2) {
                ZStack {
                    // Soft rose pill behind active icon
                    if isOn {
                        Capsule()
                            .fill(Halo.roseL)
                            .frame(width: 46, height: 28)
                            .shadow(color: Halo.rose.opacity(0.3), radius: 8, y: 2)
                            .transition(.scale(scale: 0.7).combined(with: .opacity))
                    }
                    Image(systemName: isOn ? fillIcon : icon)
                        .font(.system(size: 17))
                        .foregroundColor(isOn ? Halo.dark : Halo.faint)
                        .scaleEffect(pressed ? 0.88 : (isOn ? 1.05 : 1.0))
                        .animation(.spring(response: 0.22, dampingFraction: 0.6), value: isOn)
                }
                .frame(height: 30)

                Text(label)
                    .font(Halo.sans(8.5, weight: isOn ? .semibold : .regular))
                    .foregroundColor(isOn ? Halo.dark : Halo.light)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

#Preview {
    MainTabView().environment(AppState())
}
