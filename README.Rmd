---
title: "Como fazer uma núvem de palavras simples?"
subtitle: "Tutorial desenvolvido por Marcio Baldissera Cure."
---
</BR>

#### Este tutorial vai te ensinar como criar uma núvem de palavras de forma simples utilizando o R e o RStudio.

- Se você ainda não possuir instalado no computador, é preciso instalar o R e depois o RStudio. O R pode ser baixado [AQUI](https://www.r-project.org/) e o RStudio [AQUI](https://www.rstudio.com/products/rstudio/#rstudio-desktop).

#### Para criar uma núvem de palavras utilizei os dados do Projeto Frutos da Costa, uma iniciativa independente para mapear as árvores frutíferas em uma Comunidade Tradicional de pescadores artesanais em Florianópolis, SC. 

#### Os dados e as informações sobre o projeto estão disponíveis em <https://frutosdacosta.netlify.app>. Você também pode conhecer e acompanhar o projeto no Instagram: [@frutos_da_costa](https://www.instagram.com/frutos_da_costa/).

#### Este tutorial, assim como o script e os dados estão disponíveis em <https://github.com/Mauritia-flexuosa/word-cloud>.


- *Observação 1:* Eu também estou utilizando (eventualmente) neste tutorial um recurso que pode ser encotrado dentro do pacote ```tidyverse``` que é o chamado _pipe_ (```%>%```). Ele encadeia funções. Talvez sua utilidade não fique bem clara neste tutorial, mas ele com certeza será útil no futuro, então, vá se acostumando. ;)

- *Observação 2:* Os parâmetros das funções, juntamente com as instruções para usá-las podem ser acessadas com o comando ?função, por exemplo ```?wordcloud```.

Ok, sem mais delongas...

## Vamos ao início:

- Abra o RStudio e escreva os comandos em um script do R.

- Para executar os comandos, coloque o cursor na linha de código ou selecione o texto do código e execute ```ctrl+ENTER```.

### 1. Carregar os pacotes necessários:


```{r include=TRUE, echo=TRUE}
library(tidyverse)
library(RColorBrewer)
library(wordcloud)
library(tm)

```

- Se não tiver os pacotes, o comando para carregar é 'install.packages', com o nome do pacote entre aspas dentro dos parênteses. Exemplo: ```  install.packages("RColorBrewer")```.

### 2. Carregar os dados:

- Primeiro, vamos atribuir a tabela chamada de _dados.txt_ a um objeto chamado de _dados_.


```{r echo=TRUE, include=TRUE}
dados <-  read.table("dados_1.txt", h = T)
```

- Note que o argumento que vai entre as aspas ("argumento") é o endereço do arquivo dentro do seu computador. Como os meus dados estão armazenados em uma tabela que está dentro do meu diretório de trabalho.

- Para ver o seu diretório de trabalho, ou seja, a pasta que o R entende que você está trabalhando, basta executar o comando ```getwd()```. Por exemplo, quando eu executo este comando, aparece a pasta do meu computador onde está a tabela de dados. Exemplo: ```r getwd()```.

Você pode determinar a sua pasta de trabalho, ou seja, o seu diretório de trabalho, utilizando a função ```setwd()``` com o endereço da pasta entre aspas dentro do parênteses. Por exemplo, ```setwd("/home/Documentos/pasta1")```.


### 3. Explore os dados para ver se está tudo ok:

- Você pode explorar os dados de diferentes formas. Saiba o nome das colunas e o que tem nas linhas iniciais usando a função ```head```:

```{r echo=TRUE, include=TRUE}
dados %>% head
```


... ou o bom e velho ```str```

```{r}
dados %>% str
```

Mas o ```summary``` também é uma opção.
```{r}
dados %>% summary
```


### 4. Agora, vamos pegar o texto e criar um vetor para podermos organizar nossos dados e para que eles possam ser processados por outras funções, pois as funções, muitas vezes, trabalham com classes de objetos diferentes.

- para ver a classe de um objeto, use a função ```class()``` com o objeto dentro dos parênteses. Por exemplo, veja abaixo que a classe do objeto (_dados_) que armazenamos os nossos dados é um ```data.frame```. 

```{r echo=TRUE, include=TRUE, warning=FALSE}
class(dados)
```
- Transformando para vetor ou para a classe ```VectorSource```:

```{r echo=TRUE, include=TRUE}
vetorTexto <- VectorSource(dados$nome_popular)
```
 
### 5. Representa o vetor como um corpus de texto:

- Agora, vamos pegar esse vetor que colocamos dentro do objeto chamado _vetorTexto_ e passar para a classe _Corpus_.

```{r echo=TRUE}
corpusTexto <- Corpus(vetorTexto)
```

### 6. Constrói uma classe chamada de __term-document matrix_

- Esta etapa computa a frequência com que aparecem os termos dentro do corpus de texto e muda mais uma vez a classe do objeto que estamos trabalhando (não será a última). 

```{r echo=TRUE}
dtm <- TermDocumentMatrix(corpusTexto)
```

### 7. Transforma em matriz

- A partir do term-document matrix, vamos construir uma matrix  (i.e. classe 'matrix') binária com presença e auxência onde cada linha é uma "palavra" e cada coluna é uma unidade amostral.

```{r echo=TRUE}
matrix <- as.matrix(dtm)

```


### 8. Soma o número de linhas e coloca em ordem decrescente.

```{r echo=TRUE}
words <- sort(rowSums(matrix),decreasing=TRUE) 
```

### 9. De volta à classe original

- Cria um data frame com as palavras em uma coluna e a frequência das palavras na outra.

```{r}
df <- data.frame(word = names(words),freq=words)
```

- Demos toda essa volta para voltarmos nosso objeto para a classe 'data frame'? Sim, mas os dados não são mais os mesmos. Com todos os passos anteriores, fizemos diversas transformações até aqui para extrairmos o que a função ```wordcloud``` necessita para gerar a núvem de palavras.

### 10. Plote uma núvem de palavras simples.

- Finalmente, visualize a núvem de palavras. É a núvel mais simples, mas mesmo assim já é alguma coisa.

```{r include=TRUE, echo=TRUE, warning=FALSE}

wordcloud(df$word)

```

### 11. Melhorando a nossa núvem

- Tudo começa simples, porém nós não nos contentamos com essa simplicidade, pois essa núvem só nos mostra as diferentes palavras. Só isso! Queremos mais informações sendo transmitidas por este recurso visual, certo? Uma núvem de palavras pode nos dizer mais. Por exemplo, para sabermos qual palavra possui a maior frequência de ocorrências, ou para visualizarmos a diferença relativa de frequência entre as palavras bastaria que o tamanho das palavras na núvem fossem proporcionais à frequência de ocorrência.

- Então vamos deixar a núvem bonita ajustando os parâmetros da função que gera essa núvem.

```{r echo=TRUE, include=TRUE}
wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=130, random.order=FALSE, rot.per=0.25, colors=brewer.pal(8, "Dark2"))
```

Podemos notar claramente as palavras mais frequêntes, ou seja, as árvores frutíferas que mais encontramos, que são o Ingá e a Pitanga.

### 12. Salvando a núvem para formato de imagem.

- Para salvar a núvem de palavras no formato png, por exemplo, vamos utilizar a função ```png```. Entretanto, existem outras funções para salvar imagens geradas no R, como gráficos, mapas e outras figuras.

```{r include=TRUE, warning=FALSE}
png("nuvem_de_palavras.png", res = 300, width = 2000, height = 2000)

wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=130, random.order=FALSE, rot.per=0.25, colors=brewer.pal(8, "Dark2"))

dev.off()

```

#### **Pronto, está feita e salva a sua núvem de palavras.**

</DIV>

#### Agora tente criar uma núvem com outros dados. Qualquer dúvida, entre em contato:

</DIV>

<footer><p class="small">

<h3>Contatos:</h3>

<div>
<a href = "mailto:marciobcure@gmail.com"><img src="https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white" target="_blank"></a>
 <a href="https://instagram.com/marciobcure" target="_blank"><img src="https://img.shields.io/badge/-Instagram-%23E4405F?style=for-the-badge&logo=instagram&logoColor=white" target="_blank"></a>
</div>
</p></footer>