//
//  HomeView.swift
//  ascendiaApp
//
//  Created by Claude Code on 10/10/25.
//

import SwiftUI

// MARK: - Home View con TabView

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    if selectedTab == 0 {
                        VStack {
                            Image(systemName: "house.fill")
                                .environment(\.symbolVariants, .fill)
                            Text("Feed")
                        }
                    } else {
                        Image(systemName: "house")
                        Text("Feed")
                    }
                }
                .tag(0)

            ForosView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Foros")
                }
                .tag(1)

            MapaView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Mapa")
                }
                .tag(2)

            SeguridadView()
                .tabItem {
                    Image(systemName: "shield")
                    Text("Seguridad")
                }
                .tag(3)

            PerfilView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Perfil")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.6, green: 0.4, blue: 0.8))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Feed View

struct FeedView: View {
    @State private var searchText = ""
    @State private var isRefreshing = false
    @State private var posts: [Post] = Post.samplePosts

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // HEADER: Avatar + Nombre ASCENDIA
                    HStack(spacing: 16) {
                        // Avatar circular con inicial "A"
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)

                            Text("A")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Avatar del usuario")

                        Spacer()

                        // Nombre ASCENDIA
                        Text("ASCENDIA")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // CAMPO DE BÚSQUEDA
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))

                        TextField("Buscar publicaciones, personas…", text: $searchText)
                            .font(.system(size: 16))
                            .accessibilityLabel("Campo de búsqueda")
                            .accessibilityHint("Escribe para buscar publicaciones o personas")
                    }
                    .padding(14)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.97))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)

                    // TARJETA DE ARTÍCULOS DESTACADOS
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Artículos Destacados")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        VStack(spacing: 12) {
                            ArticleCardView(
                                title: "Guía Completa de Seguridad para Reporteras en el Campo",
                                author: "Dra. María González",
                                readTime: "5 min"
                            )

                            ArticleCardView(
                                title: "Redes de Apoyo: Cómo Construir Comunidad",
                                author: "Ana Rodríguez",
                                readTime: "3 min"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.95, green: 0.92, blue: 0.98),
                                Color(red: 0.98, green: 0.94, blue: 0.96)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(24)
                    .shadow(color: Color.purple.opacity(0.1), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Sección de artículos destacados")

                    // FEED DE POSTS
                    VStack(spacing: 16) {
                        ForEach(posts) { post in
                            PostCardView(post: post)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 8)

                    Spacer()
                        .frame(height: 20)
                }
            }
            .refreshable {
                await refreshFeed()
            }
        }
    }

    func refreshFeed() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Aquí irían las llamadas al backend
        isRefreshing = false
    }
}

// MARK: - Article Card Component

struct ArticleCardView: View {
    let title: String
    let author: String
    let readTime: String

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(author)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Pastilla de tiempo
            Text(readTime)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Artículo: \(title), por \(author), tiempo de lectura \(readTime)")
    }
}

// MARK: - Post Card Component

struct PostCardView: View {
    let post: Post
    @State private var isLiked = false
    @State private var likeCount: Int

    init(post: Post) {
        self.post = post
        _likeCount = State(initialValue: post.likes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header del post: Avatar + Info + Menú
            HStack(alignment: .top, spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(post.avatarColor)
                        .frame(width: 48, height: 48)

                    Text(post.authorInitial)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .accessibilityLabel("Avatar de \(post.author)")

                VStack(alignment: .leading, spacing: 4) {
                    // Nombre
                    Text(post.author)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                    // Badge de rol
                    HStack(spacing: 8) {
                        Text(post.role)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 0.9, green: 0.88, blue: 0.95))
                            .cornerRadius(10)

                        Text(post.timestamp)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // Botón de menú
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .rotationEffect(.degrees(90))
                }
                .accessibilityLabel("Menú de opciones del post")
            }

            // Contenido del post
            Text(post.content)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            // Imagen (si existe)
            if let imageName = post.imageName {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.9, green: 0.9, blue: 0.92))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: imageName)
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                    )
                    .accessibilityLabel("Imagen del post")
            }

            // Fila de acciones
            HStack(spacing: 20) {
                // Likes
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isLiked.toggle()
                        likeCount += isLiked ? 1 : -1

                        #if os(iOS)
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        #endif
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : Color(red: 0.4, green: 0.4, blue: 0.4))
                            .font(.system(size: 20))

                        Text("\(likeCount)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }
                .accessibilityLabel("\(isLiked ? "Quitar me gusta" : "Me gusta"), \(likeCount) me gusta")

                // Comentarios
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .font(.system(size: 20))

                        Text("\(post.comments)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }
                .accessibilityLabel("Comentarios, \(post.comments) comentarios")

                Spacer()

                // Compartir
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .font(.system(size: 20))
                }
                .accessibilityLabel("Compartir post")
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Post Model

struct Post: Identifiable {
    let id = UUID()
    let author: String
    let authorInitial: String
    let avatarColor: Color
    let role: String
    let timestamp: String
    let content: String
    let imageName: String?
    let likes: Int
    let comments: Int

    static let samplePosts: [Post] = [
        Post(
            author: "María Fernández",
            authorInitial: "M",
            avatarColor: Color(red: 0.9, green: 0.2, blue: 0.6),
            role: "Reportera Deportiva",
            timestamp: "2h",
            content: "Acabo de regresar de cubrir el partido más emocionante de la temporada. La energía en el estadio era increíble. Gracias a todas por sus mensajes de apoyo. 💪",
            imageName: "photo",
            likes: 234,
            comments: 45
        ),
        Post(
            author: "Carolina Ruiz",
            authorInitial: "C",
            avatarColor: Color(red: 0.6, green: 0.4, blue: 0.8),
            role: "Fan Verificada",
            timestamp: "4h",
            content: "¿Alguien más emocionada por el próximo torneo? He estado siguiendo a mi equipo favorito desde hace años y finalmente parece que este es nuestro año. ⚽️",
            imageName: nil,
            likes: 128,
            comments: 32
        ),
        Post(
            author: "Sofía Martínez",
            authorInitial: "S",
            avatarColor: Color(red: 0.3, green: 0.7, blue: 0.6),
            role: "Comentarista",
            timestamp: "6h",
            content: "Nuevo artículo publicado sobre las mejores estrategias defensivas de esta temporada. El análisis incluye estadísticas detalladas y entrevistas exclusivas con entrenadoras.",
            imageName: "doc.text",
            likes: 567,
            comments: 89
        )
    ]
}

// MARK: - Foros View

struct ForosView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0 // 0 = Grupos, 1 = Personas
    @State private var showFilterSheet = false
    @State private var grupos: [Grupo] = Grupo.sampleGrupos
    @State private var personas: [Persona] = Persona.samplePersonas

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // TÍTULO
                    Text("Conexiones")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                    // CAMPO DE BÚSQUEDA + BOTÓN FILTRO
                    HStack(spacing: 12) {
                        // Campo de búsqueda
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))

                            TextField("Buscar grupos o personas…", text: $searchText)
                                .font(.system(size: 16))
                                .accessibilityLabel("Campo de búsqueda")
                                .accessibilityHint("Escribe para buscar grupos o personas")
                        }
                        .padding(14)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
                        .cornerRadius(20)

                        // Botón de filtro
                        Button(action: {
                            showFilterSheet = true

                            #if os(iOS)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            #endif
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(width: 48, height: 48)
                                .background(Color(red: 0.96, green: 0.96, blue: 0.97))
                                .cornerRadius(20)
                        }
                        .accessibilityLabel("Botón de filtros")
                        .accessibilityHint("Toca para abrir opciones de filtrado")
                    }
                    .padding(.horizontal, 20)

                    // SEGMENTED CONTROL
                    HStack(spacing: 0) {
                        // Grupos
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSegment = 0
                            }

                            #if os(iOS)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            #endif
                        }) {
                            Text("Grupos")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedSegment == 0 ? .white : Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedSegment == 0 ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) : LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(20)
                        }
                        .accessibilityLabel("Segmento Grupos")
                        .accessibilityAddTraits(selectedSegment == 0 ? [.isSelected] : [])

                        // Personas
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSegment = 1
                            }

                            #if os(iOS)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            #endif
                        }) {
                            Text("Personas")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedSegment == 1 ? .white : Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedSegment == 1 ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) : LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(20)
                        }
                        .accessibilityLabel("Segmento Personas")
                        .accessibilityAddTraits(selectedSegment == 1 ? [.isSelected] : [])
                    }
                    .padding(4)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                    )
                    .cornerRadius(24)
                    .padding(.horizontal, 20)

                    // BOTÓN CREAR NUEVO GRUPO
                    if selectedSegment == 0 {
                        Button(action: {
                            #if os(iOS)
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            #endif
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.3.fill")
                                    .font(.system(size: 18))

                                Text("Crear nuevo grupo")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.6, green: 0.4, blue: 0.8),
                                        Color(red: 0.9, green: 0.2, blue: 0.6)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .accessibilityLabel("Botón crear nuevo grupo")
                        .accessibilityHint("Toca para crear un nuevo grupo")
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // CONTENIDO SEGÚN SEGMENTO
                    if selectedSegment == 0 {
                        // GRUPOS
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Grupos Activos")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .padding(.horizontal, 20)

                            ForEach(grupos) { grupo in
                                GrupoCardView(grupo: grupo)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                    } else {
                        // PERSONAS
                        VStack(alignment: .leading, spacing: 20) {
                            // TARJETA PROMOCIONAL
                            VStack(spacing: 16) {
                                Text("Encuentra acompañantes por afinidades")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                    .multilineTextAlignment(.center)

                                // CHIPS DE FILTRO
                                HStack(spacing: 10) {
                                    FilterChip(title: "Edad similar")
                                    FilterChip(title: "Misma ciudad")
                                    FilterChip(title: "Cerca de mí", icon: "location.fill")
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.95, green: 0.92, blue: 0.98),
                                        Color(red: 0.98, green: 0.94, blue: 0.96)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(24)
                            .shadow(color: Color.purple.opacity(0.1), radius: 10, x: 0, y: 4)
                            .padding(.horizontal, 20)
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Filtros de búsqueda de personas")

                            // CONEXIONES SUGERIDAS
                            Text("Conexiones Sugeridas")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .padding(.horizontal, 20)

                            ForEach(personas) { persona in
                                PersonaCardView(persona: persona)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }

                    Spacer()
                        .frame(height: 20)
                }
            }
            .refreshable {
                await refreshGrupos()
            }
        }
    }

    func refreshGrupos() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Aquí irían las llamadas al backend
    }
}

// MARK: - Grupo Card Component

struct GrupoCardView: View {
    let grupo: Grupo
    @State private var isJoined = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            grupoHeader
            grupoDescripcion
            grupoMetadatos
            grupoAcciones
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    private var grupoHeader: some View {
        HStack(alignment: .top) {
            Text(grupo.titulo)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .lineLimit(2)

            Spacer()

            Text(grupo.categoria)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(grupo.categoriaColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(grupo.categoriaColor.opacity(0.15))
                .cornerRadius(12)
        }
    }

    private var grupoDescripcion: some View {
        Text(grupo.descripcion)
            .font(.system(size: 14))
            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            .lineLimit(2)
    }

    private var grupoMetadatos: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("\(grupo.miembros)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .accessibilityLabel("\(grupo.miembros) miembros")

            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text(grupo.ultimaActividad)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .accessibilityLabel("Activo hace \(grupo.ultimaActividad)")

            Spacer()
        }
        .padding(.top, 4)
    }

    private var grupoAcciones: some View {
        HStack(spacing: 12) {
            botonUnirse
            botonVerChat
        }
        .padding(.top, 8)
    }

    private var botonUnirse: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isJoined.toggle()
            }

            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 6) {
                Image(systemName: isJoined ? "checkmark" : "plus")
                    .font(.system(size: 14, weight: .semibold))

                Text(isJoined ? "Unido" : "Unirse")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(botonUnirseBackground)
            .cornerRadius(14)
        }
        .accessibilityLabel(isJoined ? "Unido al grupo" : "Unirse al grupo")
        .accessibilityHint(isJoined ? "Toca para salir del grupo" : "Toca para unirte al grupo")
    }

    private var botonUnirseBackground: some ShapeStyle {
        if isJoined {
            return AnyShapeStyle(Color(red: 0.2, green: 0.7, blue: 0.3))
        } else {
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.8),
                    Color(red: 0.9, green: 0.2, blue: 0.6)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            ))
        }
    }

    private var botonVerChat: some View {
        Button(action: {
            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 14))

                Text("Ver chat")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
            )
            .cornerRadius(14)
        }
        .accessibilityLabel("Ver chat del grupo")
        .accessibilityHint("Toca para abrir el chat del grupo")
    }
}

// MARK: - Grupo Model

struct Grupo: Identifiable {
    let id = UUID()
    let titulo: String
    let descripcion: String
    let categoria: String
    let categoriaColor: Color
    let miembros: Int
    let ultimaActividad: String

    static let sampleGrupos: [Grupo] = [
        Grupo(
            titulo: "Ir juntas al estadio",
            descripcion: "Organizamos salidas grupales a partidos y eventos deportivos. ¡Seguridad en números!",
            categoria: "Eventos",
            categoriaColor: Color(red: 0.9, green: 0.2, blue: 0.6),
            miembros: 127,
            ultimaActividad: "2h"
        ),
        Grupo(
            titulo: "Análisis táctico semanal",
            descripcion: "Discutimos estrategias, formaciones y jugadas. Para las que aman el análisis del juego.",
            categoria: "Deportes",
            categoriaColor: Color(red: 0.2, green: 0.6, blue: 0.9),
            miembros: 89,
            ultimaActividad: "45min"
        ),
        Grupo(
            titulo: "Fans de las Tigres",
            descripcion: "Espacio dedicado a seguir y apoyar al equipo Tigres Femenil. ¡Vamos Amazonas!",
            categoria: "Equipos",
            categoriaColor: Color(red: 0.95, green: 0.6, blue: 0.1),
            miembros: 342,
            ultimaActividad: "15min"
        ),
        Grupo(
            titulo: "Red de apoyo zona norte",
            descripcion: "Compartimos rutas seguras, recomendaciones y acompañamiento para asistir a eventos.",
            categoria: "Seguridad",
            categoriaColor: Color(red: 0.2, green: 0.7, blue: 0.3),
            miembros: 256,
            ultimaActividad: "1h"
        )
    ]
}

// MARK: - Filter Chip Component

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    @State private var isSelected = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isSelected.toggle()
            }

            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color(red: 0.6, green: 0.4, blue: 0.8))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                isSelected ?
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.4, blue: 0.8),
                        Color(red: 0.9, green: 0.2, blue: 0.6)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.white]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: isSelected ? 0 : 1.5)
            )
            .cornerRadius(18)
        }
        .accessibilityLabel("Filtro: \(title)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Persona Card Component

struct PersonaCardView: View {
    let persona: Persona
    @State private var isConnected = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            personaHeader
            personaIntereses
            personaAcciones
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    private var personaHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(persona.avatarColor)
                    .frame(width: 56, height: 56)

                Text(persona.inicial)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .accessibilityLabel("Avatar de \(persona.nombre)")

            VStack(alignment: .leading, spacing: 4) {
                Text(persona.nombre)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                HStack(spacing: 4) {
                    Text("\(persona.edad)")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                    Text("•")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                    Text(persona.ciudad)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }
            }

            Spacer()

            // Badge de compatibilidad
            Text("\(persona.compatibilidad)%")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(red: 0.9, green: 0.98, blue: 0.92))
                .cornerRadius(12)
                .accessibilityLabel("\(persona.compatibilidad) por ciento compatible")
        }
    }

    private var personaIntereses: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(persona.intereses, id: \.self) { interes in
                    Text(interes)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.95, green: 0.92, blue: 0.98))
                        .cornerRadius(10)
                }
            }
        }
        .accessibilityLabel("Intereses: \(persona.intereses.joined(separator: ", "))")
    }

    private var personaAcciones: some View {
        HStack(spacing: 12) {
            botonConectar
            botonMensaje
        }
    }

    private var botonConectar: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isConnected.toggle()
            }

            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 6) {
                Image(systemName: isConnected ? "checkmark" : "person.badge.plus")
                    .font(.system(size: 14))

                Text(isConnected ? "Conectado" : "Conectar")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(botonConectarBackground)
            .cornerRadius(14)
        }
        .accessibilityLabel(isConnected ? "Conectado con \(persona.nombre)" : "Conectar con \(persona.nombre)")
        .accessibilityHint(isConnected ? "Toca para desconectar" : "Toca para enviar solicitud de conexión")
    }

    private var botonConectarBackground: some ShapeStyle {
        if isConnected {
            return AnyShapeStyle(Color(red: 0.2, green: 0.7, blue: 0.3))
        } else {
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.8),
                    Color(red: 0.9, green: 0.2, blue: 0.6)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            ))
        }
    }

    private var botonMensaje: some View {
        Button(action: {
            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 6) {
                Image(systemName: "message.fill")
                    .font(.system(size: 14))

                Text("Mensaje")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
            )
            .cornerRadius(14)
        }
        .accessibilityLabel("Enviar mensaje a \(persona.nombre)")
        .accessibilityHint("Toca para abrir chat")
    }
}

// MARK: - Persona Model

struct Persona: Identifiable {
    let id = UUID()
    let nombre: String
    let inicial: String
    let avatarColor: Color
    let edad: Int
    let ciudad: String
    let compatibilidad: Int
    let intereses: [String]

    static let samplePersonas: [Persona] = [
        Persona(
            nombre: "Ana López",
            inicial: "A",
            avatarColor: Color(red: 0.9, green: 0.2, blue: 0.6),
            edad: 28,
            ciudad: "Monterrey",
            compatibilidad: 95,
            intereses: ["Tigres", "Análisis", "Fútbol", "Estadios"]
        ),
        Persona(
            nombre: "Laura Martínez",
            inicial: "L",
            avatarColor: Color(red: 0.6, green: 0.4, blue: 0.8),
            edad: 32,
            ciudad: "San Pedro",
            compatibilidad: 88,
            intereses: ["Deportes", "Viajes", "Estadios", "Seguridad"]
        ),
        Persona(
            nombre: "Sofía Ramírez",
            inicial: "S",
            avatarColor: Color(red: 0.2, green: 0.6, blue: 0.9),
            edad: 26,
            ciudad: "Monterrey",
            compatibilidad: 92,
            intereses: ["Tigres", "Equipos", "Eventos", "Viajes"]
        ),
        Persona(
            nombre: "Carmen Hernández",
            inicial: "C",
            avatarColor: Color(red: 0.95, green: 0.6, blue: 0.1),
            edad: 30,
            ciudad: "Guadalupe",
            compatibilidad: 85,
            intereses: ["Fútbol", "Análisis", "Deportes", "Comunidad"]
        )
    ]
}

// MARK: - Mapa View

struct MapaView: View {
    @State private var isLocationSharingEnabled = true
    @State private var showFilterSheet = false
    @State private var contactosVivos: [ContactoVivo] = ContactoVivo.sampleContactos
    @State private var puntosSeguros: [PuntoSeguro] = PuntoSeguro.samplePuntos

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con degradado suave
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.92, blue: 0.98),
                        Color(red: 0.98, green: 0.94, blue: 0.96)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // HEADER: Título + Botón filtro
                        HStack {
                            Text("Mapa Seguro")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                            Spacer()

                            Button(action: {
                                showFilterSheet = true

                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                #endif
                            }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                            }
                            .accessibilityLabel("Botón de filtros del mapa")
                            .accessibilityHint("Toca para filtrar elementos del mapa")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // TARJETA DE COMPARTIR UBICACIÓN
                        HStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Compartir ubicación en vivo")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                                Text(isLocationSharingEnabled ? "Visible para tus contactos" : "Desactivado")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Toggle("", isOn: $isLocationSharingEnabled)
                                .labelsHidden()
                                .tint(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .onChange(of: isLocationSharingEnabled) { _, _ in
                                    #if os(iOS)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    #endif
                                }
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.purple.opacity(0.1), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Compartir ubicación en vivo, \(isLocationSharingEnabled ? "activado" : "desactivado")")

                        // MAPA PLACEHOLDER CON PIN Y AVATARES
                        ZStack {
                            // Fondo del mapa
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: 0.92, green: 0.94, blue: 0.96))
                                .frame(height: 320)

                            // Texto placeholder para el mapa
                            VStack(spacing: 12) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.3))

                                Text("Vista del Mapa")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.5))
                            }

                            // Pin del usuario (centro)
                            VStack {
                                Spacer()
                                    .frame(height: 140)

                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 0.6, green: 0.4, blue: 0.8),
                                                    Color(red: 0.9, green: 0.2, blue: 0.6)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 48, height: 48)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                        .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 4)

                                    Image(systemName: "person.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                                .accessibilityLabel("Tu ubicación actual")

                                Spacer()
                            }

                            // Avatares de contactos (simulados alrededor)
                            VStack {
                                HStack {
                                    miniAvatarContacto(inicial: "M", color: Color(red: 0.9, green: 0.2, blue: 0.6))
                                        .offset(x: 30, y: 50)

                                    Spacer()

                                    miniAvatarContacto(inicial: "L", color: Color(red: 0.6, green: 0.4, blue: 0.8))
                                        .offset(x: -40, y: 30)
                                }
                                .padding(.top, 20)

                                Spacer()

                                HStack {
                                    miniAvatarContacto(inicial: "S", color: Color(red: 0.2, green: 0.6, blue: 0.9))
                                        .offset(x: 50, y: -40)

                                    Spacer()
                                }
                                .padding(.bottom, 30)
                            }
                            .padding(.horizontal, 30)
                        }
                        .padding(.horizontal, 20)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Vista del mapa con tu ubicación y contactos cercanos")

                        // FAB + BOTONES DE ACCIÓN
                        HStack(spacing: 12) {
                            // Botón Zona Segura
                            Button(action: {
                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                #endif
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "shield.checkered")
                                        .font(.system(size: 16))

                                    Text("Zona Segura")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .accessibilityLabel("Botón zona segura")
                            .accessibilityHint("Toca para ver zonas seguras cercanas")

                            // Botón Ver Grupo
                            Button(action: {
                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                #endif
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.3.fill")
                                        .font(.system(size: 16))

                                    Text("Ver Grupo")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                                )
                                .cornerRadius(16)
                            }
                            .accessibilityLabel("Botón ver grupo")
                            .accessibilityHint("Toca para ver tu grupo de contactos")

                            Spacer()

                            // FAB (Floating Action Button)
                            Button(action: {
                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                #endif
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                                Color(red: 0.9, green: 0.2, blue: 0.6)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: Color.purple.opacity(0.4), radius: 12, x: 0, y: 6)
                            }
                            .accessibilityLabel("Botón agregar")
                            .accessibilityHint("Toca para agregar un nuevo elemento al mapa")
                        }
                        .padding(.horizontal, 20)

                        // CONTACTOS EN VIVO
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contactos en Vivo")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .padding(.horizontal, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(contactosVivos) { contacto in
                                        ContactoVivoCardView(contacto: contacto)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Sección de contactos en vivo")

                        // PUNTOS SEGUROS CERCANOS
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Puntos Seguros Cercanos")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .padding(.horizontal, 20)

                            VStack(spacing: 12) {
                                ForEach(puntosSeguros) { punto in
                                    PuntoSeguroCardView(punto: punto)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Sección de puntos seguros cercanos")

                        // COMPARTIR UBICACIÓN
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Compartir Ubicación")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .padding(.horizontal, 20)

                            VStack(spacing: 12) {
                                // Botón Invitar Contactos
                                Button(action: {
                                    #if os(iOS)
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    #endif
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 20))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Invitar contactos a compartir ubicación")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                                            Text("Añade personas de confianza")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                                }
                                .accessibilityLabel("Invitar contactos a compartir ubicación")
                                .accessibilityHint("Toca para invitar personas de confianza")

                                // Botón Configurar Permisos
                                Button(action: {
                                    #if os(iOS)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    #endif
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "gear")
                                            .font(.system(size: 20))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Configurar permisos de ubicación")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                                            Text("Controla quién ve tu ubicación")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                                }
                                .accessibilityLabel("Configurar permisos de ubicación")
                                .accessibilityHint("Toca para controlar quién ve tu ubicación")
                            }
                            .padding(.horizontal, 20)
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Sección de compartir ubicación")

                        // ALERTA DE EMERGENCIA
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.95, green: 0.4, blue: 0.3))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Información de Emergencia")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                                Text("En caso de emergencia, mantén presionado el botón de pánico para alertar a tus contactos y autoridades.")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .lineSpacing(2)
                            }
                        }
                        .padding(18)
                        .background(Color(red: 1.0, green: 0.95, blue: 0.93))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 0.95, green: 0.4, blue: 0.3).opacity(0.3), lineWidth: 1.5)
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Alerta de emergencia: En caso de emergencia, mantén presionado el botón de pánico")

                        Spacer()
                            .frame(height: 20)
                    }
                }
                .refreshable {
                    await refreshMapa()
                }
            }
        }
    }

    // MARK: - Mini Avatar Helper
    private func miniAvatarContacto(inicial: String, color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)

            Text(inicial)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .accessibilityLabel("Contacto \(inicial)")
    }

    func refreshMapa() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Aquí irían las llamadas al backend para actualizar ubicaciones
    }
}

// MARK: - Contacto Vivo Card Component

struct ContactoVivoCardView: View {
    let contacto: ContactoVivo

    var body: some View {
        VStack(spacing: 10) {
            // Avatar
            ZStack {
                Circle()
                    .fill(contacto.avatarColor)
                    .frame(width: 56, height: 56)

                Text(contacto.inicial)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                // Badge de estado activo
                Circle()
                    .fill(Color(red: 0.2, green: 0.7, blue: 0.3))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: 20, y: 20)
            }
            .accessibilityLabel("Avatar de \(contacto.nombre)")

            // Nombre
            Text(contacto.nombre)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .lineLimit(1)

            // Ubicación
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text(contacto.ubicacion)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            // Distancia
            Text(contacto.distancia)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(red: 0.95, green: 0.92, blue: 0.98))
                .cornerRadius(10)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .frame(width: 130)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(contacto.nombre), en \(contacto.ubicacion), a \(contacto.distancia)")
    }
}

// MARK: - Contacto Vivo Model

struct ContactoVivo: Identifiable {
    let id = UUID()
    let nombre: String
    let inicial: String
    let avatarColor: Color
    let ubicacion: String
    let distancia: String

    static let sampleContactos: [ContactoVivo] = [
        ContactoVivo(
            nombre: "María",
            inicial: "M",
            avatarColor: Color(red: 0.9, green: 0.2, blue: 0.6),
            ubicacion: "Centro",
            distancia: "0.8 km"
        ),
        ContactoVivo(
            nombre: "Laura",
            inicial: "L",
            avatarColor: Color(red: 0.6, green: 0.4, blue: 0.8),
            ubicacion: "San Pedro",
            distancia: "1.2 km"
        ),
        ContactoVivo(
            nombre: "Sofía",
            inicial: "S",
            avatarColor: Color(red: 0.2, green: 0.6, blue: 0.9),
            ubicacion: "Monterrey",
            distancia: "2.4 km"
        ),
        ContactoVivo(
            nombre: "Carmen",
            inicial: "C",
            avatarColor: Color(red: 0.95, green: 0.6, blue: 0.1),
            ubicacion: "Guadalupe",
            distancia: "3.1 km"
        )
    ]
}

// MARK: - Punto Seguro Card Component

struct PuntoSeguroCardView: View {
    let punto: PuntoSeguro

    var body: some View {
        HStack(spacing: 14) {
            // Ícono
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(punto.iconoColor.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: punto.icono)
                    .font(.system(size: 24))
                    .foregroundColor(punto.iconoColor)
            }
            .accessibilityLabel("Ícono de \(punto.tipo)")

            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(punto.nombre)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    // Tipo
                    Text(punto.tipo)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(punto.iconoColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(punto.iconoColor.opacity(0.15))
                        .cornerRadius(8)

                    // Distancia
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)

                        Text(punto.distancia)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }

                Text(punto.direccion)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .lineLimit(1)
            }

            Spacer()

            // Botón de acción
            Button(action: {
                #if os(iOS)
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                #endif
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            .accessibilityLabel("Ver detalles de \(punto.nombre)")
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(punto.tipo): \(punto.nombre), a \(punto.distancia), \(punto.direccion)")
    }
}

// MARK: - Punto Seguro Model

struct PuntoSeguro: Identifiable {
    let id = UUID()
    let nombre: String
    let tipo: String
    let icono: String
    let iconoColor: Color
    let distancia: String
    let direccion: String

    static let samplePuntos: [PuntoSeguro] = [
        PuntoSeguro(
            nombre: "Comisaría Norte",
            tipo: "Policía",
            icono: "shield.fill",
            iconoColor: Color(red: 0.2, green: 0.4, blue: 0.8),
            distancia: "400 m",
            direccion: "Av. Constitución 1234"
        ),
        PuntoSeguro(
            nombre: "Hospital San José",
            tipo: "Hospital",
            icono: "cross.fill",
            iconoColor: Color(red: 0.95, green: 0.3, blue: 0.3),
            distancia: "650 m",
            direccion: "Calle Hidalgo 567"
        ),
        PuntoSeguro(
            nombre: "Farmacia Benavides 24h",
            tipo: "Farmacia",
            icono: "staroflife.fill",
            iconoColor: Color(red: 0.2, green: 0.7, blue: 0.3),
            distancia: "220 m",
            direccion: "Av. Juárez 890"
        )
    ]
}

// MARK: - Seguridad View

struct SeguridadView: View {
    @State private var isEmergencyActive = false
    @State private var contactosEmergencia: [ContactoEmergencia] = ContactoEmergencia.sampleContactos

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con degradado suave lila
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.92, blue: 0.98),
                        Color(red: 0.98, green: 0.94, blue: 0.96)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // ENCABEZADO CON DEGRADADO ROJO→ROSADO
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Emergencia")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)

                                Text(isEmergencyActive ? "Ayuda en camino" : "Presiona el botón para activar ayuda inmediata")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(2)
                            }

                            Spacer()
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.95, green: 0.3, blue: 0.3),
                                    Color(red: 0.95, green: 0.5, blue: 0.6)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Alerta de emergencia: \(isEmergencyActive ? "Ayuda en camino" : "Presiona el botón para activar ayuda inmediata")")

                        if !isEmergencyActive {
                            // ESTADO INACTIVO
                            inactivoEstado
                        } else {
                            // ESTADO EMERGENCIA ACTIVA
                            emergenciaActivaEstado
                        }

                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
        }
    }

    // MARK: - Estado Inactivo

    private var inactivoEstado: some View {
        VStack(spacing: 20) {
            // BOTÓN PRINCIPAL DE EMERGENCIA
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isEmergencyActive = true
                }

                #if os(iOS)
                let impact = UINotificationFeedbackGenerator()
                impact.notificationOccurred(.warning)
                #endif
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 24, weight: .bold))

                    Text("¡EMERGENCIA! Presiona para llamar al 911")
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color(red: 0.95, green: 0.3, blue: 0.3))
                .cornerRadius(20)
                .shadow(color: Color.red.opacity(0.4), radius: 12, x: 0, y: 6)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel("Botón de emergencia")
            .accessibilityHint("Toca para activar emergencia y llamar al 911")

            // TARJETA CONTACTOS DE EMERGENCIA
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                    Text("Contactos de Emergencia")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }

                Text("Se enviará tu ubicación por SMS a estos contactos")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .lineSpacing(2)

                // FILA DE AVATARES
                HStack(spacing: -8) {
                    ForEach(contactosEmergencia.prefix(3)) { contacto in
                        ZStack {
                            Circle()
                                .fill(contacto.avatarColor)
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )

                            Text(contacto.inicial)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Contacto \(contacto.nombre)")
                    }

                    if contactosEmergencia.count > 3 {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.7, green: 0.7, blue: 0.7))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )

                            Text("+\(contactosEmergencia.count - 3)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("\(contactosEmergencia.count - 3) contactos más")
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.3), lineWidth: 1.5)
            )
            .cornerRadius(20)
            .shadow(color: Color.purple.opacity(0.08), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Contactos de emergencia")

            // TARJETA INFORMATIVA CON 3 PASOS
            VStack(alignment: .leading, spacing: 18) {
                Text("¿Qué sucede cuando presionas el botón?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.3, blue: 0.3))

                VStack(alignment: .leading, spacing: 14) {
                    pasoInformativo(numero: "1", texto: "Se llama automáticamente al 911")
                    pasoInformativo(numero: "2", texto: "Se envía tu ubicación por SMS a tus contactos")
                    pasoInformativo(numero: "3", texto: "Se activa el seguimiento en tiempo real")
                }
            }
            .padding(20)
            .background(Color(red: 1.0, green: 0.95, blue: 0.95))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.95, green: 0.3, blue: 0.3).opacity(0.3), lineWidth: 1.5)
            )
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Información de emergencia: cuando presionas el botón se llama al 911, se envía ubicación a contactos y se activa seguimiento en tiempo real")
        }
        .transition(.opacity.combined(with: .scale))
    }

    private func pasoInformativo(numero: String, texto: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.3, blue: 0.3))
                    .frame(width: 32, height: 32)

                Text(numero)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(texto)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Paso \(numero): \(texto)")
    }

    // MARK: - Estado Emergencia Activa

    private var emergenciaActivaEstado: some View {
        VStack(spacing: 20) {
            // BOTÓN EMERGENCIA ACTIVADA CON ANIMACIÓN
            HStack(spacing: 12) {
                // Icono de sirena animado izquierdo
                Image(systemName: "light.beacon.max.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .symbolEffect(.pulse, options: .repeating)

                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 20, weight: .bold))

                        Text("EMERGENCIA ACTIVADA")
                            .font(.system(size: 18, weight: .bold))
                    }

                    Text("Ayuda en camino")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }

                // Icono de sirena animado derecho
                Image(systemName: "light.beacon.max.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .symbolEffect(.pulse, options: .repeating)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(red: 0.8, green: 0.2, blue: 0.2))
            .cornerRadius(20)
            .shadow(color: Color.red.opacity(0.5), radius: 15, x: 0, y: 8)
            .padding(.horizontal, 20)
            .accessibilityLabel("Emergencia activada, ayuda en camino")

            // TARJETA DE ESTADO CON FONDO VERDE
            VStack(alignment: .leading, spacing: 14) {
                estadoItem(icono: "checkmark.circle.fill", texto: "Llamada al 911 iniciada", color: Color(red: 0.2, green: 0.7, blue: 0.3))
                estadoItem(icono: "checkmark.circle.fill", texto: "Ubicación enviada a contactos", color: Color(red: 0.2, green: 0.7, blue: 0.3))
                estadoItem(icono: "exclamationmark.triangle.fill", texto: "Servicios de emergencia en camino", color: Color(red: 0.95, green: 0.6, blue: 0.1))
            }
            .padding(20)
            .background(Color(red: 0.95, green: 0.99, blue: 0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.2, green: 0.7, blue: 0.3).opacity(0.3), lineWidth: 1.5)
            )
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Estado de emergencia: llamada al 911 iniciada, ubicación enviada, servicios en camino")

            // TARJETA UBICACIÓN COMPARTIDA
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                    Text("Ubicación Compartida")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Estadio Universitario, Monterrey")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                    HStack(spacing: 4) {
                        Text("Lat:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)

                        Text("25.7237")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))

                        Text("•")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)

                        Text("Lng:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)

                        Text("-100.3089")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Ubicación compartida: Estadio Universitario, Monterrey, latitud 25.7237, longitud menos 100.3089")

            // BOTÓN CANCELAR EMERGENCIA
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isEmergencyActive = false
                }

                #if os(iOS)
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                #endif
            }) {
                Text("Cancelar Emergencia")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.3, blue: 0.3))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.95, green: 0.3, blue: 0.3), lineWidth: 2)
                    )
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel("Cancelar emergencia")
            .accessibilityHint("Toca para cancelar la emergencia activa")
        }
        .transition(.opacity.combined(with: .scale))
    }

    private func estadoItem(icono: String, texto: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(texto)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(texto)
    }
}

// MARK: - Contacto Emergencia Model

struct ContactoEmergencia: Identifiable {
    let id = UUID()
    let nombre: String
    let inicial: String
    let avatarColor: Color
    let telefono: String

    static let sampleContactos: [ContactoEmergencia] = [
        ContactoEmergencia(
            nombre: "María Fernández",
            inicial: "M",
            avatarColor: Color(red: 0.9, green: 0.2, blue: 0.6),
            telefono: "+52 81 1234 5678"
        ),
        ContactoEmergencia(
            nombre: "Laura Martínez",
            inicial: "L",
            avatarColor: Color(red: 0.6, green: 0.4, blue: 0.8),
            telefono: "+52 81 2345 6789"
        ),
        ContactoEmergencia(
            nombre: "Sofía Ramírez",
            inicial: "S",
            avatarColor: Color(red: 0.2, green: 0.6, blue: 0.9),
            telefono: "+52 81 3456 7890"
        ),
        ContactoEmergencia(
            nombre: "Carmen Hernández",
            inicial: "C",
            avatarColor: Color(red: 0.95, green: 0.6, blue: 0.1),
            telefono: "+52 81 4567 8901"
        ),
        ContactoEmergencia(
            nombre: "Ana López",
            inicial: "A",
            avatarColor: Color(red: 0.3, green: 0.7, blue: 0.6),
            telefono: "+52 81 5678 9012"
        )
    ]
}

// MARK: - Perfil View

struct PerfilView: View {
    @State private var selectedTab = 0 // 0 = Acerca de, 1 = Publicaciones
    @State private var isConnected = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // ENCABEZADO CON DEGRADADO PÚRPURA→FUCSIA
                    VStack(spacing: 16) {
                        // Avatar circular con borde blanco
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.9, green: 0.2, blue: 0.6),
                                            Color(red: 0.6, green: 0.4, blue: 0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)

                            Text("M")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Foto de perfil")

                        // Nombre del usuario
                        Text("María Fernández")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)

                        // Edad y ciudad
                        Text("28 • Monterrey")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))

                        // Ubicación completa
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            Text("CDMX, México")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)

                        // ESTADÍSTICAS
                        HStack(spacing: 0) {
                            estadisticaView(numero: "24", etiqueta: "Publicaciones")

                            Divider()
                                .frame(height: 40)
                                .background(Color.white.opacity(0.3))

                            estadisticaView(numero: "186", etiqueta: "Conexiones")

                            Divider()
                                .frame(height: 40)
                                .background(Color.white.opacity(0.3))

                            estadisticaView(numero: "12", etiqueta: "Eventos")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                Color(red: 0.9, green: 0.2, blue: 0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Encabezado de perfil")

                    VStack(spacing: 20) {
                        // BOTONES DE ACCIÓN
                        HStack(spacing: 12) {
                            // Botón Conectar
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    isConnected.toggle()
                                }

                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                #endif
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: isConnected ? "checkmark" : "person.fill.badge.plus")
                                        .font(.system(size: 16))

                                    Text(isConnected ? "Conectado" : "Conectar")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                                )
                                .cornerRadius(16)
                            }
                            .accessibilityLabel(isConnected ? "Conectado" : "Conectar")
                            .accessibilityHint(isConnected ? "Toca para desconectar" : "Toca para conectar")

                            // Botón Mensaje
                            Button(action: {
                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                #endif
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bubble.left.fill")
                                        .font(.system(size: 16))

                                    Text("Mensaje")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .accessibilityLabel("Enviar mensaje")
                            .accessibilityHint("Toca para abrir chat")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // SEGMENTED CONTROL
                        HStack(spacing: 0) {
                            // Acerca de
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTab = 0
                                }

                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                #endif
                            }) {
                                Text("Acerca de")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(selectedTab == 0 ? .white : Color(red: 0.6, green: 0.4, blue: 0.8))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedTab == 0 ?
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                                Color(red: 0.9, green: 0.2, blue: 0.6)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) : LinearGradient(
                                            gradient: Gradient(colors: [Color.clear, Color.clear]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                            }
                            .accessibilityLabel("Pestaña acerca de")
                            .accessibilityAddTraits(selectedTab == 0 ? [.isSelected] : [])

                            // Publicaciones
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTab = 1
                                }

                                #if os(iOS)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                #endif
                            }) {
                                Text("Publicaciones")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(selectedTab == 1 ? .white : Color(red: 0.6, green: 0.4, blue: 0.8))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedTab == 1 ?
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                                Color(red: 0.9, green: 0.2, blue: 0.6)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) : LinearGradient(
                                            gradient: Gradient(colors: [Color.clear, Color.clear]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                            }
                            .accessibilityLabel("Pestaña publicaciones")
                            .accessibilityAddTraits(selectedTab == 1 ? [.isSelected] : [])
                        }
                        .padding(4)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                        )
                        .cornerRadius(24)
                        .padding(.horizontal, 20)

                        // CONTENIDO SEGÚN PESTAÑA
                        if selectedTab == 0 {
                            acercaDeView
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                        } else {
                            publicacionesView
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }

                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.92, blue: 0.98),
                        Color(red: 0.98, green: 0.94, blue: 0.96)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }

    // MARK: - Estadística View

    private func estadisticaView(numero: String, etiqueta: String) -> some View {
        VStack(spacing: 6) {
            Text(numero)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(etiqueta)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(numero) \(etiqueta)")
    }

    // MARK: - Acerca De View

    private var acercaDeView: some View {
        VStack(spacing: 16) {
            // TARJETA BIOGRAFÍA
            VStack(alignment: .leading, spacing: 12) {
                Text("Biografía")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Text("Apasionada del fútbol femenino y seguidora de los Tigres desde hace 10 años. Me encanta el análisis táctico y compartir experiencias en el estadio con otras aficionadas. Reportera deportiva enfocada en promover el deporte femenino en México.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Biografía")

            // TARJETA INTERESES
            VStack(alignment: .leading, spacing: 16) {
                Text("Intereses")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                // Cuadrícula de chips
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    interesChip(texto: "Fútbol Femenino")
                    interesChip(texto: "Tigres UANL")
                    interesChip(texto: "Análisis Deportivo")
                    interesChip(texto: "Viajes Seguros")
                    interesChip(texto: "Estadios")
                    interesChip(texto: "Comunidad")
                }
            }
            .padding(20)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Intereses")

            // TARJETA MIEMBRO DESDE
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Miembro desde")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                    Text("Marzo 2024")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }

                Spacer()
            }
            .padding(18)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Miembro desde marzo 2024")
        }
    }

    private func interesChip(texto: String) -> some View {
        Text(texto)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.4, blue: 0.8),
                        Color(red: 0.9, green: 0.2, blue: 0.6)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .accessibilityLabel(texto)
    }

    // MARK: - Publicaciones View

    private var publicacionesView: some View {
        VStack(spacing: 16) {
            Text("Publicaciones")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            // Placeholder para publicaciones
            VStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.3))

                Text("Sin publicaciones aún")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 60)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
            .accessibilityLabel("Sin publicaciones aún")
        }
    }
}

#Preview {
    HomeView()
}
