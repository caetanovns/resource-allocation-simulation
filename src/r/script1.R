#library(ggplot2)
#library(TeachingDemos)

# Ler dados cursos
interacoes_UECE_computacao_alunos_int_ativ <- read.csv("/home/jeandro/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_computacao_alunos_int_ativ.csv", sep="")
interacoes_UECE_pedagogia_alunos_int_avaliativas <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_pedagogia_alunos_int_avaliativas.csv", sep="")
interacoes_UECE_biologia_alunos_int_avaliativas <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_biologia_alunos_int_avaliativas.csv", sep="")

#Ler dados teste de hipotese
#computação
interacoes_UECE_computacao_alunos_int_ativ_maior_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_computacao_alunos_int_ativ_maior_7.csv")
interacoes_UECE_computacao_alunos_int_ativ_menor_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_computacao_alunos_int_ativ_menor_7.csv")

#Pedagogia
interacoes_UECE_pedagogia_alunos_int_avaliativas_maior_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_pedagogia_alunos_int_avaliativas_maior_7.csv")
interacoes_UECE_pedagogia_alunos_int_avaliativas_menor_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_pedagogia_alunos_int_avaliativas_menor_7.csv")

#biologia
interacoes_UECE_biologia_alunos_int_avaliativas_maior_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_biologia_alunos_int_avaliativas_maior_7.csv")
interacoes_UECE_biologia_alunos_int_avaliativas_menor_7 <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_biologia_alunos_int_avaliativas_menor_7.csv")


#ler tutores
interacoes_UECE_tutores_computacao_InteracoesAtividades <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_tutores_computacao_InteracoesAtividades.csv", sep="")
interacoes_UECE_tutores_Pedagogia_InteracoesAtividades <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_tutores_Pedagogia_InteracoesAtividades.csv", sep="")
interacoes_UECE_tutores_biologia_InteracoesAtividades <- read.csv("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/dados/csvs_log/interacoes_UECE_tutores_biologia_InteracoesAtividades.csv", sep="")

#Gerar resumo com informações das quantidades interações

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados.txt')
cat("Resumo computação\n")
cc <- summary(interacoes_UECE_computacao_alunos_int_ativ$Inte)
print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados.txt', append = TRUE)
cat("Resumo pedagogia\n")
  cp <- summary(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte)
print(cp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados.txt', append = TRUE)
cat("Resumo Biologia\n")
  cb <- summary(interacoes_UECE_biologia_alunos_int_avaliativas$Inte)
print(cb)
sink()

#resumo média alunos

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_media.txt')
cat("Resumo computação\n")
cc <- summary(interacoes_UECE_computacao_alunos_int_ativ$Med)
print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_media.txt', append = TRUE)
cat("Resumo pedagogia\n")
cp <- summary(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med)
print(cp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_media.txt', append = TRUE)
cat("Resumo Biologia\n")
cb <- summary(interacoes_UECE_biologia_alunos_int_avaliativas$Med)
print(cb)
sink()


#Gerar resumo com informações das quantidades interações dos tutores

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_tutores.txt', append = TRUE)
cat("Resumo computação\n")
  cc <- summary(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte)
print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_tutores.txt',  append = TRUE)
cat("Resumo pedagogia\n")
  cp <- summary(interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte)
print(cp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/descritiva/resultados_tutores.txt',  append = TRUE)
cat("Resumo biologia\n")
  cb <- summary(interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte)
print(cb)
sink()


#Gerar Histograma

#Interações
#par(mfrow=c(2,2))
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/interacoes_computacao.png")
#par(mfrow=c(1,3))
hist(interacoes_UECE_computacao_alunos_int_ativ$Inte,main="Quantidade de Interações Computação", xlab="Interações", ylab="Frequencia",col = "blue")
dev.off()
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/interacoes_pedagogia.png")
hist(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte,main="Quantidade de Interações Pedagogia", xlab="Interações", ylab="Frequencia",col = "green")
dev.off()
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/interacoes_bio.png")
hist(interacoes_UECE_biologia_alunos_int_avaliativas$Inte,main="Quantidade de Interações Biologia", xlab="Interações", ylab="Frequencia", col = "red")
#multiplot(g1, g2, g3, cols=3)
dev.off()

#Médias
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/medias_computacao.png")
hist(interacoes_UECE_computacao_alunos_int_ativ$Med,main="Média Notas Computação", xlab="Alunos", ylab="Médias",col = "blue")
dev.off()
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/medias_pedagogia.png")
hist(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med,main="Média Notas Pedagogia", xlab="Alunos", ylab="Médias",col = "green")
dev.off()
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/medias_bio.png")
hist(interacoes_UECE_biologia_alunos_int_avaliativas$Med,main="Média Notas Biologia", xlab="Alunos", ylab="Médias", col = "red")
dev.off()

#juntar figuras interações

png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/todos_juntos_interacoes.png")
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), 
       widths=c(5,5), heights=c(5,5))
#par(mfrow=c(1,3))
hist(interacoes_UECE_computacao_alunos_int_ativ$Inte,main="Licenciatura em Computação", xlab="Interações", ylab="Frequencia",col = "blue")
hist(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte,main="Pedagogia", xlab="Interações", ylab="Frequencia",col = "green")
hist(interacoes_UECE_biologia_alunos_int_avaliativas$Inte,main="Biologia", xlab="Interações", ylab="Frequencia", col = "red")
dev.off()

#interações tutor

png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/todos_hist_tutor.png")
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), 
       widths=c(5,5), heights=c(5,5))
#par(mfrow=c(1,3))
hist(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte,main="Licenciatura em Computação", xlab="Interações", ylab="Frequencia",col = "blue")
hist(interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte,main="Pedagogia", xlab="Interações", ylab="Frequencia",col = "green")
hist(interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte,main="Biologia", xlab="Interações", ylab="Frequencia", col = "red")
dev.off()






#juntar médias

png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/todos_juntos_medias.png")
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), 
       widths=c(5,5), heights=c(5,5))
#par(mfrow=c(1,3))
hist(interacoes_UECE_computacao_alunos_int_ativ$Med,main="Licenciatura em Computação", xlab="Médias", ylab="Frequencia",col = "blue")
hist(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med,main="Pedagogia", xlab="Médias", ylab="Frequencia",col = "green")
hist(interacoes_UECE_biologia_alunos_int_avaliativas$Med,main="Biologia", xlab="Médias", ylab="Frequencia", col = "red")
dev.off()



#Gerar boxplot
png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/interacoes_todos.png")
boxplot(interacoes_UECE_computacao_alunos_int_ativ$Inte,interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte,interacoes_UECE_biologia_alunos_int_avaliativas$Inte, 
        main="Interações dos Cursos", xlab="cursos", ylab="Interações",varwidth=TRUE,
        names = c("Computação","Pedagogia","Biologia"),col=c("blue","green","red"))
dev.off()

#media

png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/medias_todos.png")
boxplot(interacoes_UECE_computacao_alunos_int_ativ$Med,interacoes_UECE_pedagogia_alunos_int_avaliativas$Med,interacoes_UECE_biologia_alunos_int_avaliativas$Med, 
        main="Médias dos Cursos", xlab="cursos", ylab="Médias",varwidth=TRUE,
        names = c("Computação","Pedagogia","Biologia"),col=c("blue","green","red"))
dev.off()

#boxplot tutor

png("~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/graficos/boxplot_tutor.png")
boxplot(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte,interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte,interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte, 
        main="Interações dos Tutores", xlab="cursos", ylab="Interações",varwidth=TRUE,
        names = c("Computação","Pedagogia","Biologia"),col=c("blue","green","red"))
dev.off()


## AQUIIIIIIIIIIIIII

#Boxplot comparação entre interações e medias

#boxplot(interacoes_UECE_computacao_alunos_int_ativ$Inte,interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte, main="Interações", xlab="cursos", ylab="Interações",varwidth=TRUE,names = c("computação","pedagogia"))
#boxplot(interacoes_UECE_computacao_alunos_int_ativ$Med,interacoes_UECE_pedagogia_alunos_int_avaliativas$Med, main="Médias", xlab="cursos", ylab="Média",varwidth=TRUE,names = c("computação","pedagogia"))


#Checar normalidade
#View(interacoes_UECE_computacao_alunos_int_ativ)
hc <- ks.test((interacoes_UECE_computacao_alunos_int_ativ$Inte - mean(interacoes_UECE_computacao_alunos_int_ativ$Inte))/sd(interacoes_UECE_computacao_alunos_int_ativ$Inte),
              "pnorm",mean=0,sd=1) 
capture.output(hc, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt")

#View(interacoes_UECE_pedagogia_alunos_int_avaliativas)
hp <- ks.test((interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte - mean(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte))/sd(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte),
              "pnorm",mean=0,sd=1) 
capture.output(hp, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt", append = TRUE)

hb <- ks.test((interacoes_UECE_biologia_alunos_int_avaliativas$Inte - mean(interacoes_UECE_biologia_alunos_int_avaliativas$Inte))/sd(interacoes_UECE_biologia_alunos_int_avaliativas$Inte),
              "pnorm",mean=0,sd=1) 
capture.output(hb, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt", append = TRUE)

#Medias
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt', append = TRUE)
cat("KS media computação\n")
cc <- ks.test((interacoes_UECE_computacao_alunos_int_ativ$Med - mean(interacoes_UECE_computacao_alunos_int_ativ$Med))/sd(interacoes_UECE_computacao_alunos_int_ativ$Med),
              "pnorm",mean=0,sd=1) 
print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt', append = TRUE)
cat("KS media pedagogia\n")
cc <- ks.test((interacoes_UECE_pedagogia_alunos_int_avaliativas$Med - mean(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med))/sd(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med),
              "pnorm",mean=0,sd=1) 
print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks.txt', append = TRUE)
cat("KS media biologia\n")
cc <- ks.test((interacoes_UECE_biologia_alunos_int_avaliativas$Med - mean(interacoes_UECE_biologia_alunos_int_avaliativas$Med))/sd(interacoes_UECE_biologia_alunos_int_avaliativas$Med),
              "pnorm",mean=0,sd=1) 
print(cc)
sink()

# Checar normalidade KS para Tutores

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks_tutor.txt', append = TRUE)
hc <- ks.test((interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte - mean(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte))/sd(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte),
              "pnorm",mean=0,sd=1) 
print(hc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks_tutor.txt', append = TRUE)
hp <- ks.test((interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte - mean(interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte))/sd(interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte),
              "pnorm",mean=0,sd=1) 
print(hp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/ks_tutor.txt', append = TRUE)
hb <- ks.test((interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte - mean(interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte))/sd(interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte),
              "pnorm",mean=0,sd=1) 
print(hb)
sink()

# Shapiro Interações Tutores
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro_tutor.txt', append = TRUE)
hc <- shapiro.test(interacoes_UECE_tutores_computacao_InteracoesAtividades$Inte)
print(hc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro_tutor.txt', append = TRUE)
hp <- shapiro.test(interacoes_UECE_tutores_Pedagogia_InteracoesAtividades$Inte)
print(hp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro_tutor.txt', append = TRUE)
hb <- shapiro.test(interacoes_UECE_tutores_biologia_InteracoesAtividades$Inte)
print(hb)
sink()


# Shapiro Interações Alunos
  hc <- shapiro.test(interacoes_UECE_computacao_alunos_int_ativ$Inte)
capture.output(hc, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt")

  hp <- shapiro.test(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte)
capture.output(hp, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)

  hb <- shapiro.test(interacoes_UECE_biologia_alunos_int_avaliativas$Inte)
capture.output(hb, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)

# Shapiro Médias Alunos

  hc <- shapiro.test(interacoes_UECE_computacao_alunos_int_ativ$Med)
capture.output(hc, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt",append = TRUE)

  hp <- shapiro.test(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med)
capture.output(hp, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)

  hb <- shapiro.test(interacoes_UECE_biologia_alunos_int_avaliativas$Med)
capture.output(hb, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)

# Lilliefors (Kolmogorov-Smirnov) test for normality

###################################### AQUI 22222

# test de Spearman
# 
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/sp_test.txt')
  cat("Spearman Computação\n")
  cc <-cor.test(interacoes_UECE_computacao_alunos_int_ativ$Inte, interacoes_UECE_computacao_alunos_int_ativ$Med, alternative =c("two.sided"),method = c("spearman"))
  print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/sp_test.txt', append = TRUE)
  cat("Spearman Pedagogia\n")
  cp <-cor.test(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte, interacoes_UECE_pedagogia_alunos_int_avaliativas$Med, alternative =c("two.sided"),method = c("spearman"))
  print(cp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/sp_test.txt', append = TRUE)
  cat("Spearman Biologia\n")
  cb <-cor.test(interacoes_UECE_biologia_alunos_int_avaliativas$Inte, interacoes_UECE_biologia_alunos_int_avaliativas$Med, alternative =c("two.sided"),method = c("spearman"))
  print(cb)
sink()

#kruskal.test()


#interações

# #medias
# hc <- lillie.test(interacoes_UECE_computacao_alunos_int_ativ$Med)
# capture.output(hc, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt",append = TRUE)
# 
# hp <- shapiro.test(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med)
# capture.output(hp, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)
# 
# hb <- shapiro.test(interacoes_UECE_biologia_alunos_int_avaliativas$Med)
# capture.output(hb, file="~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/shapiro.txt", append = TRUE)

#Correlação

#Correlação computação
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/correlacao')
cat("Correlação computação\n")
  cc <- cor(rank(interacoes_UECE_computacao_alunos_int_ativ$Inte),rank(interacoes_UECE_computacao_alunos_int_ativ$Med))
print(cc)
sink()

#Pedagogia
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/correlacao', append = TRUE)
cat("Correlação pedagogia\n")
  cp <- cor(rank(interacoes_UECE_pedagogia_alunos_int_avaliativas$Inte),rank(interacoes_UECE_pedagogia_alunos_int_avaliativas$Med))
print(cp)
sink()

#Biologia
sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/correlacao', append = TRUE)
cat("Correlação Biologia\n")
  cb <- cor(rank(interacoes_UECE_biologia_alunos_int_avaliativas$Inte),rank(interacoes_UECE_biologia_alunos_int_avaliativas$Med))
print(cb)
sink()

# Teste de hipotese proposto para média

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/wilcoxon.txt')
  cat("Wilcoxon Computação\n")
  cc <- wilcox.test(interacoes_UECE_computacao_alunos_int_ativ_maior_7$Inte, interacoes_UECE_computacao_alunos_int_ativ_menor_7$Inte, alternative = c("greater"))
  print(cc)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/wilcoxon.txt',append = TRUE)
cat("Wilcoxon Pedagogia\n")
cp <- wilcox.test(interacoes_UECE_pedagogia_alunos_int_avaliativas_maior_7$Inte, interacoes_UECE_pedagogia_alunos_int_avaliativas_menor_7$Inte, alternative = c("greater"))
print(cp)
sink()

sink('~/Dropbox/doutorado/disciplinas/Cin-Ufpe/Estatisitica/projeto/resultados/testes_hipt/wilcoxon.txt', append = TRUE)
cat("Wilcoxon Biologia\n")
cb <- wilcox.test(interacoes_UECE_biologia_alunos_int_avaliativas_maior_7$Inte, interacoes_UECE_biologia_alunos_int_avaliativas_menor_7$Inte, alternative = c("greater"))
print(cb)
sink()