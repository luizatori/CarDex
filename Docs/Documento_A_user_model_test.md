# Documento D — Execução e Resultados dos Testes
**Projeto:** CarDex  
**Tecnologia:** Flutter  
**Norma aplicada:** ISO/IEC/IEEE 29119  
**Tipo de teste:** Unidade  

---

## 1. Objetivo

Registrar a execução dos testes implementados no arquivo `user_model_test.dart`, documentando os resultados obtidos, falhas encontradas e análise final do comportamento do modelo `UserModel`.

---

## 2. Ambiente de Execução

- Flutter SDK
- Dart SDK
- flutter_test

---

## 3. Estrutura dos Testes Executados


test/
  user_model_test.dart


---

## 4. Execução dos Testes


flutter test test/user_model_test.dart


---

## 5. Resultados dos Testes de Unidade

### Grupo: UserModel — Testes de unidade

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC01 | UserModel criado com valores padrão corretos | `points=0`, `capturedCars=[]` | Conforme esperado |  Aprovado |
| TC02 | UserModel criado com pontos e carros capturados | `points=150`, `capturedCars.length=3`, lista contém `'car_2'` | Conforme esperado |  Aprovado |
| TC03 | toMap serializa os campos corretamente | `map` contém `uid`, `email`, `username`, `points`, `capturedCars` | Conforme esperado |  Aprovado |
| TC04 | toMap de usuário novo tem lista de carros vazia | `capturedCars=[]`, `points=0` | Conforme esperado |  Aprovado |

---

## 6. Simulação de Falha

Foi realizada uma simulação de falha alterando propositalmente o valor esperado do teste TC01.

**Objetivo da simulação**
- Demonstrar o funcionamento do framework de teste
- Evidenciar a diferença entre resultado esperado e obtido
- Ilustrar o comportamento de falhas automatizadas

**Resultado da simulação**

Esperado pelo teste:

points = 10


Resultado obtido:

points = 0


**Resultado do Teste: Reprovado**

---

## 7. Análise dos Resultados

Os testes de unidade validaram corretamente:
- Criação do `UserModel` com valores padrão (`points=0`, lista vazia)
- Criação com dados preenchidos e verificação dos valores
- Serialização completa via `toMap`, confirmando que todos os campos necessários para o Firestore estão presentes

---

## 8. Benefícios Observados

- Validação isolada do modelo de usuário sem necessidade de Firebase ou autenticação real
- Execução rápida e previsível
- Garantia de que o contrato de dados com o Firestore está correto antes de qualquer integração

---

## 9. Problemas Encontrados

Nenhuma falha funcional foi encontrada durante os testes oficiais.  
Apenas a falha simulada apresentou erro propositalmente induzido para fins didáticos.

---

## 10. Conclusão Final

Os testes executados demonstraram que o modelo `UserModel` atende aos requisitos funcionais definidos. A criação com valores padrão e a serialização via `toMap` funcionam conforme esperado, garantindo a integridade dos dados do usuário com o Firestore.

---

## 11. Estatísticas Finais

| Tipo | Quantidade |
|------|------------|
| Testes planejados | 4 |
| Testes executados | 4 |
| Testes aprovados | 4 |
| Testes reprovados | 0 |
| Falhas simuladas | 1 |
