# Documento D — Execução e Resultados dos Testes
**Projeto:** CarDex App  
**Tecnologia:** Flutter  
**Norma aplicada:** ISO/IEC/IEEE 29119  
**Tipo de teste:** Unidade  

---

## 1. Objetivo

Registrar a execução dos testes implementados no arquivo `auth_logic_test.dart`, documentando os resultados obtidos, falhas encontradas e análise final da lógica de geração e validação de código de verificação e das validações de campos dos formulários de login e cadastro.

---

## 2. Ambiente de Execução

- Flutter SDK
- Dart SDK
- flutter_test

---

## 3. Estrutura dos Testes Executados

```
test/
  auth_logic_test.dart
```

---

## 4. Execução dos Testes

```bash
flutter test test/auth_logic_test.dart
```

---

## 5. Resultados dos Testes de Unidade

### Grupo: RegisterScreen — lógica de código de verificação

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC01 | Código gerado tem exatamente 7 caracteres | `code.length == 7` | Conforme esperado | ✅ Aprovado |
| TC02 | Código contém apenas letras maiúsculas e dígitos | `RegExp(r'^[A-Z0-9]+$').hasMatch == true` | Conforme esperado | ✅ Aprovado |
| TC03 | Dois códigos gerados em sequência são diferentes | `code1 != code2` | Conforme esperado | ✅ Aprovado |
| TC04 | 50 códigos gerados sem caracteres inválidos | Nenhum código contém caractere fora de `[A-Z0-9]` | Conforme esperado | ✅ Aprovado |
| TC05 | Código correto valida (case-insensitive) | `isValid = true` ao comparar código em minúsculas | Conforme esperado | ✅ Aprovado |
| TC06 | Código incorreto não valida | `isValid = false` para código diferente | Conforme esperado | ✅ Aprovado |

### Grupo: LoginScreen — validação de campos (lógica isolada)

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC07 | Campos preenchidos não retornam erro | `error = null` | Conforme esperado | ✅ Aprovado |
| TC08 | Email vazio retorna mensagem de erro | `error = 'POR FAVOR, PREENCHA TODOS OS CAMPOS.'` | Conforme esperado | ✅ Aprovado |
| TC09 | Senha vazia retorna mensagem de erro | `error = 'POR FAVOR, PREENCHA TODOS OS CAMPOS.'` | Conforme esperado | ✅ Aprovado |
| TC10 | Ambos os campos vazios retornam mensagem de erro | `error != null` | Conforme esperado | ✅ Aprovado |

### Grupo: RegisterScreen — validação de campos (lógica isolada)

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC11 | Todos os campos preenchidos não retornam erro | `error = null` | Conforme esperado | ✅ Aprovado |
| TC12 | Username vazio retorna mensagem de erro | `error != null` | Conforme esperado | ✅ Aprovado |
| TC13 | Qualquer campo vazio no cadastro retorna erro | `error != null` em todos os 3 casos testados | Conforme esperado | ✅ Aprovado |

---

## 6. Simulação de Falha

Foi realizada uma simulação de falha alterando propositalmente o valor esperado do teste TC01.

**Objetivo da simulação**
- Demonstrar o funcionamento do framework de teste
- Evidenciar a diferença entre resultado esperado e obtido
- Ilustrar o comportamento de falhas automatizadas

**Resultado da simulação**

Esperado pelo teste:
```
code.length == 6
```

Resultado obtido:
```
code.length == 7
```

**Resultado do Teste: Reprovado**

---

## 7. Análise dos Resultados

Os testes de unidade validaram corretamente:
- Geração de código com tamanho exato de 7 caracteres
- Conjunto de caracteres válidos (`[A-Z0-9]`) sem exceções
- Aleatoriedade da geração (dois códigos distintos em sequência)
- Robustez da geração testada em lote com 50 amostras
- Comparação case-insensitive do código digitado pelo usuário
- Bloqueio de envio do formulário de login com campos vazios
- Bloqueio de envio do formulário de cadastro com qualquer campo vazio

---

## 8. Benefícios Observados

- Validação da lógica de geração de código sem necessidade de envio real de e-mail (EmailJS)
- Testes de formulário isolados da UI, sem necessidade de renderizar widgets
- Cobertura de múltiplos cenários de campo vazio em um único teste parametrizado (TC13)

---

## 9. Problemas Encontrados

Nenhuma falha funcional foi encontrada durante os testes oficiais.  
Apenas a falha simulada apresentou erro propositalmente induzido para fins didáticos.

---

## 10. Conclusão Final

Os testes executados demonstraram que a lógica de geração e validação de código de verificação e as validações de campos dos formulários de login e cadastro do CarDex atendem aos requisitos funcionais definidos, funcionando corretamente de forma isolada e sem dependências externas.

---

## 11. Estatísticas Finais

| Tipo | Quantidade |
|------|------------|
| Testes planejados | 13 |
| Testes executados | 13 |
| Testes aprovados | 13 |
| Testes reprovados | 0 |
| Falhas simuladas | 1 |
