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

// MARK: - Placeholder Views para otras tabs

struct ForosView: View {
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Foros")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Próximamente")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MapaView: View {
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Mapa")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Próximamente")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SeguridadView: View {
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Seguridad")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Próximamente")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PerfilView: View {
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Perfil")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Próximamente")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    HomeView()
}
