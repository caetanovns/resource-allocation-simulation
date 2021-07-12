best_path <- paste0(getwd(), "/data/results/best.csv")

best_path <- paste0(getwd(), "/data/csv/best.csv")
random_path <- paste0(getwd(), "/data/csv/random.csv")
ga_path <- paste0(getwd(), "/data/csv/ga.csv")

best <- read.csv(best_path, sep = ",")
random <- read.csv(random_path, sep = ",")
ga <- read.csv(ga_path, sep = ",")

#################### Export data #####################################

sink(paste0(getwd(), "/data/results/result_mean.txt"))
cat("Resumo Best\n")
print(summary(best$mean))
sink()

sink(paste0(getwd(), "/data/results/result_mean.txt"), append = TRUE)
cat("Resumo Random\n")
print(summary(random$mean))
sink()

sink(paste0(getwd(), "/data/results/result_mean.txt"), append = TRUE)
cat("Resumo GA\n")
print(summary(ga$mean))
sink()

##################  Individual Histogram #############################

png(paste0(getwd(), "/data/results/graph/mean_best.png"))
hist(best$mean, main = "Média BEST", xlab = "Truck Factor", ylab = "Quantidade", col = "blue")
dev.off()

#################### Set of Histogram ################################

png(paste0(getwd(), "/data/results/graph/histogram_all.png"))
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE),
       widths = c(5, 5), heights = c(5, 5))
#par(mfrow=c(1,3))
hist(best$mean, main = "Best", xlab = "Truck Factor", ylab = "Frequencia", col = "blue")
hist(random$mean, main = "Random", xlab = "Truck Factor", ylab = "Frequencia", col = "green")
hist(ga$mean, main = "GA", xlab = "Truck Factor", ylab = "Frequencia", col = "red")
dev.off()


##################### Boxplot ########################################

png(paste0(getwd(), "/data/results/graph/boxplot_all.png"))
boxplot(best$mean, random$mean, ga$mean,
        main = "Interações dos Cursos", xlab = "Abordagens", ylab = "Truck Factor", varwidth = TRUE,
        names = c("Best", "Random", "GA"), col = c("blue", "green", "red"))
dev.off()

##################### Checar Normalidade ##############################

hipt_best <- ks.test((best$mean - mean(best$mean)) / sd(best$mean),
                     "pnorm", mean = 0, sd = 1)
capture.output(hipt_best, file = paste0(getwd(), "/data/results/test_hipt/ks.txt"))


##################### Checar Shapiro ##################################

shapiro_best <- shapiro.test(best$mean)
capture.output(shapiro_best, file = paste0(getwd(), "/data/results/test_hipt/shapiro.txt"))

##################### Checar Spearman #################################

#sink(paste0(getwd(), "/data/results/graph/best_spearman.png"))
#cat("Spearman Computação\n")
#print(cor.test(best$sprints, best$mean, alternative =c("two.sided"),method = c("spearman")))
#sink()


##################### Checar Correlação ###############################
sink(paste0(getwd(), "/data/results/relation.txt"))
cat("Correlação Best\n")
print(cor(rank(best$sprints), rank(best$mean)))
sink()

##################### Checar Wilcox ##################################

sink(paste0(getwd(), "/data/results/test_hipt/wilcox_best.txt"))
cat("Wilcoxon Best\n")
print(wilcox.test(best$mean, best$mean, alternative = c("greater")))
sink()