# Atividade de Análise de Dados

Esta atividade foi desenvolvida utilizando a linguagem Elixir para realizar a análise de dados extraídos dos usuários do GitHub. Os dados podem ser obtidos por meio da ferramenta RepoInsights.

## Descrição

O projeto possui dois scripts principais:

- **Calculate Metrics:**  
  Este script processa os dados dos usuários para calcular métricas como valor mínimo, máximo, média, mediana e desvio padrão das seguintes medidas:

    - Seguidores (`followers_count`)
    - Seguindo (`following_count`)
    - Idade da conta (`account_age`)

- **List Locations:**  
  Este script gera uma listagem das principais localizações fornecidas pelos usuários, transformando todas as localizações para minúsculo e ordenando-as pela quantidade de ocorrências (em ordem decrescente). Em caso de empate na frequência, a ordenação é feita alfabeticamente.

## Execução

### Executando o Script de Métricas

Para executar o script que calcula as métricas, utilize o comando abaixo no terminal:

```bash
mix calculate_metrics <arquivo.json>
```

Onde <arquivo.json> é o arquivo contendo os dados dos usuários obtido através do RepoInsights.

### Executando o Script de Localizações

Para executar o script que gera a listagem das localizações, utilize:

```bash
mix list_locations <arquivo.json>
```

Onde <arquivo.json> é o arquivo contendo os dados dos usuários obtido através do RepoInsights.

### Executando Testes Unitários

Para garantir que todas as funções estão se comportando conforme o esperado, execute os testes unitários com o comando:

```bash
mix test
```

### Script Bash

Caso queira executar os scripts várias vezes para diversos arquivos de teste, utilize:

```bash
bash run.sh test_files
```

Onde <test_files> um diretório contendo os arquivos json para testar.

## Observações

- Certifique-se de que o arquivo JSON esteja no formato esperado e contenha as informações necessárias para o processamento.

- Os scripts foram desenvolvidos para rodar no ambiente Mix, que integra a execução dos testes com o ExUnit e facilita a organização do projeto.

- Para executar os comandos, inicie o terminal no diretório do projeto.
