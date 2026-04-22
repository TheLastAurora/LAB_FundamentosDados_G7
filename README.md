# Projeto Final - Fundamentos Engenharia de Dados  
**Tema:** Entretenimento - Agência de mídia - música

**Profº:** Wesley Lourenço Barbosa

# Integrantes - Grupo 7

- Fernando Luiz
- Igor Graseffi
- João Armandes
- Vitor Ribeiro
- Victor Lira

## Desafio do Projeto

Construção de um pipeline ELT completo, avaliando a qualidade dos dados desde a ingestão (`Raw`), passando pela transformação (`Silver`/`Gold`) até a visualização.

## Storytelling

Somos uma agência de mídia (marketing) especializada na melhoria do desempenho de artistas em promover as suas músicas nos streamings de músicas (exemplo: Spotify, Deezer, Tidal, YouTube, entre outros)

Principais questionamentos (problema de negócio):

- Qual o decay médio de playback por tipo de conteúdo  ao longo de 12 semanas?
- Músicas/ artistas populares em 2024 se mantiveram? Aqueles que começaram em 2024, ascenderam? Como?
- Que combinações de features geram maior crescimento de inscritos em 60 dias?
- Existe um limiar de inscritos a partir do qual conteúdo explícito deixa de ser eficaz?

## Diagrama Storytelling

![Storytelling](Images/Storytelling_G7.png)

## Configurações realizadas

- DBT
- Great Expectatios

### Great Expectations

## Data Quality com Great Expectations

A qualidade dos dados neste projeto é garantida utilizando **Great Expectations (GE)**, integrado diretamente ao pipeline orquestrado pelo Airflow.

---

### Objetivo

As validações são aplicadas na camada **RAW**, logo após a ingestão dos dados, com o objetivo de:

- Detectar inconsistências o mais cedo possível  
- Evitar propagação de erros para as camadas analíticas (Silver e Gold)  
- Garantir confiabilidade nas análises finais no Metabase  

---

### Implementação

A validação é executada automaticamente pela DAG do Airflow na etapa:

```
validate_raw
```

Essa etapa chama o script:

```
scripts/validate_raw.py
```

O script utiliza Great Expectations para:

1. Conectar ao banco PostgreSQL  
2. Acessar a tabela `raw.artists`  
3. Definir regras de qualidade (expectations)  
4. Executar a validação  
5. Interromper o pipeline em caso de falha  

---

### Regras de Validação (Expectation Suite)

Atualmente, as seguintes validações são aplicadas à tabela `raw.artists`:

- **Tabela não vazia**  
  Garante que o processo de ingestão carregou dados corretamente  

```python
validator.expect_table_row_count_to_be_between(min_value=1)
```

- **Campo `id` obrigatório (NOT NULL)**  
  Evita registros inválidos sem identificação  

```python
validator.expect_column_values_to_not_be_null("id")
```

- **Campo `id` único**  
  Garante integridade e ausência de duplicidade  

```python
validator.expect_column_values_to_be_unique("id")
```

---

### Tratamento de Falhas

Caso alguma validação falhe:

- O Great Expectations retorna erro  
- A task `validate_raw` falha no Airflow  
- O pipeline é interrompido automaticamente  

Isso impede que dados inconsistentes avancem para as etapas de transformação (dbt).

---

### Integração com o Pipeline

Fluxo completo:

```
Extract → RAW → [Great Expectations] → dbt (Silver → Gold) → Metabase
```

---

### Escalabilidade

A arquitetura permite expansão simples das validações:

- Inclusão de novas tabelas como assets  
- Criação de novas regras de validação  
- Evolução para uso de checkpoints e Data Docs  

---

### Boas práticas aplicadas

- Validação na origem (data quality shift-left)  
- Separação entre ingestão, validação e transformação  
- Fail fast: pipeline interrompido em caso de erro  
- Estrutura preparada para evolução  

---

### Observação

Os arquivos de backup (`.tar`) não são versionados no repositório devido ao tamanho, sendo disponibilizados separadamente.

## OMDB Data Pipeline - Grupo 7

## Arquitetura

Pipeline ELT utilizando:

- Airflow (orquestração)
- PostgreSQL (armazenamento)
- Great Expectations (qualidade de dados)
- dbt (transformações)
- Metabase (visualização)

## Fluxo

1. Extract & Load → dados carregados no schema `raw`
2. Validação com Great Expectations

## Como rodar

```bash
docker compose up --build

## Diagrama arquitetura

![Diagrama](Images/Construcao_Pipeline_G7.png)

## Diagrama base de dados

![BaseDados](Images/BaseDados_G7.png)

## Execução do Pipeline

### Pré-requisitos

- Docker e Docker Compose instalados
- Git

### Subir o ambiente

```bash
# 1. Clone o repositório
git clone <repo-url> && cd LAB_FundamentosDados_G7

# 2. Copie o arquivo de variáveis de ambiente
cp .env.example .env

# 3. Suba todos os serviços
docker compose up -d --build

# 4. Aguarde os containers ficarem healthy
docker compose ps
```
### Serviços disponíveis

| Serviço           | URL                        | Credenciais                |
| ----------------- | -------------------------- | -------------------------- |
| Airflow UI        | http://localhost:8080      | admin / admin              |
| Metabase          | http://localhost:3000      | admin@omdb.local / Admin123! |
| PostgreSQL        | localhost:5432             | postgres / postgres        |

### Executar o pipeline

1. Acesse o **Airflow** em http://localhost:8080
2. Ative a DAG `omdb_pipeline`
3. Dispare manualmente (Trigger DAG) ou aguarde a execução diária
4. Acompanhe os logs de cada tarefa:
   - `extract_load` → carrega litedb.tar para `raw`
   - `validate_raw` → Great Expectations valida a raw
   - `dbt_deps` → instala pacotes dbt
   - `dbt_run` → transforma raw → silver → gold
   - `dbt_test` → executa testes

### Conectar o Metabase ao schema gold

O Metabase é configurado automaticamente ao subir os containers (via `metabase-setup`).  
Caso precise reconfigurar manualmente:

1. Acesse http://localhost:3000
2. Configure a conexão PostgreSQL:
   - Host: `postgres`, Porta: `5432`, DB: `omdb`, User: `postgres`, Pass: `postgres`
3. Crie dashboards a partir das tabelas `gold.dim_artists`, `gold.dim_albums`, `gold.fact_tracks`
  

## Vídeo de apresentação

Inserir link vídeo

## Dashboards

Inserir dashboards

## Desafios Encontrados

Inserir desafio

## Papéis e Responsabilidades

Incluir tabela participantes do grupo (com papéis e responsabilidades)

## Material de Apresentação

Incluir PPT Apresentação do Projeto

## Glossário

Inserir glossário
Em construção


## Dashboards

Dashboards em construção


## Desafios Encontrados

Em construção


## Papéis e Responsabilidades

| Integrante                   | Perfil Git      | Papel / Reponsabilidade Projeto |
|--------------------------|----------|----------|
| Fernando Luiz            | [@flg29-data](https://github.com/flg29-data)  | Documentação / Apresentação / Dashboards |
| Igor Graseffi            | Em construção  | Definição do Tema / Apresentação / Storytelling / Pipeline Dados / Dashboard |
| João Armandes             | Em construção  | Diagramas Arquitetura / Pipeline de Dados / Apresentação / Base de Dados / Dashboard |
| Vitor Ribeiro            | [@TheLastAurora](https://github.com/TheLastAurora)  | Ingestão de Dados / Pipeline de Dados / Apresentação / Dashboard |
| Victor Lira            | [@VicLira](https://github.com/VicLira)  | Documentação / Apresentação / Vídeo Apresentação / Infraestrutura, Docker e Airflow |


## Material de Apresentação

[Archives/Projeto Final G7 - Fundamentos Engenharia de Dados.pdf](https://github.com/TheLastAurora/LAB_FundamentosDados_G7/blob/15ac996eb4cb4fd6383103bc0bb523a09c656675/Archives/Projeto%20Final%20G7%20-%20Fundamentos%20Engenharia%20de%20Dados.pdf)


## Glossário

| Nome                   | Descrição |
|--------------------------|----------|
| PostgreSQL           | Sistema de gerenciamento de banco de dados relacional (SGBD) de código aberto, robusto e avançado, utilizado para armazenar, organizar e consultar dados com alta confiabilidade, suportando SQL padrão e recursos como transações, extensões e alta escalabilidade. |
| Apache Airflow          | Plataforma open source para orquestração de workflows, utilizada para agendar, monitorar e gerenciar pipelines de dados por meio de DAGs (grafos acíclicos dirigidos). |
| Great Expectations          | Framework open source para validação e qualidade de dados, que permite definir, testar e documentar regras (expectativas) para garantir a confiabilidade dos dados em pipelines e análises. |
| DBT | Ferramenta de transformação de dados que permite modelar, testar e documentar dados diretamente no banco, utilizando SQL e boas práticas de engenharia de dados em pipelines analíticos. |
| Metabase | Ferramenta open source de Business Intelligence (BI) que permite explorar dados, criar dashboards e gerar relatórios de forma simples e intuitiva, sem necessidade avançada de programação. |
| Docker | Plataforma que permite criar, empacotar e executar aplicações em containers, garantindo ambientes isolados, portáveis e consistentes entre desenvolvimento e produção. |
