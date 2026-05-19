# Desenvolvimento de Sistemas Móveis - PI
---

## Equipe 10 
- Luiza Pincitori Souza de Filippi Costa 
- Gustavo Henrique Fileni
  
## Estrutura do Repositório
- /.github - Templates de Issues e PRs;
- /docs – Requisitos;
- /lib/src – código;
- /design – protótipos;
- /assets - imagens utilizadas;
- /test - teste de software;

### Arquivos obrigatórios na raiz da aplicação Flutter
- /.gitignore;
- /.metadata;
- /analysis_options.yaml;
- /pubspec.lock;
- /pubspec.yaml;
- /firabase.json ( não é ideal estar aqui );

### Pastas Alheias do Flutter
- /android;
- /web;

# CarDex
## Objetivo do Aplicativo

Nosso aplicativo móvel tem como objetivo o entretenimento. Trata-se de uma aplicação onde os usuários podem colecionar carros vistos, funcionando como um álbum de figurinhas digital.

## As principais funcionalidades incluem:

- Uso de IA para reconhecer veículos e censurar placas automaticamente;
- Sistema de "raridade de carros", definido por IA;
- Personalização da coleção com nome, descrição e molduras;
- Criação e gerenciamento de perfil;
- Personalização de perfil por meio de widgets;
- (Futuramente) Visualização de perfis de outros usuários.

## Público-Alvo

Comunidade de carspotting e outros usuários com interesse no aplicativo.

## Problema

Suprir a falta de aplicações com essa proposta no mercado, oferecendo uma plataforma voltada à coleção com elementos gamificados.

## Empresa

Dedicada a Comunidade.

## Como Rodar a Aplicação

### Pré-requisitos
- Ter o SDK do Flutter instalado (versão estável).;
- Ter um emulador (Android/iOS) ou dispositivo físico conectado;
- VS Code com as extensões de Flutter e Dart;

### Instalação de Dependências/Execução
- Abra o terminal na raiz do projeto e execute: flutter pub get
- Com o ambiente configurado, execute o comando: flutter run 
