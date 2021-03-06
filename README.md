# BankMarketing_Multivariate_Analysis_Project
PROBLEM STATEMENT : Direct marketing campaign data of a Portuguese banking institution is being analysed to predict if a client will subscribe.

DATA DICTIONARY :

| TABLE           | COLUMN         | DATA TYPE   | REQUIRED | SENSITIVE | VALUES           | DESCRIPTION                                                                                |
|-----------------|----------------|-------------|----------|-----------|------------------|--------------------------------------------------------------------------------------------|
| Bank            | Age            | Numeric     |          |           |                  |                                                                                            |
| Bank            | Job            | Categorical |          |           | Admin            | Type of job                                                                                |
|                 |                |             |          |           | Blue-Collar      |                                                                                            |
|                 |                |             |          |           | Entrepreneur     |                                                                                            |
|                 |                |             |          |           | Housemaid        |                                                                                            |
|                 |                |             |          |           | Management       |                                                                                            |
|                 |                |             |          |           | Retired          |                                                                                            |
|                 |                |             |          |           | Self-Employed    |                                                                                            |
|                 |                |             |          |           | Services         |                                                                                            |
|                 |                |             |          |           | Student          |                                                                                            |
|                 |                |             |          |           | Technician       |                                                                                            |
|                 |                |             |          |           | Unemployed       |                                                                                            |
|                 |                |             |          |           | Unknown          |                                                                                            |
| Bank            | Marital        | Categorical |          |           | Divorced         | Divorced also covers widowed                                                               |
|                 |                |             |          |           | Married          |                                                                                            |
|                 |                |             |          |           | Single           |                                                                                            |
|                 |                |             |          |           | Unknown          |                                                                                            |
| Bank            | Education      | Categorical |          |           | Primary          |                                                                                            |
|                 |                |             |          |           | Secondary        |                                                                                            |
|                 |                |             |          |           | Tertiary         |                                                                                            |
| Bank            | Default        | Categorical |          |           | No               | Has credit in default?                                                                     |
|                 |                |             |          |           | Yes              |                                                                                            |
|                 |                |             |          |           | Unknown          |                                                                                            |
| Bank            | Balance        |             |          |           |                  |                                                                                            |
| Bank            | Housing        | Categorical |          |           | No               | Has housing loan?                                                                          |
|                 |                |             |          |           | Yes              |                                                                                            |
|                 |                |             |          |           | Unknown          |                                                                                            |
| Bank            | Loan           | Categorical |          |           | No               | Has personal loan?                                                                         |
|                 |                |             |          |           | Yes              |                                                                                            |
|                 |                |             |          |           | Unknown          |                                                                                            |
| Bank            | Contact        | Categorical |          |           | Cellular         | Contact Communication Type                                                                 |
|                 |                |             |          |           | Telephone        |                                                                                            |
| Bank            | Day            | Categorical |          |           | Mon              | Last contact day of the week                                                               |
|                 |                |             |          |           | Tue              |                                                                                            |
|                 |                |             |          |           | Wed              |                                                                                            |
|                 |                |             |          |           | Thu              |                                                                                            |
|                 |                |             |          |           | Fri              |                                                                                            |
| Bank            | Month          | Categorical |          |           | Jan              | Last contact month of year                                                                 |
|                 |                |             |          |           | Feb              |                                                                                            |
|                 |                |             |          |           | Mar              |                                                                                            |
|                 |                |             |          |           | Apr              |                                                                                            |
|                 |                |             |          |           | May              |                                                                                            |
|                 |                |             |          |           | Jun              |                                                                                            |
|                 |                |             |          |           | Jul              |                                                                                            |
|                 |                |             |          |           | Aug              |                                                                                            |
|                 |                |             |          |           | Sep              |                                                                                            |
|                 |                |             |          |           | Oct              |                                                                                            |
|                 |                |             |          |           | Nov              |                                                                                            |
|                 |                |             |          |           | Dec              |                                                                                            |
| Bank            | Duration       | Numeric     |          |           |                  | Last contact duration in seconds                                                           |
| Bank            | Campaign       | Numeric     |          |           |                  | Number of contacts performed during this campaign and for this client                      |
| Bank            | Pdays          | Numeric     |          |           |                  | Number of days that passed by after the client was last contacted from a previous campaign |
|                 |                |             |          |           |                  | * 999 means client was not previously contacted                                            |
| Bank            | Previous       | Numeric     |          |           |                  | Number of contacts performed before this campaign and for this client                      |
| Bank            | Poutcome       | Categorical |          |           | Failure          | Outcome of the previous marketing campaign                                                 |
|                 |                |             |          |           | Nonexistent      |                                                                                            |
|                 |                |             |          |           | Success          |                                                                                            |
| Bank            | y              | Binary      |          |           | Yes              | Has the client subscribed a term deposit                                                   |
|                 |                |             |          |           | No               |                                                                                            |
| Bank Additional | Emp_var_rate   |             |          |           |                  | Quarterly indicator pf employment variation rate                                           |
| Bank Additional | Cons_price_idx |             |          |           |                  | Consumer price index - monthly indicator                                                   |
| Bank Additional | Cons_conf_idx  |             |          |           |                  | Consumer confidence index - monthly indicator                                              |
| Bank Additional | euribor3m      |             |          |           |                  | Euribor 3 month rate - daily indicator                                                     |
| Bank Additional | Nr_employed    |             |          |           |                  | Number of employees - quarterly indicator                                                  |


KEY PERFORMANCE INDICATORS:

| KEY RESULT AREA   | KEY PERFORMANCE INDICATORS | DESCRIPTION                                                                                                                |
|-------------------|----------------------------|----------------------------------------------------------------------------------------------------------------------------|
| Lead Sources      | Job                        | Determines capability of the lead to predict future revenue through the specific lead                                      |
| Origination Value | Loan                       | Total Revenue earned for each loan over a given time                                                                       |
| Lead              | Campaign                   | Number of customers acquired by marketing influence                                                                        |
| Lead Conversion   | Poutcome                   | Finding the right customers, keeping them engaged and converting them into leads of the institution                        |
| Revenue           | Cons_price_idx             | Measure of the average change over time in prices paid by urban consumers for market basket of consumer goods and services |
| Overall Economy   | Cons_conf_idx              | Consumer Confidence Index is a good indicator od developments in the future reflecting current business conditions         |
