#Loading libraries

library(tidyverse)
library(lubridate)
library(dplyr)

#Loading data

lcdf <- read_csv("lcData4m.csv")

lcdf$loan_amnt<-as.numeric(lcdf$loan_amnt)
lcdf$term<-as.numeric(gsub(" months" , "", lcdf$term))
lcdf$int_rate<- as.numeric(gsub("%","", lcdf$int_rate))
lcdf$revol_util<- as.numeric(gsub("%", "", lcdf$revol_util))
lcdf$grade <- as.factor(lcdf$grade)
lcdf$sub_grade <- as.factor(lcdf$sub_grade)
lcdf$home_ownership <- as.factor(lcdf$home_ownership)
lcdf$purpose <- as.factor(lcdf$purpose)
lcdf$addr_state <- as.factor(lcdf$addr_state)
lcdf$application_type <- as.factor(lcdf$application_type)
lcdf$loan_status<- as.factor(lcdf$loan_status)

#Data Exploration

lcdf %>% group_by(loan_status, grade) %>% tally()
table(lcdf$grade, lcdf$loan_status) 

prop.table(table(lcdf$loan_status, lcdf$grade),2)
prop.table(table(lcdf$loan_status, lcdf$sub_grade),2)


#How does number of loans, loan amount, interest rate vary by grade

lcdf %>% group_by(grade) %>% summarise(mean(int_rate))

plot(lcdf$loan_status)


lcdf$annRet <- ((lcdf$total_pymnt -lcdf$funded_amnt)/lcdf$funded_amnt)*(12/36)*100
lcdf %>% group_by(grade) %>% tally()
lcdf %>% group_by(grade) %>% summarise(mean(loan_amnt))

lcdf %>% group_by(grade) %>% summarise(average_annual_retun= mean(annRet),average_int_rate=mean(int_rate))



#Or plot these..
ggplot(lcdf, aes( x = int_rate)) + geom_histogram()
ggplot(lcdf, aes( x = loan_amnt)) + geom_histogram(aes(fill=grade))
ggplot(lcdf, aes( x = loan_amnt)) + geom_histogram() + facet_wrap(~loan_status)


#Summarizing data by grade and purpose:
lcdf %>% group_by(grade) %>% summarise(nLoans=n(), defaults=sum(loan_status=="Charged Off"), avgInterest= mean(int_rate), stdInterest=sd(int_rate), avgLoanAMt=mean(loan_amnt), avgPmnt=mean(total_pymnt), avgRet=mean(annRet), stdRet=sd(annRet), minRet=min(annRet), maxRet=max(annRet))


lcdf %>%
  group_by(purpose) %>%
  summarize(freq = n()) %>%
  ggplot(aes(reorder(purpose, freq), y = freq, fill = freq)) +   
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Purpose") +
  ylab("Frequency")+coord_flip() 

lcdf %>%
  group_by(grade) %>%
  summarize(freq = n()) %>%
  ggplot(aes(reorder(grade, freq), y = freq, fill = freq)) +   
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Grade") +
  ylab("Frequency")+coord_flip() 


#Data Manipluation:

lcdf$last_pymnt_d<-paste(lcdf$last_pymnt_d, "-01", sep = "")
lcdf$last_pymnt_d<-parse_date_time(lcdf$last_pymnt_d,  "ymd")
set.seed(1234)
lcdf$issue_d<-parse_date_time(lcdf$issue_d,  "ymd")

lcdf$actualterm <- lcdf$issue_d %--% lcdf$last_pymnt_d
#View(lcdf$actualterm)

lcdf %>%  select(-c(lcdf$actualterm))

lcdf$actualTerm <- ifelse(lcdf$loan_status=="Fully Paid", as.duration(lcdf$issue_d  %--% lcdf$last_pymnt_d)/dyears(1), 3)
class(lcdf$last_pymnt_d)
#view(lcdf$last_pymnt_d)
#View(lcdf)
str(lcdf$last_pymnt_d)

#Then, considering this actual term, we can calculate the actual annual return 
lcdf$actualReturn <- ifelse(lcdf$actualTerm>=1,((lcdf$total_pymnt -lcdf$funded_amnt)/lcdf$funded_amnt)*(1/lcdf$actualTerm)*100, ((lcdf$total_pymnt -lcdf$funded_amnt)/lcdf$funded_amnt)*100)


#For cost-based performance, we want to see the average interest rate, and the average of proportion of loan amount paid back, grouped by loan_status
lcdf%>% group_by(loan_status) %>% summarise(  intRate=mean(int_rate), totRet=mean((total_pymnt-funded_amnt)/funded_amnt)  )
# Notice that the totRet on Charged Off loans as -0.366, so, for every dollar invested, there is a loss of .366 cents.   For #Fully Paid loans, the totRet seems less than what may be  expected from intRate -- how do you explain this? This is happening #because of defaults


lcdf %>% group_by(loan_status,grade) %>% select(loan_amnt, funded_amnt, total_pymnt, 
                                                int_rate, actualTerm, actualReturn )

lcdf %>% group_by(grade) %>% summarise(nLoans=n(), 
                                       defaults=sum(loan_status=="Charged Off"), 
                                       defaultRate=defaults/nLoans)


lcdf= lcdf %>% mutate_if(is.character, as.factor)


#Treating missing NA values

#missing value proportions in each column
colMeans(is.na(lcdf))
# or, get only those columns where there are missing values
colMeans(is.na(lcdf))[colMeans(is.na(lcdf))>0]

#remove variables which have more than, for example, 60% missing values
nm<-names(lcdf)[colMeans(is.na(lcdf))>0.6]
lcdf <- lcdf %>% select(-nm)

#Drop some variables for potential leakage, others
#Drop some other columns which are not useful and those which will cause 'leakage'

lcdf <- lcdf %>% select(-c(fico_range_low, fico_range_high, last_fico_range_low, 
                           funded_amnt_inv, term, emp_title, pymnt_plan,hardship_flag, title, zip_code, 
                           title, out_prncp, out_prncp_inv,total_pymnt, total_pymnt_inv, total_rec_prncp,
                           total_rec_int,total_rec_late_fee, recoveries, collection_recovery_fee, 
                           last_pymnt_d, last_pymnt_amnt, last_credit_pull_d, policy_code))

lcdf<-lcdf %>% select(-c(installment,emp_length,verification_status,issue_d))

lcdf<-lcdf %>% select(-c(num_tl_30dpd,acc_now_delinq,chargeoff_within_12_mths,
                         num_tl_90g_dpd_24m,delinq_amnt,tax_liens,pub_rec,delinq_2yrs,
                         initial_list_status,tot_coll_amt,num_accts_ever_120_pd,mths_since_last_delinq,
                         mths_since_recent_inq,percent_bc_gt_75,debt_settlement_flag,earliest_cr_line,
                         pub_rec_bankruptcies, application_type,last_fico_range_high,
                         inq_last_6mths,collections_12_mths_ex_med,mo_sin_old_il_acct))



################################################   SPLITTING   ##############################################################

# SPILTTING THE DATA

#split the data into trn, tst subsets
#View(lcdf)
nr<-nrow(lcdf)
trnIndex<- sample(1:nr, size = round(0.7*nr), replace=FALSE)
lcdfTrn <- lcdf[trnIndex, ]
lcdfTst <- lcdf[-trnIndex, ]

nm<-names(lcdfTrn)[colMeans(is.na(lcdfTrn))>0]
#View(nm)
lcdfTrn<- lcdfTrn %>% select(-nm)
lcdfTst<- lcdfTst %>% select(-nm)

#View(lcdf)

##########################################  Decision Trees using rpart  ########################################################

library(rpart)
#It can be useful to convert the target variable, loan_status to  a factor variable
lcdf$loan_status <- factor(lcdf$loan_status, levels=c("Fully Paid", "Charged Off"))

lcDT1 <- rpart(loan_status ~., data=lcdfTrn, method="class")

#lcDT1 <- rpart(loan_status ~., data=lcdfTrn, method="class", parms = list(split = "information"), control = rpart.control(minsplit = 30))

#lcDT1 <- rpart(loan_status ~., data=lcdfTrn, method="class", parms = list(split = "information"), control = rpart.control(cp=0.001, minsplit = 2000))

print(lcDT1)
plot(lcDT1)
summary(lcDT1)


#rpart.plot
library(rpart.plot)
rpart.plot::prp(lcDT1, type=2, extra=1)

#Do we want to prune the tree -- check for performance with dfferent cp levels
printcp(lcDT1)

plotcp(lcDT1)
lcDT1p<- prune.rpart(lcDT1, cp=0.01)
#lcDT1p<- prune.rpart(lcDT1, cp=0.0003)
plot(lcDT1p)
print(lcDT1p)


##########################################  Performance evaluation  ########################################################

predTrn=predict(lcDT1,lcdfTrn, type='class')
t <- table(pred = predTrn, true=lcdfTrn$loan_status)
mean(predTrn == lcdfTrn$loan_status)
predTst = predict(lcDT1,lcdfTst, type='class')
table(pred = predict(lcDT1,lcdfTst, type='class'), true=lcdfTst$loan_status)
mean(predict(lcDT1,lcdfTst, type='class') == lcdfTst$loan_status)


#accuracy metric
sum(diag(t))/sum(t)
set.seed(1234)


#With a different classsification threshold
CTHRESH=0.3
predProbTrn=predict(lcDT1,lcdfTrn, type='prob')
predTrnCT = ifelse(predProbTrn[, 'Charged Off'] > CTHRESH, 'Charged Off', 'Fully Paid')
table(predTrnCT , true=lcdfTrn$loan_status)
# Or, to set the predTrnCT values as factors, and then get the confusion matrix
table(predictions=factor(predTrnCT, levels=c("Fully Paid", "Charged Off")), actuals=lcdfTrn$loan_status)


#Or you can use the confusionMatrix fuction from the caret package
library(caret)
confusionMatrix(predTrn, lcdfTrn$loan_status)
#if you get an error saying that the 'e1071' package is required, 
# you should install and load that too
#Notice that the output says 
#   'Positive' class: Fully Paid
#So,the confusionMatrix based performance measures are based 
#  on the "Fully Paid" class as the class of interest.
# If you want to get performance measure for "Charged Off", use 
#    the positive- paremeter


confusionMatrix(predTrn, lcdfTrn$loan_status, positive="Fully Paid")


#ROC plot
library(ROCR)

score=predict(lcDT1,lcdfTst, type="prob")[,"Charged Off"]
pred=prediction(score, lcdfTst$loan_status, label.ordering = c("Fully Paid", "Charged Off"))
#label.ordering here specifies the 'negative', 'positive' class labels   

#ROC curve
aucPerf <-performance(pred, "tpr", "fpr")
plot(aucPerf) + abline(a=0, b= 1)

#AUC value
aucPerf=performance(pred, "auc")
aucPerf@y.values


#Lift curve
liftPerf <-performance(pred, "lift", "rpp")
plot(liftPerf)
 

#######################################  Performance with profit.loss  #####################################################

#Incorporating profits & costs
PROFITVAL <- 10 #profit (on $100) from accurately identifying Fully_paid loans
COSTVAL <- -50  # loss (on $100) from incorrectly predicting a Charged_Off loan as Full_paid
scoreTst <- predict(lcDT1,lcdfTst, type="prob")[,"Fully Paid"]   
#Note- we want to identify those loans wth high prob for being FullyPaid
prPerf <- data.frame(scoreTst)
prPerf <- cbind(prPerf, status=lcdfTst$loan_status)
prPerf <- prPerf[order(-scoreTst) ,]  #sort in desc order of  prob(fully_paid)
prPerf$profit <- ifelse(prPerf$status == 'Fully Paid', PROFITVAL, COSTVAL)
prPerf$cumProfit <- cumsum(prPerf$profit)

#to compare against the default approach of investing in CD with 2% int (i.e. $6 profit out of $100 in 3 years)
prPerf$cdRet <- 6
prPerf$cumCDRet <- cumsum(prPerf$cdRet)
plot(prPerf$cumProfit)
lines(prPerf$cumCDRet, col='green')

#Or, we really do not need to have the cdRet and cumCDRet columns, since cdRet is $6 for every row
plot(prLifts$cumProfit)
abline(a=0, b=6)


summary(lcDT1)
