# Documento D — Execução e Resultados dos Testes
**Projeto:** CarDex App  
**Tecnologia:** Flutter  
**Norma aplicada:** ISO/IEC/IEEE 29119  
**Tipo de teste:** Unidade  

---

## 1. Objetivo

Registrar a execução dos testes implementados no arquivo `car_model_test.dart`, documentando os resultados obtidos, falhas encontradas e análise final do comportamento dos modelos `CarItem` e `StyleOptions`.

---

## 2. Ambiente de Execução

- Flutter SDK
- Dart SDK
- flutter_test

---

## 3. Estrutura dos Testes Executados

```
test/
  car_model_test.dart
```

---

## 4. Execução dos Testes

```bash
flutter test test/car_model_test.dart
```

---

## 5. Resultados dos Testes de Unidade

### Grupo: CarItem — Testes de unidade

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC01 | CarItem.empty cria slot vazio | `isEmpty=true`, `name=""`, `style="default"`, `isFavorite=false`, `imageUrl=null` | Conforme esperado | ✅ Aprovado |
| TC02 | isBase64 retorna false para URL curta | `isBase64=false` | Conforme esperado | ✅ Aprovado |
| TC03 | isBase64 retorna true para string base64 longa | `isBase64=true` | Conforme esperado | ✅ Aprovado |
| TC04 | isBase64 retorna false quando imageUrl é nulo | `isBase64=false` | Conforme esperado | ✅ Aprovado |
| TC05 | toMap serializa os campos corretamente | `map` contém `name`, `style`, `isFavorite`, `imageUrl` | Conforme esperado | ✅ Aprovado |
| TC06 | toMap não inclui o campo id | `map` não contém a chave `id` | Conforme esperado | ✅ Aprovado |

### Grupo: StyleOptions — Testes de unidade

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC07 | Primeiro estilo é default e não está bloqueado | `key="default"`, `locked=false`, `requiredCount=0` | Conforme esperado | ✅ Aprovado |
| TC08 | Estilos bloqueados têm requiredCount maior que zero | `requiredCount > 0` para todos os bloqueados | Conforme esperado | ✅ Aprovado |
| TC09 | Estilo neon exige 100 carros para desbloquear | `locked=true`, `requiredCount=100` | Conforme esperado | ✅ Aprovado |
| TC10 | Estilos bloqueados têm mensagem de requisito | `requirement != null` e não vazio | Conforme esperado | ✅ Aprovado |
| TC11 | ace-spades exige mais carros que neon | `ace.requiredCount > neon.requiredCount` (150 > 100) | Conforme esperado | ✅ Aprovado |

---

## 6. Simulação de Falha

Foi realizada uma simulação de falha alterando propositalmente o valor esperado do teste TC07.

**Objetivo da simulação**
- Demonstrar o funcionamento do framework de teste
- Evidenciar a diferença entre resultado esperado e obtido
- Ilustrar o comportamento de falhas automatizadas

**Resultado da simulação**

Esperado pelo teste:
```
requiredCount = 1
```

Resultado obtido:
```
requiredCount = 0
```

**Resultado do Teste: Reprovado**

---

## 7. Análise dos Resultados

Os testes de unidade validaram corretamente:
- Criação de slots vazios com `CarItem.empty`
- Detecção de imagens base64 pela propriedade `isBase64`
- Serialização dos campos via `toMap`, confirmando que o campo `id` é corretamente excluído (pois é gerenciado pelo Firestore)
- Sistema de desbloqueio de estilos: hierarquia de `requiredCount`, existência de mensagens de requisito e estilo padrão sempre disponível

---

## 8. Benefícios Observados

- Validação isolada dos modelos sem necessidade de Firebase
- Execução rápida e previsível
- Testes cobrem tanto a criação quanto a serialização dos dados, garantindo integridade com o Firestore

---

## 9. Problemas Encontrados

Nenhuma falha funcional foi encontrada durante os testes oficiais.  
Apenas a falha simulada apresentou erro propositalmente induzido para fins didáticos.

---

## 10. Conclusão Final

Os testes executados demonstraram que os modelos `CarItem` e `StyleOptions` atendem aos requisitos funcionais definidos. A lógica de `isBase64`, a serialização via `toMap` e o sistema de estilos com desbloqueio progressivo funcionam conforme esperado.

---

## 11. Estatísticas Finais

| Tipo | Quantidade |
|------|------------|
| Testes planejados | 11 |
| Testes executados | 11 |
| Testes aprovados | 11 |
| Testes reprovados | 0 |
| Falhas simuladas | 1 |
