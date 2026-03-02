# RF - Requisitos Funcionais

## 1. Introdução

Este documento descreve os Requisitos Funcionais do aplicativo de coleção de carros com uso de IA.

---

## 2. Lista de Requisitos Funcionais

### RF01 – Cadastro de Usuário
**Descrição:** O sistema deve permitir que o usuário realize cadastro na plataforma.  
**Prioridade:** Alta  
**Entrada:** Nome, e-mail, senha  
**Saída:** Conta criada com sucesso  
**Regra de Negócio Relacionada:** RN01  

---

### RF02 – Login de Usuário
**Descrição:** O sistema deve permitir que o usuário realize login utilizando e-mail e senha.  
**Prioridade:** Alta  
**Entrada:** E-mail e senha  
**Saída:** Acesso ao perfil do usuário  

---

### RF03 – Reconhecimento de Veículos por IA
**Descrição:** O sistema deve permitir que o usuário fotografe um veículo e utilize IA para identificá-lo. Caso contrário, deve ser exibido um pop-up com a mensagem "veículo não identificado" ou "isso não é um veículo".
**Prioridade:** Alta  
**Entrada:** Imagem capturada  
**Saída:** Identificação se a imagem se trata de um veículo.

---

### RF04 – Censura Automática de Placas
**Descrição:** O sistema deve censurar automaticamente placas de veículos detectadas na imagem.  
**Prioridade:** Alta  

---

### RF05 – Sistema de Raridade
**Descrição:** O sistema deve classificar o veículo em um nível de raridade definido pela IA.  
**Prioridade:** Média  

---

### RF06 – Personalização da Coleção
**Descrição:** O usuário deve poder adicionar nome, descrição e stickers aos veículos colecionados.  
**Prioridade:** Média  

---

### RF07 – Personalização de Perfil
**Descrição:** O usuário deve poder personalizar seu perfil utilizando widgets.  
**Prioridade:** Baixa  

---

### RF08 – Visualização de Perfis (Futuro)
**Descrição:** O sistema deve permitir que usuários visualizem perfis de outros usuários.  
**Prioridade:** Baixa  
**Status:** Funcionalidade futura  

---

## 3. Critérios de Aceitação

Cada requisito deve:
- Ser testável;
- Possuir comportamento claramente definido;
- Estar alinhado às regras de negócio do projeto.
