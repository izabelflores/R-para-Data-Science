## R ladies - Club do Livro

## Cap 8: Importando Dados com readr
## Apresentacao: Izabel Flores

## Ler arquivos retangulares de texto simples no R
## Importacao de dados

library(tidyverse)
library(readr)


## Transformar arquivos simples em data frames:

# por delimitacao

read_csv()       # arquivos delimitados por ","
read_csv2()    # arquivo delimitado por ";"
read_tsv()     # arquivo delimitado por "|"
read_delim()   # qulquer delimitacao

# por largura

read_fwf()     # arquivo de largura fixa
fwf_widths()   # especificar por largura
fwf_positio()  # especificar por posicao
read_table()   # largura fixa onde colunas sao separadas por espacos em branco

read_log()     # Formato Apache

# trabalharemos com read_csv()

# primeiro argumento: caminho para o arquivo

read_csv('C:/Users/izabe/Desktop/wooldridge_mroz.csv')
read_csv2('http://api.bcb.gov.br/dados/serie/bcdata.sgs.10813/dados?formato=csv')
read_csv('a, b, c
         1, 2, 3
         4, 5, 6')

# primeira linha como nome e dá o tipo de cada coluna

# para pular linhas

read_csv('priemira linha
         segunda linha
         a, b, c
         1, 2, 3
         4, 5, 6',
         skip = 2)

# pular comentario

read_csv('#nomes das coluna
         a, b, c
         # primeira linhda
         1, 2, 3
         4, 5, 6
         # acabou o arquivo',
         comment = '#')

# dados sem nome na coluna

read_csv('1, 2, 3
         4, 5, 6',
         col_names = FALSE)

read_csv('1, 2, 3
         4, 5, 6',
         col_names = c('x', 'y', 'z'))

# valores faltantes

read_csv('a, b, c \n 1, 999, .',
         na = c(".", "999"))

## Comparando com o R base

read_csv()
read.csv()

# mais rapidas que o R base
# cria tibble
# nao converte caracteres em fatores
# não usa nomes de linhas
# mais reprodutiveis


## Analisando um Vetor

# parse_*
# recebe um vetor de caractere e retorna um vetor mais especializado

(exemplo_1 <- c('TRUE', 'FALSE', 'NA'))
parse_logical(exemplo_1)

(exemplo_2 <- c('1', '2', '3'))
parse_integer(exemplo_2)

(exemplo_3 <- c('2010-01-01', '1979-10-14', '1999-06-18'))
parse_date(exemplo_3)
class(parse_date(exemplo_3))

# estrutura: vetor a ser analisado, argumento na

(exemplo_4 <- c('10', '20', '.', '90'))
parse_integer(exemplo_4, na = '.')

# analise falhar

(exemplo_5 <- c('10', '20', '.', 'abc'))
parse_integer(exemplo_5)

exemplo_5 <- parse_integer(exemplo_5)
problems(exemplo_5)

# analisadores importantes

parse_logical() # logico
parse_integer() # inteiro
parse_double() # numero estrito
parse_number() # numero flexivel
parse_character() # character
parse_factor() # fator
parse_datetime() # data e hora
parse_date() # data
parse_time() # hora

## Numeros

# pessoas escrevem numeros de formas diferentes
# numeros cercados por outros caracteres
# caracteres de agrupamento

parse_double(c('1,23', '5,70', '7,00'), 
             locale = locale(decimal_mark = ',')) # o padrao e '.'

parse_number(c('R$1.23', 'R$5.70', 'R$7.00'))

parse_number(c('R$1.000,23', 'R$1.005,70', 'R$1.007,00'),
             locale = locale(grouping_mark = '.'))

# strings

# como os computadores representam strings

charToRaw("Rladiesbsb")

# mapeamento desses numeros hexadecimais para caractere se chama codificacao
# existem diferentes tipos de codificacao
# a utilizada foi a ASCII
# para linguas diferente do ingles: Latin1 (ISO-8859-1), Latin2(ISO-8859-2)
# uma codificacao praticamente universal: UTF-8
# o readr usa UTF-8
# e se os dados forem produzidos por sistemas que nao usam o UTF-8?

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\xb2\xf1\x82\xc9\x82\xbf\x82\xcd"

# especificar a codificacao

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# mas como saber qual a codificacao correta?
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))
guess_encoding(charToRaw('C:/Users/izabe/Desktop/wooldridge_mroz.csv'))

## Fatores

# usado pra representar variaveis categoricas
fruit <- c('apple', 'banana')
parse_factor(c('apple', 'banana', 'banananna'), levels = fruit)

# aprenderemos a limpar nos capitulos 11 e 12


## Data, Data-Horas e Horas

# espera-se uma data no formato ISO8601 (ano, mes, dia, hora, minuto, segundo)

parse_datetime('2010-10-01T2010')
parse_datetime('2010-10-01')
# mais informacoes: https://pt.wikipedia.org/wiki/ISO_8601 

parse_date('2010-10-01')

parse_time('01:10')
parse_time('13:10')
parse_time('01:10 am')
parse_time('01:10 pm')
parse_time('01:10:01')

library(hms) # organizar diferntes especificacoes de tempo em hh:mm:ss

##### Analisando um arquivo #### 

# como o readr adivinha automaticamente o tipo da coluna

# lê as primeiras 1000 colunas e "tenta advinhar"
guess_parser(c('TRUE', 'FALSE'))
guess_parser(c('1', '5', '9'))
guess_parser(c('244,000,876', '244,000,876.86', '244,000,876'))

# segue logical > inteiro > double > numero > horas > data > data-hora > strings

# problemas: primeiras 1000 linhas nao sao geral o suficientes
#            primeiras linhas so contem NA, le como charactere

challenge <- read_csv(readr_example('challenge.csv'))
 problems(challenge)
 
 challenge <- read_csv(readr_example('challenge.csv'),
                       col_types = cols(
                         x = col_double(),
                         y = col_date()
                       )
                     )
problems(challenge)

tail(challenge)

# mudar a quantidade de linhas lidas

challenge2 <- read_csv(readr_example('challenge.csv'),
                       guess_max = 1001)

# ler tudo como character
# depois aplicar a heuristica de analise às colunas do data frame

challenge2 <- read_csv(readr_example('challenge.csv'),
                       col_types = cols(.default = col_character()))

type_convert(challenge2)


#### Escrever os dados de volta no disco

write_csv()
write_tsv()   
write_excel_csv()   

# White_*(data frame, local)

write_csv(challenge, 'C:/Users/izabe/Desktop/challenge.csv') # caminho completo
write_csv(challenge, 'challenge.csv') # salvar no diretorio padrao

# porem, as informacoes sobre os tipos de colunas sao perdidas


## Outros tipos de dados

library(haven) # arquivos SPSS, Stata e SAS
library(readxl) # excel (.xls e .xlsx)
library(DBI) # SQL
library(jsonlite) #JSON
library(xml2) #XML

library(rio)
# manual do R

############################################################################
############################################################################
#### extra

library(httr) # baixar
library(readxl) # leitura excel
library(tidyverse) # manipulacao de dados

url<-'https://www.bcb.gov.br/content/estatisticas/Documents/Tabelas_especiais/Dlspp.xls'
GET(url, write_disk(DLSP <- tempfile(fileext = ".xls")))
DLSP <- read_excel(DLSP,
                   sheet = "R$ milhões",
                   skip=9,
                   col_names = FALSE,
                   col_types = "numeric")


