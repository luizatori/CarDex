# Técnicas e Casos de Teste — CarDex

**Projeto:** CarDex                
**Tecnologia:** Flutter  
**Arquitetura:** MVVM  
**Norma Aplicada:** ISO/IEC/IEEE 29119-4

## 1. Técnicas Utilizadas
Para a derivação dos casos de teste deste projeto, foram aplicadas as seguintes técnicas formais baseadas na norma ISO 29119-4:

| Técnica | Finalidade |
| :--- | :--- |
| **Particionamento de Equivalência** | Separar classes de entradas válidas e inválidas para otimizar a cobertura. |
| **Valor Limite** | Validar o comportamento do sistema em campos vazios ou com caracteres mínimos. |
| **Transição de Estado** | Validar a mudança de estado do sistema (ex: usuário inexistente para cadastrado). |
| **Teste Baseado em Cenário** | Validar o fluxo completo de navegação entre as telas do aplicativo. |

---

## 2. Derivação das Condições e Casos de Teste

### 2.1 Fluxo de Cadastro (SignUp)

#### CT01 - Validar cadastro válido
- **Técnica:** Particionamento de Equivalência.
- **Entradas (TC01):**
  - nome: "Luiza"
  - email: "luiza@teste.com"
  - senha: "password123"
- **Resultado Esperado:** Cadastro realizado com sucesso, exibição de mensagem e navegação para Login.

#### CT02 - Validar cadastro com campos vazios
- **Técnica:** Particionamento de Equivalência + Valor Limite.
- **Entradas (TC02):**
  - nome: ""
  - email: ""
  - senha: ""
- **Resultado Esperado:** Mensagem de erro: "Preencha todos os campos."

#### CT03 - Validar e-mail inválido
- **Técnica:** Particionamento de Equivalência.
- **Entradas (TC03):**
  - email: "luizagithub.com"
- **Resultado Esperado:** Mensagem de erro: "Informe um e-mail válido."

#### CT04 - Validar cadastro duplicado
- **Técnica:** Transição de Estado.
- **Pré-condição:** Usuário "luiza@teste.com" já deve existir no sistema.
- **Resultado Esperado:** Mensagem de erro: "E-mail já cadastrado."

---

### 2.2 Fluxo de Login e Navegação

#### CT06 - Validar login válido
- **Técnica:** Particionamento de Equivalência.
- **Entradas (TC06):**
  - email: "luiza@teste.com"
  - senha: "password123"
- **Resultado Esperado:** Evento de navegação disparado: `navigationEvent = goToHome`.

#### CT07 - Validar login com campos vazios
- **Técnica:** Valor Limite.
- **Entradas (TC07):**
  - email: ""
  - senha: ""
- **Resultado Esperado:** Mensagem de erro: "Preencha e-mail e senha."

#### CT08 - Validar login inválido
- **Técnica:** Particionamento de Equivalência.
- **Entrada:** Senha incorreta ou e-mail não cadastrado.
- **Resultado Esperado:** Mensagem de erro: "E-mail ou senha inválidos."

#### CT09 - Validar navegação para Home
- **Técnica:** Teste Baseado em Cenário.
- **Cenário:** Execução de login com sucesso.
- **Resultado Esperado:** Tela Home exibida corretamente para o usuário.

---

## 3. Tabela Consolidada

| ID | Caso de Teste | Técnica Aplicada | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **TC01** | Cadastro com dados válidos | Particionamento | Sucesso e navegação para Login |
| **TC02** | Cadastro com campos vazios | Valor Limite | Erro: "Preencha todos os campos" |
| **TC03** | E-mail inválido | Particionamento | Erro: "Informe um e-mail válido" |
| **TC04** | Cadastro duplicado | Transição de Estado | Erro: "E-mail já cadastrado" |
| **TC05** | Retorno ao login | Cenário | Evento: `goToLogin` |
| **TC06** | Login válido | Particionamento | Evento: `goToHome` |
| **TC07** | Login vazio | Valor Limite | Erro: "Preencha e-mail e senha" |
| **TC08** | Login inválido | Particionamento | Erro: "E-mail ou senha inválidos" |
| **TC09** | Navegação Home | Cenário | Tela Home renderizada |

---

## 4. Conclusão
Os casos de teste foram derivados utilizando técnicas formais da norma **ISO/IEC/IEEE 29119-4** e estão prontos para implementação automatizada no projeto Flutter (CarDex), garantindo a qualidade dos fluxos de autenticação.
