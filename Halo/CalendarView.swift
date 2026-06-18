import SwiftUI

struct HaloAppointment: Identifiable {
    let id = UUID()
    let day: String
    let month: String
    let title: String
    let detail: String
    let phone: String
    let tag: String
    let tagStyle: TagStyle

    enum TagStyle { case normal, vaccine, care, birthday }
}

struct CalendarView: View {
    @State private var appointments: [HaloAppointment] = [
        HaloAppointment(day: "22", month: "Jun", title: "Cardiology scan",
                        detail: "Dr. Patel · Cardiology dept", phone: "020 7123 4567",
                        tag: "in 6 days", tagStyle: .normal),
        HaloAppointment(day: "14", month: "Jul", title: "Weight check",
                        detail: "City Vets", phone: "020 8456 7890",
                        tag: "in 4 weeks", tagStyle: .normal),
        HaloAppointment(day: "3",  month: "Aug", title: "Annual Vaccination",
                        detail: "Cat Flu & Enteritis booster", phone: "020 8456 7890",
                        tag: "in 7 weeks", tagStyle: .vaccine),
        HaloAppointment(day: "20", month: "Aug", title: "Flea & Worming Treatment",
                        detail: "Frontline + Milprazon · Every 3 months", phone: "",
                        tag: "in 9 weeks", tagStyle: .care),
        HaloAppointment(day: "20", month: "Oct", title: "Angel's 7th birthday",
                        detail: "Born 20 October 2019", phone: "",
                        tag: "7 years old", tagStyle: .birthday),
    ]
    @State private var showingAdd   = false
    @State private var editingIndex: Int? = nil
    @State private var newTitle  = ""
    @State private var newDetail = ""
    @State private var newDay    = ""
    @State private var newMonth  = ""
    // Edit fields
    @State private var editTitle  = ""
    @State private var editDetail = ""
    @State private var editDay    = ""
    @State private var editMonth  = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Header ──
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Calendar")
                                .font(Halo.serif(26, weight: .light))
                                .foregroundColor(Halo.dark)
                            Text("Angel's appointments")
                                .font(Halo.sans(10))
                                .foregroundColor(Halo.light)
                        }
                        Spacer()
                        GlowTapButton(action: { withAnimation { showingAdd = true } }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Halo.dark)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(hex: "#faf7f2"))
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    ForEach(appointments.indices, id: \.self) { idx in
                        CalRow(appt: appointments[idx]) {
                            editTitle  = appointments[idx].title
                            editDetail = appointments[idx].detail
                            editDay    = appointments[idx].day
                            editMonth  = appointments[idx].month
                            withAnimation { editingIndex = idx }
                        }
                    }

                    Spacer(minLength: 80)
                }
            }
            .background(Halo.bg)

            // ── Add overlay (slide up) ──
            if showingAdd {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showingAdd = false } }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("New Appointment")
                            .font(Halo.serif(22))
                            .foregroundColor(Halo.dark)
                        Spacer()
                        Button { withAnimation { showingAdd = false } } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Halo.light)
                                .padding(8)
                                .background(Circle().fill(Halo.bg2))
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(spacing: 10) {
                        CalField(placeholder: "Title", text: $newTitle)
                        CalField(placeholder: "Details (vet, time...)", text: $newDetail)
                        HStack(spacing: 8) {
                            CalField(placeholder: "Day (e.g. 15)", text: $newDay)
                            CalField(placeholder: "Month (e.g. Jul)", text: $newMonth)
                        }
                    }

                    HStack(spacing: 10) {
                        Button("Cancel") { withAnimation { showingAdd = false } }
                            .font(Halo.sans(11))
                            .foregroundColor(Halo.mid)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Halo.faint))
                            .buttonStyle(.plain)

                        Button("Save") {
                            if !newTitle.isEmpty {
                                withAnimation(.spring(response: 0.3)) {
                                    appointments.append(HaloAppointment(
                                        day: newDay, month: newMonth,
                                        title: newTitle, detail: newDetail, phone: "",
                                        tag: "upcoming", tagStyle: .normal
                                    ))
                                }
                            }
                            newTitle = ""; newDetail = ""; newDay = ""; newMonth = ""
                            withAnimation { showingAdd = false }
                        }
                        .font(Halo.sans(11, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(newTitle.isEmpty ? Halo.faint : Halo.dark)
                        .cornerRadius(8)
                        .animation(.easeInOut(duration: 0.15), value: newTitle.isEmpty)
                        .buttonStyle(.plain)
                    }
                }
                .padding(22)
                .background(Halo.bg)
                .cornerRadius(20)
                .shadow(color: Halo.dark.opacity(0.12), radius: 30, y: -4)
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: showingAdd)
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: editingIndex)
        .overlay {
            if let idx = editingIndex {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { editingIndex = nil } }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Edit Appointment")
                                .font(Halo.serif(22))
                                .foregroundColor(Halo.dark)
                            Spacer()
                            Button { withAnimation { editingIndex = nil } } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Halo.light)
                                    .padding(8)
                                    .background(Circle().fill(Halo.bg2))
                            }
                            .buttonStyle(.plain)
                        }

                        VStack(spacing: 10) {
                            CalField(placeholder: "Title", text: $editTitle)
                            CalField(placeholder: "Details (vet, time...)", text: $editDetail)
                            HStack(spacing: 8) {
                                CalField(placeholder: "Day", text: $editDay)
                                CalField(placeholder: "Month", text: $editMonth)
                            }
                        }

                        HStack(spacing: 10) {
                            Button("Cancel") { withAnimation { editingIndex = nil } }
                                .font(Halo.sans(11))
                                .foregroundColor(Halo.mid)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Halo.faint))
                                .buttonStyle(.plain)

                            Button("Save Changes") {
                                var updated = appointments[idx]
                                updated = HaloAppointment(
                                    day: editDay.isEmpty ? updated.day : editDay,
                                    month: editMonth.isEmpty ? updated.month : editMonth,
                                    title: editTitle.isEmpty ? updated.title : editTitle,
                                    detail: editDetail,
                                    phone: updated.phone,
                                    tag: updated.tag,
                                    tagStyle: updated.tagStyle
                                )
                                withAnimation { appointments[idx] = updated }
                                withAnimation { editingIndex = nil }
                            }
                            .font(Halo.sans(11, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Halo.dark)
                            .cornerRadius(8)
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(22)
                    .background(Halo.bg)
                    .cornerRadius(20)
                    .shadow(color: Halo.dark.opacity(0.12), radius: 30, y: -4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct CalRow: View {
    let appt: HaloAppointment
    var onEdit: (() -> Void)? = nil
    @State private var pressed = false

    var tagColor: Color {
        switch appt.tagStyle {
        case .vaccine:  return Color(hex: "#7a9a6a").opacity(0.15)
        case .care:     return Color(hex: "#9a8a6a").opacity(0.15)
        case .birthday: return Halo.roseL
        default:        return Halo.roseL
        }
    }
    var tagFg: Color {
        switch appt.tagStyle {
        case .vaccine:  return Color(hex: "#5a7a4a")
        case .care:     return Color(hex: "#7a6a4a")
        case .birthday: return Halo.rose2
        default:        return Halo.rose2
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Date block
            VStack(spacing: 0) {
                Text(appt.day)
                    .font(Halo.serif(26, weight: .light))
                    .foregroundColor(pressed ? Halo.rose2 : Halo.dark)
                    .lineLimit(1)
                Text(appt.month.uppercased())
                    .font(Halo.sans(8, weight: .semibold))
                    .tracking(1.2)
                    .foregroundColor(Halo.light)
            }
            .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(appt.title)
                    .font(Halo.sans(13, weight: .medium))
                    .foregroundColor(Halo.dark)
                if !appt.detail.isEmpty {
                    Text(appt.detail)
                        .font(Halo.sans(10))
                        .foregroundColor(Halo.mid)
                }
                if !appt.phone.isEmpty {
                    Text(appt.phone)
                        .font(Halo.sans(10))
                        .foregroundColor(Halo.light)
                }
                Text(appt.tag)
                    .font(Halo.sans(9, weight: .medium))
                    .foregroundColor(tagFg)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(tagColor)
                    .cornerRadius(10)
            }
            Spacer()
            Button {
                onEdit?()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundColor(pressed ? Halo.rose2 : Halo.faint)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Halo.bg3)
        .cornerRadius(12)
        .shadow(color: pressed ? Halo.rose.opacity(0.18) : Halo.dark.opacity(0.06), radius: pressed ? 20 : 12, y: 3)
        .scaleEffect(pressed ? 0.975 : 1.0)
        .animation(.easeInOut(duration: 0.14), value: pressed)
        .padding(.horizontal, 14)
        .padding(.bottom, 8)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

struct CalField: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .font(Halo.sans(13))
            .padding(12)
            .background(Halo.bg2.opacity(0.5))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Halo.border, lineWidth: 1))
    }
}

#Preview { CalendarView() }
