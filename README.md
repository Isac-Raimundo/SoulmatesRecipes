# Soulmates Recipes - App de Receitas Fitness 🍳🥗

![Capa do App](URL_DA_IMAGEM_DA_CAPA_AQUI) <!--- Substitua pela URL de uma imagem de capa -->

## 📝 Descrição

**Soulmates Recipes** é um aplicativo móvel construído com Flutter, pensado para quem busca um estilo de vida mais saudável. Ele funciona como um livro de receitas digital, permitindo que usuários salvem e consultem suas receitas fitness favoritas de forma fácil e organizada.

Este projeto foi desenvolvido como uma forma de aplicar e aprofundar conhecimentos em desenvolvimento mobile com Flutter e integração com serviços de backend como o Supabase.

## ✨ Funcionalidades

- [x] **Visualização de Receitas:** Navegue por uma lista de receitas com fotos e nomes.
- [x] **Detalhes da Receita:** Toque em uma receita para ver os ingredientes e o modo de preparo completos.
- [x] **Adicionar Receitas:** Crie e salve novas receitas no banco de dados, incluindo uma foto.
- [x] **Remover Receitas:** Apague receitas que não deseja mais.
- [ ] **(Futuro) Edição de Receitas:** Modificar receitas já existentes.
- [ ] **(Futuro) Busca e Filtros:** Pesquisar receitas por nome ou dificuldade.

## 📸 Telas do Aplicativo

| Tela Principal | Detalhes da Receita |
| :---: | :---: |
| ![Tela Principal](URL_DA_IMAGEM_1_AQUI) | ![Detalhes da Receita](URL_DA_IMAGEM_2_AQUI) |

| Adicionar Receita |
| :---: |
| ![Adicionar Receita](URL_DA_IMAGEM_3_AQUI) |


## 🚀 Tecnologias Utilizadas

- **Flutter:** Framework para desenvolvimento de interfaces de usuário nativas e multiplataforma.
- **Dart:** Linguagem de programação utilizada pelo Flutter.
- **Supabase:** Plataforma de Backend-as-a-Service, utilizada para:
  - **Authentication:** (Ainda não implementado)
  - **Database:** Armazenamento das informações das receitas.
  - **Storage:** Salvamento das fotos das receitas.

## ⚙️ Como Executar o Projeto

Para rodar este projeto em sua máquina, siga os passos abaixo:

1.  **Clone o repositório:**
    ```sh
    git clone https://github.com/SEU-USUARIO/fitness.git
    cd fitness
    ```

2.  **Instale as dependências do Flutter:**
    ```sh
    flutter pub get
    ```

3.  **Configure suas credenciais do Supabase:**
    - Na pasta `lib/`, renomeie o arquivo `supabase_options.example.dart` para `supabase_options.dart`.
    - Abra o arquivo `supabase_options.dart` e preencha com a sua `url` e `anonKey` do Supabase.

4.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

---

Desenvolvido com ❤️ por [Seu Nome](https://github.com/SEU-USUARIO)
