# Cronograma de Entregas do Projeto

**Individual**

| Data      | Entrega                    | Descrição             |
| --------- | -------------------------- | --------------------- |
| **05/06** | [x] Catálogo de Entidades  | Catalogo              |
| **05/06** | [x] Formulários simples    | Formulários simples   |
| **12/06** | [x] 1 CRUD simples         | CRUD simples          |
| **19/06** | [x] 3 ou mais CRUD simples | todos CRUD simples    |
| **26/06** | [x] 1 CRUD com associação  | todos CRUD associação |
| **26/07** | [x] 3 CRUD com associação  | todos CRUD associação |

**Equipe**

| Data      | Entrega                                         | Descrição                |
| --------- | ----------------------------------------------- | ------------------------ |
| **05/06** | [x] 5 formulários simples com rotas funcionando | Formulário simples       |
| **12/06** | [x] 1 CRUD simples por integrante               | CRUD simples COMPLETOS   |
| **26/06** | [x] 1 CRUD associação                           | 3 CRUD simples COMPLETOS |

---

## Projeto – Desenvolvimento Flutter com IA

**Pontuação de Complexidade mínima: 26 pontos**
| Critério | Pontos | Descrição |
|---------|--------|-----------|
| **Cadastro simples** | 1 ponto (máx. 5) | CRUD básico, sem relações entre entidades. <br>Ex.: cadastro de produtos, clientes. |
| **Cadastro com associação (1:N)** | 3 pontos | Relacionamento pai-filho. <br>Ex.: cliente → pedidos. |
| **Cadastro com associação (N:N)** | 6 pontos | Cadastro com tabela intermediária (relacionamento muitos-para-muitos). <br>Ex.: aluno ↔ disciplinas. |
| **Consumo de API externa com persistência local e remota sincronizada** | 3 pontos | Consumo de dados externos (via `http`, `dio` etc.) com salvamento local (`Hive`, `SQLite`) e/ou remoto (Firebase). |
| **Notificações (locais ou push)** | 1 ponto | Ex.: `flutter_local_notifications`, Firebase Messaging. |
| **Chamada externa de aplicativos** | 1 ponto | Abertura de apps como e-mail, telefone, WhatsApp ou navegador. <br>Ex.: `url_launcher`. |
| **Organização em camadas (MVC, MVVM ou similar)** | 2 pontos | Separação entre interface, lógica de negócio e dados. <br>Ex.: uso de controllers, services, models. |
| **Integração com mapas, geolocalização ou sensores** | 3 pontos | Uso de recursos do dispositivo. <br>Ex.: `google_maps_flutter`, `geolocator`, `camera`, `sensor_plus`. |
| **Dashboard com gráficos dinâmicos** | 3 pontos | Gráficos que representam dados atualizados. <br>Ex.: `fl_chart`, `syncfusion_flutter_charts`. |
| **Relatórios com filtros e agrupamentos** | 2 pontos | Relatórios interativos com filtros por data, categoria etc. |
| **Componentização com campo de opções inteligentes** | 2 pontos | Campos com busca otimizada, cadastro rápido e atualização automática. <br>Ex.: `DropdownSearch`, `autocomplete`, `TextFormField` + `showDialog`. |
| **CI/CD – Integração e entrega contínua** | 8 pontos | Integração contínua com GitHub Actions e distribuição contínua com Firebase App Distribution. |

---

> ⚠️ É obrigatório ter pelo menos **uma funcionalidade** com persistência associativa.
