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
  
## Great Expectations

Em construção

## DBT

Em construção

## Dashboards Metabase

Dashboards em construção


## Desafios Encontrados

Em construção

## Vídeo de apresentação

Inserir link vídeo


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
