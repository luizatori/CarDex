# Plano de Testes: CarDex (Equipe 10)

Este documento detalha o Plano de Testes para o projeto **CarDex**, focado no desenvolvimento de sistemas móveis com integração de Inteligência Artificial para reconhecimento de veículos.

---

## 1. Requisitos Funcionais (RF) - Matriz de Rastreabilidade

| ID | Descrição do Requisito | Prioridade | Status do Requisito |
| :--- | :--- | :--- | :--- |
| **RF01** | Cadastro de Usuário (Nome, e-mail, senha) | Alta | Concluído |
| **RF02** | Login de Usuário (E-mail e senha) | Alta | Concluído |
| **RF03** | Reconhecimento de Veículos por IA | Alta | Concluído |
| **RF04** | Censura Automática de Placas | Alta | Concluído |
| **RF05** | Sistema de Raridade (Definido por IA) | Média | Concluído |
| **RF06** | Personalização da Coleção (Nome, descrição e moldura) | Média | Concluído |
| **RF07** | Personalização de Perfil (Uso de Widgets) | Alta | Concluído |
| **RF08** | Visualização de Perfis (Funcionalidade Futura) | Baixa | Pendente |
| **RF09** | Método OTP (Código de 7 dígitos via e-mail) | Alta | Concluído |
| **RF10** | Recuperação de Senha via e-mail | Alta | Concluído |

---

## 2. Casos de Teste Funcionais (CT)

### CT01 - Fluxo de Cadastro e Verificação OTP
* **Referência:** RF01, RF09
* **Prioridade:** Alta
* **Passos:**
    1. Aceder à página de registo.
    2. Preencher Nome, E-mail e Senha.
    3. Clicar em "Enviar Código".
    4. Inserir o código de 7 dígitos recebido por e-mail.
* **Resultado Esperado:** Conta criada e utilizador redirecionado para o perfil.

### CT02 - Login e Recuperação de Credenciais
* **Referência:** RF02, RF10
* **Prioridade:** Alta
* **Passos:**
    1. Tentar login com e-mail/senha válidos.
    2. Realizar Logout.
    3. Clicar em "Recuperar Senha" e validar o link enviado por e-mail.
* **Resultado Esperado:** Acesso concedido no login e redefinição concluída com sucesso.

### CT03 - Captura e Reconhecimento de Veículo
* **Referência:** RF03, RF05
* **Prioridade:** Alta
* **Passos:**
    1. Ativar a câmara dentro do aplicativo.
    2. Fotografar um veículo nítido.
    3. Aguardar o processamento da IA.
* **Resultado Esperado:** A IA deve identificar o modelo do carro e atribuir o nível de raridade.

### CT04 - Erro de Identificação (Falsos Positivos)
* **Referência:** RF03
* **Prioridade:** Média
* **Passos:**
    1. Fotografar um objeto que não seja um veículo (ex: uma árvore).
* **Resultado Esperado:** Exibição de pop-up com a mensagem "Veículo não identificado" ou "Isso não é um veículo".

### CT05 - Privacidade: Censura Automática de Placas
* **Referência:** RF04
* **Prioridade:** Alta
* **Passos:**
    1. Fotografar um veículo onde a placa esteja visível.
    2. Verificar a prévia do card gerado.
* **Resultado Esperado:** A placa deve estar censurada/borrada automaticamente na imagem.

### CT06 - Customização de Card e Perfil
* **Referência:** RF06, RF07
* **Prioridade:** Média
* **Passos:**
    1. Editar nome e descrição num card da coleção.
    2. Alterar a moldura do card.
    3. Personalizar a disposição dos widgets no perfil.
* **Resultado Esperado:** As alterações devem ser guardadas e refletidas visualmente no app.

---

## 3. Casos de Teste de Exceção (Robustez)

### CT07 - E-mail Duplicado ou Inválido
* **Referência:** RF01
* **Passos:** Tentar registar um e-mail já existente ou sem formato padrão (ex: user#gmail.com).
* **Resultado Esperado:** O sistema deve impedir o registo e mostrar erro de validação.

### CT08 - Expiração de Token OTP
* **Referência:** RF09
* **Passos:** Inserir o código de 7 dígitos após o tempo limite de expiração (ex: 15 min).
* **Resultado Esperado:** O sistema deve invalidar o código e solicitar um novo envio.

---

## 4. Requisitos Não Funcionais (RNF)

* **RNF01 (Desempenho):** O processamento da IA deve ser concluído em até 5 segundos.
* **RNF02 (Segurança):** Senhas devem ser encriptadas; Placas censuradas antes do armazenamento.
* **RNF03 (Compatibilidade):** Suporte para Android e iOS.
