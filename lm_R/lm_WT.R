install.packages("rsq")
install.packages("car")

library(rsq)
library(car)
library(RColorBrewer)


GHG<-read.table("clipboard",header=T)

summary(GHG)

#lm
m_GHG<-lm(GHGs ~ I(WT^2) + WT,data=GHG)

m_NEE<-lm(NEE ~ I(WT^2) + WT,data=GHG)

m_CH4<-lm(CH4 ~ I(WT^2) + WT,data=GHG)

m_N2O<-lm(N2O ~ I(WT^2) + WT,data=GHG)

#----------------------------------GHG------------------------
summary(m_GHG)
AIC(m_GHG)
drop1(m_GHG,test="Chisq")

crPlots(m_GHG)

qqPlot(m_GHG,labels = row.names(states),id.method = "identify",simulate = TRUE,main = "Q-Q Plot")

ncvTest(m_GHG)

durbinWatsonTest(m_GHG)
y.res=resid(m_GHG)
y.fit=predict(m_GHG)
plot(y.res~y.fit)

qqnorm(y.res)
hist(y.res)

RSE<- summary(m_GHG)$sigma
RSE
#----------------------------------NEE/CH4/N2O------------------------
summary(m_N2O)
AIC(m_N2O)
drop1(m_N2O,test="Chisq")

crPlots(m_N2O)

qqPlot(m_N2O,labels = row.names(states),id.method = "identify",simulate = TRUE,main = "Q-Q Plot")

ncvTest(m_N2O)

durbinWatsonTest(m_N2O)
y.res=resid(m_N2O)
y.fit=predict(m_N2O)
plot(y.res~y.fit)

qqnorm(y.res)
hist(y.res)

RSE<- summary(m_N2O)$sigma
RSE


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<GS_A<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

GHG<-read.table("clipboard",header=T)

factor(GHG$Climate)
summary(GHG)


m_NEE<-lm(NEE_A ~ NEE_G*Climate,data=GHG)
summary(m_NEE)
AIC(m_NEE)
m_NEE2<-lm(NEE_A ~ NEE_G,data=GHG)
summary(m_NEE2)
AIC(m_NEE2)

m_CH4<-lm(CH4_A ~ CH4_G*Climate,data=GHG)
m_CH4<-lm(CH4_A ~ CH4_G ,data=GHG)

m_N2O<-lm(N2O_A ~ N2O_G + Climate,data=GHG)
m_N2O<-lm(N2O_A ~ N2O_G ,data=GHG)
summary(m_CH4)
AIC(m_CH4)
#---------------------------------GS_A_NEE/CH4/N2O------------------------
summary(m_N2O)
AIC(m_N2O)

drop1(m_N2O,test="Chisq")
#正态性检验
crPlots(m_N2O)
#QQ图
qqPlot(m_N2O,labels = row.names(states),id.method = "identify",simulate = TRUE,main = "Q-Q Plot")
#残差图
ncvTest(m_N2O)
#误差自相关性
durbinWatsonTest(m_N2O)
y.res=resid(m_N2O)
y.fit=predict(m_N2O)
plot(y.res~y.fit)

qqnorm(y.res)
hist(y.res)

#导出RMSE
RSE<- summary(m_N2O)$sigma
RSE


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<lmer_WT_GHGs<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
install.packages("lme4")
install.packages("car")
install.packages("lmerTest")

library(lme4)## library for linear mixed effects models in R
library(car)
library(lmerTest)
library(arm)
library(MuMIn)
library(ggplot2)
library(export)
library(ggpubr)

mydata<-read.table("clipboard",header=T)

## Look at your data
dim(mydata)
summary(mydata)
head(mydata,n=20)
str(mydata)

Climate <- as.factor(mydata$Climate)


mod.NEE.lmer1 <- lmer(NEE ~ WT2 + WT + (WT|Climate)+ (WT2|Climate), data=mydata,REML=T)
mod.NEE.lmer1 <- lmer(NEE ~ WT^2 * Climate, data=mydata)
mod.NEE.lm1 <- lm(NEE ~ WT2:Climate + WT:Climate, data=mydata)
summary(mod.NEE.lm1)

ggplot(mydata, aes( x = WT, y = NEE, color = Climate)) + 
  geom_point( aes(pch = Climate), size=5, alpha=0.2,col = "black",bg = "black")+ 
  geom_smooth(method = 'lm', formula = y ~ poly(x, 2), se = T)+
  stat_cor(data=mydata, method = "pearson",aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),label.x.npc = "center",label.y.npc = "bottom") +  
  theme(axis.text.x = element_text(size = 12, color = "black")) +  
  theme(axis.text.y = element_text(size = 12, color = "black")) +
  theme_bw()
filen <- tempfile(pattern = "ggplot")
graph2ppt(x=NULL,file=filen)

#-----------------------------------CH4------------------------------------------------------------
mydata<-read.table("clipboard",header=T)
summary(mydata)
Climate <- as.factor(mydata$Climate)
Climate=as.factor(Climate)

mod.CH4.lm1 <- lm(CH4 ~ WT2:Climate + WT:Climate, data=mydata)
summary(mod.CH4.lm1)
confint(mod.CH4.lm1, level=0.95)

ggplot(mydata, aes( x = WT, y = CH4, color = as.factor(Climate))) + 
  geom_point( aes(pch = as.factor(Climate)), size=5, alpha=0.2,col = "black",bg = "black")+ 
  geom_smooth(method = 'lm', formula = y ~ poly(x, 2), se = T)+
  stat_cor(data=mydata, method = "pearson",aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),label.x.npc = "left",label.y.npc = "top") +  
  theme(axis.text.x = element_text(size = 12, color = "black")) +  
  theme(axis.text.y = element_text(size = 12, color = "black")) +
  theme_bw()
filen <- tempfile(pattern = "ggplot")
graph2ppt(x=NULL,file=filen)


#-----------------------------------N2O------------------------------------------------------------
mydata<-read.table("clipboard",header=T)
summary(mydata)
Climate <- as.factor(mydata$Climate)
Climate=as.factor(Climate)

mod.N2O.lm1 <- lm(N2O ~ WT + WT2 + WT2:Climate + WT:Climate, data=mydata)
summary(mod.N2O.lm1)

ggplot(mydata, aes( x = WT, y = N2O, color = as.factor(Climate))) + 
  geom_point( aes(pch = as.factor(Climate)), size=5, alpha=0.2,col = "black",bg = "black")+ 
  geom_smooth(method = 'lm', formula = y ~ poly(x, 2), se = T)+
  stat_cor(data=mydata, method = "pearson",aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),label.x.npc = "center",label.y.npc = "top") +  
  theme(axis.text.x = element_text(size = 12, color = "black")) +  
  theme(axis.text.y = element_text(size = 12, color = "black")) +
  #scale_y_continuous(breaks=seq(0,10,1),position = "left") +
  scale_x_continuous(breaks=seq(-100,100,50),position = "bottom") +
  theme_bw()
filen <- tempfile(pattern = "ggplot")
graph2ppt(x=NULL,file=filen)




summary(mod.NEE.lmer1)
summary(mod.NEE.lm1)
Anova(mod.NEE.lmer1)

par(mfrow=c(1,2))
hist(resid(mod.NEE.lmer1))  
#residuals should be normally distributed
ranef(mod.NEE.lmer1)
(ranef(mod.NEE.lmer1)[[1]][,1])
hist(ranef(mod.NEE.lmer1)[[1]][,1])

coef(mod.NEE.lmer1)
#CI
confint(mod.Rgpp.lmer1, 'Tk', level=0.95)
confint(mod.Rgpp.lmer1, level=0.95)

summary(mod.Rgpp.lmer1) ## summary of the model

ggplot(mydata, aes(WT,NEE),grouping(mydata$Climate))+
  geom_point(aes(pch=Climate))+
  #lm
  geom_smooth(method = 'lm', formula = 'y ~ x', 
              se = F, color = 'green')+
  #lm_I2
  geom_smooth(method = 'lm', formula = 'y ~ poly(x, 2)', 
              se = F, grouping(Climate = 1), color = 'red')+
  #lm_I3
  geom_smooth(method = 'lm', formula = 'y ~ splines::bs(x, 3)', 
              se = F, color = 'yellow')+
  geom_smooth(se = F)

ggplot(mydata, aes(x=WT,y=NEE,group = mydata$Cliamte))+
  geom_point(aes(pch=Climate),size = 5, alpha=0.1,col = "black",bg = "black")+
  geom_smooth(method = 'lm', formula = 'y ~ poly(x, 2)', 
              se = T, color = 'red')+
  geom_smooth(method = 'lm', formula = 'y ~ poly(x, 2)', 
              se = T, color = 'black')

