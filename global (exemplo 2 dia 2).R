library(shinydashboard)
library(tidymodels)
library(data.table)
library(doParallel)
library(ggfortify)
library(tidyverse)
library(xgboost)
library(ranger)
library(themis)
library(vip)
library(DT)

modelo_rf <- readRDS("rf_modelo.rds")
modelo_xgboost <- readRDS("xgboost_modelo.rds")

dados_treino <- read.csv("dados_ENEM_treino.csv",sep = ",")
dados_treino <- dados_treino[,-1]

ordem <- names(dados_treino[-46]) %>% str_remove(.,"Q0") %>%
  as.numeric() %>% order()

dados_teste <- read.csv("dados_ENEM_teste.csv",sep = ",")
dados_teste <- dados_teste[,-1]

dados_treino <- dados_treino[c(ordem,46)]
dados_teste <- dados_teste[c(ordem,46)]

itens_co <- read.csv("ITENS_PROVA_2009.csv", sep = ";")
itens_co <- itens_co %>% filter(SG_AREA == "MT")

co_posicao <- itens_co %>% filter(TX_COR == "AZUL") %>% select(CO_POSICAO,CO_ITEM) %>% group_by(CO_ITEM) %>% arrange(CO_ITEM)
co_posicao <- co_posicao$CO_POSICAO - 3*45

dados_rec_treino <- 
  recipe(NOTA ~ ., 
         data = dados_treino) %>% 
  step_center(-NOTA) %>% 
  step_scale(-NOTA) %>% 
  prep()

dados_rec_teste <- 
  recipe(NOTA ~ ., 
         data = dados_teste) %>%
  step_center(-NOTA) %>% 
  step_scale(-NOTA) %>%
  prep()

dados_final <- bake(dados_rec_treino,
                  new_data = dados_teste)

resu1 <- 
  dados_final %>%
  bind_cols(predict(modelo_rf, dados_final) %>%
              rename(predicao = .pred))

resu2 <- 
  dados_final %>%
  bind_cols(predict(modelo_xgboost, dados_final) %>%
              rename(predicao = .pred))

p1_1 <- modelo_rf %>% 
  pull_workflow_fit() %>% 
  vip(scale = TRUE,aesthetics = list(fill = "#ed1a22"))+
  theme_light()

p1_2 <- modelo_xgboost %>% 
  pull_workflow_fit() %>% 
  vip(scale = TRUE,aesthetics = list(fill = "#ed1a22"))+
  theme_light()
