# Objetivo: Criar uma núvem de palavras.
# Tutorial desenvolvido por Marcio Baldissera Cure.
# Disponível em https://github.com/Mauritia-flexuosa/word-cloud
# Os dados estão disponíveis em https://frutosdacosta.netlify.app
# Você também pode acompanhar o projeto no Instagram: @frutos_da_costa


# Carregar os pacotes necessários:
library(tidyverse)
library(RColorBrewer)
library(wordcloud)
library(tm)

# Se não tiver os pacotes, o comando para carregar é 'install.packages', com o nome do pacote entre aspas dentro dos parênteses.
# Exemplo: install.packages("RColorBrewer")

# Carregar os dados:
dados <-  read.table("dados_1.txt", h = T)

# Visualiza o nome das colunas e as linhas iniciais:
dados %>% head

# Pega o texto e cria um vetor:
vetorTexto <- VectorSource(dados$nome_popular)

# Representa o vetor como um corpus de texto:
corpusTexto <- Corpus(vetorTexto)

# Constrói uma classe chamada de 'term-document matrix'. Ela computa a
# frequência com que aparecem os termos dentro do corpus de texto. 
dtm <- TermDocumentMatrix(corpusTexto)

# A partir do term-document matrix, constrói uma matrix  (i.e. classe 'matrix') binária com presença e auxência onde cada linha é uma "palavra" e cada coluna é uma unidade amostral.
matrix <- as.matrix(dtm)

# Soma o número de linhas e coloca em ordem decrescente.
words <- sort(rowSums(matrix),decreasing=TRUE) 

# Constrói um objeto de classe 'data frame'.
df <- data.frame(word = names(words),freq=words)

# Finalmente, visualize a núvem de palavras.

wordcloud(df$word)

# Deixa a núvem bonita ajustando os parâmetros:
wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=130, random.order=FALSE, rot.per=0.25, colors=brewer.pal(8, "Dark2"))

# Salva a núvem de palavras no formato png:
png("nuvem_de_palavras.png", res = 300, width = 2000, height = 2000)

wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=130, random.order=FALSE, rot.per=0.25, colors=brewer.pal(8, "Dark2"))

dev.off()

# Observação: Os parâmetros das funções, juntamente com as instruções para usá-las podem ser acessadas com o comando ?função, por exemplo ```?wordcloud```.