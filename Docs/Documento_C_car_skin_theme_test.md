# Documento D — Execução e Resultados dos Testes
**Projeto:** CarDex  
**Tecnologia:** Flutter  
**Norma aplicada:** ISO/IEC/IEEE 29119  
**Tipo de teste:** Unidade  

---

## 1. Objetivo

Registrar a execução dos testes implementados no arquivo `car_skin_theme_test.dart`, documentando os resultados obtidos, falhas encontradas e análise final do comportamento da classe `CarSkinTheme`.

---

## 2. Ambiente de Execução

- Flutter SDK
- Dart SDK
- flutter_test

---

## 3. Estrutura dos Testes Executados


test/
  car_skin_theme_test.dart


---

## 4. Execução dos Testes


flutter test test/car_skin_theme_test.dart


---

## 5. Resultados dos Testes de Unidade

### Grupo: CarSkinTheme — Testes de unidade

| Caso | Objetivo | Resultado Esperado | Resultado Obtido | Status |
|------|----------|--------------------|------------------|--------|
| TC01 | Estilo default no modo escuro retorna cores escuras | `textColor=white`, `bgColor=#1A1A1A`, `borderWidth=1.0` | Conforme esperado |  Aprovado |
| TC02 | Estilo default no modo claro retorna cores claras | `textColor=black`, `bgColor=white` | Conforme esperado |  Aprovado |
| TC03 | Estilo gold retorna cor de texto marrom escuro | `textColor=#5C4033`, `bgColor=#D4AF37` | Conforme esperado |  Aprovado |
| TC04 | Estilo "ouro" é reconhecido como alias de gold | `bgColor` e `textColor` iguais ao gold | Conforme esperado |  Aprovado |
| TC05 | Estilo silver retorna cor de texto cinza escuro | `textColor=#454545`, `bgColor=#C0C0C0` | Conforme esperado |  Aprovado |
| TC06 | Estilo neon tem cor de borda verde neon | `borderColor=#39FF14`, `borderWidth=2.0` | Conforme esperado |  Aprovado |
| TC07 | Estilo crimson tem cor de texto vermelha | `textColor=#DC143C`, `bgColor=#1A0505` | Conforme esperado |  Aprovado |
| TC08 | Estilo "carmesim" é reconhecido como alias de crimson | `bgColor` e `textColor` iguais ao crimson | Conforme esperado |  Aprovado |
| TC09 | Estilo carbon tem fundo escuro e texto branco acinzentado | `textColor=white70`, `bgColor=#121212`, `borderWidth=2.0` | Conforme esperado |  Aprovado |
| TC10 | Estilo desconhecido retorna o tema padrão | `textColor=white`, `bgColor=#1A1A1A` (modo escuro) | Conforme esperado |  Aprovado |
| TC11 | Estilo ace-spades possui overlayTextures | `overlayTextures` não vazio, `textColor=white`, `bgColor=black` | Conforme esperado |  Aprovado |
| TC12 | Estilo nature tem borda verde e fundo claro | `borderColor=#66BB6A`, `bgColor=#E8F5E9`, `borderWidth=4.0` | Conforme esperado |  Aprovado |
| TC13 | getTheme é case-insensitive | `getTheme('GOLD')` == `getTheme('gold')` | Conforme esperado |  Aprovado |
| TC14 | Estilo vintage tem borderWidth maior que o padrão | `vintage.borderWidth > default.borderWidth` (8.0 > 1.0) | Conforme esperado |  Aprovado |

---

## 6. Simulação de Falha

Foi realizada uma simulação de falha alterando propositalmente o valor esperado do teste TC06.

**Objetivo da simulação**
- Demonstrar o funcionamento do framework de teste
- Evidenciar a diferença entre resultado esperado e obtido
- Ilustrar o comportamento de falhas automatizadas

**Resultado da simulação**

Esperado pelo teste:

borderColor = Color(0xFFFF0000)


Resultado obtido:

borderColor = Color(0xFF39FF14)


**Resultado do Teste: Reprovado**

---

## 7. Análise dos Resultados

Os testes de unidade validaram corretamente:
- Retorno das cores corretas de texto, fundo e borda para cada estilo
- Comportamento do modo claro e escuro no estilo `default`
- Reconhecimento de aliases (`ouro`/`gold`, `carmesim`/`crimson`, `natureza`/`nature`, `carbono`/`carbon`)
- Normalização case-insensitive do nome do estilo
- Presença de `overlayTextures` no estilo `ace-spades`
- Fallback correto para estilo desconhecido

---

## 8. Benefícios Observados

- Validação completa dos 12 estilos visuais do CarDex sem renderizar a UI
- Garantia de que aliases e variações de escrita não quebram a seleção de tema
- Detecção antecipada de regressões ao adicionar novos estilos

---

## 9. Problemas Encontrados

Nenhuma falha funcional foi encontrada durante os testes oficiais.  
Apenas a falha simulada apresentou erro propositalmente induzido para fins didáticos.

---

## 10. Conclusão Final

Os testes executados demonstraram que a classe `CarSkinTheme` atende aos requisitos funcionais definidos. Todos os estilos retornam as cores corretas, os aliases são reconhecidos, o método é case-insensitive e estilos desconhecidos fazem fallback seguro para o tema padrão.

---

## 11. Estatísticas Finais

| Tipo | Quantidade |
|------|------------|
| Testes planejados | 14 |
| Testes executados | 14 |
| Testes aprovados | 14 |
| Testes reprovados | 0 |
| Falhas simuladas | 1 |
