filename <- 'case_20'
simulation <- 'Simulation 5'
case_1_path <- paste0(getwd(), paste0(paste0("/data/csv/", filename), ".csv"))

case_1 <- read.csv(case_1_path, sep = ",")

if (!dir.exists(paste0(getwd(), "/data/results/", filename))) {
  dir.create(paste0(getwd(), "/data/results/", filename), showWarnings = TRUE, recursive = FALSE, mode = "0777")
  dir.create(paste0(getwd(), "/data/results/", filename, "/imgs"), showWarnings = TRUE, recursive = FALSE, mode = "0777")
}

png(paste0(getwd(), "/data/results/", filename, '/imgs/histogram_', filename, '.png'))
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE),
       widths = c(5, 5), heights = c(5, 5))
hist(case_1$tf_ga, main = "GA", xlab = "Truck Factor", ylab = "Frequencia", xlim=c(0,7),col = "blue")
hist(case_1$tf_best, main = "Best", xlab = "Truck Factor", ylab = "Frequencia", xlim=c(0,7),col = "green")
hist(case_1$tf_random, main = "Random", xlab = "Truck Factor", ylab = "Frequencia", xlim=c(0,7),col = "red")
dev.off()

##################### Boxplot ########################################

png(paste0(getwd(), "/data/results/", filename, '/imgs/boxplot_', filename, '.png'))
boxplot(case_1$tf_ga, case_1$tf_best, case_1$tf_random,
        main = "Truck Factor", xlab = "Abordagens", ylab = "Truck Factor", varwidth = TRUE,
        names = c("GA", "Best", "Random"), col = c("blue", "green", "red"))
dev.off()

#png(paste0(getwd(), "/data/results/", filename, '/imgs/boxplot_variance', filename, '.png'))
#boxplot(case_1$var_ga, case_1$var_random,
#        main = "Truck Factor", xlab = "Abordagens", ylab = "Truck Factor", varwidth = TRUE,
#        names = c("GA", "Random"), col = c("blue", "red"))
#dev.off()

##################### Chart Line #####################################

png(paste0(getwd(), "/data/results/", filename, '/imgs/lines_truck_factor_', filename, '.png'))
plot(case_1$tf_ga,type = "l",col = "#4285f4", xlab = "Sprint", ylab = "Truck Factor", main = simulation, lwd=3, lty=1)
lines(case_1$tf_random, type = "l", col = "#ea4335", lwd=3, lty=2)
lines(case_1$tf_best, type = "l", col = "#fbbc04", lwd=3, lty=3)
legend("topleft", legend=c("GA", "Random", "Best"),col=c("#4285f4", "#ea4335", "#fbbc04"), lty = 1:3,lwd=3, cex=1)
dev.off()


png(paste0(getwd(), "/data/results/", filename, '/imgs/lines_variance_', filename, '.png'))
plot(case_1$var_ga,type = "l",col = "#4285f4", xlab = "Sprint", ylab = "Variance", main = simulation,lwd=3, lty=1)
lines(case_1$var_random, type = "l", col = "#ea4335",lwd=3, lty=2)
lines(case_1$var_best, type = "l", col = "#fbbc04",lwd=3, lty=3)
legend("topleft", legend=c("GA", "Random", "Best"),col=c("#4285f4", "#ea4335", "#fbbc04"), lty = 1:3, cex=1, lwd=3)
dev.off()



##################### Checar Normalidade ##############################

ks_output <- paste0(getwd(), "/data/results/", filename, '/ks_', filename, '.txt')

hipt_best <- ks.test(case_1$tf_ga, "pnorm", mean = mean(case_1$tf_ga), sd = sd(case_1$tf_ga))
capture.output(hipt_best, file = ks_output)

hipt_best <- ks.test(case_1$tf_best, "pnorm", mean = mean(case_1$tf_best), sd = sd(case_1$tf_best))
capture.output(hipt_best, file = ks_output, append = TRUE)

hipt_best <- ks.test(case_1$tf_random, "pnorm", mean = mean(case_1$tf_random), sd = sd(case_1$tf_random))
capture.output(hipt_best, file = ks_output, append = TRUE)

##################### Checar Shapiro ##################################

# shapiro_best <- shapiro.test(case_1$tf_ga)
# capture.output(shapiro_best, file = paste0(getwd(), "/data/results/test_hipt/shapiro.txt"))

##################### Checar Wilcox ##################################

wilcox_output <- paste0(getwd(), "/data/results/", filename, '/wilcox_', filename, '.txt')

#wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_best, alternative = c("greater"))
#capture.output(wilcox_test, file = wilcox_output, append = TRUE)

#wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_best, alternative = c("less"))
#capture.output(wilcox_test, file = wilcox_output, append = TRUE)

#wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_best, alternative = c("two.sided"))
#capture.output(wilcox_test, file = wilcox_output, append = TRUE)

wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_random, alternative = c("greater"))
capture.output(wilcox_test, file = wilcox_output)

wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_random, alternative = c("less"))
capture.output(wilcox_test, file = wilcox_output, append = TRUE)

wilcox_test <- wilcox.test(case_1$tf_ga, case_1$tf_random, alternative = c("two.sided"))
capture.output(wilcox_test, file = wilcox_output, append = TRUE)