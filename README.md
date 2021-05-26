# Loan-default-prediction-and-credit-risk-analysis

## Overview

Lending Club is a peer-to-peer lending company founded in 2007 by John Donovan and Renaud Laplanche. The Lending Club platform allows borrowers to create unsecured personal loans between $1,000 and $40,000. Investors earn money by selecting loans to fund and Lending Club earns returns by charging borrowers an origination fee and investors a service fee. The Lending Club platform originated ~ $38.1 billion in loans and most recently originated ~ $2.2B in Q2'19.

#### What is LendingClub?

Lending Club (LC) offers an online platform for matching borrowers seeking loans and lenders looking to make an investment. With lower operational costs than traditional lenders (banks), such online lending platforms leverage technology, data, and analytics to bring quicker and more convenient financing for individual and small business borrowers from investors looking for attractive investment yields.

●	Loan Types: Personal (unsecured), business (unsecured), medical, auto refinancing

●	Loan Terms: 3 or 5 years for personal loans; 1 to 5 years for business loans; 2 to 7 years for medical loans; 2 years or longer for auto refinancing loans

●	Loan Size: $1,000 to $40,000 for personal loans; $5,000 to $300,000 for business loans; $499 to $50,000 for medical loans; $5,000 to $55,000 for auto refinancing loans

●	Rates: 6.16% to 35.89% APR for personal loans; 5.99% to 35.71% APR for business loans; 3.99% to 26.99% APR for medical loans; 2.24% to 24.99% APR for auto refinancing loans (all rates subject to change)

●	Origination Fee: 1% to 6%, depending on loan size, term, and borrower profile.

●	Service Fee: LendingClub charges an investor service fee of 1% of the number of borrower payments received by the payment due date or during applicable grace periods.

●	Minimum Investment: $1,000

#### How LendingClub makes money

As a marketplace, LendingClub generates revenue from: Origination Fee from borrowers, Service Fee from individual investors, Fees for investment funds and other managed accounts.

Its key partners are WebBank, who allow Lending Club to meet regulatory requirements needed to make its platform available to borrowers nationwide, LC Advisors who provide private investment funds service for accredited investors and qualified purchasers and borrower sources like mint.com, Credit Sesame and other consumer product companies.

Its key resources include Credit information, a team of remarkably high caliber professionals and directors and partnership and its revenue is through fee income from borrowers and investors.


#### How It Works for Investors

As a Lending Club investor, you can view Notes, or shares of unfunded loans that can be reserved for possible investment. You can reserve Notes in increments as low as $25. The $25-per-loan investment threshold makes it easier to create a diversified loan portfolio with a relatively modest investment. Investing can be either done by Manual Selection of loans or Automated Screening. In Manual Selection, the investor can manually browse through loan listings, filter by such criteria as loan purpose, loan grade, borrower credit score, loan size, time left, rate, and term. Whereas, In Automated Screening, an investor can use a tool that allows you to quickly invest in dozens of loans without approving each one. Once the lower limit on the loan grades are set, it uses the cash in investor’s account to make equal-sized investments in each new loan that’s above that limit.

#### Advantages of using Lending Club.

Using Lending Club provides users a set of advantages like lower interest rates for borrowers, business loans available up to $300,000, lower origination fees than some competitors, lower default rates, niche solutions for patients and car owners.

The proportion of charged-off and Fully Paid is:

![image](https://user-images.githubusercontent.com/47473472/119582976-432c1b80-bd8b-11eb-8d7d-2f44d7f2bae4.png)

The variation of default with loan grade is as follows:
The defaulter’s percentage will be low for higher grade as expected.


![image](https://user-images.githubusercontent.com/47473472/119582994-4aebc000-bd8b-11eb-8946-bffdc55c2a22.png)


It does vary with sub grades but the difference in proportions is within a sub grade is not drastic.


Variation of loan by grade is depicted below:

![image](https://user-images.githubusercontent.com/47473472/119583027-5808af00-bd8b-11eb-9c66-341ae3081027.png)

Variation of loan amount by each grade:

![image](https://user-images.githubusercontent.com/47473472/119583048-5f2fbd00-bd8b-11eb-8cb5-3e1adb64888b.png)

The highest sum of loan amount was given to grade B which is surprising because it is not the highest loan grade but otherwise the table makes sense as the amount decreased with decrease in grade.


The average interest rates are the highest for the lowest grade G and lowest is for Grade A and that is because the less interest rates are offered to faithful lenders.

![image](https://user-images.githubusercontent.com/47473472/119583069-6b1b7f00-bd8b-11eb-8570-0bd4fb2c10a1.png)

So, when we see number of loans by purpose we see the highest loan was taken for debt consolidation and next to for credit card

![image](https://user-images.githubusercontent.com/47473472/119583239-c483ae00-bd8b-11eb-89e0-984da20a8831.png)

We see although the number of loans was the highest for debt consolidation the average loan amount is highest for credit card.

Obviously, defaulters vary by purpose but the percentage of fully paid is always more that from defaulters, so we see highest defaulters in debt consolidation followed by credit card because those two categories had the highest number of loans.

![image](https://user-images.githubusercontent.com/47473472/119583280-dcf3c880-bd8b-11eb-8abb-b8f4adb39078.png)


The annual return is calculated by calculating the difference of total payment received by the investor and the amount he funded in proportion to funded amount and then it multiplied by the actual term.

Actual term is the difference from the issue date to the last payment date.

![image](https://user-images.githubusercontent.com/47473472/119583293-e4b36d00-bd8b-11eb-8f2a-988fc0f6d0c4.png)

Derived attributes

1.	First one isActual annual return.Now for which we have calculated the actual term, how much time does each person take to repay their loan with a maximum duration of 3 years. It is basically the difference between the issue date of loan and their last payment date. Then after calculating this, we try to figure out how much was the actual return per annum per person by incorporating the actual loan term we just calculated.

2.	Ratio of open account to closed accounts:It goes as the Grade goes down.

![image](https://user-images.githubusercontent.com/47473472/119583314-f6951000-bd8b-11eb-8194-209b4b217bc6.png)

3.	Ratio of revolving credit per revolving account:

Revolving balance is basically the balance that goes unpaid at the end of the billing cycle. So, we have calculated the ratio of the remaining balance per revolving account. We see an increasing trend as the grade goes down meaning high ratio for higher grade. One reason for this can be low number of revolving accounts for higher grades.

![image](https://user-images.githubusercontent.com/47473472/119583333-00b70e80-bd8c-11eb-9b3d-88985e970f16.png)

Yes, there are many rows with missing values in the data set. Missing values may be because of many reasons, some maybe due to human error or maybe just because they were literally not available.

There are certain columns with more than 60% of the data values missing. We are eliminating these columns because it does not make sense to impute them because the significance of the columns may be lost, and the output may be something totally unexpected.

There are different ways in which we impute data, like mean imputation, in which we substitute the missing data by the mean of the remaining variables. Mean imputation does not generally preserve the relationship among variables.

Another way is regression imputation in which we can impute by predicting the missing values from one or more non missing values. The disadvantage however is that it might still lead to biased parameter estimates.

So, in general there is no go to method for imputation. It all is subjective to the kind of values we are imputing.

So, there were 59 variables which had 60% of rows with NA values and hence it was viable to remove those from our data set.

In a particular case a variable named “months since last Delinquency” has missing values.NO what we can do here is check the average of this variable per grade and then impute the missing values in the respective grade instead of taking average of entire column because its values will be generally high for lower grades compared to higher grade.

##	Data Explorations

1.	Variation of number of loans per grade

![image](https://user-images.githubusercontent.com/47473472/119583429-3cea6f00-bd8c-11eb-88c6-2869729f94b8.png)

2. Variation of number of loans by purpose

![image](https://user-images.githubusercontent.com/47473472/119583447-4673d700-bd8c-11eb-9326-e434f1880eb1.png)

3. Variation of Interest rate by Grade:

![image](https://user-images.githubusercontent.com/47473472/119583461-4d024e80-bd8c-11eb-995b-f8f43ec92a1b.png)

Leakage Variables and Variables which are not needed:

![image](https://user-images.githubusercontent.com/47473472/119583927-41635780-bd8d-11eb-9cdc-efad86aea63e.png)

Variables with missing values:

![image](https://user-images.githubusercontent.com/47473472/119583989-622bad00-bd8d-11eb-89de-5fba60b0d512.png)
![image](https://user-images.githubusercontent.com/47473472/119584033-766faa00-bd8d-11eb-81c3-5662df11213c.png)

Variables which have more than 60% missing values:

![image](https://user-images.githubusercontent.com/47473472/119584096-9bfcb380-bd8d-11eb-9383-6b29709da4a9.png)

4.	Decision Tree without pruning

![image](https://user-images.githubusercontent.com/47473472/119584127-a61eb200-bd8d-11eb-93b1-b820cb2e2531.png)

Pruned decision Tree

![image](https://user-images.githubusercontent.com/47473472/119584151-ae76ed00-bd8d-11eb-9e86-8f9b40e2a8cf.png)

Performance evaluation for unpruned tree

![image](https://user-images.githubusercontent.com/47473472/119584162-b59dfb00-bd8d-11eb-9518-e3cfd9738c46.png)


Performance evaluation for pruned tree

![image](https://user-images.githubusercontent.com/47473472/119584178-be8ecc80-bd8d-11eb-8f62-bf693b4d746f.png)


