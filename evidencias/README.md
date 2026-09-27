# Evidências da execução no Databricks

Este diretório reúne **22 capturas reais do Databricks Free Edition**, feitas em 27/09/2026. Os arquivos foram renomeados para facilitar a leitura; o conteúdo das imagens não foi alterado. As capturas principais estão incorporadas nas seções correspondentes do [relatório](../README.md). Este índice facilita localizar as demais, mas não substitui o relatório.

O enunciado pede screenshots do catálogo, das tabelas persistidas, dos passos feitos pela interface e das respostas às perguntas. Ele não exige dashboard, quantidade fixa de imagens ou um diretório chamado evidencias.

## Carga e persistência

| Captura | O que comprova |
| --- | --- |
| [01_upload_volume.png](01_upload_volume.png) | Seleção dos três CSVs da Olist e destino no volume gerenciado. A tela foi capturada antes do envio. |
| [02_volume_e_tabelas.png](02_volume_e_tabelas.png) | Os três arquivos presentes no volume originais e as três tabelas Silver e três Gold visíveis no catálogo após a carga. |

A segunda captura complementa a primeira: a seleção no formulário, sozinha, não provaria que o upload terminou.

## Catálogo de dados

As telas de **Overview** mostram o nome da tabela, sua descrição, tipos e comentários das colunas. O catálogo completo, inclusive colunas fora da área visível da captura, está transcrito no README principal.

| Camada | Capturas |
| --- | --- |
| Silver | [clientes](04_catalogo_silver_clientes.png) · [itens](04_catalogo_silver_itens.png) · [pedidos](04_catalogo_silver_pedidos.png) |
| Gold | [dim_data](05_catalogo_gold_data.png) · [dim_localidade](05_catalogo_gold_localidade.png) · [fato_pedidos](05_catalogo_gold_fato.png) |

## Qualidade de dados

| Captura | Verificação visível |
| --- | --- |
| [03_qualidade_completude.png](03_qualidade_completude.png) | Ausências por atributo; em pedidos, 160 sem aprovação, 1.783 sem data da transportadora e 2.965 sem entrega real. |
| [03_qualidade_chaves.png](03_qualidade_chaves.png) | Chaves esperadas sem nulos ou grupos duplicados; máximo de 21 itens por pedido. |
| [03_qualidade_juncoes.png](03_qualidade_juncoes.png) | Nenhum pedido sem cliente, 775 pedidos sem itens e nenhum item sem pedido. |
| [03_qualidade_status.png](03_qualidade_status.png) | Oito pedidos delivered sem data real; ausências de entrega examinadas por status. |
| [03_qualidade_formatos_extremos.png](03_qualidade_formatos_extremos.png) | Verificações de formato e contagem exploratória de extremos: 8.427 preços e 11.613 fretes por item acima do limite superior de IQR. |

## Respostas às perguntas

| Pergunta | Tabela executada | Visualização e contexto |
| --- | --- | --- |
| Taxa por UF do cliente | [07_analise_uf_tabela.png](07_analise_uf_tabela.png), com atrasados, elegíveis e taxa | [07_analise_uf_grafico.png](07_analise_uf_grafico.png), dez maiores amostras |
| Evolução por mês da compra | [08_analise_mes_tabela.png](08_analise_mes_tabela.png), com março e junho de 2018 e meses finais sem taxa; [08_analise_mes_inicio.png](08_analise_mes_inicio.png), início da série | [08_analise_mes_grafico.png](08_analise_mes_grafico.png) e [08_analise_mes_periodos.png](08_analise_mes_periodos.png), que identifica meses de borda incompletos |
| Quartis de frete total | [09_analise_frete_tabela.png](09_analise_frete_tabela.png), com Q1–Q4, contagens, taxas e limites em reais | [09_analise_frete_grafico.png](09_analise_frete_grafico.png) |
| Síntese | [10_resumo_global.png](10_resumo_global.png): 99.441 pedidos, 96.470 elegíveis, 6.534 atrasados e taxa geral de 6,77% | As três perguntas são discutidas no relatório principal. |

As tabelas e gráficos acima são saídas do notebook 05 no Databricks. As capturas mostram resultados, além de comprovar o uso da plataforma; a interpretação e as limitações ficam no relatório. Nenhum vídeo ou áudio integra a entrega.
