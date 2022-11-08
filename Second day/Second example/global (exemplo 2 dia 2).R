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

load('~/X2/shiny/xgboost-enem.RData')

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

rm(dados_final,dados_rec_teste,dados_treino,
dados_teste)

#save.image(file = "xgboost-enem.RData")
