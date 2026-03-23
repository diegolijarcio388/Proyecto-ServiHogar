import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `TipoServicioView`: Permite al usuario confirmar la ubicación del servicio
/// y decidir si quiere programar una cita en el calendario o solicitar un servicio urgente.
struct TipoServicioView: View {
    // Variable de entorno para gestionar el botón de retroceso nativo
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Variables de Estado
    @State private var mostrarCalendario = false // Controla la visibilidad del modal del calendario
    @State private var citaProgramada = false    // Indica si se ha confirmado una cita para una fecha futura
    @State private var citaUrgente = false       // Indica si el usuario requiere el servicio inmediatamente
    @State private var fechaSeleccionada = Date()// Almacena la fecha elegida en el DatePicker
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        ZStack {
            
            // ==========================================
            // --- FONDO COMPLETO ---
            // ==========================================
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // ==========================================
                // --- BARRA SUPERIOR AZUL ---
                // ==========================================
                HStack {
                    // Botón para volver atrás
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    
                    // Iconos de la derecha
                    HStack(spacing: 20) {
                        Image(systemName: "calendar")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.figmaBlue)
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.figmaBlue)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 80)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity)
                .background(Color.figmaLightBlue)
                .ignoresSafeArea(edges: .top) // Extiende la barra hasta el notch superior
                
                // ==========================================
                // --- CUERPO DE LA PANTALLA ---
                // ==========================================
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        Spacer().frame(height: 15)
                        
                        // --- TÍTULO UBICACIÓN ---
                        HStack(spacing: 10) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.title2)
                            Text("Ubicación")
                                .font(.title2)
                                .bold()
                        }
                        .foregroundColor(Color.figmaBlue)
                        
                        // --- TARJETA DOMICILIO ---
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "house.fill")
                                    .font(.title3)
                                Text("Domicilio")
                                    .font(.title3)
                                    .bold()
                            }
                            .foregroundColor(Color.figmaBlue)
                            
                            Text("Calle Alfareros 15, 23400 Úbeda, Jaén, España")
                                .font(.subheadline)
                                .foregroundColor(Color.figmaBlue)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 25)
                        
                        // --- IMAGEN DEL MAPA ---
                        Image("mapa")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .cornerRadius(15)
                            .padding(.horizontal, 25)
                        
                        // --- LINK OTRA UBICACIÓN ---
                        HStack {
                            Spacer()
                            Text("Otra Ubicación")
                                .font(.subheadline)
                                .underline()
                                .foregroundColor(Color.figmaBlue)
                                .onTapGesture { print("Otra Ubicación") } // TODO: Implementar navegación o acción
                        }
                        .padding(.horizontal, 30)
                        
                        // --- TARJETA TIPO DE CITA ---
                        VStack(spacing: 20) {
                            HStack(spacing: 10) {
                                Image(systemName: "calendar")
                                    .font(.title3)
                                Text("Tipo de cita")
                                    .font(.title3)
                                    .bold()
                            }
                            .foregroundColor(Color.figmaBlue)
                            
                            // Botones de selección de cita
                            HStack(spacing: 15) {
                                // 🔵 BOTÓN PROGRAMAR
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        mostrarCalendario = true
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "calendar.badge.clock")
                                            .font(.system(size: 24, weight: .bold))
                                        Text("Programar")
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    // Cambia la opacidad si está seleccionada para dar feedback visual
                                    .background(citaProgramada ? Color.figmaBlue.opacity(0.7) : Color.figmaBlue)
                                    .cornerRadius(10)
                                }
                                
                                // 🟢 BOTÓN URGENTE
                                Button(action: {
                                    withAnimation(.spring()) {
                                        citaUrgente = true
                                        citaProgramada = false // Si es urgente, cancela la cita programada
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.system(size: 22, weight: .bold))
                                        Text("Urgente")
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(citaUrgente ? Color.figmaBlue.opacity(0.7) : Color.figmaBlue)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 25)
                        
                        // ==========================================
                        // --- ÁREA DE RESPUESTA (CITA O URGENTE) ---
                        // ==========================================
                        
                        // Feedback visual si se ha programado en el calendario
                        if citaProgramada {
                            VStack(spacing: 12) {
                                HStack(spacing: 10) {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.title3)
                                    Text("Cita")
                                        .font(.title3)
                                        .bold()
                                }
                                .foregroundColor(Color.figmaBlue)
                                
                                VStack(spacing: 5) {
                                    // TODO: Formatear `fechaSeleccionada` real en un futuro
                                    Text("Fecha: 01 / 02 / 2026")
                                    Text("Hora: 17:30")
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(Color.figmaBlue)
                            }
                            .padding(20)
                            .frame(width: 220)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .transition(.scale.combined(with: .opacity)) // Animación fluida al aparecer
                        }
                        
                        // Feedback visual si es un servicio urgente
                        if citaUrgente {
                            Text("Se te cobrarán 10€ extra")
                                .font(.system(size: 16, weight: .bold).italic())
                                .foregroundColor(Color.figmaBlue)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 40)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer().frame(height: (citaProgramada || citaUrgente) ? 10 : 20)
                        
                        // --- BOTÓN SIGUIENTE ---
                        // Navega a la vista donde el usuario describe el problema
                        NavigationLink(destination: DescribirProblema()) {
                            HStack {
                                Text("Siguiente")
                                    .font(.title3.bold())
                                Image(systemName: "chevron.right")
                                    .font(.title3.bold())
                            }
                            .foregroundColor(Color.figmaBlue)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            
            // ==========================================
            // --- MODAL PERSONALIZADO DEL CALENDARIO ---
            // ==========================================
            // Se sobrepone a toda la vista utilizando el ZStack raíz
            if mostrarCalendario {
                // Fondo oscuro semitransparente
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Cierra el modal si se toca fuera de él
                        withAnimation { mostrarCalendario = false }
                    }
                
                // Tarjeta blanca del calendario
                VStack(spacing: 20) {
                    HStack(spacing: 10) {
                        Image(systemName: "calendar")
                        Text("CALENDARIO")
                            .bold()
                    }
                    .font(.headline)
                    .foregroundColor(Color.figmaBlue)
                    .padding(.top, 25)
                    
                    // Selector de fecha nativo de iOS
                    DatePicker("Selecciona una fecha", selection: $fechaSeleccionada)
                        .datePickerStyle(.graphical)
                        .tint(Color.figmaBlue)
                        .padding(.horizontal, 20)
                    
                    // Botón para confirmar fecha
                    Button(action: {
                        withAnimation(.spring()) {
                            mostrarCalendario = false
                            citaProgramada = true
                            citaUrgente = false // Apaga "Urgente" si aceptas una fecha
                        }
                    }) {
                        Text("Aceptar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.figmaBlue)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 25)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 25)
                .transition(.scale.combined(with: .opacity)) // Animación pop-up
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        TipoServicioView()
    }
}
